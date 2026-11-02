# ANIMUPPERCUT1 Round 2 (S207) — acceptance green

Worktree: `E:/FightCamp/wt/ANIMUPPERCUT1`; branch: `codex/animuppercut1`.
Built on Round 1 `679003b7` (rebased as `80866389` onto master `3dcc7be7`).

The gate now reads `boxing_inside_uppercut.effector` from `clip_phases.json`:
`LeftHand`, mapped to the rig's `LeftUpperArm` / `LeftLowerArm` / `LeftHand`.
The master witness ran before any FightStagePlayer changes; its player was
byte-identical to master `3dcc7be7` (verified with Git). The lead-arm defect is
elbow extension and missed chin contact; the corrected witness has no crown overshoot.
Staging uses the fight's actual `FightWorldLiveScreen.RANGE_M.POCKET = 1.07 m`.

`anim_inside_uppercut_ik` defaults OFF. ON applies a final-pose two-bone arm solve
only during the named clip, using the same catalogue effector and production
contact time. The wrist rises from the chest line toward the opponent's chin,
below the transformed head-plus-scalp crown. Torso approach and bounded (8 cm)
clavicle protraction preserve arm segment lengths; the analytical solve retains
a 90-degree elbow around contact. Writes share HUMAN1's pre-sample undo cache
and happen after foot locking and pose-history recording.

The root/feet invariant takes precedence over Ludo's draft pelvis displacement:
the source knee/hip motion remains authored, while the torso drives above the
fixed lower body. No lower-body pose is written by the new layer. The existing
`set_human_response(false, false, opponent)` API supplies the opponent even when
human response effects are disabled. No screen or certified-moves file was edited.

## Exact acceptance results

```text
CHECK total=4 fails=0 autoload_refs=0 autoload_warnings=0 time=2s

MASTER / switch OFF (exit 1, required red witness):
C224 pair=generator_welter_avgenerator_welter_b pass=false reasons=["elbow", "miss"] peak_above_crown=0.000000 elbow=135.373 chin_m=0.487764 pelvis_m=1.063016 contact_s=0.422860
C224 pair=generator_heavy_cvgenerator_heavy_d pass=false reasons=["elbow", "miss"] peak_above_crown=0.000000 elbow=135.373 chin_m=0.451076 pelvis_m=1.062560 contact_s=0.422860
C224 total=2 fails=2

BRANCH / switch ON (exit 0):
C224 pair=generator_welter_avgenerator_welter_b pass=true reasons=[] peak_above_crown=0.000000 elbow=90.000 chin_m=0.099309 pelvis_m=1.063016 contact_s=0.422860
C224 pair=generator_heavy_cvgenerator_heavy_d pass=true reasons=[] peak_above_crown=0.000000 elbow=90.000 chin_m=0.071600 pelvis_m=1.062560 contact_s=0.422860
C224 total=2 fails=0

INSIDE_UPPERCUT_IK pair=generator_welter_avgenerator_welter_b off_identical=true root_feet_identical=true allowed_only=true arm_changed=true idle_identical=true
INSIDE_UPPERCUT_IK pair=generator_heavy_cvgenerator_heavy_d off_identical=true root_feet_identical=true allowed_only=true arm_changed=true idle_identical=true
INSIDE_UPPERCUT_IK_SWITCH checks=16 fails=0
PASS inside_uppercut_ik_switch_test.gd
SUITE total=1 fails=0

PASS bench1_test.gd: BENCH1_TEST checks=8 failures=0 scripts=18
PASS certified_palette_test.gd: CERTIFIED_PALETTE_TEST failures=0; 0 failure(s)
PASS fight_stage_playback_test.gd: TOTAL=36 fails=0
PASS fight_stage_technique_fidelity_test.gd: TOTAL=34 fails=0
PASS intent_bus_test.gd: INTENT_BUS total=26 fails=0
SUITE total=5 fails=0
```

Regression command: `python Godot/tools/run_tests.py --jobs 1 --only certified,fight_stage_playback,fight_stage_technique,intent_bus,bench1 --verbose`.
Every test used the GUI-named Godot 4.7.2 executable with `--headless`; parse
passed before testing. No editor import, window, viewer, browser, or full suite.
The switch test compares 30 full-clip samples for each distinct legal pair to an
independent featureless subclass that bypasses the call even with its switch ON.
ON preserves root, body transform, feet and toes in local/world space byte for
byte; only spine and striking-arm local poses change. Toggle restoration and
30 idle frames also pass.

Nothing remains undone in the scoped implementation/acceptance. Visual game-camera
review and operator approval remain Claude's release gate; the move stays withheld.
