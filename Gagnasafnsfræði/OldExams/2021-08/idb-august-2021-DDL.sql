create table teachers (
	TID int primary key,
	name varchar not null
);

create table students (
	SID int primary key,
	name varchar not null
);

create table lectures (
	LID int primary key,
	name varchar not null
);

create table censors (
	CID int primary key,
	name varchar not null
);

create table tutor (
	TID int not null references teachers(TID),
	SID int references students(SID),
	fromyear int,
	CID int not null references censors(CID),
	primary key (SID, fromyear)
);

create table attend (
	SID int references students(SID),
	LID int references lectures(LID),
	primary key (SID, LID)
);
