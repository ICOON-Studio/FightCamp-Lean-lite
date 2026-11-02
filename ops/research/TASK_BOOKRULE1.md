# TASK BOOKRULE1 (S222) - a BOXING gym starts with a wrestler (and an MMA fighter) on its roster, so it books wrestling bouts

Model: Arena (cloud, free). Repo ICOON-Studio/FightCamp, base master. Your own arena/ branch, open a PR, NEVER merge. No LFS-loading code
or tests. Do not delete or shorten any existing test. GameState.gd is 20,000+ lines: NEVER read it whole - grep and read +-40 lines.

## Evidence (the all-mechanics soak test, tests/all_mechanics_on_soak_test.gd, merged S222)
`begin_new_career(1)` + `generate_starter_boxing_floor("Allon1 Story Gym")` + `finalize_new_career("Cyprus","Nicosia",...)` gives the roster
Cole Baptiste (boxing), Deon Boone (WRESTLING); the week loop then books Deon into `amateur|amateur_open|cyprus|wrestling|...` bouts every
3-4 weeks. House rules: "A FIGHTER IS LEGAL FOR HIS RULESET" (the booking itself is legal for Deon) - the defect is the ROSTER: a gym created
as a boxing gym (generate_starter_boxing_floor, the boxing demo) must start with boxers only.

## Prior research
grep `roster_for_creation_start`, `finalize_new_career`, `generate_starter_boxing_floor`, `pending_creation_start_preset`, `story start`.
The story start (preset "house_that_holds") gives Mara Solano (boxer) - check whether only the no-preset path is wrong, or every start.

## What would a human do?
A boxing club owner starts with boxers; a wrestler walks in only if you recruit one.

## Do
1. Find every start path (story preset, guided sandbox, open sandbox, and the plain finalize with no preset) and which disciplines each
   roster can contain. 2. Fix the cause so a boxing start (the boxing floor / ruleset boxing) yields boxing fighters only; recruitment later
   is unchanged. 3. Do not change any existing test's expectations except where it asserted the wrong discipline (name it in the PR).

## Acceptance - NEW tests/boxing_start_roster_test.gd
For each start path x 3 cities (Nicosia, London, Tijuana): every starting roster fighter has discipline "boxing"; red on master first
(paste the red line in the PR). Then run tests/career_loop_walk_test.gd, tests/first_fight_for_every_fighter_test.gd,
tests/all_mechanics_on_soak_test.gd, tests/new_career_finished_test.gd. Parse gate python Godot/tools/check_scripts.py <touched .gd>.

## The one trap
The world population and other gyms keep their wrestlers and MMA fighters - only the PLAYER's boxing start changes.
