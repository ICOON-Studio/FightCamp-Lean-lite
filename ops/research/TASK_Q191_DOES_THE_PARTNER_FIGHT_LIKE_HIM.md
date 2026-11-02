# TASK Q191 - QWEN - DOES A HIRED PARTNER ACTUALLY FIGHT LIKE THE OPPONENT? (S88)
Owner: qwen. Assigned S88, 2026-09-26. Model: qwen3-coder, medium, `--yolo`. Branch `qwen/q191-partner-likeness`.
Worktree: `C:/Users/user/AppData/Local/Temp/FightCamp-Q164` (`git fetch origin && git checkout -B qwen/q191-partner-likeness
origin/master`).

## Why
Your Q190 market is merged (Claude added real mutants and fixed two defects: every partner at a level shared ONE
technique palette, and male partners could be drawn female first names; the game's weight ladder is now passed in).
S88 wired it: `GameState.get_spar_partner_offers` builds a partner with the opponent's STANCE and HEIGHT and copies the
opponent's `fight_plan` onto him; the player pays for "a man who fights like him". Nobody has measured whether he does.
If a matched partner fights no more like the opponent than a random one, the feature sells a label.

## What would a human do?
A coach who flies in a southpaw pressure fighter to mimic the next opponent watches the first rounds and asks: does he
come forward like him, throw what he throws, at his pace? If not, he sends him home. He compares against what the
opponent actually does on film - not against his own expectation.

## The work (an instrument, not a feature)
`Godot/tools/q191_partner_likeness.gd`, headless. Population, named in the output: for each ruleset in boxing,
kickboxing, mma, 10 seeded (fighter, opponent) pairs where the fighter and opponent are DIFFERENT men built by the
game's own generator (`FightOpponentGenerator.gd`; give the opponent a `fight_plan` from `FightPlans.gd` so style is
real). Three arms, each run as spars (`{"spar": "light"}` options, the ruleset's rounds) with the SAME fighter:
- REFERENCE: fighter vs the opponent himself.
- MATCHED: fighter vs `SparPartnerMarket.candidates(fighter, spec, level, seed)[0]` with spec = opponent's stance,
  height, discipline, and `fight_plan` copied from the opponent - exactly as `GameState.get_spar_partner_offers` does
  (read it: `rg -n "func get_spar_partner_offers" Godot/scripts/GameState.gd`, then `sed -n` a 60-line window).
- CONTROL: fighter vs a partner from `candidates(fighter, {}, level, seed)` with NO fight_plan copied.
For each bout take the OTHER man's profile from the engine log/result: output per minute, jab share, power-shot share,
kick share (KB/MMA), takedown attempts per round (MMA), share of time pressing forward if the log carries it. Print a
distance (normalised L1 across the profile) MATCHED->REFERENCE and CONTROL->REFERENCE per ruleset, p50 and the count of
pairs where MATCHED is closer. That is the finding.

## Owned files
`Godot/tools/q191_partner_likeness.gd`, `research/Q191_DIGEST.md`. Do NOT edit `GameState.gd` (16,900 lines),
`FightRealtime.gd` or `SparPartnerMarket.gd` - if the finding says the market needs a change, write it as a
recommendation with the number behind it.

## Tier
Research with one new tool script: parse gate on the tool, run it. No test, no suite.

## Research
All research is open: root `RESEARCH_INDEX.md` (G120, G117, R133). Do NOT read HANDOFF.md, CURRENT_STATUS.md or
HANDOFF_ARCHIVE.md.

## Done
Commit (explicit paths), push, write the digest (population, the three-arm table, what it means for the feature),
then `python Tools/agent_comms.py send --from qwen --to claude --topic Q191 --body "<matched closer in n/30, p50s>"`.

## The trap
A row that cannot move reads as "no difference" (memory: "a counter that cannot move"). Before you report MATCHED ==
CONTROL on any profile column, show that column differs between two DIFFERENT reference opponents - if it reads the same
for a pressure fighter and a counter-puncher, the column is dead, not the partner.
