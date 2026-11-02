# S260 DIGEST (2026-10-19) - the 11 attributes are in the game: trained in the gym, read by the bout, seen in the punch

Operator board Q-S256-1 (answered S259/S260): "add them all , wire them properly to training and fight".
Operator S260 (chat, original session): "can you add the actions github meter on opsboard real-time sync please" - done in that
session, not in this one.

## What now works (switch `attributes`, GAME_ON + FightRealtime.DEMO_SWITCHES)
- `scripts/rules/Attributes.gd` (TASK_ATTRIB1 Part A, Ludo S259 sections 1-5; written by Claude - Arena ATTRIB1's sandbox `git push`
  hung for 20+ min and nothing reached GitHub; the chat was told to stand down): migrate (old speed/defense/... kept), derived
  (accuracy, evasion, ko_leverage, damage_mitigation, trauma_threshold), gain/decay (Ludo's table, twitch x0.6 from 32, compounding
  decay past the pivot), wisdom_round_gain, chin_after, motion (22 physical parameters, 20 -> 80 linear, fatigue below half a tank).
- `scripts/rules/AttributeTraining.gd` (new, pure): club station -> Ludo station routing (CLUB_TO_LUDO - speed bag, pads = focus
  mitts, defence drill = slip bag + double-end, ring = sparring, treadmill = roadwork, bike = AirDyne, weights/platforms = medicine
  ball, recovery = physio + ice bath; all 10 trainable attributes reachable, chin never); apply_day (hours = minutes/60, coach
  factor 0.5 + rating x 0.007 like the weekly program, genetic cap = potential + 10; an untrained day decays first, recovery still
  pays); migrate_fighter (no stored chin -> the chin FightLink gives today, so nobody's chin moves); fight_stats; retime_floors;
  flinch_scale; after_bout.
- GameState: `load_career` migrates every roster fighter (old keys kept); `generate_starter_boxing_roster` starts migrated;
  `file_visit` (the lived club day the game runs) grows them; `_apply_fight_result` takes chin (-1.5 per knockdown suffered, -4.0
  for a KO loss - method KO or KO/TKO, a cut TKO is not concussive) and adds 0.05 fight_iq + composure per round boxed.
- FightRealtime: `fl_stats` = AttributeTraining.fight_stats (Ludo's accuracy / evasion) when ON. All-50 fighter = today's bout.
- The watched punch: PunchRetime.plan takes per-fighter floors - jab extend 0.275 s (hand_speed 20) -> 0.200 s (80), retract
  0.245 -> 0.180, cross extend 0.360 -> 0.280; +0.015 s per 0.1 tank under half. FightWorldLiveScreen seats them per side and
  updates them from stamina every frame. Technician (hand_speed 79) jab 0.201 s, banger (43) 0.246 s.
- Composure: the damage snap (FightHitAdditive, head/neck/spine) scales with Ludo's "Damage Flinch Amplitude" 24 deg (composure 20)
  -> 4 deg (80), normalised at composure 50 = today (scale flinch_deg / 14), Ludo r11's 24 deg cap kept.

## Evidence
- `tests/attributes_test.gd` ATTRIBUTES failures=0; mutant (hand_speed weight 0.70 -> 0.60) -> failures=3.
- `tests/attribute_training_test.gd` ATTRIBUTE_TRAINING failures=0 (routing, day gain = Attributes.gain exactly, age x0.6,
  decay, chin, fight_stats, retime per fighter, after_bout, flinch scale).
- `tests/attribute_wire_test.gd` ATTRIBUTE_WIRE failures=0 - real paths: file_visit OFF writes nothing; ON 3 speed-bag hours
  hand_speed 43.185 -> 43.736, footwork untouched; rest visit decays; bout fl_stats ON accuracy 71.15 / evasion 71.65 vs OFF 70/70;
  CONTROL all-50 ON vs OFF identical bouts (589 landed / 1743 thrown both).
- Cloud (GitHub runners, branch claude/attrib-s260 at e948b77c): CONTROL arm 21/21 PASS (attributes, attribute_training,
  attribute_wire, game_switches, fightlink_wire, fight_link, floor_gain, mastery_wire, mastery_week, game_training_split,
  career_mornings_path, bout_wear_wire, counter_window_wire, athlete_development, shout_training, punch_retime, fight_chin,
  career_ladder, bout_read, fight_playback, fight_log). GAME arm (`--as-game`) 15 tests: 7 fail on the branch AND on master with
  IDENTICAL failure lines (fight_chin, fight_playback, career_ladder, fight_log, amateur_circuit, contender_series hang, ambitions
  hang) - those tests build their own state and are not as_game tests (e.g. the game's empty-gym start = "starter boxer exists"
  FAIL); same for career_mornings_path / all_mechanics_on_soak / mastery_wire / punch_retime / bout_wear_wire / mastery_week.
- The game arm FOUND two real defects of this change, fixed in e948b77c: floor_gain (a heavy-bag week moved power +9.1 vs the
  0.10..1.50 bound) and game_training_split (weekly baseline) - the 4 shared old stats were trained twice and Ludo's per-real-hour
  rates ran on 600-minute game days. Now the lived day grows only the 6 new attributes at PACE 0.04 (single-station week ~ +0.5,
  the S188 census band). Both PASS as_game after the fix; game_switches got the new engine switch registered.

## Decided (developer calls, CLAUDE.md s2)
- Lived-day growth only for the 6 NEW attributes; the 4 shared old stats keep the calibrated S188 gain. PACE 0.04 (census-matched).
- Station routing table above (Ludo named gym stations our club does not have; each club station maps to the Ludo station it IS).
- Decay only on a day with no training (Ludo "idle"), so a specialised week does not bleed the attributes it skips.
- Composure normalised at 50 (house rule: the average fighter keeps today's engine constants; FightLink did the same).
- class_name dropped from both new modules (a const preload of the same name shadows the global class - GDSCRIPT_TRAPS).

## Not done / next
- Motion still owed (visual gate - game-camera stills + the operator's OK): GUARD glove height (Ludo -0.12 m -> +0.06 m; glove-in-head
  risk, S246 "the whole selling point") and FOOTWORK step cycle / speed (FightFootwork) - Ludo's build order 1 and 2.
  Also hitstun_s (composure) and the fight_iq range numbers (with FIGHTGAP1 spacing).
- UI: TASK_ATTRIBUI1 (Cursor) - the profile still shows the 9 old stats incl. GRAPPLING / TAKEDOWN DEF / TOP CONTROL on a boxer
  (still: docs/previews/attrib_s260/profile_overview_before.png). Ludo asked WITH the still uploaded (chat "Boxing Shout System"):
  research/ludo_rx/LUDO_ATTRIBUI_S260.txt, 19,561 chars (saved by a POST from the page to Tools/arena_rx.py - the extension filter
  blocks reading long replies). Verdict in the brief: 3 groups (PHYSICAL / TECHNICAL / MENTAL & RESILIENCE), 20 px rows + 14 px
  headers in today's height, chin innate (lock, no ceiling, loss gap against the new `chin_born`), radar = the 5 derived numbers.
  Cursor issue #272 (Cloud Cursor, branch cursor/issue-272). Parked for the operator: Ludo's rating = mean of 10 attributes
  (moves matchmaking) and SUB -> DQ record wording.
- Defect seen on that still (header, top right): STRESS overlaps CONDITION and WEIGHT overlaps "0 CALM" - proposed as its own session.
- Tooling: cloud-tests.yml now uploads every test's own log (18b088d5) - before, a cloud FAIL showed only its summary line.
