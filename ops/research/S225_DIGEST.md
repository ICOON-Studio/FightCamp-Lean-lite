# S225 DIGEST (2026-10-14/15) - collect day: ANIMFIX1 merged, five cloud rows landed, the globe faces the UK, ANIMFIX2 in round 2

Operator questions answered in chat this session (verbatim): "wtf is this ? is codex working according to the plan from the reviews"
(the folded-into-floor still he opened was the BEFORE witness of the mirror bug; the AFTER pair went to him + the board) and
"why there are no boots on the fighters ?will they need re-rigging with shoes ?" (boots = WARDROBE1 queued behind MH5 on the Codex
seat; the Epic MetaHuman Hightops are skinned to the MetaHuman skeleton - no re-rigging; kit colours on laces/strap).
Board: Q-S221-4 was closed by his comment "this question is old ?" (superseded by Q-S221-5/6); Q-S221-5/6/7 approvals acted on.

## Merged to master (each by diff, parse + the touched tests, never a whole file)
| Commit | What | Gate |
|---|---|---|
| 386fae95 | ANIMFIX1 (Codex codex/animfix1): rest-aware mirror (A) + uppercut source trace (B) | parse 12/12; --only mirror,react,clip,metahuman,foot = 29, 1 pre-existing red (fight_clip_slice) |
| bfce5f4f | KITS1 (cloud Qwen #190): 10 kits + KitClash (CIEDE2000, colour-blind, warm light) | kit_clash_test 1/1 |
| 4e8581f1 | CORNERLIVE2 (cloud Cursor #192): the corner card on the real 60 s clock, ON | corner_live_card + pit-stop tests green; corner_instruction_contract red before and after (nightly) |
| e861f847 | FLOORHUD1 (cloud Cursor #188): floor HUD pieces, ON | floor_hud2 + 9 related = 10/10 - but see the still below |
| 7ce885ca | STREET1 (Goose #189): street vista, ON; its CI red fixed (test built in _init before the autoloads exist) | OFF 1/1, as_game 6/6, club subset 25/25 |
| b2869e10 | NIGHTLY6 (Goose #184): 4 re-pins (2 from the PC's own hashes) + the creation_intro helper line | 6 nightly targets green on the PC |
| 360553c7 | GLOBE1 (cloud Cursor #185 r3) + three fixes of mine | globe_uv_sphere 15/15 (red 180 deg before), globe_picker 21/21, creation subset 7/7 |
| a584793b | LUDOCTX1 (Arena 01a13a2f): Tools/ludo_context_pack.py + 19 blind tests, copied out of Arena's diff (its push never reached GitHub) | 19/19; pack = 41,993 chars |

## What the stills said (all posted to 8787/review, stage S225; the operator closes)
- ANIMFIX1 A: the mirrored rear hook no longer folds MH08 into the floor (before/after pair). Feet and wrists still wrong -> ANIMFIX2 +
  offline bake. Part B: the pointed rear-uppercut sole is 35 deg at 0.50 s IN THE MIXAMO SOURCE - that clip goes to the re-bake.
- FLOORHUD1 + STREET1 on the game's own route (tools/gymlook3a_stills.gd, 1920x1080): RED. No hand cards, no news bar, nav icons
  unlabeled - and the OLD day-goal plate + news box are gone (hidden by is_floor_hud2_on). Cause found: the route `training_floor` is
  TrainingFloorPanel / the ludo_gym hall HUD (`_build_ludo_gym_hud`), while FLOORHUD1 mounted its pieces in `GymHallPanel._build_hud2_pieces`
  (hud2 and not ludo_gym). STREET1: no black void any more; a flat white band outside the south wall; skyline not in view.
- GLOBE1: three rounds of Cursor ended "UK picked -> pin in the Pacific, Russia gold" because (1) GlobeGeo put lon 0 on +Z while the
  SphereMesh UV the shader samples puts it on -Z (180 deg), (2) the fly-to decomposed yaw/pitch for a YXZ pivot (wrong hemisphere;
  now EULER_ORDER_XYZ with derived angles, pitch = latitude), (3) the shader read the ID map as source_color and matched within 0.5
  (ids are 1/255 apart) - half the world gold. Each proved by numbers in globe_uv_sphere_test; the PC capture shows Britain gold, pin on it.

## ANIMFIX2 (Codex, PC, codex/animfix2) - round 1 stopped on MY gates, round 2 running
Codex was right three times: (b) rotating a direction 20 deg about an axis moves the direction less than 20 deg when it has a component
along the axis (cone); (c) a three-number conversion cannot preserve the weighted Euler path (7.3 deg off on the shovel hook);
(a) a 3 cm absolute wrist target across different body proportions is not a contract. Rulings (TASK_ANIMFIX2.md, two new sections):
no conversion - the authored `deg` stays and "anatomical space" = the GENERATOR rig's rest frame (A = from_euler(deg*w);
W = G_rest_gen * A * inv(G_rest_gen); A_t = inv(G_rest_t) * W * G_rest_t), identity on the generator, the same world rotation on MH;
gate (b) = the rotation oracle; gate (a) = a bounded "glove in front of the face" box + arm directions (forearm 6 deg, upper arm 4);
the 21.16 deg pre-layer wrist bend at retarget output (FightClipRetarget.gd:486) is ANIMFIX2B, a separate owner. Round 2 (b7b60277):
(b) <= 0.000004 deg, (c) <= 0.0000145 deg on all 11 recipes, every face box green; subset + sole rerun + AFTER stills in flight.

## Agent lessons (memory)
- Cloud Cursor acts on the ISSUE BODY; a comment-only round produced a CI tweak (GLOBE1 r3) and a HANDOFF block (FLOORHUD1 r2).
  Round briefs go into the body (`gh issue edit --body-file`), then remove + re-add the `cursor` label.
- Arena diff copy-out (S179 route) still works; a file section can be COLLAPSED (`button[aria-expanded=false]`) - click it, then
  its `diffs-container` renders. Both files landed byte-exact through arena_rx.py.
- The operator opens the board's review pictures without captions - every before/after pair is labelled in the title now.

## Still open at the end of the stage
ANIMFIX2 r2 (Codex) landing; FLOORHUD1 r3 (cloud Cursor, body brief: tree-probe gate on the training_floor route); the visual closures
(ANIMFIX1 pair, GLOBE1, FLOORHUD1/STREET1 after r3) on the board; the Ludo pack goes at the top of the next Ask Ludo round; PROFILE2F and
WARDROBE1 (boots) on the Codex seat after ANIMFIX2; ANIMFIX2B (wrist at retarget) to brief; ANIMFIX3 -> OFFBAKE1 -> ANIMSTACK1.
