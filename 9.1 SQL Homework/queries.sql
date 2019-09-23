
DROP TABLE IF EXISTS employees;
CREATE TABLE employees (
    emp_no Integer NOT NULL,
    birth_date Date NOT NULL,
    first_name Varchar(30) NOT NULL,
    last_name Varchar(30)  NOT NULL,
    gender Varchar(1)  NOT NULL,
    hire_date Date NOT NULL,
	PRIMARY KEY (emp_no)
    
);


DROP TABLE IF EXISTS departments;
CREATE TABLE departments (
    dept_no Varchar(4) NOT NULL,
    dept_name Varchar(30) NOT NULL,
    PRIMARY KEY (dept_no)
);


DROP TABLE IF EXISTS titles;
CREATE TABLE titles (
    emp_no Integer NOT NULL,
    title Varchar(30) NOT NULL,
    from_date Date NOT NULL,
    to_date Date NOT NULL,
	FOREIGN KEY (emp_no) REFERENCES employees(emp_no)
);

DROP TABLE IF EXISTS salaries;
CREATE TABLE salaries (
    emp_no Integer NOT NULL,
    salary Integer NOT NULL,
    from_date Date NOT NULL,
    to_date Date NOT NULL,
	FOREIGN KEY (emp_no) REFERENCES employees(emp_no)
);



DROP TABLE IF EXISTS dept_manager;
CREATE TABLE dept_manager (
 dept_no Varchar(4) NOT NULL,
	emp_no Integer NOT NULL,
	FOREIGN KEY (dept_no) REFERENCES departments(dept_no),
	FOREIGN KEY (emp_no) REFERENCES employees(emp_no),
 from_date Date NOT NULL,
 to_date Date NOT NULL
	
);

DROP TABLE IF EXISTS dept_emp;
CREATE TABLE dept_emp (
	emp_no Integer NOT NULL,
    dept_no Varchar(4) NOT NULL,
	FOREIGN KEY (emp_no) REFERENCES employees(emp_no),
	FOREIGN KEY (dept_no) REFERENCES departments(dept_no),
    from_date Date NOT NULL,
    to_date Date NOT NULL
	
);

-- List the following details of each employee: employee number, last name, first name, gender, and salary.

SELECT e.emp_no, e.last_name, e.first_name, e.gender, s.salary
FROM employees AS e
INNER JOIN salaries AS s ON
e.emp_no=s.emp_no
Order by emp_no;

-- List employees who were hired in 1986.

SELECT first_name, last_name
FROM employees
WHERE hire_date >= '1986/01/01' and hire_date <= '1986/12/31';

--SELECT COUNT(*) FROM (
-- List the manager of each department with the following information: department number, department name, 
-- the manager's employee number, last name, first name, and start and end employment dates.

Select  d.dept_no, d.dept_name, dm.emp_no, e.last_name, e.first_name, dm.from_date, dm.to_date  
FROM dept_manager as dm
INNER JOIN departments as d 
ON dm.dept_no=d.dept_no
INNER JOIN employees as e
ON dm.emp_no = e.emp_no;


-- List the department of each employee with the following information: 
--employee number, last name, first name, and department name.

Select de.emp_no,  e.last_name, e.first_name,d.dept_name
FROM dept_emp as de
INNER JOIN departments as d 
ON de.dept_no=d.dept_no
INNER JOIN employees as e
ON de.emp_no = e.emp_no
Order by emp_no;

-- List all employees whose first name is "Hercules" and last names begin with "B."
SELECT *
FROM employees 
WHERE first_name = 'Hercules' and last_name LIKE 'B%';

-- List all employees in the Sales department, including their employee number, last name, first name, and department name.
Select de.emp_no,  e.last_name, e.first_name,d.dept_name
FROM dept_emp as de
INNER JOIN departments as d 
ON de.dept_no=d.dept_no
INNER JOIN employees as e
ON de.emp_no = e.emp_no
WHERE d.dept_name = 'Sales'
Order by de.emp_no;

-- List all employees in the Sales and Development departments, including their employee number, last name, first name, and department name.
Select de.emp_no,  e.last_name, e.first_name,d.dept_name
FROM dept_emp as de
INNER JOIN departments as d 
ON de.dept_no=d.dept_no
INNER JOIN employees as e
ON de.emp_no = e.emp_no
WHERE d.dept_name = 'Sales' OR d.dept_name = 'Development'
Order by de.emp_no;

-- In descending order, list the frequency count of employee last names, i.e., how many employees share each last name.

SELECT last_name, COUNT(last_name) AS "Last Name Count"
FROM employees
GROUP BY last_name
ORDER BY "Last Name Count" DESC;

--Epilogue
SELECT * 
FROM employees
WHERE emp_no= 499942;
