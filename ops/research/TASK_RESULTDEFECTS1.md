# TASK RESULTDEFECTS1 - seven places where the game tells the player two different things about one fight

Status: DONE - S442 (a85963eb, 97c13f6c).
(tools/result_dump.gd, seed 44, docs/mockups/s442/result/bout.json). Details and file:line for each:
ops/research/RESULT_ROUND3_S442.md, section on code defects. READ THAT FIRST, then confirm each in the code before fixing.

## The seven (each: ONE source of truth, every screen reads it)
1. Two energies at the last bell: FightStats' "tank at the last bell" (39 v 34) against the exchange records and the fight
   display, which also take off body shots (23 v 21). The sim fights on the second: every screen shows that one.
2. FightWhy tells the player to replace a plan line with a move the Playbook refuses at that place ("Feint and draw" for a
   line at long range; feint starts from outside). The suggestion must be a move PlanLines.options offers at that place.
3. The body map is built from 3D punches the exchange records did not count (62 v 68 against 58 v 70). One count.
4. Three head readings after one bout: the no-sparring rule (head took 46, 21 days), the body map (head 63, fine), the
   damage tile ("Nothing lasting"). One reading, and the tile says what the stand-down says.
5. Two position systems disagree on the first exchange of rounds 2 and 3 (the plan card says long range, where the line
   fired; the ring says inside).
6. The habit line says the opponent "made our fighter pay for a habit" on exchanges our fighter WON.
7. The round lines count 2 of 6 shouts working; the corner tile says "2 of 2".

## Contract
For each: a test that is RED on main first (name it in the note), then the fix, then green. Touch only the rule/state
files each defect lives in and their tests; no screen redesign. Parse check every touched script; run only the tests the
change touches (BoutNight, LiveRound, FightWhy, FightStats, BodyMap, StandDown, RingDuel/Duels, HabitFix, golden_path) through
`python ops/Tools/godot_slot.py run --who <name> -- <godot.exe> --headless --audio-driver Dummy --path . --script res://tests/<t>.gd`.
A fix that changes a balance number (who wins how often) is NOT made: report it with the measured change instead.
No pronoun in any game text; scripts under 500 lines. Commit nothing; write ops/research/RESULTDEFECTS1_RESULT.md.
