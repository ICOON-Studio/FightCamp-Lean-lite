# TASK_U166 - the kick effector is the PLANT foot: fix the tagger, re-run both censuses (Cursor)

Model: Composer, medium, `-p --force --trust`. Owner: cursor. Assigned S69, 2026-09-24.

## Why
U164 (source clips faster than humans) and U165 (onset floors, `readable_onset`) both read the striking effector from
`Godot/assets/data/clip_phases.json`, written by the Q167 tagger `Godot/tools/q167_tag_clip_phases.gd`. For kicks the
tagger picks the effector by CHEST-RELATIVE displacement, which can pick the PLANT foot: your own U163 r3 measured
`kickboxing_body_kick` plant 2.47 m/s vs striking foot 24.30 m/s, and U164 then reported that kick UNFLAGGED. So every
kick row in both censuses may be measuring the wrong foot, and U165's onset (effector leaving guard at >= 0.45 m/s)
would start its clock on the standing leg. Also raised in review (S66 session, 2026-09-24): U164's 36.86 m/s overhand
fist likely includes whole-body/root travel; `run_tests --only fight_strike` read 3/1 on the U164 branch; and a tempo
floor of 0.25 could quarter-speed a clip.

## Do
1. The tagger: for a kick (and a knee), the effector is the foot/knee with the larger PEAK speed in the load->contact
   window, not the larger chest-relative displacement. Print, per re-tagged clip, both feet's peak speeds and which one
   was chosen. Re-generate `clip_phases.json`; list every clip whose effector CHANGED.
2. Re-run `Godot/tools/u165_onset_census.gd` and U164's census on the new tags; table OLD vs NEW (clips under floor,
   worst shortfall, kickboxing_body_kick's row). Say whether U165's warp log changes for any clip.
3. Fist speed: report the overhand's peak speed hips-relative beside world, so a root-travel number is never read as a
   hand speed. Do not change a threshold to make a number pass - report it (S65 rule: "the spec can be the defect").
4. Check U164's `human_speed_tempo` floor: can a clip be slowed below 0.5x? If yes, clamp it at 0.5 and say so.

## Owned files
`Godot/tools/q167_tag_clip_phases.gd`, `Godot/assets/data/clip_phases.json`, `Godot/tools/u165_onset_census.gd`, the U164
census tool, `Godot/scripts/FightStagePlayer.gd` (only if step 4 needs the clamp - it is large: grep `human_speed_tempo`
and read windows only), `research/U166_DIGEST.md`.

## Gate (tier: scripts edited)
`python Godot/tools/check_scripts.py <touched .gd>` first. Then `python Godot/tools/run_tests.py --only fight_strike`,
`--only fight_readable_onset`, `--only fight_human_speed`, `--only fight_stage` (ONE `--only` per run; read `total=` each
time). Ceiling: fight_stage 10/1 (the known realism red), everything else no new red. No full suite. Any WINDOWED Godot
run goes through `powershell -NoProfile -ExecutionPolicy Bypass -File Tools\godot_hidden.ps1 <godot args>`; never
`--write-movie` under `--headless` (it hangs - a U165 render sat 2 hours that way on 2026-09-24).
Branch `cursor/u166-kicking-foot` off `origin/master`, commit with explicit paths ON the commit line, push,
`python Tools/agent_comms.py send --from cursor --to claude --topic U166 --body "<effectors changed, census old->new, body_kick row, fist hips vs world, tempo floor>"`.
Do NOT edit HANDOFF.md, and do not read HANDOFF.md, CURRENT_STATUS.md or any digest but U163/U164/U165's.

## The one trap
"Larger displacement" and "faster" are different questions on a clip whose root travels: measure each foot's speed in
the SAME frame the census uses (hips-relative for grafted takes), or the fix moves the error instead of removing it.
