use model;
/*
/* 7.1 计算平均数 */
-- 员工平均工资
select avg(sal*1.0) as AVG_SAL
from emp

-- 部门平均工资
select deptno,avg(sal*1.0) as AVG_SAL
from emp
group by deptno

-- avg 会忽略掉null，影响作为分母的除数
-- 处理方法：使用 coalesce(sal,0) 将null转换成0


/* 7.2 查找最小值和最大值 */
select deptno, 
	min(sal) as min_sal,
	max(sal) as max_sal
from emp
group by deptno

-- 无则返回null
select min(comm),max(comm)
from emp
group by deptno


/* 7.3 求和 */
select sum(sal) as total_for_dept
from emp
group by deptno


/* 7.4 计算行数 */
select deptno,count(sal) as Dnum,sum(sal) as total_for_dept
from emp
group by deptno
-- 会忽略掉 null 项，造成计数不准

select 
	count(*),				-- 只要那一行有东西就会进行一次计数
	count(deptno),
	count(comm),
	count('hello world')	-- 效果同 *
from emp
group by deptno

-- 测试count(*) 是否统计
create table T7_4
(	id int,
	v1 int,
	v2 int,
	v3 int,
	v4 int,
	v5 int)
insert into T7_4
values
(null,null,null,null,null,null)
(null,1,2,3,4,5)
(1,1,2,3,null,null),
(2,1,2,null,null,5),
(3,1,2,3,null,null),
(4,1,null,null,4,null),
(5,1,null,3,null,null),
(6,null,2,null,4,null)
--
select * from T7_4
select count(*) from T7_4	-- 全选时，也会统计null
select count(id) from T7_4	-- 单独列名时，会忽视null


/* 7.5 计算非Null值的个数 */
select count(comm)
from emp


/* 7.6 累计求和 */
--按小到大显示累计额
select 
	e.empno,
	e.ename,
	e.sal,
	(
		select sum(d.sal)			
		from emp d					-- 生成了笛卡尔积？？？
		where d.empno <= e.empno	-- 求和按照 empno 来排序
	) as running_total
from emp e
order by 4

select e.ename as ename1,
	e.empno as empno1,
	e.sal as sal1,
	d.ename as ename2,
	d.empno as empno2,
	d.sal as sal2
from emp e, emp d
where d.empno <= e.empno
	and e.empno = 7934


/* 7.7 计算累计乘积 */
select 
	e.empno,
	e.ename,
	e.sal,
	(
	select 
		exp(sum(log(d.sal*1.0/1000)))	--避免中间存在溢出
	from emp d
	where d.empno <= e.empno
		and e.deptno = d.deptno
	)
	as running_prod
from emp e
where e.deptno = 10
-- order by sal

select exp(log(100))


/* 7.8 计算累计差 */
-- 不能在内置函数内排序，如果有特殊要求要先排序再计算
select 
	a.empno,
	a.ename,
	a.sal,
	(
	select 
		case when a.empno = min(b.empno) then sum(-b.sal)
		else sum(-sal)
		end
	from emp b
	where b.empno <= a.empno
		and b.deptno = a.deptno
	) as rnk
from emp a
where a.deptno = 10

select a.empno as Aempno,
	b.empno as Bempno,
	a.DEPTNO as Adeptno,
	b.DEPTNO as Bdeptno
from emp a,emp b
where b.empno <= a.empno
	and b.deptno = a.deptno


/* 7.9 计算众数 */
select sal 
from (
	select 
		sal,
		dense_rank() over (order by cnt desc) as rnk	--
	from (
		select 
			sal,
			count(*) cnt
		from emp
		where deptno = 20
		group by sal
	) x
) y 
where rnk = 1


/* 7.10 计算中位数 */
select avg(sal)	-- 偶数个的情况下，中间两个数取平均
from (
	select
		sal,
		count(*) over() total,
		cast(count(*) over() as decimal)/2 mid,
		ceiling(cast(count(*) over() as decimal)/2) next,
		ROW_NUMBER() over(order by sal) rn
	from emp
	where deptno = 30
) x
where ( total % 2 = 0 and rn in ( mid, mid + 1))
	or (total % 2 = 1 and rn = next)

/*
ROUND() – 四舍五入一个正数或者负数，结果为一定长度的值。
CEILING() - 返回最小的整数，使这个整数大于或等于指定数的数值运算。
FLOOR() - 返回最大整数，使这个整数小于或等于指定数的数值运算。
*/

/* 7.11 计算百分比 */
-- deptno = 10 的部门工资占比
select
	distinct cast(d10 as decimal)/total * 100 as pct
from (
	select 
		deptno,
		sum(sal) over() as total,
		sum(sal) over (partition by deptno) d10 
	from emp
) x
where deptno = 10


/* 7.12 聚合Null列 */
-- 聚合函数会自动忽略掉null
select avg(coalesce(comm,0)) as avg_comm
from emp
where deptno = 30


/* 7.13 计算平均值时去掉最大值和最小值 */
select avg(sal)
from (
	select 
		sal,
		min(sal) over() min_sal,	--聚合函数附带 用 over
		max(sal) over() max_sal
	from emp
) x
where sal not in (min_sal,max_sal)


/* 7.14 将含有字母和数字的字符串转换为数字 */
select 
	replace(trim(translate('paul123f321','qwertyuiopasdfghjklzxcvbnm','                          ')),' ','') as num
from t1


/* 7.15 修改累计值 */
create view V7_15(id,amt,trx)
as 
select 1,100,'PR' from t1 union all
select 2,100,'PR' from t1 union all
select 3,50,'PY' from t1 union all
select 4,100,'PR' from t1 union all
select 5,200,'PY' from t1 union all
select 6,50,'PY' from t1

select * from V7_15
--
select 
	case when v1.trx = 'PY' THEN 'PAYMENT'
		ELSE 'PURCHASE' END AS trx_type,
	v1.amt,
	(select 
		sum(
			case when v2.trx = 'PY' then -v2.amt
				else v2.amt 
				end
			)
	from V7_15 v2
	where v2.id <= v1.id	-- 和上面的例子比，不需要选区，但累计则需要有此不等式
	) as balance
from V7_15 v1
*/


/* 7.1 计算平均值 */
select avg(sal) as avg_sal
from emp 

/* 7.2 查找最小值和最大值 */
select 
	min(sal) as min_sal,
	max(sal) as max_sal
from emp

/* 7.3 求和 */
select sum(sal)
from emp

/* 7.4 计算行数 */
select count(*)
from emp

/* 7.5 计算非Null值的个数 */
select count(comm)
from emp

/* 7.6 累计求和 */
select e.ename,e.sal,
	(select sum(d.sal) from emp d where d.empno <= e.empno) as running_total
from emp e

select 
	e.ename,
	e.sal,
	(select sum(d.sal) from emp d where d.empno <= e.empno)
from emp e

/* 7.7 计算累计乘积 */	-- sum(log)再exp 就得到 累积
select 
	e.ename,
	e.sal,
	(select exp(sum(log(d.sal))) from emp d where d.empno <= e.empno)
from emp e


/* 7.8 计算累计差 */ -- 可能要用到with 才行
-- 子查询中不能用order by

/* 7.9 计算众数 */

select sal
from (
	select sal,
		dense_rank() over(order by cnt desc) as rnk
	from (
		select sal,count(*) as cnt
		from emp
		where deptno = 20
		group by sal ) x
		)y
where rnk = 1


/* 7.10 计算中位数 */
/* 7.11 计算百分比 */
/* 7.12 聚合Null列 */
/* 7.13 计算平均值时去掉最大值和最小值 */
/* 7.14 将含有字母和数字的字符串转换为数字 */
/* 7.15 修改累计值 */ 
