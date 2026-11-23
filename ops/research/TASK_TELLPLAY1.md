# TELLPLAY1 - a tell changes how the opponent fights: two flagged rules, measured on the read and the real bout (S543)

Kind: design + probe. Model: claude-opus-5-5 (Code Mode tab). Commit only your paths (`git commit -m "..." -- <files>`), do not
push. Godot only through `python ops/Tools/godot_slot.py run --who TELLPLAY1 -- <cmd>` (headless, Dummy audio), ONE run at a
time, output to a file, wait on its done line (a killed waiter leaves Godot running: check by PID). Before each run:
`powershell -NoProfile -ExecutionPolicy Bypass -File ops\Tools\pc_watchdog.ps1 -Once`; RED = wait; the owner's game
(ArcheAge) in the top list with memory AMBER = wait. Two other workers share the Godot queue (COACHDEEP7, FWLOAD2).
Estimate: 3 hours. Size each full run to finish in under 45 minutes on one slot (time one cell first); run the FULL size
before any verdict.

## Why
Read `ops/research/TELLPLAY_SCOPE_S543.md` first, then `docs/TURNPROBE18_RESULT.md` ("Measure first", "Which tell a line can
answer", "Why", "The next step"). In one line: a line the player writes against an opponent's weapon or weakness adds a
median 0.2-1.1 points over the coach's plan, because the tell does not make the opponent fight that way more often; the
fade answer alone adds 7-15. This task measures the fix. Nothing under scripts/ or tests/ changes: the two rules are
FLAGGED LOCAL COPIES inside the probe.

## The two rules to probe
A. THE TELL PLAYS. Each weapon and weakness that `scripts/rules/OppFile.gd` maps to a plan situation (WEAPON_ANSWERS and
   WEAKNESS_ANSWERS, the fourth column: press / range / counter / loadup / tiring) gives that situation a WEIGHT in the
   opponent's game mix - the same weight in the read (`scripts/rules/BoutRead.gd` `_games`, which calls
   `Exchanges.next_mode`; today it passes only the style and "walks in") and in the live bout (the same `next_mode`; it
   already takes a `bias`: open it and say what it is before using it). Start size, an ESTIMATE to tune: the tell's
   situation takes 1.5 times its share of the mix, and at least 10 points of share more. Tells with no situation ("chin",
   "slow to start", "drops the right") are out of this task: list them and say what each does today.
B. THE FADE ANSWER UNDER THE CAP. The tiring situation reads a plan line at `PLAN_REACH` x `PLAN_CARRY` of its edge with no
   fire share (`BoutRead.gd` near lines 248 and 378). Bring the best fade line to 10 points or less with the smallest
   change (a fire share like the other situations, or a lower carry): say which and why.

## Do
1. `ops/research/DESIGN_TELLPLAY1.md`: one page. What the code does today (every claim opened today, file and line): how the
   opponent's next game is chosen, what a weapon and a weakness change today (`RoundStyle.from_opponent` moves the punch
   mix), where the plan's line is read and how often it fires. The two rules with their numbers and the real-world
   reason (a body puncher does come forward more; a fighter with a big right hand does load up). Where the player sees it:
   a table of the film panel, the opponent's file, the plan board and the result's Why - what each shows today and what
   line it gains ("Presses more than the style: body puncher"). Feedback loops. The bars (below), written BEFORE any run.
2. Probe `tools/tellplay1_probe.gd` (+ `tools/tellplay1_rules.gd`, a summary script if needed; each under 500 lines). Start
   from `tools/turnprobe18.gd` stage=measure (the ten types, their pro-ready books, the 180 opponent files): copy, do not
   edit it. Two instruments, both required:
   - THE READ: the game's win read with rules A and B on and off (the control arm), same files.
   - THE REAL BOUT: the game's own bout (`Bouts.fight_step` + `LiveRound`, as `tools/pushprobe2.gd` plays it), paired dice,
     the same line on and off, rules on and off. Sized so a 3-point difference is outside the noise (say how sure).
   Fighters differ (the key is `stats`), women against women, same class; the population named in the output.
3. Bars (never loosened):
   - (1) THE PLAYER'S LINE PAYS: for at least 4 of the 5 situations, the best line against a tell that maps there adds a
     median of 3 points or more over the coach's plan, for at least 6 of the 10 types.
   - (2) NEVER A WIN BUTTON: no line adds more than 10 points for any type against any file.
   - (3) THE WRONG LINE COSTS: the worst line a boxer can write against a tell loses a median of 2 points or more.
   - (4) THE FILE MUST BE READ: for no type is one line the best against more than half of the files.
   - (5) THE READ IS THE FIGHT: the best line's gain in the real bout is within 3 points of the read's, per situation.
   - (6) THE GAME DID NOT MOVE: on the coach's plan with no player line, the population's mean win rate moves under 2
     points between rules off and on, and no style-against-style pairing moves more than 6 (real bouts).
   - (7) THE COACH STILL MATTERS: print the same table at coach rating 40, 58 and 75 (no bar: the size of the player's
     part under a weak and a strong coach is a finding the owner needs).
4. Result `docs/TELLPLAY1_RESULT.md`: verdict first; the bars; the tuned numbers (before -> after); honest limits.
   PASS -> say exactly what to change under scripts/rules (functions, constants), and list the tests that pin an exact
   bout result or mix and would need re-pinning (`grep` tests/ for next_mode, _games, the mixes; do not run them).
   FAIL -> which bar, the one change that would fix it, stop. No second design round and no critic brief in this task.

## Feedback loops
- Tell -> the opponent's mix -> the answering line fires more -> wins. One way: the file is fixed for the bout and nothing
  writes back to it. Cap: 10 points a line (bar 2).
- The opponent plays one situation more -> plays the others less -> lines written for those fire less. A zero-sum mix:
  print the whole mix per file, rules on and off, and STOP if any situation falls under 5% of the mix for a style that
  lives on it.
- The pro corner that reads YOUR boxer (`ProRead`) is the mirror of this and is NOT changed here: say whether rule A, as
  you wrote it, would also apply to the player's boxer when the opponent's corner reads a tell (it must not, in this task).
- ONE-REP TRIAL FIRST: one type against six files (one per situation and one with no tell), read and one real bout each,
  printed in full. STOP and fix the page if the mix does not change with the tell, if the control arm does not reproduce
  TURNPROBE18's numbers for that type, or if a line passes 10 points.

## Prior research
`ops/research/TELLPLAY_SCOPE_S543.md`, `docs/TURNPROBE18_RESULT.md`, `docs/TURNPROBE16_RESULT.md`,
`ops/research/DEPTH_AUDIT_S534.md` (rows 24, 25; changes 4 and 5), `docs/PUSHPROBE2_RESULT.md`,
`ops/research/topics/plans_corner.md`. Run `python ops/Tools/prior_research.py tell film plan answer worth` and say which
earlier measurement of a tell's worth (tests/tell_worth_test.gd, FILM_PER_ANSWER) this agrees or disagrees with.

## What would a human do?
A coach who has watched the tape tells the boxer what the other man WILL do, not what he might: "he comes forward behind
the body shot all night; step off and catch him coming in." The answer pays because the opponent keeps doing it. A wrong
read of the tape has the boxer waiting for something that never comes.

## Prefab check
None (a rules probe on our own modules).

## Contract
OWNS: ops/research/DESIGN_TELLPLAY1.md, tools/tellplay1_probe.gd, tools/tellplay1_rules.gd, tools/tellplay1_sum.py, docs/TELLPLAY1_RESULT.md
RED_TEST: tools/tellplay1_probe.gd
REGRESSION: none
VISUAL: none

Do not ask questions: decide, and write what you decided in the result.
