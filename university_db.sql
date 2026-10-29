-- University Information System Schema
-- Normalized to 3NF: students, instructors, courses, and enrollments are stored separately.

CREATE TABLE students (
    student_id INT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    age INT NOT NULL CHECK (age > 17)
);

CREATE TABLE instructors (
    instructor_id INT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    department VARCHAR(100) NOT NULL
);

CREATE TABLE courses (
    course_id INT PRIMARY KEY,
    title VARCHAR(150) NOT NULL UNIQUE,
    credits INT NOT NULL CHECK (credits > 0),
    instructor_id INT NOT NULL,
    FOREIGN KEY (instructor_id) REFERENCES instructors(instructor_id)
);

CREATE TABLE enrollments (
    student_id INT NOT NULL,
    course_id INT NOT NULL,
    grade CHAR(2) CHECK (grade IN ('A', 'A-', 'B', 'B+', 'B-', 'C', 'C+', 'C-', 'D', 'D+', 'D-', 'F')),
    PRIMARY KEY (student_id, course_id),
    FOREIGN KEY (student_id) REFERENCES students(student_id) ON DELETE CASCADE,
    FOREIGN KEY (course_id) REFERENCES courses(course_id) ON DELETE CASCADE
);

-- Sample data
INSERT INTO instructors (instructor_id, name, department) VALUES
    (1, 'Dr. Emily Carter', 'Computer Science'),
    (2, 'Prof. Daniel Lee', 'Mathematics'),
    (3, 'Dr. Sarah Patel', 'Information Systems');

INSERT INTO students (student_id, name, email, age) VALUES
    (1, 'Alice Johnson', 'alice.johnson@example.com', 20),
    (2, 'Bob Smith', 'bob.smith@example.com', 22),
    (3, 'Carol Davis', 'carol.davis@example.com', 19);

INSERT INTO courses (course_id, title, credits, instructor_id) VALUES
    (101, 'Database Systems', 3, 1),
    (102, 'Algorithms', 4, 2),
    (103, 'Computer Networks', 3, 3);

INSERT INTO enrollments (student_id, course_id, grade) VALUES
    (1, 101, 'A'),
    (2, 101, 'B'),
    (1, 102, 'A-'),
    (3, 103, 'C+');

-- Query 1: Retrieve all students enrolled in the course "Database Systems"
SELECT s.student_id, s.name, s.email
FROM students s
JOIN enrollments e ON s.student_id = e.student_id
JOIN courses c ON e.course_id = c.course_id
WHERE c.title = 'Database Systems';

-- Query 2: List all courses along with the names of their instructors
SELECT c.course_id, c.title, c.credits, i.name AS instructor_name, i.department
FROM courses c
JOIN instructors i ON c.instructor_id = i.instructor_id;

-- Query 3: Find students who are not enrolled in any course
SELECT s.student_id, s.name, s.email
FROM students s
LEFT JOIN enrollments e ON s.student_id = e.student_id
WHERE e.student_id IS NULL;

-- Query 4: Update the email address of a student
UPDATE students
SET email = 'alice.johnson.new@example.com'
WHERE student_id = 1;

-- Query 5: Delete a course by its ID
DELETE FROM courses
WHERE course_id = 103;
