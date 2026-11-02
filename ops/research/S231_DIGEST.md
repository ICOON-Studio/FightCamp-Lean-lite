# S231 digest (2026-10-16) - promoters + away circuit, gain bubbles, Paul the PM bot

## Operator rulings this session (verbatim)
- Q-S225-11 xAI top-up: "No, use Dola/other seats for research" - then in chat: "5 euros added on xai api".
- "setup a project manager bot to review and update the board and guide you and dola and whatever else a project manager does"
- "where can i communicate with paul ?" / "paul's latest review link is not working" (fixed)
- "also add duration on tasks,runing pids on board" -> then "remove the new processes on this pc panel and add the running time on the existing tasks under running now"
- Q-S225-12 away circuit: "Yes, build it"
- Q-S225-13 day-goal plate: "Build Kalli's version"
- Q-S225-14 Codex freeze for the animation chain: "Keep the freeze - Ludo writes them"
- Paul P2 (board box): "organize thr project progress and structure to speed up production , automate processes to lower claudes workload and keep costs low , plan ahead to meet all projects needs"

## What now works (evidence)
- Catalog v4 (e190dd3b): 10 pro boxing promoters where John PROMOTERS1B and SuperGrok Expert agree, every official URL
  checked by page title: Matchroom, Queensberry, BOXXER (UK); Top Rank, Golden Boy, PBC (USA); Ohashi, Teiken (Japan);
  RCC Boxing (Russia); Eye of the Tiger (Canada). Zanfer + Max Power left out (no working site). S5 amended by the ruling
  (PROMOTERS1B note). Count pins 45 -> 55.
- Card fill (2dc88184): no boxer on two scheduled cards; 4 free athletes per sport kept for recruiting (catalog v4 had
  booked all 11 UK boxers - floor_gain red, now green; fight_camp + amateur_offer green too).
- AwayCircuit (7af7d0c2, Arena PR #206): pure module, 79 checks, control mutant goes red. Wiring = AWAYCIRCUIT2 (Arena).
- Gain bubbles (0d895be4, a4bd80cb): Ludo r92 GainBubbles on GymHall3D._float_text behind gain_bubbles (GAME_ON);
  fixed-size discs ~40 px, private RNG; gain_bubbles_test 25 checks. Still on the board (review) + sent.
- C72 (03f1686f): the day strip is 56 px like the money/countdown blocks; top_bar_timeline red on master -> green.
- STRIKEPIN1 (40b6b0b4): R16 pin from Grok Dev; OFF boxing pinned from the PC run (Grok's cloud value did not reproduce).
  CORNERCONTRACT1 rejected (refusal instead of proof) - NIGHTLY1D.
- Paul (5bf29535, c3bb65f5, 77031f73): Tools/pm_bot.py + xai persona "pm"; snapshot rides inline in the workflow (no
  commit); board main page: Paul panel, latest review link, message box (wakes `pm_bot.py ask --wait` hidden), standing
  rulings in his snapshot; reply collected from the run artifact when the push 500s (workflow now warns instead of failing).
- Board (255c0943): "running for" timer on every Running-now card incl. Claude's items; processes panel removed;
  idle Codex runs archived.
- Profile viewer gloves (this digest's last commit): ProfileStage mounts the fight's procedural ruleset gloves
  (operator C81-C84 bare splayed hands); profile_stage_test checks two gloves.

## Research collected
LUDO_ROUND91_REPLY_S230 (AwayCircuit), LUDO_ROUND92 (bubbles), PROMOTERS1B_JOHN_S231, K86 (Kalli day-goal words),
M43 (Maria jab/guard bar - binding numbers), D69 (Dola: CMU subject 14, MoCap Online punch pack, MyBoxingCoach),
VERDICT_AWAYCIRCUIT_S231, PM reviews in AgentComms/pm/.

## In flight (collect next session)
- Arena SPLITFIX1 (chat 01a1448f) - game_training_split fixture pinned (red on master before v4).
- Arena AWAYCIRCUIT2 (chat 01a144cf) - away offers on get_fight_offers for Cyprus.
- Goose DAYGOAL2 (issue #207) - Kalli's plate + payout.
- Ludo r93 (Browser 1, FightCamp project, newest chat) - JabShape.gd + LiveGuard.gd + tests.
- Goose KICKREACH1 (#194), Cursor UICARDS1 (#201) - older runs.

## Open defects
- 5 Cyprus offer reds (offer_desk, short_notice, weight_cut, event_night_backend, events_revamp_backend) - short-notice
  slots on CYPRUS cards; not solved by away offers. Investigate against 2dc88184 + 1922a0cc.
- Jab/hook/guard visuals (C70, C80-C84) - Ludo r93.
- Floor: C78 empty training area + C79 models, C76 reception wire-in, C74/C75 room stills without the panel.
- Bubble-still comment never reached the board (comments file last written 15:15) - ask the operator to re-post.

## Decided by Claude (no question needed)
- Paul's snapshot carries the operator's standing rulings (his first review planned Codex jobs).
- class_name dropped in GainBubbles (headless --script cache); preload instead.
- Opening cards keep their pairing; only the fill pass enforces the recruit reserve (a skipped opening card removed
  calendar dates in small markets - fight_camp red).
