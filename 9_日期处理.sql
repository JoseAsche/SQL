-- with x (dy,mth)
-- as 
-- ( 
--	select dy,month(dy)
--	from (
--		select dateadd(mm,1,getdate()-datepart(dy,getdate())+1) as dy
--		from t1) tmp
--	union all
--	select
--		dy+1,-- dateadd(dd,1,dy) 
--		mth
--	from x 
--	where month(dy+1)=mth)
--select count(*) 
--from x

--select datediff(dd,fy,dateadd(yy,1,fy)) as daynum
--from (
--	select dateadd(dd,-datepart(dy,getdate())+1,getdate()) fy
--	from t1) tmp
 
---- day(getdate()) 当月记号
---- datepart(dy,getdate()) 当年第几天

--select dateadd(day,-day(getdate())+1,getdate()) as fd,
--	dateadd(month,1,dateadd(day,-day(getdate()),getdate())) as ld
--from t1

-- 控制循环次数 option(maxrecursion 400) maxrecursion 


--with x (dy,fy)
--as (
--	select fd+delday,year(fd)
--	from (
--		select 
--			fd,
--			case when datepart(dw,fd) = 7 then 6
--				else 6-datepart(dw,fd) end as delday
--		from (
--			select 
--				dateadd(day,-datepart(dy,getdate())+1,getdate()) fd
--			from t1) z
--			) y
--	union all
--	select 
--		dy+7,
--		fy
--	from x 
--	where year(dy+7)=fy
--)
--select dy,fy,datename(dw,dy)
--from x
--option(maxrecursion 400)


-- 分完后再筛选的，不是分之前筛选
--with x (dy,mth,is_monday)
--as (
--	select 
--		dy,mth,case when datepart(dw,dy)=2  then 1 else 0 end
--	from (
--		select dateadd(day,1,dateadd(day,-day(getdate()),getdate())) dy,
--			month(getdate()) mth
--		from t1) tmp1
--	union all
--	select 
--		dateadd(day,1,dy),
--		mth,
--		case when datepart(dw,dateadd(day,1,dy))=2 then 1
--			else 0 end  
--	from x
--	where month(dy+1) = mth)
--select * 
--from x
--where is_monday = 1 


-- 9-3
--with x (dy,dm,mth,dw,wk)
--as (
--	select 
--		dy,
--		day(dy) dm,
--		datepart(m,dy) mth,
--		datepart(dw,dy) dw,
--		case when datepart(dw,dy) = 1 then datepart(ww,dy)-1	--第几周，处理第几排的问题
--			else datepart(ww,dy) end as wk
--	from (
--		select dateadd(day,(-day(getdate())+1),getdate()) dy
--		from t1
--	) z
--	union all 
--	select
--		dy+1,
--		day(dy+1),
--		mth,
--		datepart(dw,dy+1) dw,
--		case when datepart(dw,dy+1) = 1 then datepart(ww,dy+1)-1	--第几周，处理第几排的问题
--			else datepart(ww,dy+1) end as wk
--	from x
--	where month(dy+1) = mth)
--select 
--	max(case dw when 2 then dm end) as Mon,
--	max(case dw when 3 then dm end) as Tue,
--	max(case dw when 4 then dm end) as Wed,
--	max(case dw when 5 then dm end) as Thr,
--	max(case dw when 6 then dm end) as Fri,
--	max(case dw when 7 then dm end) as Sat,
--	max(case dw when 1 then dm end) as Sun
--from x
--group by wk
--order by wk
-- group by 查最大最小值时，找不到会返回null，第七章数值处理时出现过


-- dy,y年中日，wk，ww周，dw，w星期 ，day 月中日

--with x (fd,fy)
--as (
--	select fd,
--		year(fd)
--	from (
--		select dateadd(day,-datepart(dy,getdate())+1,getdate()) as fd
--	) z
--	union all 
--	select
--		dateadd(month,3,fd),
--		fy
--	from x
--	where year(dateadd(month,3,fd)) = fy
--)
--select
--	fd as startdate,
--	dateadd(month,3,fd)-1 as enddate
--from x

-- 9.9
--create table T9_9
--(YRQ int)
--insert into T9_9 
--select 20051 as yrq from t1 union all
--select 20052 as yrq from t1 union all
--select 20053 as yrq from t1 union all
--select 20054 as yrq from t1 

--select * from T9_9


-- 9.10 按要求的格式，必须用 with
--with x (sd,ed)
--as (
--	select 
--		dateadd(day,-1*datepart(dy,min(hiredate))+1,min(hiredate)) sd,
--		dateadd(year,1,dateadd(day,-datepart(dy,max(hiredate)),max(hiredate)))
--	from emp
--	union all
--	select
--		dateadd(month,1,sd),
--		ed
--	from x
--	where dateadd(mm,1,sd) < ed
--)
--select 
--	x.sd
--	,count(empno)
--from x
--left join emp on month(x.sd) = month(emp.hiredate) and year(x.sd) = year(emp.HIREDATE)
--group by sd
--order by 1



-- 9.13

--create table T9_13
--(
--EMPNO int,
--ENAME VARCHAR(50),
--PROJ_ID INT,
--PROJ_START DATE,
--PROJ_END DATE
--)

select * from T9_13

--insert into T9_13
--values 
--(7782,'CLARK',1,'2005-06-16','2005-06-18'),
--(7782,'CLARK',4,'2005-06-19','2005-06-24'),
--(7782,'CLARK',7,'2005-06-22','2005-06-24'),
--(7782,'CLARK',10,'2005-06-25','2005-06-28'),
--(7782,'CLARK',13,'2005-06-28','2005-07-02'),
--(7839,'KING',2,'2005-06-17','2005-06-21'),
--(7839,'KING',8,'2005-06-23','2005-06-25'),
--(7839,'KING',14,'2005-06-29','2005-06-30'),
--(7839,'KING',11,'2005-06-26','2005-06-27'),
--(7839,'KING',5,'2005-06-20','2005-06-24'),
--(7934,'MILLER',3,'2005-06-18','2005-06-22'),
--(7934,'MILLER',12,'2005-06-27','2005-06-28'),
--(7934,'MILLER',15,'2005-06-30','2005-07-03'),
--(7934,'MILLER',9,'2005-06-24','2005-06-27'),
--(7934,'MILLER',6,'2005-06-21','2005-06-23')


select *
from T9_13 a,T9_13 b
where a.empno = b.empno
	and b.PROJ_START >= a.PROJ_START
	and b.PROJ_START <= a.PROJ_END
	and a.PROJ_ID != b.PROJ_ID










