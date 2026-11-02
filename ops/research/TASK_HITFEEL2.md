# TASK HITFEEL2 - wire hit stop + the hit man's short reaction into the live fight, then a same-seed A/B video

Model: Ziva (motion seat, effort MAX). Discipline: BOXING (demo). Starts when HITFEEL1 (Qwen, Godot/scripts/rules/HitFeel.gd) is on
master. Operator S279 (chat): "do it" - hit stop on a clean landed blow scaled by power, and a SHORT reaction on the man who is hit
only, back to the clip in 0.15-0.25 s; the THROWER stays pure mocap (S274 clips_only_base and mocap_pure stand - do not turn any
CLIPS_ONLY_OFF layer back on for the thrower).

## Route (traced by Claude S279)
- Landed blows: FightStagePlayer.aim_strike (~L7218) knows the landed take + contact frame; FightWorldLiveScreen._aim_strikes (~L5035)
  runs after both bodies advance and before the contact solve. Hit stop belongs at the contact frame of a landed blow: freeze BOTH
  bodies' AnimationPlayers (and the sim clock the room shows) for HitFeel.hitstop_seconds(HitFeel.hitstop_frames(contact, power01,
  region)); power01 = the thrower's power attribute (rules/Attributes.gd ~L165 hitstop_frames is the old 1-3 placeholder - replace
  its reader, keep the attribute).
- The reaction: FightActiveRagdoll.gd (Kickback, MIT) has the pinned rig + `_impulse_pending` (~L151, ~L297: fixed 0.3 impulse along
  the thrower's x). Use it on the STRUCK man only, segments/stiffness/damping/recovery from HitFeel.reaction_profile(severity_for(
  impulse)), impulse = HitFeel.impulse(wrist speed measured on the clip at contact, power01, contact), direction = the glove's travel.
- Switch: new GAME_ON key `hit_feel` (GameSwitches.gd); NOT in CLIPS_ONLY_OFF. `active_ragdoll`/`hit_physics` stay as they are for the
  thrower; the struck-man reaction reads `hit_feel` only.

## The trap (C188, research/C188_DIGEST.md): struck-segment physics was NOT ACCEPTED because the no-worsening CONTACT gate
failed (+4.25 mm) and 60 fps was not held. This round must pass both: the contact gate (switch_gate_contact_push_carry_test style,
ON <= OFF) and frame time.

## Test (red on master first) - Godot/tests/hit_feel_wire_test.gd, last line `HIT_FEEL_WIRE failures=<n>`
as_game, seeded bout: a clean landed head blow freezes both bodies for hitstop_frames (+-1 frame); a blocked blow freezes nothing; the
struck man's Head yields and is back on the clip pose within recovery_s + 0.05 s; the thrower's bone pose is byte-identical ON vs OFF;
contact worst-penetration ON <= OFF. Plain arm (OFF) byte-identical to today.

## VISUAL GATE (.claude/skills/visual-gate/SKILL.md)
1. First run the gate on master's shipped fight: a clean landed hook shows no freeze and no head yield - paste that number.
2. Stills only via record_room.gd -- as_game + still_framing.gd save_if_framed: guard, contact frame, one between.
3. For every still report: gap between bodies / where each nose points / wrists in line / feet / the defect / which bodies.
4. Do not call it accepted or fixed. Claude opens every still; the operator closes it.
5. A/B VIDEO for the operator: same seed, 20 s, hit_feel=0 vs hit_feel=1 side by side (the S274 s274_layers_ab.mp4 method,
   --fixed-fps), previews/hitfeel1/hitfeel_ab.mp4.

## Contract
OWNS: Godot/scripts/FightWorldLiveScreen.gd, Godot/scripts/FightActiveRagdoll.gd, Godot/scripts/GameSwitches.gd, Godot/scripts/rules/Attributes.gd, Godot/tests/hit_feel_wire_test.gd
RED_TEST: Godot/tests/hit_feel_wire_test.gd -> HIT_FEEL_WIRE failures=0
REGRESSION: switch_gate_contact_push_carry_test, punch_retime_test
VISUAL: yes

## Prior research
research/topics/hit_reactions.md, C188_DIGEST.md, C217_DIGEST.md / C218_DIGEST.md (Kickback active ragdoll), G86_PHYSICS_HIT_REACTIONS.md,
K51_THE_HIT_RESPONSE.md, S274 digest (clips_only_base A/B).

## What would a human do?
Hit stop first (no bones bent, biggest weight win), video it; then the struck man's head only; then widen to the profile's segments.

## Prefab check
Kickback active ragdoll is already in the project (MIT, pinned) - reuse it, no new physics package.
