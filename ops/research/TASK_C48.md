# TASK C48 — THE RESULT THAT IS NOT A RESULT (codex)

Model: gpt-5.6-luna, effort **medium**, Fast off. One session. Research only —
**no `.gd`, no `.json`, no scene.**

## Why this exists

J3 **D8**: the game can split a decision (R38 ships UD / SD / MD) but it cannot
write a **No Contest** or a **technical decision**. `grep` shows both words
already exist in `Godot/assets/data/competition_rulesets_v2.json` and in no
script — the vocabulary was authored and nothing ever read it.

J3 D8's recommendation is already specific: accidental-foul NC before half the
scheduled rounds + 1 second, technical decision after (ABC Unified MMA);
Nevada `NAC 467.579` **may** flip a win or draw to NC on an anti-doping
violation, and the game must not auto-flip on every positive. This study turns
that into something buildable and finds every seam it would touch.

## What to answer

1. **The rule, cited.** The ABC Unified Rules text for accidental fouls, the
   half-way threshold, and what the scorecards do in each branch. The boxing
   equivalent where it differs. Mark UNKNOWN where a discipline publishes
   nothing.
2. **Who decides, and when.** Referee, commission, or a later appeal — and how
   long after the bout a result can be overturned. J3 D9 already covers the
   drug-testing overlay; do not rebuild it, cite it.
3. **What a No Contest does to everything downstream.** This is the half that
   needs your shell, and it is the real deliverable. An NC is not a win, not a
   loss and not a draw, and the game has code that assumes those are the only
   three. Audit and list, with `file:line`, every place that would need to
   learn a fourth answer:
   - the record itself (`wins` / `losses` / `draws` in `GameState.gd` and
     `WorldPopulation.gd`)
   - `Godot/scripts/FightRecordStats.gd`, `Godot/scripts/CareerEpilogue.gd`,
     `Godot/scripts/CareerArc.gd`, `Godot/scripts/Mileage.gd`
   - the belt: does an NC in a title bout move the belt? (It must not.)
   - rankings, P4P, and streak logic in `WorldPopulation.division_rankings`
   - `Godot/scripts/BoutRead.gd` and `Godot/scripts/PostFightRead.gd`
   - `Godot/scripts/RoundScoring.gd` / `Godot/scripts/JudgePanel.gd` — a
     technical decision is scored, an NC is not

   `GameState.gd` is **13,900+ lines — never open it whole.** Find the seams
   with `grep -n` on `"draws"`, `_apply_fight_result` and `method`, then read
   only the windows you hit.

4. **The cheapest honest first step.** Probably: the result TYPE exists and is
   recorded, every consumer is taught to skip it, and nothing generates one yet.
   Say so plainly if that is the answer, and name what generating one would
   cost separately.

## What to deliver

`research/C48_THE_RESULT_THAT_IS_NOT.md` in J3's shape — decisions page,
cited evidence with UNKNOWN kept, what the game does today, minimum change as a
build order — plus the `file:line` seam list, which is the part a build task
will be written from. And `research/C48_DIGEST.md`, short.

## Do NOT

- Do not edit any `.gd` or `.json`. Do not edit `HANDOFF.md`.
- Do not design the anti-doping program; J3 D9 owns it. Cite and move on.
- Do not read `HANDOFF.md`, `CURRENT_STATUS.md`, `HANDOFF_ARCHIVE.md` or any
  digest. Read this file, `research/J3_THE_DECISION_QUEUE.md`, and the
  code you audit.

## Owned files

```
research/C48_THE_RESULT_THAT_IS_NOT.md
research/C48_DIGEST.md
```

## Parse gate

None — this task owns no script.

## Test

None. Research task.

## The one trap

**A missing seam is worse than a missing citation here.** The build task after
this one will trust your list. If a record, a ranking or a career summary
silently counts an NC as a loss because you did not find it, the bug ships. Be
exhaustive on section 3 even at the cost of brevity elsewhere.
