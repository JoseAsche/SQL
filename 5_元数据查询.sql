use model;
/* 5.1 �о�ģʽ�еı� */
select TABLE_NAME 
	from INFORMATION_SCHEMA.TABLES
	where TABLE_SCHEMA = 'SMEAGOL'


/* 5.2 �о��ֶ� */
select column_name,data_type,ordinal_position 
from information_schema.columns
where table_schema = 'SMEAGOL'
	and table_name = 'emp'

/* 5.3 �о����� */
/* 5.4 �о�Լ�� */
/* 5.5 �оٷ�������� */
/* 5.6 ��SQL����SQL */

select * 
from emp
group by empno