# TASK U48 — CURSOR — THE DEFENCE HAPPENS AND NOBODY SEES IT

Model: cursor-agent, **medium** effort. Owner: cursor.

**Tier: ONE NEW TOOL in `Godot/tools/`, plus the report. No `.gd` in `scripts/`
may be edited, and no test.** Parse gate the tool, then run it. **DO NOT RUN THE
SUITE** — twenty minutes, and a new `tools/` harness cannot break a test.

## Why this exists, and it is a finding nobody was looking for

R102 was a whole stage built on an operator ruling: **a dodge is the DEFENDER's
ability and a miss is the ATTACKER's inability, and they are two different
things.** It put the defender's own chosen guard into the exchange, read the 54
`defense`/`adaptation` catalogue nodes R101 had left unread, and measured muay
thai slipping **11.1%** of built impacts while boxing blocked the reverse.

**Q46 has just measured what reaches the screen, and it is 0.3%.**

| | built impacts (R102) | shown beats (Q46) |
|---|---|---|
| muay thai slip | **11.1%** | **0.3%** |
| muay thai block | 1.6% | **0.0%** |
| boxing slip | ~0% | 0.0% |
| boxing block | higher | **0.3%** |
| `block` + `slip` pooled | — | **0.3% of shown beats** |

And Q46 names the mechanism rather than guessing it: **`FightBeatAdapter._choose`
ranks candidates `knockdown > shocked > highest wear`, and a blocked or slipped
blow carries less wear by construction, so it loses almost every window it is in.**
The presenter drops ~92% of impacts and it selects for DAMAGE.

**So the defensive half of the fight happens, is scored, is in the log — and is
not in the broadcast.** That is not a bug in R102 and it is not a bug in the
adapter; each does exactly what it was asked to. It is a **design question that
nobody has been given the numbers to answer**, and this task gets them.

## THE QUESTION IS THE OPERATOR'S. THE NUMBERS ARE YOURS.

**You are not authorised to change `_choose`, or any other script.** The decision
— whether a broadcast should show the moment a man slips a punch, and at what
cost to showing the moment he lands one — belongs to the operator. Your job is to
make that decision cheap by measuring the alternatives side by side.

## What to build

**`Godot/tools/measure_choose_rules.gd`** — a new `extends SceneTree` harness.
Model it on `Godot/tools/measure_receiver_demand.gd` (Q46's, read it whole) and
`Godot/tools/measure_shown_techniques.gd` (Q45's).

**Do NOT edit `FightBeatAdapter`.** Instead: drive the fight the way those two
harnesses already do, capture **the full candidate list for every beat window**,
and then apply each selection rule below to those SAME captured windows. One fight
per seed, four rules scored against it — so the comparison is on identical
candidates and no rule gets a luckier fight than another.

If the candidate list is not reachable without touching the adapter, **say so and
stop** — that is a finding about the seam, and an honest report of it beats an
invented workaround. Do not reimplement the windowing: a filter you write yourself
measures your filter (Q45's trap, stated in its own task file).

### The four rules to score

1. **`current`** — `knockdown > shocked > highest wear`. The baseline. Your numbers
   for it must reproduce Q46's to within rounding; if they do not, **stop and
   report the disagreement** rather than proceeding on a harness that does not
   agree with the one already on master.
2. **`defence_eligible`** — identical, except a window whose candidates include a
   `blocked` or `slipped` impact presents that one instead. The maximal version.
3. **`alternating`** — `current`, except every Nth window that CONTAINS a
   defensive candidate presents it. Report N = 2 and N = 4.
4. **`wear_blind`** — drop the wear tiebreak entirely; keep `knockdown > shocked`,
   then take the FIRST candidate in the window. This is the control: it says how
   much of the current mix is the wear rule specifically, rather than the drop.

### What to report, per rule, per ruleset (`boxing`, `mma`, `kickboxing`, `muay_thai`), 40 bouts

- The six contact words as counts and as **shares of shown beats**, with the
  denominator named on every line.
- `block` / `slip` / `react_*` / `knockdown` / `idle` receiver-role mix — the
  Q46 columns, so the two documents are one column of the same quantity.
- **WHAT IS LOST.** This is the cost side and it is the half a tidy answer will
  skip: under each rule, how many `clean` impacts, knockdowns and significant
  strikes STOP being shown versus `current`? A rule that shows every slip by
  dropping a knockdown is worse and the table must make that visible.
- Bout length and the count of shown beats per bout, to confirm no rule changes
  how MANY beats there are — only which impact each window presents.

## THE THING THAT MUST NOT MOVE

**NO RULE MAY CHANGE THE FIGHT.** You are re-ranking candidates inside windows
that already happened. The engine's RNG stream, the seeded outcomes, the scorecards
and the method of victory must be **byte-identical across all four rules on one
seed** — assert that in your own output and print it. If a rule changes who won,
the harness is driving the fight instead of reading it, and that is the defect.

R102 left the tree at **eight draws per built impact**. Your harness must not add
a draw: it draws no RNG at all.

## Owned files

- `Godot/tools/measure_choose_rules.gd` — NEW, yours alone.
- `research/U48_WHAT_THE_BROADCAST_REFUSES.md` — the four-way tables, the
  loss column, and a **recommendation with a reason**, addressed to the operator.

**DO NOT EDIT** anything in `Godot/scripts/`, anything in `Godot/tests/`, or
`HANDOFF.md`.

## Anchors — read these and nothing else

- `Godot/tools/measure_receiver_demand.gd` — Q46's. Read whole; it is your model
  and your baseline.
- `research/Q46_THE_RECEIVERS_DEMAND.md` — the finding this task answers.
- `Godot/scripts/FightBeatAdapter.gd` — `advance_beat`, `_choose`,
  `_first_where`, `_wear_total`, `BEAT_TICKS`, `LANDED_CONTACTS`. **READ-ONLY.**
- `Godot/scripts/FightStageDirector.gd:121-145` — `role_for_react`. Call it.

`Godot/scripts/GameState.gd` is ~13,000 lines and you do not need it — **never
open it whole**. `Godot/scripts/FightRealtime.gd` is 2,376 lines; read `sed -n`
windows only if you need them.

## Gate

```
python Godot/tools/check_scripts.py Godot/tools/measure_choose_rules.gd
```

then run it headless. **rc=0 IS NOT A PASS** — a GDScript runtime error leaves
rc=0, so read the output. Godot's `N RID allocations ... leaked at exit` and
`N resources still in use at exit` are teardown chatter, not failures.

## Report

Commit (explicit paths only, never `audio_exports/`), push **MASTER** — a branch
strands your mail where the inbox cannot see it — then one line via
`python Tools/agent_comms.py send --from cursor --to claude --subject U48-done`
carrying, for each of the four rules, `block+slip%` and `clean_lost`. Do not edit
`HANDOFF.md`. Check `git status -s` before staging.

## The two traps specific to this task

1. **A SHARE IS ONLY MEANINGFUL AGAINST THE RIGHT DENOMINATOR**, and this task has
   four rules producing four different shown-beat populations. "Slip rose to 9%"
   is meaningless without saying 9% of what, and comparing rule 2's share of ITS
   population against rule 1's share of ITS OWN is the error M19 made and the
   operator caught. **Name the denominator in the same sentence as every
   percentage**, and where two rules are compared, compare counts as well as
   shares.

2. **DO NOT TUNE TOWARD A NICER NUMBER.** R102's own lesson is that the tidy story
   was available and wrong: five of eleven pinned bouts became knockouts and the
   narrative was right there, until boxing's base rate on that very fixture was
   measured at 36.7% and the pins turned out to be a SELECTED sample. If
   `defence_eligible` costs three knockdowns a bout, **that is the answer** — write
   it down and recommend against it. A recommendation that hides its cost is worse
   than no recommendation.
