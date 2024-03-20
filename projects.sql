

drop database new_project;
show databases;
create database project;
use project;


create table departments
( department_id int primary key,
department_name varchar(30) not null);

create table employees 
( employee_id int primary key,
first_name varchar(30) default null,
last_name varchar(30) default null,
department_id int default null,
foreign key (department_id) references departments (department_id),
hire_date date not null);


create table projects
( project_id int primary key,
project_name varchar(30) default null,
department_id int default null,
foreign key (department_id) references departments (department_id));

create table employeeprojects
( employee_id int,
foreign key (employee_id) references employees(employee_id),
project_id int,
foreign key (project_id) references projects (project_id));

select * from employeeprojects;

desc employeeprojects;
use project;

insert into departments(department_id,department_name) values (1,'sales');
insert into departments(department_id,department_name) values (2,'marketing');
insert into departments(department_id,department_name) values (3,'finance');
insert into departments(department_id,department_name) values (4,'it');
insert into departments(department_id,department_name) values (5,'executive');

insert into employees(employee_id,first_name,last_name,department_id,hire_date) values (10,'steven','smith',1,'2002-2-15');
insert into employees(employee_id,first_name,last_name,department_id,hire_date) values (11,'hazel','wood',2,'2003-3-20');
insert into employees(employee_id,first_name,last_name,department_id,hire_date) values (12,'pat','cummins',2,'2004-7-18');
insert into employees(employee_id,first_name,last_name,department_id,hire_date) values (13,'mitchel','starc',3,'2006-4-21');
insert into employees(employee_id,first_name,last_name,department_id,hire_date) values (14,'cameron','green',4,'2008-9-13');

select * from employees;

insert into projects (project_id,project_name,department_id) values (100,'SQL',1);
insert into projects (project_id,project_name,department_id) values (101,'PYTHON',2);
insert into projects (project_id,project_name,department_id) values (102,'EXCEL',3);
insert into projects (project_id,project_name,department_id) values (103,'POWERBI',3);
insert into projects (project_id,project_name,department_id) values (104,'EDA',5);

select * from projects;

insert into employeeprojects(employee_id,project_id) values (10,100);
insert into employeeprojects(employee_id,project_id) values (11,101);
insert into employeeprojects(employee_id,project_id) values (10,100);
insert into employeeprojects(employee_id,project_id) values (11,101);
insert into employeeprojects(employee_id,project_id) values (13,104);

select * from employeeprojects;

ALTER TABLE projects
ADD COLUMN startdate DATE,
ADD COLUMN enddate DATE;

UPDATE projects
SET startdate = '2022-01-01',
    enddate = '2022-11-30'
    limit 5;

    ALTER TABLE employees
ADD COLUMN salary float;

UPDATE employees
SET salary = 
  CASE 
    WHEN employee_id = 10 THEN 50000.50
    WHEN employee_id = 11 THEN 60000.75
    WHEN employee_id = 12 THEN 75000.00
    WHEN employee_id = 13 THEN 80000.25
    WHEN employee_id = 14 THEN 90000.50
  END
WHERE employee_id IN (10, 11, 12, 13, 14);


-- increse salary by 8% to the marketing department--

UPDATE employees
SET salary = salary * 1.08
WHERE department_id = 2;

-- Select the average salary of all employees ---

SELECT AVG(salary) AS average_salary FROM employees;

-- employees along with the projects they were working on --
select e.employee_id,e.first_name,e.last_name,p.project_name
from employees as e
join employeeprojects as ep
on e.employee_id = ep.employee_id
join projects as p
on p.project_id = ep.project_id;

-- Find the project with the longest duration

select  project_id,project_name,startdate,enddate,
DATEDIFF(enddate, startdate) AS duration_days
FROM projects
ORDER BY duration_days DESC;

-- count number of employees in each department--
select d.department_id,d.department_name,count(d.emloyee_id) as number_emps
from departments as d
right join employees e
on e.department_id = d.department_id;


-- Count the number of employees in each department --

SELECT d.department_id,d.department_name,COUNT(e.employee_id) AS num_employees
FROM departments d
LEFT JOIN employees e ON d.department_id = e.department_id
GROUP BY d.department_id, d.department_name;

-- retrive the names of the employees who have worked on more than one project--

 -- Retrieve names of employees who have worked on more than one project

SELECT e.employee_id,e.first_name,e.last_name
FROM employees e
JOIN employeeprojects ep ON e.employee_id = ep.employee_id
GROUP BY e.employee_id, e.first_name, e.last_name
HAVING COUNT(ep.project_id) > 1;

-- find the department with the heighest total salary expensee --

SELECT d.department_id,d.department_name,SUM(e.salary) AS total_salary_expense
FROM departments d
LEFT JOIN employees e ON d.department_id = e.department_id
GROUP BY d.department_id, d.department_name
ORDER BY total_salary_expense desc
LIMIT 1;

-- rank employees with in each department based on their salary--

-- Rank employees within each department based on their salary

SELECT employee_id,first_name,last_name,department_id,salary,
DENSE_RANK() OVER (PARTITION BY department_id ORDER BY salary DESC) AS salary_rank
FROM employees;

-- update the enddate of the project with the shortest duration to '2022-12-31'--

update projects
set enddate = '2022-12-31'
limit 5 ;

select * from projects;

-- calculate the total salary expense for the each department--

SELECT d.department_id,d.department_name,SUM(e.salary) AS total_salary_expense
FROM employees as e
join departments as d
on d.department_id = e.department_id
GROUP BY department_id, department_name;

-- Identify employees who have not been assigned to any project

select e.employee_id,e.first_name,e.last_name
from employees e
left join employeeprojects ep ON e.employee_id = ep.employee_id
where ep.employee_id is null;

-- Determine the department with the highest average project duration--

SELECT d.department_id,d.department_name,AVG(DATEDIFF(enddate, startdate)) AS avg_project_duration
FROM departments d
JOIN projects p ON d.department_id = p.department_id
GROUP BY d.department_id, d.department_name
ORDER BY avg_project_duration DESC
LIMIT 1 ;

-- classsify employees into salary ranges (eg. low,mwdium,high) based on their salary.--

select  employee_id,first_name,last_name,salary,
    case
        when salary <= 50000 then 'Low'
        when salary >= 50000 and salary < 80000 then 'Medium'
        when salary >= 80000 then 'High'
        else 'Unknown'
end as salary_range
from employees;

-- find the employee with the heighest salary--

select employee_id,first_name,last_name,salary
from employees
order by salary desc
limit 1;

-- calculate the minimum and the maximum salary of the particular department--

select min(salary) as min_salary,max(salary) as max_salary
from employees 
where department_id = 2;

                      -- 20 questions --
                      
-- 1. Retrieve all columns from the Employees table
SELECT *FROM employees;

-- 2.Retrieve employees along with their department names
SELECT e.employee_id,e.first_name,e.last_name,e.salary,d.department_name
FROM employees e
JOIN departments d ON e.department_id = d.department_id;

-- 3. Retrieve employees hired after '2020-01-01'
SELECT employee_id,first_name,last_name,hire_date
FROMemployees
WHERE hire_date > '2020-01-01';

-- 4. Calculate the average salary of employees
SELECT AVG(salary) AS average_salary
FROM employees;

-- 5.Count the number of employees in each department
SELECT department_id,COUNT(employee_id) AS num_employees
FROM employees
GROUP BY department_id;

-- 6.Retrieve employees sorted by hire date in descending order
SELECT employee_id,first_name,last_name,hire_date
FROM employees
ORDER BY hire_date DESC;

-- 7. Retrieve employees in the Finance or executive department
SELECT employee_id,first_name,last_name,department_id
FROM employees
WHERE department_id IN (3, 4); 

-- 8.Retrieve employees whose last name starts with 'S'
SELECT employee_id,first_name,last_name
FROM employees
WHERE last_name LIKE 'S%';

-- 9. Retrieve employees working on ProjectA --
SELECT e.employee_id,e.first_name,e.last_name,ep.project_id,p.project_name
FROM employees e
JOIN employeeprojects ep ON e.employee_id = ep.employee_id
JOIN projects p ON ep.project_id = p.project_id
WHERE p.project_name = 'sql';

-- 10  Retrieve employees and their project details --

select e.employee_id,p.project_id,p.project_name
from employees as e
join employeeprojects as ep
on e.employee_id = ep.employee_id
join projects as p
on p.project_id = ep.project_id;

-- 11. Retrieve all departments and their employees (including those with no employees)
select d.department_id,d.department_name,e.employee_id,e.first_name,e.last_name
from departments d
left join employees e on  d.department_id = e.department_id;

-- 12.Retrieve departments with average salary greater than 70000 --
select d.department_id,d.department_name,avg(e.salary) as average_salary
from departments as d
join employees as e
on d.department_id = e.department_id
group by department_name,department_id
having average_salary > 70000;

 -- 13.Increase the salary of all employees in the IT department by 10%. --
update employees
set salary = salary * 1.1
where department_id = 4;

-- 14.Remove employees hired before '2019-01-01'--

delete from employees
where hire_date < '2019-01-01'
limit 1;

-- 15. Find the employee with the highest salary --
select employee_id,first_name,last_name,salary
from employees 
order by salary desc
limit 1;


-- 17.Retrieve employees and their projects in the IT department

SELECT e.employee_id,e.first_name,e.last_name,p.project_name
FROM employees e
JOIN employeeprojects ep ON e.employee_id = ep.employee_id
JOIN projects p ON ep.project_id = p.project_id
WHERE e.department_id = 4; 

-- 18. Find the department with the highest average salary --

select d.department_id,d.department_name,avg(salary) as highest_avg_sal
from departments as d
join employees as e
on d.department_id = e.department_id
group by department_id,department_name
order by highest_avg_sal desc
limit 1;

-- 19.Rank employees by salary within each department --

select employee_id,first_name,last_name,salary,
dense_rank() over (partition by department_id order by salary) as salary_rank
from employees;

-- 20. Find the average project duration for each department.--

select department_id,avg(datediff(enddate,startdate))
from projects
group by department_id;

-- 21.Retrieve the earliest hire date among all employees--

select  MIN(hire_date) as earliest_hire_date
FROM employees;

-- 22. List the projects that have employees assigned to them --

SELECT distinct p.project_id,p.project_name
from projects p
join employeeprojects ep ON p.project_id = ep.project_id;

-- 23. Find the employees who have the same last name and are in the same department --

-- 24.Calculate the total salary expense for the company --

select sum(salary) as total_company_expenses from employees;

-- 25. Identify the employees with a salary above the average salary--

select employee_id,first_name,last_name,salary
from employees
where salary>(select avg(salary) from employees);

-- 26.List the projects that are active and have employees assigned to them --
-- 27. Retrieve the employees who have not been assigned to any project--

select e.employee_id,e.first_name,e.last_name
from employees e
where not exists (select 1 from employeeprojects as ep
where e.employee_id = ep.employee_id);

-- 28. Find the department with the highest total project duration--

SELECT
    d.department_id,
    d.department_name,
    SUM(DATEDIFF(p.enddate, p.startdate)) AS total_project_duration
FROM
    departments d
    JOIN projects p ON d.department_id = p.department_id
GROUP BY
    d.department_id, d.department_name
ORDER BY
    total_project_duration DESC
LIMIT 3;

-- 29. Update the end date of ProjectA to '2022-11-30 --

UPDATE projects
SET enddate = '2022-11-30'
WHERE project_name = 'python';

-- 30. Determine the employee with the lowest salary in the IT department--

SELECT employee_id,first_name,last_name,salary
FROM employees
WHERE department_id = 4 
ORDER BY salary
LIMIT 1;




