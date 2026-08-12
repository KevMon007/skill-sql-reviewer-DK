# Test 01

## Input

Happy path. Correct SQL with a safe filter and an explicit row limit.
Corresponds to `examples/valid.sql`.

```sql
SELECT id, name, email
FROM users
WHERE id = 10
LIMIT 1;
```

## Expected behavior

- No CRITICAL, HIGH, MEDIUM, or LOW findings.
- The skill must NOT invent problems (no artificial index or data-type
  findings, because the schema is not available).
- Result: "No violations were found based on the available information."
- At most an INFO observation (for example, that index status cannot be
  verified without the schema).

## Actual behavior

Applying the rules in `SKILL.md`, `rules/performance.md` and
`rules/conventions.md`:

- PERF-001: not triggered (explicit columns).
- PERF-002: not triggered (WHERE id = 10 is selective, LIMIT 1 present).
- PERF-003: not triggered (limit is 1).
- PERF-004: not triggered; index on `id` cannot be verified → INFO only.
- PERF-005/006, CONV-001/002/003/004/005/006: not triggered.
- SEC rules: not applicable (SELECT, no destructive operation).

Result: no violations. One INFO note: "Index status on `users.id` cannot be
determined without the schema."

## Pass / Fail

PASS

## Problem detected

None. The skill produced no artificial findings on valid input.

## Modification made to the skill

None.
