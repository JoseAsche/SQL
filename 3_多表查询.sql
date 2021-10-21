use model
/* 3.1 叠加两个行集 */
-- union

-- 表叠加，虽然没有相同的键，但类型要相同
SELECT
	ename AS ename_and_dname,
	deptno 
FROM
	emp 
WHERE
	deptno = 10 UNION ALL
SELECT
	'---------',
	NULL --null 是为了对齐其他列
	
FROM`
	t1 UNION ALL
SELECT
	dname,
	deptno 
FROM
	dept

-- union 可以过滤重复项
-- 使用上类似于 distinct 
-- 使用前最好排个序
-- 除非必要，否则与 distinct 一样，最好别用

SELECT
	dname,
	deptno 
FROM
	dept UNION 
SELECT
	dname,
	deptno 
FROM
	dept

/* 3.2 合并相关行 */
-- inner join

-- 等值的内连接
select e.ename,d.loc
from emp e,dept d
where e.deptno = d.deptno
	and e.deptno = 10

--生成笛卡尔积的内连接
--所以原理是从笛卡尔积上选取所需部分？
select e.ename,d.loc
from emp e,dept d
where e.deptno = 10

--显示表达关系
select e.ename,d.loc
from emp e inner join  dept d
	on (e.deptno = d.deptno)
where e.deptno = 10

/* 3.3 查找两个表中相同的行 */
--select * from V3_3

select e.empno,e.ename,e.job,e.sal,e.deptno
from emp e,V3_3 v
where e.ename = v.ename
	and e.job = v.job
	and e.sal = v.sal

-- 两者的区别在哪？
select e.empno,e.ename,e.job,e.sal,e.deptno
from emp e join V3_3 v
on (e.ename = v.ename
	and e.job = v.job
	and e.sal = v.sal)

/* 3.4 只存在于一个表中的数据 */ -- 考虑到有Null时，取相等值，再取not exists 同 3.7
select deptno 
from dept
where deptno not in (select deptno from emp)

-- 要注意，不是主键的内容要排除重复项
select distinct deptno
from dept
where deptno not in (select deptno from emp)

-- not in 有 null 时，查不到任何值
select *
from dept
where deptno not in (select deptno from new_dept)

-- in 本质上是 or 运算
-- true or null 返回 true ，但 false or null 返回 null
-- 为了避免 not in 与 null 带来的问题，可以结合使用 not exists 和 
select d.deptno
from dept d		-- 无返回
where not exists (	
	select case when deptno is null then 0 
		else deptno end deptno 
	from new_dept)

select d.deptno
from dept d		
where d.deptno not in  (	
	select case when deptno is null then 0 
		else deptno end deptno 
	from new_dept)

select d.deptno,d.loc
from dept d		
where not exists  (	
	select *
	from new_dept nd
	where nd.deptno = d.DEPTNO)

-- 结果一样
-- 之后用这个方案

select d.deptno,d.loc
from dept d		
where d.DEPTNO not in  (	
	select null
	from new_dept nd
	where nd.deptno = d.DEPTNO)

--
select d.deptno,d.loc
from dept d
where not exists(
	select null
	from emp e
	where d.DEPTNO = e.DEPTNO)
-- 原理，首先，括号内先有表连接
-- 两者都有的行 返回Null ,not exists 判断为 False ，舍弃该行
-- dept 有的行，not exists 返回 true，与 Null 返回 结果行
-- （非 Null 则正常的返回 not exists）

/* 3.5 从一个表检索与另一个表不相关的行 */
-- outer  join 
--连接并保留不匹配项
select *
from dept d 
left outer join emp e on d.DEPTNO = e.DEPTNO
where e.DEPTNO is null	-- 逻辑上，就是先连接表，再筛选

-- inner join 是等值连接，so deptno = 40 被舍弃
select *
from dept d 
inner join emp e on d.DEPTNO = e.DEPTNO
where e.DEPTNO is null	

 
/* 3.6 新增连接查询而不影响其他连接查询 */
-- outer join

select * from emp_bonus

select e.ename,d.loc
from emp e,dept d
where e.DEPTNO = d.DEPTNO

-- 这种写法是 inner join 的逻辑吧
select e.ename,d.loc,eb.RECEIVED
from emp e,dept d,emp_bonus eb
where e.DEPTNO = d.DEPTNO
	and e.EMPNO = eb.EMPNO

-- 有额外信息，且不丢失原有数据
select e.ename,d.loc,eb.RECEIVED
from emp e join dept d on e.DEPTNO = d.DEPTNO
	left join emp_bonus eb on e.EMPNO = eb.EMPNO
order by 2,1

/* 3.7 确定两个表是否有相同的数据 */
-- select from where not exists  from (select null from  where ) union all

SELECT * 
FROM (
	SELECT e.empno,e.ename,e.job,e.mgr,e.hiredate,e.sal,e.comm,e.deptno,COUNT ( * ) AS cnt 
	FROM emp e 
	GROUP BY empno,ename,job,mgr,hiredate,sal,comm,deptno) e 
WHERE NOT EXISTS ( 
	SELECT NULL 
	FROM (
		SELECT v.empno,v.ename,v.job,v.mgr,v.hiredate,v.sal,v.comm,v.deptno,COUNT ( * ) AS cnt --风险，或者说区别在这
		FROM V3_7 v 
		GROUP BY empno,ename,job,mgr,hiredate,sal,comm,deptno) v 
	WHERE v.empno = e.empno 
		AND v.ename = e.ename 
		AND v.job = e.job 
		AND v.mgr = e.mgr 
		AND v.hiredate = e.hiredate 
		AND v.sal = e.sal 
		AND v.deptno = e.deptno 
		AND v.cnt = e.cnt 
	AND COALESCE ( v.comm, 0 ) = COALESCE ( e.comm, 0 ) 
)
	union all 
select *
from (
	select v.empno,v.ename,v.job,v.mgr,v.hiredate,v.sal,v.comm,v.deptno,count(*) as cnt
	from V3_7 v
	group by empno,ename,job,mgr,hiredate,sal,comm,deptno) v
where not exists (
	select null
	from (
		select  e.empno,e.ename,e.job,e.mgr,e.hiredate,e.sal,e.comm,e.deptno,COUNT ( * ) AS cnt 
		from emp e
		GROUP BY empno,ename,job,mgr,hiredate,sal,comm,deptno ) e
	WHERE v.empno = e.empno 
		AND v.ename = e.ename 
		AND v.job = e.job 
		AND v.mgr = e.mgr 
		AND v.hiredate = e.hiredate 
		AND v.sal = e.sal 
		AND v.deptno = e.deptno 
		AND v.cnt = e.cnt
		AND COALESCE ( v.comm, 0 ) = COALESCE ( e.comm, 0 ) 
)
--union 来筛掉相同项
select *
from emp
union 
select *
from V3_7


/* 3.8 识别并消除笛卡尔积 */
select e.ename,d.loc
from emp e
join dept d on e.DEPTNO = d.DEPTNO
where e.DEPTNO = 10

--笛卡尔积常用于变换
--展开结果集时，生成一系列值
--模拟loop循环
select e.ENAME,d.loc
from emp e,dept d
where e.DEPTNO = 10
	--and e.DEPTNO = d.DEPTNO


/* 3.9 组合使用连接查询与聚合函数 */
-- sql server 内，distinct 不能和 over并用
-- sum 之后，其他同列项要 group by ，具体可能要学到聚合函数才知道

-- OVER 子句不允许使用 DISTINCT。因此没法按书本的内容做
-- 为了AC，则在可能出现重复项的地方distinct

select DEPTNO,sum(sal) as total_sal,sum(bonus) as total_bonus
from (
select e.empno,e.ename,e.sal,e.deptno,
	sal*case when eb.TYPE = 1 then .1
		when eb.TYPE = 2 then .2
		when eb.TYPE = 3 then .3
		end as bonus
from emp e,T3_9 eb
where e.empno = eb.EMPNO	
	and e.DEPTNO = 10	) x
GROUP BY deptno

-- 处理重复项
select distinct deptno,
	total_sal,
	total_bonus
from (
	select e.empno,
		e.ename,
		sum(distinct e.sal) over	--
		(partition by e.deptno) as total_sal,
		e.deptno,
		sum(e.sal*case when eb.type = 1 then .1
				when eb.type = 2 then .2
				else .3 end) over
		(partition by deptno) as total_bonus
	from emp e,T3_9 eb
	where e.empno = eb.empno
		and e.deptno = 10 ) x


-- 聚合函数 没接触过
select e.deptno,
	sum(distinct sal) as total_sal,
	sum(e.sal*case when eb.type = 1 then .1
				when eb.type = 2 then .2
				else .3 end) as total_bonus
from emp e,T3_9 eb
where e.empno =  eb.empno
	and e.deptno = 10
group by deptno


/* 3.10 组合使用外连接查询与聚合函数 */


-- 内连接直接排除了与 eb 不相等的数据，因此目标需要用外连接
-- 除非可以用 sum( distinct ...)over 

select * from T3_10

select e.deptno,
	sum(distinct sal) as total_sal,
	sum(distinct e.sal*case when eb.type = 1 then .1
				when eb.type = 2 then .2
				else .3 end) as total_bonus
from emp e,T3_10 eb
where e.empno =  eb.empno
	and e.deptno = 10
group by deptno

--外连接
select e.deptno,
	sum(distinct sal) as total_sal,
	sum(distinct e.sal*case when eb.type = 1 then .1
				when eb.type = 2 then .2
				else .3 end) as total_bonus
from emp e
left join T3_10 eb on e.empno =  eb.empno
where e.deptno = 10
group by deptno


/* 3.11 从多个表中返回缺失值 */
-- full outer join == left join union right join

-- 错误示范
select d.deptno,d.dname,e.ENAME
from dept d 
right join T3_11 e on d.deptno = e.DEPTNO	-- 这里是right join

--full outer join <==> left join union right join
select d.DEPTNO,d.DNAME,e.ename
from dept d
full join T3_11 e on d.DEPTNO = e.DEPTNO


/* 3.12 在运算和比较中使用Null */	
-- coalesce 可以写在后面作为筛选条件

select ename,comm
from emp
where coalesce(comm,0)	-- false or null => null
	< ( select comm	
		from emp
		where ename = 'WARD')

select ename,comm,coalesce(comm,0)
from emp
where coalesce(comm,0)	-- false or null => null
	< ( select comm	
		from emp
		where ename = 'WARD')

