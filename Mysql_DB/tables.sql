# create database BankDB;
use BankDB;

create table account(
    username varchar(10) ,
    accountNumber numeric(16,0)  unique ,
    passwords CHAR(64) NOT NULL,
    firstname varchar(10) ,
    lastname varchar(10),
    national_id numeric(10,0),
    date_of_birth date,
    type varchar(10) not null check ( type IN ('client', 'employee') ),
    interest_rate DECIMAL(10, 2) NOT NULL CHECK (interest_rate >= 0 AND (type = 'employee' AND interest_rate = 0)),
    primary key (username)
);

# insert into account values ('mahsmith','8784743296713331',  'password123', 'John', 'Smith', '1234567890', '1970-01-01', 'client', 0.1);

create table login_log(
    username varchar(10),
    login_time timestamp,
    primary key (username, login_time),
    foreign key (username) references account(username)
);

create table transactions(
    type varchar(10) not null check ( type IN ('deposit', 'withdraw', 'transfer', 'interest') ),
    transaction_time timestamp,
    from_account numeric(16,0) default null check ( (type = 'deposit' or type = 'interest') and from_account is null),
    to_account numeric(16,0) default null check ( type = 'withdraw' and to_account is null),
    amount int,
    foreign key (from_account) references account(accountNumber),
    foreign key (to_account) references account(accountNumber)
);

create table latest_balances(
    accountNumber numeric(16,0) primary key ,
    amount int,
    foreign key (accountNumber) references account(accountNumber)
);

create table snapshot_log(
    snapshot_id int AUTO_INCREMENT PRIMARY KEY,
    snapshot_timestamp timestamp
);