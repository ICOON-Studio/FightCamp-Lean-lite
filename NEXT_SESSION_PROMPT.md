# S446 handover (written 2026-11-12 ~22:35 at the end of S445; S444's handover is in git history at b5b8c7d8)

OPEN IN E:\FightCamp\Lean. START: `git pull && python ops/Tools/agent_comms.py start`, then `python ops/Tools/where_we_are.py roll S446`
and redraw Miro.

## USAGE RULES (kept)
`get_usage` first; hand over at 300k context (S445 handed over at ~345k; week at 13%); at most TWO helpers; tell him the cost
before a batch; one session coordinates and pushes, helpers report by SendMessage (tell each helper your session name at start).

## HIS WORDS IN S445 (verbatim)
- "check other running session to report here" (both running sessions were pointed at the coordinator; both reported).
- On the fight screen call box: "should we make this fill up with time and make it the shout call ?" -> "Yes, build it".
- "show it" (the regroup v2 stills were sent; his default call still open).

## DONE IN S445 (all pushed)
- Ask for a fight MAP v3 (ops/research/ASKFIGHT_MAP_S441.md) from Kalli 5/6 + John 6/6 on v2. Built in scripts/rules/AskBout.gd +
  FightLearn.gd (ask_bout_test with 5 new mutants, fight_learn_test green, ee315955): asking opens after the first bout (pack 2.5);
  camp words by phase (a 14-day show is a PEAK camp; Set camp needs 7 days); a scale miss closes Ask on that date (strip.ask_ok);
  the road says when the nationals cannot be made from this show; unranked step up = "Nearest better record"; teach words 0.6/0.85.
  Decided: the host's "no" is always a closed panel or absent card with its reason (CRITIC_PACK line 152 updated).
- POWER1 step 1 collected (cddf2815 = fa3bbf7e + its ruler 4b5ae5ed; punch_weight/body_keep/cam_line/fighter_look 0).
- Regroup preview (user arg hudregroup, scripts/fight3d/HudRegroup.gd 482/500): the corner's shout IS the call box - on the line
  to her head, tagged Heard/Half heard/Not heard at once, a wash fills it over its exchange (the corner bar's ring), full =
  Worked/Did not work, then the call name takes over and fades; it takes over BOTH shout paths (caption line AND the corner-post
  bubble: ReactionBubbles shows the shout as a bubble whenever our post is on screen - the S444 cloud only caught the caption
  path). Stills docs/mockups/s445/hud/shout_1..3, on the review board. "Light on her feet" -> "Light on the feet".
- SHIPPED for everyone (b7f596c0): LANDED + CALLS WORKED counted the exchange still playing (settled at its start: the board showed
  this call's cross at 0:30) -> CornerBar._ex_over counts finished exchanges only; HoverLabel tags 16 -> 20 px (corner_bar_test
  was red on main). tools/fight3d_play.gd takes p03c_shout_half / p04b_shout_full when run with hudregroup.
- Build exported (Builds/, docs/WHAT_TO_TRY.txt S445 section).

## IN FLIGHT
- ASKPROBE2 (Qwen, branch qwen/askprobe2, worktree E:\FightCamp\wt\LEAN_ASKPROBE2, launched 22:22, ETA ~23:30-00:00):
  tools/ask_probe2.gd + docs/ASKPROBE2_RESULT.md. Bar in ops/research/TASK_ASKPROBE2.md. Collect by diff + its RESULT line.
- POWER1 steps 2-4: session power1-step-4 [local_50fabfac-0548-4a0b-9780-6871f90cd93c] in E:/FightCamp/wt/LEAN_POWER1 (branch
  claude/power1): blind read, then one fix round; it SendMessages the coordinator. Known reds at its start: punch_range 72
  (control 100), hooks in band 5/9, clean hits off 20 (control 17), toes crossed 16 (14), lead uppercut pop 28.6 m/s. Ruling:
  uppercuts at the measured 0.83-0.90 m, floor 0.70. Collect only steps the read says COLLECT. Steps 5-6 never ran: brief fresh.
- JUDGES1: HELD, nothing collected. Branch judges1 @ 1f1ed715: JudgedRound.gd (250) + test; BoutRead +7 lines (495/500).
  judgesdecide: 3 Maria cases inside 0.06, but Lucy +6 v Erin 0.443/0.542 and plan v Priya 0.383/0.444 fail; ~100 ms a reading.
  Round 3 later, fresh brief: ropes/pins in the walk, TheRead's build-up, the cost cut. The helper session is done.

## NEXT, IN ORDER
1. Tell power1-step-4 your session name; collect ASKPROBE2 when it lands; spread ok -> two FRESH critics on map v3 -> 7+ both ->
   logic check -> one drawing for his pick.
2. His call on regroup v2 + the filling shout as the default: on yes, move each part into its owner file (SidePanel 470/500: new
   pieces in their own files; HudRegroup's shout block becomes its own file) and drop the flag.
3. POWER1 collect per the read; BLOCKLOOK1; RESULTLOOK1. Fight bars stay parked (Q-205).

## TRAPS (S445)
- A shout has two display paths (FightView: ReactionBubbles.take, else the caption line); hook both.
- A call is picked only in the pause at an exchange (CornerBar._shout needs view._shouting) and the live round SETTLES the
  exchange at its start: anything reading LiveRound "ex" during play sees the future. Use finished exchanges (t >= (i+1)*30).
- fight3d_play stills land at fixed moments; a preview element needs its own shot (gate it on the user arg).
- seat_dispatch reads the watchdog: RED (RAM 98% while he plays) refuses launches; queue the row and re-run `--act` later.
- dispatch_queue.json rewrite by json.dumps reformats the whole file (big diff, same content).
