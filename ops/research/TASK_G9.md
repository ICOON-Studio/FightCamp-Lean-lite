# TASK G9 — CAREER EPILOGUE: WHAT A FINISHED CAREER SAYS ABOUT ITSELF (Grok)

**Status: COMPLETE 2026-09-07** (commit `e98a06f`). Spliced and verified by
Claude: parse gate 2/2, own test green, zero preloads, contract honoured. See
Grok's block in `HANDOFF.md`.

Part of THE YEARS. A pure module and its test — nothing else. Nothing blocks on this and it blocks nothing: R51 and
C34 can land before or after you.

Model: mid tier, effort medium, Fast off.

Grok has no Windows shell, so `rtk` does not apply — use raw git. Read this
file and the `## GROK START HERE` block in `HANDOFF.md`. Nothing else.

## Why this exists

THE YEARS gives careers an end: fighters age, decline and retire. When one
ends, the game has to be able to SAY something true about it — and today it
can only say the record. `FightRecordStats.summarize()` already computes the
record, the finish split, the streaks, the form, the titles and the purse.
What nothing computes is the SHAPE of a career: when it started, when it
peaked, what its best night was, and how long it lasted.

## Owned files

- `Godot/scripts/CareerEpilogue.gd` — **new**.
- `Godot/tests/career_epilogue_test.gd` — new.

**Touch nothing else.** Not `GameState.gd`, not `UIKit.gd`, not
`FightRecordStats.gd`, not `HANDOFF.md`. Claude splices your push and runs
the suite; you never poll for it.

## The contract

```gdscript
extends RefCounted

## rows: the athlete's fight log, exactly what GameState.get_fight_log(id)
## returns and what FightRecordStats.summarize(rows) consumes.
## athlete: the athlete dictionary (id, name, age, primary_discipline,
## record, status, ...).
static func build(athlete: Dictionary, rows: Array, career_week: int) -> Dictionary
```

Returns, and invents nothing:

| key | meaning |
| --- | --- |
| `debut_week`, `final_week` | first and last bout weeks in the log; `0` when the log is empty |
| `weeks_active` | `final_week - debut_week`, never negative |
| `years_active` | `weeks_active` in whole years (52-week years), floored |
| `peak_year` | the 52-week window with the most wins; `{"index": int, "wins": int, "from_week": int, "to_week": int}` |
| `defining_win` | ONE row: the best win in the log, and `{}` when there is none |
| `why_defining` | the reason that win was chosen, in words: `"TITLE"`, `"BEST PAID"`, `"FINISH"`, `"ONLY WIN"` |
| `epitaph` | one authored line chosen from the table below |
| `unfinished` | `true` while the athlete is still active — an epilogue for a live career is a PREVIEW and must say so |

## Settled

- **Compose, never recompute — and never `preload`.** The record, the finish
  split, the streaks, the form, the titles and the purse totals are
  `FightRecordStats`' job and it is already correct; do not reimplement one
  of them. But **`CareerEpilogue.gd` must not preload or reference
  `FightRecordStats`**: if you need one of its figures, take it as an
  optional argument the caller passes in —
  `build(athlete, rows, career_week, record_stats := {})` — and treat an
  empty dictionary as "not supplied" rather than computing it yourself. A
  module with zero preloads is testable in a bare sandbox, which is the
  environment you are actually in.
- **Pure and stateless**: statics only, no node access, no autoload
  identifier, no RNG, no `preload` of a scene. Same shape as
  `Godot/scripts/Sanctioning.gd` — read that file as the house pattern.
- **Honest empties.** A fighter with no logged bout returns a real epilogue
  with zeroes and an epitaph that says so, never `{}` and never a blank.
- **The epitaph is chosen, not generated.** A small authored table in the
  file (roughly six to ten lines), picked by the career's own facts — a
  champion, a gatekeeper, a prospect who never arrived, a journeyman who
  never stopped. No string-building of prose from fragments; a sentence
  assembled at runtime always reads assembled.
- No new UIKit factory and no new token — you draw nothing at all this task.

## Test — you can run this WITHOUT the repo

**Do not try to clone FightCamp.** It is private, its `.git` is 1.7 GB and
your sandbox has no token. You do not need it: a zero-preload module runs in
a throwaway Godot project holding nothing but your two files. The recipe is
`research/SANDBOX_MODULE_TESTING.md` — read it once. In short:

```bash
mkdir -p ~/kit/scripts ~/kit/tests
cd ~/kit
printf 'config_version=5\n\n[application]\n\nconfig/name="kit"\nconfig/features=PackedStringArray("4.7", "GL Compatibility")\n' > project.godot
# put CareerEpilogue.gd in scripts/ and career_epilogue_test.gd in tests/
godot --headless --path ~/kit --script tests/career_epilogue_test.gd
```

`res://scripts/CareerEpilogue.gd` resolves there exactly as it will in the
real project. If your Godot install has vanished with the container, that is
expected — see the same file.

The test builds its OWN fight-log fixtures as plain dictionaries — it must
not need a career, a save or DevJump. Prove: the empty log, a one-bout log,
a long log whose peak year is NOT the last year, a title win beating a
better-paid win for `defining_win`, and `unfinished` true for a live career.

**Claude runs the parse gate and the full 149-file suite after you push, and
reports the result.** That is the standing arrangement — you are not expected
to run it, and you never poll for it.

## Done

Push `master` with your two files and nothing else. Claude writes your
`HANDOFF.md` block and runs the suite. Your claim in `## GROK START HERE` is
at most 20 lines.
