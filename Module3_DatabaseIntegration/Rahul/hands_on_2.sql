
-- 16. Insert two additional students

INSERT INTO students
(student_id, first_name, last_name, email, enrollment_year, department_id)
VALUES
(9, 'Rahul', 'Kumar', '[rahul@college.edu](mailto:rahul@college.edu)', 2024, 1);

INSERT INTO students
(student_id, first_name, last_name, email, enrollment_year, department_id)
VALUES
(10, 'Priya', 'Sharma', '[priya@college.edu](mailto:priya@college.edu)', 2024, 2);



-- 17. Update grade from C to B

UPDATE enrollments
SET grade = 'B'
WHERE student_id = 5
AND course_id = 1;



-- 18. Preview rows before deletion

SELECT *
FROM enrollments
WHERE grade IS NULL;

-- Delete rows with NULL grades

DELETE FROM enrollments
WHERE grade IS NULL;

-- Verify row count

SELECT COUNT(*) AS total_enrollments
FROM enrollments;



-- 20. Students enrolled in 2022

SELECT *
FROM students
WHERE enrollment_year = 2022
ORDER BY last_name ASC;

-- 21. Courses with more than 3 credits

SELECT *
FROM courses
WHERE credits > 3
ORDER BY credits DESC;

-- 22. Professors with salary between 80000 and 95000

SELECT *
FROM professors
WHERE salary BETWEEN 80000 AND 95000;

-- 23. Students whose email ends with @college.edu

SELECT *
FROM students
WHERE email LIKE '%@college.edu';

-- 24. Count students per enrollment year

SELECT enrollment_year,
COUNT(*) AS student_count
FROM students
GROUP BY enrollment_year;



-- 25. Student full name with department

SELECT CONCAT(s.first_name,' ',s.last_name) AS student_name,
d.dept_name
FROM students s
JOIN departments d
ON s.department_id = d.department_id;

-- 26. Enrollment with student and course details

SELECT CONCAT(s.first_name,' ',s.last_name) AS student_name,
c.course_name,
e.grade
FROM enrollments e
JOIN students s
ON e.student_id = s.student_id
JOIN courses c
ON e.course_id = c.course_id;

-- 27. Students not enrolled in any course

SELECT s.student_id,
s.first_name,
s.last_name
FROM students s
LEFT JOIN enrollments e
ON s.student_id = e.student_id
WHERE e.student_id IS NULL;

-- 28. Courses with enrollment count

SELECT c.course_name,
COUNT(e.student_id) AS enrollment_count
FROM courses c
LEFT JOIN enrollments e
ON c.course_id = e.course_id
GROUP BY c.course_id, c.course_name;

-- 29. Departments with professors and salaries

SELECT d.dept_name,
p.prof_name,
p.salary
FROM departments d
LEFT JOIN professors p
ON d.department_id = p.department_id;



-- 30. Total enrollments per course

SELECT c.course_name,
COUNT(e.student_id) AS enrollment_count
FROM courses c
LEFT JOIN enrollments e
ON c.course_id = e.course_id
GROUP BY c.course_id, c.course_name;

-- 31. Average salary per department

SELECT d.dept_name,
ROUND(AVG(p.salary), 2) AS avg_salary
FROM departments d
JOIN professors p
ON d.department_id = p.department_id
GROUP BY d.dept_name;

-- 32. Departments with budget > 600000

SELECT dept_name,
budget
FROM departments
WHERE budget > 600000;

-- 33. Grade distribution for CS101

SELECT e.grade,
COUNT(*) AS grade_count
FROM enrollments e
JOIN courses c
ON e.course_id = c.course_id
WHERE c.course_code = 'CS101'
GROUP BY e.grade;

-- 34. Departments with more than 2 enrolled students

SELECT d.dept_name,
COUNT(e.student_id) AS total_students
FROM departments d
JOIN students s
ON d.department_id = s.department_id
JOIN enrollments e
ON s.student_id = e.student_id
GROUP BY d.dept_name
HAVING COUNT(e.student_id) > 2;
