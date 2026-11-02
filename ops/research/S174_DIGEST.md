# S174 digest (cloud) - the day lap's four pure modules + the cloud seats fixed

- **DAYLAP1B CoachPool** (Arena PR #57 -> d7ee079e): coach pool + station buff. Diff applied (3 files), coach_pool_test 69, mutant (drain zeroed) red. Arena never ran Godot - verified here with /opt/godot/godot.
- **DAYLAP1C MoveCards** (Goose PR #58 -> 2f91ec47): time on a card makes a move usable, combos need all parents usable, coach-knowledge gate. move_cards_test 66, mutant (usable_minutes 60) red. Goose added set_table_for_test/table_override test hooks in the module (harmless, unused by the game).
- **DAYLAP1D PitStop** (Claude, 74d95f7c): rest-break services (refuel, fresh legs/arms, patch up, the talk, the tape), soreness by station, staff speed. pit_stop_test 33.
- All four are PURE modules, wired to nothing yet. day_lap_test still 81.
- **Cloud seats were broken**: Goose runs 4+5 did no work - `gemini-2.5-flash` 404s ("no longer available to new users") AND the repo variable GOOSE_MODEL pinned it. Fix f180762f: workflows read GOOSE_MODEL_NOW / OPENCODE_MODEL_NOW (unset) -> default `gemini-flash-latest`. Run 6 worked (14 min incl. 9 min Godot import). OpenCode has the same fix, NOT yet run.
- Arena is driven by the operator from the browser (no browser pane in the cloud session); Goose/OpenCode are drivable from the cloud via issue + label/`/oc`.
- NOT done: no splice into GymHall3D, no walk clip, no hall video (needs the PC), tape service only stores a note (its training effect is undecided).
- Actions budget: 3 Goose runs ~42 min of the 2,000 free.
