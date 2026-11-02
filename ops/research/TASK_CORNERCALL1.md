# TASK CORNERCALL1 (S226) - what does each corner call REALLY do in the next round? (measure, then pin the numbers)

You are the FightCamp coding seat (Grok Dev, cloud). Repo ICOON-Studio/FightCamp, pull master. Branch grok/cornercall1, push, open a
PR into master, never merge. Parse gate first (`python Godot/tools/check_scripts.py <touched .gd>`); `run_tests.py --jobs 2` max.
Never delete or loosen a test. GameState.gd is 20,000+ lines - grep, never read whole. NO LFS on your runner: use only the pure fight
sim / corner code (no .glb, no 3D room, no FightStagePlayer).

## Why (approved)
Operator Q-S221-5 "Approve, build it" - LUDO_ROUND63_VERDICT_S224.md section F: "Every effect on the NEXT round is MEASURED with
seeded bouts (called vs not), like CAMPPAY1 - Ludo's '+40% counter' style numbers are not used." Item 4 of its build order. The corner
minute now runs on the real 60 s clock (CORNERLIVE2 merged): `Godot/scripts/CornerPitStop.gd` (pure: apply / payoff / auto_plan),
`Godot/scripts/LudoCorner.gd`, `Godot/scripts/CornerAdvice.gd` (the chief's instructions). Read them; grep where the fight sim applies
the corner between rounds.

## Step 1 - measure (no UI)
For each corner job (cutman cut work, swelling/ice, vaseline, water/stool recovery, the nose-blow) and each chief instruction the code
offers: two arms over >= 40 seeded bouts each, SAME seeds, two DIFFERENT boxers (house rule: never identical fighters; legal for their
ruleset, same weight class), the call made vs not made at the same break. Measure the NEXT round: landed %, damage taken, stamina at
the bell, cut reopen / cut chance, round won (judges). Report mean, 95% CI and n per call in the PR body and in
`research/CORNERCALL1_DIGEST.md`.
If a call changes nothing measurable, find why (is the effect applied to the fighter the sim reads next round?) and fix THAT first.

## Step 2 - pin it
`Godot/assets/data/corner_call_effects.json`: one row per call with the measured effect + CI + n + the seeds/boxers used, so the CORNER
tab (CORNERREPORT1, Arena) and the corner card can quote real numbers. No made-up values.

## Acceptance - NEW tests/corner_call_effect_test.gd
(a) each call whose effect the code claims shows it on its target metric with a CI that excludes 0 (else the PR says why and what it
fixed); (b) the vaseline call lowers next-round cut chance and does NOT change damage (ruling F); (c) the stool recovery's heart-rate
drop is ~0.5 bpm/s front-loaded and capped (ruling F); (d) a control arm (no call at all) differs from itself by less than the noise
band - the instrument can read worse. Plain --script tests are the OFF arm.

## What would a human do?
A cornerman's value is judged by the next round, not the minute: run the same fight with and without the call and compare.

## The one trap
A seed that diverges in round 1 (before the corner) measures nothing about the corner: fork each pair at the break with the same
state, then change only the call.
