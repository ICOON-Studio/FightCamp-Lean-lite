# TASK Q81 - QWEN - A SCRAMBLE THAT FAILS SHOULD NOT WIPE THE CHOKE

Model: qwen3-coder, **medium effort**. Owner: qwen. Launched `--yolo`, prompt on stdin.

**Test tier: A SCRIPT IS EDITED.** Parse gate, then the focused test, then the named
subsets below. NOT the full suite - that is Claude's, once, at integration.

## Owned files

- `Godot/scripts/FightSimulation.gd` - **3,560 lines. NEVER open it whole.** You edit ONE
  function in it. Read only the windows named below.
- `research/Q81_FAILED_SCRAMBLE_CARRY.md` - **NEW, yours alone.** The measured
  before/after.

Do NOT edit any test, any data file, `HANDOFF.md`, `AgentComms/roadmap.json`, or any other
script. Do NOT re-pin a test to make your change pass.

## Why this exists

S1f (1) landed on 2026-09-13 (`dff10389`): the man on top now resists the stand-up roll,
so the ground holds. Measured over 40 seeded bouts, stand-ups fell (MMA grappler 78 -> 56,
MMA muay-thai 64 -> 45, BJJ 54 -> 29) and submission LANDS rose sharply (74 -> 110 and
136 -> 206).

**And submission FINISHES did not move at all.** Zero in the MMA grappler-v-striker pair
and one in the muay-thai-v-jiu-jitsu pair, at every swept value of the new constant from
0.0 to 0.7. The reason is measurable and it is not the stand-up:

- The finish threshold is `SUBMISSION_BASE_THRESHOLD + defense * 0.35 + camp.sub_defense`.
  Against the MMA striker (defense 64) that is `55 + 22.4 = 77.4`.
- Peak accumulated pressure across all 40 bouts was **62.8**. It was never close.

`_resolve_escape_attempt` clears `actor["submission_attempt"] = null` AND the opponent's,
**whether or not the stand-up roll succeeded**. A landed escape wipes the accumulator even
when the man never got up. And S1f (1) made escapes LAND more often, not less
(124 -> 172), so more ground time now feeds more clearing. The choke resets every time he
squirms, so pressure can never reach the threshold.

This is Q75's option c, written up in `research/Q75_WHAT_RESISTS_A_STAND_UP.md`
under "Options". Read that section and nothing else in the file.

## Where things are (windows only)

- `Godot/scripts/FightSimulation.gd`:
  - `sed -n '2516,2570p'` - `_top_control_norm` and all of `_resolve_escape_attempt`,
    including its doc comment. **Line 2560 is `actor["submission_attempt"] = null` and
    line 2564 is the opponent's.** These are the two lines this task is about.
  - `sed -n '2178,2195p'` - the submission accumulator and its threshold, and the call site
    that reaches `_resolve_escape_attempt` with `from_catalogue`.
  - `sed -n '160,190p'` - `SUBMISSION_BASE_THRESHOLD`, `SUBMISSION_SWITCH_CARRY` with the
    measurement its comment carries, and `ESCAPE_TOP_CONTROL` from S1f (1).
- `research/Q75_WHAT_RESISTS_A_STAND_UP.md` - the "Options" section ONLY.

## The contract

A stand-up that SUCCEEDS still clears both attempts - he is off the floor, the choke is
gone, and the phase flips to STANDING. That behaviour does not change.

A stand-up that **FAILS** must no longer wipe the attacker's accumulator. Carry a share of
it forward instead, exactly as a technique switch already does:

```gdscript
const FAILED_ESCAPE_CARRY := 0.7
```

Name it, put it beside `SUBMISSION_SWITCH_CARRY` (line 173), and give it a comment that
carries YOUR measured numbers the way `SUBMISSION_SWITCH_CARRY`'s comment carries its own.
Do not reuse `SUBMISSION_SWITCH_CARRY` itself - these are two different facts and they must
be free to move apart.

Be precise about WHOSE attempt is whose. The actor is the man on the bottom escaping; the
attacker whose pressure must survive is the OPPONENT. Do not carry the escaper's own
attempt against a man who just stuffed him and do not swap the two.

**GDScript traps that cost a cycle here:** `var x := <call>` fails when the call returns
Variant - write `var n: float = ...`, and `attempt.get("strength", 0.0)` on an untyped
dictionary IS Variant. Reusing a variable name inside one function is a parse error even
across separate `if` blocks. `%` inside a format string must be `%%`.

## Gate - in this order, and watch each one FAIL before you trust it

1. **Parse gate, always first.** A parse error HANGS a headless test for its full 600 s
   timeout instead of failing it:
   `python Godot/tools/check_scripts.py Godot/scripts/FightSimulation.gd`
2. **Sweep the new constant.** `FAILED_ESCAPE_CARRY` at 0.0 (which must reproduce today's
   numbers exactly - that is your tripwire), 0.5, 0.7, 0.85, 1.0. **Run the instrument on
   the UNCHANGED tree FIRST.**
   `<godot> --headless --path Godot --script tools/measure_ground_seats.gd`
   Put the five-row table in `Q81_FAILED_SCRAMBLE_CARRY.md`, reporting for every matchup:
   submission LANDS, **submission FINISHES (the `methods` line)**, and `peak_pressure`.
3. **Focused tests:** `python Godot/tools/run_tests.py --only grapple --jobs 4` (8 tests)
   and `--only fight_simulation --jobs 4`.
4. **Named subsets, all of them:** `grapple`, `judge`, `ring`, `technique`, `smoke`,
   `fight_simulation`, `fight_beat_defence`, `fight_stamina`, `fight_log`.
   **Ceiling: `ring` and `technique` may each carry ONE failure and no more.**
   `fight_scoring_test` (judo uchi-mata ippon, `19 >= 22`) and
   `fight_stage_technique_fidelity_test` are PRE-EXISTING - both fail identically on an
   unmodified HEAD, verified 2026-09-13. Every other subset must be `fails=0`. Land fewer
   failures than that and you should say so and push - do not hold a better result back.
5. **Do NOT run `--only fight`.** It matches 67 tests by substring, including
   `fight_metres_test`, which alone burns its full 600 s timeout.

## The trap specific to this task

**This change can run away.** Carry too much and every ground exchange becomes a finish:
`SUBMISSION_SWITCH_CARRY`'s own comment records that going from 0.7 to 1.0 took BJJ from 5
finishes in 40 bouts to 26. You are adding a SECOND source of carried pressure on top of
that one, so the two compound - a bout where a man attempts an escape every exchange now
never loses pressure at all.

So judge this on the FINISH count per ruleset, not on peak pressure, and say plainly in
your write-up if a value makes any matchup finish more than it should. **Sambo already
finishes 21 of 40 and must not go higher** - it has no escape node, so if sambo moves at
all, your change is reaching something it should not. Judo must not move either: its ground
is 100% engine fallback and S1f (1) is deliberately gated off it.

## When you are done

Commit with paths on the commit line (`git add -- <file> <file>`), push, write your digest,
send one line with `python Tools/agent_comms.py send`. Do NOT edit `HANDOFF.md`.
`git show --stat HEAD` before you push: your own commits have twice swept another agent's
pre-staged mail file into the tree.
