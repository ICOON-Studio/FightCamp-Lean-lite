# TASK Q186 - QWEN - WHY KICKBOXERS ARE NOT GETTING HURT (queued; launch when a shell-agent slot frees)
Owner: qwen. Assigned 2026-09-26 (S83). Model: qwen3-coder, medium, `--yolo`. Branch `qwen/q186-kb-head-damage`.

## Why
Your Q184 census (merged, `Godot/tools/q184_kb_finish_funnel.gd`) found kickboxing finishes at **6.7%** against
Glory's **33%** (G108, n=201), and named the first divergent stage as shocks, then knockdowns: KB 0.91 shocks/bout vs
boxing 2.61, KB 0.06 KD/bout vs 0.33, and the average KB head condition at the final bell is 85.1 vs boxing's 63.2.
Your corner stoppage (`_maybe_corner_stoppage`, threshold 75) is wired and tested but **never fires in a natural bout**,
so the finish rate did not move. Q184's recommendation - raise the threshold to 85-90 - would stop fights on an average
head, which is a knob tuned to the number, not a cause.

Note what the census also says, per MINUTE: KB lands 72.4 sig / 8.8 min = 8.2/min, boxing 164.2 / 21.1 = 7.8/min. The
rate is the same. So the gap is not volume - it is **what each landed strike does to the head**.

## What would a human do?
A Glory matchmaker knows kickboxing is finished by the head kick, the knee and the counter hook in 10 oz gloves - fewer
rounds, but more fight-ending weapons, and the three-knockdown rule inside a round. A cornerman throws the towel after
he has seen his man dropped or badly hurt, not because of an abstract damage number. So look for the missing weapons:
do head kicks and knees in the engine carry the shock / knockdown power real ones do, and does the KB ruleset use the
three-knockdowns-in-a-round rule Glory uses?

## The work
1. Per landed sig strike TO THE HEAD, by technique class (punch / kick / knee / elbow where legal), print for KB and
   boxing: head wear per strike, shock chance per strike, knockdowns per 100 head strikes. Name the divisor on every
   row. Name the population (your three style matchups, both men legal kickboxers able to kick - CLAUDE.md fixture rules).
2. Name the first stage where KB's head strikes do less than their real counterpart would. Source the real anchor
   (G108 or a sourced study) or label it JUDGEMENT.
3. Fix at that stage, KB-scoped if the cause is KB-specific. Then re-run the funnel: KB finish rate must rise toward
   Glory's band (report it; gate it as a CEILING - 20-40%, if you land lower say so and push), and boxing and MMA
   finish rates must not move by more than 3 points.
4. Decide the corner stoppage: keep it at a threshold that means "badly hurt" (tie it to a knockdown or a shock this
   round, not a raw condition) or remove it. Say which and why in the digest.

## Owned files
`Godot/scripts/FightRealtime.gd` (KB damage / stoppage paths only), `Godot/scripts/ImpactModel.gd` if the cause is
there, `Godot/tools/q184_kb_finish_funnel.gd`, `Godot/tests/fight_kb_corner_stoppage_test.gd`,
`research/Q186_DIGEST.md`.

## Tier
Parse gate on touched files, then `python Godot/tools/run_tests.py --only fight_realtime,fight_scoring,fight_kb,fight_footwork,fight_pace --jobs 2`.
Ceiling: on 2026-09-26 master failed `fight_scoring_test`, `fight_stage_realism_test` and six JUDO rows inside
`fight_realtime_test`; nothing else in that subset. Fewer is better. No full suite (it runs nightly).

## Research
All research is open: root `RESEARCH_INDEX.md` (G108 is the kickboxing anchor). Do NOT read HANDOFF.md,
CURRENT_STATUS.md or HANDOFF_ARCHIVE.md. `FightRealtime.gd` is large: `sed -n` windows only.

## Done
Commit, push your branch, `python Tools/agent_comms.py send --from qwen --to claude --topic Q186 --body "<KB finish % before/after, cause>"`.

## The trap
A per-bout number hides a per-minute cause. KB bouts are 9 minutes and boxing 24, so every per-bout comparison
"finds" that kickboxing is quieter. Divide by minutes, then by head strikes, before you name anything.
