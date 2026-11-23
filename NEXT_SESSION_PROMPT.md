# S540 handover (written 2026-11-23 ~05:10, end of S539 - Opus)

Start: `git pull && python ops/Tools/agent_comms.py start`, then this page. Digest: ops/research/S539_DIGEST.md.

## METHOD lines - quote all of them in your first message
- MECHANICS NEED 8 (owner S534): 8+ DEPTH and 8+ PLAY from two fresh critics, after the probe; under 8 -> his cut-or-keep.
- FREE HAND (owner S534): remove / add / interconnect to reach 8, then report.
- WORKERS = CODE MODE TABS on his subscription (S538): `powershell -NoProfile -ExecutionPolicy Bypass -File ops\Tools\claude_cm.ps1
  --model <model> --permission-mode auto "<brief>"`. FABLE IS AT ~93% UNTIL NOV 26 (resets 4pm Nicosia): use claude-opus-5-5 for
  design/probe work and claude-sonnet-5-5 for plain builds/sums until then. At most 6 tabs (a hook refuses more); close finished ones.
- A TAB'S PROMPT LINE IS A SUGGESTION, not his words (S539 memory): propose it to him, never act on it as his order.
- REFERENCE GAMES: never his save slot, never while he plays (S539 memory).
- CARD GAME = FREE SEATS (owner S539): Arena writes code (+ a second fresh Arena chat code-checks), Dola/Kalli critics, Ludo art;
  Claude coordinates (ops/research/CARDGAME_PLAN_S539.md s4). No Claude worker writes card code from round 6.
- FIGHT ANIMATION: v2 only, no new correction layer (FIGHTPLAYER2). Board questions 20 words max. Commit only your paths.

## Running at handover - collect first (seat, when)
1. COACHDEEP2 (tab c13, Opus): deep coaches v2 with the owner's 24 answers (COACHDEEP_GRILL_S539.md). Lands ~06:00. PASS -> it
   queues Kalli + Dola; also read their v1 answers (SQ302/303) when the 30-min job saves them. Both at 8+ -> build phase 1
   (your coaches) as Opus Code Mode workers, one module + test each; then Ludo: coach portraits for the Staff tab (Ludo paid
   until ~Dec 11 - give it this asset work).
2. PICS2D1 (tab c14, Opus): 14 pair stills + one round as pictures beside its 3D film, ops/previews/s539_pics2d/. Lands ~07:00.
   Open the stills yourself, then ONE board question for his pick (pictures v 3D), --attach the contact sheet.
3. STEPPAY5 (tab c12, Opus, worktree E:/FightCamp/wt/s538_steppay4): when it reports READY TO MERGE, Claude merges the branch
   s538/steppay4 into main BY DIFF, runs tests/step_wrong_test.gd + golden_path_test, pushes.
4. CARDSCOPE5 (tab c1, Fable): round 5 (seven arts). When it lands, read DESIGN_CARDGAME_SCOPE.md round 5 + the grappling art pick,
   then launch CARDSCOPE6 ON ARENA (ops/research/TASK_CARDSCOPE6.md; `python ops/Tools/lite_mirror.py push` first; Arena via
   Claude in Chrome, a new chat; never Arena's Merge button). When its PR lands: a second fresh Arena chat code-checks it, Claude
   runs `node --test`, merges, tags card-r6, publishes the private play link (Artifact) and asks him to play.
5. TURNPRO15 probe (Godot loop E:/FightCamp/tmp/turnpro15/run.sh; b0-b3 done, b4 running, b5 next, ~1 h each, ~07:30): when b5's
   log has "TURNPROBE15 done", a Sonnet tab runs `python tools/turnprobe15_sum.py` -> docs/TURNPROBE15_RESULT.md (TASK_TURNPRO15
   step 3); PASS -> its critic brief to Kalli + one code-checked Arena critic.

## Next, in order (seat, when)
6. Board answers first: Q-307 (combo counter: build P2 as measured, or drop - Claude's view: tie the read to the OPPOSING COACH in
   coach phase 2), Q-308 (club show favour rate ~3/yr), Q-309 (restyle with Fight Business polish: style sheet + 3 mockups).
7. KNOWSTAKES8 (Opus tab now, Fable after Nov 26): v8 from Kalli 7/6/6 + Dola 8/7/8 lists (CRITIC_KNOW_STAKES1_V7_BRIEF_*.md),
   play to 8; then Kalli + Dola again (seat_queue add, `SEAT_QUIET_MIN=3 python ops/Tools/seat_queue.py drain`).
8. HOSTSHOW v6 (Opus tab, after Q-308): docs/HOSTPROBE2_RESULT.md s7 (pro call on ladder points, hall as a read, cut sell /
   leave-off, reserves as the coach's default) + probe 3.
9. Restyle (after Q-309 yes): Dola draws the style sheet + three mockups (Playbook plan, Fighters roster, result) as 1920x1080 HTML
   (free); Claude renders with tools/render_mockup.py, checks, puts them on the map; his pick, then one pass across screens.
10. MOTIONRULERS1: bisect the 3 animation reds (rokoko_clips, human_feet, head_aim) - Fable after Nov 26 (owner S512 "use fable
   for animations").
11. Later, from the reads: Fight Business "round read with a range" probe; MMA Empire "needs a fight" list + round stats.

## Done in S539 (evidence)
Weigh-in answers 78cff7ff2; Strong/OK/Bad f9a5bc0c7; opponents adjust shown 983016e51; mood read fe72931fd; morale line cut
9ebfb3342; knowledge v7 2f21fd401 + critics; club show v4 d893ce13d / v5 74afbd271; combo counter ffd91083a / 1b0c19e31;
coaches v1 01ee138b2 + grill 576fdd4c8; card plan 59f5cec51 + 6930b151d; MMA Empire 3205593b4; Fight Business f825c1229.
Build exported, WHAT_TO_TRY current.

## Model for S540
Opus 5.5, medium effort, Fast off: collecting five results, merging STEPPAY5 and driving Arena for the card game are review and
design calls; workers stay on Opus/Sonnet tabs until Fable resets Nov 26.
