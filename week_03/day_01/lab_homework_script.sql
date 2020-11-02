--MVP
--Q1
SELECT *
FROM employees 
WHERE department = 'Human Resources';

--Q2
SELECT
	first_name,
	last_name,
	country
FROM employees 
WHERE department = 'Legal';

--Q3
SELECT 
	COUNT(id) AS number_portugal_employees
FROM employees 
WHERE country = 'Portugal';

--Q4
SELECT 
	COUNT(id) AS num_portugal_or_spain_employees
FROM employees 
WHERE country = 'Portugal' OR country = 'Spain';

--Q5
SELECT
	count(id) AS missing_local_account_no
FROM pay_details 
WHERE local_account_no IS NULL;

--Q6
SELECT 
	first_name,
	last_name
FROM employees 
ORDER BY last_name NULLS LAST;

--Q7
SELECT
	COUNT(id) AS num_begins_F
FROM employees
WHERE first_name LIKE 'F%';

--Q8
SELECT 
	COUNT(id) AS num_pensioned
FROM employees 
WHERE (pension_enrol = TRUE) AND (country NOT IN ('France', 'Germnay'));

--Q9
SELECT 
	department,
	COUNT(id) AS num_since_03
FROM employees
WHERE start_date BETWEEN '2003-01-01' AND '2003-12-31'
GROUP BY department;

--Q10
SELECT
	department,
	fte_hours,
	COUNT(id) AS num_employees
FROM employees 
GROUP BY 
	fte_hours,
	department 
ORDER BY 
	department,
	fte_hours ASC;
	
--Q11
SELECT 
	department,
	COUNT(id) AS num_employees
FROM employees 
WHERE first_name IS NULL
GROUP BY department 
HAVING COUNT(id) >= 2
ORDER BY 
	COUNT(id) DESC,
	department ;

--Q12
SELECT
	department,
	((CAST(SUM(CAST(grade = 1 AS INT)) AS REAL) / COUNT(id)) * 100) AS percent_grade_1
FROM employees
GROUP BY department
ORDER BY percent_grade_1; 

-- EXTENSION
-- Q1
SELECT 
	start_date 
FROM employees
GROUP BY EXTRACT (YEAR FROM start_date);

-- Q2
SELECT 
	first_name,
	last_name,
	salary
FROM employees
WHERE ;








