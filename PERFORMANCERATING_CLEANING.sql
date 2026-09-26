------------------------EMPLOYEE__PERFORMANCERATING_CLEANING-----------------------------

select top 10 * from PerformanceRating;

--COPYING DATA INTO ANOTHER TABLE 
--select * into employee_performance from PerformanceRating;

--CHCEKING FOR DUPLICATES 

with cte as (
select *,ROW_NUMBER()over(
partition by PerformanceID,
EmployeeID,
ReviewDate,
EnvironmentSatisfaction,
JobSatisfaction,
RelationshipSatisfaction,
TrainingOpportunitiesWithinYear,
TrainingOpportunitiesTaken,
WorkLifeBalance,
SelfRating,
ManagerRating order by performanceid
) as rn from employee_performance
)
select * from cte 
where rn>1

------------------NO DUPLICATES FOUND----------------------

--CHECKING FOR NULL VALUES
DECLARE @sql NVARCHAR(MAX) = '';

SELECT @sql = @sql +
    'SELECT ''' + COLUMN_NAME + ''' AS Column_Name,
            COUNT(*) AS Null_Count
     FROM employee_performance
     WHERE [' + COLUMN_NAME + '] IS NULL
     HAVING COUNT(*) > 0
     UNION ALL '
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'employee_performance';

SET @sql = LEFT(@sql, LEN(@sql) - 10);

EXEC sp_executesql @sql;
--------------------NO NULL VALUES-------------------------------

---------INSPECTING THE COLUMNS
select column_name,data_type from INFORMATION_SCHEMA.COLUMNS
where TABLE_NAME='employee_performance';

select top 10 * from employee_performance