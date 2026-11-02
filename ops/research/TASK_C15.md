# TASK C15 — CODEX — THE RING READ API

Model: high, Fast off (real design decisions - a new enum, a new mode,
a new plan shape - not a projection of data that already exists).

Owns `Godot/scripts/GameState.gd` (append at the end only) and the new
`Godot/tests/ring_api_test.gd`. Unblocks Claude's RING build (Kalli K16,
`research/K16_DIGEST.md` + `RING_K16.html` + five PNGs), the game's
centrepiece and the last un-kitted surface. Nothing blocks this; start now.

## Why

K16 picked a HYBRID kit body for the ring - a dedicated fight-stage canvas
inside K7's 1920x912 slot, with the instrument layer (condition, move
strips, corner dock, combo alert) built as kit overlays. It named seven
gaps GameState does not answer today. Grep before you start:
`mode` on `FightNightScreen.gd` is only ever `"live"` or `"test"`
(`FightNightScreen.gd:13-14,129`) - no `"watch"`. `method` is a raw string
today (`"ippon"`, `"ko"`, `"doctor_stoppage"`, `"DECISION"`, etc. -
`GameState.gd:8567-8568`) with no UI-facing category. There is no
corner-contingency or starred-plan concept anywhere in the file (checked,
zero matches) - this is new ground, not a read of something that exists.

## Deliver (read-only unless a gap below says otherwise)

1. **Watch mode.** A third value for how a bout is being observed -
   event-night / AI-corner, distinct from live (player corners) and test
   (the lab, no stakes). Decide where this lives (a `router.push` arg like
   `mode`, or derived from whether the player's own fighter is in the
   bout) and expose it through whatever the RING build reads to open.
2. **Region condition-% feed.** A stable read of the four regions (head,
   body, legs, gas) as percentages for both fighters, for
   `condition_rail`. Confirm what already exists on the athlete/bout state
   from Ring Night's corner system (`RingNightView.gd`) and expose a thin
   projection rather than inventing new fields if the numbers are already
   tracked.
3. **Incoming combo chain + 8s wall-clock.** Whatever RingNightView
   already computes for the combo alert (K7's language: pace / the
   8-second combo alert), exposed as a read the kit overlay can poll
   without owning fight-tick logic itself.
4. **Plan contingency list + starred default.** The between-rounds dock
   needs the corner plan's own contingency calls with one marked as the
   default/starred pick. If FightContract/corner plans do not carry
   contingencies today, this is new: keep the list short and driven by the
   plan's own data (pace, aggression, defense), never invented per-fighter
   flavor text.
5. **Method-stamp enum.** Collapse the raw `method` strings into five UI
   categories: IPPON, TECHNICAL (superiority - not a KO), DOCTOR (a
   stoppage, always drawn BAD/red, never gold), DECISION, KO. A pure
   mapping function is enough; do not change what `method` itself stores,
   only add a reader that classifies it.
6. **Missed-weight / came-in-hurt chips.** Whatever condition_rail needs
   to show a fighter arrived already carrying a problem (weight miss,
   pre-existing injury) - likely already tracked (WeightCut, injury state)
   and just needs a read.
7. **Suppressible purse/stakes line.** LAB mode must never show career
   purse or stakes in the head - confirm whatever read the RING build uses
   for the top bar/head already omits this in test mode, or add the flag
   if it does not.

## Hard rules

- No changes to fight resolution, the corner's actual math, or
  settlement - this is read-only except where a gap explicitly says a new
  field is needed (the watch-mode flag, the contingency list), and even
  those are additive, never touching how a fight is actually decided.
- `RingNightView.gd` / `FightNightScreen.gd` stay untouched - Claude's
  build discards and rebuilds them; this task does not open either file
  for editing, only for reading what already exists.
- Run the parse gate, the focused test AND the full suite yourself (you
  have Godot and credits) and say so in the digest, the way C9-C14 did.

## Test command

```
Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tests/ring_api_test.gd
```

## Owned files

<!-- Backfilled 2026-09-08. This file predates the owned-files gate, so `done --task` found nothing to check and passed vacuously. Every path below comes from this task file's own parse-gate command, test command, build sections and shipped deliverables - none was invented. -->

```
Godot/tests/ring_api_test.gd
research/C15_DIGEST.md
```
