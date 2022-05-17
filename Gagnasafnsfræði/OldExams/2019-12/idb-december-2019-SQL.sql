-- a)

-- 4
select count(*)
from empires E
where E.Empire = 'Great Britain';

-- 3
select count(*)
from empires E
where E.Empire = 'Benelux';

-- b) 

-- 3264
select count(*)
from cities CI 
	join countries CO on CI.CountryCode = CO.Code
where CI.Population <= 0.01 * CO.Population;

-- 14
select count(*)
from cities CI 
	join countries CO on CI.CountryCode = CO.Code
where CI.Population > 0.5 * CO.Population;

-- c)

-- 4
select count(*)
from (
	select CC.CountryCode
	from countries_continents CC 
	group by CC.CountryCode
	having count(*) > 1
) X;

-- 2
select count(*)
from (
	select CC.CountryCode
	from countries_continents CC 
		join countries_continents C2 on CC.CountryCode = C2.CountryCode
	where C2.Continent = 'Europe'
	group by CC.CountryCode
	having count(*) > 1
) X;

-- d)

-- 2
select count(*)
from (
	select CL.CountryCode
	from countries_languages CL
	group by CL.CountryCode
	having sum(CL.Percentage) > 100.0
) X;

-- 208
select count(*)
from (
	select CL.CountryCode
	from countries_languages CL
	group by CL.CountryCode
	having sum(CL.Percentage) < 100.0
	union
	select CO.Code
	from countries CO
	where not exists (
		select *
		from countries_languages CL
		where CL.CountryCode = CO.Code
	)
) X;

-- e)

-- 164688674

select sum(SpanishSpeaking)
from (
	select CO.Code, CO.Population * CL.Percentage / 100.0 as SpanishSpeaking
	from countries CO
		join countries_continents CC on CO.Code = CC.CountryCode
		join countries_languages CL on CO.Code = CL.CountryCode
	where CO.Population > 1000000
		and CC.Continent = 'North America'
		and CL.Language = 'Spanish'
) X;

-- 160575157 +/- 100

select sum(SpanishSpeaking)
from (
	select CO.Code, CO.Population * CL.Percentage / 100.0 as SpanishSpeaking
	from countries CO
		join countries_continents CC on CO.Code = CC.CountryCode
		join countries_languages CL on CO.Code = CL.CountryCode
	where CO.Population > 1000000
		and CC.Continent = 'South America'
		and CL.Language = 'Spanish'
) X;

-- f)

	-- 456

drop view if exists AllPairs;
create view AllPairs
as
select C1.ID, 1.0*C1.Population/C2.Population as Ratio
from cities C1
	join cities C2 on C1.CountryCode = C2.CountryCode and C1.ID <> C2.ID and C1.Population > C2.Population;

select AP.ID
from AllPairs AP
where AP.Ratio = (select max(Ratio) from AllPairs);

-- g)

-- 1
select count(*)
from (
	select count(CL.language)
	from empires E
		join countries_languages CL on E.CountryCode = CL.CountryCode
	where E.Empire = 'Danish Empire'
	group by language
	having count(E.CountryCode) = (
		select count(*)
		from empires E
		where E.Empire = 'Danish Empire'
	)
) X;

-- 2
select count(*)
from (
	select count(CL.language)
	from empires E
		join countries_languages CL on E.CountryCode = CL.CountryCode
	where E.Empire = 'Benelux'
	group by language
	having count(E.CountryCode) = (
		select count(*)
		from empires E
		where E.Empire = 'Benelux'
	)
) X;

-- h) 

drop view if exists sumCities;
create view sumCities
as
select CI.CountryCode, sum(Population) as Population
from cities CI
group by CI.CountryCode;

drop view if exists sumPopulation;
create view sumPopulation
as 
select CO.Code, CO.Population, SCI.Population as UrbanPopulation, 1.0*SCI.Population/CO.Population as ratio
from countries CO 
	join sumCities SCI on CO.Code = SCI.CountryCode;

-- Info on Netherlands
select SP.UrbanPopulation
from sumPopulation SP
where Code = 'NLD';

-- SGP
select * 
from sumPopulation SP
where SP.Population > 1000000 
	and SP.ratio = (select max(ratio) from sumPopulation);

