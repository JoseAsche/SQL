use model;

/* 8.1 年月日加减法 */
select 
	dateadd(day,-5,hiredate) as hd_minus_5D,
	dateadd(day,5,hiredate) as hd_plus_5D,
	dateadd(month, -5,hiredate) as hd_minus_5M,
	dateadd(month,5,hiredate) as hd_plus_5M,
	dateadd(year,-5,hiredate) as hd_minus_5Y,
	dateadd(year,5,hiredate) as hd_plus_5DY
from emp
where deptno = 10


/* 8.2 计算两个日期之间的天数 */
select datediff(day,allen_hd,ward_hd)
from (
	select hiredate as ward_hd
	from emp
	where ename = 'WARD'
) x,
( 
	select hiredate as allen_hd
	from emp
	where ename = 'ALLEN'
) y


/* 8.3 计算两个日期之间的工作日天数 */
select 
	sum(
		case when datename(dw,jones_hd + t500.id - 1) in ('SATURDAY','SUNDAY') then 0 else 1 end) as days
from (
	select 
		max(case when ename = 'BLAKE' then hiredate end) as blake_hd,
		max(case when ename = 'JONES' then hiredate end) as jones_hd
	from emp
	where ename in ('BLAKE','JONES')
) x, t500
where t500.id <= datediff(day,jones_hd  - blake_hd) + 1


select 
		datename(dw,jones_hd),
		case when datename(dw,jones_hd) in ('SATURDAY','SUNDAY') then 0 else 1 end 
from (
	select 
		max(case when ename = 'BLAKE' then hiredate end) as blake_hd,
		max(case when ename = 'JONES' then hiredate end) as jones_hd
	from emp
	where ename in ('BLAKE','JONES')
) x, t500
where t500.id <= datediff(day,jones_hd, blake_hd) + 1

create function damiao(@beginday datetime,@endday datetime)
returns int as begin
declare @caldays int
declare @id int
select @caldays = 0
	while datediff(d,@beginday,@endday) >= 0
		begin
			if datepart(dw,@beginday) > 1 and datepart(dw,@beginday) < 7
			begin
				select @caldays = @caldays + 1
			end 
			select @beginday = datediff(day,1,@beginday)
		end 
	return @caldays
end 




/* 8.4 计算两个日期之间相差的月份和年份 */
select
	datediff(month,min_hd,max_hd) as Cmonth,
	datediff(year,min_hd,max_hd) as Cyear,			-- 不太准确，差14个月，这里会返回一年
	datediff(month,min_hd,max_hd)/12.0 as Cyear1,	-- 逻辑上，用次低单位时间 除以周期大小比较合理
	min_hd,
	max_hd
from (
	select min(hiredate) min_hd,max(hiredate) max_hd 
	from emp
) x

select datediff(year,'1995-08-18','1996-10-01')


/* 8.5 计算两个日期之间相差的秒数、分钟数和小时数 */
select 
	datediff(day,allen_hd,ward_hd)*24 ehr,
	datediff(day,allen_hd,ward_hd)*24*60 emin,
	datediff(day,allen_hd,ward_hd)*24*60*60 esec
from (
	select 
		max(case when ename = 'WARD' then hiredate end) as ward_hd,
		max(case when ename = 'ALLEN' then hiredate end) as allen_hd	
	from emp
) x
	

/* 8.6 统计一年中有多少个星期一 */
with x (start_date,end_date)
as (
	select start_date,
		dateadd(year,1,start_date) end_date
	from (
		select cast(cast(year(getdate()) as varchar) + '-01-01' as datetime) start_date
		from t1) tmp
	union all 
	select dateadd(day,1,start_Date),	-- 循环计算部分？
		end_date						-- enddate一直不变
	from x
	where dateadd(day,1,start_date) < end_date
)
select datename(dw,start_date),count(*)
from x
group by datename(dw,start_date)
option(maxrecursion 377)	-- 设置最大递归范围，如果不设置，系统默认最大为100？


/* 8.7 计算当前记录和下一条记录之间的日期差 */
  



