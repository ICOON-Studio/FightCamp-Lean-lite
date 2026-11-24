# CORNERCMD2 - the corner commands, round 2: the three failed bars, four named changes, a STOP RULE (S545)

Kind: design + probe. Model: claude-opus-5-5 (console tab). Commit only your paths (`git commit -m "..." -- <files>`), do
not push. Godot only through `python ops/Tools/godot_slot.py run --who CORNERCMD2 -- <cmd>` (headless, Dummy audio), ONE
run at a time, output to a file, wait on its done line (a killed waiter leaves Godot running: check by PID). Before each
run: `powershell -NoProfile -ExecutionPolicy Bypass -File ops\Tools\pc_watchdog.ps1 -Once`; RED = wait; the owner's game
(ArcheAge) in the top list with memory AMBER = wait. Other workers share the Godot queue.
Estimate: 1.5-2.5 hours (the probe exists: the full run took 53 minutes on one slot). Run the FULL size before any verdict.

## Why
The corner commands are the owner's design (`ops/research/PUSH_KNOW_INTERVIEW_S543.md`, THE SPEC, 12 points). Round 1
(`docs/CORNERCMD1_RESULT.md`, read it whole first; the page `ops/research/DESIGN_CORNERCMD1.md`) measured 92,400 real
bouts. WHAT HOLDS: reading the moment beats the plan alone by +9.7 (3 rounds) and +18.2 (6 rounds) wins in 100 and the
best fixed pair by +10.3 / +13.3; a wrong command held loses 22-39; the bars are a real cost; the coach rule works
(bars 1, 2, 4, 7, 9 PASS). WHAT FAILED:
- Bar 8 (nothing runs away): Get out of there held adds up to +23.9, Reset held +14.6. Code read by the coordinator:
  `scripts/rules/Exchanges.gd:85` "calm" costs -3.0 (it GIVES wind every exchange), `:70` "long" -0.5, "tie" -2.0. A
  held Reset never tires (wind 67-81 at every bell): free recovery.
- Bar 6 (the ring slot is alive): held, Centre is the right stop in 9 of 10 cells; Cut the ring off in none, even in
  the diagnostic run with the ring at 1.0 of a call. (As a moment answer the reader does pick Cut 22% and Ropes 20%.)
- Bar 5 (the boxer matters): the out-boxer and the slugger disagree on only 2 commands of the 4 needed.
- Bar 3 at 3 rounds: Hands up is never the reader's pick (Be first ties it at "loading up" and both boxers do it better).

## The four changes (the ONLY changes to round 1's page; each a flagged local rule in the probe, nothing under scripts/)
1. HONEST WIND. No command gives wind back outside the moment it answers.
   - Reset (the built "calm" and "tie"): the refill (-3.0 / -2.0) applies only while OUR boxer is tired or hurt (the
     MODES "your boxer tired" / "your boxer hurt"). In any other moment it costs 0 and still gives up offence, as now.
   - Get out of there ("long"): cost 0, not -0.5.
   - The new commands' wind on the built calls' scale: Change levels 0.5, Sit down on your shots 0.5, Be first 1.0;
     the ring: Cut the ring off 0.5, Stay away from the ropes 0.
2. ROUND 1 HAS A CALL. Round 1's result found PLAN ONLY opens round 1 with no call (`scripts/state/BoutNight.gd` l.194:
   round 1 copies the plan onto the bout; the corner speaks only from round 2), so in a 3-rounder any held command got
   a free third of the bout. A real corner sends the boxer out with one instruction. In EVERY arm, round 1 opens on the
   plan's opening call (the one `BoutRules.auto_corner` would give from the boxer's stats and the opponent's file).
   Print how much of bar 8's +13.6 this alone removes (one run with change 2 only, the four step-0 cells).
3. THE RING ANSWERS WHO RUNS AND WHO PINS. A ring stop held must be RIGHT against the opponent it is for and wrong
   against the others: Cut the ring off against the mover and the counter-puncher who gives ground (it takes his room:
   fewer of his "boxing at range" exchanges, more "pressing" ones for us - move the opponent's moment mix, do not add a
   flat edge), and it costs wind and leaves our boxer open when the opponent is NOT moving away (a presser walks onto a
   boxer who is stepping across). Stay away from the ropes against the presser and the loader (fewer exchanges on the
   ropes, where `StepEffect` already prices the place), and it gives up ground against a mover. Read
   `scripts/rules/StepEffect.gd` TABLE and STEPPAY4's result for what a place is worth today and size from that; every
   number an ESTIMATE with its boxing reason. Real-world source for each claim (run `python ops/Tools/prior_research.py
   cut ring ropes footwork`): name the study or coaching source.
4. ONLY AS GOOD AS THE BOXER (spec 5: "an untrained one shows Poor and does little"). Read `Exchanges.grade` (l.227:
   GRADE Poor / OK / Good and its multipliers). Widen what a grade does to a COMMAND until a Poor command is not worth
   shouting (its edge at about a quarter and its full cost) and a Good one is clearly the boxer's own; say the
   multipliers before and after. Also break the tie at "loading up": Hands up is the answer there for a boxer whose
   guard and head movement grade above her hand speed and timing; Be first for the other kind. No new command.

## Bars (the SAME nine, never loosened; from `TASK_CORNERCMD1.md` section 3)
All nine at both lengths, same ten cells, same two boxers plus ONE more of ours with a different trained set (bar 5
then reads: at least 4 commands where at least two of the three boxers disagree), same paired dice. Add two prints:
the wind at every bell for Reset held and Get out held (STOP flag: never under 60 = still free recovery), and for each
cell which ring stop is right held and by how much.

## STOP RULE (the coordinator applies it; write the facts, not a round 3)
- Bar 8 fails again: name the command and the cells; no further tuning.
- Bar 6 fails again: the ring slot goes to the owner as "cut it as a held slider, keep the two ring calls as moment
  answers, or cut both" with these numbers - write that page section, not another rule.
- Bar 5 fails again: say whether the grades are too close in the population (print the three boxers' grades per
  command) or the engine ignores them (print the edge a Good and a Poor boxer get from the same command).
- Bars 1, 2, 4, 7, 9 must still pass: a fix that takes the reader's margin under 5 over PLAN ONLY is itself a FAIL.

## Do
1. Append "Round 2" to `ops/research/DESIGN_CORNERCMD1.md` (the four changes as table rows: before -> after, the reason,
   the source), the feedback loops below, the bars - BEFORE any run.
2. `tools/cornercmd2_probe.gd` / `tools/cornercmd2_rules.gd` / `tools/cornercmd2_sum.py`: copies of round 1's tools with
   the four changes as flags (each can be turned off: the control of each change is round 1's number, reproduced first
   with all four off - STOP if it does not reproduce round 1's reader and plan numbers within 2 SE).
3. `docs/CORNERCMD2_RESULT.md`: verdict first; the nine bars at both lengths beside round 1's; what each change moved
   (one line each, with its off-run); the per-cell table; honest limits. PASS -> write
   `ops/research/CRITIC_CORNERCMD_BRIEF.md` (opens with `ops/research/CRITIC_PACK.md` and `CRITIC_ACCESS.md`; the game,
   the spec's rules and the probe's numbers, never our opinion or an earlier score; DEPTH and PLAY out of 10, the bar is
   8 on both; missing and useless options; the list to reach 10; the critic's 10/10 as a 1920x1080 HTML page) and stop:
   the coordinator launches the code-checked critic first.

## Feedback loops
- Command -> edge -> a won exchange -> the opponent hurt or tired -> a better moment for the same command. Cap: bar 8.
- Reset when tired -> wind back -> not tired -> Reset stops refilling -> tired again: this loop is the design (rest
  when you need it). Cap: the refill only in the tired / hurt moment, and Reset gives up offence. Check: Reset held
  must end rounds BELOW the reader's wind + 15 and must not beat PLAN ONLY by more than 10 in any cell.
- Cut the ring off -> the mover has less room -> more exchanges up close -> our boxer spends more wind there -> tired ->
  cannot cut. Cap: its 0.5 wind and the round's length. Print our wind at each bell with Cut held against the mover.
- Stay away from the ropes -> fewer rope exchanges -> less damage -> more wind for offence: one way, no loop.
- Grades wider -> trained commands pay more -> the player trains what already pays. Outside this probe (training is
  not simulated here); say so in the limits.
- ONE-REP TRIAL FIRST: all four changes off reproduces round 1 (one cell, 140 bouts); then one bout per cell per arm
  with the changes on, one cell printed exchange by exchange, read by you for a command that changes nothing.

## Prior research
`docs/CORNERCMD1_RESULT.md`, `ops/research/DESIGN_CORNERCMD1.md`, `PUSH_KNOW_INTERVIEW_S543.md` (the spec),
`docs/PUSHPROBE2_RESULT.md` ("Push five, Save one": the free-recovery loop this round closes), the STEPPAY4 result and
`docs/TREEVALUE9_RESULT.md` (what a ring place is worth), `ops/research/topics/plans_corner.md`,
`docs/TELLPLAY1_RESULT.md` (the read is never the instrument: real bouts only).

## What would a human do?
A corner man says "breathe" when his boxer is blowing, not all night; he says "cut him off" to a boxer chasing a
runner and "get off the ropes" to one being walked down. Shouted at the wrong man, each of those gets his boxer hit.

## Prefab check
None (our own modules; round 1's probe is the base).

## Contract
OWNS: ops/research/DESIGN_CORNERCMD1.md, tools/cornercmd2_probe.gd, tools/cornercmd2_rules.gd, tools/cornercmd2_sum.py, docs/CORNERCMD2_RESULT.md, ops/research/CRITIC_CORNERCMD_BRIEF.md
RED_TEST: tools/cornercmd2_probe.gd
REGRESSION: none
VISUAL: none

Do not ask questions: decide, and write what you decided in the result.
