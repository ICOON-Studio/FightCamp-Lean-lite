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
- ## METHOD - EVERY PAGE CHANGE HAS A VERSION AND A CHANGELOG LINE (owner S565: "add a changelog with every fix showing
  which version we running"): `proto/twohands/version.js`, newest first, v0.<session>.<n>, plain words, same commit.
- A COPY PAGE IS BUILT, NEVER EDITED: punch.html by make_punch.py, wait.html by make_wait.py. After any order.html edit run
  both, then page_parse + page_play_test on order, punch, head, kick, wait; wait_test 5.

## His words in S565
"how can i get my brother a link to test the game ? also maybe add a changelog with every fix showing which version we
running"
-> BUILT: `proto/twohands/version.js` (the list; the top entry is the running version, shown as v0.<session>.<n> beside
the sound button on every page) and `proto/twohands/changelog.html`. THE RULE FROM NOW ON: every change a player can
see or feel on a page adds one plain line at the top of `RS_CHANGES` with a new number, in the same commit; then
make_punch.py + make_wait.py. A measure that changed nothing on a page is not an entry.
-> THE LINK: asked him in chat (unanswered at the handover). My reading: "the game" = the Ring Switches pages. The main
repo is PRIVATE and the pages folder is 67 MB / 5,511 files. Recommended to him: a public web address made from
`proto/twohands` only (a small public repo with GitHub Pages; works with his PC off; updated with every version).
NOTHING IS PUBLISHED WITHOUT HIS YES. The other way: a temporary link from this PC (a tunnel tool to download - also his
yes; it works only while the PC and the page server run).
Also asked, unanswered: close the worker consoles left from S560-S564 (idle, about 1.5 GB together)?

## OPEN ON THE BOARD
Q-344: "Your step a moment later holds the bars on both seeds. Put that switch on the main page?" (Yes, main page / Keep
its own page / Drop it). On "Yes, main page": moment_gap_b.json's three rule edits + make_wait.py's page patches go into
order.html, `balance.mjs table out=proto/twohands/vtable.json` is rebuilt (15 min at jobs=2), punch.html and wait.html
rebuilt, the page tests, `balance.mjs play n=84` on two seeds, body_ui.js already knows the wait.

## RUNNING AT THE HANDOVER (Arena runs are on ICOON-Studio/FightCamp-Lean-lite; collect as the METHOD line says)
- LONG1 arena/cba93bd0 (TASK_LONG1.md) - the stopping jab (L1), the lead hand as a fence (L2, Dola), both (L3), control L0.
- LONG2 arena/193e5c2c (TASK_LONG2.md) - Kalli's waiting cross: K0 counts what the page already does (a cross at Long
  already lands on a man stepping in), K1 her two bonuses, K2 the cross half, K3 the jab half.
  JUDGE BOTH TOGETHER: bars 8+ of 9 on both seeds and never under the control; the jab's use up (real anchor: the jab is
  40-44% of punches thrown by pros, G99_COMPUBOX_AVERAGES; on the page the two jabs are ~27%, the head jab 8%); Long at
  most 45% of beats; the man walking in still gets in. One version goes to him as a toy page (make_<x>.py, as wait.html).
- TELLS3M arena/181a4c7c - passes -> ask him on the board (one line + the words-tool transcript): the tell on the page as
  a pose of his body? -> TASK_TELLS2PAGE.
- JABLAND2 arena/18b46867 (D / E / F: the feint and the overhand). READ IT WITH THE CLINCH CROSS-CHECK (below): its
  winner may fix the page's failing bar AND the clinch loop in one change. Its winner also goes on head.html.
- KICKFIX3 arena/c178d87d (quiet for 90+ min, its chat alive on a long run: open the chat).
- BOUNCE1: a console worker (Opus, Code Mode) launched 17:00 from this session's terminal tab "bounce565" with
  ops/research/RESUME_S565_BOUNCE1.md. A new session cannot see that tab: find it by process (claude.exe with
  RESUME_S565_BOUNCE1 in its command line) and by docs/BOUNCE1_RESULT.md's last line. When it ends: check its strips and
  screenshots yourself, then KDPIC1 (TASK_KDPIC1.md) as the next console worker, one render at a time, his game closed.
- Page server: `python proto/cardgame/serve.py 8797 twohands` (check it after any session archive).

## COLLECTED IN S565 (results on main)
- KDHEAL1: keep the get-up [6, 4]. KDFIRST (own count): on the page the man dropped first wins 13% (UFC 34.4% when the
  fight goes on), dropped twice 9% (7%). Reported to him. If he wants the "walk into a punch at 1 health" exploit gone:
  measure "up on no more than he had, no stamina refill" - never a lower floor.
- MOMENTGAP1: B (only the step a moment later) 8 of 9 on both seeds; A (a free wait anywhere) 7 of 9. wait.html built on
  its own table (vtable_wait.json). Q-344 asked.
- CLINCHFIX3: none (H1 48 / 57 / 53%, H2 37 / 58 / 42%, bar under 30%). THIRD FAILED CLINCH ROUND: no fourth clinch fix.
  The loop in probe_clinch.mjs is "step in, FEINT, OVERHAND" then "clinch"; without the clinch the same man wins 7-13%.
  CROSS-CHECK (ops/research/s558_balance/results/clinchx_<base|d|e|f>_loop.txt, n=60, the page's own table): today
  38 / 63 / 70%; D (the feint opens the overhand only Inside) 33 / 42 / 37%; E (a punch landing in your feint moment
  wastes it) 25 / 33 / 32%; F (both) 22 / 25 / 25% - UNDER THE 30% BAR AGAINST EVERY MAN, the clinch untouched. The
  clinch was never the exploit: it paid for a feint-then-overhand nobody could cover. If JABLAND2 F holds 8+ of 9 on
  both seeds (Arena), F is the page change for the landing bar AND the clinch loop: re-run probe_clinch on F's own
  table, then tweak -> order.html. If only D or E holds the bars: the same check on that one, H1 added if it misses 30%.
- AIEMPTY1 (collected after the ship, docs/AIEMPTY1_RESULT.md): NONE as briefed, WITH A FINDING. Filtering his empty
  beats (ai_no_empty.json) takes them to 0 in his plain beats but makes him stronger: the player-bot's wins v the Jabber
  76 -> 77%, v the Slugger 71 -> 63%, v the Body Snatcher 75 -> 52% (the brief's bar was "within 5 points"). His empty
  beats were a hidden handicap the S555 skill numbers were set with - and today the player-bot beats every man 71-76%
  (his S555 words: "vs the jabber you win very easy"). 53% of the empty beats come from the solved mix itself (a back
  off at Long with no punch, a step in at Inside): a rules question, not a filter. NEXT (his taste: how hard the men
  should be): AIEMPTY2 = the filter + the three skill numbers set again on the instrument to a target he names.
- PROGP2 (his Q-340 "Yes, a choice"): at Sharp "cheaper or faster" is a real choice for the Overhand only (57% / 55%),
  nearly for the lead uppercut (59 / 53). The hook's cheaper card is dead (43%); body hook, rear uppercut and body cross
  always take cheaper; the cross is too strong both ways (62 / 63); the jabs have nothing to give. NEXT: PROGP4, a pair
  of its own for each punch (docs/PROGP2_RESULT.md lists one candidate pair each, unmeasured) - a brief with
  `## Feedback loops`, per-man damage and reach read from the man's own table (probe_sharp.mjs has stamina and speed).
- INSIDE1 steps 1-4 + GLIDE2 (the S564 render worker): Inside is 0.55 m, everything at Inside re-made, 0 jumps there;
  punches 33 jumps -> 2, head moves and kicks 43 -> 8. Left, named in the result pages: the low kicks' last picture
  (8-10 px), red_low_kick_missed and red_jab_missed refused by the camera at Long and Mid. INSIDE1 Phase 2 (the
  see-through overlap where the men cover each other) is NOT started: 3-4 Inside stills to him first.

## FIRST (in this order)
1. His answers: Q-344, the consoles. Collect what has ended (arena_watch prints it).
2. JABLAND2 + the clinch cross-check -> one page change if a version holds the bars (tweak -> order.html, table,
   balance two seeds, both make scripts, the page tests, head.html too).
3. TELLS3M -> the board question, then TELLS2PAGE. AIEMPTY1, KICKFIX3.
4. LONG1 + LONG2 -> one Long rule as a toy page for him.
5. BOUNCE1 collected (your own look at its pictures) -> KDPIC1. Then INSIDE1 Phase 2 stills for him.
6. TASK_PROGP4.

## Waiting on the owner
- Q-344 (above); his play of wait.html ("Pick your moment" on the ops board), the body view (order.html), punch.html.
- The old worker consoles.

## Seats
Arena for node-only measures (push, `python ops/Tools/lite_mirror.py --lean push`, Chrome arena.ai/agent, wait ~15 s for
the branch selector, a prompt naming the committed TASK file; the branch id is the last 8 characters of the chat URL);
console workers (`ops/Tools/claude_cm.ps1 --model claude-opus-5-5 --permission-mode auto "<prompt naming the TASK file>"`);
Ziva for playtests; Dola by `play_by_message.mjs via=dola`; Antigravity by `via=agy`; Grok bots (John, Kalli, Maria) -
`gbot.py send --to "<bot>" --file <f>`; `seat_queue.py drain` collects a seat answer now instead of at the half hour.

## Model for S566
Opus, medium effort, Fast off - collecting six measures, his answer to Q-344, then one page change at a time.
