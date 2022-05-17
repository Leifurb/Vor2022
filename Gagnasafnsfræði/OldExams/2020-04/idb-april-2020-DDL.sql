-- drop statements (optional)

drop table if exists Cure;
drop table if exists Patient;
drop table if exists Doctor;
drop table if exists AuditingCompany;
drop table if exists AccountHolder;

-- entity tables

create table Patient (
	PID serial primary key
);

create table AccountHolder (
	AHID serial primary key
);

create table Doctor (
	D ID serial primary key,
	AHID integer not null references AccountHolder (AHID)
);

create table AuditingCompany (
	AID serial primary key,
	AHID integer not null references AccountHolder (AHID)
);

-- relationship table (only 1 due to 1..1 constraints)

create table Cure (
	PID integer references Patient (PID),
	DID integer references Doctor (DID),
	-- This is the 1..1 Audit relationship
	AID integer not null references AuditingCompany (AID),
	-- This is the 1..1 Review relationship
	RID integer not null references Doctor (DID),
	primary key (PID, DID)
);


