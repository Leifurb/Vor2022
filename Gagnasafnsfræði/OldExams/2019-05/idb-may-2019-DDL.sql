create table Team (
    TID integer primary key,
    Name varchar(50) not null 
);

create table GuestTeam (
    TID integer primary key references Team
);

create table RegisteredTeam (
    TID integer primary key references Team,
    RegID integer not null
);

create table XMatch (
    XMID integer primary key,
    XTime timestamp not null,
    Home integer not null references Team(TID),
    Away integer not null references Team(TID)
);

create table XSet (
    XMID integer references XMatch(XMID),
    XNumber integer,
    primary key (XMID, XNumber)
);
