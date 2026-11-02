# TASK C216 - CURSOR (reassigned from Codex, S101: Codex is animation-only) - THE COACH'S IDEAL PLAN MUST AGREE WITH WHAT THE ENGINE REWARDS (S101)
Owner: cursor. Assigned 2026-09-27 (S101). Model: Cursor default (Auto). Engine measurement + a pure-module fit.
Branch `cursor/c216-coach-reads-what-works` from `origin/master`, own worktree. Claude merges. Launch when a shell slot
frees (max two shell agents).

## Why
S99 built a Motorsport Manager style fight-plan setup (`Godot/scripts/FightPlanSetup.gd`, pure, 230 lines - read it
whole): five sliders (range, pace, target, grappling, risk), a corner's `ideal_sliders(ours, theirs, ruleset)` rule,
and an `overall` fit score. S100/S101 wired it into the engine (`FightRealtime._apply_plan_setup`, grep it; constants
`PLAN_SETUP_*` and `PLAN_FIT_*` just above `## S28 - THE STANDING TKO`). Each slider is a small lever; the fit is a
+-0.05 edge.

Measured (`Godot/tests/fight_plan_setup_engine_test.gd`, read it whole): for a GRAPPLER the coach's ideal plan wins
clearly. For a STRIKER against that grappler the gain is inside the noise (+0.16 [-0.09, 0.41] landed diff/min, great
coach vs poor coach). S100's first cut showed why: the engine rewards PRESSURE for that striker, while `ideal_sliders`
tells him to be PATIENT because the grappler has the better gas tank. So the coach's model and the engine disagree, and
a player who trusts his coach is punished.

## What would a human do?
A real head coach does not derive the plan from the tale of the tape alone - he watches what WORKS in sparring and on
film and adjusts. A game studio does the same with telemetry: measure each lever's marginal effect per matchup type
and make the advisor's rule follow the measurement. Do exactly that.

## Prefab check
None applies: this tunes our own advisor rule against our own engine. Motorsport Manager's setup logic (already read,
`S96_MOTORSPORT_MANAGER_SETUP_TO_THE_CORNER.md`) is the reference design; no library measures a custom fight engine.

## Do
1. Measure each slider's MARGINAL effect: for each of the five sliders at -1 / 0 / +1 (others 0, overall fixed at 85
   so the fit edge is neutral), the landed differential per minute and win share, 40 seeds, CI printed. Matchups,
   never identical fighters, both able to do everything their ruleset allows:
   MMA striker vs grappler (the test's two), MMA grappler vs striker (swap sides), boxing out-boxer (reach +10,
   speed +10) vs pressure puncher (power +12, chin +8), kickboxing kicker vs boxer-style (both with the whole KB
   palette, differing by stats). Name the population in the output.
2. Compare with what `ideal_sliders` says for each matchup. List every disagreement.
3. Fix `ideal_sliders` (pure, in `FightPlanSetup.gd`) so its signs agree with the measurement - keep it a readable
   corner's rule on the tale of the tape (reach, power, chin, conditioning, grapple, speed), never a lookup table of
   the measured numbers. If a lever's measured effect is the engine being unreal (e.g. pace buys volume with no gas
   cost), say so in the digest instead of teaching the coach the bug.
4. Re-run `fight_plan_setup_engine_test.gd`: TEST 5's striker row must move (report before/after); every check green.

## Gate (a ceiling)
Parse gate on touched files; `fight_plan_setup_engine_test.gd` and `fight_plan_setup_test.gd` green; tools under
`Godot/tools/c216_*.gd`. Never the full suite. `FightRealtime.gd` is ~6,500 lines - never open it whole.

## Owned files
`Godot/scripts/FightPlanSetup.gd`, `Godot/tools/c216_*.gd`, `research/C216_DIGEST.md`. You may NOT change the
engine's `PLAN_SETUP_*` lever sizes - if they are wrong, the digest says so and Claude decides.

## Deliver
Commit and push as you go; digest; `python Tools/agent_comms.py send --from cursor --to claude --topic C216 --body "..."`.
Do NOT edit HANDOFF.md. **Trap:** a coach rule fitted to 40 seeds of two fixtures is overfitting - the rule must read
the tape, and hold on the matchup you did not tune on (report one held-out matchup).
