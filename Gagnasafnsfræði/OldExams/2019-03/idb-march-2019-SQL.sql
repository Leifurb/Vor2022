-- (a)

select count(*)
from person
where height > 190;
-- 573

select count(*)
from person
where height is null;
-- 47315

-- (b)

select count(*)
from (
	select movieId, avg(P.height)
	from Involved I
		join person P on I.personId = P.ID
	group by I.movieId
	having avg(P.height) < 165
) X;
-- 365

select count(*)
from (
	select movieId, avg(P.height)
	from Involved I
		join person P on I.personId = P.ID
	group by I.movieId
	having avg(P.height) > 190
) X;
-- 89

-- (c)

select count(*)
from (
	select movieId
	from movie_genre
	group by movieId
	having count(distinct genre) <> count(*)
) X;
-- 143

-- (d)

select count(distinct I1.personId)
from involved I1 
    join involved I2 on I1.movieId = I2.movieId
	join person P on I2.personId = P.id
where I1.role = 'actor'
  and I2.role = 'director'
  and P.name = 'Francis Ford Coppola';
-- 476

select count(distinct I1.personId)
from involved I1 
    join involved I2 on I1.movieId = I2.movieId
	join person P on I2.personId = P.id
where I1.role = 'actor'
  and I2.role = 'director'
  and P.name = 'Steven Spielberg';
-- 2219

-- (e)

select count(*)
from movie M
where M.year = 2002
  and M.id not in (
	select I.movieId
    from involved I
);
-- 12

select count(*)
from movie M
where M.year = 1999
  and M.id not in (
	select I.movieId
    from involved I
);
-- 7

-- (f)

select count(*)
from (
	select I1.personId, count(*)
	from involved I1
		join involved I2 on I1.movieId = I2.movieId and I1.personId = I2.personId
	where I1.role = 'actor' 
		and I2.role = 'director'
	group by I1.personId
	having count(*) = 1
) X;
-- 603

select count(*)
from (
	select I1.personId, count(*)
	from involved I1
		join involved I2 on I1.movieId = I2.movieId and I1.personId = I2.personId
	where I1.role = 'actor' 
		and I2.role = 'director'
	group by I1.personId
	having count(*) > 1
) X;
-- 345

-- (g)

select count(*)
from (
	select M.id
	from movie M
		join involved I on M.id = I.movieId    
	where M.year = 2002
	group by M.id
	having count(distinct I.role) = (
		select count(*)
		from role R
	)
) X;
-- 282

select count(*)
from (
	select M.id
	from movie M
		join involved I on M.id = I.movieId    
	where M.year = 1999
	group by M.id
	having count(distinct I.role) = (
		select count(*)
		from role R
	)
) X;
-- 250

-- (h)

select count(*)
from (
	select P.id
	from person P
		join involved I on P.id = I.personId    
		join movie M on I.movieId = M.ID
		join movie_genre MG on MG.movieId = M.id
		join genre G on MG.genre = G.genre
	where G.category  = 'Newsworthy'
	group by P.id
	having count(distinct G.genre) = (
		select count(*)
		from genre
		where category = 'Newsworthy'
	)
) X;
-- 156

select count(*)
from (
	select P.id
	from person P
		join involved I on P.id = I.personId    
		join movie M on I.movieId = M.ID
		join movie_genre MG on MG.movieId = M.id
		join genre G on MG.genre = G.genre
	where G.category  = 'Lame'
	group by P.id
	having count(distinct G.genre) = (
		select count(*)
		from genre
		where category = 'Lame'
	)
) X;
-- 1

