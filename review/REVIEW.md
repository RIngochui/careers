# Review: Phase 0 (fb0db03..HEAD)
Verdict: PASS WITH NOTES

## Done-when checklist
- [x] `make run` opens an empty window titled from `data/config.json`: `godot --path . --quit-after 30` exits 0 with a Forward+/Metal window; `src/presentation/main.gd:8` sets `get_window().title` from config. In a scratch copy, changing the config title to "Zebra Title" was picked up by `test_main_sets_title`.
- [x] `make test` exits non-zero on a failing, crashing or syntax-broken test: `make test` gives 0 on the clean tree. `tests/selftest.sh` runs the fail, crash and syntax fixtures and expects each to fail. In a scratch copy, adding a failing `tests/test_bad.gd` made `make test` exit 2.
- [x] `make import` rebuilds a deleted `.godot` cache: I moved `.godot` away and ran `make import`. It exited 0, recreated `.godot/` (imported, uid_cache.bin, global_script_class_cache.cfg), and `make test` then passed.
- [x] `make shots` saves at least one PNG: `review/shots/00_boot.png` (1280x720) shows the flat blue-grey background from config. It is empty, as it should be for this phase.

## Blockers (must fix)
None.

## Should fix
- tests/test_config.gd:14-17: `test_main_sets_title` cannot fail as things stand. The window's default title is `config/name="Careers"` (project.godot:5), which equals `window_title` in config. In a scratch copy I deleted the title line from main.gd and the test still passed. Fix: set the title to a sentinel before instantiating (`tree.root.title = "__unset__"`), or check against a value that differs from the project name.

## Nits
- tests/run.sh: nothing stops a hanging test, so `make test` would block forever. The plan already accepts this risk; add the `perl -e 'alarm N'` wrapper when it first bites.
- src/presentation/main.gd:16-20: the shots code (path `00_boot.png`, `--shots`) lives in the main scene. That's fine for now, but it should move to a dedicated demo script when Phase 3 adds a scripted multi-shot run.
- `make movie` works (writes `review/demo.avi`, which is gitignored), though PHASES.md didn't require it yet.

## Rules questions (for the researcher or Ringo)
None. Phase 0 has no game rules, and `res://data/` only holds `config.json`, so the rules-fidelity spot-check (8 rules) doesn't apply yet.

## What looked good
- The test runner is solid: it fails on a non-zero exit, on `SCRIPT ERROR`/`Parse Error`/`ERROR:` lines, or when the `ALL PASSED` line is missing. The self-test fixtures keep this true over time.
- The title and background colour come from data (`data/config.json`). No hard-coded text in scripts beyond the config path.
- `main.tscn` is 6 lines and the scene is built in code. Nothing needs the editor; `make test`/`shots`/`movie` run an import first if `.godot` is missing.
- Stub targets (`sim`, `art`, `export`, `templates`) say which phase they arrive in and exit 2. There is no scope creep into later phases.
- `docs/.gdignore` keeps the reference photos out of the import.
