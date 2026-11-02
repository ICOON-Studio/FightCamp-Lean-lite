# TASK Q28 — QWEN — `half` HAS NO WRITER, AND A SWEEP THAT CANNOT HAPPEN

**Model: Qwen default, `--yolo`, medium effort.** Owner: Qwen.
Assigned 2026-09-10 by Claude.

Read this file and nothing else. Do NOT read `HANDOFF.md`,
`CURRENT_STATUS.md`, `HANDOFF_ARCHIVE.md` or any digest, and do not explore to
"get oriented". Every anchor you need is below.

## The defect, verified before you were assigned

`half` (half guard) is in the seat vocabulary at `GrappleSeat.gd:7`, it is read
in four places, and **nothing in the engine ever writes it.** Grep it yourself
before you start — that grep is the task.

Two consequences, and the second is the expensive one:

1. `GrappleResolve.takedown_resolve` lands **every** successful takedown in
   exactly two seats — `GrappleResolve.gd:53`:

       var to_seat: String = "side" if grade == 4 else "guard"

   So a grade-2 and a grade-3 takedown are the same landing, and half guard is
   never reached from standing.

2. Because nothing writes `half`, the **entire bottom-man SWEEP branch at
   `FightRealtime.gd:1828` can never run.** Read `FightRealtime.gd:1815-1834`:
   the file authors three different outcomes for the bottom man — from guard he
   STANDS, from half he SWEEPS (comes up on top in guard, 2 points behind a
   60-tick gate, `SWEEP_HOLD_TICKS` at `:183`), from under side/mount/back he
   ESCAPES. The middle one is dead. It is correct, it is commented, it is
   behind a green suite, and it has never executed.

**That is this project's named failure mode** — code that is correct, tested,
and can never run. Three of them were found in one day in September and every
one survived a green suite because every test checked a function in isolation
and none asked whether the pieces could line up. Your test must therefore
assert that the sweep **OCCURS**, not that it is permitted.

## What to build

### 1. Give `half` a writer

In `GrappleResolve.takedown_resolve` (`GrappleResolve.gd:44-54`), the landing
seat currently reads only `grade == 4`. `_takedown_grade` (`:134`) returns a
graded result and the middle of that range is being thrown away. Make a
takedown able to land in `half`, and make which seat it lands in a function of
the grade the module already computed — not of a new roll. **The four draws per
built grapple event are asserted elsewhere; do not add a fifth.**

Say in your digest which grade maps to which seat and why. `side` for the best
takedown and `guard` for the weakest are already the endpoints; `half` belongs
between them, and that is an ARITHMETIC choice this engine is entitled to make.
Label it AUTHORED in the code comment, the way `FightRealtime.gd:1815` labels
its own three outcomes — we have no published source that says a grade-3
takedown lands in half guard, and pretending otherwise is worse than saying so.

### 2. Verify or refute the hold-tick report at `FightRealtime.gd:1684`

A previous study reported a hold-tick bug at that line and **nobody has checked
it**. Read `FightRealtime.gd:1670-1700` — the clinch escape path calls
`_move_seat(..., "clinch_break", {}, 0)` with a zero gate. Decide whether that
zero is a defect or is correct because a break scores nothing and so has
nothing to gate.

**Report the answer either way.** "I read it and it is correct, here is why" is
a full delivery of this half. Do not change it unless you can say what breaks
if you do not.

## Owned files

You own these and nothing else:

- `Godot/scripts/GrappleResolve.gd` (149 lines — small, read it whole)
- `Godot/tests/grapple_resolve_test.gd`
- `Godot/tests/fight_realtime_test.gd` (large — read only the windows you need)
- `research/Q28_DIGEST.md` (new)

**`FightRealtime.gd` is 1,922 lines and you are READING it, not editing it** —
`sed -n '1815,1834p'` and `sed -n '1670,1700p'` are the two windows. If you
conclude the sweep needs an edit inside `FightRealtime.gd` to fire, STOP and
say so in your mail instead: that is a second task, not this one.

Do not touch `GrappleSeat.gd`, `GrappleAdapter.gd`, `RealtimeRoundStats.gd` or
any pin file. Do not edit `HANDOFF.md` — Claude writes your block.

## Test tier — FOCUSED, not the full suite

Claude runs the full suite once at integration. Yours:

```
python Godot/tools/check_scripts.py Godot/scripts/GrappleResolve.gd Godot/tests/grapple_resolve_test.gd Godot/tests/fight_realtime_test.gd
python Godot/tools/run_tests.py --only grapple
python Godot/tools/run_tests.py --only realtime
python Godot/tools/run_tests.py --only judge_panel
```

**Never pass `--godot`.** The runner already defaults to this project's engine;
overriding it with the chocolatey binary makes every boot report `engine-error`
and the whole run is then worthless. Ceiling: `fails=0` or better on each. If
one comes back lower than you expect, SAY SO and push anyway — never trap an
over-delivery, and never re-pin a card to make it green.

## The assertion that decides whether this task was worth doing

Add a test that **runs a real seeded fight and proves the seat `half` is
actually occupied**, and a second that proves the sweep at `FightRealtime.gd:1828`
**fires at least once** across a set of seeds. Search seeds and pin the ones
that work, recording the search in the test the way the stoppage seeds are
recorded. A test that only asserts `takedown_resolve` *can return* `half` is
exactly the test that let this bug live — it checks a function in isolation and
never asks whether the pieces line up.

If after a genuine seed search the sweep still cannot fire, that is a REAL
finding and is worth more than a green test: report it with the seeds you tried.

## Land it

1. `git status -s` FIRST — shared checkout, other agents' files are in it.
   Stage explicit paths only. Never `git add -A`, never `git stash`,
   `reset --hard`, `checkout .` or `clean`.
2. Commit, push `master`, trailer `Co-Authored-By: Qwen Code <noreply@qwen.ai>`.
3. Write `research/Q28_DIGEST.md`: the grade→seat map you chose and why,
   the seeds where `half` is occupied and the sweep fires, the counts before and
   after, and your verdict on `:1684`.
4. One line of mail:

```
python Tools/agent_comms.py send --from qwen --to claude --topic Q28-done --body "<commit> grapple <n>/<m>, realtime <n>/<m>, judge_panel <n>/<m> — grade→seat map, seeds where half is occupied and the sweep fires, verdict on :1684"
```

## The trap

**Do not widen `half` into everything.** The sweep is the bottom man's best
outcome and half guard is a real position, not a synonym for guard. If you make
half the common landing you will move every grapple number in the engine and
the pinned judge cards will shift — and a shifted card is never to be re-pinned
to make a suite green. Keep it the middle case, run `--only judge_panel`, and
if a card moves anyway, report the movement rather than absorbing it.
