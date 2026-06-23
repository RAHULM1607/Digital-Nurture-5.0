
Task 48: EXPLAIN FORMAT=JSON

Query:
SELECT s.first_name, s.last_name, c.course_name
FROM enrollments e
JOIN students s
    ON s.student_id = e.student_id
JOIN courses c
    ON c.course_id = e.course_id
WHERE s.enrollment_year = 2022;


Task 49: Table Scan Analysis

The query plan shows:

students -> access_type = ALL
This indicates a Full Table Scan on the students table.

enrollments -> access_type = ref
Uses an index lookup.

courses -> access_type = eq_ref
Uses the primary key index.

Task 50: Rows Examined

Estimated rows examined:

students    : 100 rows
enrollments : 20 rows
courses     : 1 row

Observation:
A Full Table Scan occurs on the students table because MySQL scans all rows to find students with enrollment_year = 2022.
Creating an index on enrollment_year can improve performance.

Suggested Index:

CREATE INDEX idx_students_enrollment_year
ON students(enrollment_year);

Task 51:
CREATE INDEX idx_students_enrollment_year
ON students(enrollment_year);

Task 52:
CREATE UNIQUE INDEX idx_enrollments_student_course
ON enrollments(student_id, course_id);

Task 53:
CREATE INDEX idx_courses_course_code
ON courses(course_code);

Task 54:
CREATE INDEX idx_enrollments_student_null_grade
ON enrollments(student_id)
WHERE grade IS NULL;

Task 55:
import mysql.connector

conn = mysql.connector.connect(
    host="localhost",
    user="root",
    password="your_password",
    database="college_db"
)

cursor = conn.cursor()

# Query 1
cursor.execute("SELECT * FROM enrollments")
enrollments = cursor.fetchall()

query_count = 1

# N Queries
for enrollment in enrollments:
    student_id = enrollment[1]  # student_id column

    cursor.execute(
        "SELECT first_name, last_name FROM students WHERE student_id = %s",
        (student_id,)
    )

    cursor.fetchone()
    query_count += 1

print("Total Queries Executed:", query_count)

cursor.close()
conn.close()

Task 56:
SELECT e.enrollment_id,
           e.student_id,
           s.first_name,
           s.last_name
    FROM enrollments e
    JOIN students s
    ON e.student_id = s.student_id
Task 57:
import mysql.connector
import time

conn = mysql.connector.connect(
    host="localhost",
    user="root",
    password="your_password",
    database="college_db"
)

cursor = conn.cursor()


start = time.time()

cursor.execute("SELECT * FROM enrollments")
enrollments = cursor.fetchall()

query_count_n1 = 1

for enrollment in enrollments:
    student_id = enrollment[1]

    cursor.execute(
        "SELECT first_name, last_name FROM students WHERE student_id = %s",
        (student_id,)
    )
    cursor.fetchone()
    query_count_n1 += 1

end = time.time()
n1_time = end - start


start = time.time()

cursor.execute("""
    SELECT e.enrollment_id,
           e.student_id,
           s.first_name,
           s.last_name
    FROM enrollments e
    JOIN students s
    ON e.student_id = s.student_id
""")

cursor.fetchall()

end = time.time()
join_time = end - start


print("N+1 Queries:", query_count_n1)
print("N+1 Time:", n1_time, "seconds")

print("JOIN Queries: 1")
print("JOIN Time:", join_time, "seconds")

cursor.close()
conn.close()

Task 59:

In the N+1 approach:

1 query is executed to fetch all enrollments.

SELECT * FROM enrollments;


SELECT e.*, s.first_name, s.last_name
FROM enrollments e
JOIN students s
ON e.student_id = s.student_id;




