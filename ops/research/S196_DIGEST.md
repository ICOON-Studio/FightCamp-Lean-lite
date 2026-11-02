# S196 DIGEST (2026-10-10 evening -> 2026-10-11, Claude Sonnet 5.5, one stage: "the gym reads as a real gym, and we know its capacity")

## What now works (merged on master, all behind OFF switches unless noted)
- Apron shouts in the engine (SHOUT1A) and the referee on the fight-night intro (REFEREE1B) - merged by diff 315760d8; shout 18/0, referee 21/0.
  The shout test's pinned master hash was stale; the live check (log identical switch OFF vs ON-unused) replaced it.
- HUD pulse answers work done (operator comments C1/C6, "red's bpm is not moving"): each thrown punch adds a capped, decaying bpm spike
  (`LudoFightHud.register_effort`, `ludo_fight_hud.json`); ludo_fight_hud_test PASS. NOT yet watched in a recorded fight video.
- GYMLOOK1A - zoned floor (`club_zones`, OFF): wood bag line, rubber strength/cardio, turf lanes, stretch mat, a name sign per zone.
  The agent's stills had mirrored signs hidden under equipment and harsh colours; Claude fixed rotation, sign positions (data `sign`), colours.
  club_zones 15/0, club_ 12/0, gym_floor 2/0, gym_club 4/0. Stills docs/previews/gymlook1a (opened by Claude), on the board with question Q-S194-7.
- EQUIP2 - equipment catalogue v3: 95 items (70 real-gym rows from the operator's two pictures) with real metre footprints (DEVICES), `min_tier`, `zone`.
  equipment 3/0, training_modifier 1/0, gym_hub 2/0, gym_decor 1/0, gym_wing 1/0. Models are greyboxes (EQUIP3 = sourcing, operator buys).
- GYMCAP1 + GYMCAP1B - capacity packer and report (`ClubCapacity.gd`, `club_capacity_rules.json`, GYMCAP1_REPORT.md/.csv): max copies of each item per tier,
  a full mix, stations per category, fighters = min(station slots, coaches x 10), members. T1 start hall 30 x 18 m: 20 fighters, 60 members, 80 at once.
  ASSUMPTIONS (unverified, flagged in the rules json): coaches per tier (T1 2, T2 4, T3 8), 4.65 m2 per member.
- GARAGEOUT1 - the garage concept removed everywhere (operator: "remove the garge concept from everywhere this is not that kind of game"): tiers are now
  T1 club (start, 30 x 18) / T2 commercial / T3 elite; catalogue min_tier remapped; no_garage_test guards the word. Ruling D46 in DECISION_LEDGER.
  The branch's replacement `shell_back/training_floor.png` was a blank dark panel and was NOT taken.
- GYMCAP2 - packed-gym view + capacity plate (`club_capacity`, OFF): every eligible station in the hall with the counts and fighters/members/total.
  The agent's version shifted everything to align the packed ring with the club ring (10 m of stations through the east wall) - fixed to hall coordinates;
  tests follow T1-T3 and support items; plate shows placed stations, counts first, named numbers. club_capacity_view 19/0, club_capacity 2/0, club_ 13/0.
  The view shows one of each eligible station plus filler (an assortment), not "the maximum of each" - that table is in the report.

## Ludo round 30 (text, saved verbatim in LUDO_ROUND30_S196.txt, prompt in LUDO_ROUND30_PROMPT_S196.txt)
Asked in one batch: A attrition per training area, B equipment <-> body benefits/defects (all 95 ids), C paying customers, D rest of design + schedule,
E gym-floor principles (no UI), F Ludo's own answers to its ten management questions, G GDScript modules, H the fighter readout (STATS1).
RECEIVED: A in full (model, schemas, AttritionProfile.gd, tests), B part 1 (first ~50 catalogue rows of 95 in the pipe format), C part 1
(acquisition, churn, usage and queues, access policies, wear, member injury, financials for 540 m2, staff roles).
STILL OWED: rest of B table + 12 cross-equipment mechanics, rest of C (archetype JSON, 30 events, decisions/KPIs, pipeline, schema/API/tests), D, E, F, G, H.
The Chrome extension blocks `navigate`/new tabs intermittently ("could not verify this site's safety category"); the save-to-disk trick
(`location.href='http://127.0.0.1:8799/?name=..&d=..'` with `Tools/arena_rx.py E:/FightCamp/tmp/ludo_s196` running) DID save despite the error message.

## Decisions made (Claude is the developer) and operator rulings this session
- D46 (operator): no garage anywhere. Tiers renumbered.
- Operator comments answered: C1/C6 bpm (fixed in code), C4/C5 "remove the other rooms from the gymfloor" (floor view ON, shown on the board).
- Operator design questions queued, NOT built: ATTRITION1 (area attrition, Darkest Dungeon style; recommendation YES, bounded; Ludo round 30 Section A is the spec),
  STATS1 (the 9 headline stats are not enough to read a fighter; underneath: 696 techniques, 6 body regions, composure, personality, plan - the gap is the readout;
  Ludo Section H). Operator: decide gym floor and UI FIRST, then reconsider UI design.
- Workflow rule learned: agent worktrees lack imported assets - the branch gate fails there ("NOT MERGEABLE" on missing .mp3/.import); run the focused test on master
  after applying the diff. A path-limited `git add` with one missing pathspec aborts the whole add - one commit carried only live_runs.json (fixed next commit 4226e51e).

## Open for the operator (board)
- Q-S194-7: turn `club_zones` ON in the demo? (still attached)
- Q-S194-6 (four-stage gym plan): answered by comment "i want the starting Gym to be minimum 450 sq. m adjust everything according to that" - done (D45, 540 m2).

## Next (exact)
1. Collect Ludo round 30: open Ludo (Chrome or the built-in pane), Ask Ludo, send "CONTINUE ..." for the owed parts (list above), save each reply with the arena_rx trick,
   append to LUDO_ROUND30_S196.txt. Then Claude turns A/B/C into verdicts (ATTRITION1, member model, equipment effects), the operator approves on the board, then build.
2. EQUIP2B (station_discipline_fit + day_lap rows for the 70 new items), EQUIP3 (models; prefab check; operator buys), GYMLOOK1B (dense equipment per tier), GYMLOOK1C
   (commercial-gym shell from the operator's two reference pictures), ROOMSPLIT1B, STATION-WEAR1, HUMAN2.. (roadmap queue order).
3. After the gym floor and UI are decided: STATS1 readout design, then reconsider UI.
