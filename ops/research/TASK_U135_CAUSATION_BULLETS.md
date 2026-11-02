# TASK_U135 — CURSOR — MAKE THE ENGINE SAY WHY THE FIGHT ENDED

**Owner:** cursor. **Model:** `composer-2.5`, MEDIUM.
`-p --force --trust --workspace <worktree>`
**Worktree:** `C:\Users\user\AppData\Local\Temp\FightCamp-U114`.
**Cut a FRESH branch off `origin/master`** — U130 and U134 are both merged to
master now, so start from there and do not re-merge your own branches.
**Test tier:** parse gate on every touched `.gd`, then
`python Godot/tools/run_tests.py --only fight_result`, then
`--only causation`. **`--only` DOES NOT STACK** — one substring per invocation,
and read `total=` to confirm it matched. **No full suite.**

## THE GAP YOU FOUND YOURSELF

U134 wired `UIKit.causation_box` into `FightResultPanel` and then reported,
honestly, that it renders nothing:

> *"No causation bullets in the engine yet — panel looks for
> `causation_bullets` / `causation` / `cause_bullets` on payload or
> `post_fight_read`; missing → no box (no placeholder)."*

That was the right call — you built the consumer and refused to fake the data.
**U135 produces the data.** The box is 840×148 with **five fixed 22 px slots**
and a 576 px measured clip width, and `>5` bullets returns `null`, so the
contract on the producer side is exact: **at most five short lines.**

## WHAT A CAUSATION BULLET IS

One line saying **why this fight ended the way it did**, derived from what the
fight actually recorded — never a template sentence with numbers dropped in.
The fight already tracks knockdowns, significant strikes, grapple grades, round
scores and stoppage cause; `G66_POST_FIGHT_SURFACE.md` §2 is the surface spec
and it is the one to read.

## THE RULE THAT MATTERS MOST

**Every bullet must be DERIVED from a recorded quantity, and the derivation must
be in the code, not in a string.** A bullet that says "dominated the clinch"
because a designer wrote it is worthless; one that says it because clinch
control time crossed a threshold is a finding. **If a fight has no strong
cause, produce FEWER bullets — or none.** An empty causation box is an honest
answer and the box already handles it.

**Rank them.** Five slots, and a knockdown matters more than a takedown count.
Produce the strongest first; the box fills top-down.

## WHAT TO BUILD

1. A module that takes the fight's own end state and returns an `Array` of at
   most five bullet strings, strongest first, each within the 576 px measured
   clip width. **Derive the width check the same way U130's
   `_clip_measure_width` does — call it, do not reimplement it.**
2. Wire it so `FightResultPanel` finds it under one of the keys it already
   looks for. **Do not change `FightResultPanel`'s lookup** — U134 set it and
   it is under test.
3. `Godot/tests/fight_causation_test.gd`: a fight that ended by KO, one by
   decision, one by submission, one with **nothing strong enough** (asserts
   zero bullets), and one that would produce more than five (asserts it is
   capped at five and that the five are the strongest).

## THE SECOND FINDING U134 LEFT, WHICH IS YOURS TO CLOSE OR REPORT

> *"`decision_type == "majority"` has no U130 token (MD ∉ kit) → `result_block`
> skipped until a token exists."*

**A majority decision currently renders no result block at all.** Either add the
token — if that is a one-line addition consistent with U130's existing set — or
**report it as still open and say why**. Do not leave it silently skipped: that
is a real fight outcome producing a blank screen.

## Owned files

- The new causation module and its wiring.
- `Godot/tests/fight_causation_test.gd`.
- `research/U135_DIGEST.md`.

Do **not** edit `UIKit.causation_box` or `result_block` — both are under
contract from U130's test.

## What already exists, so you do not rebuild it

`RESEARCH_INDEX.md` — 227 KB, one line per document, tool and driver.
**GREP IT, NEVER READ IT WHOLE.** Worth running:
`grep -i 'causation\|post.fight' RESEARCH_INDEX.md` and
`grep -i 'G66\|K71' RESEARCH_INDEX.md`. **A negative result is a result.**

## Rules

- Never `git stash`, `git reset --hard`, `git checkout .`, `git clean` or
  `git add -A`. Stage explicit paths only.
- Commit, push your branch, write the digest, send one line with
  `python Tools/agent_comms.py send`. **Do NOT edit `HANDOFF.md`.**

## The trap specific to this task

**`callv` with the wrong arity returns `{}`, not `null`** — so
`if result != null` passes and your test measures nothing. If you call the
causation module dynamically, **assert on the returned array's SIZE and its
CONTENT**, never merely that the call returned something.
