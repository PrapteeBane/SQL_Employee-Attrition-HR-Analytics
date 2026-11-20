CREATE DATABASE Employee_Analytics;
USE Employee_Analytics;

SELECT COUNT(*) FROM hr_staging;
SELECT * FROM hr_staging LIMIT 10;


-- TABLE CREATION
CREATE TABLE departments (
    department_id INT AUTO_INCREMENT PRIMARY KEY,
    department_name VARCHAR(100) NOT NULL UNIQUE
); 
DESC DEPARTMENTS;

CREATE TABLE job_roles (
    job_role_id INT AUTO_INCREMENT PRIMARY KEY,
    job_title VARCHAR(100) NOT NULL UNIQUE
);
DESC JOB_ROLES;

CREATE TABLE employees (
    employee_id INT PRIMARY KEY,
    age INT,
    gender VARCHAR(30),
    marital_status VARCHAR(30),
    education_level VARCHAR(30),
    department_id INT,
    job_role_id INT,
    job_level INT,
    FOREIGN KEY (department_id)
        REFERENCES departments(department_id),
    FOREIGN KEY (job_role_id)
        REFERENCES job_roles(job_role_id)
);
DESC EMPLOYEES;

CREATE TABLE compensation (
    employee_id INT PRIMARY KEY,
    monthly_income DECIMAL(10,2),
    stock_option_level INT,
    salary_hike_pct DECIMAL(5,2),
    FOREIGN KEY (employee_id)
        REFERENCES employees(employee_id)
);
DESC COMPENSATION;

CREATE TABLE work_experience (
    employee_id INT PRIMARY KEY,
    years_at_company DECIMAL(5,2),
    total_working_years DECIMAL(5,2),
    years_since_promotion DECIMAL(5,2),
    num_prior_companies INT,
    FOREIGN KEY (employee_id)
        REFERENCES employees(employee_id)
);
DESC WORK_EXPERIENCE;

CREATE TABLE work_environment (
    employee_id INT PRIMARY KEY,
    work_mode VARCHAR(30),
    commute_minutes INT,
    overtime_hours_per_week DECIMAL(5,2),
    business_travel_days_per_year INT,
    training_hours INT,
    manager_support_score DECIMAL(4,2),
    burnout_score DECIMAL(4,2),
    engagement_score DECIMAL(4,2),
    work_life_balance_score DECIMAL(4,2),
    uses_ai_tools_at_work BOOLEAN,
    perceived_ai_job_risk DECIMAL(4,2),
    FOREIGN KEY (employee_id)
        REFERENCES employees(employee_id)
);
ALTER TABLE work_environment
MODIFY COLUMN uses_ai_tools_at_work VARCHAR(5);
DESC WORK_ENVIRONMENT;

CREATE TABLE performance (
    employee_id INT PRIMARY KEY,
    performance_rating INT,
    last_review_score DECIMAL(4,2),
    FOREIGN KEY (employee_id)
        REFERENCES employees(employee_id)
);
 DESC PERFORMANCE;

CREATE TABLE attrition (
    employee_id INT PRIMARY KEY,
    attrition_status VARCHAR(3) NOT NULL,
    FOREIGN KEY (employee_id)
        REFERENCES employees(employee_id)
);
DESC ATTRITION;