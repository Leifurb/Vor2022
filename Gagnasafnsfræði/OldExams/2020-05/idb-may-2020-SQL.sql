-- (a)

-- 15
select count(*)
from Places
where name like '%borg';

-- 12
select count(*)
from Places
where name like '%lev';

-- (b)

-- 133
select ID
from Places
where population = (
	select min(population)
	from Places
);

-- 34
select ID
from Places
where population = (
	select max(population)
	from Places
);

-- (c)

-- 3
select count(*)
from TeamsInDivisions TD
where TD.teamID = 51;

-- 62
select count(*)
from (
	select TD.teamID
	from TeamsInDivisions TD
	group by TD.teamID
	having count(*) > 1
) X;

-- (d)

-- 54
select count(distinct T.ID)
from Teams T
	join TeamsInDivisions TD on T.ID = TD.teamID
	join Divisions D on D.ID = TD.divisionID
where T.genderID <> D.genderID;

-- (e)

-- supporting view
drop view if exists PlacesWithTeams;
create view PlacesWithTeams
as
select P.ID as PID, P.name, 
	   G.ID as GID, G.gender, count(*) as teams
from Places P
	join Clubs C on P.ID = C.placeID
	join Teams T on C.ID = T.clubID
	join Genders G on G.ID = T.genderID
group by P.ID, P.name, G.ID, G.gender;

-- 15
select PT.teams
from PlacesWithTeams PT
where PT.name = 'Aarhus'
  and PT.gender = 'M';

-- 34
select PC.PID
from PlacesWithTeams PC
where PC.teams = (
	select max(teams)
	from PlacesWithTeams
	where gender = 'M'
);

-- (f)

-- 60
select count(*)
from (
	select T.clubID, count(*)
	from Teams T 
	group by T.clubID
	having count(distinct T.genderID) = (
		select count(*)
		from Genders 
	)
) X;

-- 30 -- correctly excludes the NULL place
select count(*)
from (
	select P.ID, count(*)
	from Places P
		join Clubs C on P.ID = C.placeID
		join Teams T on C.ID = T.clubID
	group by P.ID
	having count(distinct T.genderID) = (
		select count(*)
		from Genders 
	)
) X;

-- 30 -- correctly excludes the NULL place
select count(*)
from (
	select C.placeID, count(*)
	from Clubs C 
		join Teams T on C.ID = T.clubID
	where C.placeID is not null
	group by C.placeID
	having count(distinct T.genderID) = (
		select count(*)
		from Genders 
	)
) X;

-- 31 -- incorrectly includes the NULL place
select count(*)
from (
	select C.placeID, count(*)
	from Clubs C 
		join Teams T on C.ID = T.clubID
	-- where C.placeID is not null
	group by C.placeID
	having count(distinct T.genderID) = (
		select count(*)
		from Genders 
	)
) X;

-- (g)

-- 1
select count(*)
from (
	select T.clubID, count(*)
	from Teams T
		join TeamsInDivisions TD on T.ID = TD.teamID
		join Divisions D on D.ID = TD.divisionID
		join Genders G on G.ID = D.genderID
	where G.gender = 'M'
	group by T.ClubID
	having count(distinct TD.divisionID) = (
		select count(*)
		from Divisions D
			join Genders G on G.ID = D.genderID
		where G.gender = 'M'
	)
) X;

-- (h)

-- supporting view
drop view if exists TeamsWithPoints;
create view TeamsWithPoints
as 
select ID, sum(points) as points
from (
	select T.ID, sum(S.homepoints) as points
	from Teams T
		join Matches M on T.ID = hometeamID
		join Sets S on M.ID = S.matchID
	group by T.ID
	union all
	select T.ID, sum(S.awaypoints) as points
	from Teams T
		join Matches M on T.ID = awayteamID
		join Sets S on M.ID = S.matchID
	group by T.ID
) X
group by ID;

-- 268
select *
from TeamsWithPoints 
where ID = 0;

-- 1637
select max(points)
from TeamsWithPoints;
