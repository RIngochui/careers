# CLAUDE.md

A faithful 3D digital recreation of the board game **Careers** (UK edition), built in Godot 4.7 with phone controllers. Private prototype; it will later be reskinned into Ringo's own game, Grindset.

## Source of truth, in order
1. What Ringo says in the current session
2. `docs/DECISIONS.md`: Ringo's rulings
3. `docs/RULES.md`: the original game's rules and content, maintained by the researcher agent
4. `PROMPT.md`: the build spec (architecture, presentation, workflow)

`docs/reference/` holds photos of Ringo's physical copy. They beat any online source for rules and text.

## Team
| Agent | Model | Owns | Writes to |
|---|---|---|---|
| researcher | sonnet | What the rules are | `docs/RULES.md`, `docs/research/` |
| planner | opus | How to build a phase | `docs/plans/` |
| coder | sonnet | Building it | code, data, tests |
| reviewer | opus | Independent checking | `review/` |

Commands: `/phase N` (full loop), `/research <question>` or `/research full`, `/review [range]`, `/decide <ruling>`.

## House rules
- **Never open the Godot editor.** Everything runs through `make` (see below). Build scenes in code where practical; keep `.tscn` files small and readable.
- **All rules, numbers, names and text live in `res://data/`.** Never hard-code them in scripts. This is what makes the later reskin a data swap.
- **Never invent rules.** If `docs/RULES.md` doesn't cover something, ask the researcher; if it's still unknown, use its proposed default and say so.
- **A task isn't done until `make test` passes**, and for anything visible, `make shots` has been run and the PNGs looked at.
- One task, one commit. Never push to a remote unless Ringo asks.
- Only the researcher edits `docs/RULES.md`. Only `/decide` edits `docs/DECISIONS.md`. Nobody edits `PROMPT.md` or `.claude/` without Ringo.

## Commands
| Command | What it does |
|---|---|
| `make run` | Launch the game |
| `make import` | Headless import; repairs a missing `.godot` cache |
| `make test` | All headless tests |
| `make sim` | Balance simulation → `review/sim.md` |
| `make shots` | Scripted demo screenshots → `review/shots/` |
| `make movie` | Demo recording → `review/` |
| `make art` | Rebuild Blender assets, then import |
| `make export` | Mac and Windows builds |
| `make lsp` / `make lsp-stop` | GDScript language server for VS Code |

Godot 4.7.x is on PATH as `godot`; Blender 5.2.x as `blender`. (Phase 0 creates the Makefile; until then these don't exist.)

## Layout
```
.claude/          agents and commands
data/             rules, board, occupations, cards, text (res://data/)
src/              GDScript: engine/ (no scenes), presentation/, net/
controller_web/   phone controller page
art/blender/      Blender scripts; art/previews/ for renders
assets/models/    exported .glb files
tests/            headless tests and the sim
docs/             RULES.md, DECISIONS.md, PHASES.md, plans/, research/, reference/
review/           REVIEW.md, sim.md, shots/
```
