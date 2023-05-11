use Bankdb;

CREATE PROCEDURE withdraw (
      IN w_amount int
    )
    proc_label:BEGIN
        declare p_username varchar(10);
        declare p_accountNumber numeric(16,0);

        select username into p_username
        from login_log
        where login_time = (SELECT MAX(login_time) FROM login_log);

        select accountNumber into p_accountNumber
        from account
        where username = p_username;

        insert into transactions(type,transaction_time,from_account, to_account,amount)
            values ('withdraw',current_timestamp(),p_accountNumber , null,w_amount);

    end;

# call withdraw(35000);
