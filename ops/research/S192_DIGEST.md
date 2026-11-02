# S192 digest (2026-10-10) - pulse fixed, stills/videos on the board, Ludo's animation plan started (smooth part 1 ON)

## Operator rulings this session (verbatim)
- "on the video the reds player beat did not changed at all (stucked at 72 all match)" -> pulse fix.
- "i want to be able to see those [stills and videos] on the opsboard to make comments" -> /review page + CLAUDE.md rule.
- "the animations are not feeling smooth , use ludo which is expert in 3d animation to solve our animations with the help of codex"
- "make sure the space strategy project in github has the same keys as this repo for the agents" / "please do it" -> done.
- "make the opsboard to not reload every 10 minutes" -> no timed redraws.
- Board: Q-S191-4 "Approve Ludo's rule" (doctor AI), Q-S191-5 "Turn it ON" (gym screen), Q-S191-6 "Turn both ON" (smooth part 1).
- "show me a video of the game with everything on" -> fight_all_s192.mp4. Then: "this so much better , some hits do not get a reaction ,
  some misses do not show the fighters head moving backward, the legs animation still look weird ... missing sidestep, hopping on one foot"
- "ask ludo what is missing to make the animations like humanlike and do whatever it says"; "maybe ask all these ?" (Ludo's 3 offers).

## What now works (evidence = commit)
- HUD PULSE: Cardio.from_stamina feeds each card (fresh ~120, rises with fatigue, head-hit spikes, break recovery); head bars follow
  head_neck. a197ca7f; ludo_fight_hud_test red on shipped tree -> green; video pulse_s192.mp4.
- OPS BOARD /review: 'Sent to you' + every docs/previews folder, comment box per still/video (video comments carry the moment),
  AgentComms/media_comments.json, `start` prints unseen comments; Tools/review_add.py posts. c08257fd. No timed redraws on any page
  (Refresh buttons) - 2026-10-10 commit "Ops board: no timed redraws".
- SMOOTH ANIMATION PART 1 (Codex sol, Ludo round 9): smooth_log CSV + Tools/smooth_metrics.py; cam_spring (jolts 282 -> 142) and
  alive_breath (guard never frozen, breathing from the pulse). 6d864968; ON in the game (operator).
- LUDO GYM SCREEN (Cursor GYMUI1 + send-back: overlay was invisible in its stills) 9ab38483; ON in the game.
- DOCTOR AI RULE (Ludo round 10, approved): FightRealtime.doctor_ai_choice; doctor_ai_rule_test 7/0.
- Damage chips (CUT etc.) dock under the Ludo cards (were floating over the ring).
- ANGLE1B merged: angle_guard raises output (+20% landed), no defect; 12 seeds was noise; test at 40 seeds.
- check_workflow reads git output as UTF-8 (crashed on a cp1252 decode).
- space-strategy secrets = FightCamp's (one-off Actions copy, workflow + temp token deleted).

## Findings
- Seed 94301 ends in a 0:30 referee TKO (two 4%/2% shock rolls); census 90 game bouts: 0 standing TKOs before 2:00 - seed accident,
  videos now use 94400. record_room `clock_log=1` probe; Godot/tools/c192_stoppage_census.gd.
- Arena: COMPOSURE1 chat finished but its git push hung (looped 58 min); CORNER2P chat still running at handover, no diff.
- Claude's misses: launched Cursor and ran a re-record while the watchdog read RED (chained the check instead of gating) - stopped
  Cursor at once, killed two hung Cursor test runs; live_runs ANIMSMOOTH1 written at top level (fixed).

## LUDO (design lead): rounds 9-12 saved verbatim
LUDO_ANIMATION_S192.md (r9 diagnosis + numbers, r10 transition graph + doctor rule, r11 the 9 "humanlike" systems) and
LUDO_ANIMATION_R12_S192.md (Codex checklist with pass/fail thresholds, the 30 s Vance-vs-Miller benchmark, the F3 debug overlay).
Ludo works from the built-in browser pane when the Chrome extension is down (signed in there too).

## In flight at handover (collect, do not relaunch)
- Codex ANIM-SMOOTH2 (wt E:/FightCamp/wt/ANIMSMOOTH2, branch codex/anim-smooth2, out E:/FightCamp/tmp/anim_smooth2/last.txt).
- Cursor LUDO-WEEK2A (wt E:/FightCamp/wt/LUDOWEEK2A, branch cursor/ludo-week2a, out E:/FightCamp/tmp/week2a_out.txt).
- Cloud Qwen: #84 COMPOSURE1, #85 ANIM-INERT1, #87 HUMAN-MATH1.
- Arena CORNER2P chat 01a12332-fa45-737c-9a08-ece0481fce61.
- Deferred related tests (doctor_live, ludo_doctor, ludo_gym, gym_hall, anim_smooth1, read_round, alive, camera) for the S192 switch
  flips - run them first thing (the watchdog was AMBER/RED with the nightly + 2 agents).

## Next (decision, Ludo's order)
1. Run the deferred tests. 2. Collect SMOOTH2 (game-camera before/after video, then a board question to turn it ON), WEEK2A (open the
stills), the 3 Qwen PRs. 3. BENCH1 on Codex: the 30 s benchmark (forced-action hook + Vance vs Miller) + FightDebugOverlay.gd (own file).
4. HUMAN1 (additive hit reactions + proximity flinch) -> HUMAN2 (push-pull footwork, absorbs foot lock) -> HUMAN3 (kinetic chain +
punch curves) -> HUMAN4 (look-at + centre of mass) -> HUMAN6 (fatigue posture + glove inertia), each wiring HUMAN-MATH1's modules,
each with a video. 5. Ludo round 13 when BENCH1 starts: "CSV schema + Python metrics grading the benchmark". 6. CORNER2A after
COMPOSURE1 lands; CORNER2B after CORNER2P.
