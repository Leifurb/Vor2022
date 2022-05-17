drop table if exists SellsTo;
drop table if exists Adult;
drop table if exists Child;
drop table if exists Company;
drop table if exists Person;
drop table if exists Taxpayer;

create table Taxpayer (
	TID integer primary key
);

create table Person (
	PID integer primary key
);

create table Adult (
	PID integer primary key references Person(PID),
	role varchar not null,
	TID integer not null references Taxpayer(TID)
);

create table Child (
	PID integer primary key references Person(PID),
	age int not null
);

create table Company (
	CID integer primary key,
	TID integer not null references Taxpayer(TID)
);

create table SellsTo (
	CID integer references Company(CID),
	PID integer references Child(PID),
	day date,
	price int not null,
	paysForID int not null references Adult(PID),
	primary key (CID, PID, day)
);
