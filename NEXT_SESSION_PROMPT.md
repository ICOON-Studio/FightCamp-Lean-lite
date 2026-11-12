# S445 handover (written 2026-11-12 ~21:20 at the end of S444; S443's handover is in git history at e8d9801c)

OPEN IN E:\FightCamp\Lean. START: `git pull && python ops/Tools/agent_comms.py start`, then `python ops/Tools/where_we_are.py roll S445`
and redraw Miro.

## USAGE RULES (kept)
`get_usage` first; hand over at 300k context (S444 handed over at 291k; week at 11%); at most TWO helpers; tell him the cost
before a batch; one session coordinates and pushes, helpers report by SendMessage.

## HIS WORDS IN S444 (verbatim)
- "Yes, start it" (JUDGES1 helper); "adjust model and effort according to task" (set to Opus, high);
  "do the Q-196 fight screen stills meanwhile"; "check board".
- On the judges moving a good plan v a presser from 59.7% to 41.7%: "if good plans means counter to presser then i think its ok"
  (it is: 1-1, step back, pivot out, tie up) -> the BoutRead model went ahead.
- His markup on Q-206 (ops/Feedback/2026-11-12-12 .. -19): round box WRONG (no note: read as the wood, like C327); "use a line as
  connector ... away from the head and maybe fade it away and bring it up when something change"; her plate "reminds way too much
  other games, try something different"; "what is energy ? is it stamina ?"; "instead of empty circle use the organ icon";
  AIM buttons "what are these options do?" (answered in chat); calls box "what is this for?"; corner caption "use a cloud-like icon
  ... move it towards the corner its coming from"; Rests/Tires "display the stamina cost ... with icons+numbers".

## DONE IN S444 (all pushed)
- Ziva: started at S444 start, then STOPPED at the end (he asked "why you start ziva every session ? does it always have tasks ?": it had none). `start` now restarts it only when Ziva has a live run, dispatch row or plan row (_ziva_work); idle = "ZIVA idle ... not started". Its old dirty state is on local branch wip/ziva_s444 in wt/ZIVA_LEAN.
- Ask for a fight: ops/research/ASKFIGHT_CRITIC_S444_BRIEF.md (pack + map v2 + measured probe) queued to Kalli SQ45 and John SQ46
  (fresh, free). Answers land as ops/research/ASKFIGHT_CRITIC_S444_KALLI.md / _JOHN.md. SQ43 (Dola, v1 brief) is stale.
- TASK_JUDGES1 contract passes. JUDGES1 steps 1+3 collected (fc518181): Judges WEIGHTS clean 1 big 12 ring 2 initiative 8
  work 1, LEAN_MULT 5 -> (a) 85.9 (b) 11.6 (c) 12.3; docs/JUDGES1_RESULT.md. Verified: JUDGES failures=0, BOUT_READ PASS (off).
- Q-196 regroup in the game as a PREVIEW (user arg `hudregroup`, scripts/fight3d/HudRegroup.gd, 350 lines, wired in FightHud.build):
  small maps under the plates with organ icons + counts (RoundHits.icons), one read of her mode, STAMINA/LEGS/GUARD, skips dim
  until the mouse is near, call box off her head on a line + fade, see-through round box, her plate as the corner's read in words,
  stamina cell + number per call (CornerBar sets meta "cost"), our corner's shout as a cloud on our side. Stills docs/mockups/s444/hud/
  (v2 = after_regroup_v2*.png), on the review board; question Q-206.
- SHIPPED for everyone (his "what is this for?"): calls box heading CALLS WORKED?, a call's name no longer cut (round_board_test green).
- Build exported at wrap-up (Builds/, see export log E:/FightCamp/tmp/s444/export.log).

## IN FLIGHT
- JUDGES1 helper [local_88a8afe6-f9ac-41cf-a487-47a42b3ec98d], branch `judges1`, Opus high: judged-round model in a NEW file for
  BoutRead.chance (bar: bout_read_test -- judgesdecide PASS, the 3 Maria cases inside 0.06), then the texts ("counts double" ->
  five times; WHY line on a judges' decision), regression with/without judgesdecide, DECIDES=true in one commit, result-page stills.
  It reports to the coordinator by SendMessage: YOU are the coordinator now (it finds you via list_sessions? no - tell it your id
  with SendMessage when you start). Collect by diff + the bars above; never let it push main.
- POWER1 (S439 lead, worktree LEAN_POWER1): step 4 was rejected; collect step 1 only (fa3bbf7e) until a fresh blind read passes.

## NEXT, IN ORDER
1. Tell JUDGES1 your session id; collect it when it lands.
2. Q-206: on his yes, move each regroup part into its owner file and drop the flag (SidePanel is 470/500 lines: put new pieces in
   their own files). On "more marks", read ops/Feedback newest first.
3. Ask for a fight MAP v3 (critics on v2: Kalli depth 5 / play 6, John 6 / 6 - ops/research/ASKFIGHT_CRITIC_S444_*.md). Their
   main hole ("A NAME YOU PICK downward = pay for the highest band below, a lookup") is already closed in code by Q-204 (picks
   above or level only) - the map still says "up to 4 places either side": fix the map. Also: a 14-day show is PEAK camp, not
   "no camp"; teach-word cut points from the probe's 0.47-1.05 spread (0.4/0.7 labels every card the same); hide the nationals
   chip when unreachable (0% from day 40); a later show when the scale misses; case E needs a written-plan test. Re-measure the
   probe with picks above only, then two fresh critics.
4. POWER1, BLOCKLOOK1. Fight bars stay parked (Q-205).

## TRAPS (S444)
- A PanelContainer lays out its children: a decoration (the cloud tail) must sit outside it.
- The organ PNGs are RGB on #090f17 (no alpha): RoundHits._clear_pic makes the ground see-through.
- Every Godot job, renders included, goes through `python ops/Tools/godot_slot.py run --who <you> -- ...` (rule_guard).
- `cd` inside a Bash call moves the session's folder: use absolute paths for other worktrees.

## ADOPTED FROM HIS TWO OLD CONCEPTS (S444 end; his words: "what do you think of this , if it gives you any ideas or improvements adopt it")
docs/mockups/s426/intermission_playbook.(html|png) and docs/mockups/s427/index.(html|png), rendered S444. Decided:
- CORNER MINUTE: "What do you tell Lucy?" framing; THE IF/THEN ANSWER: the read on her habit (TheRead.gd already fills a
  read meter and fires a counter) gets a player choice - which combination answers that habit ("Maria loads up after the
  jab -> slip outside, 2-3"). A cap of two changes a minute (time pressure, his S443 ice-bag ask). This is the lever the parked
  fight bars lacked (PUSHPROBE2: the coach's edge comes from the calls) - fold it into the bars v3 map, Ask for a fight first.
- HOME: a one-line question headline ("What needs your corner?"), NEEDS YOUR CALL rows each with its own button, a SINCE LAST
  MONDAY column of changes only (+2 jab mastery, +4 members, a new tell), and the CONTINUE button naming its next stop (TopCards
  has the next stop already: put it on the button). Check today's Home first; add only what is missing.
- NOT adopted: wooden frames (his S430 "wooden panels to go", C327), body text under 20 px, paragraph cards (S416 graphics rule).
