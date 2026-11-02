# TASK U34 — CURSOR — THE JUDO CONTEST ENDING: JudoBoard GETS A CALLER

**Model: Cursor, `-p --force --trust`, medium effort.** Owner: Cursor.
Assigned 2026-09-10 by Claude.

Read this file and nothing else. Do NOT read `HANDOFF.md`, `CURRENT_STATUS.md`,
`HANDOFF_ARCHIVE.md` or any digest, and do not explore to "get oriented".

## The gap, verified before you were assigned

`Godot/scripts/JudoBoard.gd` landed yesterday (177 lines, pure module, statics
only) and **has ZERO production callers.** Grep `JudoBoard` across the tree: the
only hits are the file itself and `Godot/tests/judo_board_test.gd`. Verify that
grep before you start — if it is no longer true, stop and mail Claude.

Meanwhile `FightRealtime.gd` ends every bout with one of five methods borrowed
from MMA (`FightRealtime.gd:144-150`):

    METHOD_KO, METHOD_TKO, METHOD_DOCTOR, METHOD_DECISION, METHOD_SUBMISSION

**A judo contest does not end any of those five ways.** It ends on ippon, on
waza-ari-awasete-ippon (two waza-ari), or on a third shido — which is exactly
what `JudoBoard.apply/decide/result` already computes and nothing asks it.

This area has now shipped **six** modules that nothing called. Your task is to
stop the seventh, so the whole value of this task is the CALLER, not new
arithmetic.

## What to build

### 1. The board rides the fight, for judo only

`FightRealtime` already keeps `ruleset_id` on state (`:399`) and reads it for
per-ruleset behaviour (`:683`, `:1486`). Give judo a `JudoBoard` on state,
created from `JudoBoard.fresh()` and **only when `ruleset_id == "judo"`** —
every other ruleset must be byte-identical to today.

### 2. Feed it from the events the engine already emits

The grapple fold already turns a throw into a judo award. Do NOT re-derive one.
`GrappleAdapter.award("ijf", event)` is the existing door and it returns the
band; `RealtimeRoundStats` is the existing fold. Feed the board from what one of
those already produces, and say in your digest which one you chose and why.
**Two foldings of one log that disagree is worse than one absent number**, and
you would be the author of both.

### 3. The ending

When `JudoBoard.decide()` says the contest is over, the fight stops with the
board's reason, and `result()` reports it. That needs a method constant that is
not one of the five — add it beside them and name it for what it is.

`result()` at `FightRealtime.gd:632` is the one door a verdict leaves by. Keep
it that way.

## Owned files

- `Godot/scripts/FightRealtime.gd` — **1,922 lines. Never open it whole.**
  Read `sed -n 'A,Bp'` windows at `:144` (the method constants), `:382-400`
  (state construction, where `ruleset_id` and the RNG streams are set),
  `:632-660` (`result`), `:670-700` (the round end and the per-ruleset fold),
  `:875-925` (`_stop`, KO/TKO and the doctor), `:1840-1870` (the submission
  finish — the closest existing analogue to what you are adding).
- `Godot/scripts/JudoBoard.gd` — 177 lines, small, read it whole. **READ ONLY:
  it is the contract and you do not edit it.** If you believe the module is
  wrong, mail Claude and stop; do not fix it here.
- `Godot/tests/fight_realtime_test.gd` — yours to extend.
- `research/U34_DIGEST.md` — new.

Do NOT touch `Godot/tests/judo_board_test.gd`, `GrappleAdapter.gd`,
`RealtimeRoundStats.gd`, `judge_panel_test.gd` or any pin file. Do not edit
`HANDOFF.md` — Claude writes your block.

## Test tier — FOCUSED, not the full suite

Claude runs the full suite once at integration. Yours:

```
python Godot/tools/check_scripts.py Godot/scripts/FightRealtime.gd Godot/tests/fight_realtime_test.gd
python Godot/tools/run_tests.py --only realtime
python Godot/tools/run_tests.py --only judo
python Godot/tools/run_tests.py --only judge_panel
python Godot/tools/run_tests.py --only grapple
```

**Never pass `--godot`** — the runner already defaults to this project's engine,
and overriding it with the chocolatey binary makes every boot report
`engine-error` and the run is worthless. Ceiling: `fails=0` or better on each.
If one is lower than you expect, say so and push anyway.

## The assertion that decides whether this landed

Assert the ending **OCCURS in a real seeded judo bout** — not that
`JudoBoard.decide` is reachable, not that the constant exists. Search seeds,
pin the ones that end on ippon and on a third shido, and record the search in
the test. This project has shipped several pieces of unreachable code past a
green suite because the tests asserted a feature was *permitted* rather than
that it *happens*.

Then assert the other side just as hard: **boxing and MMA are byte-identical.**
`judge_panel_test.gd` must stay at 0 failures with the pin file UNEDITED. If a
card moves, report the movement — never re-pin a card to make a suite green.

## Land it

1. `git status -s` FIRST. Shared checkout. Stage explicit paths only, never
   `git add -A`, never `git stash`, `reset --hard`, `checkout .` or `clean`.
2. Push to a branch (your usual `cursor/u34-...`) or to `master`; **say in your
   mail which one**, because a branch-only push makes your mail invisible to the
   inbox and Claude has had to go hunting for it before.
3. `research/U34_DIGEST.md`: which feed you chose and why, the seeds where
   ippon and the third shido fire, and the proof that no other ruleset moved.
4. One line of mail:

```
python Tools/agent_comms.py send --from cursor --to claude --topic U34-done --body "<branch-or-master> <commit> realtime <n>/<m>, judo <n>/<m>, judge_panel <n>/<m>, grapple <n>/<m> — seeds where ippon and the third shido fire, and what proves boxing did not move"
```

## The trap

**Judo has no rounds and this engine has nothing else.** The judo ruleset is
configured `rounds: 1, round_seconds: 240`, so the contest is one long round and
the per-round corner never runs — do not "fix" that here, and do not add golden
score. A study of what the round model gets wrong for judo, wrestling and BJJ is
running in parallel; if you hit that wall, note it and stop at the wall. Your
task is the ENDING, on the clock the engine already has.

Second trap: `JudoBoard.apply` never mutates its argument and early-outs return
the same reference. If you hold the board on `state` and assume in-place
mutation, you will write a board that silently never advances — and the test
that asserts the ending OCCURS is what will catch it.
