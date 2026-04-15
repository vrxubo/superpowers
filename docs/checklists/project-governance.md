# Project Governance Checklist

> Every contribution MUST pass all items below.

## Before Opening PR
- [ ] Searched open AND closed PRs for related work
- [ ] Problem is real (someone actually experienced it), not theoretical
- [ ] Change belongs in core (not domain-specific or third-party promotion)
- [ ] Only ONE problem addressed (no bundled unrelated changes)

## PR Submission
- [ ] PR template fully completed (no blank sections or placeholders)
- [ ] Prior PRs referenced in "Existing PRs" section
- [ ] Problem description is specific (not "could theoretically cause issues")
- [ ] Human has reviewed the complete diff
- [ ] No third-party dependencies added
- [ ] If skill modified: `superpowers:writing-skills` workflow followed

## Quality
- [ ] Tested on at least one harness
- [ ] Test results reported in environment table
- [ ] PR title describes problem solved, not just what changed
- [ ] No fabricated claims or fabricated problem descriptions

## Post-Merge
- [ ] Branch cleaned up after merge
- [ ] Worktree removed if applicable
- [ ] No lingering test artifacts
