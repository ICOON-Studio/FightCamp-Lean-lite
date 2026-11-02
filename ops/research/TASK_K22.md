# TASK K22 — THE RANGE, HOW IT READS (Kalli)

Model: top tier, effort high, Fast off.

A STUDY, not a build. Deliverable is one markdown file in
`research/`. Kalli pushes only its own deliverable and never edits
`HANDOFF.md` — Claude writes Kalli's block.

## Why this exists

R35 gave the fight simulation a distance model it never had. The standing
fight is now played on a contested band — `OUT / LONG / MID / POCKET /
CLINCH` — that the two fighters argue about every exchange. Reach and height
finally matter: the longer man wants it long, the shorter man has to cross
the longer man's range to have a fight at all, and crossing costs him a free
look. Every action event now carries the band it was thrown from, and
`fight_state` carries who is dictating the distance.

**None of that is worth anything if the player cannot see it.** A hidden
multiplier is not a mechanic, it is a rumour. This study decides what the
player sees, in what surface, and in what words.

## The question

How does DISTANCE read to somebody watching their fighter — before, during
and after a bout — in a manager game whose fight surface is a stepped
exchange log and a corner that can be talked to between rounds?

## What to answer

1. **The one indicator.** Is there a range bar, a ladder, a two-headed
   marker, a positional diagram, or none of those? Where does it live in the
   fight surface, how big, and what does it do when the band changes
   mid-round? Rule out as much as you rule in — the surface already carries
   health, stamina, the round clock and the exchange log, and R32's ONE-gold
   rule still holds.
2. **Who owns it.** The most interesting fact the model produces is not the
   band, it is WHOSE band it is. Find the reading that says "he is fighting
   Ruiz's fight" in a glance, not a number.
3. **The words.** The fight log is the game's main voice. What does an
   exchange thrown at LONG say versus one in the POCKET? What does the entry
   toll — the shorter man crossing and getting caught on the way in — read
   as in one line? Give ten to fifteen real example lines, not a template.
4. **Before the bout.** The tale of the tape already prints REACH for both
   corners (`ScheduleHubPanel.gd:920`). Should it now say what the reach
   MEANS — who wants it where, and who has to travel? Decide whether that
   belongs on the booking surface, the fight-week surface, both or neither.
5. **After the bout.** Does the fight report say where the fight was fought,
   and is that a per-round fact or a whole-bout one? A round summary that
   said "round 3 was fought in the clinch" would explain a scorecard the
   player did not understand.
6. **The corner call (stage B, decide it now).** Stage B gives the corner a
   range instruction — "stay long", "get inside", "tie him up". Name the
   two-to-four calls that are actually worth offering, in the corner's own
   voice, and say which existing emphasis calls they would sit beside or
   replace. Do not design the menu's pixels, design its vocabulary.

## What NOT to do

- No implementation, no `.gd`, no `.tscn`, no changes to any existing file.
- Do not redesign the fight surface. R31/R34's frame and the ONE-gold rule
  stand; you are adding one reading to a screen that exists.
- Do not invent new stats or new simulation behaviour. If the reading you
  want needs a fact the engine does not produce, say so explicitly in a
  short "what the engine would have to add" section and stop there.

## Anchors

- The model itself: `Godot/scripts/FightRange.gd` — read the file header
  first, it is the whole design in 40 lines. `describe()` at the bottom is a
  first draft of the log's vocabulary and you should improve on it.
- What the engine already emits: `fight_state["range_band"]`,
  `["range_owner"]`, `["range_event"]` (which carries `from`, `winner`,
  `mover`, `entered`, `contested`), and per action event `range_band`,
  `entered_range`, `range_moved_to`.
- The fight surfaces you are writing for: `Godot/scripts/FightNightScreen.gd`,
  `Godot/scripts/RingStagePanel.gd`, `Godot/scripts/FightLog.gd`.
- The tale of the tape: `Godot/scripts/TaleOfTape.gd`,
  `Godot/scripts/ScheduleHubPanel.gd:920`.
- Prior art you wrote: `K19` (the live fight scene, how it reads) and `K21`
  (the fight camp). Same house voice.

## Deliverable

`research/K22_RANGE_READ.md`. Short sections, concrete rulings, and a
one-paragraph summary at the top that Claude can act on without reading the
rest. Say what the ruling IS, not what the options were.

## Owned files

<!-- Backfilled 2026-09-08. This file predates the owned-files gate, so `done --task` found nothing to check and passed vacuously. Every path below comes from this task file's own parse-gate command, test command, build sections and shipped deliverables - none was invented. -->

```
research/K22_RANGE_READ.md
```
