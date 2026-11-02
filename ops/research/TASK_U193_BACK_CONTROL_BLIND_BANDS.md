# TASK U193 - CURSOR - A BLIND BAND TEST FOR THE BACK SEAT (Q208) (S113)
Owner: cursor. Assigned 2026-09-27 (S113). Model: Cursor default (Auto). Branch `cursor/u193-back-bands` from
`origin/master`, own worktree. Claude merges. **Tier: a NEW test file only - parse gate plus that one test.**
LAUNCHED S113. It runs in parallel with Q208, never waits for it: until
Q208 merges, a failing band IS the expected result - report it, do not weaken the band.

## Why
Qwen is building the MMA back seat (Q208) from G142 and will measure it with its own census. A test written by the
builder only agrees with the build. Write this one from G142's bands (`research/G142_BACK_CONTROL.md`, 70 lines,
read it whole), never from the Q208 code.

## What would a human do?
A FightMetric coder checks a new ground model the way he checks a season of fights: count every back visit, how long
it lasted and how it ended, across different kinds of matchup, and compare with the published shares. He does not read
the model's source.

## Prefab check
None needed: the project's own SceneTree test pattern (`Godot/tests/fight_one_down_test.gd` shows how to build two MMA
fighters and run a bout headless - read it for HOW to call, not for what to expect). No test framework.

## The contract (what Q208 promises; only these)
- The fight log carries `{"type": "back", ...}` when a back visit starts and `{"type": "back_end", "to": <String>,
  "t_s": <float>}` when it ends. Every `back` has a matching `back_end` (or the bout ends inside it).
- A bout under `boxing` or `kickboxing` has zero `back` events.
- Over many MMA bouts between DIFFERENT fighters (three populations - grappler vs striker, wrestler vs BJJ player, two
  strikers with different grapple stats; never identical fighters, both able to do everything MMA allows):
  median visit 10-30 s (G142 14-24, widened for sample size); share of visits that end the bout by submission 12-32%
  (G142 RNC 18-26 plus other chokes, widened); back visits per MMA bout 0.1-1.0 (G142 ~0.35).
Print achieved beside wanted for each band, and name each population in the output.

## Build
`Godot/tests/fight_back_bands_contract_test.gd` - 40+ bouts per population, fixed seeds, prints `FIGHT_BACK_BANDS
FAILS=N`. Prove it can fail: run it once with a scratch mutant (e.g. a band bound flipped) and say so in the digest; do
not commit the mutant.

## Gate
`python Godot/tools/check_scripts.py Godot/tests/fight_back_bands_contract_test.gd`, then the one test:
`Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tests/fight_back_bands_contract_test.gd`.
Run `godot --headless --path Godot --import` once in the worktree first.

## Owned files
`Godot/tests/fight_back_bands_contract_test.gd`, `research/U193_DIGEST.md`. Read-only: `FightRealtime.gd`
(6,915 lines - never open it whole; `sed -n` windows only, to learn how a bout is started).

## Deliver
Commit and push to your branch; `U193_DIGEST.md` with the band table; one line with
`python Tools/agent_comms.py send --from cursor --to claude --topic U193 --body "..."`. Do NOT edit HANDOFF.md.
**Trap:** the key name - fighter stats live under `"stats"`; `"attributes"` silently yields empty stats and every
population collapses into the same generic fighter.
