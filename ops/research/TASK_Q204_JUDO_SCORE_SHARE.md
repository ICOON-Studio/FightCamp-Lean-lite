# TASK Q204 - QWEN - JUDO: ONE STANDING ATTACK IN EIGHT SCORES, NOT ONE IN FIFTEEN (S101)
Owner: qwen. Assigned 2026-09-27 (S101). Model: qwen3-coder medium, `--yolo`. Branch `qwen/q204-judo-score-share` from
`origin/master`, own worktree. Claude merges.

## Why
U190 (`U190_DIGEST.md`) made judo throws get tried: 9.26 attempts per 4-min match combined [7.89, 10.63], but only
6.6% of attempts score. G136 (`G136_JUDO_GRIP_TO_THROW.md`, sourced): 11-16% of standing attacks score (Calmet ~11-12%,
Olympic medallists 15.7%, 2011 Worlds 19%); combined attempts 11-12 per match; an attack comes after ~6 s of
accomplished grip (8-10 s above 100 kg).

## What would a human do?
A judo analyst codes every attack from video: grip established, attack, outcome (nothing / yuko-era / waza-ari /
ippon). A throw scores when kuzushi (off-balance) was made first - the grip battle wins the throw. The engineer finds
which step of the engine's grip -> attack -> score chain loses the throws (too little kuzushi credit? defence too strong
against a gripped attack?) and repairs that step, not the final number.

## Prefab check
None applies to the engine change. Ready data exists and is already collected: G136 (sourced funnel), U190's census
tool. Reuse U190's tools under `Godot/tools/u190_*` rather than writing a new census.

## Do
1. Measure the funnel as a real analyst would, per fighter and combined: grip time before attack, attacks per match,
   score share by outcome. Population: two DIFFERENT judoka (a thrower: lighter, faster, higher technique; a grip
   fighter: heavier, stronger grips), both legal judo palettes. 40 seeds, CIs. Name the population in the output.
2. Find the step that loses the scores (control arm: show the number moves when that step alone is changed).
3. Fix it, gated to judo (`state.ruleset_id == "judo"`), so boxing/KB/MMA stay byte-identical (print hashes on 4 seeds
   each before/after).
Target: score share inside 11-16% with attempts still 9-13 combined. A CEILING gate: inside or closer, say which.

## Gate
Parse gate; `python Godot/tools/run_tests.py --jobs 2 --only judo,grapple,fight_realtime` no worse than master except
the judo pins in fight_realtime_test that your change moves (list them; Claude re-pins). Never the full suite.

## Owned files
`Godot/scripts/FightRealtime.gd` (~6,500 lines - never open it whole; grep `judo`, `kuzushi`, `U190`, then `sed -n`
windows), the judo board/grip scripts it calls (grep `Board.` and `U190` to find them), `Godot/tools/q204_*.gd`,
`research/Q204_DIGEST.md`.

## Deliver
Commit and push AS YOU GO. Digest, then `python Tools/agent_comms.py send --from qwen --to claude --topic Q204 --body
"..."`. Do NOT edit HANDOFF.md. All research is open: RESEARCH_INDEX.md. **Trap:** raising the score share by making
throws land more often will also raise ippon - check the ippon/waza-ari split stays plausible (G136: EJC 2021 ippon
~4.8%, waza-ari ~3.5% of all technical actions).
