# TASK MHNATIVE1 (S209) - MetaHuman boxers fight with their OWN Cascadeur clips (no retarget) + the MH4 cast in the ring

Model: Codex gpt-6.1-sol, reasoning medium. Worktree E:/FightCamp/wt/MHNATIVE1 (seeded), branch codex/mhnative1 from master f0909e20+.
Commit + push the branch; never master.

## Why
S207 operator: "why the animations are basically no animation but a scramble of hands" / "focus on animation". Root cause: mixed
source clips retargeted onto bodies + stacked corrective layers. ANIMSOURCE1B (merged bcdfe028, digest `research/ANIMSOURCE1B_DIGEST.md`)
authored NATIVE MetaHuman clips in Cascadeur: `Godot/assets/anim/metahuman/mh_guard_pose.glb, mh_jab.glb, mh_cross.glb, mh_lead_hook.glb,
mh_inside_uppercut.glb` (animation-only, 341 native joints, exact MetaHuman bone names). More arrive batch by batch on codex/animsource1
(ANIMSOURCE1C: rear_uppercut, jab_body, cross_body, rear_hook, body hooks, overhand, up_jab, check_hook, slip, pull, catch, guard_idle,
hit_head, hit_body) - your wiring must pick up any `mh_<id>.glb` that exists, so each new clip lands in the fight with zero code.
MH4 (merged 3a4c99f1, `research/MH4_DIGEST.md`) delivered 12 boxers `res://assets/models/metahuman/mh_boxer_01..12.glb`
(11-12 and one of 05-10 are women - read `previews/mh4/audit_final.txt` for sex/weight class per file).

## What to build
1. CAST: `Godot/scripts/FightWorldStage.gd` METAHUMAN_MODELS (line ~17, 4 entries) and `model_for_skin` (~51): pick from all MH4
   boxers by the athlete's SEX (women get the women's bodies - today women fall back to the old generator body) and nearest
   weight class from the audit; stable per athlete id; never the same body for both corners. Keep `is_metahuman()` true for all.
2. NATIVE CLIPS: when a fighter's body is MetaHuman AND `res://assets/anim/metahuman/mh_<move>.glb` exists for the role being played
   (map certified ids: boxing_jab -> mh_jab, boxing_cross -> mh_cross, boxing_lead_hook -> mh_lead_hook, the boxing guard idle
   `boxing_stance_guard` -> mh_guard_pose until mh_guard_idle lands, ...; strip the `boxing_` prefix), play that clip's Animation
   DIRECTLY on the MetaHuman Skeleton3D - no FightClipRetarget, no time warp. Find where the fight builds/plays a role's Animation
   for a body (start at `FightClipBinding.clip_for` ~2751 / `metadata_for` ~2904, follow callers in FightWorldLiveScreen.gd (6.6k lines:
   grep, read windows only) and FightClipRetarget.gd). Track paths must resolve on the MetaHuman skeleton the fight loads
   (`MetaHumanRig.gd`, `MetaHuman.load_fighter`) - the 1B probe `Godot/tools/move_shape_probe.gd` already maps clip NodePaths onto
   mh_boxer_01's skeleton: reuse its mapping.
   Contact timing: the fight engine schedules contact by `metadata_for(role)` phases; the native clips have contact at frame 8 / 30 fps
   (0.2667 s), guard return frame 20 (0.6667 s) - read each clip's phases from `Tools/cascadeur/animsource1/clip_manifest_1b.json`
   (or the shape json) and feed them, so the hit lands on the contact frame.
   Corrective layers: for a role playing a native clip, the hand/glove corrective layers (contact stop, hand continuity, S-curve,
   glove spring, IK reach) must NOT move the hands - the clip is the truth. List each layer you bypass in the digest.
   Roles without a native clip keep today's path unchanged.
3. SWITCH: new GameSwitches entry `mh_native_clips` ON in the game (SWITCHALL1 pattern - `Godot/scripts/GameSwitches.gd`), OFF in
   `--script` tests unless a test turns it on.

## Tests
- Parse gate first on every touched .gd: `python Godot/tools/check_scripts.py <files>`.
- NEW `Godot/tests/mh_native_clips_test.gd` (skip with SKIP line when the GLBs are LFS pointers, like mh_fight_identity_test): two
  DIFFERENT athletes (different stats/sex/weight) -> (a) each gets a MetaHuman body matching sex, the two bodies differ; (b) with
  mh_native_clips ON, the jab role on a MetaHuman body plays the mh_jab Animation (assert the resource path / track count 341-ish, no
  retarget call); (c) at the clip's contact time the lead wrist is >= 0.90 x arm length from the shoulder (the 1B number survives the
  fight's playback); (d) with the switch OFF, today's retarget path is used (control arm). Must FAIL on master first (record it).
- `python Godot/tools/run_tests.py --jobs 2 --only mh_,fight_world,fight_clip,switch_gate,game_switches` (jobs 1 when not GREEN).
  Nothing green goes red.
- Visual (a body/animation task closes only on the game camera): `record_room ... as_game` with `-- metahuman_bodies=1` (the game's
  broadcast camera + follow), stills ONLY through `Godot/tools/still_framing.gd` `save_if_framed` (both men head to feet in frame, else
  STILL_FRAMING FAIL - never a mat/feet-only shot): GUARD, and MID-MOVE at the contact frame of jab, cross and lead hook, to
  `previews/mhnative1/`. Plus one 20 s mp4 of a live round. All windowed runs via
  `powershell -NoProfile -ExecutionPolicy Bypass -File Tools\godot_hidden.ps1 ...` (hidden desktop). Open every still with your
  file-read tool and say in the digest what each shows.

## Owned files
Godot/scripts/FightWorldStage.gd (217 lines), Godot/scripts/MetaHumanRig.gd (434), Godot/scripts/FightClipBinding.gd (3162 - add a
small native map + lookup, read windows only), Godot/scripts/GameSwitches.gd, the minimal call-site edits in
Godot/scripts/FightWorldLiveScreen.gd / FightClipRetarget.gd (say each line range in the digest), NEW Godot/tests/mh_native_clips_test.gd,
previews/mhnative1/**, NEW research/MHNATIVE1_DIGEST.md. Never GameState.gd, never FightRealtime.gd.

## Rules
Watchdog before every Godot run: `powershell -NoProfile -ExecutionPolicy Bypass -File Tools\pc_watchdog.ps1 -Once` (RED = wait).
Godot by absolute path `C:\Users\user\AppData\Local\Programs\Godot\Godot_v4.7.2-stable_win64.exe` (headless for tests). Nothing opens
on the operator's screens. Another Codex (ANIMSOURCE1C) runs Cascadeur at the same time - never touch its worktree or Cascadeur.

## The one trap
The fight's corrective layers were tuned to hide bad retargets; left on, they will drag the native clip's hands exactly the way they
scrambled the old ones. Prove on the mid-move stills that the fist is where the clip puts it (compare the stage wrist position at the
contact frame with the clip's own wrist at frame 8 - within 3 cm).

## Prior research
ANIMSOURCE1A/1B digests, MH4_DIGEST, S208 mh_fight_identity fix (FightWorldStage.apply_identity ~71), S161 visual rule (game camera only),
S191 still_framing rule.
## What would a human do?
Drop the authored clips straight onto the matching skeleton, turn off the fix-up layers for them, and watch a round from the broadcast camera.
## Prefab check
None - our own clips on our own skeleton.
