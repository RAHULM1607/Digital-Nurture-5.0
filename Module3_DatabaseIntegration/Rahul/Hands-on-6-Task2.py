from sqlalchemy.orm import sessionmaker
from models import engine, Department, Student, Course, Enrollment
from datetime import date


Session = sessionmaker(bind=engine)
session = Session()


dept1 = Department(dept_name="Computer Science")
dept2 = Department(dept_name="Electronics")
dept3 = Department(dept_name="Mechanical")

session.add_all([dept1, dept2, dept3])
session.commit()



student1 = Student(
    student_name="Rahul",
    email="rahul@gmail.com",
    enrollment_year=2023,
    department=dept1
)

student2 = Student(
    student_name="Priya",
    email="priya@gmail.com",
    enrollment_year=2022,
    department=dept1
)

student3 = Student(
    student_name="Arun",
    email="arun@gmail.com",
    enrollment_year=2023,
    department=dept2
)

student4 = Student(
    student_name="Kiran",
    email="kiran@gmail.com",
    enrollment_year=2021,
    department=dept3
)

student5 = Student(
    student_name="Meena",
    email="meena@gmail.com",
    enrollment_year=2022,
    department=dept2
)

session.add_all([student1, student2, student3, student4, student5])
session.commit()



course1 = Course(course_name="Java", credits=4)
course2 = Course(course_name="Python", credits=3)
course3 = Course(course_name="DBMS", credits=4)

session.add_all([course1, course2, course3])
session.commit()



enrollment1 = Enrollment(
    student=student1,
    course=course1,
    enrollment_date=date.today(),
    grade="A"
)

enrollment2 = Enrollment(
    student=student2,
    course=course2,
    enrollment_date=date.today(),
    grade="B"
)

enrollment3 = Enrollment(
    student=student3,
    course=course3,
    enrollment_date=date.today(),
    grade="A"
)

enrollment4 = Enrollment(
    student=student4,
    course=course1,
    enrollment_date=date.today(),
    grade="A+"
)

session.add_all([enrollment1, enrollment2, enrollment3, enrollment4])
session.commit()



students = session.query(Student)\
    .join(Department)\
    .filter(Department.dept_name == "Computer Science")\
    .all()

print("\nStudents in Computer Science Department:")
for s in students:
    print(s.student_name)



print("\nStudent Name - Course Name")

enrollments = session.query(Enrollment).all()

for e in enrollments:
    print(e.student.student_name, "-", e.course.course_name)


student = session.query(Student)\
    .filter_by(email="rahul@gmail.com")\
    .first()

if student:
    student.enrollment_year = 2025
    session.commit()
    print("\nStudent Updated Successfully")



enrollment_obj = session.query(Enrollment).first()

if enrollment_obj:
    session.delete(enrollment_obj)
    session.commit()
    print("Enrollment Deleted Successfully")

session.close()
