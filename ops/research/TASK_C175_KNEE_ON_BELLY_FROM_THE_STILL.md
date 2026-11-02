# TASK_C175 — KNEE-ON-BELLY, POSED TO A CHECKED IMAGE THIS TIME

**Owner: codex. Model: `gpt-6-astra`, medium.** Assigned S59, 2026-09-23. Main checkout; do not fetch or rebase.

## Owned files

- `Tools/cascadeur/` (new dir `c175_knee_on_belly`), `Godot/tools/s31_contact_probe.gd` (declared contacts; extend,
  never loosen), `Godot/assets/anim/audition/cascadeur/Cascy_KneeOnBelly_*.glb`, `PAIRED_STRIKE_BINDINGS` in
  `Godot/scripts/FightClipBinding.gd` only, `research/C175_DIGEST.md` (new).

## WHY AGAIN

C172 skipped `bjj_knee_on_belly` at 38.60% after two new approaches (and C171 had the knee 65 cm off the belly). Both
posed from WORDS. There is now a checked TARGET: `research/_captures/ground_video/knee_on_belly_still.png` and
`knee_on_belly_from_still.mp4` (+ `_sheet.png`): the top man's knee and shin across the bottom man's STOMACH, his far
leg extended wide with the foot planted, hips HIGH, torso upright; the bottom man flat, pushing the knee. C174 showed
the method works: posed against `closed_guard_kneeling_duo_still.png` it passed with spine 33.8 deg and drift 23.77%.

## DO

Read your C172 digest's knee-on-belly section first and write in C175_DIGEST what is different now (the target image).
Pose to the still. **Make the LOOK a number, as C174 did:** add to the probe (a) knee-to-belly distance (declared
contact, `_Att` knee on `_Vic`'s abdomen/spine bone - NOT pelvis, NOT chest), (b) `_Att` hips above `_Att` knees by
>= 0.20 m (he is UP, not lying on him), (c) the far foot planted (height < 0.05 m) and wide (lateral >= 0.40 m from
the near knee). Render, and put your sheet beside `knee_on_belly_from_still_sheet.png` in the digest with one
sentence on whether they match.

## GATE - C171/C172's, unchanged

Every declared contact <= 30%; hard controls unchanged (RamsterZ `0.302639 / 0.304671`, clinch <= 15%, side control
<= 14.8173%, the C172/C174 holds no worse); parse gate; `--only clip` 10/0, `--only grapple` 10/0, `--only pair` 7/1
(`fight_pair_live` PARKED). NEVER the full suite. Two honest attempts, then skip and record. One commit, push master,
one `agent_comms.py send --from codex --to claude --subject C175` line. Do not edit HANDOFF.md.
