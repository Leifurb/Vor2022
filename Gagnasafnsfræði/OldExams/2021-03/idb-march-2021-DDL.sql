drop table if exists Grades;
drop table if exists Takes;
drop table if exists Examiner;
drop table if exists Course;
drop table if exists Term;
drop table if exists Student;

create table Term (
	TID integer primary key,
	_desc varchar not null
);

create table Student (
	SID integer primary key,
	startsin integer not null references Term(TID)
);

create table Course (
	CID integer primary key
);

create table Examiner (
	EID integer primary key
);

create table Takes (
	-- using option 2
	TakesID integer primary key,
	SID integer not null references Student(SID),
	CID integer not null references Course(CID),
	TID integer not null references Term(TID),
	room varchar not null,
	unique (TID, CID) -- since Student is 1..1
);

create table Grades (
	TakesID integer references Takes(TakesID),
	EID integer references Examiner(EID),
	grade integer not null,
	primary key (TakesID, EID)
);
