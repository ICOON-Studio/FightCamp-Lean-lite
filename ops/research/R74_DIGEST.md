# R74 digest — The tournament that records everyone

- C52 build order step 2. A Grand Prix in an EVENT discipline now writes one
  `EventResult` per SEAT, not one line per champion. Lose the judo final and
  the game stored nothing at all; it now stores the silver, the contests and
  the wins. `EventResult.gd` (G23) had zero production callers and now has one.
- The record is written where the event is marked `completed`, not at the
  crowning. `_gp_complete_event()` is the single door: `_gp_champion_crowned`
  and `_resolve_grand_prix_rest`'s empty-champion break both go through it, so
  a bracket the player never seated records exactly what one they fought does.
  It is idempotent on `status == "completed"` — the pre-existing re-resolve of
  an exhausted bracket cannot write a second copy.
- Placings come off the bracket, by the ROUND'S OWN NAME: champion `gold`,
  beaten in the FINAL `silver`, SEMIFINAL `bronze`, QUARTERFINAL `fifth`. A
  four-man bracket's first round IS the semifinal, so it has no fifth to hand
  out and none is invented. Never fought → `participated`.
- Contests, wins and the beaten round are tallied off `event.results`, never
  off the bracket order: `_gp_replace_in_bracket` REWRITES the order when the
  doctor pulls someone, replacing their id even in the round they won, so the
  order would credit a reserve with another fighter's bout. A walkover appends
  no result row and is nobody's contest; a no-contest row carries no ids.
- UNKNOWN IS NOT ZERO, and these three are unsourced placeholders, not
  findings: `ranking_points` stays `0` and `selection_effect` stays `"none"`
  (no sourced rule sets either yet), and `age_division` / `grade_division` stay
  empty — C56's finding that they are not production-written still holds, and
  this task did not invent values for them. A fighter the doctor pulled after
  winning a round is `unknown` (rank 999), not a medal and not a zero.
- Stored as `event_results` on the athlete, roster and world alike, ordered by
  `EventResult.sort_results`. Read with `get_athlete_event_results(id)`, which
  sorts again and returns copies. `grand_prix_titles` is untouched: same array,
  same shape, same three `tournaments_test.gd` assertions, still written in
  every discipline including the belt ones. The new array sits beside it.
- NO BELT. The gate is `WorldPopulation.discipline_bears_belt()` (R70), so MMA,
  kickboxing, karate and muay thai record nothing here and keep their
  championship path exactly as it was. Nothing added returns a holder, a reign
  or a defence, and nothing in the read may be booked, defended or ranked.
- Owned files: `Godot/scripts/GameState.gd`, `Godot/tests/tournaments_test.gd`,
  this digest. `EventResult.gd`, `Tournaments.gd`, `ScheduleHubPanel.gd` and
  `ProfileRevampPanel.gd` untouched.
- Verify: `Godot_v4.7.2-stable_win64_console.exe --headless --path Godot
  --script tests/tournaments_test.gd` — the R74 block takes the deepest
  event-discipline class the world actually seeds (an eight-man wrestling
  bracket in this world) and asserts 1 gold / 1 silver / 2 bronze / 4 fifth
  across its eight seats, the runner-up's silver at 3 contests and 2 wins,
  an MMA Grand Prix recording no event result at all, and the whole placing ladder including
  `participated` and `unknown`.
