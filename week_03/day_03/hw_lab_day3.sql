--MVP
--Q1

SELECT 
	local_account_no,
	iban 
FROM pay_details 
WHERE local_account_no IS NULL AND iban IS NULL;

-- NO!

--Q2 

SELECT 
	first_name,
	last_name,
	country
FROM employees 
ORDER BY 
	country NULLS LAST,
	last_name NULLS LAST;
	
--Q3

SELECT *
FROM employees 
ORDER BY salary DESC NULLS LAST
LIMIT 10;

--Q4 

SELECT 
	first_name,
	last_name,
	salary
FROM employees 
WHERE country = 'Hungary'
ORDER BY salary ASC NULLS LAST 
LIMIT 1;

--Q5 

SELECT *
FROM employees 
WHERE email LIKE '%@yahoo%';

--Q6

SELECT 
	COUNT(id),
	pension_enrol 
FROM employees 
GROUP BY pension_enrol; 

--Q7

SELECT 
	id,
	first_name,
	last_name,
	salary
FROM employees 
WHERE department = 'Engineering' AND fte_hours = 1.0
ORDER BY salary DESC NULLS LAST 
LIMIT 1;

-- or 

SELECT 
	MAX(salary)
FROM employees 
WHERE department = 'Engineering' AND fte_hours = 1.0;

-- Q8

SELECT 
	country,
	Count(id) AS number_employees,
	AVG(salary)
	FROM employees
GROUP BY country
HAVING COUNT(id) > 30
ORDER BY AVG(salary)DESC;

-- Q9

SELECT 
	id,
	first_name,
	last_name,
	fte_hours,
	salary,
	(fte_hours * salary) AS effective_salary
FROM employees;
	
-- Q10

SELECT
	e.first_name,
	e.last_name
FROM employees AS e LEFT JOIN pay_details AS pd 
	ON e.pay_detail_id = pd.id
WHERE local_tax_code IS NULL;

-- Q11

SELECT 
	e.id,
	e.department,
	(48 * 35 * CAST(charge_cost AS INT) - salary) * fte_hours AS expected_profit
FROM employees AS e LEFT JOIN teams AS t 
	ON e.team_id = t.id 
ORDER BY expected_profit DESC NULLS LAST;

-- Q12


WITH blobs(department, avg_salary, avg_fte_hours) AS (
SELECT 
	department,
	AVG(salary) AS avg_salary,
	AVG(fte_hours) AS avg_fte_hours
FROM employees 
GROUP BY department 
ORDER BY COUNT(id) DESC NULLS LAST
LIMIT 1
)
SELECT 
	e.id, 
	e.first_name,
	e.last_name,
	e.salary,
	e.fte_hours,
	(e.salary / b.avg_salary) AS salary_ratio,
	(e.fte_hours / b.avg_fte_hours) AS hours_ratio
FROM employees AS e CROSS JOIN blobs AS b
WHERE e.department = b.department;

----- alternate way w/ INNER JOIN

WITH biggest_dept(name, avg_salary, avg_fte_hours) AS (
	SELECT
		department,
		AVG(salary),
		AVG(fte_hours)
	FROM employees 
	GROUP BY department
	ORDER BY COUNT(id) DESC NULLS LAST
	LIMIT 1
)
SELECT 
	*
FROM employees AS e
INNER JOIN biggest_dept AS db
ON e.department = db.name; 

------- Alternate way w/ sub queries

SELECT 
	id, 
	first_name, 
	last_name, 
	salary,
	fte_hours,
	department,
	salary/AVG(salary) OVER () AS ratio_avg_salary,
	fte_hours/AVG(fte_hours) OVER () AS ratio_fte_hours
FROM employees
WHERE department = (
	SELECT
	department
FROM employees 
GROUP BY department
ORDER BY COUNT(id) DESC
LIMIT 1);


--Extension
--Q1

SELECT 
	first_name,
	COUNT(id) AS num_with_name
FROM employees 
WHERE first_name IS NOT NULL 
GROUP BY first_name
HAVING COUNT(id) > 1
ORDER BY COUNT(id) DESC, first_name ASC;

--Q2

SELECT 
	COUNT(id),
	COALESCE(CAST(pension_enrol AS VARCHAR), NULL, 'unknown') AS enrolement_status
FROM employees 
GROUP BY pension_enrol

-- Q3

SELECT 
	e.first_name,
	e.last_name,
	e.email,
	e.start_date,
	c.name AS committee_name
FROM 
	(employees_committees AS ec LEFT JOIN committees AS c 
	ON ec.committee_id = c.id) LEFT JOIN employees AS e 
	ON ec.employee_id = e.id
WHERE c.name = 'Equality and Diversity';

-- Q4 

WITH blobs(id, salary_class) AS ( SELECT
	id,
	CASE
		WHEN salary < 40000 THEN 'low'
		WHEN salary >= 40000 THEN 'high'
		WHEN salary IS NULL THEN 'none'
		END AS salary_class
FROM employees
)
SELECT 
	COUNT(DISTINCT(e.id)),
	b.salary_class
FROM 
	(employees AS e LEFT JOIN blobs AS b 
	ON e.id = b.id) RIGHT JOIN employees_committees AS ec 
	ON e.id = ec.employee_id 
GROUP BY b.salary_class;
	











