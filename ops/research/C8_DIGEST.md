# C8 Digest — SCOUTING read API + shortlist

`GameState` now exposes one pure SCOUTING board read, candidate cards, and
offer projections for both `athlete` and `staff`. Rows carry quoted terms,
recurring-wage affordability, shortlist and negotiation state; cards compare
only the matching fighter sex/class/discipline or staff role already in gym.

`career["shortlist"]` is an ordered, save-backed twelve-entry store. Old saves
read empty, stale references remain visible with a reason, and successful
world signings remove their matching shortlist reference in the existing path.

`scouting_hub_api_test.gd` covers pure-read snapshots and equality, finance
reasons, candidate comparison, negotiation/refusal projection, shortlist
duplicates/cap/staleness/reload, and signing cleanup. Execution is pending the
documented Godot console executable, which is absent from this machine.
