# CORNERCMD1 - the corner commands: the owner's design, one clean map and a probe on the real bout (S543)

Kind: design + probe. Model: claude-opus-5-5 (Code Mode tab). Commit only your paths (`git commit -m "..." -- <files>`), do not
push. Godot only through `python ops/Tools/godot_slot.py run --who CORNERCMD1 -- <cmd>` (headless, Dummy audio), ONE run at a
time, output to a file, wait on its done line (a killed waiter leaves Godot running: check by PID). Before each run:
`powershell -NoProfile -ExecutionPolicy Bypass -File ops\Tools\pc_watchdog.ps1 -Once`; RED = wait; the owner's game
(ArcheAge) in the top list with memory AMBER = wait. Other workers share the Godot queue.
Estimate: 3-4 hours. Size each full run to finish in under 45 minutes on one slot (time one cell first); run the FULL size
before any verdict (S542: a small check read a full-size pass as a fail).

## Why
The push switch failed two probes (`docs/PUSHPROBE2_RESULT.md`: "Push while wind is above 45" is as good as a coach who
reads everything; `docs/DEPTHPRICE1A_RESULT.md` row 27: a dearer push is only a dial). The owner was interviewed (S543,
three rounds): `ops/research/PUSH_KNOW_INTERVIEW_S543.md`, section THE SPEC (12 points) is the spec. It is HIS design: not
one switch but corner COMMANDS the player selects live, in two slots, "the engine should understand and respond and
display these decisions on the fight". This is not a patch of the push-tank maps (`PUSHTANK_MAP_V2_S442.md`): start from
the spec and from what the fight already has.

## What the fight already has (open each today; file and line in the map)
- `scripts/rules/Exchanges.gd`: CALLS - eight corner calls (long, body, lead, hands, let_go, calm, tie, finish), each with
  the attributes it needs, a wind cost, and MODES - best / ok / wrong against what the opponent is doing (press, range,
  counter, loadup, tiring, hurt, your boxer tired, your boxer hurt); `grade(call, vals)`; `uptake(coachability, shouts)`.
- `scripts/rules/PaceAim.gd`: Push / Steady / Save (edge, spend, output) and the aims (head, body, ribs) - the pace is what
  the commands REPLACE; say what happens to the aim.
- `scripts/rules/StepEffect.gd` TABLE and `scripts/state/StepWire.gd`: ten learned steps (cut_off, herd, pivot_out,
  roll_out, step_back, step_out, ...) and what a ring place does; read `docs/TREEVALUE9_RESULT.md` and the STEPPAY results
  first ("no place is an edge" was the finding before STEPPAY4) - the RING slot stands on this.
- `scripts/state/LiveRound.gd`, `Bouts.fight_step`: where a corner call enters an exchange today, and the corner's trust.
- The head and the wind: `FightMeters`, the tank, `LiverRibs`; the guard work in flight (`DESIGN_GUARDDMG1_V8/V9.md`).
- TELLS FIRST (`TELLPLAY_SCOPE_S543.md`): the opponent's game mix reads only the style today. Probe the commands on the
  MODES as built; the baits of spec point 9 are NOT in this task.

## What TELLPLAY1 found (S544, `docs/TELLPLAY1_RESULT.md`) - read it before the page; it changes step 0
- One plan line added to the coach's plan is worth 0.1-0.9 points in the ring (why is still being measured:
  `TASK_PLANWORTH1.md`). A command that tells the boxer to do what the plan already does is worth nothing. For each
  command the page must say what it gives that the plan in force does NOT have.
- The read (`BoutRead`) over-read one line 4 to 8 times against the real bout. Every verdict here comes from real bouts
  (paired dice, 2 SE printed beside each difference); the read is never the instrument.
- STEP 0, BEFORE THE PAGE (about 20 minutes): on the real bout, with TODAY'S eight calls and nothing new, play PLAN ONLY
  against a reader who shouts the call `Exchanges.grade` marks best for the opponent's moment, in four cells. Print the
  wins in 100 and 2 SE. If the reader is under 2 wins in 100 over PLAN ONLY, find in the code where the edge is lost
  (the call's edge size, `uptake`, how many exchanges a call touches, the plan line it overrides) and write that at the
  top of the page: the new commands are sized from it, not from a guess. Bar 2 cannot pass on a lever worth 1 point.

## Do
1. `ops/research/DESIGN_CORNERCMD1.md`: one clean page.
   - The ten commands in the two slots, each in one table row: what the boxer does (plain boxing words), which existing
     call / step / aim it IS or is built from, what it needs trained (spec 5), what it burns on the two bars (spec 6:
     wind, head), and against which opponent moments it is best / ok / wrong (spec 4). The four NEW ones (Change levels,
     Be first, Sit down on your shots, Reset) get numbers as ESTIMATES with their real-world reason; "Reset" takes the
     old Tie up and "Breathe, pick your shots"; "Get out of there" takes Jab and move; "Go for the finish" is the moment
     button (hurt opponent only); "Draw the lead" stays a plan line.
   - Nothing selected = the pre-fight plan as built (spec 8): say exactly how a command overrides a plan line while on.
   - Changing a command (spec 7): takes effect from the next exchange; heard by `Exchanges.uptake` x trust. No shout limit.
   - The unwatched round (spec 10): the corner coach plays the commands by tactics rating - one rule, written down.
   - The menu table (owner S425): the two controls beside the fighter (a row of eight buttons, a three-stop slider), the
     two bars, the shout bubble, the round's line, the result page's count of right and wrong calls; what each is wired to.
     The 3D look of each command is listed as "3D phase", not designed here.
   - Feedback loops, then the bars below, written BEFORE any run.
2. Probe `tools/cornercmd1_probe.gd` (+ `tools/cornercmd1_rules.gd`, a summary script; each under 500 lines), a GREYBOX on
   the REAL bout: every punch, round and verdict is the game's (`Bouts.fight_step` + `LiveRound`, as `tools/pushprobe2.gd`
   plays it: copy from it, do not edit it); the new commands are flagged local rules in the probe; nothing under scripts/
   or tests/ changes. Paired dice. TEN CELLS that differ in what the opponent does (a presser, a mover at range, a
   counter-puncher, a loader, a fader, a slow starter, a body puncher, a switch-hitter, the favourite, the underdog) x
   two of our boxers who differ in what they have trained (the key is `stats`; different techniques, steps, frame, plan);
   women against women, same class; the population named in the output. Three and six rounds.
   Arms: PLAN ONLY (no command, the control); each of the ten commands held all bout; the best fixed PAIR (one fight, one
   ring); the old "Push while wind is above 45"; a READER who changes commands from what the corner can see (the
   opponent's moment, both bars, the score, the round) by a rule a player could say in two sentences; and the CORNER
   COACH rule of the unwatched round at tactics 40 / 58 / 75.
3. Bars (never loosened):
   - (1) No fixed command or fixed pair is the best arm in more than 6 of the 10 cells.
   - (2) THE READER PAYS: the reader beats the best fixed pair by 3 wins in 100 or more over all cells, and beats PLAN
     ONLY by 5 or more.
   - (3) EVERY COMMAND HAS ITS MOMENT: at least 8 of the 10 commands are the reader's pick in 5% or more of the exchanges
     where a command is on, and each of those 8 is the best command for at least one opponent moment.
   - (4) A WRONG CALL COSTS: the worst command held all bout loses 4 wins in 100 or more against PLAN ONLY in at least 6
     cells.
   - (5) THE BOXER MATTERS: for at least 4 commands the two boxers disagree on whether the command pays (trained v not).
   - (6) THE RING SLOT IS ALIVE: Cut the ring off and Stay away from the ropes are each the right ring call in at least
     2 cells; if neither moves a result, say so plainly (PUSHPROBE2 found the feet never paid).
   - (7) THE BARS ARE A REAL COST: always "Let your hands go" and always "Sit down on your shots" each end at least 3
     cells behind the reader because of wind or the head, not by chance (print the wind and the head at each bell).
   - (8) NOTHING RUNS AWAY: wind and head stay inside 0-100; no command adds more than 10 points of win chance by itself.
   - (9) THE COACH RULE: at tactics 75 the corner coach is within 3 wins in 100 of the reader; at 40 at least 3 behind.
4. Result `docs/CORNERCMD1_RESULT.md`: verdict first; the bars; the per-cell table; the tuned numbers (before -> after);
   honest limits. PASS -> write `ops/research/CRITIC_CORNERCMD1_BRIEF.md` (opens with `ops/research/CRITIC_PACK.md` and
   `ops/research/CRITIC_ACCESS.md`; the game, the spec's rules and the probe's numbers, never our opinion or an earlier
   score; DEPTH and PLAY out of 10, the bar is 8 on both; missing and useless options; the list to reach 10; the critic's
   10/10 as a 1920x1080 HTML page) and queue it for kalli and dola (`python ops/Tools/seat_queue.py add --seat <seat>
   --brief research/CRITIC_CORNERCMD1_BRIEF.md`); say a code-checked critic is owed. FAIL -> which bar, the one change
   that would fix it, stop. The probe may tune a number; it may not add a command, a slot or a rule the spec lacks.

## Feedback loops
- Command -> edge -> a won exchange -> the opponent hurt or tired -> a better moment for the same command. Cap: bar 8 (10
  points a command); "Go for the finish" exists only while the opponent is hurt.
- Let your hands go / Be first -> wind down -> your boxer tired -> the opponent's moment. The cost side: print wind at
  every bell; STOP if any arm ends a round under 0 or never drops under 60.
- Sit down on your shots -> head open -> hurt -> worse exchanges. Same: print the head.
- Hands up / Reset -> wind back -> ? They must give up offence (no free recovery: PUSHPROBE2's "Push five, Save one").
  Trial check: a boxer alternating Let your hands go and Reset must not beat the reader.
- The opponent does not read the player's commands in this task (the mirror is the pro corner, `ProRead`: unchanged).
- ONE-REP TRIAL FIRST: one bout per cell per arm, printed exchange by exchange for one cell. STOP and fix the page if
  every cell picks the same command, if a command changes nothing, or if the control arm does not reproduce PUSHPROBE2's
  "today" numbers for its two boxers.

## Prior research
`ops/research/PUSH_KNOW_INTERVIEW_S543.md` (the spec), `docs/PUSHPROBE2_RESULT.md`, `docs/DEPTHPRICE1A_RESULT.md` (rows 27,
30), `ops/research/PUSHTANK_MAP_V2_S442.md` and its critics (what failed), `ops/research/TELLPLAY_SCOPE_S543.md`,
`docs/TREEVALUE9_RESULT.md`, `ops/research/topics/plans_corner.md`. Run `python ops/Tools/prior_research.py corner call
shout command pace` and name the real-world source for each new command's numbers (what each instruction does in a real
corner, and when a trainer gives it).

## What would a human do?
A corner man watches what the other fighter is doing THIS minute and shouts the one thing that answers it: "downstairs"
when the hands are high, "hands up" when the right hand is coming, "get out of there" when the boxer is admiring the
work, "cut him off" when he is being run from. The same shout at the wrong minute gets the boxer hit.

## Prefab check
None (our own modules).

## Contract
OWNS: ops/research/DESIGN_CORNERCMD1.md, tools/cornercmd1_probe.gd, tools/cornercmd1_rules.gd, tools/cornercmd1_sum.py, docs/CORNERCMD1_RESULT.md, ops/research/CRITIC_CORNERCMD1_BRIEF.md
RED_TEST: tools/cornercmd1_probe.gd
REGRESSION: none
VISUAL: none

Do not ask questions: decide, and write what you decided in the result.
