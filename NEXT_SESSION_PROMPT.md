# S564 handover (written 2026-11-26, S563 - Opus 5.5)

Start: `git pull && python ops/Tools/agent_comms.py start`, then this page, then `ops/research/S563_DIGEST.md`.

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
- ## METHOD - THE TELLS (S563, his "show opponents intentions like card games?"): NEVER his whole plan; ONE body tell
  from the beat he already chose, with one learnable lie per man (4 of 4 playtesters, ops/research/DESIGN_TELLS2.md). It
  reaches the page only after the v2 replay (ALLPLAY2B), the bot measure (TELLS2M) and his yes - as a POSE of his body
  plus the cue word in the ring's corner badge, never near the men.
- `play_cli.mjs` and `tells.mjs` are imported LIVE by every running playtest: keep old calls working when you change them.
- ## METHOD - NOTHING NEAR THE FIGHTERS (owner S562: "i told you do not put text or anything near the fighters"): no bar,
  tick, label or marker on, under or beside the men. Ring readouts in ONE badge in the ring's top-left corner, the rest in
  the panels; a readout says what it means for a choice (memory feedback_nothing_near_fighters_s562).
- ## METHOD - EVERY CLIP STARTS AND ENDS WHERE THE MEN STAND (owner S562: "the distance between fighters is not consistant
  when clips play"): a run is made at each page range it can happen at (`tools/pics2d_anim.gd range=` / `short=1`), proved
  by the edge table (hold before, first frame, last frame, hold after; > 8 px = a jump), never by a shrunk strip.

## His question this session, answered
"do you thinkwe should show opponents itentions like more draditional card games or it is fine the way it is ?" - four
playtesters (Claude, Arena, Ziva, Dola; Antigravity was still playing) all chose ONE body tell over his whole plan; fun with
tells 8 for all four. Version 2 (lies that fire on visible states, bluffs only, a fake costs 1 stamina, the ledger says
when) is in the words tool: `node proto/twohands/tools/play_cli.mjs new <f> opp=0 seed=1 tells=2`.

## RUNNING AT THE HANDOVER (collect first; all Arena runs are on ICOON-Studio/FightCamp-Lean-lite, read with
`gh api repos/ICOON-Studio/FightCamp-Lean-lite/contents/<path>?ref=<branch>`, copy onto main by hand, never Arena's Merge)
- ALLPLAY2B: Ziva (its editor on the hidden desktop, port 7012, same chat as round 1; report
  E:/FightCamp/tmp/allplay2/ziva/ALLPLAY2B_ZIVA.md) and Arena arena/f0a3ce55 - tells v2 replayed.
- ALLPLAY2 Antigravity: `play_by_message.mjs antigravity E:/FightCamp/wt/AGY_ALLPLAY2 via=agy tag=ALLPLAY2` (its report
  prompt is the OLD one: ask it the owner's question as a follow-up, as Dola was; see reference_s563_traps).
- TELLS2M arena/ed0b7f42 (the tells measured with bots), KDHEAL1 arena/836987cb (a knockdown heals: get-up [4,3] [4,2]
  [3,2]), KICKFIX3 arena/c178d87d, PROGP2 arena/15b7ab01 (his Q-340 Sharp choice), and from S562: HEADPULL1 arena/397eb67a,
  MOMENTGAP1 arena/4bdf9ebc (his "select exactly on which part of a beat i move"), CLINCHFIX2 arena/204b98f9, JABLAND1
  arena/ba10e2bf. Chat links are in ops/AgentComms/live_runs.json.
- GLIDE2 and INSIDE1 (console tabs from S562): code done and committed, BLOCKED on renders until his game is closed
  (docs/GLIDE2_RESULT.md, docs/INSIDE1_RESULT.md).
- The page server now runs in this session's terminal tab "Page server 8797" (the old one died when the old sessions were
  archived on his "Yes, close them").

## FIRST (in this order)
1. Collect the runs above. Tells: if ALLPLAY2B and TELLS2M agree, write the page version as a brief (the tell from
   `hisNext`, which the page already chooses before the player; three guard poses a man) and ask him with the board.
2. MOMENTGAP1's answer to his "can i ... select exactly on which part of a beat i move ? or it breaks balance ?".
3. KDHEAL1: a version that holds its bars is REPORTED to him (a rule he did not ask for), not put on the page.
4. With his game closed: GLIDE2 and INSIDE1 renders, the knockdown picture inside the ring, an overhand picture, BOUNCE1.

## Waiting on the owner
- His play of the body view (order.html), punch.html on F, and the tells (words tool) if he wants to try them.

## Seats
Arena for node-only measures; console workers (`ops/Tools/claude_cm.ps1 --model claude-opus-5-5 --permission-mode auto
"<prompt naming the TASK file>"`); Ziva for playtests (fast, decides each beat); Dola by `play_by_message.mjs via=dola`;
Antigravity by `via=agy`. Page server: `python proto/cardgame/serve.py 8797 twohands` (check it after any session archive).

## Model for S564
Opus, medium effort, Fast off - collecting ten measures and two playtests, then one page brief.
