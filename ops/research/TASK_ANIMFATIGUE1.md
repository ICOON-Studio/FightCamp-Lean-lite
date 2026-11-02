# TASK ANIMFATIGUE1 - fatigue posture + glove springs (benchmark STEPS 8 and 9), behind switches `anim_fatigue` / `anim_glove_spring` (OFF)

Model: gpt-6.1-sol (Codex, animation). Keep fixing and re-running until the acceptance is green - there is NO two-run limit. Only if sol cannot finish the whole task does Claude re-run it on astra (operator S206).
Approved: operator board Q-S204-1 "build it all with your corrections" (Ludo r38 plan, verdict LUDO_ROUND38_VERDICT_S204.md).

## What the player should see
Late in a round a tired boxer's hands sag (wrists 8-14 cm lower), head pokes forward, shoulders rise, breathing shows in the
chest; between rounds it recovers. When a punch stops or a glove is blocked, the glove bounces back 1.0-1.8 cm and settles,
like real padded gloves - never inside a certified contact window.

## Spec
1. NEW `Godot/scripts/animation/FatiguePosture.gd` (RefCounted, static, PURE): from Ludo r38 reply2 s4
   (`research/LUDO_ROUND38_S204_reply2.txt` lines 1-150; the start of s4 is reply1 lines 512-end):
   `static func offsets(stamina_01: float, round_time_s: float, between_rounds_s: float = 0.0) -> Dictionary` returns
   {wrist_drop_cm, head_forward_cm, shoulder_raise_cm, breath_amp_cm}; zero above the onset stamina, smooth (C1) onset,
   wrist_drop reaches 8-14 cm at stamina <= Ludo's critical value, recovery curve between rounds. Name every constant's source
   in a comment (Ludo's citation, or "Ludo r38, no source given").
2. NEW `Godot/scripts/animation/GloveSpring.gd` (RefCounted, PURE, one instance per glove): semi-implicit under-damped
   spring (Ludo reply2 s5.1-5.2, lines 155-275): `kick(event: String)` for "punch_stop" / "block" / "impact_received" with
   Ludo's stiffness/damping per event; `step(dt: float) -> Vector3` offset in metres; `peak_offset_cm()`. Deterministic.
3. `Godot/scripts/FightStagePlayer.gd` (6,258 lines - NEVER read whole; windows: `sed -n 1,70p` switches + human_metrics,
   `sed -n 3590,3640p` the post-animation pose pass where human_hit_additive applies (line ~3605)):
   - add `var anim_fatigue: bool = false` and `var anim_glove_spring: bool = false` beside human_hit_additive (line ~10).
   - in the post-animation pose pass (AFTER AnimationPlayer, the same place the HUMAN1 additive hit layer writes): apply the
     fatigue offsets additively to the guard/upper-body bones (hands down, head forward, shoulders up) and the glove-spring
     offset to each hand bone. BOTH layers are suppressed (weight 0) while IntentBus.in_contact_window() is true for the
     current strike (Godot/scripts/animation/IntentBus.gd, merged a28521c7) - build the intent from clip_phases.json for the
     playing strike clip; no intent = no suppression needed only when no strike is playing.
   - stamina comes from what the presenter already receives per beat (find the stamina/fatigue field in present_live's beat,
     `sed -n 2322,2440p`); if the beat carries none, the layer stays at zero (never invent a value).
   - `human_metrics()` gains `wrist_vert_drop_cm` and `glove_spring_offset_cm`.
   - OFF: byte-identical pose to today, no per-frame allocations.
4. `Godot/tools/record_room.gd` `_bench_side_metrics` (line ~540): the blue columns `blue_wrist_vert_drop_cm` and
   `blue_glove_spring_offset_cm` read those two human_metrics keys instead of the literal "0.0" (missing key -> "0.0").
   The bench1 path (line ~126, eng_b["bench1"]) switches both on for the benchmark run. Game default stays OFF.

## Acceptance (tier: script edited)
- NEW `Godot/tests/fatigue_posture_test.gd` (SceneTree, `_initialize`, `FATIGUE_POSTURE total=N fails=M`, quit(1) on fail):
  zero above onset; monotone as stamina falls; wrist drop in [8,14] cm at critical stamina; C1-continuous at onset (numeric
  derivative jump < 5%); recovers between rounds; inline MUTANT (onset step instead of smooth) must fail.
- NEW `Godot/tests/glove_spring_test.gd`: after "punch_stop" the peak rebound is 1.0-1.8 cm and settles under 0.1 cm within
  Ludo's settle time; energy decays monotonically per cycle; deterministic (two runs equal); inline MUTANT (damping 0) fails.
- NEW `Godot/tests/fight_stage_fatigue_switch_test.gd`: two DIFFERENT fighters (never identical, CLAUDE.md s5): both switches
  OFF -> every bone pose at 30 sampled frames byte-identical to a run without the feature; ON with low stamina -> the hand
  bones sit 8-14 cm lower than OFF in guard; inside a strike's contact window the hand pose equals OFF exactly.
- Then `python Godot/tools/run_tests.py --jobs 2 --only fatigue,glove_spring,intent_bus,fight_stage,bench1,certified` green.
Parse first: `python Godot/tools/check_scripts.py <every touched .gd>`.
Run one test: `"%LOCALAPPDATA%\Programs\Godot\Godot_v4.7.2-stable_win64.exe" --headless --path Godot --script tests/<name>.gd`
(never the _console exe). Claude runs the windowed benchmark and the game-camera stills at collection.

## Owned files
new Godot/scripts/animation/FatiguePosture.gd, new Godot/scripts/animation/GloveSpring.gd, the three new tests,
Godot/scripts/FightStagePlayer.gd (only: two switch vars, the post-animation pose pass hook, human_metrics keys),
Godot/tools/record_room.gd (only the two blue columns + bench switches). Another Codex run (ANIMSCURVE1) edits FightStagePlayer's
strike-start and ADVANCE/seek path at the same time - stay out of those; keep your hunks small.

## Prior research
`python Tools/prior_research.py fatigue posture guard drop glove spring secondary motion`: LUDO_ROUND38_S204_reply2.txt s4-s5
(Ludo's FatiguePostureModifier / GloveSpringModifier drafts and their tests - STARTING specs, not code to paste),
LUDO_ROUND38_VERDICT_S204.md, the HUMAN1 additive hit layer already in FightStagePlayer (the pattern to copy).

## What would a human do?
A technical animator adds two procedural layers on top of mocap: a fatigue pose blended in by a stamina curve, and a jiggle
spring on the gloves - both muted at the impact frame so the authored contact stays exact.

## Prefab check
Godot 4.7's SpringBoneSimulator3D does bone jiggle but runs its own physics step and cannot be muted per frame by our contact
window rule without a wrapper; a 40-line deterministic spring we control is safer for the C223 gate. No fatigue-posture prefab.

## The one trap
The pose pass runs AFTER AnimationPlayer - writing bone poses before it is overwritten every frame (looks like "nothing
happens"). And never move root or feet: hands/arms/neck/spine only. Work in your worktree; commit on your branch; never push
master. No windows, no image viewers.
