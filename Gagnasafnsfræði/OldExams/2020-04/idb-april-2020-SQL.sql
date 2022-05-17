-- (a)

select count(*)
from employees 
where extract(year from birthday) = 1964;
-- 22913

select count(*)
from employees 
where extract(year from birthday) = 1954;
-- 23228

-- (b)

select extract(year from E.birthday)
from employees E 
	join dept_manager M on E.emp_no = M.emp_no
	join departments D on M.dept_no = D.dept_no
where D.name = 'Finance'
 	and M.to_date is null;
-- 1957

-- (c)

select count(*)
from (
	select dept_no, count(distinct emp_no)
	from dept_emp
	group by dept_no
	having count(distinct emp_no) > 50000
) X;
-- 3

select count(*)
from (
	select dept_no, count(distinct emp_no)
	from dept_emp
	where to_date is null
	group by dept_no
	having count(distinct emp_no) > 50000
) X;
-- 2

-- (d)

select emp_no 
from dept_emp 
where to_date - from_date = (
	select max(to_date - from_date)
	from dept_emp
);
-- 429386

select DE1.emp_no 
from dept_emp DE1 
	join dept_emp DE2 on DE1.emp_no = DE2.emp_no
where DE2.to_date - DE1.from_date = (
	select max(DE2.to_date - DE1.from_date)
	from dept_emp DE1
		join dept_emp DE2 on DE1.emp_no = DE2.emp_no
);
-- 300023

-- (e)
select count(*)
from (
	select DE.emp_no
	from dept_emp DE
		join departments D on DE.dept_no = D.dept_no
	where D.name = 'Production'
	except
	select T.emp_no
	from titles T
	where T.title like '%Engineer'
) X;
-- 8390

select count(*)
from (
	select DE.emp_no
	from dept_emp DE
		join departments D on DE.dept_no = D.dept_no
	where D.name = 'Development'
	except
	select T.emp_no
	from titles T
	where T.title like '%Engineer'
) X;
-- 9456

-- (f)

select count(distinct T.title)
from departments D
	join dept_emp DE on D.dept_no = DE.dept_no
	join titles T on DE.emp_no = T.emp_no
where D.name = 'Development'
	and DE.to_date is null;
-- 7

-- (g)

select count(*)
from (
	select emp_no, count(*)
	from titles
	where title like '%Staff'
	group by emp_no
	having count(distinct title) = (
		select count(distinct title)
		from titles
		where title like '%Staff'
	)
) X;
-- 66263

select count(*)
from (
	select emp_no, count(*)
	from titles
	where title like '%Engineer'
	group by emp_no
	having count(distinct title) = (
		select count(distinct title)
		from titles
		where title like '%Engineer'
	)
) X;
-- 3008

-- (h)

select E.emp_no
from employees E
	join dept_emp DE on E.emp_no = DE.emp_no
	join departments D on DE.dept_no = D.dept_no
	join titles T on T.emp_no = E.emp_no
	join salaries S on S.emp_no = E.emp_no
where DE.to_date is null
	and S.to_date is null
	and T.to_date is null
	and D.name = 'Development'
	and T.title = 'Senior Engineer'
	and S.salary = (
		select min(S1.salary)
		from salaries S1
			join dept_emp DE1 on S1.emp_no = DE1.emp_no
			join departments D1 on DE1.dept_no = D1.dept_no
			join titles T1 on S1.emp_no = T1.emp_no
		where S1.to_date is null
			and DE1.to_date is null
			and D1.name = 'Development'
			and T1.title = 'Senior Engineer'
	);
-- 63966

select E.emp_no
from employees E
	join dept_emp DE on E.emp_no = DE.emp_no
	join departments D on DE.dept_no = D.dept_no
	join titles T on T.emp_no = E.emp_no
	join salaries S on S.emp_no = E.emp_no
where DE.to_date is null
	and S.to_date is null
	and T.to_date is null
	and D.name = 'Development'
	and T.title = 'Senior Engineer'
	and S.salary = (
		select max(S1.salary)
		from salaries S1
			join dept_emp DE1 on S1.emp_no = DE1.emp_no
			join departments D1 on DE1.dept_no = D1.dept_no
			join titles T1 on S1.emp_no = T1.emp_no
		where S1.to_date is null
			and DE1.to_date is null
			and D1.name = 'Development'
			and T1.title = 'Senior Engineer'
	);
-- 86631

