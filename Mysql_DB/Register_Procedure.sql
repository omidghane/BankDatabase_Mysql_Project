use BankDB;

CREATE PROCEDURE register_user (
      IN p_username VARCHAR(10),
      IN p_name VARCHAR(10),
      IN p_lastname VARCHAR(10),
      IN p_password CHAR(64),
      IN p_national_id numeric(10,0),
      IN date_of_births date,
      IN p_account_type VARCHAR(10),
      IN p_interest_rate DECIMAL(10,2),
      OUT res varchar(10)
    )
    proc_label:BEGIN
    DECLARE accountNumbers numeric(16,0);

    -- If the age is less than 13 then return
    SET @age = TIMESTAMPDIFF(YEAR, date_of_births, CURDATE());
    IF @age < 13 THEN
        set res = 'under13';
        LEAVE proc_label;
    END IF;

    -- create a random account number for user
    SET accountNumbers = FLOOR(RAND() * 9000000000000000 + 1000000000000000);
    WHILE EXISTS(SELECT * FROM account WHERE accountNumber = accountNumbers)
    DO
      SET accountNumbers = FLOOR(RAND() * 9000000000000000 + 1000000000000000);
    END WHILE;

  -- hash the input password
    SET @salt = 'salt';
    SET @hashed_password = SHA2(CONCAT(p_password, @salt), 256);

  -- Insert user information into the account table
    INSERT INTO account (username,accountNumber, firstname, lastname, passwords,national_id,date_of_birth, type, interest_rate)
    VALUES (p_username,accountNumbers, p_name, p_lastname, @hashed_password, p_national_id, date_of_births, p_account_type, p_interest_rate);
  -- insert amount 0 into latest_balances
    INSERT INTO latest_balances(accountNumber, amount) VALUES (accountNumbers, 0);
    
    -- Display the user's information
    SELECT *
    FROM account;

    set res = 'allowed';

END;

# delete from latest_balances;
# DELETE FROM account;
#
# CALL register_user('johnsmith', 'John', 'Smith', 'password123', '1234567890', '2020-01-01', 'client', 0.5);
# CALL register_user('mahsmith', 'John', 'Smith', 'password123', '1234567890', '1970-01-01', 'client', 0.1);
#
# CALL register_user('omidgh', 'omid', 'Smith', 'password123', '1234567890', '1980-01-01', 'client', 0.5);
#
# CALL register_user('omidkh', 'ali', 'Smith', 'password123', '1234567890', '1980-01-01', 'employee', 0);
# delete from account where username = 'mamali';
# delete from latest_balances where accountNumber =7866350218529208;
# delete from login_log where username = 'mamali';

