use Bankdb;

CREATE PROCEDURE interest_payment (
    )
    proc_label:BEGIN
        DECLARE p_interest VARCHAR(10);
        DECLARE p_accountNumber NUMERIC(16,0);
        DECLARE p_amount int;
        DECLARE done INT DEFAULT FALSE;
        DECLARE account_cursor CURSOR FOR
            SELECT accountNumber FROM account;
        DECLARE amount_cursor CURSOR FOR
            SELECT amount FROM latest_balances;

        DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

        OPEN account_cursor;
        OPEN amount_cursor;

        read_loop: LOOP
            FETCH account_cursor INTO p_accountNumber;
            FETCH amount_cursor INTO p_amount;
            IF done THEN
                LEAVE read_loop;
            END IF;

            SELECT interest_rate INTO p_interest
            FROM account
            WHERE accountNumber = p_accountNumber;

#             select concat(p_interest, ' log') as log;

            IF p_interest is not null THEN
                INSERT INTO transactions(type, transaction_time, from_account, to_account, amount)
                VALUES ('interest', current_timestamp(), NULL, p_accountNumber, p_interest*p_amount);
            END IF;
        END LOOP;

        CLOSE account_cursor;
        CLOSE amount_cursor;

    end;

# select * from transactions;

# delete from transactions where type = 'interest';

# call interest_payment();

# update latest_balances set amount = 2000 where accountNumber =2626129198471204;