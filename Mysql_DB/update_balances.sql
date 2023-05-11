use Bankdb;

CREATE PROCEDURE update_balances (
    )
    proc_label:BEGIN

        DECLARE p_type VARCHAR(10);
        DECLARE p_time timestamp;
        DECLARE p_from NUMERIC(16,0);
        DECLARE p_to NUMERIC(16,0);
        DECLARE p_amount int;
        DECLARE done INT DEFAULT FALSE;
        DECLARE transaction_cursor CURSOR FOR
            SELECT transaction_time,from_account,to_account,type,amount FROM transactions;
#         DECLARE amount_cursor CURSOR FOR
#             SELECT type FROM transactions;

        DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

#         OPEN account_cursor;
        OPEN transaction_cursor;

        read_loop: LOOP
#             FETCH account_cursor INTO p_accountNumber;
            FETCH transaction_cursor INTO p_time,p_from,p_to,p_type,p_amount;
            IF done THEN
                LEAVE read_loop;
            END IF;

            SELECT max(snapshot_timestamp) INTO @max_time FROM snapshot_log;

            IF p_time > @max_time THEN
                if p_type = 'deposit' then
                    update latest_balances set amount = amount + p_amount where accountNumber = p_to;
                end if;
                if p_type = 'withdraw' then
                    update latest_balances set amount = amount - p_amount where accountNumber = p_from;
                end if;
                if p_type = 'transfer' then
                    START TRANSACTION;

                    select type into @t from account where accountNumber = p_from;

                    update latest_balances set amount = amount - p_amount where accountNumber = p_from;
                    select amount into @a from latest_balances where accountNumber = p_from;
                    if @a < 0 and @t != 'employee' then
                        ROLLBACK;
                        ITERATE read_loop;
                    end if;
                    update latest_balances set amount = amount + p_amount where accountNumber = p_to;

                    COMMIT;
                    end if;
                if p_type = 'interest' then
                    update latest_balances set amount = amount - p_amount where accountNumber = p_to;
                end if;
            END IF;
        END LOOP;

        CLOSE transaction_cursor;
        insert into snapshot_log(snapshot_timestamp) values (current_timestamp());

    end;

# select * from latest_balances;
# update latest_balances set amount = 0;

call update_balances();

CREATE PROCEDURE update_balances_specific (
        IN accNum numeric(16,0)
    )
    proc_label:BEGIN

        DECLARE p_type VARCHAR(10);
        DECLARE p_time timestamp;
        DECLARE p_from NUMERIC(16,0);
        DECLARE p_to NUMERIC(16,0);
        DECLARE p_amount int;
        DECLARE done INT DEFAULT FALSE;
        DECLARE transaction_cursor CURSOR FOR
            SELECT transaction_time,from_account,to_account,type,amount FROM transactions;
#         DECLARE amount_cursor CURSOR FOR
#             SELECT type FROM transactions;

        DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

#         OPEN account_cursor;
        OPEN transaction_cursor;

        read_loop: LOOP
#             FETCH account_cursor INTO p_accountNumber;
            FETCH transaction_cursor INTO p_time,p_from,p_to,p_type,p_amount;
            IF done THEN
                LEAVE read_loop;
            END IF;

            SELECT max(snapshot_timestamp) INTO @max_time FROM snapshot_log;

            IF p_time > @max_time and (accNum = p_to or accNum = p_from) THEN
                if p_type = 'deposit' then
                    update latest_balances set amount = amount + p_amount where accountNumber = p_to;
                end if;
                if p_type = 'withdraw' then
                    update latest_balances set amount = amount - p_amount where accountNumber = p_from;
                end if;
                if p_type = 'transfer' then
                    START TRANSACTION;

                    select type into @t from account where accountNumber = p_from;

                    update latest_balances set amount = amount - p_amount where accountNumber = p_from;
                    select amount into @a from latest_balances where accountNumber = p_from;
                    if @a < 0 and @t != 'employee' then
                        ROLLBACK;
                        ITERATE read_loop;
                    end if;
                    update latest_balances set amount = amount + p_amount where accountNumber = p_to;

                    COMMIT;
                    end if;
                if p_type = 'interest' then
                    update latest_balances set amount = amount - p_amount where accountNumber = p_to;
                end if;
            END IF;
        END LOOP;

        CLOSE transaction_cursor;
        insert into snapshot_log(snapshot_timestamp) values (current_timestamp());

    end;

# call update_balances_specific(1797825695758523);
