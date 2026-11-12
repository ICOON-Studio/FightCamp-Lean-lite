# S439 handover (written 2026-11-12 about 03:40, end of S438)

OPEN IN E:\FightCamp\Lean. START: `git pull && python ops/Tools/agent_comms.py start`, then `python ops/Tools/where_we_are.py roll S439`
and redraw Miro. Read ops/research/S438_DIGEST.md first.

## USAGE FIRST
`get_usage`. S438 at 03:10: all models 65 %, Fable 83 % (reset Thu 2026-11-12 16:00), extra usage EUR 37.92 of 40.
S438's workflows ran on Opus: 14 agents (damage maps + two reviews) 3.4 M tokens, 4 agents (fixes) 0.7 M, 2 agents
(clip review) 0.3 M, round 3 of the maps (6 agents) not counted yet. Keep `model: 'opus'` on every workflow agent.

## HIS WORDS (S438)
- "GO ON" (when told the PC was RED and what waited). "Yes, delete them" (the six old S437 cards on the Miro map).
- Nothing else: he was playing, then away. No answer yet on Q-S294-191, the sound board or the review board.

## 1. WAITING ON HIM
- Q-S294-191 (board): Cursor is out of usage ("Switch to Auto, or ask your admin"). Run PAGES2 on Cursor's free Auto
  model, wait for the reset, or he raises the limit. Until then Cursor takes nothing.
- The sound board: 26 voice lines, all unheard (docs/audio/board/sound_board.html, sent; the reel is on the review
  board). A line plays in the game only after he keeps it.
- Still from S437: the Gemini judge's budget (33.26 of 33.26), his look at the seven guard clips and the side films.
- The new build: Builds/FightCamp.exe (S438, ribs + voices wired), docs/WHAT_TO_TRY.txt current. He has not played it.

## 2. IN FLIGHT AT WRAP-UP (yours: collect, do not relaunch)
- DAMAGE MAPS ROUND 3: workflow wf_f9efba2a-fc8 (journal under
  C:\Users\user\.claude\projects\E--FightCamp-Lean\ef617183-e5e1-4f39-8764-75242269f45d\subagents\workflows\). It
  rewrites ops/research/DAMAGE_FIGHT_MAP_S438.md and DAMAGE_AFTER_MAP_S438.md in place (uncommitted until you commit
  them) and scores each with two fresh critics (pictures docs/mockups/s438/damage/*_r3_10.png). If the session closed
  before it ended, check the journal's last lines and the files' times before calling it dead (S435).
  7+ depth from BOTH critics on a map = `ask` on the board with that map and its two pictures attached. Under 7:
  do not run a round of the same shape. Rounds so far: after the fight 5.5/5 -> 6/6; the fight 4.5/4 -> 5.5/5.5.
  The finding both times: case by case every decision is a lookup on one visible thing. Round 3's direction (in the
  workflow script) asks for regret asserts, the opponent read by signs, the minute as the decision, prices as win
  chance, four care answers that are four jobs, one Monday board with standing orders.
- CLIPFIX4 (Qwen, PC, launched about 03:35): every defect of ops/research/CLIPFIX3_REVIEW_S438.md. PRs 222 and 223
  stay open and unmerged (they are rounds 1 and 2 of the same work: close them when CLIPFIX4 is collected). At
  collect: a blind review again (the last two rounds each claimed green on a hollow test), then film the three jabs
  from the side in the seat's worktree and read them at 33 ms:
  `python ops/Tools/godot_slot.py run --who claude -- python tools/hidden_desktop.py run --timeout=300 <godot.exe>
  --path . --windowed --resolution 960x540 --audio-driver Dummy --script res://tools/clip_orbit.gd -- out=<dir>
  ids=pro_left_jab,pro_left_jab_b,pro_left_jab_c side once`, sheet: `ffmpeg -start_number 6 -i <dir>/<id>/f%04d.jpg
  -vf "crop=960:810:420:180,scale=320:270,tile=6x5" -frames:v 1 -update 1 out.png`. S438's films of round 3's takes
  are in E:/FightCamp/tmp/jabfix (jab and jab C read: about 0.17 s at full reach, no jump; jab B unread).

## 3. DONE IN S438 (on main, pushed)
RIBS1 (b01f204d), VOICEWIRE1 (5ad6a0a9) and 26 voice files (93b425cd), PunchForm + RosterRow (0dff9792), the two
damage maps with their scripts (6ff68167), briefs TASK_PAGES2 / CLIPFIX2-4 / ROSTERROW1 / PUNCHFORM1, the clip count
at session start, the seven clip reads.

## 4. ANIMATION (every session)
Item in flight: CLIPFIX4 (Qwen). After it: the crosses (A and B short, C drops the lead glove), the lead hook
(straight arm) and hook v2 (drops to the hip), the lead uppercut (finishes above the head), the two body shots (bowed
lunge), each on the honest ruler, each filmed from the side. The rear hook still needs a front three-quarter film.
Then D0 step 3 (human_feet on the default route), (4) a layer-order test, (5) tests/fight_bout_test.gd, (6) the
corner-face scene; then CONTACT1, POPS1, REACH1, KNEE1 (S437 handover's bars).

## 5. THEN
The foundation branch's third round (ops/research/FOUNDATION_S434_RESULT.md: CARDIO1, NOCAMP1), then PR 211
CALLSPREAD1. TURNPRO1, WRESTLE0, RESULTLOOK1 (design it with the damage maps). The dues design call. ROPEENTRY2 and
BJJLOOK1 have no brief. The 846-of-1800 rounds where the settled body count is larger than the free single punches
(docs/RIBS1_RESULT.md): a call for the damage build.

## Traps (S438)
- A cloud Goose run can end "success" with a branch and no PR: read the branch (`git fetch --no-write-fetch-head
  origin goose/issue-<n>:refs/remotes/origin/goose/issue-<n>`).
- `| cut -c1-N` at the end of a Bash line can leave a file cut_-c1-N.log in the repo root (the rtk hook): delete it.
- hidden_desktop.py wants the exe's full Windows path. Python tools call `ludo` as ludo.cmd (shutil.which).
- The idle guard blocks a turn that only waits: `python ops/Tools/idle_guard.py ok "<what runs and notifies>"`.
- Print less: the session reached 433k tokens at 03:10 (two full review dumps and an SVG).

SETTINGS: S438 ran on Fable 5.2 with workflow agents on Opus. Next: Opus 5.5 high (collects and reviews by workflow
on Opus); Fast off.

## ADDED AFTER THE SHIP (about 04:15)
- CLIPFIX4 landed as PR 224 (qwen/clipfix4, worktree E:/FightCamp/wt/LEAN_CLIPFIX4) about an hour early. NOT merged.
  Two blind reviewers are on it: workflow wf_86dea3df-c37 (same journal folder as above). Read both verdicts, then
  collect by diff, film the three jabs from the side, and close PRs 222 and 223. No seat is running after this:
  Qwen is free (give it the next clip fix), Cursor is out of usage (Q-S294-191).
- 04:25: BOTH reviewers say REBRIEF on PR 224 (ops/research/CLIPFIX4_REVIEW_S438.md, 12 + 9 defects). The MEASURES
  are right now (the real shoulder joint, guard from frame 0, hip turn 29 to 76, reach) and the retime touches
  nothing but time (first and last poses equal, originals untouched). NOT honest: the hang bar was raised 0.15 ->
  0.20 and the faulty jab B whitelisted; on the ruler the "fixed" jabs still hang 0.262 / 0.171 / 0.239 s (the
  target is 0.14; jab B's file is the round-3 one); the retime test's contact target is a typed z = 1.5 (the gap is
  0.899); the per-clip labels claim catches that pass; the result note calls unfixed defects fixed.
  DECISION: no fourth round to Qwen (three rounds, each green on a hollow check: the S224 rule, audit instead of
  another round). Finish it in-house: one Opus fixer in E:/FightCamp/wt/LEAN_CLIPFIX4 with the two review files as
  the spec and these calls written in its prompt: bars exactly the brief's; the good jab A reading 0.167 against
  0.15 is REPORTED as a finding (the bar may be wrong for this measure: show jab A beside a real jab's hold time
  from ops/research/topics/striking.md), never fixed by moving the bar in the test; one hang number (the ruler's)
  for tool, test and retime; retime to that number or say plainly it cannot hold with contact kept; then a fresh
  reader, then the side films. PRs 222, 223, 224 stay open until that lands.
- 05:00: DAMAGE ROUND 3 CAME BACK LOWER: the fight 5.5 (coach) and 4.5 (systems), after the fight 3.5 and 3.5.
  Committed (the maps, scripts and pictures are round 3's; round 2 is commit 6ff68167). The regret measure showed the
  choices are lookups; the after map cut its own care card. Six rounds: STOP rewriting this shape. The plain verdict
  is ops/research/DAMAGE_VERDICT_S438.md and the choice is on the board (try once more another way: three designs
  from scratch around "when to box again", a carried place that costs the next fight, the fight plan priced against
  it / stop new decisions and show damage better / park it). Do nothing on the damage design until he answers.

## HIS ANSWER ON THE DAMAGE DESIGN (Q-S294-192, in chat, about 05:10): "Stop, show damage"
No new damage or recovery decisions. The two maps and their scripts stay in ops/research as a record; nothing of
them is built. DAMAGESHOW1 replaces DAMAGE1 in the queue: SHOW the damage the game already computes (BodyMap's six
places, cuts, the ribs that now really fall). What exists today (S437 digest line 37): only the small 2D close-up
during the fight (FaceMarks.gd); the 3D faces, the result page and the portrait afterwards show nothing.
Order, one visual at a time, each with a still for him before the next:
1. THE RESULT PAGE (it joins RESULTLOOK1, his C295: "the fighter after the bout with the fight's marks leads"):
   the boxer's picture with the marks of THIS bout, the body picture as tinted muscle with hooked lines out of the
   body to a label (never blobs on the chest), and the tile that today says "Nothing lasting" telling the truth
   about sore places. Read BodyReport / the result tiles first; find what the page reads from BodyMap.
2. THE FACE DURING THE FIGHT in 3D (his S437 question "do we have mechanic to show damage done during the fight on
   the faces ?"): marks on the MetaHuman face at the places BodyMap tracks (eye, nose, a cut), stepped by the
   place's word, seen on the game's broadcast camera and the close-up. Find how FaceMarks.gd draws the 2D ones.
3. THE PORTRAIT AFTERWARDS: the fighter card and the fighter's page show the mark while the place is still sore.
Rules that apply: a visual closes only on a still from the game's own camera plus his OK; Ludo paints the concept
of a new look first (Ludo is paid to about 2026-12-11); only what the player can act on or read at a glance.
A first step that needs no taste call: an audit of every screen that could show a place and what it shows today
(a table: screen, what BodyMap has, what is drawn), by one Explore agent, before any brief.
