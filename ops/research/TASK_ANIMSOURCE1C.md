# TASK ANIMSOURCE1C - the rest of the boxing palette in Cascadeur, from the 1B guard (before the licence ends 2026-10-27)

Model: Codex gpt-6.1-sol, reasoning medium. SAME worktree and branch as 1B: E:/FightCamp/wt/ANIMSOURCE1, branch codex/animsource1
(continue from ee51ade9; master merged 1B as bcdfe028 - `git merge origin/master` first, no conflicts expected).

## Claude's review of 1B (sheets opened S209) - ACCEPTED, merged
The guard is a real orthodox guard (54 cm bladed stance, bent knees, rear fist at the jaw); jab/cross reach 94%; the shape gates fail 1A.
Two notes carried into 1C:
1. The uppercut pair at 0.50 m interpenetrates on the side sheet (red's torso inside blue's). For close-range moves the receiver's
   CHEST must stay >= 0.10 m from the attacker's chest at every frame - compute pair distance from both torsos, not from reach alone.
2. Keep the 1B pipeline, guard hub (`guard_pose.casc`), gates and animation-only packaging exactly; do not rebuild any of it.

## What to author (orthodox, MetaHuman native rig, every move starts AND ends on the 1B guard; 30 fps)
Batch A - power + body shots:
- rear_uppercut: rear hip drives up and in, knees dip 6-10 cm then rise, fist from chest height under the chin, elbow below the fist.
- lead_uppercut: same from the lead side, shorter dip, lead hip turns.
- jab_body: level change (knees bend 15-25 cm lower, torso stays upright-ish, head off the centre line), lead hand straight to the solar
  plexus, 90%+ extension, return to guard height.
- cross_body: as the cross with the same level change, rear heel pivot >= 30 deg.
Batch B - hooks + overhand:
- rear_hook: rear foot pivots, hips/shoulders 45-70 deg, elbow at shoulder height, elbow 80-100 deg through contact.
- lead_body_hook (id boxing_body_hook) and rear_hook_body: hook shape aimed at the floating rib, knees bend so the elbow is at rib height,
  elbow 80-100 deg.
- overhand: rear hand loops OVER the opponent's lead guard (fist rises above shoulder then drops onto the head), torso leans forward
  and dips to the lead side, rear heel pivots.
Batch C - jab variants + check hook:
- up_jab: jab thrown from a lowered lead hand (lead glove starts at chest height), rising path to the chin, 90%+ extension.
- check_hook: lead hook while the lead foot pivots ~60-90 deg so the body turns OUT of the opponent's line (pivot is the point).
Batch D - defence + idle + reactions (no strikes):
- slip: head moves 15-25 cm off the centre line to the lead side by bending at the knees and turning the shoulders (not by bending the
  neck), both gloves stay at the face, returns to guard. Also slip_rear (to the rear side) if time allows.
- pull: weight shifts to the rear leg, head moves 15-25 cm back (torso leans back from the hips), gloves at the face, returns.
- catch: rear glove opens/turns to catch an incoming jab in front of the face (parry 10-15 cm), returns.
- guard_idle: a 2.0 s seamless LOOP on the guard - small bounce (pelvis 1-2 cm), breathing, gloves drift <= 3 cm, feet planted.
  First and last frame identical (loop gate: every joint position equal within 1 mm).
- hit_head: head snaps back/aside 8-15 cm with the torso following, gloves stay up, recover to guard in <= 0.5 s.
- hit_body: torso folds 10-20 deg forward at the rib, elbow drops toward the hit side, recover to guard in <= 0.6 s.
Combos (one_two, liver_combo, etc.) are NOT authored - the engine chains singles.

## Gates (extend `Godot/tools/move_shape_probe.gd`, same style as 1B)
- Shared guard at both endpoints (2 mm, as 1B); non-punching glove within 0.15 m of the face through contact; planted-foot drift <= 1 cm
  except the declared pivots.
- Straights (jab_body, cross_body, up_jab): extension >= 0.90 x arm length at contact; out slower than back.
- Hooks: elbow within 0.08 m of shoulder height at contact for head hooks / within 0.08 m of the target rib height for body hooks;
  elbow 80-100 deg; hip yaw change >= 40 deg; check_hook lead-foot yaw change >= 60 deg.
- Uppercuts: 1A/1B uppercut rules (rise, forearm angle, dip, elbow below wrist).
- Body shots: pelvis lowered >= 12 cm at contact vs guard.
- Overhand: wrist above the shoulder at mid-flight, then contact at head height.
- Slip/pull: head displacement 15-25 cm in the declared direction; both gloves within 0.15 m of the face throughout.
- guard_idle: loop closure <= 1 mm; glove drift <= 3 cm; feet drift <= 5 mm.
- Every gate must have a negative witness: run each new gate once on a deliberately wrong clip (e.g. the 1B jab as body_hook) and record
  the FAIL lines in the digest.
- NO INTERPENETRATION in paired sheets: minimum torso-to-torso distance >= 0.10 m on every frame (new gate; must FAIL the 1B uppercut
  sheet's 0.50 m pairing - record it).

## Packaging
Animation-only GLBs `Godot/assets/anim/metahuman/mh_<move>.glb`, <= 600 KB each, 341 native joints, no mesh/material/texture; same
`animation_only.py` + `validate_exports.py`. Use the certified ids without the `boxing_` prefix (mh_rear_uppercut.glb ...).

## Sheets for Claude (per batch, before the next batch)
`E:/FightCamp/tmp/animsource1c/<move>_side.png` + `_front.png`, 12 frames, both men head to feet, mh_boxer_01 attacker vs mh_boxer_02.
Commit + push each batch on codex/animsource1 so Claude can collect batch by batch. Then continue to the next batch without waiting.

## Owned files
`Tools/cascadeur/animsource1/**`, `Tools/cascadeur/README.md`, `Godot/assets/anim/metahuman/**`, `Godot/tools/move_shape_probe.gd`,
NEW `research/ANIMSOURCE1C_DIGEST.md`. Nothing else.

## Rules and gates
- Watchdog before every heavy step: `powershell -NoProfile -ExecutionPolicy Bypass -File Tools\pc_watchdog.ps1 -Once` (RED = wait). One
  hidden Cascadeur at a time (ensure_server.py --hidden); stop it when done. Nothing opens on the operator's screens; no image viewers.
- Parse: `python Godot/tools/check_scripts.py Godot/tools/move_shape_probe.gd`.
- Godot by ABSOLUTE path `C:\Users\user\AppData\Local\Programs\Godot\Godot_v4.7.2-stable_win64.exe` headless for the probe; sheets only via
  `powershell -NoProfile -ExecutionPolicy Bypass -File Tools\godot_hidden.ps1 ...`.
- Final: `MOVE_SHAPE_SUMMARY moves=<n> fails=0` over ALL mh clips (1B's 5 + 1C's), negative witnesses recorded.
- `git add -- <files>`, push codex/animsource1, never master.

## The one trap
Defence and reactions have no "contact" - do not let the gate framework force a contact frame on them; give them their own phase marks
(evade peak / impact frame) and say which in the digest.

## Prior research
ANIMSOURCE1A_DIGEST.md, ANIMSOURCE1B_DIGEST.md (pipeline + gates), topics/striking.md, S30_THE_PAIRED_POSE.md (pair spacing),
certified_moves.json (the palette ids).
## What would a human do?
An animator builds the library from one hub pose in batches, reviewing each batch against reference before the next.
## Prefab check
Same as 1B: nothing on the MetaHuman skeleton covers our certified set; Cascadeur is the chosen source until 2026-10-27.
