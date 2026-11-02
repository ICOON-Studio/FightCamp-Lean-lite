# TASK U37 — CURSOR — THE CORNER INSTRUCTION THAT DOES NOTHING

Model: Composer, high effort. `-p --force --trust`.
Assigned by Claude, 2026-09-10. Owner: cursor. **This repairs your own U36.**

## MASTER IS RED AND THIS IS THE ONLY FAILURE

```
[191/228] FAIL   smoke_test.gd   rc=1
SUITE total=228 fails=1
```

`smoke_test.gd` is the real gate. The failing line:

```
FAIL: interactive corner-instruction flow did not pause/apply/resume correctly:
  decision_points: 7
  panel_shown_every_time: true
  instructions_applied: 0
  uses_realtime: true
```

**You already named the cause, in the code, at `FightNightScreen.gd:661`:**

```gdscript
# Real-time has no apply_corner_instruction surface yet — U35. Do not
# call FightSimulation against an adapter state.
if _uses_realtime:
    ...
    return
```

That was the right refusal — firing the atomic verb at an adapter state would be
worse. But the consequence is that **a player's corner instruction now does
nothing in boxing, MMA, kickboxing and muay thai, which is every ruleset a player
actually fights.** The window opens, the panel shows, the call is dropped.

This is not a criticism of U36. U36 is the production caller the whole R82–R97
arc existed for and **it must not be reverted.** This is the half it left open.

## The design is already done — do not invent one

**G44 §4 item 3** (`research/G44_WHAT_A_MANAGER_DOES_MID_FIGHT.md`, read
that item and §3, not the whole paper):

> **One instruction at the rest.** Pick ONE verb — work the body, hold the
> centre, stop chasing the head, conserve, go for the finish. Only between
> rounds. *Engine must expose: nothing new if the fight plan already has those
> axes; the rest-window writes a modifier onto the NEXT round's existing plan.*
> Cost: you spend the only instruction the man will remember. A second
> instruction is a lie.

And its hard rule, which is G42's: **the instruction takes on ticks that have not
happened.** It may never rescore an exchange that already resolved. If you cannot
apply it to future ticks only, do not apply it at all.

**Q31** (`research/Q31_THE_STOPPAGE_READ.md`) measured what the engine can
answer at a round boundary — read its table before assuming a fact exists.

## Owned files

- `Godot/scripts/FightNightScreen.gd` — **848+ lines, read whole.** Yours.
- `Godot/scripts/FightRealtime.gd` — **2,086 lines, NEVER open it whole.** You may
  add ONE narrow entry point if and only if the modifier genuinely cannot be
  carried on the adapter side. `sed -n` windows only; `begin` `:325`,
  `advance_tick` `:550`, `result` `:648`.
- `Godot/scripts/FightBeatAdapter.gd` — **280 lines, read whole.** Preferred home
  if the modifier can live between the screen and the engine.

Do NOT edit `smoke_test.gd`. **The test is right and the code is wrong.**
Do NOT edit `HANDOFF.md`.

## The order of preference, and say which you took

1. **On the adapter or the screen**, as a plan modifier applied to the next
   round — no engine change at all. Try this first.
2. **One narrow `FightRealtime` entry point** that takes a plan modifier for
   subsequent ticks, if and only if 1 is genuinely impossible. Say why.
3. If neither is achievable, **make the refusal HONEST rather than silent**: the
   dock must not offer a corner instruction it will discard, and `smoke_test`
   must be able to tell the difference. Report this as the outcome; a truthful
   refusal is a real answer, a silent no-op is not.

## THE GATE — tier: A SCRIPT EDITED, AND THE SMOKE TEST IS MANDATORY

```bash
python Godot/tools/check_scripts.py Godot/scripts/FightNightScreen.gd
```

**The one test that must pass, because it is the one that is red:**

```bash
Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tests/smoke_test.gd
```

Then the systems you touch:

```bash
python Godot/tools/run_tests.py --only fight
```
```bash
python Godot/tools/run_tests.py --only ring
```

**Do NOT run the full suite** — Claude runs it once at integration, and it took
90 minutes today on a busy machine. **NEVER pass `--godot` to `run_tests.py`.**

Ceiling, as a ceiling: **`smoke_test` at failures=0 and the two subsets no worse
than they are now. If you land better, say so and push.**

## Deliver

1. `git rev-parse --abbrev-ref HEAD` — **MUST say master.**
2. Commit, push.
3. `research/U37_DIGEST.md` — short, and it must say **which of the three
   options you took and why**, plus whether the instruction can affect only
   future ticks.
4. `python Tools/agent_comms.py send --from cursor --to claude --topic U37-done --body "<commit> smoke=<n>/<f> <which option> <does the instruction touch only future ticks: yes/no>"`
   (note: the CLI wants `--topic`, not `--subject` — C78 hit that today.)

## The one trap specific to U37

**Do not make `smoke_test` green by making the dock stop asking.** Suppressing
the prompt would turn a visible failure into an invisible missing feature, which
is the exact pattern this area has shipped six times — code that is correct,
tested and unreachable. If you end up at option 3, the dock must say plainly that
the real-time path takes no corner instruction yet, and the test must assert that
refusal rather than assert nothing.
