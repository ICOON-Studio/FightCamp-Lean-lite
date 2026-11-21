# TASK DEPTH35 - depth changes 3 and 5: maps from the code + a greybox probe each (S537)

Model: claude-fable-5-2 (Code Mode console in E:\FightCamp\Lean). Discipline: boxing (demo).
Bar (owner S534): a lever is PROBED before critics; 8+ DEPTH and 8+ PLAY from two fresh critics after the probe. FREE HAND.
This task writes maps and probes only: it changes no file under scripts/.

## Why (ops/research/DEPTH_AUDIT_S534.md part 4, DEPTH_SCOPE_S534.md rows 3 and 5; changes 1, 2, 4 are probed/built)
3. THE COACH'S HANDS AS THE CLUB'S CURRENCY: pad time is the one scarce thing that decides bouts. Sharing the pad nights
   between boxers in camp is agreed and not built (critic pack 4.2); every week then asks "whose fight matters more".
   LOYAL1 (docs/LOYAL1_RESULT.md): size the place count first - eight places could not serve four fighters.
5. ONE OPPONENT WHO REMEMBERS: the pro corner reads your boxer's last two fights and waits for the punch thrown most. Give
   that read to the named rival gym's corner in amateur rematches and on the ladder, and give the player a WORKING counter
   (READBACK1, docs/READBACK1_RESULT.md: dropping or swapping the line both fail today). A plan that won last month becomes a
   risk this month.

## Do (3 first, then 5; one probe at a time)
For each: (a) map `ops/research/DESIGN_PADHANDS1.md` / `ops/research/DESIGN_REMEMBER1.md` written FROM THE CODE (file:line for
every CODE claim), with the menu table (every screen it appears on, what each is wired to) and the 10/10 target;
(b) a greybox probe `tools/<padhands|remember>_probe.gd` - pass = it moves the result AND no pick is best in more than 6 of 10
cells AND best vs laziest worth 3+ wins in 100 (or real money); population named, fighters all differ, controls first;
(c) `docs/PADHANDS1_RESULT.md` / `docs/REMEMBER1_RESULT.md`. For 5, the probe must show a counter that wins back at least half
of what the read takes (READBACK1's arms are the baseline).
PASS -> chat critic `python ops/Tools/design_loop.py critic <NAME> research/DESIGN_<NAME>.md --seat kalli` + a code-checked
brief `ops/research/TASK_<NAME>CRIT.md` (form of TASK_TURNPRO13CRIT.md); do not run it. FAIL -> write which lever broke, stop.

## Prior research
DEPTH_AUDIT_S534.md, DEPTH_SCOPE_S534.md, docs/LOYAL1_RESULT.md, docs/READBACK1_RESULT.md, ops/research/CRITIC_PACK.md 4.2,
`python ops/Tools/prior_research.py pad nights coach time` and `... rival corner remembers read`.

## What would a human do?
A one-coach club owner splits the pads between the boxer fighting Saturday and the one fighting next month, and knows a rival
coach who saw your boxer win with the jab will have his man waiting for it in the rematch.

## Prefab check
None.

## Contract
OWNS: ops/research/DESIGN_PADHANDS1.md, ops/research/DESIGN_REMEMBER1.md, tools/padhands_probe.gd, tools/remember_probe.gd,
docs/PADHANDS1_RESULT.md, docs/REMEMBER1_RESULT.md, ops/research/TASK_PADHANDS1CRIT.md, ops/research/TASK_REMEMBER1CRIT.md
RED_TEST: the two probes (measurements)
REGRESSION: tests/golden_path_test.gd (unchanged: nothing under scripts/ is touched)
VISUAL: no

## Rules
Godot only through `python ops/Tools/godot_slot.py run --who depth35 -- <command>`; long probe output to a file, wait on its
done line. Never stage LineGrade.gd, LiveRound.gd, StepWire.gd, MHRig.gd, tools/export.sh. `git add -- <new>` then
`git commit -m ... -- <your paths>` with `Co-Authored-By: Claude Opus 5.5 <noreply@anthropic.com>`, push, report in two
lines, stop.
