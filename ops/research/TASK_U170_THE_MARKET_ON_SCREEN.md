# TASK_U170 - THE MARKET ON SCREEN: slice two's reads in the gym/office GUI, and the weigh-in red (Cursor)

Model: Composer, medium, `-p --force --trust`. Owner: cursor. Assigned S71, 2026-09-25.

## Why
S71 (commit `996e3c11`) made four things move the member count that the player cannot yet SEE or CHOOSE:
- `get_floor()["team_slot"]` - "evening" (the team trains in the member slot, members crowd it) or "day" (apart); unset means
  a one-coach gym shares the slot (`GameState.team_shares_member_slot()`).
- kit TYPES on the floor (`get_membership_market().kit_types`, e.g. `["ring", "strength"]`), a draw smaller than a coach.
- the title spike (`get_membership_market().title_spike`, a multiplier > 0 for 4 weeks after a home title win).
- rival refits (already pushed to news as "<gym> installs a ring" / "<gym> refits its floor").

## Build
1. **The team-slot choice, on the gym/floor screen** (find where station capacity / crowding is shown:
   `grep -rn "crowd_ratio\|crowd_yield" Godot/scripts/*Panel*.gd Godot/scripts/*Screen*.gd`). Two buttons, EVENING WITH MEMBERS /
   DAYTIME APART, writing `get_floor()["team_slot"]` through a small `GameState.set_team_slot(slot: String) -> Dictionary`
   ({ok, reason}; refuse anything but "evening"/"day"). Beside it the read: crowd ratio, the training yield it gives the team,
   and - when unset - the one line why ("one coach: the team trains with the members; a second coach runs it apart").
2. **The market read names the new terms** where the membership target / share is shown (office ledger:
   `Godot/scripts/GymLedgerRead.gd`, the `membership_dues` line's `why`): the kit types present, and while `title_spike` > 0 a
   line "TITLE WEEK: +N% pull, fading" (N = round(title_spike x 100)). Every figure keeps its INVENTED label.
3. **Also yours: `Godot/tests/weight_cut_test.gd` has 2 reds on master since before S69** (U169's digest noted them): "a 13%
   cut stops at 11%, misses by a little" reads "Missed weight by 13.5 kg", and the 20%-over cancel finds no cancellation. That
   magnitude says the LIMIT or the FAMILY is wrong at the weigh-in, not the cut - find which (`_weigh_in_now`,
   `_class_limit_for`, `_weight_family_for` vs the offer's ruleset). Fix the mechanism; if the TEST's fixture is the defect,
   show why with numbers and fix the fixture. Never loosen the assertion.

## Owned files
`Godot/scripts/GameState.gd` (ONLY `set_team_slot` new, and the weigh-in fix - ~15,200 lines, NEVER open it whole; `grep -n`
then `sed -n 'A,Bp'` windows at `team_shares_member_slot`, `_weigh_in_now`, `_class_limit_for`), the gym/floor panel you find
in step 1 and `Godot/scripts/GymLedgerRead.gd` (read whole if under 400 lines), `Godot/tests/weight_cut_test.gd` (fixture only),
a NEW `Godot/tests/market_on_screen_test.gd`, `research/U170_DIGEST.md`.

## Gate (tier: scripts edited)
`python Godot/tools/check_scripts.py <touched .gd>`, then `market_on_screen_test` alone, then
`python Godot/tools/run_tests.py --only gym_,membership,office,ledger,weight,weigh` (ONE run; read `total=`/`fails=`). Ceiling:
no new red vs master; `weight_cut_test` green or its remaining fail explained with numbers. A GUI change is walked: a
`<id>_walk.plan` like U168's, screenshots under `research/_captures/previews/u170_walk/`, and you OPEN them before saying
done. No full suite. Branch `cursor/u170-market-on-screen` off `origin/master`, commit explicit paths, push,
`python Tools/agent_comms.py send --from cursor --to claude --topic U170 --body "<what shipped, test totals, weight_cut root cause>"`.
Do NOT edit or read HANDOFF.md or CURRENT_STATUS.md.

## The one trap
`team_slot` unset is a real state (the default by coach count), not "evening". A toggle that writes "evening" on first paint
silently changes every one-coach gym that later hires a second coach. Only the player's press writes it.
