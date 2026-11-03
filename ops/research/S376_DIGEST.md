# S376 digest (2026-11-03)

## Built and pushed (main)
- BJJCOACH1 666ef070: the coach's steps under Ana's mat (BjjSteps rules, CoachSteps UI, MatPlayer play_step / speed / pause);
  leg locks play leg-lock films (were a judo trip), scissor sweep unfilmed (was a flying scissor), berimbolo + crucifix + saddle.
- LEGFIX1 54684f35: FootPlant STEP_REACH / CAP_REACH - knees locked > 170 deg 14-22 % -> 0-1 % (men and women; bisect:
  `nofeet` 0-2 %, `noknee` no change); RECOVER_MAX / REACT_FAST_MAX 2.5 -> 1.5, OTHER_SPEED 1.25 -> 1.1, SWING_S 0.2.
  Measure: tools/men_fight_film.gd (legs.csv per frame; `women` control; `wide` lens). Argon on main: 3 -> 3/10 (jitter gone;
  walking footwork, skating, fast bob/ducks, camera flip remain) - board post 2026-11-03_1215.
- KALLINUMS1 (Qwen PR #27, collected): combo worth cap 10, 4-punch signature gamble (58 %, +1), share 0.33/0.25 tired/0.40
  named; graded card "+N combos by round 3".
- S375 playtest findings ca7a8bcc: Ana a face card on the Roster, Scouting face cards keep ranges after invite, Drill it on own
  combos, written personalities (no two alike). Danny's camps photo was already right (S372). playtest_s375_test 13/0.
- KNOCKDOWN1 5d92829a: fall on the shot (FALL_AFTER_S 0.12, FALL_FROM_S 0.4: head 0.74 m down 0.8 s after), slow-motion
  replay (KnockdownReplay + PoseRecorder, tree pause), footwork holds while down; FloorClear lies a downed boxer ON the canvas
  (gloves -0.12 -> +0.085 m, pelvis 0.01 -> 0.11). Probes: tools/knockdown_film.gd 4/0, tools/floor_clear_probe.gd 11/0.
- Ops: agent_limits rows (Antigravity + 2,500 credits; Gemini judge Nov $10.42 of $48); loop_seats.json; LOOP_MAX 99;
  read_verdict reads the Score line (FIGHT9R5's "9/10" was a real 3.5); `seat_dispatch.py reloop <task>`.

## Branches
- ziva/bjj9 + claude/bjjmenu1 = cf5891cf: BJJMENU1, the belt match calls as a move menu (chance / points / gas / risk).
  Not on main until BJJ9 is collected.
- claude/fight9base 2961c7b8 = cursor/fight9r5 + main: FIGHT9R6's BASE. FIGHT9R6 running on agy Argon High (launched ~14:00).

## Operator words this session
"i watch the fight of men it it pretty bad their leg animation are broken completely their punch speed feels very fast
along with their body movement and it is very unatural"; "use argon!"; "tell argon to work on the animation until the
quality reach 9/10"; "hands are below canvas wtf"; "knees bent unaturally , i told you before something is wrong";
"let argon fix all the clips"; "knees also tremble on the clips i see on the board"; "tell argon i expect to raise the
quality to 9/10 results"; "i have already paid for google ai pro" (+ bought 2,500 Antigravity credits).
