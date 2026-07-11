

from sqlalchemy.orm import joinedload



print("\n========== WITHOUT joinedload() ==========")


enrollments = session.query(Enrollment).all()

for e in enrollments:
    print(
        f"Student: {e.student.student_name} | Course: {e.course.course_name}"
    )

print("\nObserve the SQL logs above.")
print("You will notice many SELECT statements.")
print("Example Query Count: 13")



print("\n========== WITH joinedload() ==========")

enrollments = (
    session.query(Enrollment)
    .options(
        joinedload(Enrollment.student),
        joinedload(Enrollment.course)
    )
    .all()
)

for e in enrollments:
    print(
        f"Student: {e.student.student_name} | Course: {e.course.course_name}"
    )

print("\nObserve the SQL logs again.")
print("Only ONE SQL query should be executed.")



print("\n========== QUERY COMPARISON ==========")
print("Without joinedload() : 13 SQL Queries (example)")
print("With joinedload()    : 1 SQL Query")



"""
Django ORM

Without Optimization:

enrollments = Enrollment.objects.all()

for e in enrollments:
    print(e.student.student_name, e.course.course_name)



With select_related():

enrollments = Enrollment.objects.select_related(
    'student',
    'course'
).all()

for e in enrollments:
    print(e.student.student_name, e.course.course_name)

select_related() performs SQL JOINs and avoids
the N+1 query problem, just like SQLAlchemy's joinedload().
"""
