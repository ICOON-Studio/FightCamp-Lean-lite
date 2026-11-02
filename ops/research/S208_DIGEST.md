# S208 digest (2026-10-12) - everything switched ON, MetaHuman fights fixed, stress wired to rules, Ludo r43, CI minutes cut

## What now works (merged on master, tests run on master)
- SWITCHALL1 (Codex luna, 174f3a23): `Godot/scripts/GameSwitches.gd` is the ONE shipped-switch registry; the game (no --script, or
  `-- as_game`) runs every feature ON, --script tests keep the OFF control arm. Newly ON: trap/defence/output engine set, ludo_cardauto /
  ludo_shouts / ludo_referee, corner_wired, limb_damage, separation_strip_velocity, stage anim layers (incl. anim_inside_uppercut_ik -
  not in the certified palette), metahuman_bodies + metahuman_staff, broadcast_autocut, gym_look2, club_zones, hud2, career_wear,
  open_spar_night. Inventory: SWITCHALL1_INVENTORY.md. Review fixes by Claude: `bench1` is a SCRIPTED benchmark timeline -> OFF (it broke
  switch_gate_hold_pair_geometry 0.32 -> 2.31 m) and game_switches_test now refuses instruments; LudoShoutBar builds lazily (SCRIPT ERROR
  every frame once shouts went on). Pre-existing reds (red with the old switch set too): switch_gate_contact_push_carry, switch_gate_hands_smooth_in_whole.
- Defects fixed (each with a test that went red first):
  - room view cut no wall since the S206 18 m hall (ClubRoomBase HALL_FRONT_Z const 12 -> layout hall_d): opening a room showed a wall
    (gym_floor_view_test, 10 fails -> green); reception still on the game camera.
  - MetaHuman boxers skipped the identity pass in the live fight (generator-only condition): same red trunks, open hands in the gloves
    -> corner colours + FighterFist (mh_fight_identity_test 3 fails -> 8/0).
  - TIE HIM UP shout drew a blank button (lucide has no link-2) -> handshake (shout_bar_test icon check).
- Collected: RECEPTIONDESK1 (Cursor, Sketchfab counter in the reception, 9/0), TECHSEED1B (Arena #127, world + starters seeded with
  level-implied techniques), STRESS1A (Qwen #126, StressRules), STRESS1B_A (Arena #128, StressWeek: week facts -> events -> tick; Claude
  fix: a win is RELIEF, after the gains; 88/0).
- CI minutes (side session gh-billing, PR #129 merged 5cdefcf7): ~950 Actions min/day, October already over the 2,000 free (+$14.14).
  Cause: every CI run re-imported ~1,200 review stills in Godot/docs (7-11 min). Now: docs hidden from the CI importer (import 38 s), CI
  runs only on .gd changes, blob-less checkout. A typical run ~1 min (was ~14).
- Stills on the board: reception room view; live fight with every switch ON (MetaHumans, red vs blue). Barefoot (no MH boots yet),
  bodies overlap at close range (motion source = ANIMSOURCE1B).

## Ludo round 43 (asked + collected, verdict on the board Q-S207-2 with the doc attached)
LUDO_ROUND43_S208_ask.txt, replies 1-4 (~100k chars), verdict LUDO_ROUND43_VERDICT_S208.md: 7 profile tabs -> 5 full-screen tabs;
MEDICAL & BIO from the operator's 4 boxes; PERFORMANCE & CAMP + CAREER & CONTRACT; header stress bar + wear pill; reception check-in
app (banner, 1.2 s glide, dock); Techniques stage / LOOP-SLOW-MO bar / 8-col icon grid / wireframe; AAA polish timings. Changes: no
invented names/numbers, no grappling card, our stress bands, member prices from Members.gd/FrontDoor; proposed composure rename
(SETTLED for a normal boxer). Ludo trap: the session was signed out mid-answer (pane AND Chrome); the operator signed in on the pane
(Google popup must be his click). A JS click on `button.send-message` sometimes does not send - use a real click and check the box empties.

## Rejected on the sheets (not sent to the operator)
ANIMSOURCE1A (Codex sol, branch codex/animsource1 90bcdaa4): the Cascadeur pipeline works (hidden desktop, native MH quick rig,
AutoPhysics, export/normalize, probe), but the moves start from an upright square stance (feet parallel, hands at chin), the jab
travels 33.5 cm, and each clip GLB carries the full mesh (7.2 MB). Its probe gated only feet/hand continuity. -> ANIMSOURCE1B.

## In flight at handover (YOURS next session)
- Codex sol ANIMSOURCE1B (E:/FightCamp/wt/ANIMSOURCE1, codex/animsource1): guard stance, full extension, hip turn, shape gates that fail
  1A, animation-only GLBs <= 600 KB; sheets to E:/FightCamp/tmp/animsource1b/ - OPEN THEM before anything else. Do NOT merge 1A's 7 MB clips.
- Codex sol MH4 (E:/FightCamp/wt/MH4): fit varied cast, batches 1-3 committed (staff + 6 lean boxers); check lineups, post to the board.
- Codex sol UAL1 (E:/FightCamp/wt/UAL1, codex/ual1): Quaternius CC0 idles/walks/sits on MetaHuman staff/members + ual_clips_test + strips.
- Arena STRESS1B_B (chat 01a12db9): StressWeekFacts + advance_week hook + wiring test.
- John J_CLOTHES2 (MetaHuman clothes, licence first); Maria M_ICONS files to _maria_delivery/M_ICONS_S207 (requested).

## Next (decision)
1. Collect the in-flight runs above (ANIMSOURCE1B sheets first, then STRESS1B_B PR, MH4 lineups, UAL1 strips).
2. When Q-S207-2 is approved: PROFILE2 build on Cursor from Ludo r43 (5 tabs + MEDICAL first), then RECEPTION1 check-in app.
3. METAHUMAN1: profile stage MetaHuman (METAHUMAN1_profile_stage.patch) once MH4's distinct bodies land; boots via wardrobe.
4. Queue: fight HUD BPM reads 200 after 18 s (cardio feed) - Cursor.

## Delegation this session
Codex luna SWITCHALL1, Codex sol UAL1 + ANIMSOURCE1B, Arena STRESS1B_A + STRESS1B_B, John J_CLOTHES2, Maria M_ICONS files, side session gh-billing (CI minutes).
