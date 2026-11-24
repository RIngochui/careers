---
description: Run a full phase - research gaps, plan, build, independent review, fix - then stop for Ringo
argument-hint: <phase number>
---

Run Phase $ARGUMENTS. You are the orchestrator: delegate the work to subagents and keep your own context small.

1. **Check.** Read `docs/PHASES.md`. Confirm Phase $ARGUMENTS exists and every earlier phase is `done` or `needs Ringo`. If not, stop and tell Ringo why. Note the current commit as the phase's starting point. Set the phase status to `in progress` and commit.

2. **Plan.** Use the **planner** subagent to write `docs/plans/phase-$ARGUMENTS.md`.

3. **Research gaps.** If the plan lists "Rules questions for the researcher", use the **researcher** subagent to answer them in `docs/RULES.md` before building. If the researcher can't settle a question that blocks the phase, stop and ask Ringo, giving its proposed default. If the planner reports **blocking** questions for Ringo, stop and ask them the same way. Non-blocking questions don't stop the run.

4. **Build.** Use the **coder** subagent to implement the plan. Tell it the plan's path.

5. **Review.** Use the **reviewer** subagent. Give it only the phase number and the commit range from the starting point to `HEAD`. Don't pass it the plan, the coder's summary or your opinion.

6. **Fix loop.** If the verdict is FAIL, use the **coder** subagent to fix everything in `review/REVIEW.md`, then run a **new** reviewer subagent on the full phase range again. If a review raises a rules question, send it to the **researcher** first. Stop after 3 review rounds; if it still fails, report the remaining blockers to Ringo.

7. **Wrap up.** Set the phase status to `needs Ringo` in `docs/PHASES.md` (or `done` if the phase has no Ringo check) and commit. Then give Ringo a short report:
   - What was built, in 3–5 bullets
   - The final review verdict and any open notes
   - Questions for Ringo, each with its proposed default
   - Exactly what to do for the phase's "Ringo check", including the commands to run

Never change game rules or numbers, and never edit `PROMPT.md`, `docs/RULES.md` (only the researcher does) or `docs/DECISIONS.md` (only through /decide).
