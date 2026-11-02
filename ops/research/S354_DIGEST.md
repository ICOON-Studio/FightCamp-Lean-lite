# S354 DIGEST (2026-11-02) - update 55: the corner card in numbers, cuts on her face, Training on her page

Lean commit: see roadmap `last_working_commit` (one commit, update 55). Game: this digest, roadmap, live runs, board Q-S294-78.

## Operator input this session (verbatim)
- Board: Q-S294-76 "Yes, I buy it and drop it in Downloads" (already done S353); Q-S294-77 "i do not quite understand the
  picture , what is " (live) " ??".
- Review: C202 (fight panel holo) KEEP "you nailed it here, and you can show the cuts if any here on her small real face",
  KEEP "not bad"; C203 "nice"; C204 (training board) "this should be like a sub tab in the players profile , to see an an
  overview of the training"; C205 (corner card) WRONG "i do not like this how everything is hown here, try to communicate the
  options better and clearer, player needs to see some stats to take decisions"; C206/C207 (belt road) WRONG "huge distance
  between index and text ... can be confusing to the player's eye".
- Chat: "does cline,antigravity or kimi worth subbing ?"; "should i upgrade ziva to 50$ ? are there better alternatives ?";
  "keep going here"; "i do not like his or her in the text ,m use names or do not use it if it is not necessary";
  "also check board for comments"; "what do you think of that ?".
- THE DIRECTION (verbatim): "in my opinion we have to focus on 2-3 mechanics (beside the corner onthe fight) to make them a
  bit fun for player , when picking up the morning exercises it has to sum up gains/loses towards a goal , first week comes
  close to the goals,then the player adjust a bit the intesity to burn weight for example , then the planner for the moves
  should be another mechanism for the player to make unique combinations to improve the fighter , if we manage to make thisi
  fun and display it properly to the player the progress of the move, the effectiveness of the combos the gains, the losses
  and everything . also make the fight plan fun to design , if we can succeed on those we are for early access while
  constantly improving the bjj and boxing at backgrounds"

## What now works (Lean, update 55)
1. C205 CORNER CARD IN NUMBERS - `scripts/ui/CornerStats.gd` (new): the round as a TV stats table at the top of the card -
   ROUND n: WHOSE ROUND, 10-9 (10-8 on a count), rounds so far; landed of thrown, jabs, power punches, to the body (BodyMap.tally
   of the round's beats), energy at the bell, each one's worst spot, her red left / opponent blue right with fixed-width bars.
   The WORKED/HURT sentences go when the table is there (they repeated it). Each option now shows its effect: recover chips
   "(+3 energy each)", talk buttons "+1.5 power, tires her, riskier" read off HER personality (CornerJobs.talk; new
   CornerJobsRow.talk_words), the eight plan tiles "When Maria boxes at range / Fair at it, costs energy"
   (CallButtons.energy_words, GRADE_WORD). Still: fight3d_play p05 (FIGHT3D_PLAY failures=0).
2. C202 CUTS ON HER FACE - `scripts/ui/FaceMarks.gd` (new): the body map's cuts (brow over each eye, nose bridge), swollen
   eye (soft, darker the worse), shut eye (slit), hurt nose drawn on the HEAD close-up's headshot; positions measured on the
   baked headshots (same framing for every boxer). BodyLive hands each callout its side of the map. tools/callout_still.gd
   shows a cut + swollen eye (red) and a cut nose + shut eye (blue).
3. C204 TRAINING ON HER PAGE - FighterPage tab "Training" (index 3, TRAINING_TAB) holds her TrainingBoard; Fighters >
   Training is one line per fighter (main session, the move she learns) with "Her training" opening that tab. Tests and the
   snapshot tool moved Record 3 -> 4 (grey_reason_test, layout_snapshot, golden path loops 7 tabs).
4. Mockups v2 (docs/mockups/S354_week.png, S354_beltroad.png): "(live)" -> "vs a partner" + a key line (sparring / rolling =
   real rounds against a partner who fights back); THIS WEEK numbers beside the move names; belt road bars right beside the
   move names (C206/C207); a Training tab on the BJJ profile. Asked again as Q-S294-78 with both attached.
5. Tests: corner_stats_test (new, 18 checks), face_marks_test (new), both in tools/run_tests.sh.
6. NO HIS/HER (Lean 5fb2303): ~380 strings - screens, fight HUD, corner, rules lines, tape room, plan templates, text data
   (commentary 42 lines, habits 49, combo lines 20, trial/pro offers 17, news 4). Names where they help, else no pronoun.
   Calls renamed: Draw the lead / Tie up / Go for the finish; talks Calm down / Fire up / Tell the truth. Weakness keys
   moved with the data (OppFile "drops the right", TapeClips; Data "Heavy legs late" keeps the "legs late" key). KEPT: the
   wrestling reaction ids ("pulls her arm away" etc.) - they are saved plan move ids; a display-name map is the follow-up.
7. CORE3 (the operator's direction): design Game CORE3_DESIGN_S354.md + mockup Lean docs/mockups/S354_core_loop.png, asked as
   Q-S294-79. WeekPlan.gd (Lean 8eeadaf, pure + week_plan_test 25 checks): seven mornings {session, intensity} -> stat gain
   (TrainingPreview's rule, a fifth of a focused week), kcal (MET x kg x h, Compendium) and kg (7,700 kcal/kg; hold = 300
   kcal allowance, cut = 500 kcal deficit), fatigue (RPE x min, 75 % kept a night, 80+ = 0.6 gain), red days, the camp
   projection and goal lines. The coach's week on a cut: -0.42 kg/week at 61 kg (0.7 %), fatigue peak 54.

## Agents
- CLINCH2 -> Ziva (round 5 overall; Goose r1-r4 never passed 3/6, its r4 probe printed 4/6 on 0 holds). Brief
  wt/ZIVA_LEAN docs/ziva/CLINCH2.md on branch ziva/clinch2 (from main 10e838d): the probe must FAIL on 0 holds and read <= 3/6
  with holds >= 3 on main first. Chat "Implementing Clinch Hold Mechanics" (Ziva Smart, effort Max). The first message hit
  Basic's per-message step cap after 5 min of reading (no output); "continue" sent. RUNNING at handover.

## Decided (Claude, the developer)
- The corner card's stats are graphics (numbers + bars), not sentences: S350's "too much text" and C205's "needs stats" are
  both met by a table where the number sits by its label and the bar shows the gap.
- Talk effects are computed from the fighter's own personality (the same call LiveRound makes), so the card never promises
  what the round will not do.
- Subscriptions (money - the operator decides; Claude's answer from our own record): Kimi no (S125 EUR 15: 4 wrong claims,
  gamed a test); Cline no (free app, the model is the cost; our free models hit limits and ended); Antigravity no (free tier
  works file-only, runs on his PC, cannot run tests headless). Ziva Pro ($50): not yet - decide on CLINCH2's measured score:
  6/6 on Ziva Smart = Basic is enough; stuck at 3/6 = one prorated month of Pro to rerun on Opus/Sonnet, keep only if the
  score moves.

- The direction (Claude's answer, agreed): the three mechanics must feed each other (mornings -> body, evenings -> weapons,
  plan spends weapons, the fight shows it, planned vs actual sends you back) and every choice shows its price.

## Not done (next session)
- Q-S294-79 answer -> CORE3 steps: the Training tab week row with live goal projections (UI), WeekPlan wired into Sim
  (the real week = the plan; weight from the diet + mornings instead of the flat 0.11 kg/day), planned vs actual at the week
  review, evening drills + combo lab effectiveness, fight plan "Test it" (20 sims).
- The export for update 55 (WHAT_TO_TRY written) waited on a GREEN PC (AMBER 80 C beside Ziva).
- Q-S294-78 answer -> TRAINWEEK1 (WeekPlan.gd + Gym > Training week) and BJJ1 (belt road tab, BJJ fighters).
- SMOOTH audit (three red Goose rounds; S353 numbers: OURS 309/min, 115 at a clip change, so ~194/min are INSIDE clips -
  pro_idle 74, pro_left_hook 73, pro_body_shot 57): start from the in-clip kinks (raw clip vs layers per clip), not the joins.
- CLINCH2 collect (Ziva) + the Pro yes/no to the operator.
- Holo replays a tiring move; Miro production map + loop board.

## Later in S354 (after the first wrap-up; operator "keep going here")
- Board catch-up: Q-S294-79 "build playtest get other testers too ... review etc"; markups C210/C213 goal card "make it a bit
  clearer what the player tunes here", C211/C212 fatigue line "this is kind of weak diplay"; C208 week evenings panel "i do not
  understand what is this"; C209 belt road holo "why this is hsown on the belt road tab ?,belt road tab is wrong this should be
  displayed probably in the record tab" -> mockups v3 (Q-S294-80). "build it i guess and we change things if we do not fit".
- Miro (operator: "use the miro board also with other opinions and previews ?"): loop board frames "Core loop - Early Access"
  (mockups, the four parts, Claude/Kalli/John lanes, YOUR NOTES, the in-game still) and "Reception - signing as an RPG recruit".
  No token: "use your connector" - Claude posts seat answers + previews each session.
- CORE3 STEP 1 BUILT (Lean a216706, update 56 exported): WeekBoard.gd = the Training tab; Sim.step_day runs WeekPlan.full_day
  (gains, weight from the diet + the morning's burn replacing the flat 0.11 kg/day, fatigue f["week_fatigue"]); Injuries reads
  WeekPlan.hours; BoutActs wday/spar/weekreset. John's numbers taken (running 9.3, bag 5.8, 87 % kept a night, 44 load points a
  fatigue point with evenings: coach camp ~68, two greedy weeks ~83). Suite 93/93.
- "this needs a lot of improvement, i do not even understand why am choosing those . get it more rpg elements to this" (the
  reception's week cards): Kalli's RPG answer (KALLI_RECEPTION_RPG_S354.md) -> mockup docs/mockups/S354_reception_rpg.png,
  Q-S294-81. All-caps HER/HIS/SHE swept (17 more strings).
- Not built yet: TrainingBoard.gd (the old session-blocks board) is no longer shown - delete or fold in with the perk road.
- RPG RECRUIT BUILT (Lean 3171299, update 57; operator "Yes, build it" on Q-S294-81): Recruit.gd (class, stars range, ceilings,
  traits from the personality with their existing effects, signature, ambition, FOCUS + apply_focus, default cards), PerkRoad.gd
  (8 perks, status/newly_open, news), RecruitPanel.gd (Interview + Trial), Roster.sign_fighter applies the focus (three-card picks
  still sign), Sim.end_week trains the habit out on time and announces perks, FighterPage Attributes tab shows the road.
  recruit_test 20 checks; suite 94/94. NOT YET: the perks' fight effects (next session, first item).
