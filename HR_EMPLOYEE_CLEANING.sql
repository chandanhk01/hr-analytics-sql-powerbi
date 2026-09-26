------------------------------EMPLOYEE DATA CLEANING--------------------------------
select top 10 * from hr_employee;

---COPYING DATA 
--select * into data_employee from HR_Employee

---FINDING DUPLICATES

with cte as (
select *,ROW_NUMBER() over(
partition by EmployeeID,FirstName,LastName,Gender,Age,BusinessTravel,Department,
Distance_FromHome_KM,State,Ethnicity,Education,EducationField,JobRole,MaritalStatus,
Salary,StockOptionLevel,OverTime,HireDate,Attrition,Years_At_Company,Years_InMost_RecentRole,
Years_Since_Last_Promotion,Years_With_CurrManager order by EmployeeID
) as rn from data_employee
)
select * from cte 
where rn>1

--NO DUPLICATES

--CHECKING FOR NULLS
DECLARE @sql NVARCHAR(MAX) = '';

SELECT @sql = @sql +
    'SELECT ''' + COLUMN_NAME + ''' AS Column_Name,
            COUNT(*) AS Null_Count
     FROM data_employee
     WHERE [' + COLUMN_NAME + '] IS NULL
     HAVING COUNT(*) > 0
     UNION ALL '
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'data_employee';

SET @sql = LEFT(@sql, LEN(@sql) - 10);

EXEC sp_executesql @sql;

--NO NULLS IN THE TABLE 

---INSPECTING DATA TYPES OF THE COLUMN
select column_name,data_type from INFORMATION_SCHEMA.COLUMNS
where TABLE_NAME='data_employee';

select * from data_employee


--ADDING EXTRA COLUMN
alter table data_employee
add Education_level nvarchar(50);

update data_employee
set education_level= case
    when Education=1 then 'Below College'
    when Education=2 then 'College'
    when Education=3 then 'Bachelor'
    when Education=4 then 'Master'
    when Education=5 then 'Doctor'
end 
from data_employee

select top 10* from data_employee