drop view if exists alldata;
drop view if exists bedperc;
drop view if exists familycount;

-- (a)

select count(*)
from plants P
where P.familyID is null;
-- 8

select count(*)
from plants P
	join families F on F.ID = P.familyID
where M.name = 'Thespesia';
-- 18

-- (b)

select count(*)
from people E
	left join plantedin I on E.ID = I.planterID
where I.planterID is null;
-- 11

select count(*)
from people E
	left join plantedin I on E.ID = I.planterID
where I.planterID is null
	and E.position = 'Planter';
-- 9

-- (c)

select sum(1.0 * B.size * I.percentage / 100) as sqm
from families F
	join plants P on F.ID = P.familyID
	join plantedin I on P.ID = I.plantID
	join flowerbeds B on B.ID = I.flowerbedID
where F.name = 'Thespesia';
-- 66.62000000000003
-- 66.62

select sum(1.0 * B.size * I.percentage / 100) as sqm
from families F
	join plants P on F.ID = P.familyID
	join plantedin I on P.ID = I.plantID
	join flowerbeds B on B.ID = I.flowerbedID
where F.name = 'Vicia';
-- 27.3

-- (d)

drop view if exists bedperc;
create view bedperc 
as
select I.flowerbedID as ID, sum(I.percentage) as perc
from plantedin I
group by I.flowerbedID;

select max(BP.perc)
from bedperc BP;
-- 105

select BP.ID
from bedperc BP
where BP.perc = (
	select max(BP.perc)
	from bedperc BP
);
-- 243

-- (e)

select count(*)
from bedperc BP
where BP.perc > 100;
-- 9

select count(*)
from flowerbeds B
where B.ID not in (
	select BP.ID
	from bedperc BP
	where BP.perc >= 100
);
-- 273

-- (f)

select count(*)
from bedperc BP
where BP.perc < 100
 	and BP.ID in (
		select I.flowerbedID
	  	from plantedin I
	  		join plants P on I.plantID = P.ID
			join families F on P.familyID = F.ID
			join types T on F.typeID = T.ID
		where T.name = 'herb'
);
-- 150

-- (g)

select count(*)
from (
	select F.ID  --,  count(*), count(distinct B.ID), count(distinct B.parkID) -- use these for debugging
	from families F
		join plants P on F.ID = P.familyID
		join plantedin I on P.ID = I.plantID
		join flowerbeds B on B.ID = I.flowerbedID
	group by F.ID
	having count(distinct B.parkID) = (
		select count(*)
		from parks K
	) 
) X;
-- 354

select count(*)
from (
	select P.familyID  --,  count(*), count(distinct B.ID), count(distinct B.parkID) -- use these for debugging
	from plants P 
		join plantedin I on P.ID = I.plantID
		join flowerbeds B on B.ID = I.flowerbedID
	group by P.familyID
	having count(distinct B.parkID) = (
		select count(*)
		from parks K
	) 
) X;
-- 354

select count(*)
from (
	select I.flowerbedID --,  count(*), count(distinct M.ID), count(distinct M.typeID) -- use these for debugging
	from families F 
		join plants P on F.ID = P.familyID
		join plantedin I on P.ID = I.plantID
	group by I.flowerbedID
	having count(distinct F.typeID) = (
		select count(*)
		from types T
	) 
) X;
-- 2

-- (h)

create view alldata
as
select E.ID, E.name, T.name as type, K.name as park, E.position, 1.0 * B.size * I.percentage / 100 as sqm
from people E
	join plantedin I on E.ID = I.planterID
	join flowerbeds B on B.ID = I.flowerbedID
	join parks K on K.ID = B.parkID
	join plants P on P.ID = I.plantID
	join families F on F.ID = P.familyID
	join types T on T.ID = F.typeID;

select A.ID, A.name, sum(A.sqm)
from alldata A
group by A.ID, A.name
having A.ID in (
	select A2.ID
	from alldata A2
	where A2.type = 'flower'
		and A2.park = 'Kongens Have'
		and A2.position = 'Planter'
)
order by sum(A.sqm) desc;
-- First 5 rows:
-- 154	"Frank Jansen"	72.82
-- 110	"Jan Lauridsen"	72.04999999999998
-- 48	"Johan Mikaelsen"	70.41999999999999
-- 142	"Mikael Lauritz"	67.52999999999999
-- 156	"Mikael Mikaelsen"	67.47
--http://www.ict.griffith.edu.au/normalization_tools/normalization/ind.php#editAttibutes