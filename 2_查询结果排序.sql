use model;
/* 2.1 ��ָ��˳�򷵻ز�ѯ��� */	--order by 1 asc,desc
select ename,job,sal
from emp
where deptno = 10
order by sal asc -- �͵��� asc�� �ߵ��� desc

--ѡ��˳���� ����
select ename,job,sal
from emp
where deptno = 10
order by 3

/* 2.2 ���ֶ����� */ 
--order by ���ṩ�������Ⱥ������������
select empno,deptno,ename,sal,job
from emp
order by deptno, empno desc

/* 2.3 �����Ӵ����� */ 
--substring�����ַ����ݵĲ�ͬλ�ý�������	
select ename,job
from emp
order by substring(job,len(job)-2,2)	-- len ѡ���ȥ�� n - 1����n �ͳ���ĩβ

select ename,job
from emp
order by substring(job,len(job)-2,3)	--����Ӧ�ö���һ���߼������ߴ��ˣ��������ԭ��������

select substring('abcdef',len('abcdef') - 3,2)
select len('abcdef')

/* 2.4 �Ժ�����ĸ�����ֵ������� */
--create view V
--as 
-- ���� deptno ����
select concat(ename,' ',deptno) as data
from emp
order by cast(replace(trim(translate(concat(ename,' ',deptno),'QWERTYUIOPASDFGHJKLZXCVBNM','aaaaaaaaaaaaaaaaaaaaaaaaaa')),'a','') as int)

--�� sql ��������Ҫ �Ƚ� ��������ת��Ϊ �ַ��ͺţ��� ���� + ����
--������ concat Ч����һ��
--create view V
--as 
-- ����ename����
select ename + ' '+ cast(deptno as varchar(20))as data
from emp
order by replace(trim(translate(concat(ename,' ',deptno),'123456789','000000000')),'0','')

select * from V

/* 2.5 ����ʱ��Nullֵ�Ĵ��� */	--������ Oracle����Ȼ�� null ��ص��н���������Ҫ��� null��������������
select ename,sal,comm
from emp 
order by 3

select ename,sal,comm
from emp 
order by 3 desc
-- ����Ҫ null ���� ���� ���� ǰ����ٸ�����������
select ename,sal,comm
from ( 
	select ename,sal,comm,
		case when comm is null then 0
			else 1
			end as is_null
	from emp
	) x
order by is_null desc,comm

-- 
select ename,sal,comm
from ( 
	select ename,sal,comm,
		case when comm is null then 0
			else 1
			end as is_null
	from emp
	) x
order by is_null desc ,comm desc

/* 2.6 ���������߼���̬���������� */ -- ��order by���� case when
select ename,sal,job,comm
from emp
order by case when job = 'SALESMAN' then comm
	else sal end