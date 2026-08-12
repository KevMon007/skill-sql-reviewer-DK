-- WHERE existe, pero siempre es verdadero
DELETE FROM users
WHERE 1 = 1;

-- WHERE existe, pero afecta prácticamente a todo el conjunto
UPDATE users
SET role = 'ADMIN'
WHERE email LIKE '%';

-- LIMIT existe, pero es tan grande que prácticamente no protege
SELECT *
FROM users
LIMIT 1000000000;

-- Parece un JOIN, pero no existe condición de relación
SELECT u.id, o.id
FROM users u
JOIN orders o;

-- Parece correcto, pero NULL está siendo comparado incorrectamente
SELECT id, name
FROM users
WHERE email = NULL;