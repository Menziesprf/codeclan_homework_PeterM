--MVP
--Q1
SELECT 
	e.*,
	pd.local_account_no,
	pd.local_sort_code
FROM employees AS e LEFT JOIN pay_details AS pd
ON e.pay_detail_id = pd.id;

--Q2
SELECT 
	e.*,
	pd.local_account_no,
	pd.local_sort_code,
	t.name AS team_name
FROM 
	(employees AS e LEFT JOIN pay_details AS pd
	ON e.pay_detail_id = pd.id) LEFT JOIN teams AS t 
		ON e.team_id = t.id;
		
-- Q3

SELECT 
	e.first_name,
	e.last_name,
	t.name AS team_name,
	t.charge_cost 
FROM employees AS e LEFT JOIN teams AS t 
	ON e.team_id = t.id 
WHERE CAST(t.charge_cost AS INT) > 80
ORDER BY e.last_name NULLS LAST;

--Q4

SELECT 
	t.name AS team_name,
	count(e.id) AS num_employees
FROM teams AS t LEFT JOIN employees AS e 
ON t.id = e.team_id 
GROUP BY t.name

-- Q5

SELECT 
	e.id,
	e.first_name,
	e.last_name,
	e.fte_hours,
	e.salary,
	(e.fte_hours * e.salary) AS effective_salary,
	SUM(e.fte_hours * e.salary) OVER (ORDER BY e.fte_hours * e.salary) AS running_total
FROM employees AS e 


-- Q6

WITH blobs(id, team_name, num_per_team) AS (
SELECT
	t.id,
	t.name AS team_name,
	COUNT(e.id) OVER (PARTITION BY t.id) AS num_per_team
FROM teams AS t LEFT JOIN employees AS e
	ON t.id = e.team_id 
)
SELECT 
	t.name AS team_name,
	blobs.num_per_team,
	t.charge_cost,
	(CAST(t.charge_cost AS INT) * blobs.num_per_team) AS total_day_charge
FROM teams AS t LEFT JOIN blobs
	ON t.id = blobs.id
GROUP BY t.name, blobs.num_per_team, t.charge_cost;

-- Q7

WITH blobs(id, team_name, num_per_team) AS (
SELECT
	t.id,
	t.name AS team_name,
	COUNT(e.id) OVER (PARTITION BY t.id) AS num_per_team
FROM teams AS t LEFT JOIN employees AS e
	ON t.id = e.team_id 
)
SELECT 
	t.name AS team_name,
	blobs.num_per_team,
	t.charge_cost,
	(CAST(t.charge_cost AS INT) * blobs.num_per_team) AS total_day_charge
FROM teams AS t LEFT JOIN blobs
	ON t.id = blobs.id
GROUP BY t.name, blobs.num_per_team, t.charge_cost
HAVING (CAST(t.charge_cost AS INT) * blobs.num_per_team) > 5000;


--- EXTENSION
-- Q1
SELECT 
	e.id,
	e.first_name,
	e.last_name 
FROM employees AS e INNER JOIN employees_committees AS ec 
	ON e.id = ec.employee_id;

-- 24 returns so entire emp_com table joined on
-- 2 employees on 2 committees so 

SELECT 
	DISTINCT(e.id),
	e.first_name,
	e.last_name 
FROM employees AS e INNER JOIN employees_committees AS ec 
	ON e.id = ec.employee_id;

-- Q2

SELECT 
	DISTINCT(e.id),
	e.first_name,
	e.last_name 
FROM employees AS e LEFT JOIN employees_committees AS ec 
	 ON e.id = ec.employee_id WHERE ec.employee_id IS NULL;

	 -- 974 aren't on a committee

-- Q3

SELECT 
	DISTINCT(e.id),
	e.first_name,
	e.last_name,
	c.name AS committee_name
FROM (employees AS e INNER JOIN employees_committees AS ec 
	ON e.id = ec.employee_id) LEFT JOIN committees AS c 
	ON ec.committee_id = c.id
WHERE e.country = 'China';

-- Q4 
	 
WITH blobs(id, first_name, last_name) AS (
SELECT 
	DISTINCT(e.id),
	e.first_name,
	e.last_name,
	e.team_id 
FROM employees AS e INNER JOIN employees_committees AS ec 
	ON e.id = ec.employee_id
) SELECT 
	b.id,
	b.first_name,
	b.last_name,
	t.name AS team_name,
	COUNT(b.id) OVER (PARTITION BY t.name) AS num_in_committee
FROM blobs AS b FULL JOIN teams as t
	ON b.team_id = t.id
ORDER BY num_in_committee DESC;
	 
	 
	 