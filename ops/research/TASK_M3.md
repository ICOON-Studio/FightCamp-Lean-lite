# TASK M3 — THE RANGE RAIL, PASS TWO (Maria)

**Status: COMPLETE 2026-09-06.** Landed by Claude; spec `research/M3_RANGE_RAIL_PASS2.md`.

Model: top tier, effort medium, Fast off.

Art direction only — the deliverable is a spec plus reference images, no `.gd`
and no `.tscn`. Maria pushes only her own deliverable and never edits
`HANDOFF.md`; Claude writes Maria's block.

M1 was landed and is good work: the Range Rail instrument, its five states,
its motion table and its placement all stand. This task closes the four gaps
the M1 review found, and adds the one reading K22 named that nobody has drawn.

## You are NOT blocking anything

R37 (Claude) is building the Range Rail **now**, from M1 plus the rulings
below. It ships with text labels in the cells and no glyphs. Your work slots
into a finished instrument afterwards — so do not re-spec geometry, and do not
wait on R37 or hurry for it.

## What was ruled since M1 (build these, do not re-open them)

R37 settled the four open questions. Your pass dresses these decisions:

1. **Owner is a text row under the rail**, not a chip on the pip — K22's
   surname reading (`RUIZ'S FIGHT` / `AT RANGE`) in a 14px row at the bottom
   of the 600×80 slot. The ladder keeps your ticks.
2. **The corner range call rides the OURS tick.** The tick sits at the band
   the corner called, drawn HOLLOW (outlined `GOOD`, no fill) to say "he is
   being told"; FILLED means "he wants". The owner row appends the call in
   corner voice: `STAY LONG` / `GET INSIDE` / `TIE HIM UP`.
3. **Clinch lock is dropped** — no engine state backs it. CLINCH is an
   ordinary cell.
4. **`MENTAL #8B7AD8` is rejected for now.** Existing `UITokens.gd` only. If
   you still want a mental/tactical colour, make the case across more than
   one surface and it gets revisited — do not assume it in this pack.

Also, a correction for your token table: there are no `COOL_LO` / `COOL` /
`COOL_HI` constants. Those three hexes are `COOL_RAMP[0..2]` in
`UITokens.gd:78`. Your hexes were right; the names were not.

## Deliverables

### 1. Band glyphs that actually read at 16px — the real job

M1's glyph set fails its own stated bar. At 16px, OUT, LONG and MID are
indistinguishable, because the only thing separating them is the gap between
two identical figures, and a few pixels of gap is the weakest cue there is at
that size. POCKET and CLINCH degrade to blobs.

Rebuild the set so each band is told apart by **silhouette, not spacing**.
Solve it however reads best — but the test is fixed: **five glyphs at 16px,
side by side, correctly named by someone who has not seen the labels.** Ship
the 64px masters and the 16px proofs the way M1 did, and include one board
showing all five at 16px in a row against the panel ground, which is the only
context that matters.

House idiom stands: thick white strokes on transparent, tinted by state, same
family as `TechniqueGlyphs.gd`.

### 2. The corner range call, drawn

One board showing the OURS tick in both treatments (filled = his own game,
hollow = corner called) across the three calls, with the owner row beneath
reading the call word. Include the case that matters most: the call is
standing and the fight is NOT yet at the called band — that is the state the
player most needs to read, because it is the whole point of a range call.

### 3. The owner row

One board of the three owner states: a surname (`RUIZ'S FIGHT`), the neutral
`AT RANGE` when `range_owner` is empty, and the contested case where K22 ruled
the surname drops away until the argument settles. 14px row, `TEXT_2`, no gold.

### 4. The post-fight range card — K22's unclaimed gap

K22 section 5 asked for two post-bout readings nobody has drawn: a **per-round
dominant band** line ("Round 3 fought mostly in POCKET") and a **whole-bout**
line ("Fought at MID · range belonged to Ruiz"). Design that card. It is a
report surface, not a live instrument — different constraints, more room, and
it can carry the glyphs at a comfortable size.

Note for the brief: the engine does not aggregate this yet. Design it anyway
and say what it needs; naming the gap precisely is what gets it built.

## Constraints

- Bebas / Plex kit. Existing `UITokens.gd` only.
- **Gold is forbidden on the rail and its glyphs.** Fight-surface gold stays
  on the loudest board action. The post-fight card may use gold once if the
  card genuinely has a single loudest element — your call, say which.
- Green = CONTINUE only, as always.
- Do not redesign the fight surface, and do not re-spec the rail's geometry —
  R37 is building it to M1's numbers.
- Silhouettes. Invent no new sim behaviour.

## Deliverable paths

- Spec: `research/M3_RANGE_RAIL_PASS2.md`
- Images: `DesignLibrary/screens/range/` (alongside M1's, do not overwrite —
  prefix new files `m3_`)
- Staging zip if you want one: `_maria_delivery/` (never committed; Claude
  extracts and lands)

## Reference

- Your own M1: `research/M1_RANGE_VISUAL.md`, boards in
  `DesignLibrary/screens/range/`.
- The words: `research/K22_RANGE_READ.md` — sections 2 and 5 are the
  ones this task acts on.
- What the engine actually knows: `research/TASK_R36.md`.
- The kit: `DesignLibrary/kit/index.html`.

## On the AAA profile pack

The unassigned AAA profile kickoff you produced is **parked, not rejected** —
it is not committed and it is not this task. It proposes a different left rail
and reopens the R18/R23 profile, which are operator calls, not art calls. It
waits for the operator. Please do not extend it until then.

## Owned files

<!-- Backfilled 2026-09-08. This file predates the owned-files gate, so `done --task` found nothing to check and passed vacuously. Every path below comes from this task file's own parse-gate command, test command, build sections and shipped deliverables - none was invented. -->

```
research/M3_RANGE_RAIL_PASS2.md
```
