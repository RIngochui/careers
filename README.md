# Careers (digital edition)

Private prototype: a 3D recreation of the board game Careers in Godot 4.7, with phone controllers.

## Prerequisites
Godot 4.7 and Blender 5.2 on PATH (`godot`, `blender`).

## Commands
| Command | What it does |
|---|---|
| `make run` | Launch the game |
| `make import` | Headless import; repairs a missing `.godot` cache |
| `make test` | All headless tests (plus a self-test of the runner) |
| `make sim` | Balance simulation (stub until Phase 2) |
| `make shots` | Scripted screenshots to `review/shots/` (needs a window) |
| `make movie` | Demo recording to `review/demo.avi` |
| `make art` | Rebuild Blender assets (stub until Phase 5) |
| `make export` / `make templates` | Builds (stubs until Phase 7) |
| `make lsp` / `make lsp-stop` | GDScript language server on port 6005 |

## Tests
Put tests in `tests/test_*.gd`, extending `res://tests/assert.gd`. Every `test_*` method runs; report with `check(cond, msg)`. A runtime or parse error also fails the run.

Never open the Godot editor. If `.godot` goes missing, `make import` rebuilds it.
