# Skill Development Checklist

> Every skill creation or modification MUST pass all items below.

## Frontmatter
- [ ] `name` uses only letters, numbers, hyphens (no parentheses/special chars)
- [ ] `description` starts with "Use when..." and includes specific triggers
- [ ] `description` does NOT summarize the skill's process or workflow
- [ ] Frontmatter is under 1024 characters total

## Structure
- [ ] Overview with core principle in 1-2 sentences
- [ ] When to Use with symptoms/use cases AND "do not use for"
- [ ] Core Pattern or Quick Reference section
- [ ] Common Mistakes section
- [ ] Red Flags table with Excuse/Reality columns
- [ ] Directory is `skills/<kebab-case-name>/SKILL.md` (flat, no nesting)

## Quality
- [ ] Token count under 200 (frequently-loaded) or 500 (other skills)
- [ ] At most ONE code example, complete and runnable
- [ ] Cross-references use skill name only (no `@path` syntax)
- [ ] No narrative storytelling ("In session X we found...")
- [ ] No multi-language examples
- [ ] Flowcharts (if any) only for non-obvious decisions

## Testing
- [ ] Baseline behavior documented (what agent does WITHOUT this skill)
- [ ] Agent complies WITH this skill
- [ ] New rationalizations identified and countered
- [ ] `superpowers:writing-skills` workflow followed end-to-end
