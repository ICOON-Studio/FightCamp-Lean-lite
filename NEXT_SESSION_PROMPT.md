# S559 handover (written 2026-11-25, S558 - Fable)

Start: `git pull && python ops/Tools/agent_comms.py start`, then this page, then `docs/RINGSWITCH_S558.md` (NOT GREEN first).

## METHOD lines - quote all of them in your first message
- ## METHOD - RING SWITCHES IS THE MAIN LINE, AND THE ORDER VERSION IS THE PAGE (owner S553, S555).
  `proto/twohands/order.html` is the hand-edited source; `switch.html` is the old version: do not build on it.
- ## METHOD - THE SLICE IS BALANCED ON THE INSTRUMENT, NEVER BY HAND (owner S555). A change is first a tweak file
  (`tweak=<file.json>`, examples in ops/research/s558_balance; `tweak_check.mjs <file>`). AFTER ANY RULE OR NUMBER CHANGE
  ON THE PAGE: `node proto/twohands/tools/balance.mjs table` (8 minutes), `balance.mjs play who=mix opp=mirror n=84`
  (and `seed=2`), `rules_test.mjs` (36), `page_parse.mjs order.html`, `page_play_test.mjs` (4). NEW S558: a clinch
  change is also measured on `probe_clinch.mjs` (a rote "feint, punch, clinch" script must lose clearly).
- ## METHOD - THE FIGHT MUST BE SEEN, SIDE VIEW, BOTH MEN CHEST TO THE CAMERA (owner S553). Every render takes `south=blue`.
- ## METHOD - THE SEATS' IDEAS ARE USED AND REPORTED (owner S554).
- HOW HE WORKS ON THIS GAME: he plays the page in Chrome and writes what is wrong within minutes. The page's server runs
  in a terminal tab (`python proto/cardgame/serve.py 8797 twohands`; curl first).
- DO NOT EDIT order.html (or balance.mjs) WHILE A balance.mjs RUN IS GOING. BEFORE YOU KILL OR RERUN A MEASUREMENT, look
  for a chain a previous session left alive (`Get-CimInstance Win32_Process | ? CommandLine -match 'chain.sh|balance'`):
  S558 killed part of S557's run by mistake. Every Godot start goes through `python ops/Tools/godot_slot.py run`.
  HIS GAME FIRST (`Get-Process ArcheAgeChronicles`): `balance.mjs` takes 7 workers and 2 GB. AGENTS ONLY IN THE CONSOLE.
- Every Bash call starts with `cd /e/FightCamp/Lean` (a cd elsewhere moves the session folder).

## FIRST: HIS THREE ORDERS FROM THE END OF S558 (none finished)
1. **HIS IDEA, BUILD IT AS A TOY FIRST (owner S558):** "what if we map the available options for the player (cards,
   switches) on the opponents body and your own fighters body . Lets say i move my mouse on the left hand of my fighter
   and the available switches appear like tooltip . if i click the same hand the the tooltip stays and i can make my
   selection ... then that selection goes into a strip or something like that decides and explains the order . what
   is your opinion on all this ?" My answer to him: yes (the reasons are in the last message of S558 and below). Build
   it on a COPY of the page (`proto/twohands/body.html`, rules untouched): hover a hand or the boots of YOUR man = that
   hand's switches as a tooltip, click = it stays, pick = a chip in the order strip (drag to reorder; the strip says in
   words what meets what). Hover HIS hand = what that hand did in his last three beats and which line it shuts. A
   pulsing hand on the first beat; the clinch on the torso; no hover on a phone (a tap opens). Send him the link within
   the hour. It also cuts the page to 1080 high (it is 1357 now).
2. **THE GUARD PICTURE (owner S558, with a crop of the blue man):** "this guard is wrong why he protects his ears ?".
   The pose is the hold `both_low_high` / `rear_high` (lead hand low, rear glove on the side of the head at the ear,
   face open). I looked: he is right (`E:/FightCamp/tmp/allplay1/guard_holds.png`, four holds side by side). Fix: the
   rear glove held high sits in FRONT of the ear, on the cheek and jaw, elbow in (HOLDTAKES1 said "at the temple and
   cheek"; it came out at the ear). Retake `rear_high` and `both_low_high` (and check `both_high_low`), both corners,
   through `tools/pics2d_anim_more.gd` (`_hold_run`); a picture bar first (the glove's centre ahead of the ear line),
   red on today's pictures; then gate, `anim_check.mjs`, `anim_web.py`, a before/after strip to him. Animation fixes
   have his standing approval. This is also the session's animation item.
3. **RUNE COLISEUM'S STEP MECHANIC (owner S558):** "check the step mechanic included/or required in some moves on the
   game RuneColossieum ... play it in the background you can use any saved games i have ,i do not care and try see if
   its logic fits our switch/card game". RUNNING at the handover: a console worker (Opus, terminal tab "RUNESTEP1
   worker", brief `ops/research/TASK_RUNESTEP1.md`). It writes `ops/research/RUNESTEP1_STUDY.md` and up to three
   `ops/research/s558_balance/rune_*.json`. Collect it (check three claims against its screenshots under
   E:/FightCamp/tmp/runestep1), tell him the verdict, measure its best sketch. If the tab died: relaunch the same line.

## SECOND: the clinch (measured in S558, NOT on the page)
`docs/RINGSWITCH_S558.md` has the table: a rote "step in, feint, cross, then clinch" script breaks even on the page
(43 / 53 / 43% wins against the three men; the same script without the clinch wins 3%); "the man tied up gets all his
stamina back" drops it to 18 / 23 / 22%. The balance runs for three clinch versions and the feint cleanup were still
going at the handover: `E:/FightCamp/tmp/s558_balance/batch/` (`done.log`; `clinch_back_all.txt`,
`clinch_net0_back_half.txt`, `clinch_net0_back_all.txt`, `feint_clean.txt`). FIRST RESULT: "all of it back" holds only 7 of 9 bars (the push off dies at 3%: it is the answer to a clinch, so it
needs a second job - Antigravity: let it disrupt a slower punch). Take the mildest version that holds 8 of
9 bars and puts the loop under 30%; then table, two plays, the three tests, `probe_clinch.mjs`, and the words on the
page and in `play_cli.mjs help`. If two versions tie, it is his call (it changes how every bout feels): ask on the board.

## What S558 did (docs/RINGSWITCH_S558.md)
- THE ALL-AGENTS PLAYTEST. Reports in `ops/research/allplay1/<seat>/` (fun, depth, clarity, variety):
  Claude 8, 8, 6, 6 (3 bouts) - Ziva 7, 8, 7, 7 (6) - Antigravity 7, 7, 6, 6 (3) - Dola 8, 7, 7, 8 (3) - Arena 7, 7, 7, 7
  (6, on the page as it was before the changes). Mean 7.4, 7.4, 6.6, 6.8: under the bar of 8 for depth and play.
  Kalli, John, Maria: 1 to 2 beats each, then "grokbots are out of quota" (owner). Cline: 2 bouts and a half, no report
  (free model's daily limit). All five drawings are on the map; Antigravity's is the one to build from.
- ON THE PAGE (8 of 9 bars on both sets, 36 rule tests, the page played to the bell): a round won by 5 points or more
  is 10-8; a man at 0 health throws nothing more that beat; words ("ties you up", "you step in and cut him off", "a
  hand that punches is held HIGH in the other moments", the judges' line). `play_cli.mjs help` says five more rules.
- NOT TAKEN (measured): Ziva's four rule ideas (no gain on the jab), every ground version (the Jabber backs off by
  style, the look-ahead does not change it).
- LOW COVER: played on the page in the browser (his body jab and body cross blocked by my low lead, the new pictures
  played), both picture tests green, the before/after picture sent and on the map. He has not answered it.
- Tools: `ops/Tools/play_by_message.mjs` (via=grok | agy | dola | test), `proto/twohands/tools/probe_clinch.mjs`.

## Then (what the five reports agree on, most to least)
- Backing off is dead and Long is a corridor (8 back offs in 366 beats; every round's first beat is "walk in").
- The guard bar: on every line, explained nowhere on the card, moved on a handful of beats. His open call: cut it,
  rebuild it on stamina (John), or price the block with it (Ziva, Arena).
- Reach is not shown before the beat (a switch that cannot reach should be dimmed: Ziva, Arena, Antigravity's drawing).
- The men break their cards and repeat beats word for word; a feint with no punch behind it (`feint_clean.json`).
- Getting up from a knockdown on 6 can leave a man healthier than the one who dropped him (his call: it is also the
  comeback).
- A MISSED body punch is still at chest height; the overhand plays the rear hook's pictures.

## Seats
- Dola is reachable only while her app runs with its debug port (S558 restarted it: `python ops/Tools/cici/cici.py
  status`). The 30-minute queue sent her SQ324 mid-playtest and cut the thread: one job at a time for her. SQ327 is
  back in the queue.
- Resume a stopped by-message seat with the same command: `node ops/Tools/play_by_message.mjs kalli
  E:/FightCamp/tmp/allplay1/kalli bouts=0:11,1:12,2:13 pace=45` (john 21-23, maria 31-33), ONE bot at a time.
- Cline: `CLINE_MODEL=nvidia/nemotron-3-ultra-550b-a55b:free`, workspace `E:/FightCamp/wt/CLINE_ALLPLAY1` (bouts 1, 2
  and half of 3 are there).

## Not touched this session
MATCHBOTS2 hooks on disk, uncommitted (tests/matchmaking_bots_test.gd modified: not mine). The 05:00 run of 2026-11-25
(517 pass, 6 fail) was checked in S556. No export: the game's scripts did not change.

## Waiting on the owner
His play on the page (now with 10-8 rounds). His look at the low-cover picture. The guard bar: cut or rebuild. The
rest of his Q-336 note ("thecoaches should have").

## Model for S559
Opus, medium effort, Fast off, in a console tab where it can be (the Fable week was 91% used at 22:45 on 25 Nov and
resets 26 Nov 16:00): the toy page and the guard retake need no Fable.

## Landed at the very end, NOT READ
Dola answered SQ324 (the coaches map critics, queued in S551): `ops/research/CRITIC_COACHMAP1_BRIEF_DOLA.md`, committed unread. Coaches are parked (S553), so it waits; open it and verify her claims before any coach work.

## The clinch and feint runs finished after the handover was written (all read)
All three clinch versions hold only 7 of 9 bars, for the same reason: the push off falls to 3% of beats (and with
+1 and all back the clinch itself falls to 3%). "All back": mirror 40%; "+1 and half back": 55%; "+1 and all back":
49%. So NO clinch version goes on the page as measured: first give the push off a second job (Antigravity: it also
disrupts a slower punch in its moment; or it costs him stamina), as a tweak, then measure the clinch fix WITH it.
The feint cleanup (`feint_clean.json`): 7 of 9 on one set - the mirror reads 61% (the bar is 40 to 60). One set is
not enough to drop it: play `seed=2` before deciding. Files: `E:/FightCamp/tmp/s558_balance/batch/*.txt`.
