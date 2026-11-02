# TASK Q31 — QWEN — CAN THE ENGINE ANSWER "SHOULD I PULL HIM OUT?"

Model: qwen3-coder-plus, medium effort. `qwen --yolo` from the repo root.
Assigned by Claude, 2026-09-10. Owner: qwen.

## Why this exists now

G44 landed today (`research/G44_WHAT_A_MANAGER_DOES_MID_FIGHT.md` — read
§4 item 1 and §2's stoppage section, not the whole paper). It surveyed 124
sources on what a fight-management player should be doing during a live fight and
came back with one call:

> **Build "ask for the stoppage" first** — it is the only mid-round verb a real
> chief second is allowed to use that changes the result, it reads facts the
> engine already emits, it costs the fight, and it does not rewrite the seed.

G44 claims the engine already has what that verb needs. **Nobody has checked.**
This task checks, before anyone writes a line of the verb — because the last six
things this area built were correct, tested, and could never run.

## The question

**Can `FightRealtime` answer, at any tick, the question a corner actually asks:
is my man still able to defend himself?**

Not "is he losing". Not "is he hurt right now". The corner's read is cumulative
and it is about capacity.

## Owned files

- `research/Q31_THE_STOPPAGE_READ.md` — **NEW, yours, the deliverable.**
- `Godot/tools/probe_stoppage.gd` — **NEW, yours**, a throwaway measuring tool.
  It is a tool, not a test; it prints numbers.

**Read but do not edit:**

- `Godot/scripts/FightRealtime.gd` — **2,086 lines, never open it whole.**
  `sed -n` windows only. Anchors: `begin` `:325`, `advance_tick` `:550`,
  `result` `:648`, the impact event's full shape at `:1469-1502`,
  `body_condition_of` `:524`, `_maybe_doctor_stoppage` (grep for it).
- `Godot/scripts/FightBeatAdapter.gd` — **280 lines, read it whole.** It is the
  easiest way to run a bout: `begin` / `advance_beat` / `state_view` / `result`.
  Its `state_view()` already hands you `fighters[side].body_condition`.
- `Godot/scripts/ImpactModel.gd` and `Godot/scripts/FightTrauma.gd` — small.
- `Godot/tests/fight_beat_adapter_test.gd` — for the fighter fixtures and how to
  build a seeded bout. Copy its `_boxer()` / `_wrestler()` / `_ruleset()`.

## What to measure

Run a decent sample of seeded bouts (a few hundred; a 3×5 costs 283 ms, so this
is cheap — R96 measured it) and answer with NUMBERS, not opinions:

1. **What the engine can say about a man's state at an arbitrary tick.**
   Enumerate it: the six `body_condition` regions, the stamina/tank read,
   `shocked`, `knockdown` and `flash_knockdown` history, the trauma pips by site
   and kind, the round, the scorecards so far. For each, say whether it is
   available **at a tick** or only **at a round boundary**, because the verb is
   supposed to be available mid-round.
2. **Is there a cumulative "he is finished" signal, or only instantaneous ones?**
   `shocked` is a flash. A corner pulls a man because of the last two rounds, not
   the last punch. Does anything in the state carry that, or would the verb have
   to accumulate it itself?
3. **The distribution that decides whether a threshold is possible at all.**
   Over your sample, at the tick where the engine's OWN stoppage fires (KO,
   three-knockdown TKO, doctor), what did `head_neck` read? What did the trauma
   pips read? And what do those same numbers read in bouts that went to a
   decision? **If the two distributions overlap completely, a threshold cannot
   exist and that is the finding.**
4. **How much warning is there?** For bouts the engine stopped: how many seconds
   earlier could a reasonable threshold have fired? If the answer is "two
   seconds", the verb is decorative. If it is "ninety seconds", it is a real
   decision. **This is the single most important number in the task.**
5. **The doctor already exists.** `_maybe_doctor_stoppage` runs between rounds and
   R86 reported it "no longer fires between two ordinary men over 12 rounds but
   stays reachable". Say what it reads and whether the corner's read should be
   the same quantity at a lower threshold, or a different quantity entirely.
6. **What is MISSING.** The honest half. Name every fact G44's verb wants that the
   engine cannot supply today, and for each say whether it is derivable from what
   exists or needs new engine surface.

## The deliverable

`Q31_THE_STOPPAGE_READ.md`, short and numeric:

- A table of what the engine can answer, at a tick versus at a boundary.
- The two distributions from (3), as actual numbers.
- The warning-window number from (4), stated plainly.
- A one-line verdict: **is "ask for the stoppage" buildable on today's engine —
  yes, yes-with-a-named-addition, or no?**
- The missing list from (6).

**Do not design the verb.** No UI, no button, no threshold constant proposed as
final. This is a feasibility measurement, and if the answer is "not buildable
without X", that is a good answer and saves a whole stage.

## THE GATE — tier

- Research plus a throwaway tool. **No test, and never the suite.**
- Parse gate on your tool before you run it:

```bash
python Godot/tools/check_scripts.py Godot/tools/probe_stoppage.gd
```

```bash
Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tools/probe_stoppage.gd
```

**NEVER pass `--godot` to `run_tests.py`** — it was pointed at a chocolatey binary
and turned 104 tests into engine-error noise that read as a red gate.

## Deliver

1. `git rev-parse --abbrev-ref HEAD` — MUST say master.
2. `git add -- <explicit paths, never audio_exports/>`, commit, push.
3. `python Tools/agent_comms.py send --from qwen --to claude --subject Q31-done --body "<commit> <buildable: yes/yes-with-X/no> <warning window in seconds> <do the stopped and decision distributions overlap: yes/no>"`
4. Do **not** edit `HANDOFF.md`.

## The one trap specific to Q31

**Do not report that a threshold "could be tuned" without showing the two
distributions.** R84 reported a split decision was arithmetically impossible and
was wrong because it measured under the wrong profile; R83F tuned against an
assumed force distribution instead of the emitted one. The number has to come out
of the engine's own output on real seeds, or it is the same mistake a third time.
