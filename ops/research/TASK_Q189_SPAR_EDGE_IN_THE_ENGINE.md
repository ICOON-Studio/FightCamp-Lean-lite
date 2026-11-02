# TASK Q189 - QWEN - THE SPAR EDGE IN THE FIGHT ENGINE, AND A REAL BYTE-IDENTITY PROOF (S86)
Owner: qwen. Assigned S86, 2026-09-26. Model: qwen3-coder, medium, `--yolo`. Branch `qwen/q189-spar-edge`.
Worktree: `C:/Users/user/AppData/Local/Temp/FightCamp-Q164` (`git fetch origin && git checkout -B qwen/q189-spar-edge
origin/master`).

## Why
S86 shipped gym sparring (your Q188 engine mode is merged, thank you). The man who had the better of a spar now carries
an EDGE for 3-7 days (G117 s7: "a small visible form/timing tick") - but today it only moves morale, so the fight engine
never feels it. Second: Q188's digest called its bout check "byte-identity" but it compared METHOD and WINNER only. That
is not byte-identity; a changed log with the same winner passes it.

## What would a human do?
A coach says a fighter who had a good week of sparring is "sharp" - his timing is there, he sees shots early, he stays
calm when touched (G117 s5: sparring builds timing, distance, reading, composure). It is a small, real difference a few
days old, not a power boost. A tester proving a refactor changed nothing hashes the whole output, not the headline.

## The contract (Claude's next stage will set this; build to it exactly)
`fighter["sharp_edge"]`: a float in [0.0, 0.05], absent = 0.0. When > 0 it adds, capped at 0.05, to the attacker's
TIMING in the contact roll (the `technique`-driven `clean_at` / `glance_at` terms in `_run_impact`, around
`FightRealtime.gd:3662`) AND, the same amount, to the defender's read of an incoming strike where the engine rolls it
(find the defender-side term; name it in the digest). Name the constant at the top of the file:
`SHARP_EDGE_MAX := 0.05`. Nothing else changes. A fighter with no key fights byte-identically to today.

## The work
1. Implement it in `Godot/scripts/FightRealtime.gd` (6,091 lines - NEVER open it whole; `rg -n "clean_at|glance_at|
   SPAR_POWER"` then `sed -n 'A,Bp'` windows at `:340` (constants), `:921` (`begin`), `:3448` (`_run_impact`)).
2. BYTE-IDENTITY, PROPERLY: a tool `Godot/tools/q189_byte_identity.gd` that runs 5 seeds x 3 rulesets (boxing,
   kickboxing, MMA) and prints a hash of `JSON.stringify(state["log"])` plus the scorecards for each - run it on
   `origin/master` BEFORE your change and after, and on a spar ("technical") too. Every bout hash must match; say so in
   the digest with both columns. (The same-seed rerun is the DETERMINISM tripwire - the one legitimate identical-seed
   use.)
3. Census `Godot/tools/q189_edge_census.gd`: for a LEGAL, DIFFERENT pair per ruleset (outside boxer vs pressure boxer;
   outside kicker vs pressure puncher, both able to kick; grappler vs striker - different stats, frames, plans; name
   the population in the output), 40 seeds each, bouts with `sharp_edge = 0.05` on side A vs none: landed-clean rate
   and win share for A. The edge must be SMALL: expect a few points of clean rate, never a flipped matchup. Print it.
4. Test `Godot/tests/fight_sharp_edge_test.gd`: absent key == byte-identical log (hash) on 5 seeds x 3 rulesets; an edge
   of 0.05 raises A's clean-landed share over 40 seeds; an edge of 0.5 is capped (same result as 0.05).

## Owned files
`Godot/scripts/FightRealtime.gd` (the edge only), `Godot/tools/q189_byte_identity.gd`, `Godot/tools/q189_edge_census.gd`,
`Godot/tests/fight_sharp_edge_test.gd`, `research/Q189_DIGEST.md`.

## Tier
A script edited. Parse gate (`python Godot/tools/check_scripts.py <files>`) on every touched file, the new test, then
`python Godot/tools/run_tests.py --only fight_realtime,fight_scoring,fight_kb,fight_footwork,fight_pace,fight_spar,fight_sharp --jobs 2`.
Ceiling: master fails `fight_scoring_test` and six rows inside `fight_realtime_test` (R91 subs + judo); fewer is better,
more is a regression. No full suite (it runs nightly).

## Research
All research is open: root `RESEARCH_INDEX.md` (G117 is the source; Q188_DIGEST your last change). Do NOT read
HANDOFF.md, CURRENT_STATUS.md or HANDOFF_ARCHIVE.md.

## Done
Commit (explicit paths), push the branch, write the digest (population, census table, both hash columns), then
`python Tools/agent_comms.py send --from qwen --to claude --topic Q189 --body "<hash match n/15, clean-rate delta per ruleset>"`.

## The trap
An edge that changes an RNG draw count changes every roll after it: if you add a `rng.randf()` for the edge, the whole
bout diverges even at edge 0 and the hash catches it. Apply the edge as ARITHMETIC on an existing threshold, never as a
new draw.
