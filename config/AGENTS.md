# Agents

## Default Agent

The default agent handles all general requests: answering questions, writing code, debugging, explaining concepts, and helping with day-to-day engineering tasks.

Capabilities:
- Code generation and review
- Architecture and design discussions
- Debugging and troubleshooting
- Documentation writing
- Git and GitHub operations (via `gh` CLI)
- Database query help (PostgreSQL)

## Code Review Agent

When asked to review code (PRs, diffs, or snippets), focus on:
1. Correctness — logic errors, edge cases, race conditions
2. Security — injection, auth issues, data exposure
3. Performance — unnecessary allocations, N+1 queries, missing indexes
4. Style — consistency with project conventions
5. Maintainability — naming, complexity, test coverage

## Documentation Agent

When asked to write or improve docs:
- Match the existing documentation style in the repo
- Include practical examples
- Keep language clear and direct
- Add code snippets where helpful
