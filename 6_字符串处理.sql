use model;

/* 6.1 字符串处理 */

select substring('damiao',1,len('damiao')) -- 字符串从1 开始计数，函数可以从 0 开始执行
select substring('damiao',1,1)

-- substring() 将其字符串拆分
select substring(e.ename,iter.pos,1) as C
from (select ename from emp where ename = 'KING') e,
	(select id as pos from t10) iter
where iter.pos <= 
Datalength(e.ename)	
-- length() 不是内置函数
-- 因此可以在网上搜 sql 字符串长度 内置函数

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
-- substring() 的用法和书上也不同


/* 6.2 嵌入引号 */ 
-- 转义单引号：单引号前再加个单引号
select 'g''date mate' as qmarks from t1 union all
select 'beavers'' teeth' from t1 union all
select '''' from t1

select 'apples core','apple''s core',
case when '' is null then 0 else 1 end
from t1


/* 6.3 统计字符出现的次数 */
-- 用减法，替换掉那些字符之后统计即可（范围：字符）
select (len('10,CLERK,MANAGER') - len(replace('10,CLERK,MANAGER',',','')))/len(',') as cnt
from t1

select (len('HELLO HELLO')-(LEN(REPLACE('HELLO HELLO','LL',''))))/LEN('LL') as correct_cnt,	-- 出现次数
	(len('HELLO HELLO')-(LEN(replace('HELLO HELLO','LL','')))) AS incorrect_cnt	-- 占字节总长
from t1

select len('HELLO HELLO') as 'HELLO HELLO'
select LEN(REPLACE('HELLO HELLO','LL',''))


/* 6.4 删除不想要的字符 */
-- 删除元音字母
select ename,
	replace(replace(replace(replace(replace(ename,'A',''),'E',''),'I',''),'O',''),'U','') as stripped1,
	sal,	-- int 先自动转成 string 再 replace 
	replace(sal,0,'') as stripped2
from emp

-- 'ABC' 和 'EFG' 要等长
-- translate(A,'ABC','EFG')
-- trim 可以去空格 ' '
select ename,
	translate(ename,'AEIOU','     '),
	replace(trim(translate(ename,'AEIOU','     ')),' ','')
from emp


/* 6.5 分离数字和字符数据 */
-- 数据原表 T6_5
select concat(ename,sal) as DATA
into T6_5
from emp
-- 替换元素
select DATA,
	replace(trim(translate(DATA,'123456789','000000000')),'0','') as ename,
	cast(replace(trim(translate(DATA,'qwertyuiopasdfghjklzxcvbnm','aaaaaaaaaaaaaaaaaaaaaaaaaa')),'a','') as int) as sal
from T6_5

/* 6.6 判断含有字母和数字的字符串 */
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

-- 书里的答案
-- 用min(val) 来筛选
select data
	from (
	select v.data,
		iter.pos,
		substring(v.data,iter.pos,1) c,
		ascii(substring(v.data,iter.pos,1)) val
	from  V6_6 v,(select id as pos from t100) iter
	where iter.pos <= len(v.data)
	) x -- 这些内嵌表 要有列名
group by data
having min(val) between 48 and 122

-- 去解释为何从48 ——》 0
-- 122 ——》 z（Z 是 90）
select v.data,
	iter.pos,
	substring(v.data,iter.pos,1) c,
	ascii(substring(v.data,iter.pos,1)) val
from V6_6 v,
	(select id pos from t100) iter
where iter.pos <= len(v.data)
order by val desc

select ascii('z')


/* 6.7 提取姓名首字母 */	-- 摸了

select CHARINDEX('d','damiao')	-- 查找字符在字符串的位置
select substring_index
select concat_ws('aa','bb','cc')
select concat_ws('-','aa','bb','cc')-- 第一个字符作为后续字符的中间连接符

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

/* 6.8 按照子字符串排序 */

-- 对字符串最后两个字母排序
select ename
from emp
order by substring(ename,len(ename)-1,2)	

select len('a')


/* 6.9 根据字符串里的数字排序 */
-- create view V6_9 as 
select concat(e.ename,' ',e.empno,' ',d.dname) as data
from emp e,dept d
where e.deptno = d.deptno
 
select data
from V6_9
order by cast(trim(translate(data,'qwertyuiopasdfghjklzxcvbnm','                          ')) as int)


/* 6.10 创建分隔列表 */
-- 当成特例去背，笛卡尔积的情况下，表内数值还能改变
with x (deptno,cnt,list,empno,len)
as (
-- 整个 union all 上面板块的意义在哪？
	select deptno,	-- 分类标准
	count(1) over (partition by deptno),	-- 将统的数值作为列返回,好像还会影响排序
											-- 作为后续计数标准
											--	词长
	cast(ename as varchar(100)),			-- 组合元素
	empno,									-- 单个元素
	1										-- 计数器
	from emp
	union all
	select x.deptno,						-- 这个干嘛用的
		x.cnt,								-- cnt 的作用是？
		cast(x.list + ',' + e.ename as varchar(100)),
		e.empno,	
		x.len + 1							-- 计数
	from emp e,x
											-- 累加结构，需要提前定位，以及计数 三个的基本单元
											-- 这个结构是返回累加的结果
	where e.DEPTNO = x.deptno				-- 只会返回三行
		and e.empno > x.empno				-- 这个是？
		)
select deptno,list,* 
from x
where len = cnt -- 递归终止处
order by 1

select *,count(*) over (partition by deptno) as 大喵
from emp

-- with fragment_name (column_name_1,...
-- as (...
-- 然后当成 table 用

-- partition by 有点方便，这里应该是 over() 的基本应用
select *, count(*) over (partition by deptno) as '大喵'
from emp

-- 开窗函数与聚合函数一样，都是对行的集合组进行聚合计算
/*开窗函数的调用格式为：函数名(列) OVER(选项)。
第一大类：聚合开窗函数====》聚合函数(列) OVER (选项)，
这里的选项可以是PARTITION BY子句，表示根据PARTITION BY后面的字段分组。

第二大类：排序开窗函数====》排序函数(列) OVER (选项)，
这里的选项可以是ORDER BY子句，也可以是PARTITION BY子句+ORDER BY子句，但不可以只是PARTITION BY子句。*/

select count(1) 
from emp
/* Count(1)和Count(*)实际上的意思是，
评估Count（）中的表达式是否为NULL，如果为NULL则不计数，而非NULL则会计数。

对于Count（列）来说，同样适用于上面规则，
评估列中每一行的值是否为NULL，如果为NULL则不计数，不为NULL则计数。
*/

-- 用 with as 来模拟一个循环
-- 内置了递归范围是 100
/* 一个查询页面只能一个 with? 
	此处报错： xy不是可识别的提示选项。如果它要作为表值函数的参数，
	请确保您的数据库兼容性模式设置为90 */
-- union all 后面的where 只能选用上面 select 过的列排序
-- 所以 x 才会有 deptno 和 empno
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
4. CTE 可以引用自身，也可以引用在同一 WITH 子句中预先定义的 CTE。不允许前向引用。 
5. 不能在 CTE_query_definition 中使用以下子句： 
（1）COMPUTE 或 COMPUTE BY 
（2）ORDER BY（除非指定了 TOP 子句） 
（3）INTO 
（4）带有查询提示的 OPTION 子句 
（5）FOR XML 
（6）FOR BROWSE 
*/


/* 6.11 分隔数据转换为多值IN列表 */ 

select charindex(',',','+'7654,7698,7782,7788'+',',2) -- 返回在字符串中的位置
select substring('damiao',1,12)

select ename,sal,deptno
from emp
where empno in ('7654,7698,7782,7788')
-- 直接写数字是没问题的

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

-- 分析
select substring(c,2,charindex(',',c,2)-2) as empno,	-- 去掉开头和结尾的 ','，所以charindex 的值要 减二
	substring(c,1,1) as '条件', -- 确保取到 ',' 开头的数据行
	*
from (
	select substring(csv.emps,iter.pos,len(csv.emps)) as c,*
	-- 一行的数据通过笛卡尔积来复制多行
	from (
		select ','+'7654,7698,7782,7788'+','as emps -- 前面加逗号就是为了使用 substring(c,1,1) = ','
		from t1 ) csv,
		(
		select id as pos 
		from t100 ) iter
	where iter.pos <= len(csv.emps)	-- len = 21 
	) x
where len(c) > 1
	and substring(c,1,1) = ','


select charindex(',',','+'7654,7698,7782,7788'+',',2) -- 返回在字符串中的位置
select substring('damiao',1,12)

/* 6.12 按字母表顺序排列字符 */
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
-- 单独创建一个列，并按照 by 后内容进行排序 与 赋予序号
select row_number() over (order by deptno,empno),
	*
from emp

select ename,
	substring(ename,iter.pos,1) as c,
	row_number() over (
		partition by ename	-- 先按 ename 分区
		order by substring(ename,iter.pos,1)) as pos	-- 再按拆分后的字母排序，然后得到相应字母的序号
from emp e,(
	select row_number() over (order by ename) as pos	-- 通过row_number得到一个 1,2,3,4,5...的递增序列
	from emp) iter 
where iter.pos <= len(ename)


/* 6.13 识别字符串里的数字字符 */
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


/* 6.14 提取第n个分隔子字符串 */

CREATE VIEW  V6_14 AS 
select 'mo,larry,curly' as NAME
-- from t1	-- 这句有必要吗？
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


/* 6.15 解析IP地址 */
with x (pos,ip) as (
	select 1 as pos,'.' + '111.22.3.4' as ip 
	from t1
	union all
	select pos + 1,
		ip
	from x 
	where pos + 1 <= 20	-- 4*4=16 ？
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








