use model;

/*
1. �����¼�¼��
2. �������м�¼��
3. ɾ������Ҫ�ļ�¼
*/

/* 4.1 �����¼�¼ */
select * from T4_1
insert into T4_1(DEPTNO,dname,loc)
values(50,'PROGRAMMING','BALTIMORE')


/* 4.2 ����Ĭ��ֵ */
create table T4_2 (id integer default 0)
--create ֮����û��ֵ��
insert into T4_2 values(default)
--select * from T4_2

create table T4_2_1(id integer default 0, foo varchar(10))
insert into T4_2_1(foo) values ('Bar')
select * from T4_2_1	-- �ܿ��� id �Զ������� 


/* 4.3 ʹ��Null ����Ĭ��ֵ */
create table T4_3(id integer default 0, foo varchar(10))
insert into T4_3 values (Null,'Brighten')
select * from T4_3
insert into T4_3(foo) values ('Brighten')


/* 4.4 �������ݱ���һ���� */
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

/* 4.5 ���Ʊ��� */
select * 
into T4_5
from dept 
where 1 = 0	--Ϊ�˲������κν��

select * from T4_5

/* 4.6 ������ */
-- SQL Server ����֧�ֶ�����


/* 4.7 ��ֹ�����ض��� */
create view V4_7 as 
select empno,ename,job
from emp

select * from V4_7

/* 4.8 ���¼�¼ */
-- �е��ϸ񣬼����ʱ����� int * double 
-- �����ص�ֵ������������int���������int
-- ���ҽ������4��5���
-- Ȼ����select Ԥ�������ʱ����ת�����͵�


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

--����֮ǰ��������select Ԥ��һ��
select deptno,
	ename,
	sal as orig_sal,
	sal * .1 as amt_to_sal,	
	sal * 1.1 as new_sal
from emp
where deptno = 20
order by 1,5

/* 4.9 ������д���ʱ���¼�¼ */
-- ���������Ժ��� in ���� exists�����ӱ���
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

-- ���±�
update T4_9E 
set sal = sal * 1.2
where exists (
	select null 
	from T4_9_EB
	where T4_9E.empno = T4_9_EB.EMPNO)

-- �����

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

/* 4.10 ʹ����һ��������ݸ��¼�¼ */

-- ���������µ�����Դ��
SELECT *
INTO T4_10E
FROM EMP

-- �����������
create table T4_10ns
(DEPTNO INTEGER,
SAL INTEGER)

INSERT INTO T4_10ns
VALUES (10,4000)

-- ���µ�д��
update e
	set e.sal = ns.sal,
		e.comm = ns.SAL/2
	from T4_10E e,T4_10ns ns
	where ns.DEPTNO = e.DEPTNO	--�Ѳ�ѯ������ݸ�update����set�־�

-- ��������
SELECT *
FROM T4_10E


/* 4.11 �ϲ���¼ */
--sql ������


/* 4.12 ɾ��ȫ���¼ */
-- delete from 
select * 
into T4_12E
from emp

--drop table T4_12
select * from T4_12E
-- ɾ��ȫ������
delete from T4_12E
delete from emp

/* 4.13 ɾ��ָ����¼ */
-- ɾ��ָ����¼
select *
into emp
from T4_13E

delete from T4_13E where deptno = 10

select * from T4_13E
select * from emp


/* 4.14 ɾ�����м�¼ */ 
select * 
into T4_14E
from emp

delete from T4_14E
where empno = 7782

select * from T4_14E


/* 4.15 ɾ��Υ�����������Եļ�¼ */
select *
into T4_15E
from emp

delete from T4_15E
where deptno not in  (
	select deptno
	from dept)

select * from T4_15E


/* 4.16 ɾ���ظ���¼ */
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

/* 4.17 ɾ������������յļ�¼ */
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
