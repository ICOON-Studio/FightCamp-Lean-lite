# S525 digest (2026-11-19, Opus)

## DONE IN S525 (Opus; all on main, tests named in each commit green)
- Collected 7 probes: GUARDPROBE1, MORNINGSPROBE2, MONEYFOUR2, FITPROBE1 (Qwen), KNOWBOTS4 (Goose #379), TURNPROBE1 (Goose
  #380, finished before its job died on network errors), PROCONTRACT1 (Arena #383). PRs 382-387 closed, issues 379/380 closed.
- GUARD v4 step 2 damage LIVE: amateur and pro wear scales (AMATEUR_SCALE 0.28, WEAR_SCALE 0.40), each block leaks
  transmission x base x K_THROUGH 0.038 into m.damage. tools/guard_onoff.gd (200 bouts a cell, 4 s): damage +7.3..10.5%,
  stoppages up to +3.5 points (6-round mismatch), amateur last bell 0.53, pro6 0.32. Step 3 decided not built. Step 5: result
  row "Got through the guard (in punches)", Ludo's icon beside the corner guard line (FightNight). Guard habits wired
  (slow starter / fades late / chases the stoppage -> wear and recovery, GuardState.after(.., n, opp_habits)); the opponent
  file's habit read names the guard effect (OppFile.GUARD_NOTE).
- TURNING PRO: Arena's blind contract test found the 3rd-decline news line wrong (Roster.DECLINE_NEWS per the design);
  decline_pro with no offer is a no-op; pro_signed keeps the house key. tests/pro_contract_test.gd in run_tests.sh.
- KNOWLEDGE: KNOWBOTS4 yardstick VOID twice -> CLAUDE.md item 8: scope plan KNOWLEDGE_SCOPE_S525.md + KNOWBOTS5.
- STEP LEVERS wired (see 1). tests/step_levers_test.gd (control arm levers_on = false).
- CLASS NIGHTS: a class pays only on an evening it takes from pads (GymSpend.paying_classes) - MONEYFOUR2's free Tue+Thu
  arm is not reachable from the button; the Wednesday class (+$3,042 for 6.9 mastery in 26 weeks) is a real choice.
- LEDGER1 v1 (Dola SQ227) extracted to DESIGN_LEDGER1_V1.md; critics queued.
- The owner asked why memory was full: ~19 idle Claude Code sessions (250-500 MB each) + the app. He closed some (RAM 93% -> 71%).
- Exported (Builds/FightCamp.exe), WHAT_TO_TRY S525 on top.


## MAIN LINE - DO FIRST (S525 left four runs going; collect each)
1. TREEVALUE3 (PC, started ~11:15, ~2 h): tools/treevalue_probe.gd rerun AFTER the S525 step-lever wiring (StepWire
   levers / open_edge: DENY / DRAIN / OPEN / own tank now reach the exchange - TREEVALUE2 read roll_out / push_off at exactly
   0 because only the ropes count was wired). Output E:/FightCamp/tmp/treevalue3.txt (+ the probe's own result page; if it
   overwrote docs/TREEVALUE2_RESULT.md, save it as docs/TREEVALUE3_RESULT.md and restore the old one from git). Then size
   StepEffect.TABLE rows (deny / open / drain) toward 1.5-5 in 100 against each step's own style; rerun; then STEPVALUE1's
   "step worth on the learn card".
2. Goose #388 KNOWBOTS5 (ops/research/KNOWLEDGE_SCOPE_S525.md phase 1): which truth decides a career - rating, potential or
   neither. Decide per the scope's phase 2. NO knowledge screen until K1 passes.
3. Goose #389 TURNTUNE1: ProCall ESTIMATEs sized on TURNPROBE1's pass lines (2 of 9 pass today; "costs" ask best 81%).
   Collect by diff (constants only), rerun pro_call / pro_offer_wire / pro_contract / golden_path.
4. Qwen FITPROBE2 (running, E:/FightCamp/wt/LEAN_FITPROBE2): coach fit on the EVENINGS. Then decide the fit numbers (the
   +3..+5 stat bar cannot be met by x1.32 on today's +3.5 base gain - Claude's call) and wire COACHFIT1. Qwen SPLIT500C
   (GymSpend 492 -> GymDeals.gd) is queued behind it.
5. Critics SQ228 Dola + SQ229 Maria on LEDGER1 v1 (ops/research/DESIGN_LEDGER1_V1.md, checked against the code: signing
   bonus and per-bout entry fee are NOT in the code). 7+/7+ -> his board with `ask --attach`; lower -> revise round.
6. Guard v4 left: step 5's HUD pieces live in scripts/fight3d (HudBars hover transmission %, icon on the bar) - the
   animation session's files: do them when it is idle, or brief it. Step 6 menus: fight plan defence tab, camp/fight-week
   amateur note, opponent style warning (design s3 table). Step 3 is DECIDED not built (the leak is the feedback).
7. Ludo (paid to ~11 Dec, one asset job a session): S525 gave it none. The 5 missing step cards (step_out, pivot_out,
   cut_off, roll_out, push_off in assets/ui/moves) are baked from the game's clips (tools/bake_move_pics.gd), not Ludo.

