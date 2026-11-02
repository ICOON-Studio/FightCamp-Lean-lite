# TASK C17 — THE LIVE FIGHT SCENE: ARCHITECTURE DEEP-DIVE (Codex)

Model: top tier, effort high, Fast off. **Research and design only**: no
`.gd`, no `.tscn`, no HANDOFF edit. Deliverable is one document (plus its
diagram) in `research/`; push it and message Claude.

This is the operator's brief, translated to this repository. Where the
brief names `@src/`, `@src/core/` or `@src/entities/`, this project's
equivalents are `Godot/scripts/` — there is no `src/`.

## The ask

Stage a **live, real-time isometric Fight Scene** in Godot for a combat
sports management game where the player coaches: they watch a round and
intervene mid-round with macro commands whose effect is bounded by the
fighter's own attributes and reaction time — impactful, never arcade.

## Read this first, because it shipped four hours ago

R31 rebuilt the ring (`05c3131`, `ae1a9ef`, digest `R31_DIGEST.md`, boards
`DesignLibrary/screens/ring/`). Do not design as if the surface were
empty, and do not assume it is sacred either: the operator has explicitly
opened current mechanics to change for the best result. Your job is to say
which parts survive contact with a real-time isometric world and which do
not, with reasons.

What exists now, all of it verified in code:

| Piece | Where | What it does |
|---|---|---|
| The tick | `FightNightScreen.gd` | A `Timer` at `FIGHT_TICK_SECONDS = 1.4` calls `FightSimulation.advance_exchange()`. **Nothing in the fight runs in `_process` or `_physics_process` — there is no per-frame simulation at all.** |
| The model | `FightSimulation.gd` (138k) | Discrete EXCHANGES. `AVG_SECONDS_PER_EXCHANGE = 14.0`, `MIN_EXCHANGES_PER_ROUND = 6`, so a 180-second round is ~13 exchanges and a 3-round bout is ~40 ticks ≈ 55 s of wall clock at 1×. Speed control is 1× / 2× / 4× on the Timer, not on any animation. |
| Space | — | **There is none.** The state carries `phase` (STANDING / GROUND) and `top_side`, and nothing else spatial: no positions, no distance, no ring coordinates, no facing. |
| The picture | `RingStagePanel.gd` (R31) | A 2.5D stage: venue plate, a drawn ring floor per `arena_profile`, two photo silhouettes, an impact burst / evade streak, and a lunge-and-recover tween chosen from the event's `animation_family`. |
| The instruments | `UIKit.gd` "ring" family | `condition_rail` (head/body/legs/gas), `move_strip`, `corner_dock`, `combo_alert_8s`, `verdict_stamp_ring`, `watch_mode_chip`. |
| The intervention | `FightNightScreen._dock_sides()` + `FightSimulation.get_available_corner_instructions()` / `apply_corner_instruction()` | Pace and emphasis calls, plan contingencies, "let the combination go". A call rides a LISTEN ROLL against coach rapport and the fighter's own tactical rating — it can be waved off. The 8-second incoming-combo window (`ComboDecisionTimer.gd`) is the one hard real-time beat in the game. |
| The read | `GameState.get_ring_read_contract()` (C15, yours) | mode live/test/watch, the four condition reads, arrival chips, plan contingencies, the live combo, the method stamp. |
| The frame | `SetpieceRoot.gd` + `SetpieceChrome.gd` (K7) | The ring is a BODY in a 1920×912 slot; the frame owns the way out, the stakes line, the round digit and the names. R31 made a body that answers `adopt_body_size()` mount 1:1. |

## 1. Godot and repository context

- Map the current architecture honestly: the Timer-driven tick, the
  pause/resume seam around a corner window, `SetpieceRoot`'s body slot,
  and where a `SubViewport` + `Node3D` world would attach without the
  frame or the kit HUD having to know about it.
- Say exactly how a discrete 14-fight-second exchange becomes continuous
  motion: interpolation between exchange outcomes, an animation queue that
  consumes events, or a re-timed sim. Name the trade-off in determinism —
  every test in `Godot/tests/` drives the fight by calling
  `advance_exchange()` directly, and `run_to_completion_for_test()` must
  keep working without a rendered frame.
- The simulation has **no spatial state**. Either the scene invents
  choreography from event families (what R31 does), or the model gains
  position/distance. Recommend one, and if it is the second, say what
  `FightSimulation.gd` would have to carry and what that costs the
  existing tests and save data.
- Keep the separation the brief asks for: the isometric world in a
  `SubViewport`/`Node3D`, the coaching HUD in `Control` nodes, and no
  gameplay logic in either.

## 2. External market and UX research

Use your search tools. Concrete systems, not adjectives.

- How real-time management and tactical games present coaching overlays
  and live feedback (Football Manager's 3D match engine and its touchline
  shouts, EA UFC's coach corner, tactical/RTS ability bars, Total War's
  live orders, Fire Pro / WMMA-style sims for the manager-facing end).
- **How a sim keeps active intervention from feeling arcade**: what
  visual instruments (cooldowns, a reaction/attention meter, a listen or
  "did they hear you" indicator, commitment windows) communicate that the
  command is a REQUEST bounded by the fighter's attributes. We already
  have a listen roll and an 8-second window — say what the market does
  that we do not.
- Godot-specific pitfalls when mixing world-space elements (a bar floating
  over a fighter's head) with screen-space `CanvasLayer` UI:
  `unproject_position` cost and jitter, billboard scaling with camera
  distance, sorting and occlusion, `SubViewport` stretch and pixel
  snapping, input routing between the 3D world and the HUD, and what
  breaks when the viewport is a 1920×912 slot rather than the window.

## 3. Constraints that are not negotiable

- Females never fight males; the facility is a GYM, never a camp.
- The K7 frame owns the way out, the stakes line, the round digit and the
  names. The scene must not say any of them twice.
- Kit law (`ui_kit_manifest.json`, family "ring"): Bebas / IBM Plex,
  `SIZE_MIN` 12, **gold ×1 per board**, green is CONTINUE only, a doctor
  stoppage is semantic BAD, IPPON and TECHNICAL superiority are not
  knockouts.
- Ripped assets never ship. The two photo silhouettes and the venue plate
  in `Godot/assets/images/fight/` are what we own today; if the answer
  needs 3D models, say what class of asset and how it is sourced.
- Determinism: `begin_fight()` takes a seed and the whole suite depends on
  the same seed giving the same fight.

## 4. Definition of done — `research/C17_FIGHT_SCENE.md`

1. **A Godot scene-tree diagram** (a fenced ASCII tree is fine) of the
   proposal: `SubViewport` / `Camera3D` (or the 2.5D equivalent you argue
   for), the world root, the fighter rigs, the `CanvasLayer`s, and where
   today's `RingStagePanel` instruments live in it. Show it as a body
   inside `SetpieceRoot`'s 1920×912 slot, not as a full-window scene.
2. **A markdown comparison table** of **three** shipped real-time tactical
   systems: how each handles mid-match player intervention, how it keeps
   HUD clarity, and what we should copy or refuse. One row per system,
   with a "what it costs us" column.
3. **Three highly-targeted technical questions for the operator** about
   how our simulation ticks should meet Godot's `_process` /
   `_physics_process` loop — asked with the numbers above in hand (1.4 s
   per exchange, 14 fight-seconds per exchange, the pause seam, the
   determinism requirement), not in the abstract. Put them at the TOP of
   the digest and in your mailbox message; Claude relays them and the
   answers gate the build.
4. **A keep / change / drop ledger against R31**, line by line: the stage
   canvas, the condition rails, the move strips, the corner dock, the
   combo alert, the stamps, the C15 read, the speed control.
5. **A staged path**: what ships first, what it costs, and the smallest
   version that is still a real improvement over what is on master today.

## Rules

- No engine work, no scene files, no edits to `GameState.gd`,
  `FightSimulation.gd`, `RingStagePanel.gd` or any test. This task ends
  with a document.
- Read the files you cite. Where you propose changing a mechanic, name the
  tests in `Godot/tests/` that would have to move.
- Kalli has the visual half of this question (K19: what the scene LOOKS
  like and how the HUD reads). Stay on architecture, mechanics and the
  market; do not draw boards.

## Test command

None — nothing executable ships. Sanity gate before you push:
`python Godot/tools/check_scripts.py` over any file you touched (expected:
none).

## Owned files

<!-- Backfilled 2026-09-08. This file predates the owned-files gate, so `done --task` found nothing to check and passed vacuously. Every path below comes from this task file's own parse-gate command, test command, build sections and shipped deliverables - none was invented. -->

```
research/C17_FIGHT_SCENE.md
```
