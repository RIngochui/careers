# Build spec: Careers, digital edition (private prototype)

Build a faithful 3D digital recreation of the board game **Careers** (UK edition) in **Godot 4.7 (GDScript)**, with Monopoly Plus-style presentation, a Mario Party-style turn menu, and Jackbox-style phone controllers. It targets **PC (Mac first, Windows later)**.

This is step one of a two-step plan: build the original game first, get it playable and fun to look at, then reskin it into Ringo's own game (Grindset) by swapping data. So:
- **Rules and content are not in this file.** They live in `docs/RULES.md`, which the researcher agent builds from the original game. `docs/DECISIONS.md` overrides it where Ringo has ruled.
- **Everything that could change in the reskin must be data:** board spaces, occupations and their paths, cards, amounts, text, names, colours.
- **This is a private prototype.** It uses the original's name, rules and text for personal playtesting only. Nothing gets published or put on Steam until it's been converted to original content.

---

## 1. Architecture

### Host = the Godot game (the "TV")
- Runs on the Mac everyone watches: the 3D board, tokens, camera moves, animations, stats and turn log.
- Hosts the networking. Phones never run Godot.

### Phones = controllers (browser, no install)
- The Godot app runs a small built-in HTTP server (`TCPServer`) that serves a static controller page bundled in the project (`res://controller_web/`), plus a WebSocket server (`WebSocketPeer`) on the **same port** with an upgrade on `/ws`, so one ngrok tunnel works for remote friends.
- Lobby screen shows the join URL, a 4-letter room code and a QR code.
- Phone flow: open URL → room code + name → pick token colour → set secret Success Formula → wait in lobby. The first player to join is the VIP and starts the game.
- Phones show only that player's private info and choices. All logic and dice are **server-authoritative** in Godot. Phones send intents; Godot validates and broadcasts state.
- Reconnects: a dropped phone rejoins with the same name and room code and resumes its seat.
- **Hot-seat keyboard mode stays working** as a fallback and for testing.

### Code structure
- **The rules engine is pure GDScript with no scene dependencies** (`GameState`, `RulesEngine`, `SpaceResolver`, `Occupation`, `Deck`), driven entirely by data in `res://data/`.
- The engine emits an **ordered event stream** (`moved`, `space_resolved`, `stat_changed`, `card_drawn`, `bumped`, …). The presentation plays events back as animations in order; phones get state snapshots. Animation can be skipped without changing results.
- **Seeded RNG** so tests, sims and replays are deterministic.
- Player choices are **pending decisions** the engine waits on (enter occupation? play a card? which degree?), answerable by a keyboard, a phone or a test.
- **Headless tests** cover every rule in `docs/RULES.md`. A **simulation** plays hundreds of games with simple strategy bots and reports game length and win patterns to `review/sim.md`.

### Editor-free workflow (required)
Ringo never opens the Godot editor. Everything is done from the terminal by agents. Provide a `Makefile` with:
- `make run`: launch the game window.
- `make import`: headless asset import (`--headless --import`); must always repair a missing `.godot` cache.
- `make test`: run all headless tests; non-zero exit on failure.
- `make sim`: run the balance simulation and write `review/sim.md`.
- `make shots`: play a scripted demo and save PNGs of key moments to `review/shots/` (needs a real window; headless can't render).
- `make movie`: record a short demo with `--write-movie` into `review/`.
- `make art`: rebuild all Blender assets headlessly, then import.
- `make export`: macOS and Windows builds (`--headless --export-release`), plus `make templates` to download export templates.
- `make lsp` / `make lsp-stop`: background GDScript language server for VS Code.

Build scenes in code where practical; keep `.tscn` files small and readable. Godot is on PATH as `godot` (4.7.x); Blender as `blender` (5.2.x).

---

## 2. Turn flow (Mario Party style)

Every turn has the same shape:
1. **Turn banner** on the TV ("Ringo's turn!"), camera on the active token.
2. **Action menu** on the player's phone (mirrored on the TV):
   - **Roll:** hit the dice block.
   - **Cards:** play an Opportunity or Experience card instead of rolling, following the original's rules for when cards can be played.
   - **Map:** free camera look around the board, then back to the menu.
3. **Move:** the token hops space by space with a countdown above it. Things that trigger on passing (like Payday) pop up mid-move.
4. **Land:** the space resolves with a big event card on the TV.
5. **Turn ends**, next player.

Entering an occupation follows the original's rules exactly (as in `docs/RULES.md`). No Mario Party-style forks.

---

## 3. Presentation (Monopoly Plus-lite)

- **3D tabletop board** matching the original's layout: the outer track, the corner spaces, and each occupation's inner path in the same places and shapes as the real board (see `docs/reference/`). Path layout is generated from data, not hard-coded.
- **Camera:** overview shot, smooth follow of the active token, dramatic zooms for big moments.
- **Dice:** physical-looking 3D dice whose result comes from the engine; the animation lands on it.
- **Tokens:** hop with squash and stretch. Floating `+£2,000` / `+4 ♥` / `+2 ★` numbers over tokens.
- **Juice:** screen shake on bumps, coin and confetti bursts on big gains, sad sounds on losses.
- **HUD:** player panels in the corners (Mario Party style) with name, colour, money, fame, happiness, salary and status. Highlight whose turn it is.
- **Audio hooks:** audio bus plus SFX and music trigger points, with placeholder sounds.
- **Options:** volume, fullscreen/windowed, animation speed (1×/2×/skip).

### Art pipeline: Blender, fully scripted
- All 3D assets come from Blender Python scripts in `art/blender/`, one per asset family, sharing `art/blender/style.py` (palette, bevels, materials). Stylized low-poly.
- `make art` runs `blender --background --python art/blender/build_all.py`, exports `.glb` files into `res://assets/models/`, and renders a preview PNG per asset into `art/previews/`.
- Until a model exists, use a primitive stand-in of the same size, so art never blocks progress.

---

## 4. Phases
See `docs/PHASES.md`. Each phase is run with `/phase N`: plan, fill rules gaps with the researcher, build, independent review, fix, then stop for Ringo.
