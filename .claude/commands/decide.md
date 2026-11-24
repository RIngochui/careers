---
description: Record a ruling from Ringo in docs/DECISIONS.md and apply it
argument-hint: <the ruling, in plain words>
---

Ringo's ruling: $ARGUMENTS

1. Add it to `docs/DECISIONS.md` under "Settled" (or replace the matching default or open question), in one or two plain sentences. If it settles something listed under Unknowns or Conflicts in `docs/RULES.md`, say which item.
2. If it changes rules, numbers or content already in `res://data/` or code, use the **coder** subagent to update them and their tests, and run `make test`.
3. Commit with a message starting `decision:` and tell Ringo what changed.
