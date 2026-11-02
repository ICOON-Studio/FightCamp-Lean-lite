# TASK MHSPACING1 (S212) - MetaHumans stand inside each other in the live round; the native cross slides past the chin

Model: Codex gpt-6.1-sol, medium. Worktree E:/FightCamp/wt/MHSPACING1 (seed it: Tools\seed_godot_cache.ps1), branch codex/mhspacing1,
cut from codex/mhnative1 (df5763bc) - it carries the native clips this round plays. Never master.

## The defect (primary source, opened by Claude)
MHNATIVE1 resume 2 (research/MHNATIVE1_DIGEST.md "Current live round", branch codex/mhnative1 df5763bc):
`previews/mhnative1/video_samples/sample_03.png` = live round frame 588 (19.6 s), broadcast camera, as_game,
metahuman_bodies=1: the two men's torsos and hips OVERLAP, blue's native cross goes past red's near side instead of meeting his
chin. Source wrists are exact (error < 1e-6 m) - the clip is right, the room puts the men too close. Same round, frames 562-564
and 578-580: blue goes nearly horizontal for 3 frames on `boxing_slip` (native=false, legacy fallback) - second defect, below.

## Prior research
`research/topics/contact_collision.md` (capsules, overlap refusal, separation - read it first), OPINION_TELEPORTS_*.md
(overlap refusal + `_floor_clamped`), Q213C_DIGEST.md (clip coverage). Code: FightWorldLiveScreen.gd builds the capsules at
~L1351 (`Capsules.build_body_model`, AFTER the MetaHuman mesh swap at ~L1298, so the mesh is right), `_torso_floor_m` from
`Capsules.torso_radius` (~L3504/L3964), `_refused_overlap_from_parts` (~L2058), `_stop_posed_contact` (~L4482, core/core and
leg/leg pairs by part `class`). FightBodyCapsules.gd `posed_parts` / `torso_radius`.

## What would a human do?
Measure the pair on MetaHumans vs the old Tripo pair (f01 vs f09) on the same seed: per frame, nearest torso-torso and
head-torso surface distance, and the parts each body owns by class. A boxer's chests never interpenetrate; at a landed straight
the glove meets the chin at a bent-to-straight arm, so the gap is set by the arm length, not by the torso floor.

## Prefab check
None - our room code.

## Suspects (unproven - prove or kill each with a number)
1. MetaHuman bones get the wrong part `class` (head/torso/leg names keyed to the Mixamo/Tripo rig) -> core/core pairs are never
   tested, so neither `_stop_posed_contact` nor the overlap refusal pushes them apart.
2. MetaHuman skin weights give torso capsules that are too thin (torso_radius much smaller than the drawn chest).
3. The native-clip path (`mh_native_clips`, whole takes) holds the root (`_whole_roots` origin) and skips or undoes the
   separation.
4. Range: the engine's range band -> `_target_gap` table was tuned for Tripo arm lengths.

## Do
1. Probe (new tools/mhspacing1_probe.gd, headless, seed 92012, f01 out-boxer vs f09 pressure puncher - two DIFFERENT men; run
   with metahuman_bodies + mh_native_clips ON, and the Tripo control with both OFF): per-frame min torso-torso distance,
   frames with overlap > 2 cm, part classes per body, torso_radius per body, gap vs `_target_gap`. Print the population in the
   output.
2. Fix the cause the probe names, in the room (FightWorldLiveScreen.gd / FightBodyCapsules.gd). Never warp hands or edit
   clips; never loosen a gate.
3. Slip: if `boxing_slip` falls back to a non-native clip on a MetaHuman, keep it from laying the body flat (find why it goes
   near-horizontal - the fallback retarget or the spine-correction pass at `_stop_posed_contact` Q214 Step 1) or route slip to
   the guard until a native slip exists. Say which in the digest.
4. Acceptance: probe on MetaHumans - 0 frames with torso overlap > 2 cm over a 30 s round; a red-first test
   `tests/mhspacing1_test.gd` that FAILS on df5763bc and PASSES on your fix; then
   `python Godot/tools/run_tests.py --jobs 2 --only mh_,fight_world,switch_gate,contact` - nothing green goes red.
5. Visual (the game's camera, mandatory): `record_room ... as_game` live round 20 s + 4 stills through
   `tools/still_framing.gd save_if_framed` (both men head to feet; never a mat shot), at a landed jab and cross, a body
   shot and a slip. Open every still with your file tool and describe what you see in the digest.
6. research/MHSPACING1_DIGEST.md: cause with numbers, fix, before/after probe, stills described. Commit, push the branch,
   note to Claude in AgentComms/messages.

## Owned files
- `Godot/scripts/FightWorldLiveScreen.gd` (~5,000 lines - NEVER read whole: `sed -n` windows around the anchors above)
- `Godot/scripts/FightBodyCapsules.gd`
- `Godot/tools/mhspacing1_probe.gd` (NEW), `Godot/tests/mhspacing1_test.gd` (NEW), `research/MHSPACING1_DIGEST.md` (NEW)
- `previews/mhspacing1/` (NEW)

## Rules
Parse gate before any test: `python Godot/tools/check_scripts.py <touched .gd>`. Watchdog before every Godot run
(`powershell -NoProfile -ExecutionPolicy Bypass -File Tools\pc_watchdog.ps1 -Once`, RED = wait). Windowed Godot only via
`Tools\godot_hidden.ps1`. Never open image viewers or browsers - view images with your file tool. `git add -- <files>`. Never master.

## The one trap
Headless tests keep game switches OFF: turn metahuman_bodies + mh_native_clips ON explicitly in the probe/test options, or you
measure the Tripo pair and "fix" nothing.
