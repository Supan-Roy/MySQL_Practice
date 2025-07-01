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
