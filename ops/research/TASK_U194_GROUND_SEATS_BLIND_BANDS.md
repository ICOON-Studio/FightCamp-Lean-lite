# TASK U194 - CURSOR - A BLIND BAND TEST FOR THE FOUR GROUND SEATS AND THE SKILL GAP (Q209) (S114)
Owner: cursor. Assigned 2026-09-27 (S114). Model: Cursor default (Auto). Branch `cursor/u194-ground-bands` from
`origin/master`, own worktree. Claude merges. **Tier: a NEW test file only - parse gate plus that one test.**
HELD for a free shell slot (max two agents). It runs in parallel with Q209, never waits for it: until Q209 merges, a
failing band IS the expected result - report it, do not weaken the band.

## Why
Qwen builds guard / half / side / mount (Q209) from G143 section 7 and scales them by G144. A test written by the
builder only agrees with the build. Write this one from the research - `research/G143_TOP_POSITIONS.md` (102
lines) and `research/G144_GROUND_SKILL_GAPS.md` (read both whole) - never from the Q209 code.

## Prior research (checked S114)
`G143_TOP_POSITIONS.md`, `G144_GROUND_SKILL_GAPS.md`, `G142_BACK_CONTROL.md`, and `U193_DIGEST.md` (the same blind
pattern for the back seat). Delivered S114 before this section existed; kept as written.

## What would a human do?
A FightMetric coder and a grappling coach check a new ground model the way they check a season: count every seat
visit, how long it lasted and how it ended, and ask whether the BJJ man sweeps and the wrestler stands up. They do not
read the model's source.

## Prefab check
None needed: the project's own SceneTree test pattern (`Godot/tests/fight_back_bands_contract_test.gd`, your U193,
shows how to build MMA fighters and run bouts headless). No test framework.

## The contract (what Q209 promises; only these)
- The fight log carries `{"type": "<seat>", "via": ...}` when a visit starts and `{"type": "<seat>_end", "to":
  <String>, "t_s": <float>}` when it ends, for seat in `guard`, `half`, `side`, `mount`. Every start has a matching end
  (or the bout ends inside it). Boxing and kickboxing bouts have zero such events.
- Over many MMA bouts in THREE populations of DIFFERENT fighters (BJJ vs striker, wrestler vs BJJ, wrestler vs striker;
  never identical, all able to do everything MMA allows), widened from G143 7.5 / G144 section 5 for sample size:
  median visit guard 6-20 s, half 5-18, side 8-24, mount 6-20; submissions 10-30% of MMA bouts; the grappler beats the
  striker in 55-80% of BJJ-vs-striker and wrestler-vs-striker bouts; among bouts a BJJ fighter wins, the submission
  share is above the same share for bouts a wrestler wins.
- Style (G144 section 2): with a wrestler on the bottom, his `<seat>_end` exits to standing outnumber his sweeps; with
  a BJJ player on the bottom, sweeps plus submissions outnumber stand-ups. Name the exit strings you count in the
  digest; if the log uses others, report that, do not guess.
Print achieved beside wanted for each band, and name each population in the output.

## Build
`Godot/tests/fight_ground_bands_contract_test.gd` - 40+ bouts per population, fixed seeds, prints
`FIGHT_GROUND_BANDS FAILS=N`. Prove it can fail: run it once with a scratch mutant (a band bound flipped) and say so
in the digest; do not commit the mutant.

## Gate
`python Godot/tools/check_scripts.py Godot/tests/fight_ground_bands_contract_test.gd`, then the one test:
`Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tests/fight_ground_bands_contract_test.gd`.
Run `godot --headless --path Godot --import` once in the worktree first.

## Owned files
`Godot/tests/fight_ground_bands_contract_test.gd`, `research/U194_DIGEST.md`. Read-only: `FightRealtime.gd`
(~7,000 lines - never open it whole; `sed -n` windows only, to learn how a bout is started).

## Deliver
Commit and push to your branch; `U194_DIGEST.md` with the band table; one line with
`python Tools/agent_comms.py send --from cursor --to claude --topic U194 --body "..."`. Do NOT edit HANDOFF.md.
**Trap:** a "BJJ" or "wrestler" is made by the fighter's discipline AND stats (grapple, wrestling); a fixture that
sets only the name or only the discipline gives two men the same numbers and the style bands measure nothing. Stats
live under `"stats"`, never `"attributes"`.
