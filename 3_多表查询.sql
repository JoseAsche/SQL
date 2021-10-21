use model
/* 3.1 ���������м� */
-- union

-- ����ӣ���Ȼû����ͬ�ļ���������Ҫ��ͬ
SELECT
	ename AS ename_and_dname,
	deptno 
FROM
	emp 
WHERE
	deptno = 10 UNION ALL
SELECT
	'---------',
	NULL --null ��Ϊ�˶���������
	
FROM`
	t1 UNION ALL
SELECT
	dname,
	deptno 
FROM
	dept

-- union ���Թ����ظ���
-- ʹ���������� distinct 
-- ʹ��ǰ����Ÿ���
-- ���Ǳ�Ҫ�������� distinct һ������ñ���

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

/* 3.2 �ϲ������ */
-- inner join

-- ��ֵ��������
select e.ename,d.loc
from emp e,dept d
where e.deptno = d.deptno
	and e.deptno = 10

--���ɵѿ�������������
--����ԭ���Ǵӵѿ�������ѡȡ���貿�֣�
select e.ename,d.loc
from emp e,dept d
where e.deptno = 10

--��ʾ����ϵ
select e.ename,d.loc
from emp e inner join  dept d
	on (e.deptno = d.deptno)
where e.deptno = 10

/* 3.3 ��������������ͬ���� */
--select * from V3_3

select e.empno,e.ename,e.job,e.sal,e.deptno
from emp e,V3_3 v
where e.ename = v.ename
	and e.job = v.job
	and e.sal = v.sal

-- ���ߵ��������ģ�
select e.empno,e.ename,e.job,e.sal,e.deptno
from emp e join V3_3 v
on (e.ename = v.ename
	and e.job = v.job
	and e.sal = v.sal)

/* 3.4 ֻ������һ�����е����� */ -- ���ǵ���Nullʱ��ȡ���ֵ����ȡnot exists ͬ 3.7
select deptno 
from dept
where deptno not in (select deptno from emp)

-- Ҫע�⣬��������������Ҫ�ų��ظ���
select distinct deptno
from dept
where deptno not in (select deptno from emp)

-- not in �� null ʱ���鲻���κ�ֵ
select *
from dept
where deptno not in (select deptno from new_dept)

-- in �������� or ����
-- true or null ���� true ���� false or null ���� null
-- Ϊ�˱��� not in �� null ���������⣬���Խ��ʹ�� not exists �� 
select d.deptno
from dept d		-- �޷���
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

-- ���һ��
-- ֮�����������

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
-- ԭ�����ȣ����������б�����
-- ���߶��е��� ����Null ,not exists �ж�Ϊ False ����������
-- dept �е��У�not exists ���� true���� Null ���� �����
-- ���� Null �������ķ��� not exists��

/* 3.5 ��һ�����������һ������ص��� */
-- outer  join 
--���Ӳ�������ƥ����
select *
from dept d 
left outer join emp e on d.DEPTNO = e.DEPTNO
where e.DEPTNO is null	-- �߼��ϣ����������ӱ���ɸѡ

-- inner join �ǵ�ֵ���ӣ�so deptno = 40 ������
select *
from dept d 
inner join emp e on d.DEPTNO = e.DEPTNO
where e.DEPTNO is null	

 
/* 3.6 �������Ӳ�ѯ����Ӱ���������Ӳ�ѯ */
-- outer join

select * from emp_bonus

select e.ename,d.loc
from emp e,dept d
where e.DEPTNO = d.DEPTNO

-- ����д���� inner join ���߼���
select e.ename,d.loc,eb.RECEIVED
from emp e,dept d,emp_bonus eb
where e.DEPTNO = d.DEPTNO
	and e.EMPNO = eb.EMPNO

-- �ж�����Ϣ���Ҳ���ʧԭ������
select e.ename,d.loc,eb.RECEIVED
from emp e join dept d on e.DEPTNO = d.DEPTNO
	left join emp_bonus eb on e.EMPNO = eb.EMPNO
order by 2,1

/* 3.7 ȷ���������Ƿ�����ͬ������ */
-- select from where not exists  from (select null from  where ) union all

SELECT * 
FROM (
	SELECT e.empno,e.ename,e.job,e.mgr,e.hiredate,e.sal,e.comm,e.deptno,COUNT ( * ) AS cnt 
	FROM emp e 
	GROUP BY empno,ename,job,mgr,hiredate,sal,comm,deptno) e 
WHERE NOT EXISTS ( 
	SELECT NULL 
	FROM (
		SELECT v.empno,v.ename,v.job,v.mgr,v.hiredate,v.sal,v.comm,v.deptno,COUNT ( * ) AS cnt --���գ�����˵��������
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
--union ��ɸ����ͬ��
select *
from emp
union 
select *
from V3_7


/* 3.8 ʶ�������ѿ����� */
select e.ename,d.loc
from emp e
join dept d on e.DEPTNO = d.DEPTNO
where e.DEPTNO = 10

--�ѿ����������ڱ任
--չ�������ʱ������һϵ��ֵ
--ģ��loopѭ��
select e.ENAME,d.loc
from emp e,dept d
where e.DEPTNO = 10
	--and e.DEPTNO = d.DEPTNO


/* 3.9 ���ʹ�����Ӳ�ѯ��ۺϺ��� */
-- sql server �ڣ�distinct ���ܺ� over����
-- sum ֮������ͬ����Ҫ group by ���������Ҫѧ���ۺϺ�����֪��

-- OVER �Ӿ䲻����ʹ�� DISTINCT�����û�����鱾��������
-- Ϊ��AC�����ڿ��ܳ����ظ���ĵط�distinct

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

-- �����ظ���
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


-- �ۺϺ��� û�Ӵ���
select e.deptno,
	sum(distinct sal) as total_sal,
	sum(e.sal*case when eb.type = 1 then .1
				when eb.type = 2 then .2
				else .3 end) as total_bonus
from emp e,T3_9 eb
where e.empno =  eb.empno
	and e.deptno = 10
group by deptno


/* 3.10 ���ʹ�������Ӳ�ѯ��ۺϺ��� */


-- ������ֱ���ų����� eb ����ȵ����ݣ����Ŀ����Ҫ��������
-- ���ǿ����� sum( distinct ...)over 

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

--������
select e.deptno,
	sum(distinct sal) as total_sal,
	sum(distinct e.sal*case when eb.type = 1 then .1
				when eb.type = 2 then .2
				else .3 end) as total_bonus
from emp e
left join T3_10 eb on e.empno =  eb.empno
where e.deptno = 10
group by deptno


/* 3.11 �Ӷ�����з���ȱʧֵ */
-- full outer join == left join union right join

-- ����ʾ��
select d.deptno,d.dname,e.ENAME
from dept d 
right join T3_11 e on d.deptno = e.DEPTNO	-- ������right join

--full outer join <==> left join union right join
select d.DEPTNO,d.DNAME,e.ename
from dept d
full join T3_11 e on d.DEPTNO = e.DEPTNO


/* 3.12 ������ͱȽ���ʹ��Null */	
-- coalesce ����д�ں�����Ϊɸѡ����

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

