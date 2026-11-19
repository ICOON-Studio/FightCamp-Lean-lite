# TASK HOLD1 - the specialty: four ways to hold moves over two seasons, and the hold minutes that make it a choice (probe)

Status: OPEN (S528, Claude main). Discipline: boxing. Model: qwen3-coder (PC seat), after TREEVALUE5. PROGBUILD1's left item.

## Why
The progression plan (owner Q-211 "Yes, go ahead"; ops/research/PROGRESSION_CRITIC_S448B_BRIEF.md section M3, lines 583-596)
adds HOLDING: a Sharp move needs pad / bag / sparring minutes each week or it fades toward 50 (Signature toward 70); three
held moves of one style's set name the style and add a plan line. Its numbers are ESTIMATES that HOLD1 sets (table at line
703). John's critic (PROGRESSION_CRITIC_S448B_JOHN.md item 1) proposed Sharp 10 / Signature 20 minutes on 75-minute nights.
tools/prog_probe.gd + tools/prog_probe_rules.gd (PROGPROBE1R2) already model the hold rule in its ARM B - reuse them.

## What to build (probe-side only - do NOT edit scripts/)
New `tools/hold1_probe.gd` (under 400 lines) on prog_probe's population and ARM B rules (preload prog_probe_rules.gd; copy
what you need from prog_probe.gd rather than editing it). Two seasons (104 weeks), seeds 4481-4483, the 4 quick-start
fighters + the 60 walk-ins. Four hold POLICIES (the player's choice each week of which moves get the minutes):
- PLAN: hold only the moves in the fighter's fight plan (sparring credits them, PadWeek.spar_pool).
- WIDE: spread minutes over as many Sharp moves as possible.
- DEEP: put minutes on 2-3 moves first, push one to Signature.
- COACH: the coach's pick (the moves the next opponent's file says matter; else PLAN).
Arms: hold minutes Sharp/Signature in {10/20, 15/30, 20/40} (min a week on a 75-min night, pads = 240 units a night as in
PadWeek.PAD_NIGHT_MINUTES). Per (arm, policy): held Sharp count and Signature count at the end of each season (median,
spread), named styles (and that no style is named in more than 1 in 3 careers), weeks to take a new move to Usable while
holding, and how often two fighters with the same start end season 2 with DIFFERENT held sets.

## Pass line (print it)
An arm PASSES when: a careful policy (best of the four) holds 4-5 Sharp + 1 Signature by season 2; no policy is best in
more than 2 of the 3 seeds' line-ups; same-start fighters end with different held sets in 50%+ of pairs; a new move still
reaches Usable within 4 weeks while holding. Print `HOLD1 done pass=<arm or NONE>` with the closest arm when none passes.

## Deliverable
`tools/hold1_probe.gd`, `docs/HOLD1_RESULT.md` (tables + the RESULT line). Stay under 80 minutes run time on a GREEN PC
(pilot first; cut arms, never seeds).
RESULT: tools/hold1_probe.gd -> HOLD1 done pass=<arm>

## Contract
OWNS: tools/hold1_probe.gd, docs/HOLD1_RESULT.md
RED_TEST: tools/hold1_probe.gd prints HOLD1 done pass=<arm>
REGRESSION: tools/prog_probe.gd (must still run unchanged)
VISUAL: no

## Prior research
PROGRESSION_CRITIC_S448B_BRIEF.md (M3, the probe table), PROGRESSION_CRITIC_S448B_JOHN.md, docs/READ1_RESULT.md,
tools/prog_probe.gd (PROGPROBE1R2).
## What would a human do?
A coach keeps a fighter's best shots sharp with a few rounds on the pads every week and lets the rarely-used ones go.
## Prefab check
None: our own probe.
