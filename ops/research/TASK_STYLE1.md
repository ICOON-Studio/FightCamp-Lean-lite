# TASK STYLE1 - does any named style dominate, and is each one worth having? (a probe; headless, no fix)

Status: OPEN (S477, Claude main). Discipline: boxing. Model: Arena (cloud, lite mirror).

## Why now
The owner approved the progression plan (Q-211 "Yes, go ahead"); its build order item 12 asks for the probes, in the order
FIRELEVEL3, HOLD1, STYLE1, READ1, PICKSPREAD1, TREEVALUE1, COACHMARKET1. PICKSPREAD1 and TREEVALUE1 are done; STYLE1 never
ran. The six named styles are BUILT AND WIRED into the fight (scripts/rules/StyleName.gd EFFECTS, 116 lines; read by
LiveRound.gd 286/289 plan_mult + pressure, RingDuel.gd 95 range_open, BoutNight.gd 247/332 knock_power + combo_energy,
BoutRead.gd 195, GamePlan.gd 105 line limit). Nobody has measured what each is worth. The map's risk line: "Style effects
could dominate: STYLE1 bounds each at 1.5 to 4 in 100" (ops/research/PROGRESSION_MAP_S448.md section M4, line ~138-156,
and the probe table line ~279).

## What to do (measure only - change no game script)
Write tools/style1_probe.gd (extends SceneTree, headless, under 500 lines; a second file tools/style1_probe_rules.gd if you
need room, also under 500). Reuse by COPYING the few functions you need - do not edit these files:
- tools/treevalue_probe.gd (468 lines): its 60 generated fighters (AttrGen, fixed seeds), its four style opponents OPPS, its
  PLAN, its bout loop with FireLevel on.
- tools/prog_probe.gd (430 lines) + tools/prog_probe_rules.gd (197): the week loop (pad nights, LearnSlots picks, holds); line
  97 already records the first week a style is held (MoveTree.styles_held).

PART A - each style's worth in the played bout. For each of the 60 fighters and each of the six styles in StyleName.EFFECTS:
copy the fighter, set f["named_style"] = <style> AND raise that style's three set moves to 60 mastery (so StyleName.named()
returns it - read MoveTree.styles_held to see what "held" needs), then play N bouts against each of the four OPPS. The control
arm is the SAME copy with the same three moves at 60 but f["named_style"] = "" (so the only difference is the named effect,
not the moves). Print one line per style x opponent:
`STYLE style=<s> opp=<o> win_named=<x> win_control=<y> delta=<x-y in 100>`
PART B - the road to each style. Over the prog_probe week loop (arm B, the map's rules; seeds 4481-4483; the 4 quick-start
fighters + the 60 walk-ins; two seasons), record per career: the first week each style is held, the style named (DrillWeek's
Monday names one: StyleName.monday), and whether two sets are held at once (StyleName.two_held) at any Monday. Amateurs and
professionals apart if the loop reaches pro; else say so.
Summary lines:
`STYLE1 worth=<style:best_delta,...> best_vs_all=<style or none> named_share=<style:share,...> two_held=<share>
 weeks=<style:median,...> spread_weeks=<max-min median>`
`STYLE1 pass=<0|1> why=<which gates failed>`
Gates (from the map): each style's effect worth 1.5 to 4 wins in 100 against the opponent style it suits best (its best
delta); no style is the best style against all four opponents; no style named in more than 1 career in 3; two sets held at
once in under 1 career in 4; no style's median weeks more than 3 weeks from the others.
N: enough bouts that the dice on one delta is under 1 in 100 (say which N and why - a 1.5-in-100 effect needs tight dice);
keep the run under 30 minutes. If that N does not fit, run fewer fighters and say so.
Then docs/STYLE1_RESULT.md: the 6 x 4 delta table, the Part B table, which gates pass, and ONE paragraph in plain words: is a
named style worth having, does one dominate, and which number in StyleName.EFFECTS (or which set in MoveTree) the result says
to change and by how much (a recommendation only - change nothing).

## Pass lines
- `STYLE1 pass=` printed; 24 STYLE lines; the result doc.
- RESULT: tools/style1_probe.gd -> STYLE1 pass=

## Contract
OWNS: tools/style1_probe.gd, tools/style1_probe_rules.gd, docs/STYLE1_RESULT.md
RED_TEST: tools/style1_probe.gd -> STYLE1 pass= (a new probe; nothing is red on main - it has no file yet)
REGRESSION: tests/style_name_test.gd, tests/learn_slots_test.gd (no game script changes)
VISUAL: no
NOT YOURS: every script under scripts/, every test under tests/, tools/treevalue_probe.gd, tools/prog_probe.gd,
tools/prog_probe_rules.gd. No number changed anywhere.
Run: `godot --headless --audio-driver Dummy --path . --script res://tools/style1_probe.gd` (Godot 4.7.2). No .glb/.png/
audio is loaded by these rule modules, so the lite mirror runs it. Work on your own arena/ branch, open a PR, never merge.
Never delete or skip a test to go green.

## Prior research
ops/research/PROGRESSION_MAP_S448.md M4 + sections 9-10; docs/PICKSPREAD1_RESULT.md and docs/TREEVALUE1_RESULT.md (same
fighters and bouts; PICKSPREAD1 found punches beat steps and defences, so a style whose set is mostly steps may read weak for
that reason - say so if it does); docs/NODEREAD1_RESULT.md (which moves a bout reads at all).
## What would a human do?
Give the same boxer each style's name in turn, keep everything else the same, and box the same four opponents many times.
## Prefab check
None: our own rules.
