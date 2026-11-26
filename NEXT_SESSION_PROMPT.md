# S565 handover (written 2026-11-26, S564 - Opus 5.5)

Start: `git pull && python ops/Tools/agent_comms.py start`, then this page, then `ops/research/S564_DIGEST.md`.

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

## His words in S564
"grokbots are back" -> John and Kalli answered their briefs within the hour (SQ337 comebacks, SQ338 kicks); Kalli and
Dola have a new one: Long is a corridor (SQ339, SQ340).

## RUNNING AT THE HANDOVER (collect first; Arena runs are on ICOON-Studio/FightCamp-Lean-lite, read with
`gh api repos/ICOON-Studio/FightCamp-Lean-lite/contents/<path>?ref=<branch>`, copy onto main by hand, never Arena's Merge)
- TELLS3M arena/181a4c7c - tells v3 against bots, bars against the control. Told mid-run to merge main (Body Snatcher rule).
- KDHEAL1 arena/836987cb - a knockdown heals: KD0 control 8 of 9, comeback 19%; KD3 [3,2] dropped (75% stoppages).
  REPORT it to him with John's real numbers (a dropped man who fights on wins 34%, dropped twice 7%); not on the page.
- MOMENTGAP1 arena/4bdf9ebc - HIS question "can i select exactly on which part of a beat i move ? or it breaks balance ?":
  the n=12 trial says a free wait is picked in ~70% of beats ("wait first, counter his punch") and the page drops to 5 of 9.
  Answer him with the final numbers and the costed variant B.
- CLINCHFIX3 arena/67e7800b - his habit read sees clinches (H1), + clinch +1 stamina (H2).
- AIEMPTY1 arena/f889f281 - his empty beats counted, then filtered from his plain beats.
- JABLAND1 arena/ba10e2bf, KICKFIX3 arena/c178d87d, PROGP2 arena/15b7ab01 (his Q-340), HEADPULL1 arena/397eb67a.
- Render worker in terminal tab "renders564" (Opus, Code Mode): RESUME_S564_RENDERS.md - INSIDE1 probe, GLIDE2 renders,
  INSIDE1 re-render. When it ends: BOUNCE1 (TASK_BOUNCE1.md), then KDPIC1 (TASK_KDPIC1.md), each a console worker, one
  render at a time, his game closed.
- Page server: `python proto/cardgame/serve.py 8797 twohands` (check it after any session archive).

## FIRST (in this order)
1. Collect the runs above. TELLS3M passes -> ask him on the board (one line + a still or the words-tool transcript): the
   tell on the page as a pose of his body? -> TELLS2PAGE.
2. MOMENTGAP1: answer his question in plain numbers. KDHEAL1: report it.
3. CLINCHFIX3 / AIEMPTY1 / JABLAND1: a version that holds the bars goes on the page (tweak -> page, balance re-run).
4. When the render worker pushes: BOUNCE1, then KDPIC1.

## Waiting on the owner
- His play of the body view (order.html), punch.html on F, and the tells v3 in the words tool if he wants
  (`node proto/twohands/tools/play_cli.mjs new <f> opp=1 seed=1 tells=3`).

## Seats
Arena for node-only measures; console workers (`ops/Tools/claude_cm.ps1 --model claude-opus-5-5 --permission-mode auto
"<prompt naming the TASK file>"`); Ziva for playtests (fast; its chat can loop on "Go." - resume it from the state file);
Dola by `play_by_message.mjs via=dola`; Antigravity by `via=agy`; Grok bots (John, Kalli, Maria) back since S564 -
`gbot.py send --to "<bot>" --file <f>` (positional text fails).

## Model for S565
Opus, medium effort, Fast off - collecting nine measures, two answers to him, then a page build if the tells pass.
