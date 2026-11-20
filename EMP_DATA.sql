INSERT INTO departments (department_name)
SELECT DISTINCT department
FROM hr_staging
ORDER BY department;
SELECT * FROM DEPARTMENTS;

INSERT INTO job_roles (job_title)
SELECT DISTINCT job_role
FROM hr_staging
ORDER BY job_role;
SELECT * FROM JOB_ROLES;

INSERT INTO employees (
    employee_id, age, gender, marital_status,
    education_level, department_id, job_role_id, job_level
)
SELECT
    s.employee_id,
    s.age,
    s.gender,
    s.marital_status,
    s.education_level,
    d.department_id,
    j.job_role_id,
    s.job_level
FROM hr_staging s
JOIN departments d
    ON s.department = d.department_name
JOIN job_roles j
    ON s.job_role = j.job_title;
    SELECT * FROM EMPLOYEES;
    
INSERT INTO compensation
SELECT employee_id, monthly_income,
       stock_option_level, salary_hike_pct
FROM hr_staging;
SELECT * FROM COMPENSATION;

INSERT INTO work_experience
SELECT employee_id, years_at_company,
       total_working_years, years_since_promotion,
       num_prior_companies
FROM hr_staging;
SELECT * FROM work_experience;

INSERT INTO work_environment (
    employee_id, work_mode, commute_minutes,
    overtime_hours_per_week, business_travel_days_per_year,
    training_hours, manager_support_score, burnout_score,
    engagement_score, work_life_balance_score,
    uses_ai_tools_at_work, perceived_ai_job_risk
)
SELECT
    employee_id, work_mode, commute_minutes,
    overtime_hours_per_week, business_travel_days_per_year,
    training_hours, manager_support_score, burnout_score,
    engagement_score, work_life_balance_score,
    uses_ai_tools_at_work, perceived_ai_job_risk
FROM hr_staging;
SELECT * FROM work_environment;

INSERT INTO performance
SELECT employee_id, performance_rating, last_review_score
FROM hr_staging;

INSERT INTO attrition
SELECT employee_id, attrition
FROM hr_staging;
SELECT * FROM ATTRITION;

SELECT COUNT(*) AS total_employees
FROM employees;

SELECT COUNT(*) AS total_departments
FROM departments;

SELECT COUNT(*) AS total_job_roles
FROM job_roles;

SELECT COUNT(*) AS compensation_records
FROM compensation;

SELECT COUNT(*) AS experience_records
FROM work_experience;

SELECT COUNT(*) AS environment_records
FROM work_environment;

SELECT COUNT(*) AS performance_records
FROM performance;

SELECT COUNT(*) AS attrition_records
FROM attrition;