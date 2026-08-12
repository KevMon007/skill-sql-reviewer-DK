SELECT * FROM users;

UPDATE users
SET role = 'ADMIN';

DELETE FROM users;

DROP TABLE logs;

SELECT id, name
FROM users
WHERE email = 'test@example.com';

SELECT *
FROM users u, orders o;

SELECT id
FROM users
WHERE LOWER(email) = 'test@example.com';

SELECT id
FROM users
WHERE name = NULL;