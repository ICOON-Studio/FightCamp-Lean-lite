# TASK YARDSTICK1 (S223) - a pure realism yardstick: score a fight trace against real boxing numbers (John J67)

Model: Arena (agent mode). Own branch arena/<chat-id>-fightcamp + PR. Never master, never Arena's Merge button. Everything is public.
Why: the operator will watch a 3-minute fight video once the animation fixes land ("i want to see after codex is done"); we
must say, in numbers, how real it looks. John's memo `research/J67_VISUAL_REALISM_REPLY.md` (read it) gives the real-world
numbers with their population; this task turns them into ONE pure module + a blind test.

## Build
`Godot/scripts/rules/FightRealismYardstick.gd` - `extends RefCounted`, static functions only, ZERO preloads of game scripts.
Input: a trace = `{"fps": float, "ring_half_m": float, "frames": [ {"t": s, "a": side, "b": side, "clinch": bool, "referee_break": bool} ]}`
where side = `{"pos": [x, z] metres (ring centre = 0,0), "feet_moving": bool, "punching": bool, "punch_landed": bool,
"heel_up_rear": bool, "head_offset_m": float}`. Output: `score(trace) -> Dictionary` with one row per metric:
`{"id", "value", "unit", "band": [lo, hi], "source": "S#..." or "ESTIMATE", "population": "...", "in_band": bool}` plus
`"summary": {"in_band": n, "total": n}`. Metrics (all from J67, use ITS bands and wording):
1. mean distance between the two (1.23 +- 0.16 m, French elite) - band mean +- 2 SD;
2. share of time moving the feet per fighter (53-56%, London 2012) - band 40-70%;
3. distance travelled per 3-min round per fighter (155 +- 28 m) - scale to the trace length;
4. range shares long / mid / inside (J67 estimate bands; define long > 1.5 m, mid 0.9-1.5, inside < 0.9 m between pos);
5. exchanges: an exchange = a run of punching frames (either side) with gaps < 0.6 s; count per round, mean punches per
   exchange (2-5), exchange duration (1-3 s ESTIMATE), gap between exchanges (6-15 s ESTIMATE);
6. activity : rest ratio (elite 18:1 ... novice 6:1 - report the value, band 6-18);
7. clinches per round (2.5 +- 2.0 R1) and clinch seconds per clinch (~5-6 s);
8. ring position shares centre / ropes / corners (J67 ESTIMATE: centre 55-70, ropes 20-35, corners 5-15) using ring_half_m
   (ropes = within 0.6 m of an edge, corner = within 0.9 m of two edges);
9. rear heel up share (ESTIMATE 80-95%);
10. punches thrown per round (37.6/round pro heavyweights, band 25-70) and landed share (34.6%, band 20-50%).
Every band carries the population string from J67. A metric whose input is missing reports "value": null, "in_band": false
and says why - never a made-up value.

## Test (blind, from this contract, not from your code)
`Godot/tests/fight_realism_yardstick_test.gd` (`extends SceneTree`, prints `FIGHT_REALISM_YARDSTICK PASS checks=N` or FAIL,
quits non-zero on any failure): (a) a synthetic "real-looking" 180 s trace you build in the test from the J67 numbers reads
in band on >= 8 of 10; (b) a "robot" trace (both stand still 1.0 m apart, punch every 1.1 s non-stop, no clinch) reads OUT of
band on distance-travelled, feet-moving, gap-between-exchanges and activity ratio; (c) an empty frames list returns nulls, no
crash; (d) mutants: break the exchange gap rule (gap < 6.0 s instead of 0.6) and show (b) stops failing - put the mutant check
in the test as a second scorer call with a parameter, not by editing the module.
Command: `godot --headless --path Godot --script tests/fight_realism_yardstick_test.gd`. Parse gate:
`python Godot/tools/check_scripts.py Godot/scripts/rules/FightRealismYardstick.gd Godot/tests/fight_realism_yardstick_test.gd`.
No LFS assets, no scene, no autoload: CI has no LFS.

## Do not
Delete or weaken any test; touch any other file; add a switch (a pure module ships nothing until a tool calls it).

## Prior research
J67_VISUAL_REALISM_REPLY.md (John, S222); tests/fight_stage_realism_test.gd (the S4a frame-by-frame rhythm check - read its
header for how the room is measured; this module is the shared scorer, it does not replace that test).

## What would a human do?
A sports scientist codes the video with a time-motion sheet and compares each number to the published band, saying which bands
are sourced and which are estimates. This module is that sheet.

## Prefab check
None needed - a small pure scorer.

## The one trap
The bands are J67's - do not invent tighter ones, and keep "ESTIMATE" visible on every estimated band so a green row never
reads as more certain than the source.

## VISUAL GATE (.claude/skills/visual-gate/SKILL.md)
1. First run the gate on master's shipped clip: it must read RED on <the defect>; paste that number in your report.
2. Stills only via record_room.gd -- as_game + still_framing.gd save_if_framed: guard, contact frame, one between.
3. For every still report: gap between bodies / where each nose points / wrists in line / feet / the defect / which bodies.
4. Do not call it accepted or fixed. Claude opens every still; the operator closes it.
```

(S224 note: YARDSTICK1 itself is a pure scorer with no picture; the gate applies when its score is used to close a fight-look task - the clip/stills it scores go through this gate.)
