# Test 04

## Input

Information-insufficient case. The SQL is syntactically reviewable, but the
request requires information about indexes that is not provided.

```sql
SELECT id, name, email
FROM users
WHERE email = 'test@example.com';
```

No schema, index definition, table size, or query plan is provided.

## Expected behavior

- The skill must analyze the SQL that can be evaluated directly.
- It must NOT claim that an index is missing.
- PERF-004 may produce an INFO finding because index status cannot be
  determined without schema or index definitions.
- The skill must explicitly identify the missing information.
- The skill must not invent table size, indexes, data distribution, or
  application behavior.

Expected result: no unsupported HIGH, MEDIUM, or LOW finding caused by an
assumption about the index.

## Actual behavior

Applying the rules:

- The SELECT uses explicit columns, so PERF-001 is not triggered.
- The WHERE condition is specific, so no destructive security rule applies.
- PERF-004 cannot determine whether `users.email` has an index because no
  schema or index definitions are provided.
- The skill reports an INFO note stating that index status cannot be
  determined without the schema or index definitions.

Result: PASS. The skill recognizes the information gap instead of inventing
an index problem.

## Pass / Fail

PASS

## Problem detected

None. The important behavior is that the skill refuses to make an unsupported
claim.

## Modification made to the skill

None.
