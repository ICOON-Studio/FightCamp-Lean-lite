# S317 digest (2026-10-30) - Lean update 20: the TV look, motion blur, through the ropes, a real clinch, smoother guard

Operator this session: "use ziva to playtest and review"; on a reference boxing game's video (Tale of the Tape, YouTube
jXpq60STOms): "look how much better their game looks", "can you reach their level"; "go ahead" (the motion blur
download); "keep perfecting the clinch and the fight". Board: Q-S294-25 "Clinch looks wrong", Q-S294-27 "Looks right",
Q-S294-29 "Yes, build it" (body map), Q-S294-30 "Yes, keep going". Heat after the PC service: idle median 60 C (was 64),
RED only in the first 20 min after start-up, never above 75 C since; no load test yet.

## What now works (Lean 75af1a9 .. ef45185, update 20 exported)
- TV LOOK (493ddc6): RingCamera shot director - ringside lenses (side 3.0 m at 1.3 m, low diagonal, over the shoulder,
  side wide) that orbit 6-10 deg/s and cut every 4-7.5 s (reference: 15 shots in 86 s). RingSet: AgX, SSIL beside SSAO,
  soft shadows from every spot bank, saturated canvas (0.09/0.28/0.6), darker hall, DOF far 0.22. Stills before/after:
  previews/s317/look_*_before_after.jpg (tools/look_stills.gd, round 1 at 6/14/23/37/52/68 s).
- MOTION BLUR (a9620aa): sphynx-owner Godot Motion Blur Addon v1.1.1 + Easy Compositor v1.0.4 (both MIT, scripts read
  before install: no shell/network/file writes) in Lean addons/, plugins enabled, on the ring camera's compositor; a lens
  jump > 0.4 m (a cut) gets no blur that frame; `-- noblur` control arm; none headless. motion_blur_punch.jpg.
- RING ENTRY (8dbb392): Mixamo "Entry" (old repo mixamo_s215/mh, retargeted) played pure at the start of FightIntro;
  FightIntro carries her from the apron through the rope line while the clip ducks (1.0-5.0 s); RingRopes.part holds the
  ropes apart (middle -0.3 m, top +0.16 m); red then blue 2.4 s later, each on her own shot; then she walks to her corner.
  corner_film: both duck 0.59-0.60 m and end inside; ring_entry.jpg.
- THE CLINCH (ef45185): tools/pair_bake.gd retargets the old repo's two-person Cascadeur clinch (Cascy_CageClinch_Att/Vic,
  4 s) onto two MetaHumans (world rotation delta from rest; each half in her own facing, centred on her own hips) ->
  baked clinch_att / clinch_vic; Clinch.gd plays them pure and in step at the clip's pelvis gap 0.77 m (0.83 x hip
  height), loop 0.4-3.6 s; block pose + IK kept as fallback. clinch_paired_ring.jpg: the 42 s tie reads as a real clinch;
  the 14 s tie shows the victim half's collar-tie hand over the top - tune next.
- SMOOTHER GUARD (fef4898): GuardTuck EASE_S 0.15 -> 0.3.
- INSIDE EXITS on John J-INSIDE3 (312 real exits: step 84 %, pivot 12 %): step 0.76 / pivot 0.15 / tie-up 0.09 (75af1a9).

## Evidence - tools/smooth_probe.gd raw baseline (b116c0e: each kinked clip played alone on the same body)
| run | ours /min | at a clip change | clips' own /min |
|---|---|---|---|
| update 19 plain | 676 | 411 | 817 |
| noguard | 599 | 402 | 839 |
| nojoin | 1199 | 601 | 886 |
| nofeet | 682 | 405 | 821 |
| noreach | 590 | 401 | 856 |
| guard ease 0.3 s | 557 | 329 | 793 |
55 % of all "kinks" are the clips' own fast hands; ours now 557/min, ~330 of them at clip changes (172 changes/min).

## Ziva (wt/ZIVA_LEAN, branch ziva/lean bde0993: docs/ziva/S317_PLAYTEST_REVIEW.md)
Confirms smoothness as the most fake thing; no glove in a head; referee never blocks. Its "score lags the caption 2.4 s"
does not hold in code (FightHud.score adds VERDICT_LEAD_S). Its per-second "snaps" come from stills - not evidence.
Open from it: Begin-fight stall in the editor (recheck in the exe), Space ignored in the intro.

## Not done / next
1. Qwen BODYMAP1 committed on qwen/bodymap1 (86ae8d3, wt LEAN_BODYMAP1): it reports test 5 (loser hurt 100 % vs 40-90 %)
   unreachable with a self-contradicting reason - read RoundScript's landed counts per side yourself, then collect.
2. Clinch: the victim half's raised hand (14 s still); gloves on the clinch grip (C143: "calculate the grip without
   wearing the glove and then put the gloves on right angle").
3. Smoothness: the ~330/min at clip changes - fewer, longer clips between punches (pro_idle plays 0.17 s, 41x/min).
4. Body map 3D/HUD after the rules land; ask the operator about update 20 (Q on the board).
