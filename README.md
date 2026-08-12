# SQL Reviewer Skill

A reusable AI skill that reviews SQL statements and scripts as a technical
database reviewer. It reports structured findings with a severity level,
explanation, and recommendation for every detected problem.

## What the skill does

- Detects security, performance, data quality, and convention problems.
- Classifies every finding as CRITICAL, HIGH, MEDIUM, LOW, or INFO.
- Follows deterministic, explainable rules defined in the `rules/` directory.
- Does NOT execute SQL, modify databases, or invent missing context.

## Supported engines

Generic SQL plus the common dialects of:

- PostgreSQL
- MySQL / MariaDB
- SQL Server

Engine-specific syntax is handled explicitly (for example, `LIMIT` in
PostgreSQL/MySQL vs. `TOP` in SQL Server). New engines can be added by
extending the dialect notes in `rules/` without changing the core logic.

## Repository structure

```
sql-reviewer-skill/
|-- SKILL.md                  # Skill definition: purpose, procedure, output, validation
|-- README.md
|-- rules/
|   |-- security.md           # SEC-xxx: dangerous and destructive operations
|   |-- performance.md        # PERF-xxx: efficiency and index problems
|   `-- conventions.md        # CONV-xxx: naming, NULL, data types
|-- examples/
|   |-- valid.sql             # Clean SQL (happy path)
|   |-- invalid.sql           # Multiple clear violations
|   `-- edge-cases.sql        # Superficially safe but dangerous inputs
`-- tests/
    |-- test-01.md            # Happy path
    |-- test-02.md            # Evident errors
    |-- test-03.md            # Edge case
    |-- test-04.md            # Insufficient information
    `-- test-05.md            # Adversarial / red team
```

## How to use

Give the skill one or more SQL statements, optionally with context (engine,
table definitions, indexes). The skill responds with a structured review:
overall result, findings with Rule ID, severity, problem, explanation,
recommendation, and any information gaps.

Example input:

```sql
DELETE FROM users
WHERE 1 = 1;
```

Expected result: CRITICAL — the WHERE clause is always true, so the statement
affects every row and must not be executed.

## Design decisions

- **Rules over prompts.** The skill is a reproducible procedure with explicit
  IF/THEN rules, not a generic instruction.
- **No invented context.** When the schema, indexes, or data volume are
  unknown, the skill says so and downgrades the conclusion to INFO instead of
  assuming facts.
- **Severity conflict resolution.** Every finding keeps its own severity. The
  overall risk of a statement is set by its highest-severity finding.
- **Keywords are not guarantees.** The presence of WHERE or LIMIT does not
  make a statement safe; the skill evaluates the real meaning and impact of
  the conditions.

## Testing

The `tests/` directory contains the five mandatory test cases defined in the
assignment. Each test documents its input, expected behavior, actual behavior,
pass/fail result, any problem detected, and the modification made to the skill.

## Development flow

requirement -> specification -> rules -> implementation -> tests -> red team
-> iteration -> defense
