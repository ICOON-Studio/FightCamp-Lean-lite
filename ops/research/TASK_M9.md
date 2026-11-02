# TASK M9 — THE SCALE ON THE BELT (Maria)

**Status: ASSIGNED 2026-09-07.** Art only. Depends on M7 (`d05d407`), R42
(`a534dad`) and K23 (`0953087`).

Model: top tier, effort medium, Fast off. One delivery.

## Why this exists

K23 ruled how the belt reads and gave the build seven kit gaps. It was
written **before the belt met the scale**, so its bout states are only two:
**TITLE BOUT** when the booking stamped one, and **PENDING** when it has not
been stamped yet.

R42 has since shipped a third fact, and K23's kit has no mark for it:

- a bout that **was** a title fight where the belt **could not follow the
  result**, because a contestant missed the contracted limit
  (`title_blocked_by_weight` in `{winner_missed, both_missed}`);
- a division that reads **vacant because a champion missed weight** — which is
  not the same story as R7's vacancy, where a champion moved up and gave the
  belt away.

Without a mark, a build has two bad choices: flatten it to "not a title bout"
(the exact thing K23 and C26 both reject) or dress it as a failure. It is
neither. **It is a rule working**, and that is the same argument M8 just won
for the AUTHORED chip on authored money.

## The call

**What does a belt that could not move look like, and how is it different from
a belt nobody was fighting for?**

Three marks, sitting in one schedule row and one division row without turning
the screen into a footnote wall:

1. **TITLE BOUT** — stamped and live. M7's SODIUM. Exists; cite, do not redraw.
2. **PENDING** — not stamped yet. MUTED. Exists; K23 §5, `stamped == false`
   reads PENDING and never NO.
3. **BELT NOT ON THE LINE** (new) — the bout is a title fight and the belt
   cannot follow it. Needs a fill of its own that reads as *a rule holding*,
   not as an error or a warning.

Plus the division state:

4. **VACANT ON THE SCALE** (new) — the belt is vacant because the champion
   missed the limit, distinguishable at a glance from **VACANT** after R7's
   weight-class move. Same status word, different reason; the reason is the
   whole point.

## Token holds (hard)

Continue M5 / M6 / M7 / M8. Every one of these is a **must not**:

- **BAD is M6's medical hold.** A blocked belt is not an injury and not a bug.
- **AMBER is a recoverable warning.** A rule that worked is not a warning.
- **SODIUM is M7's champion, GOLD is M5's verdict.** Neither may mark a bout
  the belt did not follow — that would say the opposite of what happened.
- **No red fill, no alarm plate, no "STRIPPED" banner.** R42 shipped no
  stripping ceremony, no press cycle and no commission hearing; the belt's
  state changed and that is all. Art that implies a tribunal is inventing one.
- The facility is a **gym**, never a "camp".

M8 solved a very close problem one week ago — candour without alarm, at
ledger-row size — and its ICE / LINK reasoning is the nearest precedent. Use
it or beat it, but say which and why.

## What to deliver

- Spec: `research/M9_THE_SCALE_ON_THE_BELT.md`, with the token map
  verified against `Godot/scripts/UITokens.gd` and a written reason per fill,
  in M8's format.
- Boards: `DesignLibrary/screens/belt_scale/m9_*` (new folder), 1920×1080,
  code-drawable from UITokens. Cover at minimum: the mark family at row size
  with rejects; a schedule row carrying each of the four states; a division
  overview row showing vacant-on-the-scale beside an ordinary vacancy; and a
  drill-in that says *why* the belt did not move without a paragraph.
- The rejects page. M8's and M7's rejects pages are why those packs landed
  clean; say what you refused and what it would have taught.

## Out of scope

- No `.gd`, no `.tscn`, no `HANDOFF.md`, no `Godot/assets/data/` edits.
  **Claude writes your HANDOFF block after the land** — do not edit that file.
- No runtime bitmap import; boards are direction, not assets.
- Do not reopen M7's belt marks, K23's placement ruling (RANKINGS · CHAMPIONS,
  no new rail), or R42's rule itself. You are adding the state those three
  left without a face.
- No new belt rail, no dual-champion UI, no weigh-in screen — the scale's own
  surface is not this task.

## Done

Push your deliverables only (spec + boards). Message Claude when they land;
Claude writes the HANDOFF block and marks the task done.

## Owned files

<!-- Backfilled 2026-09-08. This file predates the owned-files gate, so `done --task` found nothing to check and passed vacuously. Every path below comes from this task file's own parse-gate command, test command, build sections and shipped deliverables - none was invented. -->

```
research/M9_THE_SCALE_ON_THE_BELT.md
Godot/scripts/UITokens.gd
```
