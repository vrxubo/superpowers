# Python Script Standards

Applies to all `.py` files: analysis scripts and test utilities in `tests/`.

## General

- Target Python 3.8+. Use `#!/usr/bin/env python3` shebang.
- No external dependencies. Use only the standard library.
- Scripts must be directly executable with `python3 script.py [args]`.

## Style

- Follow PEP 8 naming: `snake_case` for functions/variables, `PascalCase` for classes, `UPPER_SNAKE_CASE` for constants.
- Use f-strings for formatting: `f"result: {value}"`.
- Type hints are optional for short scripts; use them when they clarify complex data shapes.

## Structure

- Put the main logic in a `main()` function.
- Guard execution with `if __name__ == "__main__": main()`.
- Keep scripts under ~200 lines. If longer, split into helper modules.

## Error Handling

- Use `sys.exit(code)` for exit with status.
- Catch expected exceptions explicitly; do not use bare `except:`.
- Print error messages to stderr: `print("error", file=sys.stderr)`.

## Analysis Scripts

- Output structured data (CSV, JSON, or tab-separated) to stdout for piping.
- Log status/messages to stderr so output can be cleanly consumed.
