create table Human (
  CPR integer primary key,
  name varchar(50) not null
);

create table  Player (
  CPR integer primary key references Human (CPR),
  rank integer not null
);

create table  Official (
  CPR integer primary key references Human (CPR),
  title varchar(50) not null
); 

create table  GamePlay_V1 (
  -- The default version, using the natural primary key
  white integer references Player(CPR), 
  black integer references Player(CPR),
  time timestamp, 
  -- this is one way of encoding this: true for white, false for black
  winner bool not null, 
  primary key (white, black, time)
);

create table  Record_V1 (
  recorder integer references Official (CPR),
  white integer,  
  black integer,  
  time timestamp, 
  primary key (white, black, recorder, time),
  foreign key (white, black, time) references GamePlay_V1 (white, black, time)
);

create table  GamePlay_V2(
  -- With GamePlay ID, must remember the unique declaration at the end
  GPID integer primary key,
  white integer not null references Player(CPR), 
  black integer not null references Player(CPR),
  time timestamp not null, 
  -- this is one way of encoding this: true for white, false for black
  winner bool not null, 
  unique (white, black, time)
);

create table  Record_V2 (
  recorder integer references Official (CPR),
  GPID integer references GamePlay_V2 (GPID),
  primary key (GPID, recorder)
);