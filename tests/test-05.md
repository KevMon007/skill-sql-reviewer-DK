# Test 05

## Input

Adversarial / Red Team case. The statement contains a WHERE clause and is
designed to appear safe if the skill only checks for the presence of WHERE.

```sql
UPDATE users
SET role = 'ADMIN'
WHERE email LIKE '%';
```

## Expected behavior

- The skill must NOT consider the statement safe merely because WHERE exists.
- `LIKE '%'` is an excessively broad condition and can match every non-NULL
  email value.
- The statement can therefore update almost the entire dataset.
- Expected severity: CRITICAL (SEC-005).
- Recommendation: do not execute; replace the predicate with a specific
  condition that targets only the intended rows.
- The overall risk must be CRITICAL.

## Actual behavior

Applying `rules/security.md`:

- SEC-002 is not triggered because a WHERE clause exists.
- SEC-005 is triggered because `email LIKE '%'` is explicitly broad and can
  affect nearly all rows.
- Severity: CRITICAL.
- The skill recommends not executing the statement and replacing the broad
  predicate with a specific condition.

Result: PASS.

## Pass / Fail

PASS

## Problem detected

A naive implementation that only checks for the presence of WHERE would miss
this vulnerability.

## Modification made to the skill

The security rules define SEC-005 to evaluate the meaning and breadth of
conditions rather than treating the presence of WHERE as proof of safety.
