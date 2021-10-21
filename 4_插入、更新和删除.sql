use model;

/*
1. 插入新记录；
2. 更新已有记录；
3. 删除不需要的记录
*/

/* 4.1 插入新记录 */
select * from T4_1
insert into T4_1(DEPTNO,dname,loc)
values(50,'PROGRAMMING','BALTIMORE')


/* 4.2 插入默认值 */
create table T4_2 (id integer default 0)
--create 之后，是没有值的
insert into T4_2 values(default)
--select * from T4_2

create table T4_2_1(id integer default 0, foo varchar(10))
insert into T4_2_1(foo) values ('Bar')
select * from T4_2_1	-- 能看到 id 自动生成了 


/* 4.3 使用Null 覆盖默认值 */
create table T4_3(id integer default 0, foo varchar(10))
insert into T4_3 values (Null,'Brighten')
select * from T4_3
insert into T4_3(foo) values ('Brighten')


/* 4.4 复制数据表到另一个表 */
create table T4_4
(
DEPTNO INT,
DNAME VARCHAR(50),
LOC VARCHAR(50)
)

insert into T4_4 (deptno,dname,loc)
select deptno,dname,loc
from dept 
where loc in ('NEW YORK','BOSTON')
SELECT * FROM T4_4

/* 4.5 复制表定义 */
select * 
into T4_5
from dept 
where 1 = 0	--为了不返回任何结果

select * from T4_5

/* 4.6 多表插入 */
-- SQL Server 好像不支持多表插入


/* 4.7 禁止插入特定行 */
create view V4_7 as 
select empno,ename,job
from emp

select * from V4_7

/* 4.8 更新记录 */
-- 有点严格，计算的时候可以 int * double 
-- 但返回的值，当初是设置int，结果就是int
-- 并且结果不是4舍5入的
-- 然而在select 预览结果的时候，是转换类型的


select deptno, ename, sal
from emp
where deptno = 20
order by 1,3

select * 
into T4_8
from emp

select * from T4_8

update T4_8
set sal = sal *1.1	
where deptno = 20

select * from T4_8
select * from emp

--更新之前，可以先select 预览一下
select deptno,
	ename,
	sal as orig_sal,
	sal * .1 as amt_to_sal,	
	sal * 1.1 as new_sal
from emp
where deptno = 20
order by 1,5

/* 4.9 当相关行存在时更新记录 */
-- 这类问题以后用 in 不用 exists，更加保险
select *
from emp_bonus,emp
where emp.empno = emp_bonus.EMPNO

DROP TABLE T4_9_EB
create table T4_9_EB
(
EMPNO INT,
HIREDATE DATE,
ENAME VARCHAR(50)
)

INSERT INTO T4_9_EB 
SELECT EMPNO,HIREDATE,ENAME
from emp
where empno in (7369,7900,7934)
--
select * from T4_9_EB

--DROP TABLE T4_9E
SELECT *
INTO T4_9E
FROM EMP

-- 更新表
update T4_9E 
set sal = sal * 1.2
where exists (
	select null 
	from T4_9_EB
	where T4_9E.empno = T4_9_EB.EMPNO)

-- 检查结果

SELECT * FROM EMP
SELECT * FROM T4_9E

SELECT M.ENAME,M.SAL 
FROM EMP M
WHERE M.SAL NOT IN (
SELECT SAL 
FROM T4_9E O
WHERE M.EMPNO = O.EMPNO)
UNION ALL
SELECT '---------',NULL
UNION ALL
SELECT M.ENAME,M.SAL 
FROM T4_9E M
WHERE M.SAL NOT IN (
SELECT SAL 
FROM EMP O
WHERE M.EMPNO = O.EMPNO)

/* 4.10 使用另一个表的数据更新记录 */

-- 创建被更新的数据源表
SELECT *
INTO T4_10E
FROM EMP

-- 创造更新类别表
create table T4_10ns
(DEPTNO INTEGER,
SAL INTEGER)

INSERT INTO T4_10ns
VALUES (10,4000)

-- 更新的写法
update e
	set e.sal = ns.sal,
		e.comm = ns.SAL/2
	from T4_10E e,T4_10ns ns
	where ns.DEPTNO = e.DEPTNO	--把查询结果传递给update语句的set字句

-- 更新数据
SELECT *
FROM T4_10E


/* 4.11 合并记录 */
--sql 做不到


/* 4.12 删除全表记录 */
-- delete from 
select * 
into T4_12E
from emp

--drop table T4_12
select * from T4_12E
-- 删除全部数据
delete from T4_12E
delete from emp

/* 4.13 删除指定记录 */
-- 删除指定记录
select *
into emp
from T4_13E

delete from T4_13E where deptno = 10

select * from T4_13E
select * from emp


/* 4.14 删除单行记录 */ 
select * 
into T4_14E
from emp

delete from T4_14E
where empno = 7782

select * from T4_14E


/* 4.15 删除违反参照完整性的记录 */
select *
into T4_15E
from emp

delete from T4_15E
where deptno not in  (
	select deptno
	from dept)

select * from T4_15E


/* 4.16 删除重复记录 */
create table dupes(id integer, name varchar(10))
insert into dupes values (1,'NAPOLEON')
insert into dupes values (2,'DYNAMITE')
insert into dupes values (3,'DYNAMITE')
insert into dupes values (4,'SHE SELLS')
insert into dupes values (5,'SEA SHELLS')
insert into dupes values (6,'SEA SHELLS')
insert into dupes values (7,'SEA SHELLS')

select * from dupes

delete from dupes
where id not in (select min(id) 
					from dupes 
					group by name)

/* 4.17 删除被其他表参照的记录 */
create table T4_17
(deptno integer,
accident_name varchar(20))

insert into T4_17 
values
(10,'BROKEN FOOT'),
(10,'FLESH WOUND'),
(20,'FIRE'),
(20,'FIRE'),
(20,'FLOOD'),
(30,'BRUISED GLUTE')

SELECT *
INTO T4_17E
FROM emp

delete from T4_17E
where deptno in (
	select deptno
	from T4_17
	group by deptno
	having count(*) >= 3)

select * from T4_17
select * from T4_17E
