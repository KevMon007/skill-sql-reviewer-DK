-- SELECT con columnas explícitas
SELECT id, name, email
FROM users
WHERE id = 10
LIMIT 1;

-- INSERT con columnas explícitas
INSERT INTO users (name, email, role)
VALUES ('Ana López', 'ana@example.com', 'USER');

-- UPDATE con condición específica
UPDATE users
SET role = 'ADMIN'
WHERE id = 25;

-- DELETE con condición específica
DELETE FROM users
WHERE id = 100;

-- JOIN con condición definida
SELECT u.id, u.name, o.id AS order_id
FROM users u
JOIN orders o ON o.user_id = u.id
WHERE u.id = 25
LIMIT 10;