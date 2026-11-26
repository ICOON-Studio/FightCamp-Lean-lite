# S563 handover (written 2026-11-26, S562 - Opus 5.5)

Start: `git pull && python ops/Tools/agent_comms.py start`, then this page, then `ops/research/S562_DIGEST.md`.

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
- ## METHOD - NOTHING NEAR THE FIGHTERS (owner S562: "i told you do not put text or anything near the fighters"): no bar,
  tick, label or marker on, under or beside the men. Ring readouts in ONE badge in the ring's top-left corner, the rest in
  the panels; a readout says what it means for a choice (memory feedback_nothing_near_fighters_s562).
- ## METHOD - EVERY CLIP STARTS AND ENDS WHERE THE MEN STAND (owner S562: "the distance between fighters is not consistant
  when clips play"): a run is made at each page range it can happen at (`tools/pics2d_anim.gd range=` / `short=1`), proved
  by the edge table (hold before, first frame, last frame, hold after; > 8 px = a jump), never by a shrunk strip.

## RUNNING AT THE HANDOVER (collect first)
- GLIDE2 - console tab "GLIDE2" (head moves and kicks at every range on head.html / kick.html; its renders wait for his
  game to close). Brief ops/research/TASK_GLIDE2.md; it ends with docs/GLIDE2_RESULT.md and `GLIDE2 DONE`.
- INSIDE1 - console tab "INSIDE1" (owner after the handover, on the Inside hold: "can you make the silhoutes parts that are
  clipping transparent , the distance looks wrong to me btw"). Inside (0.71 m in, the clinch's tie-up gap) widens to a real
  inside distance (K50: 0.70-0.90 m feet-mid), every Inside run is re-rendered, the head masks with it (BODYUI2's last step;
  the after_glide2.sh waiter was stopped), then the overlapping parts see-through. Brief ops/research/TASK_INSIDE1.md.
  GLIDE2 was told (cross-session message) to leave its Inside renders to INSIDE1.
- Arena, on ICOON-Studio/FightCamp-Lean-lite (read with `gh api repos/ICOON-Studio/FightCamp-Lean-lite/contents/<path>?ref=<branch>`,
  copy onto main by hand, never Arena's Merge button, check no test deleted):
  KICKFIX2 arena/bb25d26e (slow, 2 cores), HEADPULL1 arena/397eb67a, PROGP3 arena/49993fd3 (9 of 9 runs; its guard runs
  (7 v 5 and 7 v 6) are byte-identical: endBeat clamps m.g to N.guard - my note is typed in its chat
  arena.ai/agent/01a216e4-80eb-7fea-88a3-0ed549993fd3, send it if still unsent), MOMENTGAP1 arena/4bdf9ebc (his "select
  exactly on which part of a beat i move"), CLINCHFIX2 arena/204b98f9, JABLAND1 arena/ba10e2bf.
- Chat seats: SQ337 John, SQ338 Kalli (sent, unanswered).

## FIRST (his asks, in this order)
1. Collect the runs above. A measured version that holds its bars goes on the page (tweak src onto the rules); a rule he
   did not ask for is reported to him first.
2. MOMENTGAP1's answer to his "can i ... select exactly on which part of a beat i move ? or it breaks balance ?".
3. BOUNCE1 (brief ops/research/TASK_BOUNCE1.md: after GLIDE2, game closed).
4. Progression Q-340 "Yes, a choice", Q-341 "Try it", Q-342 "Right amount" - after PROGP3's numbers (guard runs redone).

## Waiting on the owner
- His play of the body view (order.html: point at a limb), punch.html on F, the distance fix.

## Seats
Arena for node-only measures; console workers (`ops/Tools/claude_cm.ps1 --model claude-opus-5-5 --permission-mode auto
"<prompt naming the TASK file>"` in a terminal tab; owner S562: "use console-code if you need more tasks done"); John /
Kalli through `python ops/Tools/seat_queue.py add`. Page server: `python proto/cardgame/serve.py 8797 twohands`.

## Model for S563
Opus, medium effort, Fast off - collecting six measures and two renders, then page work with clear targets.
