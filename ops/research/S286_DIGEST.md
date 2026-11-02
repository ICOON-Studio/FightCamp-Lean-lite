# S286 digest (2026-10-22) - reception street door, AUTOFILL2 + BUILDFLOW1 collected, A/B noise traced upstream of the bout

## Shipped (master)
- a57513ef BUILDFLOW1 r3 (Cursor #335 34d8ba2e by diff): the room-draft status line no longer covers FINISH/CANCEL. Build-flow tests
  4/4 both arms. (r1 81ab1e5d, r2 aa32be99 were collected in S284.)
- e9a1bbe2 AUTOFILL2 (Cursor #336 b392e04b by diff): four Ludo gym layouts (Arena Heart, Perimeter Gauntlet, Two-Zone Pro Camp,
  Coaches Prow), chooser + top-down plan editor on the gym step, free apply at OPEN GYM. 9 tests plain 9/9; stills
  docs/previews/s286_autofill2 (on the review board). The single "FULL GYM" preset is replaced (brief TASK_AUTOFILL2).
- 648f3fe3 operator C135-C137 ("this should be the in/out point for npcs. can you make it so the reception makes a new door to the
  street"): a reception drawn on the street front cuts the building's street door in its own front wall (`GymClubLayout.
  reception_street_door`, middle of the edge, pushed along the wall when a placed item blocks the way in); the default gap closes,
  steps and sign follow, visitors enter at the desk and reach the floor through the reception's own door (never its wall); off the
  street the default door stays. New test reception_makes_street_door_test red on master (6 FAIL) -> 13/13; 11 reception/walk-in/
  room tests green both arms. Stills docs/previews/s286_street_door (4 yaws, review board + sent).
- ASGAMERED9 r1 (Cursor #342 9a52acec by diff): creation_root + gym_step_layout_s238 green as_game (quick 2-step creation, globe,
  empty shell - each port cites its switch, no check guarded away); GAME FIX: BACK from the gym under quick_creation returns to the
  country (was the hidden city step).
- Q-S277-8 answered "OK, keep it" - the MGT2 room look stays.

## Measured
- S285 master cloud runs (ab5f6216): q226_strands, camp_pays, mastery_select_wire RED on master (fight_identity run still going).
  Earlier Qwen run had q226 GREEN on master -> the tests flip between runs.
- Qwen BOUTREPEAT1 r1 (qwen/issue-341 fd2e55fb, not collected yet): the BOUT ENGINE is repeatable per seed (3/3, both arms; all RNG
  in seeded streams). So the noise is UPSTREAM - the career route (world gen, signed boxers, camp, rollover) that camppay_measure and
  the strand/mastery tests use. Round 2 sent (same issue).
- Loop probe (s276_loop_probe as_game, 150 s): clock never stops, 5 weeks pass, ~15 s/day at speed 1, tray icons queue
  (Plan/Today/Report/Week), no unopened overlay. Probe's own seeding of a booked bout fails ("REAL CAREER STARTS WITH 3 FIGHTERS") -
  probe limitation, the route itself plays.
- Pre-existing, noted: gym_preset_stills floor_view == floor_far (free camera maps both to the same distance at this hall size;
  second shot dropped); the stills tool's direct scene build shows a ghost of the old top bar (S284 stills too, not the game route).

## In flight (collect in S287)
- Qwen BOUTREPEAT1 r2 #341 - make the career route repeatable per seed (two-process hash), then run the 4 A/B tests twice.
- Cursor ASGAMERED9 r2 #342 - creation_api_test C14 as_game (red on master before r1 too).
- Arena WALKROUTE1 (chat 01a164f1, branch arena/70e521ea-fightcamp-lite) - pure WalkRouteRules + test; Claude wires it into
  `_shell_walk_in` after collect.
- Ziva editor started (wt/ZIVA has its own uncommitted edits - merge of master refused, left as is).

## Delegated this session
Qwen BOUTREPEAT1 (r1+r2), Cursor ASGAMERED9 (r1+r2), Arena WALKROUTE1.

Next session: collect the three runs; wire WalkRouteRules into the walk-in graph; if BOUTREPEAT1 r2 finds the career leak, re-read
the 4 A/B tests on runners twice; then the exe (`python Tools/build_playable.py`) for the operator.
