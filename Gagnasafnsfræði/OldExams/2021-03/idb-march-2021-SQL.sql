-- (a)

select count(*)
from vaccines V
	join companies C on V.comID = C.ID
where C.name = 'Amgen';
-- 23

select count(*)
from vaccines V
	join diseases D on V.disID = D.ID
where D.name = 'Coronavirus';
-- 3

select * from categories;

-- (b)

select count(distinct I.peoID)
from injections I 
	join vaccines V on V.ID = I.vacID
	join diseases D on D.ID = V.disID
	join categories C on C.ID = D.catID
where D.curable = false
	and C.name = 'Immune diseases';
-- 282

select count(distinct I.peoID)
from injections I 
	join vaccines V on V.ID = I.vacID
	join diseases D on D.ID = V.disID
	join categories C on C.ID = D.catID
where D.curable = true
	and C.name = 'Bone diseases';
-- 514

-- (c)

-- incorrect version: only check disease in inner
select *
from vaccines V
where V.effectyears = (
	select max(V2.effectyears)
	from vaccines V2 
		join diseases D on V2.disID = D.ID
	where D.name = 'Coronavirus'
);

-- correct version, make sure the min is only for the coronavirus disease
select V.ID
from vaccines V
	join diseases D on V.disID = D.ID
where D.name = 'Coronavirus'
  and V.effectyears = (select min(V2.effectyears)
					   from vaccines V2
					   where V2.disID = D.ID);
-- 535

select V.ID
from vaccines V
	join diseases D on V.disID = D.ID
where D.name = 'Coronavirus'
  and V.effectyears = (select max(V2.effectyears)
					   from vaccines V2
					   where V2.disID = D.ID);
-- 536

-- (d)

select count(*)
from diseases D
where D.ID not in (
	select V.disID 
	from vaccines V
	group by V.disID
	having count(*) >= 5
);
-- 10

-- (e)

select count(distinct I.peoID)
from injections I
	join vaccines V on I.vacID = V.ID
	join diseases D on V.disID = D.ID
where D.name = 'Sleep Apnea'
  and I.injectionyear + V.effectyears >= date_part('year', CURRENT_DATE);
-- 113

select count(distinct I.peoID)
from injections I
	join vaccines V on I.vacID = V.ID
	join diseases D on V.disID = D.ID
where D.name = 'Coronavirus'
  and I.injectionyear + V.effectyears >= date_part('year', CURRENT_DATE);
-- 235

-- (f)

select count(*)
from People P
	join injections I on P.ID = I.peoID
where P.ID = 23;
-- 4

select (1.0*(select count(*) from injections) 
	 /  (select count(*) from people)) as X;
-- 57.4908088235294118

select ((select count(*) from injections) 
	 /  (select count(*) from people)) as X;
-- 57 

-- (f)
-- 

-- (g)
select count(*)
from (
	select P.ID, P.name
	from people P
		join injections I on P.ID = I.peoID
		join vaccines V on I.vacID = V.ID
		join diseases D on V.disID = D.ID
		join categories C on D.catID = C.ID
	where C.name = 'Immune diseases'
	group by P.ID
	having count(distinct D.ID) = (
		select count(*)
		from diseases D 
			join categories C on D.catID = C.ID
		where C.name = 'Immune diseases'
	)
) X;
-- 150

select count(*)
from (
	select P.ID, P.name
	from people P
		join injections I on P.ID = I.peoID
		join vaccines V on I.vacID = V.ID
		join diseases D on V.disID = D.ID
	group by P.ID
	having count(distinct D.catID) = (
		select count(*)
		from categories C
	)
) X;
-- 450

-- (h)

drop view if exists q1h_b;
drop view if exists q1h_a;

create view q1h_a
as
select P.ID as PID, D.ID as DID, P.birthyear, count(distinct V.ID) as vacnum
from people P
	join injections I on P.ID = I.peoID
	join vaccines V on I.vacID = V.ID
	join diseases D on V.disID = D.ID
	join categories C on C.ID = D.catID
where C.name = 'Immune diseases'
	and D.curable = true
group by P.ID, D.ID;

create view q1h_b
as
select Q.PID, Q.birthyear
from q1h_a Q
where Q.vacnum = (select max(Q1.vacnum) from q1h_a Q1);

select Q.PID
from q1h_b Q
where Q.birthyear = (select min(Q1.birthyear) from q1h_b Q1);
-- 422