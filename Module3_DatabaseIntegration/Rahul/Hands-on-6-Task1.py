from sqlalchemy import create_engine, Column, Integer, String, ForeignKey, Date
from sqlalchemy.orm import declarative_base, relationship
engine = create_engine(
    "mysql+mysqlconnector://root:root@localhost/college_db_orm",
    echo=True
)
Base = declarative_base()
class Student(Base):
    __tablename__ = "students"

    student_id = Column(Integer, primary_key=True)
    student_name = Column(String(100))
    email = Column(String(100))

department_id = Column(
    Integer,
    ForeignKey("departments.department_id")
)
student_id = Column(
    Integer,
    ForeignKey("students.student_id")
)

course_id = Column(
    Integer,
    ForeignKey("courses.course_id")
)
students = relationship(
    "Student",
    back_populates="department"
)
department = relationship(
    "Department",
    back_populates="students"
)
enrollments = relationship(
    "Enrollment",
    back_populates="course"
)
course = relationship(
    "Course",
    back_populates="enrollments"
)
professors = relationship(
    "Professor",
    back_populates="department"
)
department = relationship(
    "Department",
    back_populates="professors"
)
Base.metadata.create_all(engine)

print("Tables Created Successfully")
