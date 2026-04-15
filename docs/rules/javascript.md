# JavaScript & TypeScript Standards

Applies to all `.js` and `.ts` files: server scripts, test files, helper modules, and skill utilities.

## General

- Use CommonJS (`require`/`module.exports`) for files in `skills/` and `tests/` directories to avoid bundler complexity.
- Use `const` by default, `let` only when reassignment is needed. Never use `var`.
- Use template literals for string interpolation.

## TypeScript

- Files in `skills/systematic-debugging/` and similar example files should use modern TS syntax (ES modules or CommonJS consistent with the file).
- Avoid `any`; use `unknown` when the type is truly opaque.
- Do not add a `tsconfig.json` or build step for single-file utilities.

## Naming

- `camelCase` for variables and functions.
- `PascalCase` for constructor functions or classes.
- Test files: `<feature>.test.js` or `<feature>.test.ts`.

## Async

- Prefer `async/await` over raw `.then()` chains.
- Always handle rejection: wrap `await` in `try/catch` or use `.catch()`.

## Node APIs

- Use built-in `node:` prefix for standard library imports: `require('node:fs')`.
- Use `child_process` with explicit error handling; do not silently swallow spawn failures.

## Testing (JS)

- Use `console.assert` or explicit `throw new Error()` for lightweight test assertions.
- Print a summary: total, passed, failed.
- Exit with non-zero status on any failure.
