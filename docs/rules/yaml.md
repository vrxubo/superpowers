# YAML Standards

Applies to `.yml` and `.yaml` files: GitHub Actions workflows, issue templates, and funding config.

## General

- Use 2-space indentation. No tabs.
- Quote strings that could be misinterpreted: `"on"`, `"off"`, `"yes"`, `"no"`, version numbers.
- Use `---` at the top of GitHub Actions workflow files.

## GitHub Actions

- Use `name:` at the top of every workflow.
- Pin action versions to specific SHA or major version tags (e.g., `actions/checkout@v4`), avoid `@main` or `@master`.
- Use `run:` with `|` (literal block scalar) for multi-line commands, not `>` (folded).
- Group related steps under meaningful `name:` labels.

## Naming

- Workflow files: kebab-case, e.g., `sync-upstream.yml`.
- Job names: kebab-case. Step names: sentence case.

## Validation

- Run `actionlint` on workflow files before committing (available locally or via GitHub's built-in linter).
- No hardcoded secrets; always use `${{ secrets.* }}`.
