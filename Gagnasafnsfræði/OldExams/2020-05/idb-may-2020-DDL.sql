drop table if exists observes;
drop table if exists masters;
drop table if exists mantras;
drop table if exists anakins;
drop table if exists yodas;
drop table if exists programmers;
drop table if exists skills;

create table programmers (
	PID integer primary key
);

create table yodas (
	PID integer primary key references programmers,
	JediLevel integer not null
);

create table anakins (
	PID integer primary key references programmers,
	trainer integer not null references yodas(PID),
	AngerLevel integer not null
);

create table mantras (
	PID integer references yodas,
	mantra varchar,
	primary key (PID, mantra)
);

create table skills (
	SID integer primary key
);

create table masters (
	SID integer references skills,
	PID integer references yodas,
	SkillLevel integer not null,
	primary key (SID, PID)
);

create table observes (
	SID integer,
	YPID integer,
	APID integer references anakins(PID),
	foreign key (SID, YPID) references masters (SID, PID),
	primary key (SID, YPID, APID)
);
