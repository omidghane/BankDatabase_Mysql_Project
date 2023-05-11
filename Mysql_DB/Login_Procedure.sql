use bankdb;

CREATE PROCEDURE login_user (
      IN p_username VARCHAR(10),
      IN p_password CHAR(64),
      out res varchar(10)
    )
    proc_label:BEGIN
    DECLARE pass CHAR(64);

    SET @salt = 'salt';
    SET @hashed_password = SHA2(CONCAT(p_password, @salt), 256);

    SELECT passwords into pass
    FROM account
    WHERE username = P_username and passwords = @hashed_password;

    IF pass IS NOT NULL THEN
        insert into login_log values (p_username, current_timestamp());
        set res = 'found';
        leave proc_label;
    end if;
    set res = 'notFound';

END;
#
# call login_user('johnsmith','password123');
# call login_user('omidgh','password123');
#
#
# select current_timestamp();