# Test 02

## Input

Evident error case. Multiple clear violations.
Corresponds to `examples/invalid.sql`.

```sql
SELECT * FROM users;

UPDATE users
SET role = 'ADMIN';

DELETE FROM users;

DROP TABLE logs;
```

## Expected behavior

The skill must detect all four problems and classify them by severity:

- `SELECT * FROM users;` → MEDIUM (PERF-001).
- `UPDATE users SET role = 'ADMIN';` → CRITICAL (SEC-002, no WHERE).
- `DELETE FROM users;` → CRITICAL (SEC-001, no WHERE).
- `DROP TABLE logs;` → HIGH (SEC-004, destructive operation).

Each finding must include Rule ID, Severity, Problem, Explanation, and
Recommendation. The overall risk is determined by the highest severity
(CRITICAL).

## Actual behavior

Applying the rules:

1. Rule PERF-001 — MEDIUM — `SELECT *` returns all columns; recommend listing
   explicit columns.
2. Rule SEC-002 — CRITICAL — UPDATE without a WHERE condition affects every
   row; do not recommend executing the statement.
3. Rule SEC-001 — CRITICAL — DELETE without a WHERE condition removes every
   row; do not recommend executing the statement.
4. Rule SEC-004 — HIGH — DROP TABLE is destructive and permanent.

Overall result: 4 findings, highest severity CRITICAL.

## Pass / Fail

PASS

## Problem detected

None. All expected violations were found with the correct severity.

## Modification made to the skill

None.
