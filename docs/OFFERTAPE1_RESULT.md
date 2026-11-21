# OFFERTAPE1 - result (S535, owner review notes C448, C449)

Brief: `ops/research/TASK_OFFERTAPE1.md`. Prior research read: `ops/research/topics/ui_screens.md` (canonical UI page),
memory notes names-only-in-headers (S448), only-actionable-info (S398), screen-logic-of-the-moment (S439).

## Part 1 (built): form on the tale of the tape (C449 "ok. maybe add streak/latest results?")
- `scripts/rules/TapeRows.gd` is still the one list. Two new rows under Record: **Last 5** (newest first: W / L / D,
  inside the distance W(KO) / L(KO)) and **Streak** in words ("3 wins in a row"; one bout: "won the last bout").
- Where each corner's five come from. Nothing is invented:
  | Who | Source |
  |---|---|
  | Our boxer | `Career.results` (newest first), then the bouts brought to the club (`PriorBouts`, the History tab's own list) - `scripts/state/TapeForm.gd` |
  | Amateur rival | the bout-by-bout record the game already keeps (`RivalPast`, `r["bouts"]`: rival v rival at club shows, and against us) |
  | Pro / world boxer | a new small `form` list (5 kept), written where the record moves: `Matchmaking.apply_result`, `WorldSim._apply_bout_result`, a ladder draw in `ProLadder.result`; `ProLadder.bout_opp` carries it to the bout |
  The brief said opponents keep only w / l. Amateur rivals already keep every bout (S341 RivalPast), so the row reads that
  record and no second list was added for them; only pros needed the new list.
- Unknown: a record with nothing on tape (an old save's world boxer until the next bout) shows the record only; Last 5 reads
  "?" with "not on tape" (the TapeRows MISSING / WHY rule) and there is no Streak row. No bouts at all is a dash.
  Old saves load: every read is a `.get` with a default, no migration.
- Screens: fight night's tape card and the 3D intro's bands (`TapeVersus`), the prep page's tale (`FightPrep`). The bout
  offer does not get the rows: part 2 redraws it. The in-ring `TapeCard` draws whatever TapeRows rows it is handed.
- Files touched beyond the brief's OWNS list (the brief itself asks for the writers): `scripts/state/TapeForm.gd` (new),
  `Matchmaking.gd`, `WorldSim.gd`, `ProLadder.gd`, `TapeVersus.gd`, `FightPrep.gd`, one expectation in `tests/tape_rows_test.gd`.

## Part 2 (mockup only, NOT built): the bout offer as a decision (C448 "this looks too much like the tale of tape")
- `ops/previews/s535_offer_mockup/offer.html` / `offer.png` (1920x1080, Palette colours, the game's fonts and painted bodies).
- The centre is a letter from the host club, not a stat table: the night, time to prepare, money to the club, the sanction,
  what a win and a loss each do (ladder, members, record, loyalty), answer-by as a stamp. Left: our boxer and what a pass
  costs. Right: the coach's read with the win range, the opponent's form and style, and the three facts that decide it.
- The form marks on the mockup are the ones the game shows for this bout (`tape_with_form.png` beside it, the real tape).
- Waits for the owner's OK before any build.

## Tests
- Red first: `tests/tape_form_test.gd` on the untouched tree failed to load (rc 1: `streak()`, `push_form()`, `FORM_KEEP` not in TapeRows).
- Green after (headless, one at a time through the Godot queue): tape_form_test 0 failures, tape_rows_test 0, tape_versus_test 0,
  versus_test 0, nocamp_page_test 0, matchmaking_bots_test 0, pro_ladder_test 0, world_rules_test 0 (6 checks),
  save_load_test 0 (86 checks), golden_path_test 0.
- Still (hidden desktop, the real flow, `layout_snapshot.gd only=18_tape`): `ops/previews/s535_offer_mockup/tape_with_form.png` -
  quick start, the first offer: our boxer 3-1 "W L W(KO) W(KO)", "won the last bout"; the opponent 5-1 "W W L W W(KO)", "2 wins in a row".
- Not checked on a picture: the 3D intro's bands and the prep page (covered by tests only).
