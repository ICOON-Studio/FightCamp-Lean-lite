# S560 digest (2026-11-26, Fable 5.2)

## His words this session (board answers and comments, quoted)
- Q-S294-337, Rune's pull counter: "Yes, put it on" -> on `proto/twohands/order.html`.
- C515 on the first body toy still: "no overlaps on the fighters and menus . use smaller buttons and and tooltip to make
  that popu smaller" -> the MASK1 page built after that still already has the side panel and small buttons; the one
  overlap left (the distance words on the boots) moved under the floor bar.
- "Looks fine" (guard off the ear), "Looks fine" (low cover), "not bad" (Antigravity's and Claude's 10/10 cards), "nah" (Dola's).

## Done
- PULL COUNTER on the boxing page: a back off arms that man's next punch in the beat, +1 when it lands; cut off by a
  step in it arms nothing. Shown three ways: the Back off tooltip, "+1" on the armed punch in the order strip BEFORE the
  click, "lands - off the pull, +1" in the story. The page's look-ahead table rebuilt (418 s). rules_test 37 (one new
  test), page_play_test 4, kick_test 12, head_test 11, page_parse ok. Played on the real page in headless Edge with the new
  `proto/twohands/tools/beat_shot.mjs`: the jab off a back off takes 2 instead of 1.
- Body toy: the distance words sit under the bar (ring_ui.js, all four pages).
- GHOST STEP measured on the pictures he sees (new `proto/twohands/tools/step_feet.py`): the 8 step runs that can be read
  all glide - front foot first going in, back foot first going out, soles lift 0 to 2.6 cm. 4 runs cannot be read (two
  boots touch). No new authoring needed for the glide; the never-still bounce between beats is still to render.
- Collect: nine finished or stale runs archived; Dola's SQ327 defence ideas committed (for the parked card game).
- Six questions on the board (Q-338 to Q-343): three on the body view, three on progression.

## Kicks: what the five results say (the reason for the next version; in TASK_KICKFIX2.md)
1. B killed the body kick and the head kick by taking Long from them: at Mid a slow kick loses to the cross. Fix A, with
   kicks at Long and Mid, already fought Inside / Mid / Long 28 / 36 / 36%.
2. The low kick's landing rate is set by whether a check is worth playing: at 1 health nobody checks (94%). C's
   "hold your ground checks" landed 96% because men hold Inside, where the low kick does not reach.
3. A weaker strike lands MORE (nobody defends it): to lower a landing rate, make the defence cheap or the threat bigger.
Versions for Arena: E1 cheaper lighter kicks, E2 "a man who holds or backs off checks by reflex; only the man stepping in or
kicking has his lead leg planted", E3 both.

## Running at the handover
| Run | Seat | State |
|---|---|---|
| PUNCHCHANCE1 | console worker, terminal tab PUNCHCHANCE1 | Today's comeback number: the man 4+ health behind after round 1 wins 11% (4 of 35). Version A: 16% (7 of 43) but stoppages 45% and 2.6 knockdowns; used in 35% of open beats. It is measuring B, C, D (its first loop wrote all three to one file: it reruns). Files: ops/research/s558_balance/punch_chance_*.json, punch_chance_out/. |
| KICKFIX2 | Arena, branch arena/bb25d26e-fightcamp-lean-lite | Trials of E1-E3 at 12 bouts, then 56. Its clone has 2 cores: slow (hours). |
| HEADPULL1 | Arena, branch arena/397eb67a-fightcamp-lean-lite | head.html + the pull counter, two runs of 84. |
| PROGP3 | Arena, branch arena/49993fd3-fightcamp-lean-lite | A new probe tool: how much health, stamina, recovery and guard each decide a bout. |
| SQ337 John, SQ338 Kalli | chat seats | Real comeback and kick numbers; what each kick is for. |
| HEADPICS1 | STOPPED | Closed after 14 minutes when his game opened. On disk: tools/pics2d_head.gd (uncommitted), E:/FightCamp/tmp/headpics1/try1. First pass: the slip reads as a duck, the roll run is not usable (defender does not move). Relaunch when the PC is free. |

## Incidents and lessons
- His game (ArcheAge) opened 5 minutes after two workers started: memory RED 97%. Stopped my own measure run, closed the
  GPU worker, set the other worker's probe to Idle priority; the node-only measures went to Arena. AMBER 89% after.
- Four worker processes from 24-25 Nov (RUNESTEP1, COACHMAP2, BODYCROSS4, STYLEPLACE1) are still open and idle (~1.6 GB).
  The permission check refused closing them: asked him.
- No export this session: no game code changed (pages and tools only), and an export beside his game would lag it.
- base84 on the page with the pull counter: 8 of 9, the jab lands 74% (S559's 56-bout run said 68%), the overhand 70%,
  back off in 35% of beats (the must bar is 40%): watch it in the next measure.
