-- (a)

-- 2
select count(*) 
from airport 
where country = 'DK';

-- 17
select count(*) 
from airport 
where country = 'DE';

-- (b) 

-- 57
select count(*) 
from airport A
    join country C on A.country = C.country
where C.region = 'AS'
    and exists (select * from flights F where F.arr = A.airport)
    and exists (select * from flights F where F.dep = A.airport);

-- 185
select count(*) 
from airport A
    join country C on A.country = C.country
where C.region = 'EU'
    and exists (select * from flights F where F.arr = A.airport)
    and exists (select * from flights F where F.dep = A.airport);

-- (c) 

-- 42.77
select avg(F.end_op - F.start_op)
from flights F;

-- 1572
select max(F.end_op - F.start_op)
from flights F;

-- (d)

-- 6126
select count(*)
from flights F
    join aircraft A on F.actype = A.actype
    join airport P on F.DEP = P.airport
    join country C on C.country = P.country
where A.capacity > 300
  and C.region = 'EU';

-- 185
select count(*)
from flights F
    join aircraft A on F.actype = A.actype
    join airport P on F.DEP = P.airport
    join country C on C.country = P.country
where A.capacity > 300
  and C.region = 'AS';

-- (e)

create view AGcount 
as
select A.ag, count(*) as ac
from aircraft A
group by A.ag;

-- 2
select min(ac) 
from AGcount;

-- 24
select max(ac) 
from AGcount;

-- (f)

-- 124
select count(*)
from (
    select F1.DEP, count(*)
    from flights F1
    group by F1.DEP
    having count(*) > (select count(*) from flights F2 where F2.ARR = F1.DEP)
) X;

create view D
as
select F1.DEP, count(*) as C
    from flights F1
    group by F1.DEP;

create view A
as
select F1.ARR, count(*) as C
    from flights F1
    group by F1.ARR;

select count(*)
from D left join A on D.dep = A.arr
where D.C > A.C or A.C is null;

-- 182
select count(*)
from (
    select F1.ARR, count(*)
    from flights F1
    group by F1.ARR
    having count(*) > (select count(*) from flights F2 where F2.DEP = F1.ARR)
) X;

select count(*) 
from airport a
where (
	select count(*) 
    from flights f1
	where f1.arr = a.airport
) > (
	select count(*) 
    from flights f2
	where f2.dep = a.airport
);

select count(*)
from A left join D on D.dep = A.arr
where A.C > D.C or D.C is null;

-- (g)

-- 518
select count(*)
from flights F 
    join aircraft P on F.actype = P.actype
    join airport A1 on A1.airport = F.ARR 
    join country C1 on A1.country = C1.country
    join airport A2 on A2.airport = F.dep
    join country C2 on A2.country = C2.country
where C1.region = C2.region
  and A1.country <> A2.country
  and P.ag = 'F';

-- (h) 

-- 1
select count(distinct F.AL) 
from flights F
	join airport A on F.dep = A.airport
where A.country = 'DK'
group by F.AL
having count(distinct a.airport) = (
	select count(*) 
    from airport
	where country = 'DK'
);

select count(distinct C.AL)
from flights C
where not exists (
	select *
    from airport A
    where A.country = 'DK'
      and not exists (
		select *
        from flights F
        where F.AL = C.AL
          and F.DEP = A.airport
	)
);

-- 1
select count(distinct F.AL) 
from flights F
	join airport A on F.dep = A.airport
where A.country = 'NL'
group by F.AL
having count(distinct a.airport) = (
	select count(*) 
    from airport
	where country = 'NL'
);

select count(distinct C.AL)
from flights C
where not exists (
	select *
    from airport A
    where A.country = 'NL'
      and not exists (
		select *
        from flights F
        where F.AL = C.AL
          and F.DEP = A.airport
	)
);
