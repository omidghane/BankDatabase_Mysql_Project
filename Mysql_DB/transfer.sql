use Bankdb;

CREATE PROCEDURE transfer (
      IN t_amount int,
      IN destination_acc numeric(16,0)
    )
    proc_label:BEGIN
        declare p_username varchar(10);
        declare p_accountNumber numeric(16,0);
        declare source_acc numeric(16,0);

        select username into p_username
        from login_log
        where login_time = (SELECT MAX(login_time) FROM login_log);
        select accountNumber into source_acc from account where username = p_username;

        select accountNumber into p_accountNumber
        from account
        where accountNumber = destination_acc;

        if p_accountNumber is not null then
            insert into transactions(type,transaction_time,from_account, to_account,amount)
            values ('transfer',current_timestamp(),source_acc , destination_acc,t_amount);
        end if;

    end;

# select *
# from transactions;
#
# call transfer(5000000,8784743296713330);
# call transfer(20000,2626129198471204);
# delete from transactions where type = 'transfer';
# select * from transactions;
