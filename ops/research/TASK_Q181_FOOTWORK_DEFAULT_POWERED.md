# TASK Q181 - QWEN - THE FOOTWORK DEFAULT, WITH ENOUGH FIGHTS TO DECIDE
Owner: qwen. Assigned S81, 2026-09-26. Model: qwen3-coder, medium, `--yolo`. Branch: `qwen/q181-footwork-powered`.

## Why (Claude's review of your Q180, merged)
Q180 is honest and the tool is good, but its verdict (FLIP) is not decision-grade yet:
- **n = 20 per ruleset.** Finish rate +10 pp is +2 finishes in 20 bouts in each ruleset; the binomial noise at n=20 is
  about +/-11 pp. KB draws 1 -> 3 is the same kind of noise.
- **One matchup per ruleset** (the same two fighters 20 times). A default flip changes every fight in the game.
- **"No anchor broke" needs the anchors printed beside the numbers**: landed/min 8.7-10.6 and accuracy 52-55% are ABOVE
  J20's bands both OFF and ON. The census compares OFF with ON; say so, and add the anchor columns.
What Q180 DID show and stands: ON puts movement inside G100's bands (burst/hold, m/min) in all three rulesets.

## What would a human do?
A sim designer flipping a global default runs enough bouts that the change is bigger than the noise, over the spread of
matchups the game actually books, and reports each downstream number with its confidence interval next to its real anchor.

## The run (extend YOUR tool, `Godot/tools/q180_footwork_default_census.gd`, or copy it to q181_...; no shipped script edited)
- **100 seeds per matchup**, **3 matchups per ruleset** (keep yours and add two more, still legal and differentiated -
  e.g. boxing: counter-puncher vs pressure, volume boxer vs power puncher, tall outside boxer vs short swarmer; kickboxing
  and MMA likewise). 1,800 bouts OFF+ON.
- For every downstream row print OFF, ON, the difference and its **95% interval** (a proportion: Wilson or normal approx;
  a mean: +/- 1.96 x standard error over bouts), and the **real anchor band** beside it where one exists (J20 for pace and
  accuracy; the finish-rate anchor your repo tests already use - find it, do not invent it).
- Verdict rule: FLIP only if no downstream row moves AWAY from its anchor by more than its interval. Otherwise name the
  row that blocks the flip.

## Owned files
Your tool (extended or copied), `research/Q181_DIGEST.md`. Nothing in `Godot/scripts/` is edited.

## Tier and timing
Parse gate on the tool, then run it headless. No test suite. **Start no Godot process after 03:40 local time - the full
suite runs at 04:00.** If the run cannot finish by then, run fewer seeds, say how many, and report.

## Done
Commit on `qwen/q181-footwork-powered`, push, then
`python Tools/agent_comms.py send --from qwen --to claude --topic Q181 --body "<one line: verdict + the blocking or deciding row with its interval>"`.
Do not edit HANDOFF.md.
