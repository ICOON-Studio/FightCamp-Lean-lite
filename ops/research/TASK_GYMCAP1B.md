# TASK GYMCAP1B - make the capacity report believable (send-back of GYMCAP1, merged 1d857a8b)

Model: Codex luna (medium). Worktree E:/FightCamp/wt/GYMCAP1B, branch codex/gymcap1b. Never master, never HANDOFF.md, never AgentComms/.
Operator S196: "how many of each equipment can fit and how many customers maximum and fighters can be at the same time in the gym".
GYMCAP1 (module `scripts/club_capacity/ClubCapacity.gd`, rules `assets/data/club_capacity_rules.json`, test `tests/club_capacity_test.gd` 37/0,
report `research/GYMCAP1_REPORT.md`) answers it, but the numbers I read in the report are NOT believable. Fix these five, nothing else:

1. FIGHTERS flat 10 in every tier (T1..T4 all "10"): the coach cap is 1 coach x 10 athletes everywhere. Put `coaches` per tier in the rules json (T1 1, T2 2,
   T3 4, T4 8 - authored, flagged `"verified": false`, source string says so) and report THREE numbers: station slots (physical), supervised slots
   (coaches x athletes_per_coach), and fighters_max = min of the two. Keep members_max as is.
2. SUPPORT ITEMS COUNT AS ATHLETE SLOTS: `striking_safety_locker` x 74 (T3) and `first_aid` are cupboards, not stations. Add `"counts_as_station": false`
   for support items in the rules json (lockers, first_aid, focus_mitts_locker) and exclude them from athlete_slots AND from the filler mix (they stay
   as a one-off "support" line). Derived check: no item with counts_as_station=false contributes to athlete_slots.
3. THE MIX IS SILLY (T2: speed_bag x 7, striking_safety_locker x 12, heavy_bag only 2; area 47%): re-tune `mix_weights` so the filler follows a real gym
   (bags : speed bags about 3 : 1, mats and cardio balanced, never more than 2 of any recovery item below T3) and the used zone area lands 55-70% of
   the gross hall in T2/T3/T4. Weights are DATA in the rules json; the test asserts the 55-70% band from the module's own output.
4. T1 "unplaced required items" lists 14 of 20 items: a garage cannot hold one of everything, so "every store item at least once" is the wrong rule
   there. Rule: the REQUIRED set per tier = store-available items whose `min_tier` (catalogue key added by EQUIP2; absent today -> treat as T1) is <= the
   tier, AND whose `real_zone` area <= 15% of the hall; items skipped for size are listed under "too big for this tier" (not "unplaced required").
   Read `min_tier` defensively (EQUIP2 is landing in parallel; absent = old behaviour for those rows).
5. Re-run the report tool and commit the new .md + .csv. Also add to the report a table "stations per tier by category" (ring, bags, strength, cardio,
   mats, recovery) from the full mix, so the operator reads "T2 holds N bags, M cardio machines".

## Owned files
`Godot/scripts/club_capacity/ClubCapacity.gd`, `Godot/assets/data/club_capacity_rules.json`, `Godot/tests/club_capacity_test.gd`,
`Godot/tools/club_capacity_report.gd`, `research/GYMCAP1_REPORT.md|.csv`. Nothing else (not GymClub3D, not the catalogue).

## Done (tier: script edited - parse, focused test)
- `python Godot/tools/check_scripts.py <touched .gd>`. Extend `club_capacity_test.gd`: RED first on master for each of the five (paste the red
  count), then green: fighters differ by tier and = min(station, supervised); support items add 0 slots; T2/T3/T4 area band 55-70%; T1 has an empty
  "unplaced required" list and a non-empty "too big" list; the by-category table sums to the mix totals (derived).
- The test must pass in the MAIN checkout layout (imports present); the worktree may lack imported assets - if a Godot error about a missing
  .mp3/.import appears, run the test with the output filtered for `CLUB_CAPACITY checks=` and report that line.
Final message: red count, green line, the new fighters/members table for T1..T4.

## The one trap
Do not "fix" fighters by raising the coach constant until the number looks big: the assumption must be visible (3 numbers) and flagged unverified.
