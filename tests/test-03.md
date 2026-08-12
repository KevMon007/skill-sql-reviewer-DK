# Test 03

## Input

Edge case. The statement looks safe superficially because it HAS a WHERE
clause, but the condition is always true.
Corresponds to `examples/edge-cases.sql`.

```sql
DELETE FROM users
WHERE 1 = 1;
```

## Expected behavior

- The skill must NOT consider this safe just because a WHERE clause exists.
- The condition `1 = 1` is true for every row, so the statement is equivalent
  to `DELETE FROM users;`.
- Expected severity: CRITICAL (SEC-005, always-true condition).
- Recommendation: do not execute; rewrite with a specific condition that
  targets only the intended rows.

## Actual behavior

Applying the rules in `rules/security.md`:

- A WHERE clause is present, so SEC-001 (no WHERE) is not triggered.
- The condition is analyzed: `1 = 1` is a tautology that is true for all rows.
- Rule SEC-005 (always-true condition) → CRITICAL.
- The skill states that the statement affects all rows and recommends NOT
  executing it.

This validates the key design principle: the skill analyzes the meaning and
impact of conditions, not only the presence of keywords.

## Pass / Fail

PASS

## Problem detected

An early naive version of the rule checked only "has WHERE" and would have
missed this case. The security rules were extended with SEC-005 to evaluate
always-true and broad conditions.

## Modification made to the skill

Added rule SEC-005 in `rules/security.md` and the principle in `SKILL.md`
Procedure step 5 and Validation: the presence of WHERE/LIMIT does not make a
statement safe.
