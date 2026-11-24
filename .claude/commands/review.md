---
description: Run an independent review of recent work
argument-hint: [commit range, default HEAD~1..HEAD]
---

Use the **reviewer** subagent to review the commit range `$ARGUMENTS` (if empty, use `HEAD~1..HEAD`). Pass it only the range. Don't share any context about how the work was done. When it finishes, show Ringo the verdict and the blockers from `review/REVIEW.md`.
