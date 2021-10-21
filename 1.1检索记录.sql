/* 1.1 检索所有行和列 */
-- 我觉得用于未知数据的检索
select *
from emp

-- 我觉得用于已知数据的交付
select empno,ename,job,sal,mgr,hiredate,comm,deptno
from emp


/* 1.2 筛选行 */ --筛选时，行和值挂钩，列和列名挂钩
select * 
from emp
where deptno != 10	-- != 和 <> 效果好像一样的

/* 1.3 查找满足多个查询条件的行 */	--这些个查询条件是否有优先级排序？
select *
from emp
where deptno = 10
	or comm is not null
	or sal <= 2000 and deptno = 20

/* 1.4 筛选列 */
select empno,ename 
from emp

/* 1.5 创建有意义的列名 */
select sal as salary,comm as commission
from emp

/* 1.6 在WHERE字句中引用别名列 */
select *
from (
	select sal as salary,comm as commission
	from emp) x
where salary < 5000

/* 1.7 串联多列的值 */	-- concat  字符合并展示 
select concat(ename,' WORK AS A ',JOB) AS MSG,
	CONCAT('THE SALARY OF ',ENAME,' IS ',SAL) AS MSG1
FROM EMP
WHERE DEPTNO = 10


/* 1.8 在SELECT语句里使用条件逻辑 */ --使得值可以按逻辑展示内容
select ename,sal,
	case when sal <= 2000 then 'UNDERPAID'
		WHEN SAL >= 4000 THEN 'OVERPAID'
		ELSE 'OK' 
	END AS 'STATUS'
from emp


/* 1.9 限定返回行数 */
SELECT TOP 5 * 
FROM EMP


/* 1.10 随机返回若干行记录 */	-- 随机几行
select top 5 ename,job
from emp
order by newid()

/* 1.11 查找null值 */ -- is null , is not null
select *
from emp
where comm is null

/* 1.12 把Null值转换为实际值 */	--coalesce 专门替换NULL值的库函数
select ename,coalesce(comm,0) as comm_new
from emp


/* 1.13 查找匹配项 */	--值在某个特定范围内 in，字符 用 like

select ename,job
from emp
where deptno in (10,20)

--从值上筛选，从列名上筛选
select ename,job	
from emp
where deptno in (10,20)
	and (ename like '%I%' or job like '%ER')

