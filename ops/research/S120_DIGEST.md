S120 (2026-09-28, Claude) - boxing 10/36 -> 11/36; body shots aim at the body; female fighters on the generator; Codex out -> Claude owns 3D animation

Operator rulings this session: "codex is out of credits you take all the 3d animation design for now" (C223 -> Claude until
Codex returns 2026-10-03 21:50; recorded in roadmap + roster). Asked "why don't you generate the female sprite we are missing" -> done.

## Shipped (all pushed to master)
- 55c0706d smoke_test re-pinned 696->700 / 424->428 (Q210's four grapple naming nodes shipped unresearched; named in the pin).
- dbe9926b C223 run 10 merged as a diff: RamsterZ jab (5.50-6.43 m/s), one-two + double jab recertified. Stills reviewed.
- c37dd1f9 Q213 clipping gate merged (+ Claude fix: a certificate counts only if its source is the production binding path).
  Baseline clips 1/11 pass; live FAIL head 2 / arm 16 / leg 3 failing events, torso 0.
- 72484cd1 ops board: the Codex toggle "did nothing" - roster save nulled the snapshot cache and the page waited an 80 s cold
  build; now patched in place + snapshot persisted to disk (cold 0.005 s); duplicate server on 8787 killed.
- 8150e12d boxing_rear_hook_body CERTIFIED (11/36): additive pose layer (NEW `FightClipPoseLayer.gd`) on the certified rear hook
  + strike-warp `pre` span (wind-up) in `FightClipRetarget.strike_phase_warp`. Fixed on the way: 3 dead aliases, one-two silent
  with strikes_play_whole OFF, missing uppercut clip_phases, a LEFT-hand rear_hook_body entry, tests taught C223's graft loop.
- c7275760 FEMALE fighters on the MPFB generator (D5): `mpfb_female_pilot.glb`, 9 CC0 female skins, painted trunks + sports
  crop top; `FightWorldStage.is_generator`; the Tripo twelve are no longer used. Sheet `docs/previews/s120/female_seeds.png`.
- 257c114b body punches aim at the BODY: the live contact helper aimed every body shot from the shoulder (chest height); now
  the clip's own contact fist, latched per strike. Re-certified 4/4: jab_body, rear_hook_body, body_hook (warp 0.60->0.66).
  Shovel hook bound NEAR with a solved layer (liver height, mechanically clean) - visually a lunge, not certified.
- Tools: `tools/s120_axis_probe.gd` (bone axes by number), `tools/s120_layer_solve.gd` (solve a layer before rendering),
  production gate `yaw=` + peak time; `tools/s120_female_sheet.gd`.
- Records: fighter_looks topic states WHICH bodies ship; videos archived to D:\FightCamp\videos (163 files).

## Suite
No full suite in session (nightly rule). Nightly 2026-09-28 at 6d2a4201: total=457 fails=23. Re-run of those reds on S120
master: smoke_test fixed; `result_screen_why` (seed drift), `fight_contact_stop` (4 landed hands < 5 in 60 s),
fight_ground_policy / technique_phase_seat / technique_range_data (Q210's muay_thai_ground_* nodes - Muay Thai has no ground
game; remove them) and 12 older reds remain. Focused subsets this session: all pass except the two nightly reds above.

## In flight / owed
- Q214 (Qwen) LANDED f7a54501 on qwen/q214-g147-remedies (worktree Temp/FightCamp-Q214, base e413ef42 = BEFORE the S120 aim
  fix): gate NOT met (head 4 failing, seed 94303 unchanged); it rotates Spine backward on trunk penetration. Verify, merge
  master into it, re-measure 3 seeds, then merge or send back.
- Codex worktree Temp/FightCamp-C223 holds UNCOMMITTED 3-part sequence edits (uncertified) - left untouched.
