-- (a)

-- 286
select count(distinct fromID) 
from Relationships;

-- 287
select count(distinct toID) 
from Relationships;

-- (b)

-- 46
select count(*)
from Relationships A
	join Relationships B on A.toID = B.fromID and A.fromID = B.toID
where A.fromID > B.fromID;

-- (c)

-- 10
select count(*)
from Relationships S
	left join Roles R on R.fromID = S.fromID and R.toID = S.toID
where R.role is null;

-- (d)

-- supporting view
drop view if exists postsWithCommentCount;
create view postsWithCommentCount
as
select C.postID as ID, count(*) as cnt
from Comments C
group by C.postID;

-- 3
select C.cnt
from postsWithCommentCount C
where C.ID = 24;

-- 1223
select C.ID
from postsWithCommentCount C
where C.cnt = (
	select max(cnt)
	from postsWithCommentCount
);

-- (e)

-- 6
select count(*)
from postsWithCommentCount C
where C.cnt > 5;

-- 1674
select count(*)
from (
	select C.ID
	from postsWithCommentCount C
	where C.cnt <= 2
	union
	select P.ID 
	from Posts P
		left join postsWithCommentCount C on P.ID = C.ID 
	where C.cnt is null
) X;

-- (f)

-- 90
select count(distinct R.fromID)
from Roles R  
	join Comments C on R.toID = C.posterID and R.fromID = C.userID
where R.role = 'Spouse';

-- 33
select count(distinct Z.municipalityID)
from Zips Z
	join Users U on Z.zip = U.zip
	join Roles R on U.ID = R.fromID 
	join Comments C on R.toID = C.posterID and R.fromID = C.userID
where R.role = 'Spouse';

-- (g)

-- 83
select count(distinct fromID)
from (
	select R.fromID, R.toID
	from Roles R
	group by R.fromID, R.toID
	having count(role) = (select count(distinct role) from Roles)
) X;

-- 86
select count(distinct toID)
from (
	select R.fromID, R.toID
	from Roles R
	group by R.fromID, R.toID
	having count(role) = (select count(distinct role) from Roles)
) X;

-- (h)

-- 206 = readable version
select count(distinct posterID)
from (
	select P.ID, P.posterID
	from Posts P join Likes L on L.postID = P.ID
	except
	select P.ID, P.posterID
	from Posts P join Comments C on P.ID = C.postID
) X;

-- 206 = dense version
select count(distinct posterID)
from Posts P join (
	select L.postID 
	from Likes L
	except
	select C.postID
	from Comments C
) X on P.id = X.postID;


-- 206 = simplest student version, probably the most readable!
select count(distinct posterid)
from posts p
where p.id in (select postid from likes)
and p.id not in (select postid from comments)

