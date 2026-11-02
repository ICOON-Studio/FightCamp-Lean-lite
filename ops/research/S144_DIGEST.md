# S144 DIGEST - 2026-10-02 (after the PC restart): PC heat control, empty-gym start, the first real playtest

## 1. What now works (each with its evidence)
- Pagefile on C: only (Win32_PageFileUsage: C:\pagefile.sys 31904 MB, none on D:). LibreHardwareMonitor running (:8085).
- Watchdog temperature limit 84 C (operator: "you can go upt to 84C"), RED only when SUSTAINED over 10 s (operator: "yes make
  it sustained 10 seconds") - 47391486; AMBER 74. Heavy-job GOVERNOR in the watchdog loop: every Godot/Blender process pinned
  to the same 6 of 16 logical CPUs, re-applied every 5 s (afab89f9) - verified on 6 sandboxed Codex Godots; Tctl 76-80 C with
  3 Godots vs 82-88 before. Worktree watchdogs carry the S143 sandbox fallback (they did not - every agent read RED forever).
- Ops board: snapshot TTL 60 -> 300 s (940365ed) - the 51-90 s `board` build ran back to back and pinned one core.
  /agents shows who works on what LIVE (38c1aa73, 76ada6b9): one row per running CLI process (worktree + task from its own
  command line), plain-words title, started, running for, last file change, ETA, waiting queue, finished today, Claude's own
  task. Registry: AgentComms/live_runs.json (update at every launch and landing - CLAUDE.md s8).
- Operator: 3 shell agents at once (PC heat). Relaunched from checkpoints: C241, MH2, U211, Q213B, G158 (resume prompts
  AgentComms/prompts/<id>_rN.txt); G159 checkpointed by Claude (1dcb8b12) after its run ended on its own compaction.
- Career tests red since the 10-02 nightly fixed (0f3b4e11): fight_contract, contract_clauses, press_conferences,
  tournaments - G153's FightGate enforces two operator rules the old book_fight skipped; tests now recover/re-card. 4/0.
- C242 (bisected, 503f8630): the boxing guard idle had two sources - the C237 merge (08b4444f) overwrote the path in
  FightStagePlayer.bind() with c237/active_guard.glb (2.4 s, operator-approved S139) while FightClipBinding named
  Bouncing_Boxing_Idle (2.2 s). One source now; idle_metadata_for uses RawAsset (export keeps raw .glb beside the exe).
  boxing_idle_binding + certified_palette 2/0; fight_strike_whole 3678/0.
- EMPTY-GYM START (2ecbf74b, operator: "from the start without any boxer, maybe only some basic equipment"): the game's new
  career has no fighters/staff, starter floor + $25,000; --script tests keep the starters (control arm).
- C241 gloves: own Blender gloves failed review (thumb through); operator approved, Claude downloaded the CC-BY 4.0 Sketchfab
  "Boxing Glove" by Incg5764 -> E:/FightCamp/incoming/ (+ CREDITS.txt; NoAI tag noted). Run 4 brief written (C241_r4.txt).

## 2. The playtest (operator: "evaluate the whole game experience and loop" ... "check how pros do the playtests")
PLAYTEST_PROTOCOL.md (Bromley severity scale, think-aloud, RITE, FTUE funnel, PLAY heuristics) + tools/s144_live_walk.gd (live
one-command driver). PASS 1 = PLAYTEST_S144_PASS1.md: first 15 minutes good; the LOOP DOES NOT START - a female boxer has 0
bookable bouts for 6 weeks (generated offers are always men + hidden from amateurs; no women's amateur cards), payroll billed
monthly heads to bankruptcy ~week 8; 44 issues ranked. Fix briefs: TASK_C243 (a fight for every fighter, CRITICAL),
TASK_U213 (empty-gym first hour reads true: home CTA, staff hire button, honest counts, dev text, week review, ICONS in exe).

## 3. Agents at handover
RUNNING: MH2 (Codex astra), Q213B (Codex luna), G158 (Grok). LANDED: U211 (slide -30%, acceptance missed, C223 + video owed),
C241 run 3 (own glove failed; run 4 = fit the downloaded glove). WAITING (in order): C241 run 4, C243, U213, G159 (venue
backdrop in the ring + dark house), U211 remainder.

## 4. Rules this stage earned
- A walk driven with --script plays the TEST game; pass `as_game` for anything that judges the player's game (run 0 of the
  playtest kept the starters).
- Agents quit when the PC is hot: every brief says "when RED, wait and poll; never end the run because it is hot".
- A background launcher with a time limit kills its child agent (G158 run 2) - launch long agents detached.
- The temperature reading is Tctl (hottest spot, jumps 5-10 C); the CCD average runs ~10 C lower.

## 5. Tests
fight_contract/contract_clauses/press_conferences/tournaments 4/0; boxing_idle_binding+certified_palette 2/0;
fight_strike_whole 3678/0; parse on every touched .gd. Not run: the full suite (nightly only).

## 6. Next (the decision)
Launch C241 run 4 (glove fit) on the first free seat, then C243 (fights for every fighter) - C243 blocks the demo loop.
Collect MH2, Q213B, G158 as they land (open output, merge as a diff). Then U213, rebuild the .exe, PLAYTEST PASS 2 with the same
protocol; then the operator's own cold session (HOME-key recorder, think-aloud).
