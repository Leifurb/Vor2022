drop table if exists Audit;
drop table if exists Client;
drop table if exists Shrink;
drop table if exists Office;
drop table if exists Manager;

create table Manager (
	MID integer primary key
);

create table Office (
	OID integer primary key,
	MID integer not null references Manager
);

create table Shrink (
	SID integer primary key,
	OID integer not null references Office,
	since date not null
);

create table Client (
	CID integer primary key,
	SID integer not null references Shrink
);

create table Audit (
	CID integer references Client,
	MID integer references Manager,
	primary key (CID, MID)
);
