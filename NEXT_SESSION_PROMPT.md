# S561 handover (written 2026-11-26, S560 - Fable 5.2)

Start: `git pull && python ops/Tools/agent_comms.py start`, then this page, then `ops/research/S560_DIGEST.md`.

## METHOD lines - quote all of them in your first message
- ## METHOD - RING SWITCHES IS THE MAIN LINE (owner S553, S555). The pages: `proto/twohands/order.html` (boxing, the
  source; the PULL COUNTER is on it since S560), `kick.html` (kickboxing), `head.html` (head movement), `body.html` (the
  lit-limb toy). The rules sit above each page's `// ---- the page` mark; page look below it and in ring_ui.js / body_ui.js.
- ## METHOD - THE SLICE IS BALANCED ON THE INSTRUMENT, NEVER BY HAND (owner S555). A change is a tweak file first
  (`"page": "kick.html"` names the page); `node proto/twohands/tools/balance.mjs table` + `play n=84` / `balance_batch.sh`;
  rules_test 37, kick_test 12, head_test 11, page_parse, page_play_test 4. Never edit a page's rules while a run reads it.
  A weaker strike lands MORE (nobody defends it): to lower a landing rate, make the defence cheap or the threat bigger.
- ## METHOD - THE FIGHT MUST BE SEEN: HIS CAMERA (S559 #16, raised 31 deg, from the side; tools/pics2d_camera.json), one
  fixed ring camera (RINGCAM1), the page slides the picture for red's steps (ring_ui.js). Every render takes south=blue.
  A new rule is proved SHOWN with `node proto/twohands/tools/beat_shot.mjs <out> <page> '<beats json>'` (headless Edge).
- ## METHOD - ONE ART AGAINST ITSELF FIRST (owner S549, S559 "Yes, kickboxer first").
- ## METHOD - CONSOLE WORKERS IN PARALLEL (owner S559), up to 3 through `ops/Tools/claude_cm.ps1` in terminal tabs; the
  Workflow / Agent tools are refused (his S541 rule). Every brief: commit by pathspec, `git diff --cached --stat` first.
  NODE-ONLY MEASURES GO TO ARENA (S560): `git push`, `python ops/Tools/lite_mirror.py --lean push`, Chrome arena.ai/agent,
  a prompt naming the committed TASK file. While his game is open: ONE console worker, at Idle priority, no renders.
- Appended comments are `/* */`, never `//`.

## RUNNING AT THE HANDOVER (collect first)
1. PUNCHCHANCE1 (terminal tab PUNCHCHANCE1, if still open): `docs/PUNCHCHANCE1_RESULT.md` when done. So far: the man
   4+ health behind after round 1 wins 11% today; version A 16% but 45% stoppages. Files:
   `ops/research/s558_balance/punch_chance_*.json`, `punch_chance_out/`, `proto/twohands/tools/probe_punch_chance.mjs`.
2. Arena, three chats on the lite mirror (ICOON-Studio/FightCamp-Lean-lite). Read each branch with
   `gh api repos/ICOON-Studio/FightCamp-Lean-lite/contents/<path>?ref=<branch>`, copy its files onto main by hand, never
   Arena's Merge button, check it deleted no test:
   - KICKFIX2 `arena/bb25d26e-fightcamp-lean-lite`: `ops/research/s558_balance/kick_fix_e*.json`, `results/kick_fix_e*.txt`,
     `docs/KICKFIX2_RESULT.md`. Its clone has 2 cores: hours.
   - HEADPULL1 `arena/397eb67a-fightcamp-lean-lite`: `results/head_pull_1.txt`, `head_pull_2.txt`, `docs/HEADPULL1_RESULT.md`.
   - PROGP3 `arena/49993fd3-fightcamp-lean-lite`: `proto/twohands/tools/probe_attributes.mjs` + its test,
     `results/attr_*.txt`, `docs/PROGP3_RESULT.md`.
3. Chat seats: SQ337 John (real comeback and kick numbers), SQ338 Kalli (what each kick is for, three leg-defence designs).
4. HEADPICS1 is STOPPED (his game opened): relaunch it when the PC is free - the brief `ops/research/TASK_HEADPICS1.md`
   carries its state (tools/pics2d_head.gd uncommitted, try1 strips, what was wrong with the roll).

## FIRST (his asks still open)
1. Collect the five runs above; put the passing kick version and (his call) head movement on the pages.
2. Puncher's chance: the version that lifts the comeback into 15-30% without breaking stoppages; then a page copy for his play.
3. Head-move pictures (HEADPICS1 relaunch) - the animation item of the session.
4. The never-still bounce between beats (the ghost-step glide is measured and already there: `python
   proto/twohands/tools/step_feet.py blue_step_in_r2 ...`); four step runs cannot be read (boots touch): look at them.
5. Layers: one man per clip + the guard joint (BML1 "perfect clips"), on MASK1's per-limb layers.
6. Kicks after KICKFIX2: boxer v kickboxer (noKick on one man), then DESIGN_PROGRESSION1's P1, P2, P4 (P3 is at Arena).
7. base84 with the pull counter: the jab lands 74%, back off is in 35% of beats (must bar 40%): read both in the next measure.

## Waiting on the owner (board)
- Q-338 to Q-343: the body view (make it the main page's way to pick; his limbs; head / torso / legs) and progression
  (a Sharp choice; a fight plan; four attributes).
- (Done at the handover, owner: "clear old tabs": the four old worker processes are closed.) He asked how long the
  head-move pictures take: told 3 to 4 hours of worker time once his game is closed, first strips after about 1 hour.
- His play of the pages (http://127.0.0.1:8797/order.html with the pull counter; kick.html, head.html, body.html).

## Seats
Console workers (claude_cm.ps1); Arena for node-only measures; John / Kalli through `python ops/Tools/seat_queue.py add
--seat <s> --brief research/<file>` (the path is relative to ops/). The page server runs in a terminal tab:
`python proto/cardgame/serve.py 8797 twohands`. Ziva idle (its editor plugin lost its backend, S559).

## Model for S561
Opus, medium effort, Fast off - collecting five runs and briefing; the weekly Fable allowance was 94% used at this handover.
