# JSON Configuration Standards

Applies to all `.json` files: package configs, settings, plugin manifests, and test fixtures.

## General

- Valid JSON only — no comments, no trailing commas.
- 2-space indentation.
- Trailing newline at end of file.

## Naming Conventions

- Keys: `camelCase` for application config, `snake_case` for tool-specific configs that require it.
- Boolean keys should start with a verb or be clearly boolean: `isEnabled`, `verbose`.

## Package Files (`package.json`)

- Pin dependency versions with `^` for compatible ranges, or exact versions for lockfile-sensitive projects.
- Do not add `package.json` files in `skills/` unless the skill requires `npm install` as a setup step.
- Keep `scripts` section minimal: only entries that are invoked by humans or CI.

## Settings Files

- `.claude/settings.local.json` is user-specific and should not be committed.
- Plugin manifests (`.cursor-plugin/plugin.json`, `gemini-extension.json`) must include required fields per their platform spec.

## Validation

- Run `jq . file.json` to validate syntax before committing.
