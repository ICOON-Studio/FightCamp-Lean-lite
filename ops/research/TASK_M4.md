# TASK M4 — THE POST-FIGHT READ, THE VISUAL LANGUAGE (Maria)

**Status: OPEN.**

Model: top tier, effort medium, Fast off.

Art direction only — a spec plus reference boards, no `.gd`, no `.tscn`.
You push only your own deliverable and never edit `HANDOFF.md`; Claude
writes your block, as with M1, M2 and M3.

M3 landed on master today (`0c0e37c`) and R37 shipped the live range rail
(`cd7c88d`) with text labels, exactly as ruled — your glyphs slot in above
them later without touching layout. One note from my read of your 16px proof
row: OUT, LONG, MID and CLINCH each read unlabelled; **POCKET and CLINCH are
the closest pair at true 16px**, both dense masses. Worth one pass on POCKET
whenever the glyphs are actually slotted. Nothing is blocked by it.

## What this is

The screen a bout ends on. It exists in the engine as numbers nobody has
drawn: a card per round, a decision, and — once Codex's C23 lands — the
range aggregates your M3 card was designed for.

## What you are dressing (all of it already true in the engine)

1. **The round-by-round card grid.** One row per round, both fighters,
   10-9 / 10-8 / 10-10, knockdowns marked. It must also carry the two other
   scoring styles the engine really runs: raw POINTS accumulation
   (taekwondo, karate, wrestling, BJJ, sambo) and IPPON (judo). Three
   shapes, one visual family — a boxing card and a judo card must look like
   they came from the same game.
2. **The decision stamp.** The words already exist in the UI
   (`ProfileRevampPanel.gd:33`): UNANIMOUS / SPLIT / MAJORITY DECISION, and
   the draw types. Design the family, including the ones the engine cannot
   yet emit, so nothing has to be redrawn when it can.
3. **The range card**, slotted into this screen rather than floating on its
   own: per-round dominant band and the whole-bout owner line, from your own
   M3 section D.
4. **Honest empties and unknowns.** A bout that ended by knockout in round
   one has almost no card. A round with no standing exchanges has no
   dominant band. Draw what those look like — the house rule is that an
   empty says why, and never fakes a value.

## What you are NOT doing

- **No judges as characters.** Do not draw judge names, portraits, per-judge
  cards or bias readouts. John's J1 study is running now and rules whether
  judges are people, how many sit, and how they disagree. Drawing them first
  would be art built on a guess. The grid must simply not FIGHT a future
  where a card belongs to a named official — leave the room, draw nothing
  in it.
- No screen IA beyond this surface, no rail changes, no `.gd`, no `.tscn`.
- Nothing from the AAA profile pack. It landed as REFERENCE only
  (`d3c9b2b`) and is not adopted; do not extend it or cite it as a spec.

## Constraints (house rules, unchanged)

- `UITokens.gd` only. No new tokens — the same call that rejected MENTAL
  in M1 stands.
- **Gold ×1 per board**, and on this surface gold belongs to the verdict
  line and nothing else. CONTINUE green only. A doctor stoppage is semantic
  BAD and never gold; IPPON and TECHNICAL superiority are NOT knockouts and
  must not wear a knockout's treatment — that ruling is R31's and it holds
  here (`UIKit.RING_STAMPS`, `RingStagePanel._classify`).
- Code-drawable: thick strokes, transparent ground, the TechniqueGlyphs
  family. Board PNGs are design reference; they are never imported as
  runtime bitmaps.
- Prefix every file `m4_` so M1's and M3's packs stay intact.

## Deliverables

- Spec: `research/M4_POST_FIGHT_READ.md` — the rules, a token map, a
  motion table if anything moves, and a file list, in the shape of your
  M3 pack.
- Boards: `DesignLibrary/screens/post_fight/m4_*` — at minimum the card grid
  in all three scoring styles, the decision stamp family, the range card in
  place, and the empty/unknown states.
- Staging zip in `_maria_delivery/` as usual. It is not committed; Claude
  lands the spec and the boards.

## Reference

- The engine's own scoring: `Godot/scripts/RoundScoring.gd` — three styles,
  `ten_point_must` / `points` / `ippon`.
- What a card holds: `FightSimulation.gd:2570` (round, a, b, score_a,
  score_b, knockdowns_a, knockdowns_b).
- The read that will bind this: `research/TASK_C23.md` (Codex, running
  in parallel) — its `cards`, `totals`, `decision` and `range` blocks are
  the fields you are dressing. It does not block you and you do not block it.
- Your own M3 section D for the range card, and `research/K22_RANGE_READ.md`
  section 5 for how the post-fight range read is supposed to speak.
- The finish stamps that already exist: `UIKit.RING_STAMPS`,
  `RingStagePanel.show_result`.

## Owned files

<!-- Backfilled 2026-09-08. This file predates the owned-files gate, so `done --task` found nothing to check and passed vacuously. Every path below comes from this task file's own parse-gate command, test command, build sections and shipped deliverables - none was invented. -->

```
research/M4_POST_FIGHT_READ.md
```
