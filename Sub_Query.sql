Students(id, name, age)
Marks(id, student_id, subject, score)
-- 1. Subquery in WHERE (Single Row Subquery)
-- Q: Find students who got the highest Math score.
SELECT name
FROM Students
WHERE id = (
    SELECT student_id
    FROM Marks
    WHERE subject = 'Math'
    ORDER BY score DESC
    LIMIT 1
);

-- 2. Subquery with IN (Multiple Row Subquery)
-- Q: Find students who appeared in the Math exam.
SELECT name
FROM Students
WHERE id IN (
    SELECT student_id
    FROM Marks
    WHERE subject = 'Math'
);

-- 3. Correlated Subquery
-- Q: Find students who scored above average in Math.
SELECT name
FROM Students s
WHERE id IN (
    SELECT student_id
    FROM Marks
    WHERE subject = 'Math' AND score > (
        SELECT AVG(score)
        FROM Marks
        WHERE subject = 'Math'
    )
);

-- 4. Subquery in FROM
-- Q: Find the average score per student, then filter those with average > 70.
SELECT name, avg_score
FROM (
    SELECT student_id, AVG(score) AS avg_score
    FROM Marks
    GROUP BY student_id
) AS avg_table
JOIN Students ON avg_table.student_id = Students.id
WHERE avg_score > 70;

-- 5. Subquery in SELECT clause
-- Q: Show each student's name and their average score.
SELECT name,
    (SELECT AVG(score)
     FROM Marks
     WHERE Marks.student_id = Students.id) AS average_score
FROM Students;

-- Problem 1: Students who never took Math
SELECT name
FROM Students
WHERE id NOT IN (
    SELECT student_id
    FROM Marks
    WHERE subject = 'Math'
);

-- Problem 2: Students who took all subjects Riya did
SELECT DISTINCT s.name
FROM Students s
WHERE NOT EXISTS (
    SELECT subject
    FROM Marks
    WHERE student_id = (
        SELECT id FROM Students WHERE name = 'Riya'
    )
    EXCEPT
    SELECT subject
    FROM Marks m2
    WHERE m2.student_id = s.id
);

-- Problem 3: Students whose age is above average age
SELECT name, age
FROM Students
WHERE age > (
    SELECT AVG(age) FROM Students
);

-- Problem 4: Top scorer per subject
SELECT subject, student_id, score
FROM Marks m
WHERE score = (
    SELECT MAX(score)
    FROM Marks
    WHERE subject = m.subject
);

-- Problem 5: Students who scored more than Riya's average
SELECT name
FROM Students
WHERE id IN (
    SELECT student_id
    FROM Marks
    GROUP BY student_id
    HAVING AVG(score) > (
        SELECT AVG(score)
        FROM Marks
        WHERE student_id = (SELECT id FROM Students WHERE name = 'Riya')
    )
);

-- Problem 6: Student with second highest average score
SELECT name
FROM Students
WHERE id = (
    SELECT student_id
    FROM (
        SELECT student_id, AVG(score) AS avg_score
        FROM Marks
        GROUP BY student_id
        ORDER BY avg_score DESC
        LIMIT 1 OFFSET 1
    ) AS second_top
);

-- Problem 7: List each student and number of subjects more than 1
SELECT name
FROM Students
WHERE id IN (
    SELECT student_id
    FROM Marks
    GROUP BY student_id
    HAVING COUNT(DISTINCT subject) > 1
);

