# S562 handover (written 2026-11-26, S561 - Fable 5.2)

Start: `git pull && python ops/Tools/agent_comms.py start`, then this page, then `ops/research/S561_DIGEST.md`.

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

## RUNNING AT THE HANDOVER (collect first) - all at Arena, on ICOON-Studio/FightCamp-Lean-lite
Read each branch with `gh api repos/ICOON-Studio/FightCamp-Lean-lite/contents/<path>?ref=<branch>`, copy its files onto
main by hand, never Arena's Merge button, check it deleted no test.
- KICKFIX2 `arena/bb25d26e-fightcamp-lean-lite` (chat arena.ai/agent/01a216db-21b6-714e-a68f-ba6abb25d26e).
- HEADPULL1 `arena/397eb67a-fightcamp-lean-lite` (01a216df-1820-7c22-9f03-e8ff397eb67a).
- PROGP3 `arena/49993fd3-fightcamp-lean-lite` (01a216e4-80eb-7fea-88a3-0ed549993fd3): the branch is pushed.
- PUNCHCHANCE2 `arena/403bd20a-fightcamp-lean-lite` (01a21702-0f08-75c6-8761-a804403bd20a): brief
  `ops/research/TASK_PUNCHCHANCE2.md`; when it names a version, `python proto/twohands/tools/make_punch.py <its tweak>`,
  `page_play_test.mjs punch.html`, a beat_shot, and tell him.
- Chat seats: SQ337 John, SQ338 Kalli.

## FIRST (his asks, in this order)
1. Collect the four runs; kicks and head movement onto the pages where they hold their bars (his call for head movement).
2. HIS ANSWER Q-343 "Yes, replace the board": the body view becomes how you pick switches on the main page. Q-338: pointing
   at HIS limb "Show what it can do" (not his last three beats). Q-339 "Yes": head opens slip / roll / lean back, torso the
   clinch, legs the steps. Build it on a page copy first (his rules: nothing written on the fighters, no tubes or circles,
   small buttons, tooltips; memory feedback_body_view_no_text_on_fighters_s559), a jump button on the ops board, his play.
3. Progression: Q-340 "Yes, a choice" (a Sharp move: one of two upgrades), Q-341 "Try it" (a fight plan before the bout),
   Q-342 "Right amount" (four attributes on the fight board) - after PROGP3's numbers.
4. The never-still bounce and one-man-per-layer clips (renders: only when his game is closed).
5. base84 with the pull counter: the jab lands 74%, back off in 35% of beats (the must bar is 40%).

## Waiting on the owner
- His play of punch.html and head.html (jump buttons on the board's Play box and top bar).

## Seats
Arena for node-only measures; console workers (claude_cm.ps1); John / Kalli through `python ops/Tools/seat_queue.py add
--seat <s> --brief research/<file>`. The page server runs in a terminal tab: `python proto/cardgame/serve.py 8797 twohands`.

## Model for S562
Opus, medium effort, Fast off - collecting four runs, then the body-view build is page work with a clear target.
