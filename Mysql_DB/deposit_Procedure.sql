use Bankdb;

CREATE PROCEDURE deposit (
      IN d_amount int
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
            values ('deposit',current_timestamp(),null , p_accountNumber,d_amount);

    end;

# call deposit(123000);