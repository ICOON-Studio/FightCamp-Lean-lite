# S432 handover: the matched look is with him (Q-182); three jobs of S431 to collect (written 2026-11-11, end of S431)

OPEN IN E:\FightCamp\Lean. START: `git pull && python ops/Tools/agent_comms.py start`, then `python ops/Tools/where_we_are.py roll S432` and redraw the Miro map.
S431 has no digest: its facts are here, in roadmap.json `now` and in memory (project_s431_look_matched_usage).

## USAGE FIRST (this bit the session)
`get_usage` before anything. Weekly Fable went from 24% to 60% in about ONE HOUR of S431 (four workflows of this session
plus the HUMANFIGHT1 session). Reset: Thursday 2026-11-12 16:00 local. Extra usage EUR 37.92 of 40 (2 left). His word
(S429): burn it, but make it last to the reset. So before the reset: NO workflow, NO critic round, no fan-out of agents
unless weekly Fable is under 70% and the job is small. One review of 444 lines cost 1.9M tokens (three readers + twelve
skeptics): next time two readers and skeptics only for findings that block.
Also: hand over when the context passes about 420k; S431 passed it at 465k before noticing.

## HIS WORDS IN S431
- "inform other running sessions to report to this one" -> HUMANFIGHT1 (session local_f2068222-ae6c-4eb3-8a8b-b3a826700139)
  now reports to the main session by message. A new main session must tell it its own id the same way (SendMessage to
  that local_ id), or its reports go to the closed S431 session.
- "check board comments" -> four read (media_comments.json C287 to C290):
  - Overview A: "looks nice , change \"Engine\" to cardio". The body chart is kept as drawn; the stamina group is "Cardio".
  - A fight-week drawing: "stop using nicknames for people use cach instead and" (cut off; he means Coach). Staff are named
    by role on screen ("Coach", "Coach's evenings"), never a bare surname. If he says what came after "and", apply it.
  - "looks nice" on docs/mockups/s430/fourstart_10_fm.png and amateurweek_10_cards.png: the base of map v3's drawings.
- "yes delete the old miro cards" -> done: 12 surplus slots, two orphan cards inside the frame, four stray cards outside
  it. The frame is back to its size and the ledger (ops/AgentComms/where_we_are_miro.json) matches the board.

## 0. HIS THREE ANSWERS AT THE END OF S431 (read questions.json to confirm each)
- Q-S294-182 (the matched look): "Yes, paint and build both" (board). FIRST WORK OF S432: Ludo paints the Fighters page
  and the Profile from docs/mockups/s431/final (his S400 rule; `ludo` skill, image edit over the mockup; uses his Ludo
  subscription, not Claude usage), he sees the paintings, then ONE Cursor task per page. He said yes to the set as shown,
  so the four judge additions (mood, Cut, the four faces, the rank line) stay in. Still open inside it: Ana needs a BJJ
  body chart; the top bar's 15 to 16 px lines.
- Q-S294-183 (the fight route): "Older stepping route" (typed in the old S430 session, recorded on main by it, section 3).
- Q-S294-184 (map v3): asked with the three drawings (clubweek_v3, fightweek_v3, road_v3) and the map
  ops/research/CLUBWEEK_MAP_V3_S431.md. Options: two critics after Thursday's reset / measure the prices first / change
  something. NOT answered when S431 ended. My lean: measure first (the prices are guesses; measuring runs on the seats).

## 1. HIS PICK: Q-S294-182, the matched look (pictures sent, on the review board)
`docs/mockups/s431/final/`: side_by_side.png, overview.png (the fighter Profile = his body chart), squad.png (Fighters,
all four), notes.md, build.py (writes both pages; one line per judge addition, easy to take out).
The gym screen is untouched (reference: docs/mockups/s431/ref/gym_screen.png, rendered from the build). Wood stays only on
the top bar. No new menu bar: the gym's pins stay the way around, a Gym button brings you back, six tabs a fighter.
Three blind judges scored the BASE set 8, 7, 8; the merged final was not re-scored.
He must still decide: (a) four additions all three judges asked for beyond his six changes (mood row, "Cut" on an
over-limit weight, four faces to step between fighters, a rank line); (b) the top bar's 15 to 16 px lines break his 20 px
rule but are the gym screen's own; (c) Ana (BJJ) is drawn on the boxer's chart and needs her own.
After a yes: Ludo paints both (his S400 rule), then ONE page per Cursor task. The other pages (Training, Playbook, Fight
plan, History, Condition) get the same look one at a time.

## 2. COLLECT what S431's workflows left (they die if the S431 session was cleared; the files stay)
- CAMLINE2 (the fight camera, ruler first): worktree `E:\FightCamp\wt\LEAN_CAMLINE2`, branch `claude/camline2`. At wrap-up:
  commit 7fc41b69 "the ruler, red on main" was in; the fix pass (RopeFade.gd split first, then the angle, ropes, lens
  numbers, gloves by measurement) was running, with two critics after it. Read docs/CAMLINE2_RESULT.md on the branch
  (BEFORE and AFTER numbers), the stills in E:/FightCamp/tmp/s431_camline2/, then collect by diff + parse + the contract's
  tests + your own film. If the fix pass never finished: brief is ops/research/TASK_CAMLINE2.md, the review of the first
  attempt is ops/research/CAMLINE1_REVIEW_S431.md.
- MAP V3: `ops/research/CLUBWEEK_MAP_V3_S431.md` + `docs/mockups/s431/clubweek_v3.png`, `fightweek_v3.png` (one map: the
  club week for four WITH the fight weeks; three fact-checkers, no scoring critics; it was in its revise pass). Read it,
  check the two drawings are whole, send it to him (his Q-179: "Show me the maps first, no critics"). Critics only on his word.
- TRAININGB2 (Cursor, PR 194, worktree LEAN_TRAININGB2): NOT collected. Its own still
  (docs/mockups/s429/trainingb2/23e_training_tab_real.png on the branch) shows the week's tiredness numbers and the label
  "80: too tired, injuries rise" struck through by their own lines, and "32 under the line" crossed too. Collect by diff,
  move those labels clear of the lines, parse, week_b_test + the contract's regression, render, read. The two-reader
  review is in `ops/research/TRAININGB2_REVIEW_S431.md`: nothing blocks, ten fixes at collect with the exact lines
  (numbers above their dots on a dark plate, plates behind the two line labels, floor instead of round near 80, tooltips
  that can open, three regression results that were never proven: run them yourself). ALSO A DEFECT ALREADY ON MAIN that
  it found: with two "Held at 48 by the Cross" lines (WEEKTESTS1) the Training tab's bottom row (Do it, Leave, START
  WEEK) is pushed off the 1080 screen. Fix it in the same collect and render a week that shows it.
- DUESSUMS2 (queued for Qwen, goes to Goose when the daily cap allows): read its tables. DUESSUMS1's result:
  ops/research/DUESSUMS1_RESULT_S431.md (0 balanced sets of 243; the volunteer saving is far too strong; Standard wins
  nothing in 203 sets). Its files stay on goose/issue-193, not on main (the test is red by design).

## 3. HUMANFIGHT1 (separate session): HIS DECISION IS IN
HE CHOSE (chat, in the old S430 session, after reading the scores): "Older stepping route". So the next animation round
builds on the route with the captured takes OFF (`-- norokoko`, critics 4 and 4, support-foot slip 0.7 m against 14 m),
and captured takes come back one clip at a time once they pass the posture limits. This reverses his S399 call on the
takes, by his own word; Q-S294-183 is marked answered. To do: (a) collect `claude/humanfight1` by diff (read the two
edited tests first), (b) make the stepping route the default the game plays, with a film read by you, (c) brief the next
round, in this order and none of it a leg layer: a per-frame pop cap on the shown pose and a 4 to 6 frame blend at every
clip start; a reach band per punch checked before it starts; contact for ONE frame then the hand comes home, with the
reaction on that frame; posture limits on every clip (trunk lean, knees over feet, gloves between belt and eyebrows).
Then the clips: trim or replace the few bad ones (a dodge and a weave that show the back, a body shot bowed flat, a
20-frame wind-up), a living idle (the idle is 42 to 48 % of a round), more hit reactions, a rear-heel pivot on a right
hand: check what we own before sourcing any. My estimate, told to him as an estimate: the code items alone reach 5 or 6;
7 also needs the clip work and one shared stance. Budget: a round costs a large share of the weekly Fable allowance.
The notes below were written before his answer.
Feet are fixed (0 frames airborne, 0 under the canvas; support-foot slide 30 m -> about 10 m a round). Critics: 3 and 3,
then 3.5 and 3: close range (punches do not stop on the target, hits barely felt, pops, statue-like waiting).
Its finding: what the critics ask for describes the route the game had BEFORE the captured takes (`-- norokoko`, still in
the code): on that arm the foot slide falls to 0.7 m in 75 s. It was scoring that arm with two last critics and was told to
stop after it, write both sets of scores into ops/research/HUMANFIGHT1_DIGEST.md on `claude/humanfight1`, push and wait.
FINAL REPORT (after this page was first written): it STOPPED after round 3, NOT at 7/10. Branch pushed at 0ef2213f (17
commits). Six fresh critics: default route 3 and 3, then 3.5 and 3; with the captured takes off 4 and 4. Not fixed in
either route: punches do not stop on the target, hits barely felt, one-frame pops, clip content. ASKED HIM AS Q-S294-183
with both films attached and sent: read his answer first. The session is stopped and waiting; it does nothing more
until told (and it reports to the S431 session id: tell it the new one).
WHICH ROUTE SHIPS IS HIS CALL (he asked for the captured takes back in S399): put both films in front of him
(E:/FightCamp/tmp/humanfight1/r2/men.mp4 and r3_norokoko/men.mp4) with the scores. Collect the branch by diff only after:
it edited two existing tests that hard-coded old distances (tests/body_keep_test.gd, tests/range_breath_test.gd): read
those two edits. PRs 163 and 168 (leg tremble) do not touch the causes it found: close them when HUMANFIGHT1 is in.

## 4. Seats
Qwen: AIMWIRE1 running; then CORNERFACE1, DUESSUMS2. Cursor: free after TRAININGB2: FACEFRAME1, DUESWIRE1, GYMLIFE1 (the
dispatcher launches them; all contracts valid now). Ziva is DOWN (not restarted beside the films): restart it when no
film renders.

## Done in S431 (main, pushed)
- CAMLINE1 rejected with reasons, PR 192 closed; PRs 190 and 191 closed (already collected in S430).
- tests/camp_protocol_test.gd reads the tiredness carried in BEFORE the bell (main CI was red since S430's fight toll).
  READ THE CI RUN on that push (45f105cf) at the start: it was not finished when checked.
- Contracts repaired: AIMWIRE1, CORNERFACE1, DUESWIRE1, FACEFRAME1, HUMANFIGHT1. New briefs: CAMLINE2, DUESSUMS1, DUESSUMS2.
- Miro P0 redrawn, leftover cards deleted. P1 to P9 untouched.

## Not done, say so
- No export this session: nothing playable changed on main. Builds/S430 is still not moved into Builds/ (his game was
  closed when checked; do it at the next start if it still is).
- Kalli's corner answer (ops/research/K_CORNER_MORE_S427_BRIEF_KALLI.md) still unread. The round board on the fight bar
  is still narrow.
- E: 34 GB free (AMBER). Nothing deleted: ask him which scratch renders under E:/FightCamp/tmp may go.
- tests/head_aim_test.gd has an uncommitted change from before S429: not mine, left alone.

## Traps
- A python heredoc in the shell broke on an apostrophe AGAIN (the roadmap update): write the script with the Write tool
  into the scratchpad and run it.
- A workflow script's strings: an apostrophe inside a single-quoted JS string is a parse error (the look workflow failed
  to start once on "the gym screen's").
- Miro: a frame will not shrink while any child sits outside the new bounds, and it applies the frame change before the
  deletes of the same call: delete first, resize in a second call. Read the frame's lower half with canvas_read_as_svg
  (scope) to find orphans the ledger does not know.
- `where_we_are.py svg` prints "TRIM ... n surplus" for any stale ledger key, even ones it does not mark for deletion.
- `cd` into a worktree in a shell call moves the session's working directory: start every command with `cd /e/FightCamp/Lean`.
- Read his board comments (media_comments.json, `seen_by_claude: false`) at the start: `start` did not print them.
- Every Godot job through `python ops/Tools/godot_slot.py run --who claude -- <command>`; films need `--timeout=580`.
- CornerBar.gd 471 lines, SidePanel.gd 470, BoutNight.gd 471, LiveRound.gd 469, GamePlan.gd 499, UI.gd 498, RingCamera.gd 500.

SETTINGS: S431 ran on Fable 5.2, high effort, with multi-agent workflows on. Next session: Fable 5.2, default effort,
Fast off, workflows OFF until the Thursday 16:00 reset: the work is collects with renders and his two picks.
