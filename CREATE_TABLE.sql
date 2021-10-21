--CREATE DATABASE MYEXE	--失败
--USE MYEXE				--失败

USE MODEL;

-- drop table emp

/* create emp
create table emp
(
EMPNO int,
ENAME VARCHAR(50),
JOB VARCHAR(50),
MGR INT,
HIREDATE DATE,-- YYYY-MM-DD
SAL INT,
COMM INT,
DEPTNO INT
)
*/

/** create dept
create table dept
(
DEPTNO INT,
DNAME VARCHAR(50),
LOC VARCHAR(50)
)
*/

/** create t系列
create table t1
(ID int)

create table t10
(ID int)

create table t100
(ID int)

create table t500
(ID int)
*/

--drop table emp

select * 
from emp

select * 
from DEPT

select * 
from t100
/*
insert into emp
values 
(7369,'SMITH','CLERK',7902,'1980-12-17',800,NULL,20),
(7499,'ALLEN','SALESMAN',7698,'1981-2-20',1600,300,30),
(7521,'WARD','SALESMAN',7698,'1981-2-22',1250,500,30),
(7566,'JONES','MANAGER',7839,'1981-4-2',2975,NULL,20),
(7654,'MARTIN','SALESMAN',7698,'1981-09-28',1250,1400,30),
(7698,'BLAKE','MANAGER',7839,'1981-05-01',2850,NULL,30),
(7782,'CLARK','MANAGER',7839,'1981-1-9',2450,NULL,10),
(7788,'SCOTT','ANALYST',7566,'1982-12-09',3000,NULL,20),
(7839,'KING','PERSIDENT',NULL,'1981-11-17',5000,NULL,10),
(7844,'TURNER','SALESMAN',7698,'1981-9-8',1500,0,30),
(7876,'ADAMS','CLERK',7788,'1983-1-12',1100,NULL,20),
(7900,'JAMES','CLERK',7698,'1981-12-3',950,NULL,30),
(7902,'FORD','ANALYST',7566,'1981-12-3',3000,NULL,20),
(7934,'MILLER','CLERK',7782,'1982-1-23',1300,NULL,10)

INSERT INTO DEPT
VALUES
(10,'ACCOUNTING','NEW YORK'),
(20,'RESEARCH','DALLAS'),
(30,'SALES','CHICAGO'),
(40,'OPERATIONS','BOSTON') */

/** insert 值
insert into  t1
values
(1)

insert into  t10
values
(1),(2),(3),(4),(5),(6),(7),(8),(9),(10)
*/

/** create 3.3 的基础 view
create view V3_3
as 
select ename,job,sal
from emp
where job = 'CLERK'
*/

-- 3.4
/**
create table new_dept(deptno integer)
insert into new_dept values (10)
insert into new_dept values (50)
insert into new_dept values (null)
*/

-- 3.6
/**
create table emp_bonus(EMPNO integer,RECEIVED DATE,TYPE INTEGER)
insert into emp_bonus values (7369,'2005-3-14',1)
insert into emp_bonus values (7900,'2005-3-14',2)
insert into emp_bonus values (7788,'2005-3-14',3)
*/

-- 3.7
/**
create view V3_7
AS 
select * from emp where deptno != 10 
	union all
select * from emp where ename = 'WARD'
*/

-- 3.9
/**
create table T3_9
(EMPNO INT,
RECEIVED DATE,
TYPE INT)	*/

/*
INSERT INTO T3_9
values
(7934,'2005-3-17',1),
(7934,'2005-2-15',2),
(7839,'2005-2-15',3),
(7782,'2005-2-15',1)
*/

/*
create table T3_10
(EMPNO INT,
RECEIVED DATE,
TYPE INT)	
*/

/*
INSERT INTO T3_10
values
(7934,'2005-3-17',1),
(7934,'2005-2-15',2)
*/


/*
create table T3_11
(
EMPNO int,
ENAME VARCHAR(50),
JOB VARCHAR(50),
MGR INT,
HIREDATE DATE,-- YYYY-MM-DD
SAL INT,
COMM INT,
DEPTNO INT
)


insert into T3_11
values 
(7369,'SMITH','CLERK',7902,'1980-12-17',800,NULL,20),
(7499,'ALLEN','SALESMAN',7698,'1981-2-20',1600,300,30),
(7521,'WARD','SALESMAN',7698,'1981-2-22',1250,500,30),
(7566,'JONES','MANAGER',7839,'1981-4-2',2975,NULL,20),
(7654,'MARTIN','SALESMAN',7698,'1981-09-28',1250,1400,30),
(7698,'BLAKE','MANAGER',7839,'1981-05-01',2850,NULL,30),
(7782,'CLARK','MANAGER',7839,'1981-1-9',2450,NULL,10),
(7788,'SCOTT','ANALYST',7566,'1982-12-09',3000,NULL,20),
(7839,'KING','PERSIDENT',NULL,'1981-11-17',5000,NULL,10),
(7844,'TURNER','SALESMAN',7698,'1981-9-8',1500,0,30),
(7876,'ADAMS','CLERK',7788,'1983-1-12',1100,NULL,20),
(7900,'JAMES','CLERK',7698,'1981-12-3',950,NULL,30),
(7902,'FORD','ANALYST',7566,'1981-12-3',3000,NULL,20),
(7934,'MILLER','CLERK',7782,'1982-1-23',1300,NULL,10)

insert into T3_11 (empno,ename,job,mgr,hiredate,sal,comm,deptno)
select 1111,'YODA','JEDI',null,hiredate,sal,comm,null
from emp
where ename = 'KING'
*/

/**
create table T4_1
(
DEPTNO INT,
DNAME VARCHAR(50),
LOC VARCHAR(50)
)

INSERT INTO T4_1
VALUES
(10,'ACCOUNTING','NEW YORK'),
(20,'RESEARCH','DALLAS'),
(30,'SALES','CHICAGO'),
(40,'OPERATIONS','BOSTON')	*/

/**
insert into  t100
values
(1),
(2),
(3),
(4),
(5)*/



create emp
create table emp
(
EMPNO int,
ENAME VARCHAR(50),
JOB VARCHAR(50),
MGR INT,
HIREDATE DATE,-- YYYY-MM-DD
SAL INT,
COMM INT,
DEPTNO INT
)


insert into T3_11
values 
(7369,'SMITH','CLERK',7902,'1980-12-17',800,NULL,20),
(7499,'ALLEN','SALESMAN',7698,'1981-2-20',1600,300,30),
(7521,'WARD','SALESMAN',7698,'1981-2-22',1250,500,30),
(7566,'JONES','MANAGER',7839,'1981-4-2',2975,NULL,20),
(7654,'MARTIN','SALESMAN',7698,'1981-09-28',1250,1400,30),
(7698,'BLAKE','MANAGER',7839,'1981-05-01',2850,NULL,30),
(7782,'CLARK','MANAGER',7839,'1981-1-9',2450,NULL,10),
(7788,'SCOTT','ANALYST',7566,'1982-12-09',3000,NULL,20),
(7839,'KING','PERSIDENT',NULL,'1981-11-17',5000,NULL,10),
(7844,'TURNER','SALESMAN',7698,'1981-9-8',1500,0,30),
(7876,'ADAMS','CLERK',7788,'1983-1-12',1100,NULL,20),
(7900,'JAMES','CLERK',7698,'1981-12-3',950,NULL,30),
(7902,'FORD','ANALYST',7566,'1981-12-3',3000,NULL,20),
(7934,'MILLER','CLERK',7782,'1982-1-23',1300,NULL,10)