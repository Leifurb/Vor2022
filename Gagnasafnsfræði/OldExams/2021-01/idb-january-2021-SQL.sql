-- (a)
-- Number of models made by Volvo
-- => number of cars made by Volvo

select count(*)
from models M
	join makers K on M.makerID = K.ID
where K.name = 'VOLVO';
-- 13

select count(*)
from cars C 
	join models M on C.modelID = M.ID
	join makers K on M.makerID = K.ID
where K.name = 'VOLVO';
-- 664

-- (b)
-- Number of different makers of cars that person 34 has bought from
-- => Number of different makers of cars that person 45 has bought from

select count(distinct M.makerID)
from sales S
	join cars C on S.carID = C.ID
	join models M on C.modelID = M.ID
where S.personID = 34;
-- 7

select count(distinct M.makerID)
from sales S
	join cars C on S.carID = C.ID
	join models M on C.modelID = M.ID
where S.personID = 45;
-- 7

-- (c)
-- Six different makers with the fewest models (1)
-- => ID of maker with the most models 

select makerID
from models M
group by M.makerID
having count(*) = (
	select max(cnt)
	from (
		select count(*) as cnt
		from models M
		group by makerID
	) X
);
-- 10

-- (d)
-- How many cars have been sold < 2 times  
-- (some have never been sold, must be included)

-- Find all the cars that were never sold 
-- PLUS
-- Find all the cars sold, but fewer times than twice
select count(*)
from (
	select C.ID
	from cars C
		left join sales S on C.ID = S.carID
	where S.carID is null
	union all -- there can be no duplicates... 
	select S.carID 
	from sales S
	group by S.carID
	having count(*) < 2
) X;
-- 818

select count(*)
from (
	select C.ID
	from cars C
	where C.ID not in (select S.carID from sales S)
	union all -- there can be no duplicates... 
	select S.carID 
	from sales S
	group by S.carID
	having count(*) < 2
) X;
-- 818

-- Negation: Count all cars, except the ones sold >= 2 times
select count(*)
from (
	select C.ID
	from cars C
	except
	select S.carID 
	from sales S
	group by S.carID
	having count(*) >= 2
) X;

-- Negation: Count all cars, except the ones sold >= 2 times
select count(*)
from cars C
where C.ID not in (
	select S.carID 
	from sales S
	group by S.carID
	having count(*) >= 2
);
-- 818

-- Doing it all in the select clause
-- NOT A RECOMMENDED SOLUTION :)
select (
	select count(*)
	from cars C
		left join sales S on C.ID = S.carID
	where S.carID is null
) + (
	select count(*)
	from (
		select S.carID 
		from sales S
		group by S.carID
		having count(*) < 2
	) X
);
-- 818

-- (e)
-- Car with licence LX363 has been sold twice
-- => What is the licence of the car sold most often

-- helper view that groups by licence and counts sales
drop view if exists licsales;
create view licsales
as 
select C.licence, count(*) as salecount
from sales S
	join cars C on S.carID = C.id
group by C.licence;

select LS.salecount
from licsales LS
where LS.licence = 'LX363';
-- 11

select LS.licence
from licsales LS
where LS.salecount = (select max(salecount) from licsales);
-- SI998

-- (f)
-- How many people have made at least one sale alone

select count(distinct S2.personID)
from (
	select L.saleID
	from sellers L
	group by L.saleID
	having count(*) = 1
) S1 join sellers S2 on S1.saleID = S2.saleID;
-- 544

select count(distinct personID)
from (
	select L.saleID, max(L.personID) as personID
	from sellers L
	group by L.saleID
	having count(*) = 1
) X;
-- 544

-- (g)
-- Number of people who have bought all models from maker X
-- => Number of people who have bought all models from maker Y

select count(*)
from (
	select S.personID
	from sales S
		join cars C on S.carID = C.ID
		join models M on C.modelID = M.ID
		join makers K on M.makerID = K.ID
	where K.name = 'LAMBORGHINI'
	group by S.personID
	having count(distinct C.modelID) = (
		select count(*)
		from models M
			join makers K on M.makerID = K.ID
		where K.name = 'LAMBORGHINI'
	)
) X;
-- 23

select count(*)
from (
	select S.personID
	from sales S
		join cars C on S.carID = C.ID
		join models M on C.modelID = M.ID
		join makers K on M.makerID = K.ID
	where K.name = 'VOLVO'
	group by S.personID
	having count(distinct C.modelID) = (
		select count(*)
		from models M
			join makers K on M.makerID = K.ID
		where K.name = 'VOLVO'
	)
) X;
-- 5

-- (h)
-- How many cars have some problem with years

select count(*)
from (
	select C.ID
	from cars C 
		join models M on C.modelID = M.ID
	where M.firstyear > C.prodyear 
		or M.lastyear < C.prodyear
	union
	select C.ID
	from cars C
		join sales S on S.carID = C.ID
	where S.saleyear < C.prodyear
	union 
	select C.ID
	from cars C
		join sales S on S.carID = C.ID
		join people P on S.personID = P.ID
	where S.saleyear < P.birthyear
	union
	select C.ID
	from cars C
		join sales S on S.carID = C.ID
		join sellers L on L.saleID = S.ID
		join people P on L.personID = P.ID
	where S.saleyear < P.birthyear
) X;
-- 5364