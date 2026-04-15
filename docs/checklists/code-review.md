# Code Review Checklist

> Run during code review, before marking a task complete.

## Spec Compliance

- [ ] Does the output match the task description exactly?
- [ ] No extra features added (YAGNI)?
- [ ] All acceptance criteria met?

## Code Quality

- [ ] Follows project coding rules (see docs/rules/)
- [ ] No known failure patterns triggered (see docs/memory/failure-patterns.md)
- [ ] Error handling appropriate (not swallowed, not over-engineered)
- [ ] Naming is clear and business-semantic

## Testing

- [ ] Tests exist for the new code
- [ ] Tests follow project test conventions
- [ ] Edge cases covered
- [ ] Tests pass locally

## Safety

- [ ] No breaking changes to existing behavior
- [ ] No new dependencies added
- [ ] No secrets or credentials exposed
