---
description: Ask the researcher a question about the original Careers rules or content
argument-hint: <question, or "full" to build docs/RULES.md from scratch>
---

If the argument is `full`: use the **researcher** subagent to build `docs/RULES.md` from scratch for the UK edition of Careers. It must cover the full turn sequence, the success formula and winning, salary and Payday, every outer-track space, every occupation (entry requirements, every path space in order, completion rewards), degrees and college, Opportunity and Experience cards (full lists if photos exist in `docs/reference/`, otherwise sourced lists), bumping, Hospital, Park Bench/Unemployment, bankruptcy and any optional rules. Start with the photos in `docs/reference/`.

Otherwise use the **researcher** subagent to answer this question: $ARGUMENTS

When it finishes, show Ringo the summary and every open question with its proposed default. Commit the research with a message starting `research:`.
