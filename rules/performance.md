# Performance Rules

Rules in this file identify potentially inefficient operations. Each rule is
deterministic and is referenced from `SKILL.md` by its Rule ID.

Dialect note: the LIMIT clause is used in PostgreSQL and MySQL. SQL Server uses
the TOP clause. Both forms are considered equivalent by these rules.

---

## PERF-001 — SELECT *

Condition:

    IF statement = SELECT
    AND select list = *
    AND the columns are not explicitly justified

    THEN severity = MEDIUM
    AND recommendation = list only the columns actually needed

Explanation: `SELECT *` returns every column, increases network and memory
usage, and breaks when the table schema changes. It can also expose sensitive
columns.

Exception: if the intent is clearly to count or probe structure and the query
is explicitly scoped, the severity may be lowered to INFO.

---

## PERF-002 — Potentially massive query without LIMIT/TOP

Condition:

    IF statement = SELECT
    AND the query filters no rows or filters with a non-selective condition
    AND the result set is potentially massive
    AND no LIMIT/TOP clause is present

    THEN severity = MEDIUM
    AND recommendation = add a LIMIT/TOP or a more selective WHERE

Explanation: a query without row bounds can materialize an unbounded result
set. If the table size is unknown, the skill must say that the assessment
depends on the data volume (INFO) instead of assuming a large table.

---

## PERF-003 — Excessively large LIMIT/TOP

Condition:

    IF statement = SELECT
    AND a LIMIT/TOP clause is present
    AND limit value >= 1,000,000 rows

    THEN severity = HIGH
    AND recommendation = reduce the limit or add a more selective WHERE

Explanation: a LIMIT that is effectively the whole table provides no
protection. This addresses adversarial inputs such as
`SELECT * FROM TA_USERS LIMIT 1000000000;`.

---

## PERF-004 — Potentially missing index

Condition:

    IF a column is used in WHERE or JOIN
    AND the available context includes schema or index definitions
    AND that column has no index
    AND the table is likely to grow large

    THEN severity = LOW
    AND recommendation = consider an index on the filtered column

If the schema or index definitions are NOT available, the skill cannot conclude
that an index is missing.

    IF the index status is unknown
    THEN severity = INFO
    AND state: index status cannot be determined without the schema

Explanation: filtering on an unindexed column causes full scans. The skill
must never invent index information.

---

## PERF-005 — Function applied to a column in WHERE

Condition:

    IF statement = SELECT/UPDATE/DELETE
    AND a column is wrapped in a function inside WHERE
    (for example: LOWER(col), UPPER(col), YEAR(date), TRIM(col))

    THEN severity = MEDIUM
    AND recommendation = compare against the bare column or use a
    computed/generated column

Explanation: wrapping a column in a function usually prevents the use of an
index on that column, forcing a full scan.

---

## PERF-006 — Missing JOIN condition (cartesian product)

Condition:

    IF statement = SELECT
    AND the FROM/JOIN clauses reference two or more tables
    AND no JOIN condition is present
    AND no linking condition exists in WHERE

    THEN severity = HIGH
    AND recommendation = add the missing join condition

Explanation: without a join condition the database produces a cartesian
product, which can be catastrophic in memory and time.
