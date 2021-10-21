/* 1.1 ���������к��� */
-- �Ҿ�������δ֪���ݵļ���
select *
from emp

-- �Ҿ���������֪���ݵĽ���
select empno,ename,job,sal,mgr,hiredate,comm,deptno
from emp


/* 1.2 ɸѡ�� */ --ɸѡʱ���к�ֵ�ҹ����к������ҹ�
select * 
from emp
where deptno != 10	-- != �� <> Ч������һ����

/* 1.3 ������������ѯ�������� */	--��Щ����ѯ�����Ƿ������ȼ�����
select *
from emp
where deptno = 10
	or comm is not null
	or sal <= 2000 and deptno = 20

/* 1.4 ɸѡ�� */
select empno,ename 
from emp

/* 1.5 ��������������� */
select sal as salary,comm as commission
from emp

/* 1.6 ��WHERE�־������ñ����� */
select *
from (
	select sal as salary,comm as commission
	from emp) x
where salary < 5000

/* 1.7 �������е�ֵ */	-- concat  �ַ��ϲ�չʾ 
select concat(ename,' WORK AS A ',JOB) AS MSG,
	CONCAT('THE SALARY OF ',ENAME,' IS ',SAL) AS MSG1
FROM EMP
WHERE DEPTNO = 10


/* 1.8 ��SELECT�����ʹ�������߼� */ --ʹ��ֵ���԰��߼�չʾ����
select ename,sal,
	case when sal <= 2000 then 'UNDERPAID'
		WHEN SAL >= 4000 THEN 'OVERPAID'
		ELSE 'OK' 
	END AS 'STATUS'
from emp


/* 1.9 �޶��������� */
SELECT TOP 5 * 
FROM EMP


/* 1.10 ������������м�¼ */	-- �������
select top 5 ename,job
from emp
order by newid()

/* 1.11 ����nullֵ */ -- is null , is not null
select *
from emp
where comm is null

/* 1.12 ��Nullֵת��Ϊʵ��ֵ */	--coalesce ר���滻NULLֵ�Ŀ⺯��
select ename,coalesce(comm,0) as comm_new
from emp


/* 1.13 ����ƥ���� */	--ֵ��ĳ���ض���Χ�� in���ַ� �� like

select ename,job
from emp
where deptno in (10,20)

--��ֵ��ɸѡ����������ɸѡ
select ename,job	
from emp
where deptno in (10,20)
	and (ename like '%I%' or job like '%ER')

