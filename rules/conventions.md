# Conventions and Data Quality Rules

Rules in this file identify maintainability, readability, and correctness
problems. Each rule is deterministic and is referenced from `SKILL.md` by its
Rule ID.

---

## CONV-001 — Poorly descriptive names

Condition:

    IF an identifier (table, column, or alias) is a generic or
    meaningless name such as: a, b, x, t, tmp, aux, data, val
    AND no explicit justification is provided

    THEN severity = LOW
    AND recommendation = use a descriptive name that reflects the content

Explanation: unclear names make the SQL hard to read and maintain, and hide
intent.

---

## CONV-002 — Inconsistent naming conventions

Condition:

    IF identifiers in the same statement/script mix conventions
    (snake_case, camelCase, PascalCase, or inconsistent prefixes/suffixes)

    THEN severity = LOW
    AND recommendation = use one convention consistently

Explanation: mixed conventions reduce readability and make automated tooling
harder to apply. If the project has an explicit convention, that convention is
preferred.

---

## CONV-003 — Incorrect NULL comparison

Condition:

    IF a comparison with NULL uses = or <> instead of IS NULL / IS NOT NULL
    (for example: column = NULL, column <> NULL)

    THEN severity = HIGH
    AND recommendation = use IS NULL or IS NOT NULL

Explanation: in SQL, NULL is not a value, so `= NULL` and `<> NULL` never
match any row. The condition silently evaluates to unknown and the query
returns incorrect results.

---

## CONV-004 — NOT IN with a NULL-producing subquery

Condition:

    IF statement uses NOT IN (subquery)
    AND the subquery may return NULL values
    AND the schema does not prove the column is NOT NULL

    THEN severity = MEDIUM
    AND recommendation = use NOT EXISTS or ensure the subquery excludes NULLs

Explanation: `NOT IN` over a set that contains NULL returns no rows at all,
which is a common data integrity bug.

---

## CONV-005 — Evident data type problems

Condition:

    IF a column is used in a way that contradicts its evident type, such as:
    - numeric values stored in a VARCHAR/CHAR column
    - dates stored as strings (VARCHAR) instead of DATE/TIMESTAMP
    - comparing or joining columns of clearly different types

    THEN severity = MEDIUM
    AND recommendation = use the correct data type for the column

Explanation: wrong types cause implicit conversions, index misuse, sorting
errors, and data integrity problems. If the schema is not provided, the skill
must flag this as INFO because the actual types cannot be verified.

---

## CONV-006 — Reserved words used as identifiers

Condition:

    IF an identifier is a SQL reserved word
    AND it is not quoted/escaped according to the dialect

    THEN severity = LOW
    AND recommendation = rename the identifier or escape it consistently

Explanation: unquoted reserved words can produce syntax errors or behavior
that differs across engines.
