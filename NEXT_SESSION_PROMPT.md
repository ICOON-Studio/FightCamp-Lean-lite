# S510 handover (written 2026-11-17, end of S509)

Start: `git pull && python ops/Tools/agent_comms.py start`, then this page. Roadmap `now.next_action` has the detail.
Digest: `ops/research/S509_DIGEST.md`.

## First
- Q-267 answered "Only when I'm not playing": before any film, list windowed processes (Get-Process with a MainWindowTitle);
  a game window (ArcheAgeChronicles, FightCamp, Steam games) = no film. Q-268 "Yes, medium": effortLevel is medium.
- He sent a usage-cost video (Fable 5.2 cheap). Done: `.claude/agents/Explore.md` puts search helpers on Haiku. The video's
  other rule for us: do not split small jobs across helpers (briefing + re-reading costs more than doing it).

## Done in S509
- HEADSPLIT2 + HEADSPLIT3 collected (PRs 350, 351): head jumps by phase incl. `combo`.
- A paw/feint/fidget waits until the return to guard has eased in (cc1f9476f); exported with WHAT_TO_TRY.
- PopCap `-- capwhy`: why a >12 cm head frame passes the cap. s509a: 72 of 136 landed punch at full hold, 43 hit
  reactions (free by design), 11 blocked/height-only (body slide).
- Rejected + removed: trunk cap after the hit (hit_carry 31 -> 43); trunk cap on the way in of unlanded punches (no gain).

## NEXT (in order)
Blind r12 (S509): coach 5.0, animator 5.0 - flat vs r11. Reviews: E:/FightCamp/tmp/fightweek/r12blind/critic_*.md.
0. OWNER (S509): "why they only throw puches with one hand ?" - r12 log: each boxer ~35 wait-beat paws/feints in 75 s, ALL
   lead hand (GuardLife WAIT_JAB = pro_left_jab_b); real punches red 23 (7 rear), blue 24 (~half rear). Fix: feints on
   both hands (rear-shoulder cross feint, body feint, level change), paw every 3-4 s not ~2, mix by style (STYLE_EVERY).
   Count hands on the next film; film only with no game window open.
   ALSO: GuardLife.FIDGETS names mc_head_movement and mc_bob_weave - NO such clips load (0 plays in r12; has_animation
   filters them out). Point them at the owned weaves (pro_left_weave / pro_right_weave / mc_Box1_M3_Quick_Weave, today
   defence only) so the waits get head movement. r12 waits: 6 Punch Pro fidgets 32 plays, ow_bounce_idle 6, ow_side_lean 6.
1. Blue's FREE glove shoots straight up above his head after punches - named by r11 AND r12 critics (r12 sheets ex1
   #40-47, ex2 #27-30, ex4 #25-32, ex5 #35-36). Find which clip / layer lifts it; guard box chin to 10 cm over the brow.
2. Arm out after contact worst 29 frames (red's cross, ex1 #40-47; median 5, critics want 3-4, never over 2 held).
3. A head inside the other's body (ex4 #21-24). 4. join_return 3 (rear uppercut: guard loop wrap inside the guard join;
   lead hook: the frame after hit-stop). Run every test with --fixed-fps 60.

## Traps seen this session
- EVERY in-session Godot test takes `--fixed-fps 60` (tools/run_tests.sh passes it, S470). Without it hit_carry read 29-33
  and join_return 2-4 run to run, and older debt numbers (block_meet 3) were measured that way.
- A capped trunk cannot give back the body's own slide: a head that rides the root/hips needs the slide fixed, not PopCap.
- `cd` into E:/FightCamp/tmp moved the session folder: use absolute paths.
- watch-video skill: local faster-whisper fails on this PyAV (`metadata_errors`); feed it numpy from `wave` instead.

## Debt (S509, --fixed-fps 60)
hit_carry 26, block_meet 13, block_catch 10, join_return 3; others from S508 (uppercut_tail 2, block_absorb 11,
punch_speed 40, hit_frame 4, punch_range 1, guard_knee, human_feet, rokoko_clips off-route) - recheck with the flag.
