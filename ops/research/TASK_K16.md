# TASK K16 — THE RING (Kalli)

Model: top tier, effort high, Fast off. **Study only**: no `.gd`, no
`.tscn`, no HANDOFF edit. Push your `research/` deliverables; Claude
writes your block.

## Why now

Every management surface has been rebuilt from the kit — gym, training, the
fighter card, schedule, scouting, office, staff, the five set-pieces (R27)
and the boot gate (R29). **The fight itself is the last one, and it is the
centrepiece.** `RingNightView.gd` (1792 lines) and `FightNightScreen.gd`
(809) are pre-kit: their own colours, their own layout, arcade wordart, and
a decade of features bolted on one at a time.

R27 changed the frame around it and deliberately did not touch the inside.
`FightNight.tscn` is now instanced as a BODY inside `SetpieceRoot`'s K7
chrome, scaled to fit a 1920×912 slot with its authored 1920×1080 canvas —
so the ring is currently a slightly shrunk picture of an old screen inside a
new frame. That is the seam this study has to settle.

## What already exists (do not restate it, judge it)

- **The K7 frame owns** the way out, the stake line, the clock/round cell,
  the two names and the phase label. Whatever the ring draws must not say
  those things twice.
- **`FightNightScreen.gd`** owns the tick loop, the corner bar, the finish,
  and `setup(bout_id, mode)` with modes **live** (a real booked bout) and
  **test** (the Match Simulator lab, no career stakes).
- **`RingNightView.gd`** draws the fight: impact FX, corner-coloured damage
  numbers, arcade wordart moments (FIGHT!, ROUND N, KNOCKOUT!), a real-time
  move strip per fighter with incoming combo links ghosted, the
  incoming-combo alert with an **8-second wall-clock decision bar**, and
  body-region damage feeding back into the fight.
- **The systems behind it, all live and all complete on the backend**:
  combo chains (engine, show, training), fight plans v2 (ruleset-aware
  judge, archetypes + pace, the signature battle and coach contingencies),
  rapport driving the corner listen rate, weight-cut cost riding into the
  bout, and the ruleset-specific methods — including IPPON and TECHNICAL
  superiority, which are not knockouts and must not be drawn as one.

## Settle these

**A. Shape.** Does the ring stay one full-canvas scene scaled into the K7
body, or is it rebuilt as a kit body that fills the 1920×912 slot natively?
Say which, and say what is lost either way. Consider at least: native kit
body; the scene kept and re-dressed; a hybrid where the ring canvas stays
and only the instrument layer is kit-built.

**B. The round.** What must be on screen while the fight runs, in priority
order, and what is currently there that has to go. The two fighters and
their condition, the action as it happens, the move strips, region damage —
rank them and place them. One figure once per screen; silhouettes.

**C. The corner.** This is the interactive half and it is the reason the
board exists: pace calls, the combo alert on its 8-second clock, the
between-rounds contingency menu with the plan's own call starred, "let the
chain go". Is that ONE surface or several, and what stays readable while
the fight is moving? A call the player misses because they were reading is
a design failure, not a player failure.

**D. The moment layer.** Wordart, damage numbers, impact FX. What survives
the kit as a real moment (the finish, the belt, the round bell) and what is
arcade noise that the rest of the game outgrew. Gold is spent once; a
stoppage is semantic BAD red and never gold.

**E. Modes.** live / test, plus event-night watch where the player coaches
their own side of someone else's card. One board differently dressed, or
different boards? What must never appear in the lab (career stakes) and
what must never disappear in a real bout.

**F. States.** No bout. Doctor stoppage. IPPON and TECHNICAL superiority.
A decision on cards. A fight the player is NOT coaching (AI corner). A
fighter who came in hurt or missed weight.

**G. Kit gaps.** Reuse first — the kit is 240 variants across 19 families,
and the setpiece family already carries the frame, the scale readout, the
verdict block, the scorecards and the belt hero. Name only what is genuinely
missing, as an instrument with a one-line need.

## Deliverables (`research/`)

- `RING_K16.html` — the boards, 1920×1080, inside the K7 set-piece frame
  (not ShellChrome; the shell is suspended for a set-piece).
- `RING_K16_round.png`, `_corner.png`, `_combo.png`, `_moment.png`,
  `_states.png`.
- `K16_DIGEST.md` — A-G in short form, with the picks and what was rejected.

## Rules

- **Invent no data.** Everything drawn comes from what the fight already
  produces. If a board needs something the simulation does not expose, name
  it in the digest as a gap for Codex, the way K14 named the incompatible
  save (C12) and K15 named the movement delta (C13).
- Kit rulings: Bebas / Plex, SIZE_MIN 12, **gold ×1 per board**, GREEN is
  Continue and Continue only (on a set-piece it appears on the result's way
  out and nowhere else), pair blocks stay slate, the facility is a GYM,
  females never fight males, silhouettes for figures, no drag primitive.
- Do not open `GameState.gd` and do not read `HANDOFF.md` whole
  (`sed -n '/^## Active claims/,/^## Direction notes/p' HANDOFF.md`).
- Legacy `RingNightView.gd` is discarded and rebuilt, not migrated — the
  standing rule for every pre-kit scene. You do not have to read all 1792
  lines to judge it; read what you need to be specific.

## Blocks nothing

Claude's next two stages are R28 (career creation, on your K13) and R30 (the
rankings, on your K15). This study lands in time for the stage after them.

## Owned files

<!-- Backfilled 2026-09-08. This file predates the owned-files gate, so `done --task` found nothing to check and passed vacuously. Every path below comes from this task file's own parse-gate command, test command, build sections and shipped deliverables - none was invented. -->

```
research/K16_DIGEST.md
```
