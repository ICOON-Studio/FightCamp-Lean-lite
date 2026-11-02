# TASK Q192 - QWEN - DO THE FIGHT PLANS MAKE DIFFERENT FIGHTERS? (AND THE MMA JAB ROW) (S89)
Owner: qwen. Assigned S89, 2026-09-26. Model: qwen3-coder, medium, `--yolo`. Branch `qwen/q192-plan-separation`.
Worktree: `C:/Users/user/AppData/Local/Temp/FightCamp-Q164` (`git fetch origin && git checkout -B qwen/q192-plan-separation
origin/master`). Lane: engine (agents own it).

## Why
Your Q191 instrument is merged and Claude re-ran it in S89 with a NOISE arm (the same opponent on fresh seeds), three
bouts per arm, columns scaled by the reference men's spread, and power_share dropped (it was 1 - jab_share). p50
distance to the real opponent - noise / S88 market / S89 style clone / random control:
boxing 0.58 / 1.64 / 1.22 / 1.62; kickboxing 0.52 / 1.01 / 0.55 / 1.09; MMA 0.68 / 1.15 / 0.71 / 1.07.
The clone reaches the noise floor in KB and MMA. **Boxing does not** - and your liveness check already hinted why: a
pressure fighter and an out-boxer read only 0.032 apart. If the four boxing plans make nearly the same fighter, no
partner can copy "his plan", because the plan does not show.
Second finding from the same run: **MMA jab share is ~0.00 in every bout.** `FightBroadcast.gd:105` counts a jab only
when the technique id contains "jab". If MMA's lead straight is named otherwise, the broadcast's JABS row (a line the
player reads) is empty in every MMA fight.

## What would a human do?
A coach watching film can tell a pressure fighter from an out-boxer in one round: who walks forward, who jabs and
moves, who waits to counter, how many punches a minute. A plan that does not change those things is not a plan. And a
broadcaster's stat team counts every jab, whatever the fighter's discipline calls it.

## The work
1. **Plan separation.** An instrument `Godot/tools/q192_plan_separation.gd`: for each ruleset (boxing first, then KB and
   MMA), 10 DIFFERENT fighters (FightOpponentGenerator, own stats and palettes), each fought under EVERY plan of the
   ruleset against the same set of DIFFERENT opponents, 3 seeds each. Per plan, the man's profile (output/min, jab share,
   leg-target share, takedowns/round, and - if the log carries it - distance kept / time pressing forward). Print the
   plan-to-plan distance matrix beside the same-plan-reseeded NOISE. A plan pair closer than 2x the noise is "not
   distinct". Name the population and the catalogue in the output.
2. If boxing plans are not distinct: find WHY in the engine (read how `FightRealtime.gd` consumes `fight_plan` - 6,117
   lines, never open it whole: `rg -n "fight_plan|plan\\." Godot/scripts/FightRealtime.gd` then `sed -n` 60-line
   windows; `FightPlans.gd` is 374 lines, read it whole) and change the PLANS (FightPlans.gd weights/intents) so each
   boxing plan shows on film, re-measured. Do not retune the engine's shared constants.
3. **The MMA jab row.** Confirm or refute with a census of MMA technique ids thrown in 10 bouts; if the lead straight is
   not counted, fix the classification in `FightBroadcast.gd` (a jab is the LEAD straight punch, whatever its id - read
   the technique catalogue's own tags, do not hard-code a list if a tag exists) and prove it on an MMA bout.

## Owned files
`Godot/tools/q192_plan_separation.gd`, `research/Q192_DIGEST.md`, `Godot/scripts/FightPlans.gd`,
`Godot/scripts/FightBroadcast.gd` (the jab classification only). Do NOT edit `GameState.gd` or `FightRealtime.gd` - if
the engine itself must change, write it as a recommendation with the number behind it.

## Gate (a CEILING)
Every boxing plan pair >= 2x the noise apart after your change (or say which pair cannot be and why); the MMA JABS row
non-zero on a bout where a lead straight is thrown; `fight_plans_test`, `fight_plan_test`, `fight_plan_explainer_test`,
`fight_broadcast` tests: 0 failures. Re-run `tools/q191_partner_likeness.gd` at the end and report the boxing row.

## Tier
Scripts edited: parse gate (`python Godot/tools/check_scripts.py <touched .gd>`), then
`python Godot/tools/run_tests.py --only fight_plan,broadcast,fight_scoring --jobs 1`. No full suite (nightly).

## Research
All research is open: root `RESEARCH_INDEX.md` (R133 styles, G120, Q191). Do NOT read HANDOFF.md, CURRENT_STATUS.md or
HANDOFF_ARCHIVE.md.

## Done
Commit (explicit paths), push the branch, write the digest, then
`python Tools/agent_comms.py send --from qwen --to claude --topic Q192 --body "<distinct pairs before->after, jab row>"`.

## The trap
A column that cannot move reads as "the plans are the same". Q191's `kick_share` was really LEG-TARGET landed share
(`leg_landed`), not kicks - read what each counter counts before naming it. And the tool must `await process_frame`
before `load()`ing FightOpponentGenerator (it names the GameState autoload) - Q191 as committed could not run on master.
