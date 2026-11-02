# S249 DIGEST - 2026-10-18 - FIGHTLINK step 1 in the game, workflow automation, heat rule, E: cleaned

Operator, this session (verbatim): "how is our workflow working using the ai automation and leaving the human bottlenecks"; "how can
improve this part ?"; "it seems to me you will still be the bottleneck ?"; heat: "RED at 84 C only when held 2 minutes, instant stop
at 88 C, and RED when free commit memory is under 4 GB" (goal "to allow more work to run so project speeds up"); "free up space on e
... it must be around 100 gb free at least" + the approved delete lists; "have the collector session auto-retire worktrees and gate
clones from now on"; "do not test mechanics we do not use maybe until we actually implement them"; code-PR lane "Push, merge off"
("i picked the wrong one" -> corrected); the corner-shout IDEA (research/IDEA_CORNER_SHOUTS_LEARNED_S249.md).

## What now works (pushed)
- FIGHTLINK1 COLLECTED (8ee89914, Arena #254): rules/FightLink.gd + tests/fight_link_test.gd (FIGHT_LINK failures=0).
- FIGHTLINK1 WIRED (aaed6910): FightRealtime behind `fight_link` (GAME_ON + DEMO_SWITCHES, boxing only). Whiff read LAST (after every
  guard/movement) on a punch still landing -> `slipped`, own stream SEED_FIGHT_LINK (OFF = byte-identical), 1.5x stamina, 0.45 s
  counter window, log why_kind=whiff / by=defender / why line; accuracy x accuracy_mult / (1-0.22) on the ladder; chin x chin_mult on
  head shock + knockdown-from-shock; derive_stats seated once at begin (fl_stats).
- NIGHTLY9 #253 collected (4621bffa): hands_smooth_in_whole gate excludes the striking glove in its contact window (S131 rule). #252
  was already in (S247). The third NIGHTLY8 call (clip cap on played length) was NOT delivered - re-task if it still matters.
- auto_collect fast-lane false negative fixed (6d530720): a RESULT line is proven by the exact line OR the CI runner's own PASS.
- Workflow automation (two side sessions, both verified on master):
  - collector (9e592596, 4d4602cb, 0c1bccf9, 9fe9136d): 30-min reconcile collects/dry-runs PRs (merge needs operator arm), runs and
    review comments self-close on evidence, chat-seat queue, comment-only board answers count, branch_prune (Q-S249-1: delete 333
    branches fully on master), worktree + gate-clone AUTO-RETIRE (holds dirty/unpushed, skips ZIVA, salvages untracked).
  - code-PR lane (a08c5fd8, 940d2da6, 0525523a) MERGING OFF: brief `## Contract` (OWNS/RED_TEST/REGRESSION) + start flag, dispatch-only
    CI regression job, code_gate.py (WOULD MERGE only), Arena reviewer, nightly auto-revert dry run. Proof on #254 passed (4 Actions min).
    Arming needs the operator's yes after one clean night. Not yet: the gate hooked into the 30-min collector; a live Arena review.
- Heat rule (7ee5889f): 84 C is AMBER until HELD 120 s (shared hold clock %LOCALAPPDATA%\FightCamp\heat_hold.txt), 88 C RED at once,
  commit < 4 GB RED (existed). Watchdog loop restarted via its task.
- rule_guard (2923c493): run_tests --only matching > 40 tests, or no --only, is blocked (S249 `--only fight_` = 185 tests, 70+ min).
- E: 11 -> 106 GB free: 8 worktrees + ROOMS3CD + 2 branch-gate clones + 6 tmp scratch deleted (operator's lists); untracked outputs
  in E:\FightCamp\wt_salvage. Pagefile: operator set E: 32-48 GB (C: 16 GB) - REBOOT pending; check commit limit ~95 GB after.

## Evidence
- tests/fightlink_wire_test.gd: RED on master 46c43a20 (failures=5) -> FIGHTLINK_WIRE failures=0. Connect 44.8 -> 35.0% vs defender
  evasion 30 -> 85; 31.3 -> 43.0% attacker accuracy 35 -> 85; knockdowns chin 30: 4, chin 88: 0 (20 bouts each); pooled 32.7%
  (G99 27-32, band 24-38); 502 why-lines e.g. "Reyes slips Perez's double jab (evasion 70 vs accuracy 56)".
- Regression = the 20 tests that play a boxing bout with game switches: SUITE total=20, 1 fail = game_switches_test registry (needed
  fight_link in its engine-key list) -> PASS.

## Not done / still wrong
- Ludo r116 SENT (ask: research/ludo_rx/LUDO_R116_ask.txt; chat "Office PC World Label Design", ~200 credits of 575): A = training
  wear/readiness into the bout (numbers), B = post-fight why + corner report rules, layouts, mockup images. Reply NOT collected yet.
- FIGHTLINK2 (Arena, MoveMastery.gd) still running, no PR at session end - chat https://arena.ai/agent/01a14c07-ba7a-7650-8235-c85358edfcf9.
- Nightly dry run (code lane) saw 6 tests newly red 10-16 -> 10-17: check against NIGHTLY1.
- Actions budget $37.08 of $40 - board Q-S248-2 (raise or keep).
- TRAP: Godot_v4.7.2-stable_win64.exe is GUI-subsystem - PowerShell `&` returns at once unless piped; use Start-Process -Wait or a pipe.

## HANDOFF
Next session: (1) collect Ludo r116 (save verbatim to ludo_rx/LUDO_R116_raw.txt + char count), turn A into the wear->bout verdict for the
board; (2) collect Arena FIGHTLINK2 and wire mastery (roadmap now); (3) Ziva playtest of a FIGHTLINK bout as_game (editor hidden,
wt/ZIVA synced first); (4) corner-shout idea -> Ludo r117 after mastery.
