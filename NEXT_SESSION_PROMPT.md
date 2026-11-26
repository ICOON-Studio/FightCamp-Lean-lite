# S566 handover (written 2026-11-26, S565 - Fable 5.2)

Start: `git pull && python ops/Tools/agent_comms.py start`, then this page, then `ops/research/S565_DIGEST.md`.

## METHOD lines - quote all of them in your first message
- ## METHOD - RING SWITCHES IS THE MAIN LINE (owner S553, S555). The pages: `proto/twohands/order.html` (boxing, the
  source), `punch.html` (order.html + the Puncher's chance switch: BUILT by `python proto/twohands/tools/make_punch.py
  [tweak.json]`, never edited by hand), `kick.html`, `head.html` (head movement, with its own pictures since S561),
  `body.html` (the lit-limb toy). The rules sit above each page's `// ---- the page` mark.
- ## METHOD - THE SLICE IS BALANCED ON THE INSTRUMENT, NEVER BY HAND (owner S555). A change is a tweak file first;
  `node proto/twohands/tools/balance.mjs table` + `play n=84`; rules_test 37, kick_test 12, head_test 11, punch_chance_test
  13, page_parse, page_play_test 4 (`page_play_test.mjs punch.html` for the copy). A weaker strike lands MORE.
- ## METHOD - THE FIGHT MUST BE SEEN: HIS CAMERA (S559 #16), one fixed ring camera, every render `south=blue`. A new rule
  or picture is proved SHOWN with `node proto/twohands/tools/beat_shot.mjs <out> <page> '<beats json>'` (headless Edge;
  it prints the pictures a beat played; a beat can set `"hp": [yours, his]`).
- ## METHOD - A HEAD MOVE IS STAGED WITH THE GLOVE THROUGH THE PLACE THE HEAD WAS (S561, `tools/pics2d_head.gd`): never
  the plain miss staging (it gives ground: "he stood far away"). The slip is a lean from the Spine bone; the roll takes
  pro_right_weave on both men.
- ## METHOD - ONE ART AGAINST ITSELF FIRST (owner S549, S559 "Yes, kickboxer first").
- ## METHOD - CONSOLE WORKERS IN PARALLEL (owner S559), up to 3 through `ops/Tools/claude_cm.ps1`; the Workflow / Agent
  tools are refused. NODE-ONLY MEASURES GO TO ARENA: `git push`, `python ops/Tools/lite_mirror.py --lean push`, Chrome
  arena.ai/agent (wait ~12 s for the repo selector), a prompt naming the committed TASK file. While his game is open: ONE
  job on the PC, no second render.
- WHEN HE SAYS "ON THE BOARD" ASK WHICH BOARD IN ONE LINE IF IT IS NOT PLAIN (S561: "a jumpsuit for punchers chance on
  the board" was a jump button on the OPS BOARD; a new playable page always gets its jump button there the same turn:
  `ops/Tools/opsboard/roadmap.html`, the PAGES list).
- Appended comments are `/* */`, never `//`.
- ## METHOD - THE TELLS (S563, S564; his "show opponents intentions like card games?"): NEVER his whole plan; ONE body tell
  from the beat he already chose (5 of 5 playtesters). VERSION 3 is the current one (`play_cli.mjs ... tells=3`,
  tells.mjs LIES3/CAP3): a fake never hides a bigger punch, at most 2 a round, a second rule of his own state. It reaches
  the page only after TELLS3M (bars against the no-tell control - the page's men are beaten 67-83% by the control alone)
  and his yes - as a POSE of his body (TASK_TELLS2PAGE) plus the cue word in the ring's corner badge, never near the men.
- `play_cli.mjs` and `tells.mjs` are imported LIVE by every running playtest: keep old calls working when you change them.
- ## METHOD - NOTHING NEAR THE FIGHTERS (owner S562: "i told you do not put text or anything near the fighters"): no bar,
  tick, label or marker on, under or beside the men. Ring readouts in ONE badge in the ring's top-left corner, the rest in
  the panels; a readout says what it means for a choice (memory feedback_nothing_near_fighters_s562).
- ## METHOD - EVERY CLIP STARTS AND ENDS WHERE THE MEN STAND (owner S562: "the distance between fighters is not consistant
  when clips play"): a run is made at each page range it can happen at (`tools/pics2d_anim.gd range=` / `short=1`), proved
  by the edge table (hold before, first frame, last frame, hold after; > 8 px = a jump), never by a shrunk strip.
- ## METHOD - A CLOUD RUN IS WATCHED, NOT POLLED (S565): arm the Monitor tool on `python -u ops/Tools/arena_watch.py 180
  <ID>=<branch id> ...` (30 min, re-arm): one line when a run's result page carries its done line, a STALL line after 75
  quiet minutes (a table build commits nothing for an hour: open the chat before calling it dead). Read a branch with
  `git fetch --no-write-fetch-head --no-tags https://github.com/ICOON-Studio/FightCamp-Lean-lite.git
  +refs/heads/arena/<id>-fightcamp-lean-lite:refs/lite/arena/<id>`, then `git diff --name-status refs/lite/main...refs/lite/arena/<id>`
  and `git show <ref>:<path> > <path>` for each ADDED file (never a whole branch, never Arena's Merge).
- A NEW SLOT IN A PLAN'S ORDER (S565, the 'wait') must be known to `proto/twohands/body_ui.js` words(): it reads
  `ACT[P[sl]]` for every slot. page_play_test does not load body_ui.js - only `beat_shot.mjs` (headless Edge) caught it.
- A COPY PAGE IS BUILT, NEVER EDITED: punch.html by make_punch.py, wait.html by make_wait.py. After any order.html edit run
  both, then page_parse + page_play_test on order, punch, head, kick, wait; wait_test 5.

## His words in S565
None (the session ran from the start line). Asked in chat, unanswered: close the four worker consoles left from S560-S564
(PUNCHCHANCE1, the old GLIDE2 and INSIDE1 workers, the ALLPLAY2 playtester)? They cannot be closed without his yes.

## RUNNING AT THE HANDOVER (Arena runs are on ICOON-Studio/FightCamp-Lean-lite; collect as the METHOD line says)
- LONG1 arena/cba93bd0 (TASK_LONG1.md) - the stopping jab (L1), the lead hand as a fence (L2, Dola), both (L3), control L0.
- LONG2 arena/193e5c2c (TASK_LONG2.md) - Kalli's waiting cross: K0 counts what the page already does (a cross at Long
  already lands on a man stepping in), K1 her two bonuses, K2 the cross half, K3 the jab half.
  JUDGE BOTH TOGETHER: bars 8+ of 9 on both seeds and never under the control; the jab's use up (real anchor: the jab is
  40-44% of punches thrown by pros, G99_COMPUBOX_AVERAGES; on the page the two jabs are ~27%, the head jab 8%); Long at
  most 45% of beats; the man walking in still gets in. One version goes to him as a toy page (make_<x>.py, as wait.html).
- MOMENTGAP1 COLLECTED (docs/MOMENTGAP1_RESULT.md): B (only the step a moment later) 8 of 9 on both seeds, a wait in 8%
  of beats; A (a free wait anywhere) 7 of 9, in 67%. ASKED HIM Q-344: main page / its own page / drop. wait.html is the
  page to play, on its OWN look-ahead table since S565 (`proto/twohands/vtable_wait.json`, 875 s to build at jobs=2;
  make_wait.py prints which table the page uses).
  On "Yes, main page": moment_gap_b.json's three rule edits + make_wait.py's page patches go into order.html, vtable.json
  is rebuilt, both copies rebuilt, `balance.mjs play n=84` on two seeds.
- TELLS3M arena/181a4c7c - passes -> ask him on the board (one line + the words-tool transcript): the tell on the page as
  a pose of his body? -> TASK_TELLS2PAGE.
- CLINCHFIX3 arena/67e7800b, AIEMPTY1 arena/f889f281, JABLAND2 arena/18b46867 (its winner also goes on head.html),
  KICKFIX3 arena/c178d87d (quiet for 75+ min at 16:30 but its chat was alive on a long run), PROGP2 arena/15b7ab01 (Q-340).
- Render worker (console, Opus; its tab is not visible from a new session - find it by process: claude.exe with
  RESUME_S564_RENDERS in its command line): GLIDE2 pushed (7534204a0), INSIDE1 step 3 re-render running. When it ends:
  BOUNCE1 (TASK_BOUNCE1.md), then KDPIC1 (TASK_KDPIC1.md), each a console worker, one render at a time, his game closed.
- Page server: `python proto/cardgame/serve.py 8797 twohands` (check it after any session archive).

## FIRST (in this order)
1. Collect what has ended (arena_watch prints it). TELLS3M -> the board question. His answer to Q-344.
2. KDHEAL1 + KDFIRST ARE REPORTED TO HIM (S565 chat): keep the get-up [6, 4]; on the page the man dropped first wins 13%
   (real 34.4%), dropped twice 9% (real 7%). If he wants the "walk into a punch at 1 health" exploit gone: measure "up
   on no more than he had, no stamina refill" - never a lower floor.
3. CLINCHFIX3 / AIEMPTY1 / JABLAND2: a version that holds the bars goes on the page (tweak -> page, balance re-run, both
   make scripts, the page tests).
4. LONG1 + LONG2 -> one Long rule as a toy page for him.
5. When the render worker pushes: BOUNCE1, then KDPIC1.

## Waiting on the owner
- His play of wait.html (the late step), the body view (order.html), punch.html, and tells v3 in the words tool if he
  wants (`node proto/twohands/tools/play_cli.mjs new <f> opp=1 seed=1 tells=3`).
- The four old worker consoles (above).

## Seats
Arena for node-only measures (push, `python ops/Tools/lite_mirror.py --lean push`, Chrome arena.ai/agent, wait ~15 s for
the branch selector, a prompt naming the committed TASK file; the branch id is the last 8 characters of the chat URL);
console workers (`ops/Tools/claude_cm.ps1 --model claude-opus-5-5 --permission-mode auto "<prompt naming the TASK file>"`);
Ziva for playtests; Dola by `play_by_message.mjs via=dola`; Antigravity by `via=agy`; Grok bots (John, Kalli, Maria) -
`gbot.py send --to "<bot>" --file <f>`; `seat_queue.py drain` collects a seat answer now instead of at the half hour.

## Model for S566
Opus, medium effort, Fast off - collecting up to nine measures, two answers to him, then one page change at a time.
