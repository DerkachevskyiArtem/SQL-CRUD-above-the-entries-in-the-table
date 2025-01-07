CREATE TABLE workers (
  id SERIAL PRIMARY KEY,
  full_name VARCHAR(255) NOT NULL,
  department VARCHAR(255),
  birthday DATE CHECK (birthday <= current_date - INTERVAL '18 years' AND birthday >= '1895-01-06'),
  salary NUMERIC(10, 2)
);

ALTER TABLE workers
ADD COLUMN vacation_days SMALLINT DEFAULT 0 CHECK (vacation_days >= 0);

ALTER TABLE workers
ADD COLUMN email VARCHAR(255) UNIQUE;

ALTER TABLE workers
ALTER COLUMN email SET NOT NULL;

ALTER TABLE workers
ADD CHECK (email != '');

ALTER TABLE workers
ALTER COLUMN salary SET DEFAULT 500;


ALTER TABLE workers
RENAME TO employees;

/*
  Додати співробітника Микиту, 90го року народження, зарплата 300$.
  Додати співробітника Світлану с зарплатнею 1200$.
  Додайте двох робітників одним запитом. Ярослав с зарплатнею 1500$ та 80 роком народження та  Павла с зарплатнею1000$ та 93 роком.
  Також можна додати ще декількох співробітників для виконання наступних завдань)
*/

INSERT INTO employees (full_name, department, birthday, salary, vacation_days, email)
VALUES ('Микита', 'IT', '1990-01-01', 300, 0, 'mykyta@example.com')
RETURNING *;


INSERT INTO employees (
  full_name,
  department,
  birthday,
  salary,
  vacation_days,
  email
)
VALUES ('Світлана', 'IT', '1990-01-01', 1200, 0, 'svitlant@example.com')
RETURNING *;

INSERT INTO employees (full_name, department, birthday, salary, vacation_days, email)
VALUES
  ('Ярослав', 'Finance', '1980-01-01', 1500, 22, 'yaroslav@example.com'),
  ('Павло', 'HR', '1993-01-01', 1000, 24, 'pavlo@example.com'),
  ('Анна', 'Marketing', '1995-05-10', 950, 5, 'anna@example.com'),
  ('Іван', 'Sales', '1988-07-22', 1200, 10, 'ivan@example.com'),
  ('Олена', 'Engineering', '1992-11-15', 1100, 8, 'olena@example.com'),
  ('Сергій', 'Customer Support', '1996-04-25', 1000, 12, 'serhiy@example.com'),
  ('Дмитро', 'IT', '1989-09-10', 1400, 15, 'dmytro@example.com')
  RETURNING *;

/*
  UPDATE
  Встановити Павлу зарплатню 2000$.
  Співробітнику з id=3 змінити дату народження на 87й рік.
  Всім у кого зарплатня меньше 400$ зробити її 700$.
  Співробітникам з id більше 2 і менше 5 включно встановити кількість днів відпустки 5.
  Перейменуйте Ярослава на Евгена і підніміть йому зарплатню на 200$.
*/

UPDATE employees 
SET salary = 2000
WHERE full_name = 'Павло'
RETURNING *;

UPDATE employees
SET birthday = '1987-01-01'
WHERE id = 3
RETURNING *;

UPDATE employees
SET salary = 700
WHERE salary < 400
RETURNING *;

UPDATE employees
SET vacation_days = 5
WHERE id BETWEEN 2 AND 5
RETURNING *;

UPDATE employees
SET full_name = 'Євген', salary = salary + 200
WHERE full_name = 'Ярослав'
RETURNING *;

/*
  SELECT
  Виведіть співробітника з id = 3.
  Виведіть співробітників с зарплатнею меньше ніж 800$.
  Виведіть співробітників з кількістю днів відпустки більше нуля. Відсортуйте по зростанню дні відпустки.
  Виведіть зарплатню та кількість днів відпустки Евгена.
  Вивести всіх співробітників з ім'ям Петро.
  Вивести перших 3 співробітників з ім'ям НЕ Петро. Відсортувати по спаданню по id.

  *Вивести всіх співробітників віком 27 років або с зарплатнею 1000$.
  *Вивести всіх співробітників віком від 25 (не включно) до 28 років (включно).
  *Вивести всіх співробітників віком від 23 до 27 років включно або з зарплатнею від 400$ до 1000$ включно.
*/

SELECT * FROM employees
WHERE id = 3;

SELECT * FROM employees
WHERE salary < 800;

SELECT * FROM employees
WHERE vacation_days > 0
ORDER BY vacation_days ASC;

SELECT salary, vacation_days 
FROM employees
WHERE full_name = 'Євген';

SELECT * FROM employees
WHERE full_name = 'Петро';

SELECT * FROM employees
WHERE full_name != 'Петро'
ORDER BY id DESC
LIMIT 3;

SELECT * FROM employees
WHERE extract(YEAR FROM age(current_date, birthday)) = 27 OR salary = 1000;

SELECT * FROM employees
WHERE extract(YEAR FROM age(current_date, birthday)) > 25
AND extract(YEAR FROM age(current_date, birthday)) <= 28;

SELECT * FROM employees
WHERE (extract(YEAR FROM age(current_date, birthday)) BETWEEN 23 AND 27)
OR (salary BETWEEN 400 AND 1000);

/*
  DELETE
  Видаліть співробітника з id=7.
  Видаліть всіх Микол.
  Видаліть всіх співробітників, у кого кількість днів відпусток більше 20
*/

DELETE FROM employees
WHERE id = 7
RETURNING *;

DELETE FROM employees
WHERE full_name = 'Микола'
RETURNING *;

DELETE FROM employees
WHERE vacation_days > 20;