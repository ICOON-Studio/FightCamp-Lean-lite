# S443 handover (written 2026-11-12 during S442; S441's handover is in git history at 015c6dec)

OPEN IN E:\FightCamp\Lean. START: `git pull && python ops/Tools/agent_comms.py start`, then `python ops/Tools/where_we_are.py roll S443`
and redraw Miro (a partial SVG with the frame line and the changed cards works; then `where_we_are_svg.py learn` / `trim`).

## USAGE FIRST
`get_usage`. S442 started at all models 93 %, Fable 97 %, extra usage EUR 37.92 of 40; the week reset Thu 2026-11-12 16:00
local. He said "Carry on now", so S442 ran helpers on Opus (model "opus" on every Agent call). Keep helpers on Opus.

## HIS WORDS (S442, verbatim)
- "Carry on now" (asked whether to hold the paid critic rounds until the reset).
- "check comments on board". C314 on the retimed jab B: "still no power behind the shot it looks like a gymnastic extension
  move , not a punch"; C315 jab A: "same with jab b"; C316: "PA lines seem to be pausing a lot and the crowd volume doesnt
  rise up gradually" (fixed, new clip on the board, unheard).
- On the two recommended mocap packs (Q-S294-194): "i dont like any of their punches animations, their punches seem to be
  have to power behind them , what other options we have". Answered with four options (POWER1 first; three other packs'
  previews; capture a real boxer ourselves; film to motion). No pick from him yet. Do not buy the two packs.
- "will your agents keep running if fable credits run out ? will i be able to switch to opus and continue ?" (answered).
- "can you also a UX expert to audit game and makeimprovements", "and HUD too if can do both", "maybe add some hades-like UX
  the text labels for button remains hidden until you omouse over the mouse over them" + the video (watched whole:
  ops/research/HADES_UX_VIDEO_S442.md), "add some effects on critical decisions buttons like slowly expand and shrink to draw
  players eys ?", and the slide "Secret recipe for main menus" (nine rules: memory feedback_menu_recipe_hades_ux_s442).

## DONE IN S442 (on main, pushed)
- Collected by diff, each with fixes at collect, NONE wired to a screen: R26SWAP1 (PR 230, scripts/rules/LineSwap.gd),
  R50TRAIT1 (PR 231, TraitLine.gd), R17PHASE1 (PlanPhase.gd; the dispatcher may still open its PR: close it, it is on main).
  Their three tests are on the daily list.
- ASK FOR A FIGHT short map: ops/research/ASKFIGHT_MAP_S441.md (fair match / step up / a name for the $450 gate; a fight
  teaches Fight IQ, NEW for amateurs from the pro numbers). Free critics: Kalli (sent), John (sent); Dola unreachable.
  Answers land as ops/research/ASKFIGHT_CRITIC_S442_KALLI.md / _JOHN.md.
- Result page: round 2 FAILED its logic check (ops/research/RESULT_LOGIC_CHECK_S442.md: a hand-written bout that cannot
  happen) and two critics at 6. ROUND 3 is drawn from a real bout: tools/result_dump.gd (seed 44) ->
  docs/mockups/s442/result/bout.json -> build_result.py -> fight_result.png; note ops/research/RESULT_ROUND3_S442.md.
  Round 3 critic A = 6 (RESULT_R3_CRITIC_A_S442.md + its 10/10 drawing); critic B's file is RESULT_R3_CRITIC_B_S442.md.
- Sound: the crowd swells back in under the announcer (Sfx fade_in, FightSfx constants); preview on the board.
- Measured: ops/research/FIRELEVEL2_ADAPT1_RESULT_S442.md (fire level ON only with a first-season re-measure; the adapting
  opponent stays OFF: answering it loses 6-8 points with two shouts a round). The foundation moved Lucy v Maria from 41 %
  to 58 %: older numbers for that matchup are void.
- Ziva's editor restarted (worktree on main; its old import noise is on local branch wip/ziva-s442). Miro P0 redrawn.

## LATER IN S442 (all on main, pushed)
- His "Yes, draw them" then "All three": BUILT and in the build of 16:18 (Builds/FightCamp.exe, WHAT_TO_TRY current, the
  exe smoke-started headless, NOT played on screen): corner cards (scripts/ui/CornerSwapCards.gd, SwapLink.gd, from
  LineSwap), reaction bubbles over the fight (scripts/fight3d/ReactionBubbles.gd), the headline card before the result page
  (scripts/rules/Headline.gd, scripts/ui/modals/HeadlineCard.gd). Notes: ops/research/LOOP_BUILD_UI_S442.md,
  LOOP_BUILD_BUBBLES_S442.md, LOOP_DRAWINGS_S442.md. Real stills on the review board.
- UX audit committed (ops/research/UX_AUDIT_S442.md): 17 fixes, Pulse.gd (one breathing button a screen), Tally.gd (money
  rolls). His opinion asks answered in chat: animated numbers (yes, short, skippable, particles only for milestones), the
  "visually engaging" table (yes, visual must carry the decision), the "Living Gym" text (take fighter states on the hub,
  the BOUT SIGNED stamp, a scale needle, a locker-room beat; refuse the gym-as-menu, stats without text, shake on every drop).
- RESULTDEFECTS1: 4 of 7 fixed (+ the damage tile's head); 3 measured, not changed (ops/research/RESULTDEFECTS1_RESULT.md).
  FOR HIM, WITH NUMBERS, NOT YET ASKED: the no-sparring rule gives 21 days off after 148 of 200 bouts (a lost bout carries
  about 55 head damage against a design figure of about 22).
- DEFECTS1 merged. R24GRADE1 (LineGrade.gd) collected. Result page: round 4 scored 6 and 6: THE LOOP IS STOPPED; his call
  on the shape is Q-S294-199 (summary + tabs, my recommendation, or one page). Round 4: docs/mockups/s442/result/.
- ASK FOR A FIGHT: map v2 after Kalli (5/6) and John (6/6); ASKPROBE1 delivered as PR 235 but its result looks too tidy
  (wait never wins). A blind reviewer writes E:/FightCamp/wt/LEAN_ASKPROBE1/ASKPROBE1_REVIEW.md. NOTHING DRAWN until an
  honest probe shows a spread.

## OPEN PRS / REVIEWS WHEN THIS WAS WRITTEN
- PR 235 ASKPROBE1, PR 234 R73DEAL1, PR 236 R19WORTH1, PR 237 MATPRICE1: two blind reviewers (helpers on Opus) write
  <TASK>_REVIEW.md in each worktree root, with fixes left uncommitted in the worktree. Read the review, check each fix,
  copy the files to main, run the tests, commit, close the PR. Do not merge on the seat's own word.
- Qwen queue: R29JUDGES1, R85NEWS1 (the dispatcher launches them; it waits while a windowed render runs on an AMBER PC).
- The lead S439 session: POWER1 steps 3-6 (collect against C314/C315: "a gymnastic extension move, not a punch").

## ON HIS BOARD (unanswered)
Q-S294-195 Cardio or Stamina as the one name; 196 fight screen regroup; 197 hover labels for secondary buttons; 198 Money
page on one screen; 199 result page shape; in chat: do the roster bars keep growing from zero on every visit (old rule)
or only move when changed (new rule; my recommendation). Review board: block stills (the jab ends under the guard: same on
main, item BLOCKLOOK1), the PA mix round 3, the three built features.

## NEXT, IN ORDER
1. The four reviews above: collect or re-brief. 2. His answers on the board, then: the result page in the shape he picks
(the coach critic's two musts go in either way: the best fix is BOTH plan changes, 100 of 200; "even the best plan makes
it an even fight"). 3. UX proposals he says yes to. 4. POWER1 collect. 5. Wiring: TraitLine on the fighter card, PlanPhase
and LineGrade in the Playbook, Towel in the corner minute. 6. Fire level on with a first-season re-measure. 7. The 3D
corner card is 924 px tall and reaches the bottom bar; "Fix: Chases the stoppage" runs under "Leave it": both need a
layout change in CornerOverlay (fold into the fight screen regroup if he says yes to 196).

## TRAPS (S442)
- A JSON file rewritten with json.dumps re-indents the whole file (media_comments.json, questions.json): keep the indent.
- seat_queue.py takes brief paths relative to ops/ ("research/X.md"), run from ops/.
- The dispatcher holds a seat until its own checks finish, and its checks wait behind windowed renders: a seat can look
  idle for 15 minutes. Collect the pushed branch yourself meanwhile; `seat_dispatch.py --act` launches the next brief.
- A Bash `cd` into a worktree moves the session's working directory: cd back.
SETTINGS: next session Opus 5.5 high, Fast off (critic rounds and three collects need judgement).
