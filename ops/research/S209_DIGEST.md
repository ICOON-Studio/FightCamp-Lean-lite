# S209 DIGEST (2026-10-12) - collection day: native MetaHuman punches, the 26-person cast, gym motion, weekly stress; six runs out

## Board answers acted on
- Q-S207-1 "Signed in" (Ludo) - r43 already collected.
- Q-S207-2 "Approve all" (Ludo r43 verdict) -> PROFILE2E (Cursor), RECEPTION1B (cloud Cursor #132), COMPOSEBANDS1 (Arena).

## Merged (all diff-applied, each opened/tested by Claude)
| Item | Commit | Evidence |
|---|---|---|
| ANIMSOURCE1B (Codex) - native MetaHuman guard + jab/cross/lead_hook/inside_uppercut, animation-only 544 KB GLBs | bcdfe028 | sheets opened: real orthodox guard (54 cm bladed stance, bent knees, rear fist at jaw), straights 94% extension; MOVE_SHAPE 4/0, 1A witness 4/4 FAIL; gate MERGEABLE. Note: uppercut review pair at 0.50 m interpenetrates (rig staging) -> new no-interpenetration gate in 1C |
| STRESS1B_B (Arena PR #130) - advance_week ticks StressWeek from real week facts into athlete.stress + news | 8b9d01f3 | reviewed GameState hook (roll 0-100 matches tick, composure float); stress/week/playable_loop 15/0 (playable_loop green again) |
| MH4 (Codex) - 10 staff (4 rebuilt lean), 12 boxers (3 women), 4 members; 26/26 audit | 3a4c99f1 | lineups 2/3_age/4_sex/5 opened: varied, fit, distinct; 148 MB in budget; 60 untracked old import files moved to E:/FightCamp/backup_untracked_S209_mh4 (reversible) |
| UAL1 (Codex) - Quaternius CC0 idle/talk/sit/walk on MetaHuman gym people | f0909e20 | strips opened: natural gait, seated, talking; ual_clips + room tests 20/0 on the MH4 cast. Gate could not read TASK_UAL1 owned-files format -> ownership checked by hand |
| Defect: FightStagePlayer `apply_human on Nil` every frame (SWITCHALL1 default-ON flags, stance built only in set_human_response) | 81af0fac | lazy build; profile_stage + stage player 2/0 |
| J_CLOTHES2 (John) saved | 52fdfede | research/J_CLOTHES2_S208.md (.txt for the operator) |

## Decided (developer calls)
- METAHUMAN1 profile stage waits for MHNATIVE1: on the windowed still the old retargeted jab is an open-palm scramble on a MetaHuman and
  the Tripo stand-in boot sits rotated beside the heel (FighterKit assumes the old rigs' foot axes). Patch v2 saved
  (`METAHUMAN1_profile_stage.patch`: MetaHuman stage + a test check that went RED on master, bones 22). Boots -> WARDROBE1.
- Maria's machine link failed 4 handoffs running -> she pastes SVG/text deliverables inline in the gbot thread; Claude renders PNGs.
- RECEPTION1 split: 1B (data module + dock panel) on a cloud seat now; 1C (banner, 1.2 s camera glide, GameState apply) local with stills.

## Running at handover
| Run | Seat | Where | Collect |
|---|---|---|---|
| ANIMSOURCE1C - rest of the boxing palette in Cascadeur, batches A-D (Cascadeur ends 10-27) | Codex sol | E:/FightCamp/wt/ANIMSOURCE1, codex/animsource1 | sheets per batch in E:/FightCamp/tmp/animsource1c FIRST |
| MHNATIVE1 - MH boxers play native clips in the live fight; MH4 cast by sex/weight | Codex sol | E:/FightCamp/wt/MHNATIVE1, codex/mhnative1 | mid-move game-camera stills (still_framing), wrist-at-contact check; then apply METAHUMAN1 patch v2 |
| PROFILE2E - 5 tabs, MEDICAL & BIO from his 4 boxes | Cursor | E:/FightCamp/wt/PROFILE2E, cursor/profile2e | profile2e stills + red->green test |
| COMPOSEBANDS1 - SETTLED band rename | Arena | chat 01a12eb8-52a9 | PR review |
| HUDBPM1 - pulse bounded by 220-age + spike cap | Arena PR #131 | arena/2c90a556 | applied in the main tree, local tests running at handover (see HANDOFF) |
| RECEPTION1B - check-in data + dock | cloud Cursor | issue #132 | PR review |
| M_ICONS - six icon SVGs | Maria | gbot thread | paste-as-text asked |

## Board
- NEW Q-S208-1 (money): clothes budget for the MetaHuman cast - Fab outfits up to 364 USD / ~45 USD refit / free pilot first; J_CLOTHES2 attached.

## HANDOFF
Next: collect the runs above in the order they land (sheets/stills first); HUDBPM1: if its local run (hud_bpm, ludo_fight_hud, cardio,
fight_world_live, composure) is green, commit the applied diff and close PR #131 - if anything went red, `git checkout --` its five files.

## Late S209 (after the operator's look)
- OPERATOR on the 1B cross sheet (verbatim): "the right hand of red fighter does not make any sense the animation is broken". Claude's
  read: the pair stands chest to chest, the rear fist wraps AROUND blue's head; elbow-up looping path across his own face; elbow 141 deg at
  contact. Claude had accepted it on numbers (94% "extension") + a side sheet - the S207 lesson repeated. 1C batch A (cross_body) showed
  the same defect. ACTION: ANIMSOURCE1C stopped (batch A WIP kept on the branch), ANIMSOURCE1D launched (Codex sol HIGH): target-based
  spacing, re-author the straights, gates straight_path / elbow>=165 / elbow height / no_wrap / pair_clearance that must FAIL the rejected
  clips first, then finish 1C. 1B clips stay on master but play nowhere yet (MHNATIVE1 not merged); 1D replaces the files.
- Q-S208-1 answered (comment): "we donot spend money on this , check for free packs : <links>" - the board CUT his answer at 500 chars
  (input maxlength + server cap) -> raised to 8000, board restarted via its scheduled task; John J_CLOTHES3_S209 = free-only census of
  his links. He is asked to resend the cut tail.
- HUDBPM1 merged df876add (Arena PR #131; local 6/0).
- PROFILE2E landed (f7dec1d3) and was SENT BACK (TASK_PROFILE2E_FIX): injured still identical to unhurt, face box shows an old
  non-MetaHuman full body, grey block body map, weight contradiction, empty columns. Cursor round 2 running.
- MHNATIVE1 paused asking to edit FightStagePlayer.gd -> granted, resumed.
- Heat: Claude's own redundant check_workflow re-run did a full uncached editor import (RED 86 C); killed by PID. Do not re-run the
  branch gate just to re-read its output - it imports in a fresh temp checkout.
