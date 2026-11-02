# TASK MOMENTS1W - the result screen's "THREE MOMENTS THAT DECIDED IT" says WHY, from the player's own corner calls

Model: Cursor (Godot gameplay/UI scripts). Worktree E:/FightCamp/wt/GYM4G (has the Godot import cache), branch cursor/moments1w from origin/master
(`git fetch origin && git checkout -B cursor/moments1w origin/master` - CORNER1 and CAMPVIS1 are merged there).
Tier: scripts edited + new test -> parse gate + the new test + `python Godot/tools/run_tests.py --only causation,fight_moments,corner,result --jobs 2`.

## Prior research
- `research/TASK_MOMENTS1_CAUSAL_MOMENTS.md` + `Godot/scripts/FightMoments.gd` (merged S182, Arena PR #65): the PURE module, header lines 1-35
  give the exact input shapes. `FightMoments.causal_moments(rounds, calls, scout, names)` -> up to 3 Strings "Round N - ...", <= 90 chars.
- DEMO_DESIGN_REVIEW_S172 finding 3: the result screen lists stats, never the cause the player made ("Round 4 - you called the body,
  his output fell 30%").
- Today the box is filled by `FightCausation.from_read` (Godot/scripts/FightCausation.gd, 352 lines, lines 46-82): stat candidates only.

## What would a human do?
A cornerman after the fight says "the body call in the 4th - that's where he slowed down". The game already knows every call the player
made and every punch per round; it just never joins them. Put the player's own cause FIRST, the stat lines after.

## Prefab check
None needed: the module exists (FightMoments), the per-round counts exist (FightBroadcast.round_stats), the call path exists.

## Owned files
1. `Godot/scripts/FightBeatAdapter.gd` (1,421 lines; `sed -n 560,620p`): in `apply_corner_instruction`, after a call is applied, append
   `{"round": <the round he goes OUT for>, "label", "emphasis", "pace"}` to `fight["corner_calls"][side]` (an Array per side; find the
   current round with the state's own clock helper - grep `round_number(` in FightRealtime.gd; during the rest after round N the call is
   for round N+1). Write the key ONLY when a call is made - a fight with no calls must stay byte-identical (S141 lesson).
2. `Godot/scripts/FightCausation.gd` (`from_read`, lines 46-82): before the stat candidates, build FightMoments' inputs from the
   finished fight_state and push its lines at a priority ABOVE every stat candidate:
   - rounds: for r in 1..rounds completed, `{"round": r, "a": round_stats(log, r, P), "b": round_stats(log, r, O)}` with
     `FightBroadcast.round_stats` (P = the player's side, O the other; P = first of `coached_sides` in the state/options if present,
     else "a"). round_stats already returns thrown/landed/jab_landed/power_landed/body_landed/knockdowns.
   - calls: `fight["corner_calls"][P]` (empty Array when absent).
   - scout: `{"read": <jab|power|body|"">, "label": <plan name>}` from the player's fighter `fight_plan` through `FightPlans.plan_by_id`
     (grep the plan data for a field that says what the plan leans on; map it to jab/power/body; "" when nothing maps - do not invent).
   - names: surnames, the same helper `_names_from_state` already uses, re-keyed so "a" = the player.
   Distinct lines only (the panel's `distinct_candidates` already de-dups). No moments -> the box is exactly today's.
3. NEW `Godot/tests/moments_wired_test.gd`.

## Acceptance (the one test)
`Godot_v4.7.2-stable_win64.exe --headless --path Godot --script tests/moments_wired_test.gd` -> `MOMENTS WIRED PASS`, rc 0:
- Two DIFFERENT boxers (stats, plan, reach). Run a realtime bout (FightRealtime.begin / run in steps like corner tests do -
  copy the pumping pattern of `tests/first_corner_test.gd` or `tests/corner_wired_test.gd`), apply a body call at the round-1 break
  and a head/pace call later through `FightBeatAdapter.apply_corner_instruction`.
- `fight["corner_calls"]["a"]` holds both calls with the right OUT rounds.
- With the calls, `FightCausation.build(state)` (or from_read) contains at least one line starting "Round " that names a call cause;
  with the SAME seed and NO calls, no "Round N - ..." call line appears and the output equals today's lines for that state.
- A fight with no calls: state hash with and without your change is identical (compare `var_to_bytes(state["log"])` of a no-call run
  against a run where you only checked `corner_calls` is absent).
- Player on side "b" (coached_sides ["b"]): the moments name the b fighter as "you"/his surname, not a.
- MUTANT: drop the append in apply_corner_instruction -> red. Say in the commit that you ran it.
Parse gate first: `python Godot/tools/check_scripts.py scripts/FightBeatAdapter.gd scripts/FightCausation.gd tests/moments_wired_test.gd`.

## The one trap
FightCausation lines are clipped by `UIKit._clip_measure_width` to the box - FightMoments lines are <= 90 chars and must fit; if a line
clips, shorten the source (names are capped at 12 in FightMoments), never widen the box. FightRealtime.gd and GameState.gd are never read
whole - windows and greps only. Headless Godot ONLY with `Godot_v4.7.2-stable_win64.exe --headless` (never `_console.exe`). Open no
windows, view no images. Commit with `git add -- <paths>` (never `git add -A`; the worktree has import-cache noise), push, stop.
