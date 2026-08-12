# Security Rules

Rules in this file identify dangerous, destructive, or potentially unsafe SQL operations.
Each rule is deterministic and is referenced from `SKILL.md` by its Rule ID.

---

## SEC-001 — DELETE without WHERE

Condition:

    IF statement = DELETE
    AND no WHERE clause is present

    THEN severity = CRITICAL
    AND recommendation = do not execute; add a specific WHERE condition
    that targets only the intended rows

Explanation: a DELETE without WHERE removes every row from the target table.

---

## SEC-002 — UPDATE without WHERE

Condition:

    IF statement = UPDATE
    AND no WHERE clause is present

    THEN severity = CRITICAL
    AND recommendation = do not execute; add a specific WHERE condition
    that targets only the intended rows

Explanation: an UPDATE without WHERE modifies every row in the target table.

---

## SEC-003 — Evident SQL Injection through unsafe concatenation or interpolation

Condition:

    IF SQL is constructed by directly concatenating or interpolating
    untrusted/external input into a SQL statement
    AND the input is not parameterized or safely bound

    THEN severity = HIGH
    AND recommendation = use parameterized queries, prepared statements,
    or the database driver's parameter-binding mechanism

Explanation: direct insertion of external input into SQL can allow an attacker
to alter the intended query structure or execute unintended operations.

If the input source cannot be determined from the provided material, the skill
must not invent that context. It should report only what is directly evident.

---

## SEC-004 — Destructive DDL operation

Condition:

    IF statement performs a destructive operation such as:
    DROP TABLE, DROP DATABASE, DROP SCHEMA, or TRUNCATE

    THEN severity = HIGH
    AND recommendation = do not execute unless the destructive operation is
    explicitly intended, reviewed, and protected by an appropriate procedure

Explanation: these operations can permanently remove database objects or data.

Engine-specific behavior must be considered when relevant.

---

## SEC-005 — Always-true or excessively broad WHERE condition

Condition:

    IF statement = DELETE or UPDATE
    AND a WHERE condition is present
    AND the condition is provably always true
    OR the condition is explicitly broad enough to target the complete
    or nearly complete dataset
    THEN severity = CRITICAL
    AND recommendation = do not execute; replace the condition with a
    specific predicate that identifies only the intended rows

Examples:

    DELETE FROM users WHERE 1 = 1;

    UPDATE users
    SET role = 'ADMIN'
    WHERE email LIKE '%';

Explanation: the presence of WHERE does not guarantee safety. Conditions such
as `1 = 1` are tautologies and match every row. A wildcard predicate such as
`LIKE '%'` can also match every non-NULL value and therefore may update or
delete almost the entire dataset.

The skill must evaluate the meaning and impact of the condition rather than
checking only whether WHERE exists.
