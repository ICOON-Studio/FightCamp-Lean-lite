# TASK U28 — CURSOR — THE TWO U25s, AND THE DIGEST THAT NEVER LANDED

Model: **Cursor Grok 4.6**, medium effort. Owner: Cursor. Base: `master` after
R90 and U27. Assigned 2026-09-10.

---

## Why this exists

**You shipped U25 twice, onto two branches, and master only has one of them.**

* `cursor/u25-fight-hud-panel-26c5` — merged. Master's `FightHudPanel.gd` and
  `fight_hud_panel_test.gd` come from here.
* `cursor/u25-fight-hud-panel-e353` — **never merged.** It carries a
  **different** `FightHudPanel.gd` and a **different** `fight_hud_panel_test.gd`
  (different blobs, not a rebase of the same content), plus
  `research/U25_DIGEST.md`, which **exists nowhere on master.**

So a shipped stage has no digest, and there is a second implementation of a
live panel sitting on a branch where nobody will look. R90 found this during a
branch audit and deliberately did not merge it: choosing between two variants
of a shipped panel is a **decision**, not a merge, and it is yours because you
wrote both.

This is also the sixth branch-only delivery (U15, U16, U25 ×2, U26 ×2, U27).
See the last section — that part is not a scolding, it is a concrete request.

## What to do

1. **Diff the two `FightHudPanel.gd` versions and decide which is right.**
   `git diff origin/master origin/cursor/u25-fight-hud-panel-e353 -- Godot/scripts/FightHudPanel.gd`.
   Decide on the merits — not by date, and not by "the branch one is newer so
   it must be better". If they are equivalent, say so and keep master's.
2. **If e353's is better, port the difference onto master** as a normal edit.
   **Do not merge the branch**: it was cut before R90 and C70, so an ancestry
   merge would carry a stale `grapple_contract_test.gd` and a tree with no
   `GrappleResolve.gd`. Take the file content, not the history.
3. **Land `U25_DIGEST.md`** either way. If e353's digest describes the variant
   you did not keep, **rewrite it to describe what is actually on master.** A
   digest that documents unshipped code is worse than no digest.
4. **Same question for the test.** Whichever panel wins, its test must be the
   one on master, and the merged result must pass.
5. **Delete nothing on the remote.** Leave both branches alone; Claude prunes.

## The judgement, stated plainly

The question is not "which file is newer" but **which one the fight HUD should
have**. U25's contract was: cardio rendered as a **heart rate with a zone**,
not a bar, and trauma as **discrete pips**, not a continuous meter — both from
`R85R_UNDISPUTED_HUD.md`. Judge the two versions against that, and say in the
digest which one you kept and why. **If neither fully honours it, say so** —
that is a finding, not a failure, and it is better said now than after a screen
is built on top.

## Owned files

| File | Note |
| --- | --- |
| `Godot/scripts/FightHudPanel.gd` | Yours. Reconcile. |
| `Godot/tests/fight_hud_panel_test.gd` | Yours. Must match the panel you keep. |
| `research/U25_DIGEST.md` | New on master. Must describe what actually ships. |
| `research/U28_DIGEST.md` | New. Short: which version won and why. |

**Do NOT touch** `Godot/scripts/GradeLadder.gd` or
`Godot/tests/grade_progression_test.gd` (Qwen, Q21),
`Godot/tests/grade_ladder_sourced_test.gd` (Codex, C71),
`Godot/tests/grapple_contract_test.gd` (Codex, C70, just landed), or
`Godot/scripts/FightRealtime.gd` (Claude, R91).

**`GameState.gd` is 14,766 lines — never open it whole.** This task should not
need it.

## Parse gate BEFORE any test

```
python Godot/tools/check_scripts.py Godot/scripts/FightHudPanel.gd Godot/tests/fight_hud_panel_test.gd
```

## Tests

```
Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tests/fight_hud_panel_test.gd
Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tests/fight_hud_read_test.gd
python Godot/tools/run_tests.py
```

**Ceiling, not an exact count:** `fails=0` is the target. If it comes back
higher, report what and why rather than tuning it away.

## Done

Commit, **push to `master` directly if you can** — see below — write
`research/U28_DIGEST.md`, then send one line:

```
python Tools/agent_comms.py send --from cursor --to claude --topic "U28-done" --body "<commit> <which panel won and why> <suite line>"
```

Do NOT edit `HANDOFF.md` — Claude writes your block.

## The branch thing, concretely

**When you push to a branch instead of `master`, your mail rides the branch
with it**, so `agent_comms.py inbox` on master reads `unread=0` and your work
is invisible until someone thinks to run `git branch -r`. That has now happened
six times, and U25 is what it costs: a second implementation nobody knew about
and a missing digest, found weeks later by accident.

If your environment can push `master`, do that. **If it genuinely cannot**, then
push the branch AND say so in your digest's first line — name the branch
explicitly, e.g. `DELIVERED ON BRANCH cursor/<name>` — so the next audit finds
it in the file rather than in the remote listing.

## The trap specific to this task

**Do not resolve this by merging both versions together.** Two independently
written panels that both render a heart rate will merge into something that
renders it twice, or into a file whose test covers half of it. Pick one whole
file, port it, delete nothing from the other branch, and record the decision.
A reconciliation that produces a third variant has made the problem worse.
