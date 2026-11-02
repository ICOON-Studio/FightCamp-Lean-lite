# TASK_Q131 - QWEN - IS THE LIVE OVERLAP THE SAME CAPSULE DEFECT?

**Owner:** qwen
**Model:** `qwen3-coder`, MEDIUM. `--yolo` (NEVER `auto`), stdin, from your own
worktree.
**Test tier:** parse gate, then `python Godot/tools/run_tests.py --only overlap`
and SEPARATELY `--only body`. `--only` DOES NOT STACK - one substring per
invocation, read `total=` to confirm how many ran. Do NOT run the full suite.

## This is your own Q130 finding meeting S47's

**Your Q130** censused seed 810039 and found 51 frames (5.7%) of penetration the
gate did not refuse, worst `torso>leg` at **0.197 m**. You expanded
`REFUSED_PAIRS` 3 -> 12 and the test is now RED on purpose.

**S47**, separately and on a different instrument, found that the `thorax`
capsule on both fighter rigs has radius **0.1909 m on a 0.3054 m segment** -
wider than half its own length, so it is effectively a ball. Its cause is that
`FighterCapsules` takes the thorax radius as the p80 of the Chest bone's skin,
and the Chest bone owns the deltoids. On the pose corpus that fat torso makes the
`neck` **0.0% reachable**.

**THE QUESTION, and it is a question before it is a fix: is your 0.197 m
`torso>leg` the SAME defect?** If the live-fight overlap is dominated by pairs
that involve `torso`, and if shrinking the thorax radius to a chest-DEPTH value
removes most of it, then S47 and Q130 are one bug and the next stage fixes both.
If the overlap is spread evenly across pairs that have nothing to do with the
torso, they are two bugs and must be scheduled separately.

## What to build

Extend `Godot/tools/probe_overlap_census.gd` (yours from Q130) with a **second
pass that is a CONTROL ARM, not a second opinion**:

1. Re-run the census on seed 810039 unchanged. That is the control.
2. Re-run it a second time with the `thorax` capsule's radius **overridden** to a
   chest-DEPTH estimate rather than the p80 - use `0.55 * ` the p80 as the probe
   value and SAY IN THE OUTPUT that the number is a probe, not a derivation. You
   are testing sensitivity, not shipping a radius.
3. Report both censuses side by side: per class pair, count of frames over the
   0.05 m threshold, and **p50 / p90 / max depth**. Never gate on the max alone -
   bounding an extremum invites passing it by discarding samples.
4. State the verdict in one line of the tool's own output: what share of the
   refused frames involve `torso`, and what share of THAT share survives the
   narrower thorax.

**NAME THE POPULATION IN THE OUTPUT** - seed, ruleset, both fighters and the
catalogue. A census that does not say whose fight it measured is a fixture
reading, not a finding.

## Owned files

- `Godot/tools/probe_overlap_census.gd` - yours from Q130.
- `research/Q131_DIGEST.md` - NEW, yours.
- Do NOT edit `Godot/scripts/FighterCapsules.gd`. The radius override is a probe
  applied to the built capsule array inside your tool, not a change to the
  derivation - Claude owns that under S48 and you would collide.
- Do NOT change `REFUSED_PAIRS` again. Q130 set it; this task measures, it does
  not re-tune.

## Gate

Parse gate on every touched `.gd`. Then `--only overlap`, then separately
`--only body`. **`fight_body_overlap_test` is RED ON PURPOSE from your own Q130 -
that is the expected state, not a regression.** Report its number; do not fix it.

## Deliver

Fresh branch off `origin/master` in your worktree. Commit with explicit paths,
message ending `Co-Authored-By: Claude Opus 5 <noreply@anthropic.com>`, push,
write the digest, then
`python Tools/agent_comms.py send --from qwen --to claude --subject q131-ready --body "<one line>"`.
Do NOT edit `HANDOFF.md`.

## THE TRAP

**A control arm that shares the bug proves nothing.** Both your passes run the
same fight through the same engine; the only difference must be the thorax
radius. If you find yourself changing the seed, the fighters or the catalogue
between passes, stop - you have built two measurements instead of one
comparison. And if the narrower thorax changes NOTHING, that is a real answer
and you report it as one.
