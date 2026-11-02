# S356 DIGEST (2026-11-02) - update 59: the camp writes the week, twist cards you answer, Test it, peak camp; the whiteboard

Lean commits: ef7ff01 (update 59), 8876fc2 (the whiteboard Training tab). Game: this digest,
TASK_SMOOTH3 ROUND 4, MIRO_AI_NOTES_S356.md, TWIST_CARDS_REVIEW_S356.md, roadmap, live runs (SMOOTH3R4 = Ziva).

## Operator input this session (verbatim)
- Chat, the Qwen Code link (github.com/QwenLM/qwen-code): I said updating needs a download so I would ask; operator: "you can
  always do that" -> Qwen Code 0.23.0 -> 0.26.5 (official installer, SHA256-checked); memory feedback_tool_updates_ok_s356.
- "miro ai can read the whole project and comment , check its response to me" / "check the stickies": 9 stickies in YOUR
  NOTES on the core-loop frame; verdicts in MIRO_AI_NOTES_S356.md.
- Board Q-S294-82 "Yes, build it": the camp's phase writes the week, one card a day, the player edits exceptions.
- "did you check the twist cards on miro ? hwat do you think of it ?" -> review TWIST_CARDS_REVIEW_S356.md; Q-S294-83
  "Yes, build it" (chat).
- "check miro" -> the "Whiteboard planner - mockup" frame; Q-S294-84 "Yes, build it" (chat).
- Board: Q-S294-78 / Q-S294-80 (training week + belt road v2/v3) still unanswered.

## What now works (Lean, update 59)
1. THE CAMP WRITES THE WEEK (WeekPhase.gd): base / build (3+ weeks out, the camp's stat Hard once) / peak (two weeks out,
   sparring twice) / fight-week taper (half the volume, 3 rest days, no sparring, pads 3 nights - John S354: taper 40-60 %,
   stop sparring 7-10 days out). Synced on Monday and on booking. One card a day ("Hard intervals"); exceptions only
   (f.week_edits); the coach's card again undoes one. The coach's camp, no picks: Sunday fatigue 44/54/54/35, peak 63.
   Fight week on a cut: -0.05 kg a day (low-residue diet, Reale 2017) - the golden path makes weight 61.06 for 61.2.
   The goal lines project through the coming phases (WeekPlan.ahead).
2. TWIST CARDS YOU ANSWER (WeekTwist CHOICES): 9 cards, two priced answers each, the coach's call by default, locked on
   Monday; about 1 week in 4 a small no-choice card. Effects reach the week (rest_hard, all_light, rest/morning/evening),
   money, morale, reputation, members, injury rolls (push through = x2.2 measured over 600 weeks), the pads (combo x2), the
   weight/fatigue numbers, and the fight (lefty +1.5 vs a southpaw; hot head = the corner's fix half as well).
3. TEST IT (PlanTest.gd): the plan on the board fights 20 bouts through fight night's own rounds on a scratch career; wins as
   a range (8 wide on a stranger, 2 with her file open), rounds won, where it breaks; 3 a camp, the same dice each test.
   Control: the presser plan wins 33/60 rounds vs 25/60 for the plan that walks into her.
4. PEAK CAMP (PeakCamp.gd): weight made + the camp's stat on its (fixed) target + fatigue never 80 = +1 every stat for that
   fight, a gold line on the result and the review. The golden path earned it on its own.
5. THE WHITEBOARD TRAINING TAB (WhiteboardKit.gd + WeekBoard.gd + WeekCoach.gd): the Miro mockup - name, camp week and
   phase, the fight date circled in red; magnets per day (I/II/III), fatigue colour only near/over the line; THIS CAMP with
   weight, the stat, the fatigue peak and the injury load; the twist on a sticky note; the coach's one line; CONTINUE.
6. Cleanup: TrainingBoard.gd deleted; wrestling reactions read neutral on screen; TestJump plays one known career (1 run in
   8 lost the bout to a random injury); the week review scrolls with Next week pinned.

## SMOOTH3 audit (one commit, Lean 14bb6b7, --fixed-fps 30) -> ROUND 4 to Ziva
OURS/min: plain 353 (137 at a clip change, idle 107); noreach 259 (idle 59); noglove 271; nosnap 316; noheads 331;
nosettle 347; noguard 375; nojoin 608; nofeet VOID (view never loaded). Top source: PunchReach's disarm fade (0.12 s toward
the live target while the idle plays). Ziva on wt/ZIVA_LEAN branch ziva/smooth3-r4 (from ef7ff01), chat "Fixing
PunchReach Continuity Issues"; result due in docs/ziva/SMOOTH3_r4_result.md.

## Decided (Claude, the developer)
- The phase changes on Monday (and on booking), never mid-week, so planned vs actual stays honest.
- Fight-week weight comes from the diet, not training volume (the taper alone missed weight by 0.06 kg).
- Twist effects are data on the card; Monday applies the once-effects; no weekly news line (S355 flood rule).
- Test it shows a range with a fixed offset so the test reads the plan without giving the fight away.

## Not done (next session)
- Collect Ziva's SMOOTH3 round 4 (bounds: OURS <= 250/min, <= 110 at a clip change, hit_gap unchanged).
- Playtest a 4-week camp in the .exe (computer-use) with the whiteboard + reviews by Kalli and Ziva; ask about outside testers.
- Q-S294-78 / 80 still open; Short-notice swap twist card (later, per the review).
