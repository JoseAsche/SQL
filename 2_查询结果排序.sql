use model;
/* 2.1 以指定顺序返回查询结果 */	--order by 1 asc,desc
select ename,job,sal
from emp
where deptno = 10
order by sal asc -- 低到高 asc， 高到低 desc

--选用顺序列 排序
select ename,job,sal
from emp
where deptno = 10
order by 3

/* 2.2 多字段排序 */ 
--order by 后按提供列名的先后进行依次排序
select empno,deptno,ename,sal,job
from emp
order by deptno, empno desc

/* 2.3 依据子串排序 */ 
--substring，对字符数据的不同位置进行排序	
select ename,job
from emp
order by substring(job,len(job)-2,2)	-- len 选最后，去掉 n - 1个，n 就成了末尾

select ename,job
from emp
order by substring(job,len(job)-2,3)	--上面应该多了一个逻辑，或者错了，这个才是原来的描述

select substring('abcdef',len('abcdef') - 3,2)
select len('abcdef')

/* 2.4 对含有字母和数字的列排序 */
--create view V
--as 
-- 按照 deptno 排序
select concat(ename,' ',deptno) as data
from emp
order by cast(replace(trim(translate(concat(ename,' ',deptno),'QWERTYUIOPASDFGHJKLZXCVBNM','aaaaaaaaaaaaaaaaaaaaaaaaaa')),'a','') as int)

--在 sql 上连接需要 先将 其他类型转换为 字符型号，后 再用 + 连接
--好像用 concat 效果好一点
--create view V
--as 
-- 按照ename排序
select ename + ' '+ cast(deptno as varchar(20))as data
from emp
order by replace(trim(translate(concat(ename,' ',deptno),'123456789','000000000')),'0','')

select * from V

/* 2.5 排序时对Null值的处理 */	--除非用 Oracle，不然对 null 相关的列进项排序，需要针对 null创建辅助列排序
select ename,sal,comm
from emp 
order by 3

select ename,sal,comm
from emp 
order by 3 desc
-- 若需要 null 置于 后面 或者 前面后，再根据列来排序
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

/* 2.6 依据条件逻辑动态调用排序项 */ -- 在order by内用 case when
select ename,sal,job,comm
from emp
order by case when job = 'SALESMAN' then comm
	else sal end