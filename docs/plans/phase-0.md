# Phase 0 plan: Project setup

## Goal
A Godot 4.7 (Forward+) project skeleton that agents drive entirely from the terminal: a Makefile with every PROMPT.md target (later-phase ones stubbed), a headless test runner that fails loudly, a window titled from `data/config.json`, a screenshot path that saves a PNG, and a README. No game logic.

## Approach
- **Thinnest possible skeleton.** One `project.godot`, one main scene built in code (`src/presentation/main.gd` attached to a one-node `main.tscn`), one data file. No autoloads, no addons, no test framework dependency (GUT etc. is more than we need).
- **Title comes from data at runtime.** `main.gd` reads `res://data/config.json` and sets `get_window().title`. `project.godot`'s `config/name` stays a plain project name; data owns the user-facing title (reskin = data swap).
- **Test runner is a `SceneTree` script** (`godot --headless --path . -s res://tests/run_tests.gd`). It finds `tests/test_*.gd`, calls every `test_*` method, counts failures, and calls `quit(1)` on any failure. A wrapper `tests/run.sh` also fails on a non-zero exit code, on any `SCRIPT ERROR`/`Parse Error` in the output, and if the runner's final `ALL PASSED` line is missing. Why the wrapper: a GDScript runtime error does not crash Godot. It logs, aborts that function, and execution carries on, so the exit code alone can't catch "crashing" tests.
- **Self-test of the runner lives in `make test`.** Fixtures with a deliberate failing, crashing and syntax-broken test sit in `tests/fixtures/` (each with a `.gdignore` so `make import` skips them). `tests/selftest.sh` points the runner at each fixture dir and expects non-zero. This keeps the Done-when check true for good.
- **Shots run in a real window.** `make shots` runs `godot --path . -- --shots`. `main.gd` sees the user arg, waits for `RenderingServer.frame_post_draw`, saves the viewport image to `review/shots/00_boot.png` (absolute path via `ProjectSettings.globalize_path`), and quits.
- **Stubs say so and exit 2** (`sim`, `art`, `export`, `templates`): they print `"<target>: arrives in Phase N"` so nothing looks like it silently worked. `movie` is cheap enough to make real now (`--write-movie review/demo.avi --fixed-fps 30 --quit-after 90`).

## Tasks
1. **Project skeleton.** `project.godot` (name "Careers", Forward+ via `rendering/renderer/rendering_method="forward_plus"`, `config/features` with `"4.7"`, `run/main_scene="res://src/presentation/main.tscn"`, 1280x720 window), `src/presentation/main.tscn` (single `Node3D` root with script), `src/presentation/main.gd` (reads config, sets title, adds a `Camera3D` and a `WorldEnvironment` with a plain background colour so the window isn't black), `data/config.json` (`{"window_title": "Careers"}`), empty `src/engine/.gitkeep`, `src/net/.gitkeep`, `controller_web/.gitkeep`, `assets/models/.gitkeep`, `art/blender/.gitkeep`. Check `.gitignore` already covers `.godot/`, `review/shots/`, `review/*.avi` (it does; add `build/` exports only if missing).
2. **Makefile.** Targets: `run`, `import`, `test`, `sim`, `shots`, `movie`, `art`, `export`, `templates`, `lsp`, `lsp-stop`, all `.PHONY`. `GODOT ?= godot`. `import`: `$(GODOT) --headless --path . --import`. `test` and `shots` depend on a `.godot` check (`[ -d .godot ] || $(MAKE) import`) so a fresh clone works. `lsp`: `$(GODOT) --headless --editor --path . --lsp-port 6005 &` with PID in `.godot/lsp.pid` (headless editor, no window); `lsp-stop` kills that PID.
3. **Test runner.** `tests/run_tests.gd` (extends `SceneTree`; optional `--dir=res://...` user arg, default `res://tests`; loads each `test_*.gd`, treats a null load or `not script.can_instantiate()` as a failure, instantiates, calls each `test_*` method; tests report through a tiny `tests/assert.gd` helper with `check(cond, msg)` that records failures; prints `PASS`/`FAIL` per test and `ALL PASSED` or `N FAILED`; `quit(0|1)`). `tests/run.sh` (bash, `set -o pipefail`, runs the runner with the dir arg, tees output, fails on exit code, error strings, or missing `ALL PASSED`). Real test `tests/test_config.gd`: config parses and `window_title` is a non-empty string; instantiating `main.tscn` sets the window title to that value.
4. **Runner self-test.** `tests/fixtures/fail/test_fail.gd` (asserts false), `tests/fixtures/crash/test_crash.gd` (calls a method on `null`), `tests/fixtures/syntax/test_syntax.gd` (unparseable line), each dir with `.gdignore`; `tests/fixtures/pass/test_pass.gd` as the control. `tests/selftest.sh` expects pass→0 and the other three→non-zero. `make test` = `tests/run.sh` then `tests/selftest.sh`.
5. **Shots.** `--shots` handling in `main.gd` (see Approach); `make shots` creates `review/shots/` and runs it. Not headless (headless has no renderer).
6. **Movie and stubs.** Real `movie` target; `sim`, `art`, `export`, `templates` stubs with phase numbers (sim: 2, art: 5, export/templates: 7).
7. **README.md.** What the project is (private prototype, one line), prerequisites (Godot 4.7 and Blender 5.2 on PATH), the command table from CLAUDE.md, how tests are laid out (`tests/test_*.gd`, `check()`), and "never open the editor; `make import` repairs `.godot`". LAN/ngrok joining is Phase 4, not here.

## Tests
| Done-when item | Proof |
|---|---|
| `make run` opens an empty window titled from `data/config.json` | `test_config.gd` asserts the title is set from config. Manual: `make run`, see the "Careers" title bar (Ringo check). Change the JSON value once, rerun, title follows, then revert. |
| `make test` exits non-zero on failing, crashing, syntax-broken tests | `tests/selftest.sh` inside `make test` asserts all three fixtures exit non-zero and the pass fixture exits 0. Manual once: `make test; echo $?` → 0. |
| `make import` rebuilds a deleted `.godot` cache | `rm -rf .godot && make import && test -d .godot && make test` passes. |
| `make shots` saves at least one PNG | `make shots && test -s review/shots/00_boot.png`; open the PNG and check it shows the background colour, not black or garbage. |
| Stubs | `make sim; echo $?` prints the phase message and returns 2. |
| LSP | `make lsp && sleep 5 && lsof -i :6005` shows a listener; `make lsp-stop` removes it. |

## Risks
- **Runtime errors don't fail anything by default.** Covered by the `run.sh` output grep plus the `ALL PASSED` sentinel. If Godot 4.7 changes its error prefix, the self-test catches it (the crash fixture would start "passing").
- **`.gdignore` fixtures may not be `load()`-able.** Scripts aren't imported resources, so `load()` should still read them. Fallback: keep the fixtures as `*.gd.txt` and have `selftest.sh` copy each one into a temp `tests/_selftest/` dir (gitignored) before running, then delete it.
- **The syntax fixture prints parse errors during `make import`** if `.gdignore` isn't honoured. Only noise, but it would look alarming. Same fallback as above.
- **Hanging test.** macOS has no `timeout`. Out of scope for Phase 0. If it bites, add `perl -e 'alarm 120; exec @ARGV'` around the runner.
- **`make shots` on a machine without a display** (CI, SSH) fails. That's expected per PROMPT.md. Agents run it on the Mac.
- **Window title on macOS.** `get_window().title` sets the title bar. The app menu still shows `config/name`. Both say "Careers" for now.

## Research notes
- Godot CLI flags (`--headless`, `--import` "waits for any resources to be imported, and then quits", `-s/--script`, `--write-movie`, `--quit-after`, `--fixed-fps`, `--lsp-port`, `--export-release`, `--check-only`): https://docs.godotengine.org/en/latest/tutorials/editor/command_line_tutorial.html
- `SceneTree` as the `-s` entry point and `quit(exit_code)`: https://docs.godotengine.org/en/stable/classes/class_scenetree.html
- Viewport capture after draw (`await RenderingServer.frame_post_draw`, then `get_viewport().get_texture().get_image().save_png()`): https://docs.godotengine.org/en/stable/classes/class_renderingserver.html
- User args after `--` via `OS.get_cmdline_user_args()`: https://docs.godotengine.org/en/stable/classes/class_os.html
- `.gdignore` excludes a folder from the import scan: https://docs.godotengine.org/en/stable/tutorials/best_practices/project_organization.html
- Movie Maker (`--write-movie` with `.avi`, needs a window): https://docs.godotengine.org/en/stable/tutorials/animation/creating_movies.html

## Rules questions for the researcher
None. Phase 0 touches no game rules.

## Questions for Ringo
- Blocking: none.
- Non-blocking:
  - Window title text? (Default: "Careers".)
  - Should stub targets exit non-zero? (Default: yes, exit 2 with a "arrives in Phase N" message, so nothing appears to succeed.)
  - LSP port? (Default: 6005, Godot's standard, which the VS Code godot-tools extension expects.)
