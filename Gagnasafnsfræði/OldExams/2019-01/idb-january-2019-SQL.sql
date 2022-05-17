-- a) 

select count(*) 
from Player 
where email like '%@yahoo.dk';

-- b) 

select count(score) 
from Score
where score < (select avg(score) from Score);

-- c) 

select count(*)
from PlayerAchievement PA 
	left join Achievement A on PA.achievementId = A.id
where A.id is null;

select count(AchievementId) 
from PlayerAchievement 
where AchievementId not in (
	select id 
    from Achievement
);

-- d) 

select count(distinct PA.playerId)
from PlayerAchievement PA 
	join Achievement A on PA.achievementId = A.id
    join Game G on A.gameId = G.id
	join Score S on PA.playerId = S.playerId and S.gameId = G.id
where G.producer = 'Codemasters';   

select count(distinct Score.PlayerId) 
from Score 
join PlayerAchievement PA on Score.playerId = PA.playerId 
join Achievement AC on PA.AchievementId = AC.id 
where Score.gameId = AC.gameId 
  and Score.gameId in (
	  select id 
	  from Game 
	  where producer like 'Codemasters'
  );

-- e) 

select count(distinct playerId)
from PlayerAchievement PA
	join Achievement A on PA.achievementId = A.id
where not exists (
	select *
    from Score S
	where PA.playerId = S.playerId
		and A.gameId = S.gameId
);

select count(distinct playerid) 
from (
	select PlayerAchievement.playerId,Score.gameId as score, Achievement.gameId as ach 
    from PlayerAchievement 
		join Achievement on PlayerAchievement.AchievementId=Achievement.Id 
        left join Score on Achievement.gameId=Score.gameId and PlayerAchievement.playerId = Score.playerId
	) a 
where score is NULL; 

-- f) 

select count(playerId) 
from (
	select playerId
    from Score 
    where GameId in (
		select id 
		from Game 
        where name like 'Project Eden'
	) 
    group by playerId 
    having count(gameId) = (
		select count(*) 
        from Game 
        where name = 'Project Eden'
	)
) X;

select count(*)
from Player P
where not exists (
	select *
    from Game G
    where name = 'Project Eden'
    and not exists (
		select *
        from Score S
        where P.Id = S.playerId
          and G.id = S.gameId
	)
);


-- g) 

select count(*)
from (
	select count(distinct producer) 
    from Game 
    group by name 
	having count(distinct producer) = 2
) X;

-- h)

select count(*) 
from game G1 
	join game G2 on G1.name = G2.name and G1.id < G2.id;

select count(*) 
from (
	select *
    from Game a 
		join Game b on a.id > b.id 
	where a.name = b.name
) as Z;
