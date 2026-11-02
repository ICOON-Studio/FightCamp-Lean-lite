# ROUND 2 (S286, Claude) - read this first

Round 1 (qwen/issue-341 fd2e55fb) proved the BOUT ENGINE is repeatable: `FightRealtime.begin` + `advance_tick` with two fixed profiles
and the same seed gives the same log 3/3, plain and as_game. Good - keep that test. But it bypasses everything the flaky tests run:
`camp_pays_test` builds its men through `tools/camppay_measure.gd` (`Measure.measure(gs, SEEDS)`: GameState world, signed boxers,
`start_fight_camp`, weekly rollover, then the live engine with the game's switches); `q226_strands_test` and
`mastery_select_wire_test` read athlete data (training strands, `move_mastery`, attribute layer). NIGHTLY13B measured the UNCAMPED
control arm moving 31.2% <-> 33.5% jab landed and 1700 vs 1950 jab attempts between two runs of the SAME commit. So the leak is in
the career/world route that feeds the bout, not in the tick loop.

## Do (round 2)
1. Extend `Godot/tests/bout_repeat_test.gd` with a CAREER arm: in ONE process run `Measure.measure(gs, 1)` (the camp_pays route,
   one seed) twice from a fresh `begin_new_career` each time, and compare (a) every generated fighter's id/name/stats/attributes/
   move_mastery/strands that enters a bout, (b) every bout's log string. Then the same across TWO processes (run the test twice,
   each writes a hash line `BOUT_REPEAT career_hash=<sha256 of the dump>`; the PR body shows both hashes). Print the first field
   or log row that differs.
2. Find the source (likely: world generation or fighter ids from an unseeded RNG / `randomize()` / Time / `Dictionary` built from a
   `DirAccess` listing / `hash()` of a dict / an id counter that survives between careers in one process / a static cache).
   `grep -rn "randomize()\|randi()\|randf()\|Time.get_\|OS.get_ticks" Godot/scripts/GameState*.gd Godot/scripts/world* Godot/scripts/FightCamp.gd Godot/scripts/rules`.
3. Fix the GAME so the same career seed gives the same world and the same fighters (a real career can stay random by seeding from
   the clock ONCE at new-career, stored in the save). Never re-seed inside a test, never add seeds, never lower a floor.
4. Then run camp_pays_test, q226_strands_test, mastery_select_wire_test, fight_identity_test TWICE each (both arms) and report both
   results - they must give the same numbers twice. If one is still red but repeatable, report it; do not tune it.
OWNS for round 2 adds: Godot/scripts/GameState.gd (grep + sed windows only, ~huge), Godot/tools/camppay_measure.gd, any world/
fighter generator script the source is in (name it in the PR body).

---

# TASK BOUTREPEAT1 - the as_game bout must replay byte-identically per seed (S286, Claude)

Model: Qwen (cloud, label qwen). Discipline: BOXING (demo) - the boxing bout every A/B test plays.

## Why
Four 30-40-bout A/B tests flip red/green between runs on the SAME commit:
- master ab5f6216 cloud runs 39829679758 / 39829684480 / 39829689391 (2026-10-22): q226_strands_test, camp_pays_test,
  mastery_select_wire_test RED; Qwen's NIGHTLY13B run 39815898562 had q226_strands GREEN on master.
- NIGHTLY13B (#340) measured the uncamped control arm move 31.2% <-> 33.5% jab landed, and arm B jab attempts 1700 vs 1950,
  between two runs of the same commit and seeds.
- q226_strands_test line 76 proves the OFF arm replays byte-identically (`OFF control replays byte-identically`). So the
  non-repeatable stream is something the game switches turn ON (`as_game` / GameSwitches.GAME_ON) or something the 30-bout
  tests read that the OFF check does not (wall clock, unseeded global RNG, Dictionary/Array order from a file walk, a static
  cache that survives between bouts in one process, frame-delta instead of the fixed 20 Hz tick).

A statistical gate on a non-repeatable bout is noise. Fix the game's repeatability first; then the gates mean something.

## Do
1. Write `Godot/tests/bout_repeat_test.gd` (RED on master first): play the SAME boxing bout (two DIFFERENT fighters - different
   stats, techniques, plan; never identical fighters) twice in one process with the same seed and the game's switches ON
   (read `GameSwitches.on()` the way FightRealtime does; the test must pass `-- as_game` through like the other as_game tests),
   then once more in a fresh FightRealtime instance. Compare the full event log (`state["log"]`) string. Print
   `BOUT_REPEAT checks=<n> failures=<k>` and one `FAIL <what> first divergence at log row <i>: <row a> | <row b>` per mismatch.
   It must be RED on master (show the FAIL line in the PR body).
2. Find each source of divergence (print the first diverging row, then bisect the switches in GameSwitches.GAME_ON one by one -
   which switch turns the bout non-repeatable?). Candidates to check first: bare `randf()`/`randi()`/`randomize()` anywhere the
   bout calls (FightRealtime.gd, FightMoves.gd, scripts/rules/*.gd it preloads), `Time.get_ticks_*`, `OS.get_ticks_*`,
   static vars / class caches that keep state from the previous bout, iteration over `DirAccess` listings.
3. Fix the GAME with the smallest change: every random draw comes from the bout's own seeded RandomNumberGenerator; no state leaks
   from one bout into the next. A seeded bout with the switches OFF must play EXACTLY as before (q226 OFF check stays green, and
   the OFF-arm log of seed 1 is byte-identical before/after your change - say so in the PR body with the hash).
4. Run, both arms (`--jobs 1` is fine on the runner): bout_repeat_test, q226_strands_test, camp_pays_test,
   mastery_select_wire_test, fight_identity_test, attribute_wiring_e2e_test (`--timeout 1200`). Run the four A/B tests TWICE each
   on your final commit and report both results - they must now give the SAME numbers twice. If one is still red but repeatable,
   report its numbers; do NOT tune it (that is the next task, and a repeatable red is a real finding).

## Contract
OWNS: Godot/tests/bout_repeat_test.gd, Godot/scripts/GameState.gd, Godot/tools/camppay_measure.gd, Godot/scripts/FightRealtime.gd, Godot/scripts/FightMoves.gd, Godot/scripts/rules/FightLink.gd, Godot/scripts/rules/MoveMastery.gd
RED_TEST: Godot/tests/bout_repeat_test.gd -> BOUT_REPEAT checks=3 failures=0
REGRESSION: q226_strands_test, camp_pays_test, mastery_select_wire_test, fight_identity_test, attribute_wiring_e2e_test
VISUAL: no

`FightRealtime.gd` is ~10k lines: grep + `sed -n` windows only, never read whole. A fix in another scripts/rules/*.gd file the bout
preloads is allowed - name it in the PR body.

## Prior research
research/TASK_NIGHTLY13B.md (#340 spread numbers), research/S285_DIGEST.md (bout not repeatable), FightRealtime.gd
comments near lines 4709, 5751, 5788, 5957 (the `_rng_impact` stream rule: "never a new stream, never a bare randf()"),
research/GDSCRIPT_TRAPS.md.

## What would a human do?
Run the same seed twice, diff the two logs, look at the first row that differs, and follow that value back to the draw that
produced it. Then toggle the game switches one at a time to see which one owns the leak.

## Prefab check
None - project bout code.

## The one trap
Do not "fix" it by re-seeding inside the tests, adding more seeds, widening a CI, or lowering a floor. The game must be repeatable.
Plain `--script` tests are the OFF control arm; `-- as_game` turns the switches on - test both.

## Output
PR from qwen/issue-<n> (the workflow pushes; never merge). PR body: the RED line on master, each divergence source (file:line,
which switch), the change, the OFF-arm hash before/after, and these lines copied from your own run:
`RESULT: tests/bout_repeat_test.gd -> BOUT_REPEAT checks=3 failures=0`
plus each A/B test's pass/fail line from BOTH repeat runs. Zero SCRIPT ERROR lines.
