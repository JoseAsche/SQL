use model;
/* 5.1 列举模式中的表 */
select TABLE_NAME 
	from INFORMATION_SCHEMA.TABLES
	where TABLE_SCHEMA = 'SMEAGOL'


/* 5.2 列举字段 */
select column_name,data_type,ordinal_position 
from information_schema.columns
where table_schema = 'SMEAGOL'
	and table_name = 'emp'

/* 5.3 列举索引 */
/* 5.4 列举约束 */
/* 5.5 列举非索引外键 */
/* 5.6 用SQL生成SQL */

select * 
from emp
group by empno