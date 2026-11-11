# S437 digest (2026-11-11 night into 11-12)

## What happened
- START: no open board questions. C302 (three marks on the glove-touch still: shoulders "this is not smooth", "neckloooks
  wierd") and C303 ("no" on the old tape card, already answered by the see-through tape). The S434 session closed itself
  and left ops/research/FOUNDATION_S434_RESULT.md (branch claude/foundation-s433: PUNCHSTART1 ready, CARDIO1 and NOCAMP1
  need a third round). NOT taken this session.
- GLOVE TOUCH (4042d37a): CornerIK.loosen(w) eases both collarbones and the neck to their rest turn before the look and
  the hands; the intro's touch uses 0.8. The fold between neck and shoulder was the guard's shrug under an arm IK'd down.
  tools/intro_shots.gd takes from=<s>. Still docs/mockups/s437/touch_loose.png (no answer from him yet).
- RANKSHOWUI (Cursor, PR 217, collected 9ee00d6e): RANKING row in the Why, RankRow on the fighter cards; Claude added
  the line under the record on the fighter's own page (DarkOverview). Stills docs/mockups/s437/rank_*.png.
  Note: the result page now says the rank twice (tile + Why row). Left as is.
- DUESSUMS3C (Qwen, PR 216, collected): measure only. With the dead lever (waiting-list strength) excluded there is NO
  robust dues setting; the waiting list keeps nobody because a full club never loses a member. Next dues step is a
  design call (ops/research/DUESSUMS3_RESULT_S433.md, last section).
- ANIMATION D0 step 2 (ops/research/HIT_GAP_S437.md): the re-measured contact file is in (body hook far hits 1 -> 0);
  short_m restored and measured: no gain, so FightStage.land no longer reads it (audit A5 closed as deleted). The punches
  that land off are off sideways or low (pro_left_hook, pro_left_jab_a), not short. block_meet: 2 red rows, both the
  rear hook into the blocking glove (3.4 and 3.0 cm at the 3.0 bar).
- LUDO: his words in order: "ludos credits reloaded , i thinking on cancelling ludo for now", "ludos sub is paused for 3
  months", "credits still work 1083 right now", "sub is paid normally for a month, after that it is paused". So Ludo is
  usable to about 2026-12-11 (1,083 credits), then paused about three months. All approved Ludo work goes in this month.
- VOICEWIRE1 (Qwen, PR 218, NOT collected): 42 lines in a table, events registered, wiring in FightIntro / CornerMinute
  / FightNight, tools/voice_make.py written but NOT RUN (0 credits spent, no voice file exists).
- DAMAGE, HITS, RECOVERY (his ask: "i want the ribs to take normally the damage and deepen/streghten/tighten the damage
  system/mechanic and hit system , have the current one judged and  improve it , same with the recovery mechanics when
  an area become injured options for player to act etc"). Workflow wf_74a9d903-fa0 (12 agents on Opus): four readers,
  two critics on TODAY's game (coach 3, systems designer 3.5), the design map ops/research/DAMAGE_MAP_S437.md v1 (6 / 6)
  and v2 (6.5 / 6, clarity 6 / 5): under the bar. Round 3 = wf_1491fae8-ce6 (see the handover for its result).
  Why the ribs look untouched: only body_hook reaches a rib, 1.5 points, always one side (between two orthodox boxers
  the left ribs can never be hit); the fight rules keep a second, different rib count; body hooks the rules settled can
  vanish in ExchangeBeats._show_game. RIBS1 (Cursor) fixes that defect now, before the redesign.
- HIS RULES TONIGHT: (1) design reviews keep the 7+ bar, but a found defect is fixed at once and he gets the critics'
  verdict on today's game early ("ok"); (2) on a critic's sketch with two ovals for the ribs: "do not make it like this ,
  it looks like tits, use the hook line and the pointer out of the body"; (3) "do we have mechanic to show damage done
  during the fight on the faces ?" - only the small 2D close-up (FaceMarks.gd); the 3D faces, the result page and the
  portrait afterwards show nothing: in the map's round 3 as build tasks.
- CLIPS (his "whos verifying the boxing clips ? i still see only one on the board ?", then on rk_jab / rk_cross "the
  fists have no power , are the animationsbad ?", then "go"): nobody was verifying since S399. Done: the board no longer
  tags the switched-off captured takes "In the fight"; tools/clip_orbit.gd takes `side` (a fixed side camera) and `once`;
  15 fight punches filmed side-on (ops/previews/lean_anim_side, normal then quarter speed); eight read on 33 ms frames
  and recorded in clip_verdicts.json (none a pass): cross B short and bent, lead hook a straight-arm swing, body shot a
  bowed lunge, cross with the lead glove left out, jab B hangs; jab A and the rear uppercut read as real punches; the
  rear hook is unclear from the side. Seven guard clips posted for his OK. The Gemini judge is braked: the month's
  budget on the meter is used up (33.26 of 33.26); raising it is his.

## Traps
- seat_dispatch --act returns before the launch is logged: a "WAIT worktree exists" a few seconds later is the launch
  in progress. Claude removed the live worktree of a run it had just started (RANKSHOWUI), had to stop the seat and
  relaunch. Read ops/AgentComms/seat_dispatch.log before touching a worktree.
- `git commit -m .. -- <paths>` commits only those paths, but the one-line summary the shell wrapper prints counts other
  staged files too. Read `git show --stat HEAD` before worrying.
- hit_gap_probe on one bout of 32 punches: the same data moves p90 by 0.07 m between runs. It shows a clip fixed; it
  cannot rank two data files.
- ffmpeg refuses the hidden desktop's 1920x1009 frames (odd height): scale to an even size.
- A circling preview camera hides how far an arm goes: judge punches on the side films.
- The session passed 420k tokens of context at about 00:00 because of long tool outputs (an SVG, a price table, two
  journals): print less.

## Open
- PR 218 VOICEWIRE1 to collect (it touches FightIntro.gd, changed this session: by diff), then run tools/voice_make.py
  (42 credits) and post the files to the sound board.
- RIBS1 (Cursor) running at wrap-up.
- The other seven fight punches unread; the rear hook needs a front three-quarter film; a seat to own clip verification.
- The foundation branch's third round (CARDIO1, NOCAMP1), PR 211 after it.
- Miro "Where we are": the old surplus cards still need his yes to delete.
