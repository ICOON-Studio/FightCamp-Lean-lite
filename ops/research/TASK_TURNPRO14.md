# TASK TURNPRO14 - turning pro v14: the player books the kind of each fight, house favour, pick the debut night (S537 FREE HAND)

Model: claude-fable-5-2 (Code Mode console in E:\FightCamp\Lean). Discipline: boxing (demo).
Bar (owner S534): 8+ DEPTH and 8+ PLAY from two fresh critics, after the probe. FREE HAND (owner S534): remove / add /
interconnect to reach 8, then report.

## Why (Claude, S537, reading both v13 critics)
v13 probe PASSED 14/15, but both critics score it 5/7/5: Arena code-checked
(ops/research/DESIGN_TURNPRO1_V13_CRITIC_ARENA.md, 75 of ~80 code claims true) and John
(ops/research/DESIGN_TURNPRO1_V13_CRITIC_JOHN_JOHN.md). Both put the same item first: the house decides the kind of every fight
after the debut, so the "road of six fights" plays itself and the mechanic is ONE decision. Decision (interconnect, not cut):
1. THE KIND IS THE PLAYER'S. Each of the first six pro sets offers a tune-up AND a step-up; the house sets aims, purse, lead,
   split - not the kind. `ProLadder.book` writes the kind into `f["bout"]`; `BoutFinish` :98 already pays +5 / +2 from it;
   `ProFights` :161-163 already draws the chip (Arena 7.1).
2. HOUSE FAVOUR 0-10 (John 2, interconnects 1 with the house fork): each house marks the kind it prefers; booking it +1 favour,
   refusing it -1. At 8: the ticket house opens an area title shot after 4 wins; the guarantee house +$300 a purse. Under 3:
   offers stand 4 days instead of 7. So the kind's value depends on the moment (house mood, the boxer's form).
3. PICK THE DEBUT NIGHT (Arena 7.2): two named debutants a house (one to build, one to test), both from DebutPick's own search,
   both shown with their card. Resolve Arena's FALSE claim (FighterProfile.gd :25 month_no_fight read nowhere) - wire it or drop
   it from the map. Resolve the DebutOpp per-house styles vs "the debutant it picks does not change" (Arena 2.4/3.4b): drop the
   styles.
Not in v14: John 3 (switch house after fight 3) - only if the probe says the fork still solves itself.

## Do
1. Map v14 `ops/research/DESIGN_TURNPRO1_V14.md` from v13 with the three changes; CODE file:line for every claim; menu table
   (offer letter, ProFights rows, the debut card) with what each is wired to.
2. Probe 14: copy tools/turnprobe13* to turnprobe14*; same population and pairing; add bot arms that read the +2/+5 line
   (name-chaser vs win-chaser vs favour-keeper). Bars = probe 13's, plus: inside one house two bots book different kinds; no
   arm best in more than 6 of 10 cells; favour moves the result. Fix Arena's note that bars 10 and 15 are one fact (merge them)
   and that bars 7/8/11 are vacuous with two options (rewrite for the new choice). `docs/TURNPROBE14_RESULT.md`.
3. PASS -> a chat critic `python ops/Tools/design_loop.py critic TURNPRO1_V14 research/DESIGN_TURNPRO1_V14.md --seat kalli` and a
   code-checked brief `ops/research/TASK_TURNPRO14CRIT.md` (form of TASK_TURNPRO13CRIT.md) - do not run it yourself.
   FAIL -> stop, write which lever broke (a fourth round under 8 = cut-or-keep to the owner).

## Prior research
docs/TURNPROBE13_RESULT.md, ops/research/DESIGN_TURNPRO1_V13.md and both critics above, DEPTH_AUDIT_S534.md, docs/DEBUTPICK1_RESULT.md.

## What would a human do?
A manager with a new pro picks each early opponent with the promoter - "keep him busy" vs "test him" - and keeps the promoter
sweet so the good dates keep coming.

## Prefab check
None.

## Contract
OWNS: ops/research/DESIGN_TURNPRO1_V14.md, tools/turnprobe14.gd, tools/turnprobe14_rules.gd, tools/turnprobe14_sum.py,
docs/TURNPROBE14_RESULT.md, ops/research/TASK_TURNPRO14CRIT.md
RED_TEST: tools/turnprobe14.gd (a measurement probe)
REGRESSION: tests/golden_path_test.gd (unchanged: nothing under scripts/ is touched)
VISUAL: no

## Rules
Godot only through `python ops/Tools/godot_slot.py run --who turnpro14 -- <command>`; long probe output to a file, wait on its
done line. Never stage LineGrade.gd, LiveRound.gd, StepWire.gd, MHRig.gd, tools/export.sh. `git add -- <new>` then
`git commit -m ... -- <your paths>` with the Co-Authored-By line, push, report in two lines, stop.
