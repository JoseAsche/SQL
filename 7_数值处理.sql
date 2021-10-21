use model;
/*
/* 7.1 ����ƽ���� */
-- Ա��ƽ������
select avg(sal*1.0) as AVG_SAL
from emp

-- ����ƽ������
select deptno,avg(sal*1.0) as AVG_SAL
from emp
group by deptno

-- avg ����Ե�null��Ӱ����Ϊ��ĸ�ĳ���
-- ��������ʹ�� coalesce(sal,0) ��nullת����0


/* 7.2 ������Сֵ�����ֵ */
select deptno, 
	min(sal) as min_sal,
	max(sal) as max_sal
from emp
group by deptno

-- ���򷵻�null
select min(comm),max(comm)
from emp
group by deptno


/* 7.3 ��� */
select sum(sal) as total_for_dept
from emp
group by deptno


/* 7.4 �������� */
select deptno,count(sal) as Dnum,sum(sal) as total_for_dept
from emp
group by deptno
-- ����Ե� null ���ɼ�����׼

select 
	count(*),				-- ֻҪ��һ���ж����ͻ����һ�μ���
	count(deptno),
	count(comm),
	count('hello world')	-- Ч��ͬ *
from emp
group by deptno

-- ����count(*) �Ƿ�ͳ��
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
select count(*) from T7_4	-- ȫѡʱ��Ҳ��ͳ��null
select count(id) from T7_4	-- ��������ʱ�������null


/* 7.5 �����Nullֵ�ĸ��� */
select count(comm)
from emp


/* 7.6 �ۼ���� */
--��С������ʾ�ۼƶ�
select 
	e.empno,
	e.ename,
	e.sal,
	(
		select sum(d.sal)			
		from emp d					-- �����˵ѿ�����������
		where d.empno <= e.empno	-- ��Ͱ��� empno ������
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


/* 7.7 �����ۼƳ˻� */
select 
	e.empno,
	e.ename,
	e.sal,
	(
	select 
		exp(sum(log(d.sal*1.0/1000)))	--�����м�������
	from emp d
	where d.empno <= e.empno
		and e.deptno = d.deptno
	)
	as running_prod
from emp e
where e.deptno = 10
-- order by sal

select exp(log(100))


/* 7.8 �����ۼƲ� */
-- ���������ú������������������Ҫ��Ҫ�������ټ���
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


/* 7.9 �������� */
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


/* 7.10 ������λ�� */
select avg(sal)	-- ż����������£��м�������ȡƽ��
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
ROUND() �C ��������һ���������߸��������Ϊһ�����ȵ�ֵ��
CEILING() - ������С��������ʹ����������ڻ����ָ��������ֵ���㡣
FLOOR() - �������������ʹ�������С�ڻ����ָ��������ֵ���㡣
*/

/* 7.11 ����ٷֱ� */
-- deptno = 10 �Ĳ��Ź���ռ��
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


/* 7.12 �ۺ�Null�� */
-- �ۺϺ������Զ����Ե�null
select avg(coalesce(comm,0)) as avg_comm
from emp
where deptno = 30


/* 7.13 ����ƽ��ֵʱȥ�����ֵ����Сֵ */
select avg(sal)
from (
	select 
		sal,
		min(sal) over() min_sal,	--�ۺϺ������� �� over
		max(sal) over() max_sal
	from emp
) x
where sal not in (min_sal,max_sal)


/* 7.14 ��������ĸ�����ֵ��ַ���ת��Ϊ���� */
select 
	replace(trim(translate('paul123f321','qwertyuiopasdfghjklzxcvbnm','                          ')),' ','') as num
from t1


/* 7.15 �޸��ۼ�ֵ */
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
	where v2.id <= v1.id	-- ����������ӱȣ�����Ҫѡ�������ۼ�����Ҫ�д˲���ʽ
	) as balance
from V7_15 v1
*/


/* 7.1 ����ƽ��ֵ */
select avg(sal) as avg_sal
from emp 

/* 7.2 ������Сֵ�����ֵ */
select 
	min(sal) as min_sal,
	max(sal) as max_sal
from emp

/* 7.3 ��� */
select sum(sal)
from emp

/* 7.4 �������� */
select count(*)
from emp

/* 7.5 �����Nullֵ�ĸ��� */
select count(comm)
from emp

/* 7.6 �ۼ���� */
select e.ename,e.sal,
	(select sum(d.sal) from emp d where d.empno <= e.empno) as running_total
from emp e

select 
	e.ename,
	e.sal,
	(select sum(d.sal) from emp d where d.empno <= e.empno)
from emp e

/* 7.7 �����ۼƳ˻� */	-- sum(log)��exp �͵õ� �ۻ�
select 
	e.ename,
	e.sal,
	(select exp(sum(log(d.sal))) from emp d where d.empno <= e.empno)
from emp e


/* 7.8 �����ۼƲ� */ -- ����Ҫ�õ�with ����
-- �Ӳ�ѯ�в�����order by

/* 7.9 �������� */

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


/* 7.10 ������λ�� */
/* 7.11 ����ٷֱ� */
/* 7.12 �ۺ�Null�� */
/* 7.13 ����ƽ��ֵʱȥ�����ֵ����Сֵ */
/* 7.14 ��������ĸ�����ֵ��ַ���ת��Ϊ���� */
/* 7.15 �޸��ۼ�ֵ */ 
