create table Jojos(
    JID int primary key,
    name varchar not null
);

create table Loners(
    LID int primary key,
    status varchar not null
);

create table Homes(
    HID int primary key,
    state varchar not null
);

create table Thought(
    lasted varchar not null,
    Lid int references Loners(Lid),
    JID int references Jojos(JID),
    primary key (lasted, JID, LID)
);


create table Leftfor(
	JID int references Jojos(JID));,
	HID int references Homes(HID),
	what varchar not null,
	primary key (LJID, LHID, what)
);

create table Getback(
    to_where varchar not null,
    LID int references Loners(LID)
    JID int references Leftfor(JID)),
    LHID int references Leftfor(HID),
    primary key (to_where, LID, HID, JID)

);