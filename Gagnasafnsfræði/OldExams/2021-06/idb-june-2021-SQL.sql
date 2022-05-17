-- (a)

-- There is one club from Copenhagen
-- How many clubs are there from London?

select count(*)
from clubs C 
	join cities T on C.cityID = T.ID 
where T.name = 'Copenhagen';
-- 1

select count(*)
from clubs C 
	join cities T on C.cityID = T.ID 
where T.name = 'London';
-- 6

-- (b) 

-- There are three clubs that have signings, but are no longer in the database.
-- How many players have at some point signed with these clubs?

select count(distinct W.clubID)
from signedwith W
where W.clubID not in (
	select C.ID
	from clubs C
);
-- 3

select count(distinct W.playerID)
from signedwith W
where W.clubID not in (
	select C.ID
	from clubs C
);
-- 7

-- (c)

-- The club named Liverpool has 243 away wins, 
-- while the highest number of away wins happens to be 260.
-- How many different clubs jointly have the most away wins?

-- A view to count the away wins per club
drop view if exists awaywins;
create view awaywins
as
select C.ID, C.name, count(*) as awaywins
from matches M
	join clubs C on M.awayID = C.iD
where M.awaywin
group by C.ID;

-- check the view
select *
from awaywins
order by awaywins desc;
 
select A.awaywins
from awaywins A
where A.name = 'Liverpool';
-- 243

select max(A.awaywins)
from awaywins A;
-- 260

select count(*)
from awaywins A
where A.awaywins = (
	select max(awaywins)
	from awaywins
);
-- 2


-- (d)

-- During the playing career of Andrea Pirlo, 
-- the teams he was signed with scored 319 home goals.
-- How many away goals did the teams that Steven Gerrard was signed with score?

select sum(M.homegoals)
from players P
	join signedwith W on W.playerID = P.ID
	join matches M on W.clubID = M.homeID and W.seasonID = M.seasonID
where P.name = 'Andrea Pirlo';
-- 319

select sum(M.awaygoals)
from players P
	join signedwith W on W.playerID = P.ID
 	join matches M on W.clubID = M.awayID and W.seasonID = M.seasonID
where P.name = 'Steven Gerrard';
-- 62

-- (e)

-- During his illustrious playing career, Bjorn signed with 7 different clubs
-- Write a query to output the name(s) of the player(s) which signed with 
-- the largest number of different clubs
drop view if exists clubcount;
create view clubcount 
as
select W.playerID, count(distinct W.clubID) as clubs
from signedwith W
group by W.playerID;

select *
from clubcount CC
order by CC.clubs desc;

select CC.clubs
from clubcount CC 
	join players P on P.ID = CC.playerID
where P.name = 'Bjorn';
-- 7

select P.name
from clubcount CC 
	join players P on P.ID = CC.playerID
where CC.clubs = (
	select max(clubs)
	from clubcount
);
-- Ruud van Nistelrooy

-- (f)

-- How many players never signed with a club from London

select count(*)
from (
	select P.ID
	from players P
	except
	select distinct W.playerID
	from signedwith W 
		join clubs C on W.clubID = C.ID
		join cities T on C.cityID = T.ID
	where T.name = 'London'
) X;
-- 22

-- (g)

-- All 14 non-London clubs have beaten all London clubs away at some point in history
-- How many non-London clubs have beaten all London clubs away in a single season?

select count(*)
from (
	select M.awayID, count(distinct M.homeID)
	from matches M
		join clubs C on M.homeID = C.ID
		join cities T on C.cityID = T.ID
	where T.name = 'London'
		and M.awaywin
	group by M.awayID
	having count(distinct M.homeID) = (
		select count(*)
		from clubs C join cities T on C.cityID = T.ID
		where T.name = 'London'
	)
) X;
-- 14

select count(*)
from (
	select M.awayID, M.seasonID, count(distinct M.homeID)
	from matches M
		join clubs C on M.homeID = C.ID
		join cities T on C.cityID = T.ID
	where T.name = 'London'
		and M.awaywin
	group by M.awayID, M.seasonID
	having count(distinct M.homeID) = (
		select count(*)
		from clubs C join cities T on C.cityID = T.ID
		where T.name = 'London'
	)
) X;
-- 2

-- (h)

-- Write a query that correctly outputs the final standing in season 2035

drop view if exists points;
create view points
as
select M.homeID as clubID, 3 as points, seasonID
from matches M
where M.homegoals > M.awaygoals
union all
select M.homeID, 1, seasonID
from Matches M
where M.homegoals = M.awaygoals
union all
select M.awayID, 1, seasonID
from matches M
where M.homegoals = M.awaygoals
union all
select M.awayID, 3, seasonID
from matches M
where M.homegoals < M.awaygoals;

select name, points
from (
	select C.ID, C.name, sum(S.points) as points
	from points S
		join clubs C on S.clubID = C.ID
	where S.seasonID = 2035
	group by C.ID
	order by sum(S.points) desc
) X;

-- Chelsea	63
-- West Ham	62
-- Fulham	62
-- FCK	61
-- AC	60
-- City	57
-- Juventus	56
-- Liverpool	56
-- Roma	55
-- PSG	54
-- Inter	54
-- Rangers	53
-- Barcelona	53
-- Crystal Palace	48
-- Everton	48
-- Tottenham	45
-- Arsenal	44
-- United	43
-- Bayern	41
-- Real	38


