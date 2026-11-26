# S565 digest (2026-11-26, Fable 5.2)

## His words this session
None yet (the session was opened with the start line). Open for him: the four worker consoles left from S560-S564
(PUNCHCHANCE1, the old GLIDE2 and INSIDE1 workers, the ALLPLAY2 playtester) still hold memory - "close them?" asked in chat.

## Start state
No open board question, no new board answer or map note. Nightly 2026-11-26: 506 passed, 0 failed. PC GREEN, E: 62 GB free.
Render worker (console, Opus): GLIDE2 pushed (7534204a0), INSIDE1 step 3 re-render running at the start.

## Done (commits on main)
- 4bf5a5d94 TASK_LONG1 + `ops/research/s558_balance/long1_l1|l2|l3.json` + `long1_check.mjs` (13 one-beat checks).
  LONG IS A CORRIDOR (5 of 5 testers). L1 the stopping jab (Antigravity): a head jab that LANDS in the moment he steps in
  from Long stops him at Long, he paid the step; a high lead blocks it. L2 the fence (Dola SQ340 design 2): a lead held
  high all beat at Long makes his step in cost 2. L3 both. Bars: 8+ of 9 both seeds and never fewer than the control on
  the same seed; jab 12%+ of beats (today 7-8%); Long at most 45%; steps from Long get in 60%+; no lazy plan.
  A new count tool is asked for (probe_long.mjs): what happens in the beats that START at Long.
  Baseline fact: Long already holds 31-34% of beats; the jab is in 7-8% of beats. Real anchor in our research
  (G99_COMPUBOX_AVERAGES): the jab is 40-44% of punches THROWN by pros; on the page the two jabs are ~27% and the head jab 8%.
- a0a7e8733 LONG1 launched at Arena (arena/cba93bd0). NEW TOOL `ops/Tools/arena_watch.py`: one line when a cloud run's
  result page carries its done line, a STALL line after 75 quiet minutes. Armed with the Monitor tool (30 min, re-arm).
- 8253f0653 Kalli SQ339 collected (`seat_queue.py drain`): her pick THE WAITING CROSS - a cross at Long lands only on a
  man who steps in that moment, as a counter; jabs score 2 on a stepping man. FINDING (`long2_check.mjs` lines 1-3): half
  of it is already on the page - the step is played before the punches of its moment, so a cross thrown at Long already
  lands on a man stepping in (3 health, 2 points), and falls short and hands him counters if he did not come. No tester
  found it. TASK_LONG2 (Arena, arena/193e5c2c): K0 counts it on today's page, K1 her two bonuses, K2 the cross half,
  K3 the jab half; 15 one-beat checks.
- 020d31241 CLINCHFIX2's result page and nine outputs copied onto main (read in S564, never copied). The six collected
  Arena pull requests (456-461) closed with a note; READY TO COLLECT is empty.
- 0cc937e64 `proto/twohands/wait.html` - HIS QUESTION (S562) "can i be able to select exactly on which part of a beat i
  move ? or it breaks balance ?" as a playable copy: MOMENTGAP1 version B, the step may come one moment later (a switch
  beside the order, the wait as its own chip). Built by `python proto/twohands/tools/make_wait.py` from order.html +
  `moment_gap_b.json` (never edited by hand); `wait_test.mjs` 5; its jump button "Pick your moment" on the ops board.
  Shown: `ops/previews/s565_wait/wait_late_step_plan.png` (beat_shot).
  DEFECT FIXED ON EVERY PAGE: with three moments set, the last line under the ring ran off a 1080 screen (seen on
  order.html too) - the moment lines now flow in a row (`#seqwords`, order / head / kick, punch + wait rebuilt).
  `body_ui.js` words() knows the wait (it read `ACT[P[sl]]` for every slot of the order: a new slot crashes the body view).
- de48f9ae0 KDHEAL1 collected (Arena): KEEP today's get-up [6, 4].
  | Version | get-up | Bars | Stoppages | Knockdowns | Comeback (4+ behind after round 1 wins) |
  |---|---|---|---|---|---|
  | KD0 today | 6, 4 | 8 of 9 | 29% | 2.5 | 19% |
  | KD1 | 4, 3 | 7 of 9 | 45% | 2.8 | 14% |
  | KD2 | 4, 2 | 7 of 9 | 44% | 2.8 | 4% |
  | KD3 | 3, 2 | dropped at trial | 75% | 3.2 | - |
  The bots show no "walk into a punch at 1 health" pull (both hands thrown in 14-15% of low-health beats v 17% overall):
  the mix and the value table are health-blind, so the exploit is a human's. If he wants it gone the shape to measure is
  "up on no more than he had, no stamina refill", not a lower floor.

## MOMENTGAP1 FINAL (Arena, collected: docs/MOMENTGAP1_RESULT.md) - his S562 question answered
"can i be able to select exactly on which part of a beat i move ? or it breaks balance ?"
| Version | Seed 1 | Seed 2 | A wait is in | What breaks |
|---|---|---|---|---|
| Today's page (fresh controls) | 7 of 9 | 8 of 9 | - | jab / overhand landing; push off under 3% on seed 1 |
| A: a free wait anywhere | 7 of 9 | 7 of 9 | 66-67% of a man's beats | two-punch beats 16-17% -> 9-10%, holding 11-13% -> 4%, the overhand at the 3% floor |
| B: only the step may come a moment later | 8 of 9 | 8 of 9 | 8% of a man's beats (15% of beats have one) | nothing new: the same landing bar the page fails |
Verdict: "put on the page: B". Counters a bout 2.5-2.6 -> A 2.9-3.1, B 2.6-2.8; no order becomes a must (none over 16%).
No runaway loop: a man waits LESS when ahead and after his own counter. Limits: the mirror only, not the three styled
men, no human play. B is built to play: wait.html. Asked on the board whether it goes on the main page (his call: a
new switch on his page).

## KDFIRST (S565, `probe_kd_first.mjs`, today's page, two seeds of 84 bouts) - the knockdown beside real fights
| | Page seed 1 | Page seed 2 | Real (John SQ337, UFC) |
|---|---|---|---|
| Bouts with no knockdown | 1% | 5% | most fights |
| The man dropped FIRST wins | 13% (11 of 83) | 13% (10 of 80) | 34.4% when the fight goes on past the knockdown (13.9% of all fights with one) |
| The first man dropped TWICE wins | 4% (2 of 45) | 14% (7 of 51) | 7% |
| The bout's only knockdown: that man wins | 5% (1 of 20) | 0% (0 of 12) | - |
Reading: on the page nearly every bout has a knockdown (2.5 a bout) and the first one already decides more than in real
fights (13% v 34%). The heal is not too generous in results; a lower get-up would widen the gap from real fights.
The comeback share on these runs (the page's own table) was 12% and 6% (Arena's rebuilt table: 19%): a noisy number at
84 bouts - never judge it on one seed.

## Running at the handover
See NEXT_SESSION_PROMPT.md.

## Still running on the PC at the ship
`proto/twohands/tools/probe_kd_first.mjs` (two seeds, 84 bouts, two cores; outputs
`ops/research/s558_balance/results/kd_first_0.txt` and `_s2.txt`): on today's page, how often the man dropped FIRST wins
and the first man dropped TWICE wins, beside John's UFC numbers (34.4% when the fight goes on past the knockdown; 7%
dropped twice). It goes into the knockdown-heal report to him.

## Tooling
- `ops/Tools/arena_watch.py` (new).
- `agent_comms.py` start check: a numbers-only probe brief (Kind: probe, VISUAL: none) is no longer flagged for a missing
  visual gate (7 flagged -> 3, all parked card-game / coach briefs).

## After the ship
- wait.html runs on its own look-ahead table (`proto/twohands/vtable_wait.json`, built in 875 s at jobs=2; its values
  match the table Arena measured B on). page_parse, page_play_test 4, wait_test 5; one beat played in headless Edge.

## Stage 2
- a7099d35d CLINCHFIX3 collected (Arena): NONE. H1 (a clinch enters his habit history) 48 / 57 / 53% for the loop against
  the Jabber / Slugger / Body Snatcher, H2 (+ clinch +1 stamina) 37 / 58 / 42%; today 38 / 63 / 70%; the bar is under 30%.
  His read fires 4-7 times a bout and it does not matter: the clinch never repeats inside the 3-beat history (it breaks
  to Mid), so the read answers the loop's punching beat. Bars: H1 8 and 8 of 9, H2 7 and 8.
  THIRD FAILED CLINCH ROUND (CLINCHFIX1 economy, CLINCHFIX2 push-off counter, CLINCHFIX3 the read) -> no fourth clinch
  fix. Read of `probe_clinch.mjs`: the loop is "step in, FEINT, OVERHAND (cross if he cannot pay)" then "clinch" - the
  clinch's +2 stamina pays for a 5-stamina bomb beat every other beat, and the feint makes the overhand uncoverable
  (Antigravity: 12 of 13 landed). The same man without the clinch wins 7-13%. So the loop has two legs, and JABLAND2's
  versions cut the other one: D the feint opens the overhand only Inside, E a punch landing in your feint moment wastes
  it, F both. CROSS-CHECK run on the PC: `probe_clinch.mjs n=60` on today's page and on D, E, F (the page's own table).
