use Bankdb;

    create procedure check_balances (
            out res int
        )
    begin

        select username into @uname from login_log where login_time = (select max(login_time) from login_log);
        select accountNumber into @accNum from account where username = @uname;
        SELECT amount into res FROM latest_balances WHERE accountNumber = @accNum;

    end;

# call check_balances();