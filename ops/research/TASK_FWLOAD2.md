# FWLOAD2 - the fight week's load: two state-reading values, probed on the game's own tank and week (S543)

Kind: design + probe. Model: claude-opus-5-5 (Code Mode tab). Commit only your paths (`git commit -m "..." -- <files>`), do not
push. Godot only through `python ops/Tools/godot_slot.py run --who FWLOAD2 -- <cmd>` (headless, Dummy audio), ONE run at a
time, output to a file, wait on its done line (a killed waiter leaves Godot running: check by PID). Before each run:
`powershell -NoProfile -ExecutionPolicy Bypass -File ops\Tools\pc_watchdog.ps1 -Once`; RED = wait; the owner's game
(ArcheAge) in the top list with memory AMBER = wait. Two other workers share the Godot queue (COACHDEEP7, TURNPRO18).
Estimate: 2-3 hours. Size the full run to finish in under 40 minutes on one slot (time one cell first); run the FULL size
before any verdict.

## Why
The fight week's load (Rest up / Tick over / Train through, `scripts/rules/FightWeek.gd`) is a solved choice (DEPTH_AUDIT
row 21). A flat price was probed (DEPTHPRICE1A) and a code-checked critic scored it DEPTH 4, PLAY 5:
`ops/research/DESIGN_DEPTHPRICE1_CRITIC_OPUS.md` (read sections 1, 2 row 21, 3 and 4 first). Its findings: the probe used
the screen's tank, not the bout's; the tiredness carry was invented; the ten cells were two tiredness levels; and the
assistant (`scripts/rules/FightWeekPick.gd` best_stop) already plays the lookup. Fixed since (commit 6e60558e4): the
screen now shows the bout's tank (`FightWeekPlan.bout_tank` -> `BoutRules.tank_parts_for`), and the unwired "+6 after the
bell" line is gone. This task tests the critic's two changes; if they fail, the choice is cut (the assistant picks).

## The two changes to probe (as flagged local rules in the probe; nothing under scripts/ or tests/ changes)
1. TRAIN THROUGH'S BANK LANDS BEFORE THE BELL. The week's banked pad work (`FightWeek.BANK_SHARE`, `FightWeekPlan.lock`
   `f["fw_bank"]`, `DrillWeek.fw_bank`) is applied before the bout: a plan line that crosses `FireLevel.USABLE_AT` fires at
   its new level IN THIS BOUT (Train through the full bank, Tick over half, Rest up a fifth). The state the player sees:
   the line's mastery bar and its distance to Usable (`FightWeekPick` fact `near_usable`).
2. REST UP'S FLAT ROUND READS THE OPPONENT. The flat round costs its edge only against an opponent whose file says a fast
   start (`FightWeekPick` fact `opp_round1`, `OppFile`); nothing against a slow starter. Size: start at -3 against a fast
   starter (ESTIMATE; the probe may tune it, before -> after written down).
Train through's tank stays 12 and `REST_UP_EDGE` stays as built unless a number has to move; the probe may tune numbers,
it may not add a rule or an option.

## Do
1. `ops/research/DESIGN_FWLOAD2.md`: one page - the choice as built today (every code claim opened today, file and line),
   the two changes, the menu table (the load cards, ON FIGHT NIGHT, the assistant's line: what each shows and is wired
   to), feedback loops, the bars below (written BEFORE any run, never loosened), then the result.
2. Probe `tools/fwload2_probe.gd` (+ a report script if needed), each file under 500 lines. It must play the GAME's tank
   and week: do NOT pre-set `bout.stale` (let `BoutNight._peak` call `BoutRules.tank_parts_for`), run the week through the
   game's own day loop (`Sim.step_day`, `WeekPhase.LOAD_WEEKS`) so tiredness carries as the game carries it, lock the week
   with `FightWeekPlan.lock`, fight with the game's bout. Cells along THREE axes, named in the output: start tiredness
   (about 35 / 50 / 58 / 66), a plan line near Usable (yes / no), the opponent a fast or a slow starter = 16 cells; add
   "a bout six days before" as a seventeenth and eighteenth. Fighters differ (stats under the key `stats`, techniques,
   frame, plan); women against women, same weight class. Arms: always Rest up, always Tick over, always Train through,
   "Use the pick" (`FightWeekPick.best_stop` as built), and a READER that follows a rule a player could say in one
   sentence from what the screen shows. Run today's rules as the control arm beside the two changes.
3. Bars: (1) no load is best in more than half of the 18 cells; (2) each of the three loads is best in at least 3 cells;
   (3) the reader beats "always Tick over" by 3 wins in 100 or more, cross-checked on split halves; (4) the reader beats
   "Use the pick" as built by 2 wins in 100 or more in at least 4 cells, or the pick already plays the changed rules
   right (say which: if the assistant plays it perfectly, the choice is one button); (5) nothing runs away (the tank
   stays inside 0-100; tiredness never climbs week on week under any arm over 8 weekly bouts).
4. Result `docs/FWLOAD2_RESULT.md`: verdict first; the bars; each arm by cell; what was tuned; honest limits. PASS -> say
   exactly what to build (constants, functions, the screen lines). FAIL -> say plainly "cut the choice: the assistant
   picks the load" and what the screen keeps (the tank bar, the sparring nights). No second design round in this task.
   No critic brief in this task (the coordinator writes it from a PASS).

## Feedback loops
- Load -> tank -> the bout -> the bout's toll -> next week's tiredness -> the load. Cap: the game's own (tiredness capped,
  the taper's rest days). Print tiredness at each of 8 weekly bells per arm; STOP if it climbs every week.
- Bank before the bell -> a line reaches Usable -> wins -> ? Mastery does not feed the load choice back except through
  `near_usable` (once Usable the state is gone): a one-shot, say so and print how many weeks it stays "near".
- The opponent's start -> Rest up's cost: one way (the opponent's file is fixed for the bout).
- ONE-REP TRIAL FIRST: one career per cell per arm, printed in full. STOP and fix the page if every cell picks the same
  load, if the tank printed by the probe differs from `BoutRules.tank_parts_for` on the same bout, or if any arm never
  loses a bout.

## Prior research
`docs/DEPTHPRICE1A_RESULT.md` (row 21), `ops/research/DESIGN_DEPTHPRICE1.md` (with its S543 correction note),
`ops/research/DEPTH_AUDIT_S534.md`, `ops/research/DEPTH_SCOPE_S534.md`, `ops/research/FIGHTWEEK_SCREEN_V1_CRITIC_JOHN_JOHN.md`.
Real-world: the taper literature the module cites (WeekPhase; Chapman 2016 in BoutRules) - name what a real amateur coach
does in the week of a bout and why.

## What would a human do?
An amateur coach tapers a tired boxer and keeps a fresh one sharp; he drills one thing all week only when the boxer is a
session away from owning it, and he worries about a flat first round only against someone who starts fast.

## Prefab check
None (a rules probe on our own modules).

## Contract
OWNS: ops/research/DESIGN_FWLOAD2.md, tools/fwload2_probe.gd, tools/fwload2_report.gd, docs/FWLOAD2_RESULT.md
RED_TEST: tools/fwload2_probe.gd
REGRESSION: none
VISUAL: none

Do not ask questions: decide, and write what you decided in the result.
