# SQL Reviewer

## Purpose

The SQL Reviewer skill analyzes SQL statements and scripts to identify security,
performance, data integrity, and convention problems.

The skill provides structured findings with a severity level, explanation, and
recommendation for every detected problem.

The skill supports generic SQL and the common dialects of PostgreSQL, MySQL,
and SQL Server. Engine-specific differences are flagged explicitly instead of
being silently assumed.

The skill does not execute SQL, modify databases, or invent missing context.

## When to activate

Activate the skill when the user provides:

- A SQL statement.
- Multiple SQL statements.
- A SQL script.
- A SQL fragment that can be reasonably analyzed.
- A request to review, validate, audit, or identify problems in SQL code.

The input must contain SQL that can be analyzed with the available information.

## When NOT to activate

Do not activate the skill when:

- The input does not contain SQL.
- The user asks a general database question without providing SQL to review.
- The user asks to generate new SQL code from scratch without reviewing existing
  SQL.
- The requested analysis requires information that is not provided and cannot
  reasonably be inferred from the SQL itself.

When the input is insufficient, the skill must not invent database schema,
indexes, constraints, data distributions, or application behavior.

## Inputs

The skill accepts:

1. A single SQL statement.
2. Multiple SQL statements.
3. A SQL script.
4. SQL accompanied by optional context, such as:
   - Database engine or dialect.
   - Table definitions.
   - Index definitions.
   - Expected behavior.
   - Performance requirements.

Optional context may improve the analysis, but the skill must never assume that
missing information exists.

## Procedure

The skill follows this procedure:

1. Validate that the input contains SQL.
2. Identify each SQL statement in the input.
3. Determine the type of each statement (SELECT, INSERT, UPDATE, DELETE, DDL, etc.).
4. Analyze each statement against the security, performance, and convention rules.
5. Determine whether conditions and clauses are actually safe, considering the
   meaning and impact of the statement instead of checking only for the presence
   of keywords such as WHERE or LIMIT.
6. Identify potentially destructive or unsafe operations.
7. Assign exactly one severity to every detected finding.
8. Provide an explanation and a concrete recommendation for every finding.
9. Identify situations where the available information is insufficient and state
   them explicitly.
10. Produce the final structured review.

## Rules

The skill uses three rule categories, defined as deterministic rules in the
files under the `rules/` directory:

### Security

Rules that identify potentially dangerous operations, defined in
`rules/security.md`. Examples:

- UPDATE or DELETE without a safe WHERE condition.
- DELETE or UPDATE with a WHERE condition that is always true.
- Potentially destructive SQL operations (DROP, TRUNCATE).
- Evident SQL injection through unsafe concatenation or interpolation.
- Conditions that affect an unexpectedly broad set of records.

### Performance

Rules that identify potentially inefficient operations, defined in
`rules/performance.md`. Examples:

- SELECT *.
- Queries that may return excessively large result sets.
- Missing LIMIT/TOP when a query is potentially massive.
- Excessively large LIMIT/TOP values.
- Potentially missing indexes when the available information supports that
  conclusion.
- Other evident performance problems.

### Conventions and data quality

Rules that identify maintainability and correctness problems, defined in
`rules/conventions.md`. Examples:

- Poorly descriptive or inconsistent names.
- Incorrect NULL comparisons.
- Evident problems with data type selection.
- Other explicitly defined convention violations.

## Severity levels

Each finding must use exactly one of the following severity levels:

- CRITICAL: Immediate or potentially severe impact. Destructive operations or
  highly dangerous security issues that can affect the whole data set.
- HIGH: Significant security, integrity, or operational risk.
- MEDIUM: Relevant performance, correctness, or maintainability problem.
- LOW: Minor quality or convention problem.
- INFO: Recommendation or observation that requires additional context before a
  stronger conclusion can be made.

Conflict resolution: when multiple findings affect the same statement, every
finding is reported with its own severity. The overall risk level of that
statement is determined by the finding with the highest severity
(CRITICAL > HIGH > MEDIUM > LOW > INFO).

Important: the presence of a WHERE or LIMIT clause does not automatically make
a statement safe. The skill evaluates the real meaning and impact of the
conditions.

## Expected output

The review must contain:

1. Overall result.
2. Findings list.
3. Severity for every finding.
4. Explanation of every finding.
5. Recommendation for every finding when possible.
6. Information gaps or assumptions that limit the analysis.

Each finding must follow this structure:

- Rule ID
- Severity
- Location (statement and, when possible, clause)
- Problem
- Explanation
- Recommendation

If no violations are detected, the skill must explicitly state that no
violations were found based on the available information. It must not invent
problems.

## Validation

Before producing the final result, verify that:

- The input is actually SQL.
- Every finding is supported by the provided SQL or context.
- No database information has been invented.
- Every finding has a valid severity.
- Security, performance, and convention rules were all considered.
- Potentially destructive operations were considered.
- The recommendation does not claim that SQL was executed or tested when it
  was not.
- The analysis considers the meaning and impact of conditions rather than
  checking only for the existence of keywords.

## Failure handling

If the SQL is incomplete, ambiguous, malformed, or lacks information required
for a reliable conclusion:

1. Identify what can be determined from the provided input.
2. Clearly state what cannot be determined.
3. Do not invent missing schema, indexes, constraints, application behavior, or
   database configuration.
4. Report only findings supported by the available information.
5. Request additional context when it is necessary for a stronger conclusion.

The skill must always prefer an explicit "insufficient information" result over
an unsupported assumption.
