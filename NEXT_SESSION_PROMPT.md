# S486 handover (written 2026-11-15 at the end of S485; S484's handover is in git history)

OPEN IN E:\FightCamp\Lean. START: `git pull && python ops/Tools/agent_comms.py start`, then `python ops/Tools/where_we_are.py roll S486`.

## USAGE RULES (kept)
- Run `get_usage` first. Hand over at 420k; start the wrap-up at ~310k. The Miro P0 redraw costs ~20k each time: do it
  once at start and once at the end, never more.
- Godot jobs through `python ops/Tools/godot_slot.py run --who s485 -- <cmd>`; `timeout` OUTSIDE godot_slot. Single tests
  as tools/run_tests.sh runs them (`--headless --audio-driver Dummy --fixed-fps 60`); a runner script for a test list was
  used in S483 (xargs -P 3, rc + SCRIPT ERROR check).
- Never `cd` into a worktree (S483 did once by accident); use `git -C <wt>`.
- Arena: pure modules only, it has no Godot - run its test yourself. Lite mirror `python ops/Tools/lite_mirror.py --lean push`.
- Qwen rerun: a landed run blocks seat_dispatch (worktree, local + remote branch, run record). Save the old commit to
  `<branch>-r1`, retire the worktree, delete both branches, mark the run failed, `seat_dispatch.py retry <ID>`, then `--act`.
- Goose: GOOSE_PER_DAY 3 (S483 used all three). Briefs say "never sleep to wait; foreground timeout".

## WHAT S485 DID (ops/research/S485_DIGEST.md)
- Club week v1 WIRED on his S484 answers: loyalty bar on the Overview ("62 - Settled"), LoyaltyWire (sponsorship +5/-8,
  Monday drift to 60, wants_sponsor -3), pro share 10% under 50, a day job = 2 of 6 mornings (WORK on the week plan),
  film seats (third boxer in a fight week watches alone). CHECKs 4/6/7/10 closed. Leaving + the talk = R58 build (not done).
- Arena x3 merged (DAYJOB1 with 2 parse fixes, FILMSEATS1, STEPEFFECT1); STEPVALUE2 running at wrap-up.
- FOURSTART1 money with classes + ticket cuts -> board Q-S294-246 (one sponsored starter, three on day jobs).
- Arena prompt recipe that works: navigate arena.ai/agent, wait 6 s, click (400,272), execCommand insertText into
  document.activeElement, wait, send button at about (661,360) in the 800x600 frame. Brief has a GDSCRIPT TRAPS paragraph.

## IN FLIGHT (collect, do not resend)
- Qwen CLASH7 (qwen/clash7, wt E:/FightCamp/wt/LEAN_CLASH7, ETA ~13:44): RUN its hidden film yourself; bar in
  ops/research/TASK_CLASH7.md (08_jab and 09_jab 0 frames > 0.02 m, regression set not grown, pass log regular).
- Arena STEPVALUE2 (https://arena.ai/agent/01a1dec4-84c1-7fed-8c3f-c62337d95d4f, a lite PR): run tests/step_value_test.gd.
- Seat queue: SQ172 John (training K critic), SQ174 Kalli (STYLE4 levers -> Qwen code brief + retune all six at 100 bouts a
  cell), SQ175 Kalli (ladder v3 -> two fresh critics).

## FIRST
1. Collect CLASH7 and STEPVALUE2; seat answers.
2. R58 build (ops/research/R58_MAP_S439.md section 8; pro share stays 10% per his Q-244, the map says 12%): APPROACH1 and
   PROMISE1 to Arena/Qwen first hour; LEAVE1 + LOYALHOOKS1 Claude (removing a fighter touches c.fighters, a booked bout, UI
   fid refs, the save; c.fighter() is fighters[0]).
3. STEPVALUE1: piece 3 (the ropes count inside the exchange) and wiring StepEffect into LiveRound; then probes 2-7.
4. Q-246 answer -> FOURSTART1 start state.
5. His look/play gates (chart, training K, fight week) for PLANFLOW1 rest and FIGHTWEEK3.
