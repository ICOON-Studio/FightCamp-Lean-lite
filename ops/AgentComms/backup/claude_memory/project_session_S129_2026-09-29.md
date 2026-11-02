---
name: project-session-s129-2026-09-29
description: "S129 - reach calibrated (RC1, exp 1.0, MMA validates untuned); QuickMagic float was OUR adapter (bind pose); check hook + lead hook certified -> palette 17; foot_lock; catch_counter never played"
metadata:
  node_type: memory
  type: project
  originSessionId: bb0bbf6d-f879-4a16-860f-3a0e586202a1
  modified: 2026-09-29T20:30:59.890Z
---

S129 (2026-09-29, Opus 5.5). Digest `research/S129_DIGEST.md`.

- RC1 reach: the strike gate was ONE shared range for both men and the ladder never read reach. Now `reach_fit` scales
  the thrower's contact ladder by the reach ratio outside the pocket (`reach_edge`, ON in DEMO_SWITCHES, REACH_EDGE_EXP 1.0).
  Census `Tools/reach_census.py` (4 pairs x swap, n=400): boxing 6.5 in 65.8%, 8.7 in 69.9%, MMA (not tuned) 61.6% - all
  inside J33's sourced bands. The swap design (long reach on each side) cancels the pair's skill edge (OFF reads 50.9%).
- QuickMagic "float" was OUR bug: its FBX HIERARCHY holds frame 0 (the crouch), the T-pose lives in the skin BIND pose.
  Adapter now takes the bind pose as rest and refuses a rest equal to frame 0. Check the source before editing it in a
  paid tool: Blender showed the FBX grounded, so the Motion Editor + download were never needed. See [[reference_quickmagic]].
- QuickMagic text-to-motion pads the take (2.3 s of guard drift) -> adapter `end_s=` trim; otherwise recovery 2.95 s.
- `FightClipFootPlant.lock_foot` + binding `foot_lock`: fixed the lead hook's thigh-into-thigh clip; the rear hooks
  clip at the KNEE (hip turn), not the foot -> Q217d (Qwen).
- Found: boxing_catch_counter certified S125 but missing from technique_roles() -> never registered, never played.
- Booked census KO+TKO 37.5 -> 43.3% (control 45.8%) - back in band; run q212 arms ONE AT A TIME (shared save dir collides).
- Exe rebuilt + walked 83/0, godot.log 0 SCRIPT ERROR. fight_strike_whole OFF boxing hash drift is PRE-S129 (engine swap proved it) -> SW1.
- Operator 09-30 00:00: Higgsfield popup '+864 bonus credits, expire Sep 30 23:59 UTC' (balance 136.55 Plus); asked whether
  Dola/Dreamina Seedance 2.5 video was ever tested - NO (record: Seedance only via Higgsfield + BytePlus playground = non-commercial).
- Stage shipped (session 6a79ab5ce35c, last commit after dd3a1964). Q217d (Qwen) in flight.

**Why:** carry the mechanisms, not just the numbers - the next session must not re-derive the bind-pose trap.
**How to apply:** any new FBX source through the adapter -> check the receipt's `rest_source`; a warped strike -> end the
strike span at full extension (the speed minimum), not after it.
