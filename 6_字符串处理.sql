use model;

/* 6.1 �ַ������� */

select substring('damiao',1,len('damiao')) -- �ַ�����1 ��ʼ�������������Դ� 0 ��ʼִ��
select substring('damiao',1,1)

-- substring() �����ַ������
select substring(e.ename,iter.pos,1) as C
from (select ename from emp where ename = 'KING') e,
	(select id as pos from t10) iter
where iter.pos <= 
Datalength(e.ename)	
-- length() �������ú���
-- ��˿����������� sql �ַ������� ���ú���

select e.ename,iter.pos
from (select ename from emp where ename = 'KING') e,
	(select id as pos from t10) iter

select ename,iter.pos
from (select ename from emp where ename = 'KING') e,
	(select id as pos from t10) iter
where iter.pos <= len(e.ename)

-- 
select substring(e.ename,iter.pos,len(e.ename)-iter.pos+1) a,
	substring(e.ename,len(e.ename) - iter.pos + 1,len(e.ename)) b
from (select ename from emp where ename = 'KING') e,
	(select id pos from t10) iter
where iter.pos <= len(e.ename)
-- substring() ���÷�������Ҳ��ͬ


/* 6.2 Ƕ������ */ 
-- ת�嵥���ţ�������ǰ�ټӸ�������
select 'g''date mate' as qmarks from t1 union all
select 'beavers'' teeth' from t1 union all
select '''' from t1

select 'apples core','apple''s core',
case when '' is null then 0 else 1 end
from t1


/* 6.3 ͳ���ַ����ֵĴ��� */
-- �ü������滻����Щ�ַ�֮��ͳ�Ƽ��ɣ���Χ���ַ���
select (len('10,CLERK,MANAGER') - len(replace('10,CLERK,MANAGER',',','')))/len(',') as cnt
from t1

select (len('HELLO HELLO')-(LEN(REPLACE('HELLO HELLO','LL',''))))/LEN('LL') as correct_cnt,	-- ���ִ���
	(len('HELLO HELLO')-(LEN(replace('HELLO HELLO','LL','')))) AS incorrect_cnt	-- ռ�ֽ��ܳ�
from t1

select len('HELLO HELLO') as 'HELLO HELLO'
select LEN(REPLACE('HELLO HELLO','LL',''))


/* 6.4 ɾ������Ҫ���ַ� */
-- ɾ��Ԫ����ĸ
select ename,
	replace(replace(replace(replace(replace(ename,'A',''),'E',''),'I',''),'O',''),'U','') as stripped1,
	sal,	-- int ���Զ�ת�� string �� replace 
	replace(sal,0,'') as stripped2
from emp

-- 'ABC' �� 'EFG' Ҫ�ȳ�
-- translate(A,'ABC','EFG')
-- trim ����ȥ�ո� ' '
select ename,
	translate(ename,'AEIOU','     '),
	replace(trim(translate(ename,'AEIOU','     ')),' ','')
from emp


/* 6.5 �������ֺ��ַ����� */
-- ����ԭ�� T6_5
select concat(ename,sal) as DATA
into T6_5
from emp
-- �滻Ԫ��
select DATA,
	replace(trim(translate(DATA,'123456789','000000000')),'0','') as ename,
	cast(replace(trim(translate(DATA,'qwertyuiopasdfghjklzxcvbnm','aaaaaaaaaaaaaaaaaaaaaaaaaa')),'a','') as int) as sal
from T6_5

/* 6.6 �жϺ�����ĸ�����ֵ��ַ��� */
--create view V6_6 as 
select ename as data
from emp
where deptno = 10
union all
select concat(ename,', $',cast(sal as varchar(4)),'.00') as data
from emp
where deptno = 20
union all
select concat(ename,deptno)
from emp
where deptno = 30

select a.data 
from (
	select 
		data,
		trim(translate(lower(data),'qwertyuiopasdfghjklzxcvbnm0123456789','                                    ')) as flag
	from V6_6 ) a
where a.flag = ''

-- ����Ĵ�
-- ��min(val) ��ɸѡ
select data
	from (
	select v.data,
		iter.pos,
		substring(v.data,iter.pos,1) c,
		ascii(substring(v.data,iter.pos,1)) val
	from  V6_6 v,(select id as pos from t100) iter
	where iter.pos <= len(v.data)
	) x -- ��Щ��Ƕ�� Ҫ������
group by data
having min(val) between 48 and 122

-- ȥ����Ϊ�δ�48 ������ 0
-- 122 ������ z��Z �� 90��
select v.data,
	iter.pos,
	substring(v.data,iter.pos,1) c,
	ascii(substring(v.data,iter.pos,1)) val
from V6_6 v,
	(select id pos from t100) iter
where iter.pos <= len(v.data)
order by val desc

select ascii('z')


/* 6.7 ��ȡ��������ĸ */	-- ����

select CHARINDEX('d','damiao')	-- �����ַ����ַ�����λ��
select substring_index
select concat_ws('aa','bb','cc')
select concat_ws('-','aa','bb','cc')-- ��һ���ַ���Ϊ�����ַ����м����ӷ�

select 
	case when cnt = 2
		then trim( '.' from 
			concat_ws('.',
				substring(substring_i
from (
	select name,len(name)-len(replace(name,' ','')) as cnt
	from (
		select replace('Stewie Griffin','.',' ') as name
		from t1) y
		) x

SELECT TRIM('$ ' FROM '   $PythonJournalDev$   ') AS Output

/* 6.8 �������ַ������� */

-- ���ַ������������ĸ����
select ename
from emp
order by substring(ename,len(ename)-1,2)	

select len('a')


/* 6.9 �����ַ�������������� */
-- create view V6_9 as 
select concat(e.ename,' ',e.empno,' ',d.dname) as data
from emp e,dept d
where e.deptno = d.deptno
 
select data
from V6_9
order by cast(trim(translate(data,'qwertyuiopasdfghjklzxcvbnm','                          ')) as int)


/* 6.10 �����ָ��б� */
-- ��������ȥ�����ѿ�����������£�������ֵ���ܸı�
with x (deptno,cnt,list,empno,len)
as (
-- ���� union all ��������������ģ�
	select deptno,	-- �����׼
	count(1) over (partition by deptno),	-- ��ͳ����ֵ��Ϊ�з���,���񻹻�Ӱ������
											-- ��Ϊ����������׼
											--	�ʳ�
	cast(ename as varchar(100)),			-- ���Ԫ��
	empno,									-- ����Ԫ��
	1										-- ������
	from emp
	union all
	select x.deptno,						-- ��������õ�
		x.cnt,								-- cnt �������ǣ�
		cast(x.list + ',' + e.ename as varchar(100)),
		e.empno,	
		x.len + 1							-- ����
	from emp e,x
											-- �ۼӽṹ����Ҫ��ǰ��λ���Լ����� �����Ļ�����Ԫ
											-- ����ṹ�Ƿ����ۼӵĽ��
	where e.DEPTNO = x.deptno				-- ֻ�᷵������
		and e.empno > x.empno				-- ����ǣ�
		)
select deptno,list,* 
from x
where len = cnt -- �ݹ���ֹ��
order by 1

select *,count(*) over (partition by deptno) as ����
from emp

-- with fragment_name (column_name_1,...
-- as (...
-- Ȼ�󵱳� table ��

-- partition by �е㷽�㣬����Ӧ���� over() �Ļ���Ӧ��
select *, count(*) over (partition by deptno) as '����'
from emp

-- ����������ۺϺ���һ�������Ƕ��еļ�������оۺϼ���
/*���������ĵ��ø�ʽΪ��������(��) OVER(ѡ��)��
��һ���ࣺ�ۺϿ�������====���ۺϺ���(��) OVER (ѡ��)��
�����ѡ�������PARTITION BY�Ӿ䣬��ʾ����PARTITION BY������ֶη��顣

�ڶ����ࣺ���򿪴�����====��������(��) OVER (ѡ��)��
�����ѡ�������ORDER BY�Ӿ䣬Ҳ������PARTITION BY�Ӿ�+ORDER BY�Ӿ䣬��������ֻ��PARTITION BY�Ӿ䡣*/

select count(1) 
from emp
/* Count(1)��Count(*)ʵ���ϵ���˼�ǣ�
����Count�����еı��ʽ�Ƿ�ΪNULL�����ΪNULL�򲻼���������NULL��������

����Count���У���˵��ͬ���������������
��������ÿһ�е�ֵ�Ƿ�ΪNULL�����ΪNULL�򲻼�������ΪNULL�������
*/

-- �� with as ��ģ��һ��ѭ��
-- �����˵ݹ鷶Χ�� 100
/* һ����ѯҳ��ֻ��һ�� with? 
	�˴����� xy���ǿ�ʶ�����ʾѡ������Ҫ��Ϊ��ֵ�����Ĳ�����
	��ȷ���������ݿ������ģʽ����Ϊ90 */
-- union all �����where ֻ��ѡ������ select ����������
-- ���� x �Ż��� deptno �� empno
with xy ( cnt,list,len)
as (
	select count(1) over (partition by deptno) as cnt,
		cast(ename as varchar(200)),
		1
	from emp
	union all 
	select 
		xy.cnt,
		cast(xy.list + ',' + e.ename as varchar(200)),
		xy.len + 1
	from emp e,xy

	)
select * from xy

/*
4. CTE ������������Ҳ����������ͬһ WITH �Ӿ���Ԥ�ȶ���� CTE��������ǰ�����á� 
5. ������ CTE_query_definition ��ʹ�������Ӿ䣺 
��1��COMPUTE �� COMPUTE BY 
��2��ORDER BY������ָ���� TOP �Ӿ䣩 
��3��INTO 
��4�����в�ѯ��ʾ�� OPTION �Ӿ� 
��5��FOR XML 
��6��FOR BROWSE 
*/


/* 6.11 �ָ�����ת��Ϊ��ֵIN�б� */ 

select charindex(',',','+'7654,7698,7782,7788'+',',2) -- �������ַ����е�λ��
select substring('damiao',1,12)

select ename,sal,deptno
from emp
where empno in ('7654,7698,7782,7788')
-- ֱ��д������û�����

select empno,ename,sal,deptno
from emp
where empno in (
	select substring(c,2,charindex(',',c,2)-2) as empno
	from (
		select substring(csv.emps,iter.pos,len(csv.emps)) as c
		from ( 
			select ','+'7654,7698,7782,7788'+','as emps
			from t1) csv,
			(
			select id as pos
			from t100) iter
		where iter.pos <= len(csv.emps)
		) x
	where len(c) > 1
		and SUBSTRING(c,1,1) = ','
	) 

-- ����
select substring(c,2,charindex(',',c,2)-2) as empno,	-- ȥ����ͷ�ͽ�β�� ','������charindex ��ֵҪ ����
	substring(c,1,1) as '����', -- ȷ��ȡ�� ',' ��ͷ��������
	*
from (
	select substring(csv.emps,iter.pos,len(csv.emps)) as c,*
	-- һ�е�����ͨ���ѿ����������ƶ���
	from (
		select ','+'7654,7698,7782,7788'+','as emps -- ǰ��Ӷ��ž���Ϊ��ʹ�� substring(c,1,1) = ','
		from t1 ) csv,
		(
		select id as pos 
		from t100 ) iter
	where iter.pos <= len(csv.emps)	-- len = 21 
	) x
where len(c) > 1
	and substring(c,1,1) = ','


select charindex(',',','+'7654,7698,7782,7788'+',',2) -- �������ַ����е�λ��
select substring('damiao',1,12)

/* 6.12 ����ĸ��˳�������ַ� */
select ename as OLD_NAME,
	max(case when pos = 1 then c else '' end)+
	max(case when pos = 2 then c else '' end)+
	max(case when pos = 3 then c else '' end)+
	max(case when pos = 4 then c else '' end)+
	max(case when pos = 5 then c else '' end)+
	max(case when pos = 6 then c else '' end) as NEW_NAME
from (
	select e.ename,
		substring(e.ename,iter.pos,1) as c,
		row_number() over (
			partition by ename
			order by substring(e.ename,iter.pos,1)) as pos
	from emp e,(
		select row_number() over (order by ename) as pos
		from emp) iter
	where iter.pos <= len(ename)
	) x
group by ename

-- row_number() over (order by ...)
-- ��������һ���У������� by �����ݽ������� �� �������
select row_number() over (order by deptno,empno),
	*
from emp

select ename,
	substring(ename,iter.pos,1) as c,
	row_number() over (
		partition by ename	-- �Ȱ� ename ����
		order by substring(ename,iter.pos,1)) as pos	-- �ٰ���ֺ����ĸ����Ȼ��õ���Ӧ��ĸ�����
from emp e,(
	select row_number() over (order by ename) as pos	-- ͨ��row_number�õ�һ�� 1,2,3,4,5...�ĵ�������
	from emp) iter 
where iter.pos <= len(ename)


/* 6.13 ʶ���ַ�����������ַ� */
create view V6_13 as
select replace(mixed,' ','') as mixed
from (
	select substring(ename,1,2) 
		+ cast(deptno as varchar(4)) 
		+ substring(ename,3,2) as mixed
	from emp
	where deptno = 10
	union all
	select cast(empno as varchar(4)) as mixed
	from emp
	where deptno = 20
	union all
	select ename as mixed
	from emp
	where deptno = 30
	) x

select * from V6_13

select * from (
select 
	replace(trim(translate(mixed,'qwertyuiopasdfghjklzxcvbnm','                          ')),' ','') as MIXED
from V6_13 ) G
where MIXED <> ''


/* 6.14 ��ȡ��n���ָ����ַ��� */

CREATE VIEW  V6_14 AS 
select 'mo,larry,curly' as NAME
-- from t1	-- ����б�Ҫ��
union all
select 'tina,gina,jaunita,regina,leena' as NAME
-- from t1

SELECT * FROM V6_14

select substring(c,2,CHARINDEX(',',c,2)-2)
from (
	select pos,
		name,
		substring(name,pos,len(name)) as c,
		row_number() over (
			partition by name
			order by len(substring(name,pos,len(name))) desc) rn
	from (
		select ',' + csv.name + ',' as name,
		iter.pos
		from V6_14 csv,(
			select id as pos 
			from t100) iter
		where iter.pos <= len(csv.name)+2
	) x
	where len(substring(name,pos,len(name))) > 1
		and substring(substring(name,pos,len(name)),1,1) = ','
) y
where rn = 2


/* 6.15 ����IP��ַ */
with x (pos,ip) as (
	select 1 as pos,'.' + '111.22.3.4' as ip 
	from t1
	union all
	select pos + 1,
		ip
	from x 
	where pos + 1 <= 20	-- 4*4=16 ��
)
select 
	max(case when rn = 1 then e end) a,
	max(case when rn = 2 then e end) b,	
	max(case when rn = 3 then e end) c,
	max(case when rn = 4 then e end) d
from (
	select pos,
		c,
		d,
		case when charindex('.',d) > 0 then substring(d,1,charindex('.',d)-1)
		else d
		end as e,
		row_number() over (order by pos desc) rn
	from (
		select pos,
			ip,
			right(ip,pos) as c,
			substring(right(ip,pos),2,len(ip)) as d
		from x
		where pos <= len(ip)
			and substring(right(ip,pos),1,1) = '.'
	) x
) y








