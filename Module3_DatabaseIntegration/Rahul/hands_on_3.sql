

-- 35

SELECT s.student_id,
       s.first_name,
       s.last_name
FROM students s
JOIN enrollments e
ON s.student_id = e.student_id
GROUP BY s.student_id, s.first_name, s.last_name
HAVING COUNT(*) >
(
    SELECT AVG(enrollment_count)
    FROM
    (
        SELECT COUNT(*) AS enrollment_count
        FROM enrollments
        GROUP BY student_id
    ) avg_table
);



-- 36.

SELECT c.course_id,
       c.course_name
FROM courses c
WHERE NOT EXISTS
(
    SELECT *
    FROM enrollments e
    WHERE e.course_id = c.course_id
      AND e.grade <> 'A'
);



-- 37. 
SELECT p.professor_id,
       p.first_name,
       p.last_name,
       p.department_id,
       p.salary
FROM professors p
WHERE p.salary =
(
    SELECT MAX(p2.salary)
    FROM professors p2
    WHERE p2.department_id = p.department_id
);



-- 38.
SELECT *
FROM
(
    SELECT department_id,
           AVG(salary) AS avg_salary
    FROM professors
    GROUP BY department_id
) dept_avg
WHERE avg_salary > 85000;





-- 39. 

CREATE VIEW vw_student_enrollment_summary AS
SELECT
    s.student_id,
    CONCAT(s.first_name,' ',s.last_name) AS student_name,
    d.dept_name,
    COUNT(e.course_id) AS total_courses,
    AVG(
        CASE
            WHEN e.grade='A' THEN 4
            WHEN e.grade='B' THEN 3
            WHEN e.grade='C' THEN 2
            WHEN e.grade='D' THEN 1
            WHEN e.grade='F' THEN 0
        END
    ) AS GPA
FROM students s
JOIN departments d
ON s.department_id = d.department_id
LEFT JOIN enrollments e
ON s.student_id = e.student_id
GROUP BY s.student_id,
         student_name,
         d.dept_name;



-- 40. 

CREATE VIEW vw_course_stats AS
SELECT
    c.course_name,
    c.course_code,
    COUNT(e.student_id) AS total_enrollments,
    AVG(
        CASE
            WHEN e.grade='A' THEN 4
            WHEN e.grade='B' THEN 3
            WHEN e.grade='C' THEN 2
            WHEN e.grade='D' THEN 1
            WHEN e.grade='F' THEN 0
        END
    ) AS avg_gpa
FROM courses c
LEFT JOIN enrollments e
ON c.course_id = e.course_id
GROUP BY c.course_id,
         c.course_name,
         c.course_code;



-- 41.

SELECT *
FROM vw_student_enrollment_summary
WHERE GPA > 3.0;



-- 42.
UPDATE vw_student_enrollment_summary
SET GPA = 4
WHERE student_id = 1;



DROP VIEW IF EXISTS vw_student_enrollment_summary;
DROP VIEW IF EXISTS vw_course_stats;



-

CREATE VIEW vw_student_enrollment_summary AS
SELECT
    student_id,
    first_name,
    last_name,
    department_id
FROM students
WHERE department_id = 1
WITH CHECK OPTION;





DELIMITER //

CREATE PROCEDURE sp_enroll_student
(
    IN p_student_id INT,
    IN p_course_id INT,
    IN p_enrollment_date DATE
)
BEGIN

    DECLARE enroll_count INT;

    SELECT COUNT(*)
    INTO enroll_count
    FROM enrollments
    WHERE student_id = p_student_id
      AND course_id = p_course_id;

    IF enroll_count = 0 THEN

        INSERT INTO enrollments
        (
            student_id,
            course_id,
            enrollment_date
        )
        VALUES
        (
            p_student_id,
            p_course_id,
            p_enrollment_date
        );

        SELECT 'Student Enrolled Successfully';

    ELSE

        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT =
        'Duplicate Enrollment Not Allowed';

    END IF;

END //

DELIMITER ;




CALL sp_enroll_student(1,2,'2025-06-18');




CREATE TABLE department_transfer_log
(
    log_id INT AUTO_INCREMENT PRIMARY KEY,
    student_id INT,
    old_department_id INT,
    new_department_id INT,
    transfer_date DATETIME
);



DELIMITER //

CREATE PROCEDURE sp_transfer_student
(
    IN p_student_id INT,
    IN p_new_department_id INT
)
BEGIN

    DECLARE old_dept INT;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
    END;

    START TRANSACTION;

    SELECT department_id
    INTO old_dept
    FROM students
    WHERE student_id = p_student_id;

    UPDATE students
    SET department_id = p_new_department_id
    WHERE student_id = p_student_id;

    INSERT INTO department_transfer_log
    (
        student_id,
        old_department_id,
        new_department_id,
        transfer_date
    )
    VALUES
    (
        p_student_id,
        old_dept,
        p_new_department_id,
        NOW()
    );

    COMMIT;

END //

DELIMITER ;





CALL sp_transfer_student(1,2);





CALL sp_transfer_student(1,999);

SELECT *
FROM students
WHERE student_id = 1;

SELECT *
FROM department_transfer_log;





START TRANSACTION;

INSERT INTO enrollments
(student_id,course_id,enrollment_date)
VALUES
(1,1,'2025-06-18');

SAVEPOINT sp1;

INSERT INTO enrollments
(student_id,course_id,enrollment_date)
VALUES
(1,999,'2025-06-18');

ROLLBACK TO SAVEPOINT sp1;

COMMIT;

SELECT *
FROM enrollments
WHERE student_id = 1;