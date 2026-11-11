# S433 handover: five collects in, the stepping fight is the default, Ludo's paintings wait for his pick (written 2026-11-11, end of S432)

OPEN IN E:\FightCamp\Lean. START: `git pull && python ops/Tools/agent_comms.py start` (now ~14 s and ~160 lines, S432),
then `python ops/Tools/where_we_are.py roll S433` and redraw the Miro map (recipe: ops/Tools/where_we_are_svg.py docstring).

## USAGE FIRST
`get_usage` before anything. At S432's end: weekly Fable 68 %, all models 35 %, extra usage EUR 37.92 of 40. Fable resets
Thursday 2026-11-12 16:00 local. Before the reset: no workflow, no critic round. After it: still check before each launch.
S432 ran on Opus 5.5 with no workflow and reached 400k context with five collects: one stage of collects fits a session.

## HIS WORDS IN S432
- "make other active sessions to report here" -> HUMANFIGHT1 ([42c713]) and the busy start session ([51682f]) were told to
  report to S432's main session. Neither answered; both idle. A new main session tells any live one its own name again.
- "check if you can trim the session start because it starts to take too long" -> done (commit 33466aa0): runs collected
  by diff are closed automatically once their PR or issue is closed (30 sat 'landed' and were re-checked on GitHub at every
  start); triage is `--full` only; THE QUEUE block is the board plan; old milestone / THEN / per-seat notes `--full` only;
  board_sync keeps roadmap.json's indent (indent 2 made every sync an 11k-line diff).

## 0. OPEN QUESTIONS (on the board)
- Q-S294-185: which Ludo painting to build the two pages to (3 per page on 8787/review; painting 1 of each sent to him).
  On his answer: ONE Cursor task per page (Fighters page first, then the Profile), the painting as the look target, the
  mockup docs/mockups/s431/final/*.html as the layout and words. Small numbers in the paintings are garbled: the game draws
  the real ones. Still open inside it: Ana needs a BJJ body chart; the top bar's 15-16 px lines.
- Q-S294-184: map v3 (critics after the reset, or measure the prices first). My lean: measure first.
- Miro: 14 leftover card slots of the P0 frame sit below it (the frame cannot shrink until they go). Deleting needs his yes
  (asked at the end of S432). With it: `python ops/Tools/where_we_are.py svg`, send it WITH its data-deleted lines, then a
  second call for the frame size.

## 1. WHAT LANDED IN S432 (main, pushed)
- HUMANFIGHT1 collected by diff (79665239); THE STEPPING ROUTE IS THE GAME'S DEFAULT (his Q-183): RkClips.enabled is opt-in
  (`-- rokoko`); rokoko_clips_test and human_feet_test opt in. Film E:/FightCamp/tmp/s432_route/men.mp4: 0 airborne frames,
  slide 0.7 / 0.5 m a minute, pro_ clips only. PRs 163, 168 (leg tremble) closed.
- TRAININGB2 (df98308f) with the S431 review's fixes; Start week back on the 1080 screen. Still docs/mockups/s432/trainingb2_23e_real.png.
- AIMWIRE1 (Qwen): rib calls and the body-on-tired bonus reach the fight; the liver side opens first by her stance (changed
  at collect: 50/50 made two twin buttons). Not delivered by the seat: the aim plans measured over a year; the fight-toll numbers.
- CAMLINE2 round 1 (b2568842): hidden 0.63 -> 0.23 s, behind 0.80 -> 0 s, split ropes 1,889 -> 0, one faded-rope read left.
  Round 2 (unverified) saved on branch claude/camline2 as a WIP commit, NOT collected. Gloves' smear not re-measured.
- DUESSUMS2 (Qwen): 0 balanced sets of 972. Why: a full 40-place club gives every band the same total at any reputation, so
  Premium can never win the small famous club. Next lever: a waiting list (ops/research/DUESSUMS2_RESULT_S432.md).
- DUESBAND1 closed (it was collected in S424).
- Exported Builds/ (13:14; the exe ran 300 frames headless with no script error). WHAT_TO_TRY.txt has S432's four items.

## 2. RUNNING
- HUMANFIGHT2 on Cursor (worktree E:/FightCamp/wt/LEAN_HUMANFIGHT2, branch cursor/humanfight2, brief
  ops/research/TASK_HUMANFIGHT2.md): the animation round - pops at clip starts, the range picks the punch, one-frame
  contact with the reaction on it, posture limits, ruler first. Collect: its ruler red on main, every bar in
  docs/HUMANFIGHT2_RESULT.md, read its film and sheets yourself. No critics unless he says.
  HUMANFIGHT1's last report (S432, by message): for the stepping route the two round-3 critics ALSO asked for a taller
  stance (knee bend 125 deg now; a boxer stands 145-160) and feet that move in exchanges (a rear-heel pivot on the right
  hand); and the knee-jerk count (230-290 a knee in 75 s) was never chased. Not in HUMANFIGHT2's brief: they are the
  round after it (HUMANFIGHT3), unless its ruler shows them first.
  What he was told about animation (S431, confirmed by its report to S432): code owns the feet and the distance on the
  stepping route, four code fixes, captured clips back one at a time; we hold 182 boxing clips (165 from the bought
  pack: 39 hit reactions, 17 idles), so the clip count is not the limit - check those before sourcing any.
  CAMLINE2's round-2 WIP commit on its branch holds two debug scripts (tools/_cl2_dbg.gd, tools/_cl2_pose.gd): never collect them.
- DUESSUMS3 on Qwen (worktree LEAN_DUESSUMS3, brief ops/research/TASK_DUESSUMS3.md): the waiting-list lever, the search again.
- CORNERFACE1 on Qwen (the corner minute's camera keeps the face in view).
- SQ41 John (how big fight games build their animation) queued.

## 3. NEXT, IN ORDER
0. HIS S432 ANSWERS AFTER THE HANDOVER: Q-184 "i want v3 reviewed by critics . see if we can deepen and stregthnen and add if
   required any new mechanics , before we start building we need to decide if we done with the mechancis for this version"
   -> workflow wf_f0541204-ae8 (critics on v3 -> map v4 -> critics -> verdict in docs/mockups/s432/critics/VERDICT.md).
   Then "i want a bit more rpg elements with coach and fighters" + "yes add the rpg layer after the review" -> RPGLAYER1:
   on the reviewed map, the coach grows (experience, an either/or perk at each step), a bond with each fighter, a coaching
   style, traits that change through play, fighter moments; every piece on a screen and tied to the week; two fresh critics.
   Already built (do not redo): Recruit class/stars/traits/habit/signature/ambition, PerkRoad, CornerTrust, HeadCoach
   background, CoachAreas. Miro ideas: idea backlog (trust meter, loyalty vs money), twist cards (old coach visits).
1. His answers (Q-185, Q-184) -> act.
2. Collect what lands (HUMANFIGHT2, CORNERFACE1).
3. DUESSUMS3 brief (Qwen): the waiting-list lever in DuesLevers, the same 972-set search plus that lever.
4. Aim plans measured over a year (own game / body / head / body then ribs): a harness that plays aim plans.
5. Cursor after HUMANFIGHT2: FACEFRAME1, DUESWIRE1, GYMLIFE1 (the dispatcher queues them).
6. Ziva is DOWN: restart it when no render runs (the start prints the command).

## Traps (S432)
- tools/export.sh: Godot crashed on exit (segfault) AFTER writing the exe and pck; smoke-run the exe
  (`godot_slot.py run -- E:/FightCamp/Lean/Builds/FightCamp.exe --headless --audio-driver Dummy --quit-after 300`, full
  path) before trusting it.
- A Godot command inside a shell heredoc is blocked by rule_guard: write the runner with the Write tool
  (the S432 runner: 3 tests at a time, prints each test's last line - read the pass line, not the engine's leak line).
- `agent_comms.py ask --attach` wants an absolute path.
- A seat's "test passes" can be a dropped check: DUESSUMS2 removed the brief's own red check; AIMWIRE1 printed tables nobody
  asked for and skipped the year measurement. Read the brief's numbered checks against the test.
- `cd` in a Bash call moves the working directory: start each command with `cd /e/FightCamp/Lean`.

SETTINGS: S432 ran on Opus 5.5, default effort, no workflows. Next session: Opus 5.5 or Fable 5.2 at default effort, Fast
off; workflows only after Thursday 16:00 and only for a job that needs them.
