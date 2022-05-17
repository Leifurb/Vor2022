create table Politicians (
    PID integer primary key,
);

create table Police (
    LID integer primary key
    PID integer not null references Politician(PID),
    HowMuch varchar(500) not null
);

create table Officials (
    OID integer primary key
);

create table Civilians (
    CID integer primary key
);

create table Bribes (
    PID integer references Politicians(PID),
    OID integer references Officials(OID),
    _When timestamp,
    Why varchar(500) not null,
    primary key (PID, OID, _When)
);

create table Arrests (
    LID integer references Police(LID),
    CID integer references Civilians(CID),
    primary key (LID, CID)
);

create table Mistreats (
    CID integer references Civilians(CID),
    OID not null integer references Officials(OID),
    How varchar(500) not null,
    primary key (CID)
);


