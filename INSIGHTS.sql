														-- BASIC EMPLOYEE ANALYSIS
SELECT COUNT(*) AS TOTAL_EMPLOYEE FROM EMPLOYEES;

SELECT * FROM employees
LIMIT 10;
SELECT COUNT(JOB_TITLE) AS TOTAL_ROLES FROM job_roles;
SELECT COUNT(*)AS TOTAL_DEPARTMENTS FROM DEPARTMENTS;

 
-- employees in each department
SELECT D.department_name ,COUNT(E.EMPLOYEE_ID) AS TOTAL_EMP 
FROM employees E LEFT JOIN departments D
ON D.department_id=E.department_id
group by D.department_id;

-- average age of employees
SELECT round(AVG(AGE)) AS AVG_AGE FROM employees;


-- employees older than 40
SELECT COUNT(*) FROM employees
WHERE AGE>40;

-- employees who have worked at the company for more than 5 years.
SELECT * FROM work_experience;
select EMPLOYEE_ID, YEARS_AT_COMPANY FROM work_experience
WHERE YEARS_AT_COMPANY>5;
 


														-- Salary and compensation
-- the highest, lowest, and average monthly income.
SELECT * FROM compensation;
SELECT MAX(MONTHLY_INCOME) AS HIGHEST_INCOME, 
min(MONTHLY_INCOME) as LOWEST_INCOME, 
ROUND(AVG(MONTHLY_INCOME)) AS AVG_INCOME FROM compensation;


-- top 10 highest-paid employees
SELECT EMPLOYEE_ID,MONTHLY_INCOME
FROM compensation
order by MONTHLY_INCOME DESC
LIMIT 10;

-- average salary for each department
SELECT D.DEPARTMENT_NAME ,ROUND(avg(C.MONTHLY_INCOME)) AS AVG_SALARY
FROM EMPLOYEES E JOIN DEPARTMENTS D  ON E.DEPARTMENT_ID=D.DEPARTMENT_ID
JOIN COMPENSATION C ON E.EMPLOYEE_ID=C.EMPLOYEE_ID
GROUP BY D.DEPARTMENT_NAME
order by  AVG_SALARY DESC;

-- Compare average salaries across job levels
SELECT E.JOB_LEVEL,ROUND(avg(C.MONTHLY_INCOME)) AS AVG_SALARY
FROM EMPLOYEES E JOIN COMPENSATION C ON E.EMPLOYEE_ID=C.EMPLOYEE_ID
GROUP BY E.JOB_LEVEL 
order by AVG_SALARY desc ;

-- employees earning more than the overall average salary
SELECT E.EMPLOYEE_ID, C.MONTHLY_INCOME
FROM EMPLOYEES E
JOIN COMPENSATION C 
ON E.EMPLOYEE_ID=C.EMPLOYEE_ID
WHERE C.MONTHLY_INCOME > (SELECT avg(MONTHLY_INCOME)FROM COMPENSATION);

															-- Attrition analysis
-- employees who left and employees who stayed
select * from attrition;
select attrition_status,count(*) as count_ from attrition
group by attrition_status;
                                                            
-- overall attrition rate as a percentage
select attrition_status,round((count(*)/(select count(*) from attrition))*100) as ATTRITION_IN_PERCENT from attrition
group by attrition_status;
-- OR
SELECT 
    ROUND((COUNT(IF(attrition_status = 'Yes', 1, NULL)) / COUNT(*)) * 100) AS ATTRITION_PERCENT
FROM attrition;


-- attrition rate for each department
SELECT D.DEPARTMENT_NAME , ROUND((COUNT(IF(A.ATTRITION_STATUS = 'Yes', 1, NULL)) / COUNT(*)) * 100 )AS ATT_RATE
FROM DEPARTMENTS D JOIN EMPLOYEES E ON D.DEPARTMENT_ID=E.DEPARTMENT_ID
JOIN ATTRITION A ON A.EMPLOYEE_ID=E.EMPLOYEE_ID
group by D.DEPARTMENT_NAME ;


-- attrition rates across job roles
SELECT *from work_environment;
SELECT J.JOB_TITLE , ROUND((COUNT(IF(A.ATTRITION_STATUS = 'Yes', 1, NULL)) / COUNT(*)) * 100 )AS ATT_RATE
FROM JOB_ROLES J JOIN EMPLOYEES E ON J.JOB_ROLE_ID=E.JOB_ROLE_ID
JOIN ATTRITION A ON A.EMPLOYEE_ID=E.EMPLOYEE_ID
group by J.JOB_TITLE ;

-- Compare attrition rates across work modes
SELECT *from work_environment;
SELECT W.WORK_MODE, ROUND((COUNT(IF(A.ATTRITION_STATUS = 'Yes', 1, NULL)) / COUNT(*)) * 100 )AS ATTRITION_PERCENT
FROM WORK_ENVIRONMENT W JOIN EMPLOYEES E ON W.EMPLOYEE_ID=E.EMPLOYEE_ID
JOIN ATTRITION A ON A.EMPLOYEE_ID=E.EMPLOYEE_ID
group by W.WORK_MODE ;


									-- Performance and employee well-being
-- average performance rating by department
SELECT * FROM WORK_ENVIRONMENT;
select * from performance;
SELECT D.DEPARTMENT_NAME, ROUND(AVG(P.PERFORMANCE_RATING)) AS AVG_PERFORMANCE
FROM DEPARTMENTS D JOIN EMPLOYEES E ON D.DEPARTMENT_ID=E.DEPARTMENT_ID
JOIN PERFORMANCE P ON E.EMPLOYEE_ID=P.EMPLOYEE_ID
GROUP BY D.DEPARTMENT_NAME;
                                     
-- attrition rates across performance ratings
SELECT P.PERFORMANCE_RATING, ROUND((COUNT(IF(A.ATTRITION_STATUS = 'Yes', 1, NULL)) / COUNT(A.ATTRITION_STATUS)) * 100 )AS ATTRITION_RATE
FROM PERFORMANCE P JOIN EMPLOYEES E ON P.EMPLOYEE_ID= E.EMPLOYEE_ID
JOIN ATTRITION A ON E.EMPLOYEE_ID=A.EMPLOYEE_ID
GROUP BY  P.PERFORMANCE_RATING
ORDER BY ATTRITION_RATE DESC ;                   


-- attrition rates for employees who use AI tools and those who do not.
SELECT W.USES_AI_TOOLS_AT_WORK, COUNT(IF(A.ATTRITION_STATUS="Yes",1,NULL)) AS ATTRITION_COUNT
FROM  EMPLOYEES E RIGHT JOIN ATTRITION A ON A.EMPLOYEE_ID=E.EMPLOYEE_ID
JOIN WORK_ENVIRONMENT W ON E.EMPLOYEE_ID=W.EMPLOYEE_ID
GROUP BY  W.USES_AI_TOOLS_AT_WORK;

 -- OR
 
SELECT 
    W.USES_AI_TOOLS_AT_WORK, 
    -- Counts attrition safely, treating active/missing records as 0
    COUNT(IF(A.ATTRITION_STATUS = 'Yes', 1, NULL)) AS ATTRITION_COUNT,
    COUNT(E.EMPLOYEE_ID) AS TOTAL_EMPLOYEES_IN_GROUP
FROM EMPLOYEES E
LEFT JOIN ATTRITION A ON E.EMPLOYEE_ID = A.EMPLOYEE_ID
LEFT JOIN WORK_ENVIRONMENT W ON E.EMPLOYEE_ID = W.EMPLOYEE_ID
GROUP BY W.USES_AI_TOOLS_AT_WORK; 


-- the relationship between work-life balance scores and attrition
SELECT A.ATTRITION_STATUS,COUNT(*) AS TOT, AVG(W.WORK_LIFE_BALANCE_SCORE) AS AVG_
FROM ATTRITION A JOIN WORK_ENVIRONMENT W ON A.EMPLOYEE_ID= W.EMPLOYEE_ID
GROUP BY A.ATTRITION_STATUS;


-- -- the relationship between work-mode and attrition
SELECT W.WORK_MODE,count(W.EMPLOYEE_ID)AS TOTAL_EMPLOYEE,ROUND((COUNT(IF(A.ATTRITION_STATUS = 'Yes', 1, NULL)) / COUNT(*)) * 100 )AS ATT_RATE
FROM ATTRITION A JOIN WORK_ENVIRONMENT W ON A.EMPLOYEE_ID= W.EMPLOYEE_ID
GROUP BY W.WORK_MODE;


-- -------------------------------------------------------------------------------------
-- employees earning more than their department's average salary
SELECT C.EMPLOYEE_ID , C.MONTHLY_INCOME 
FROM COMPENSATION C JOIN EMPLOYEES E ON E.EMPLOYEE_ID= C.EMPLOYEE_ID
JOIN DEPARTMENTS D ON E.DEPARTMENT_ID=D.DEPARTMENT_ID
WHERE MONTHLY_INCOME > (SELECT AVG(MONTHLY_INCOME) FROM COMPENSATION;

-- -- the top 3 job roles with the highest attrition rates, considering group sizes
SELECT J.JOB_TITLE , ROUND((COUNT(IF(A.ATTRITION_STATUS = 'Yes', 1, NULL)) / COUNT(*)) * 100 )AS ATT_RATE
FROM JOB_ROLES J JOIN EMPLOYEES E ON J.JOB_ROLE_ID=E.JOB_ROLE_ID
JOIN ATTRITION A ON A.EMPLOYEE_ID=E.EMPLOYEE_ID
group by J.JOB_TITLE 
ORDER BY ATT_RATE DESC
LIMIT 3;

SELECT * FROM WORK_ENVIRONMENT;




/*	Which department has the highest attrition rate - Customer Support
	Which job roles have comparatively high attrition - Support Team Lead
    the relationship between work-life balance scores and attrition- HIGH SCORE== HIGH ATTRITION
    the relationship between work-modes and attrition- ONSITE has higher attrition rate
    
    
   REASONS :
    1. WORK-LIFE BALANCE 
    2. EMPLOYEE BURNOUT
    3.SALARY AND COMPENSATION
    4. CAREER GROWTH 