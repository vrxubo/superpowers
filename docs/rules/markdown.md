# Markdown Standards

Applies to all `.md` files: documentation, skill files, agent definitions, plans, reports, and templates.

## General

- Use ATX-style headings: `#`, `##`, `###` (not setext `===`/`---`).
- One blank line between heading and following content.
- No trailing whitespace on any line.

## Headings

- Sentence case for headings: `## Pull Request Requirements`, not `## Pull request requirements` or `## PULL REQUEST REQUIREMENTS`.
- Do not skip heading levels.

## Lists

- Use `-` for unordered lists (not `*` or `+`).
- Use `1.`, `2.`, etc. for ordered lists (markdown auto-numbers, but be explicit).
- Nested lists: 2-space indent.

## Code

- Inline code: backticks.
- Fenced code blocks: specify the language. Use ``` for shell, `js` for JavaScript, `python` for Python, `yaml` for YAML.
- Indent code blocks with 0 spaces relative to the fence.

## Links and References

- Use relative paths for internal links: `[link](../file.md)`.
- Use absolute URLs for external links.
- Reference files with `path/to/file.md` inline when discussing code locations.

## Skill Files

- Skill frontmatter uses `---` YAML blocks with `name:`, `description:`.
- Skill content sections use `##` headings.
- Red flags / tables: use markdown tables with aligned columns.

## PRs and Issues

- PR descriptions and issue templates follow the repo template format.
- Plans in `docs/plans/` use date-prefixed filenames: `YYYY-MM-DD-short-description.md`.
