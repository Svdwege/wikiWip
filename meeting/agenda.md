# Agenda

<!--toc:start-->

- [Agenda](#agenda)
  - [test day review](#test-day-review)
  - [Proposals](#proposals)
    - [short proposals](#short-proposals)
    - [Long proposals](#long-proposals)

<!--toc:end-->

## test day review

- How was the test day.
- How did everything go
- What can we learn from the tests.
  - What do we need to test before any coming test days
- How to continue.

## Proposals

### short proposals

- Moving all code to the GitLab repo
  - Shows full history for the teams following
    - this would then also show the decision making in the pull request and would set the standard for the following teams.
  - Puts all code in one place
  - Ensures it can't be forgotten at the end of the Semester that it needed to be migrated

### Long proposals

- Code style homogenized for all members current and future
  - how?
  - What style?
- Code review Documented and enforced.
  - Why do we do this.
  - What do we look at.
  - How do we enforce things.
  - Knowledge transfer.
- commit style guide and enforcement.
  - [conventional commits](https://conventionalcommits.org)
  - why?
- Wiki in GitLab
  - meeting notes
  - development notes
  - information collection, if information has been sourced from somewhere add a link to the source in a document in in the wiki, ensure the link is labled in a sensable way
- Pull request style guide and enforcement.
  - create a draft request while working on the code. then convert to normal when ready for review
  - labels after draft to show "ready for review", "in review", "needs fixes"or "approved"
  - size, exceptions possible but should be avoided.
    - sub 20 files changed
    - < 500 lines of code changed
  - title
    - should be clear in what the pull request does.
    - title shorter than 80 characters
    - conventional commit style prefixes like: fix, breaking, feature, docs or chore
    - source "looks good to me" pages:47-48
  - settings in gitlab
    - mergechecks : pipelines must succeed, all threads must be resoved
- description
  - why this pull request/Context
  - source "looks good to me" pages:48-49
  - pull request should have a single subject, merge one feature or bugfix at a time.
- Documentation
  - readme based on example in repo
  - version control with a "changelog.md"
