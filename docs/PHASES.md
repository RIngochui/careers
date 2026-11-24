# Phase roadmap

Run a phase with `/phase <number>` (Phase 1 uses `/research full`). Each phase stops for Ringo at the end.

Status key: `todo` · `in progress` · `needs Ringo` · `done`

---

## Phase 0: Project setup
**Status:** needs Ringo

Godot 4.7 project skeleton (Forward+), the Makefile with every target from PROMPT.md (stub the ones that need later phases), `.gitignore` for Godot, a README, the headless test runner, and `data/config.json` for the window title.

**Done when**
- [ ] `make run` opens an empty window titled from `data/config.json`.
- [ ] `make test` runs and exits non-zero on a failing, crashing or syntax-broken test.
- [ ] `make import` rebuilds a deleted `.godot` cache.
- [ ] `make shots` saves at least one PNG.

**Ringo check:** run `make run` once.

---

## Phase 1: Rules research
**Status:** todo · run with `/research full`

The researcher builds `docs/RULES.md` for the UK edition: turn sequence, success formula and winning, salary and Payday, every outer space, every occupation (entry, every path space in order, rewards), college and degrees, both card decks, bumping, Hospital, Park Bench, bankruptcy, optional rules.

**Done when**
- [ ] Every section above exists, with every rule sourced.
- [ ] Every outer space and path space is listed, transcribed from `docs/reference/` where readable.
- [ ] Conflicts and Unknowns are listed, each Unknown with a proposed default.

**Ringo check:** read the Unknowns and Conflicts, answer them with `/decide`, and add photos for anything marked `[unreadable]`.

---

## Phase 2: Rules engine
**Status:** todo

The whole game as pure GDScript, driven by data, proven by tests. No graphics.

**Done when**
- [ ] `data/` holds the board, occupations, cards and amounts from `docs/RULES.md`; no rules or text in scripts.
- [ ] Tests cover every space type, every occupation's special spaces, every card type, bumping, Hospital, Park Bench and the win check.
- [ ] `make sim` plays 500 games with simple strategy bots without errors or infinite loops, and reports game length and win patterns.

**Ringo check:** skim `review/sim.md`. Do games end in a sensible number of turns?

---

## Phase 3: Hot-seat board
**Status:** todo

A full game playable on one Mac with the keyboard, using primitive shapes.

**Done when**
- [ ] The 3D board matches the original's layout: outer track, corners and every occupation path in the right place and shape (compare with `docs/reference/`).
- [ ] The Mario Party-style turn menu (Roll / Cards / Map) works on screen with the keyboard.
- [ ] 2–6 local players can finish a game.
- [ ] `make shots` captures: game start, an occupation path, Hospital, Park Bench, a bump, a card being played, the win screen, and a top-down board shot.

**Ringo check:** play one full game with 2–3 seats.

---

## Phase 4: Phone controllers
**Status:** todo

Friends join and play the whole game from their phones.

**Done when**
- [ ] HTTP + WebSocket on one port, lobby with room code, join URL and QR code, VIP start, secret formula entry.
- [ ] The turn menu and every decision work on phones; private info shows only on its owner's phone.
- [ ] Reconnect works.
- [ ] A headless test plays a full game through 3 fake WebSocket clients.
- [ ] README explains LAN and ngrok joining.

**Ringo check:** play a few turns from your phone (and a second device).

---

## Phase 5: Art
**Status:** todo

Stylized low-poly models from Blender scripts replace the primitives.

**Done when**
- [ ] `make art` rebuilds everything from scratch with no manual steps.
- [ ] Tokens, board, space props, occupation landmarks and dice all exist, each with a preview PNG.
- [ ] Missing models fall back to primitives.

**Ringo check:** look through `art/previews/` and a `make shots` run.

---

## Phase 6: Presentation and juice
**Status:** todo

Make it feel like Monopoly Plus and Mario Party.

**Done when**
- [ ] Camera follow and zooms, physical dice, token hops, event cards, floating numbers, HUD panels, win reveal, audio hooks, options menu.
- [ ] `make movie` shows a full turn with every effect.
- [ ] A test proves skipping animation doesn't change results.

**Ringo check:** watch the movie, then play with friends.

---

## Phase 7: Polish and export
**Status:** todo

Main menu, pause, help screen, edge cases from playtests, a Mac build.

**Done when**
- [ ] A 6-player phone game runs start to finish without errors.
- [ ] `make export` produces a Mac `.app` (zipped) that launches and accepts phones.

---

## Phase 8: Reskin to Grindset
**Status:** later

Swap the data for Grindset's careers, board, cards, names and art, one change at a time, playtesting between changes. Planned separately once Phase 7 is done.
