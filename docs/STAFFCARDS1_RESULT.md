# STAFFCARDS1 result (S547)

The Staff window of the office computer is now cards, built from the S546 mockup (`docs/mockups/s546/staff_cards.png`).
Branch `build/staffcards1`. Brief: `ops/research/TASK_STAFFCARDS1.md`.

## What each step changed

0. **Red first.** `tests/staff_cards_test.gd` (new). It ran red on the shipped page with 21 failures (commit 1 on the branch).
   The test checks:
   - the two sections AT THE GYM and JOBS OPEN;
   - every card `StaffCard_<id>` has a face or a silhouette, a name, at most 4 facts and at most 1 button;
   - an open job borrows no face;
   - the page fits the office window with no scroll;
   - exactly one Hire pulses when there is no coach;
   - the head line;
   - Hire on the physio moves the card to AT THE GYM with NEW and a "Let go" button;
   - Let go moves it back, and the game really lets the physio go;
   - the word "club" never appears on the page.
1. **`scripts/ui/StaffDesk.gd`** (new, 309 lines) builds the two rows from `OfficeDesk.staff_sheet(c)`.
   - Card specs come from `_you`, `_coach` (hired, or for hire while no coach is signed), `_mat` (while a grappler trains),
     `_role` (the four jobs; hired ones go to AT THE GYM) and `_evening` (the coaches working, plus the open job for one more).
   - `hover(c, id)` gives each card's hover. `boxer_line` and `means` give the coach's week and his tactics/film checks.
   - `_mark_new` adds NEW (see step 3).
   - `_head` writes the head line into the window bar, beside STAFF: "3 at the gym · 5 jobs open · wages $620 a week",
     then the reputation word.
   - **`scripts/ui/StaffDeskCard.gd`** (new, 238 lines) draws one card: picture strip, name over it, tag, NEW, role line, fact dots,
     button, a dashed edge for an open job, and a grey silhouette drawn in code. **Decided:** a second file, so that StaffDesk stays
     under the brief's 400 lines. This file is not in the contract's OWNS list; it is new and touches nothing else.
   - The first-need pulse: with no coach, Luke Reid's Hire pulses. This is the button the guide strip already lights
     (guide step "coach", `guide_person_test`: "the light is on the Hire button"). With a coach signed, nothing pulses: the guide
     names no staff job after the coach. That meets the brief's feedback-loop check.
2. **Wired.**
   - `scripts/ui/areas/Gym.gd` calls `StaffDesk.page` for gym:0-2.
   - `scripts/ui/areas/Office.gd` (still 499 lines):
     - new `bar_head` (the window bar's row) for the head line;
     - the Staff foot line is now "Hover a card for what each job changes." (the "Scroll the window ..." line is gone);
     - the dock's Staff icon now goes to gym:1, the cards; the coordinator's decision;
     - `SHEET_APPS` is only Fighters, because the Fighters icon opens the sheets view, which still holds both sheets.
   - `scripts/ui/StaffCard.gd` is down to `ROLE_WORD` (7 lines), which OfficeDesk and StaffDesk read. Everything else went:
     `page`, `_promises`, `_head`, `_you`, `_coach`, `_hired`, `_with_areas`, `_bars`, `_boxer`, `_points`, `_facts`,
     `_roles`, `_role`, `_figure`, `_bjj`, `_members`, `_tile`, `_no_file`, `_tag`, `_slate`, `_chip`, `_host`, `_icon`,
     `_ink_icon`, `_paint_bar`, `_photo`, `TABS`, `ROLE_ICON`. The only outside caller was `tests/film_night_test.gd` (`_facts`),
     which I rewrote (see below). The needed parts moved into StaffDesk (`_with_areas`, `_photo`, `_points`, the figures).
3. **What changed after a click.** A card that arrives at AT THE GYM during a visit gets NEW: a gold tag and a gold edge.
   The NEW stays until the page is left (`main.past` grows when the player leaves). It works the same from the card's button or
   from any act that re-renders the page. There is no toast-only feedback and no pop-up. Let go asks nothing more than the game
   does today (the old acts: `letgorole`, `eveningcoach cut`).
4. **Stills** are in `docs/playtest/s547_staff/`, made by `tools/jump_snapshot.gd` on the hidden desktop. Each run ended with
   `JUMP_SNAPSHOT bounds=0` (no BOUNDS line). I opened all three.
   - (a) `jump_staff_real.png`: fresh quick start with no coach (new jump `staff` in `scripts/ui/TestJump.gd`, 453 lines).
     1 at the gym, 7 jobs open.
   - (b) `jump_club4_go_gym1_real.png`: the test club (`jump=club4`): Luke Reid hired, Ana on the mat.
     3 at the gym (you, Luke Reid, the mat coach), 5 jobs open, wages $620 a week: the same state as the mockup.
   - (c) `jump_club4_go_gym1_hirerole_real.png`: the same after `hirerole physio`. The physio's card is AT THE GYM with NEW and
     Let go, and the head line reads 4 / 4 / $695.
5. **Tests.** `_fits` in `tests/coach_areas_test.gd` asks for no scroll, and its comment now says so (it had been allowed to
   scroll "until the cards redo").

## What left the page, and where it lives now

| Was on the page | Now |
|---|---|
| The coach's five area bars ("Versus no coach") | The coach card's hover: his three best areas, the most rows the tooltip standard allows (`Tip.MAX_ROWS`). The card itself says "Best at pads: moves +30%". |
| The boxer's week line (BoxerLine) | The coach card's hover (`now`) |
| The tactics, film checks, pay, classes, real cost and signing fee tiles | Pay and classes are facts on the card; tactics and film checks are in the hover (`StaffDesk.means`); the signing fee is on the Hire button's hover |
| The members tile | The office desktop (`Office.gd` members number) and Finance |
| The dues tile | Finance (the dues boards, `Money.gd`, `DuesBoards`) |
| The reputation tile | No other screen shows it, so it stays here as one word in the window bar after the head line ("Known locally"), with a hover |
| The "Need a coach" tile | Gone: the two coach cards for hire, with the pulsing Hire, say it |
| The roster places tile (1 / 1) | Finance's "Staff, a week" card hover (`MoneyPanels.gd`); the Second coach card says "1 more boxer on the roster" |
| PROMISES OPEN (a slate of rows) | No other screen lists them, so your own card keeps them as a fourth fact, "Promises open: N", with the list on its hover (node `PromisesOpen`) |
| The CLUB head and its tabs | Gone since S546 (the office window's bar) |

## Decided, not asked
- **No "Let go" on the coach or the mat coach** (the mockup draws one on each): the game has no act for either, and the brief
  forbids rule changes.
- **The evening coach is never refused by the game** (`GymSpend.evening_coach`). So its Hire button stays enabled. While the
  gym has room, the button is the quiet one and the card says "Not needed yet: the gym has room". No other job has a case the
  game refuses, so no card has a disabled button.
- **Hired jobs (physio, strength coach, cutman, second coach) get a silhouette, not a face.** The game has no person for those
  jobs, and an open job may not borrow a face either.
- **The mat coach uses `mh_staff_coach_2`**, the face the mockup gives it.
- **Card sizes:** 330 x 146 strip on a 320-wide card. The mockup's 356-tall card does not fit two rows in the 756 px window.
  The strip is at most 2.15 times as wide as it is tall, because `face_frame_test` needs the whole head inside the frame and a
  704 px portrait cannot fill a wider strip. On a 320-wide card that leaves a few pixels at the sides.
  A row with more than five cards narrows them (the fresh start's JOBS OPEN has seven at 232 px), and their text drops to 15 px.
- **Page words:** `coach_areas_test` capped the page at 110 words, the slate page's count. The cards carry 141 with one coach
  and four jobs hired; the cap is now 150, the mockup's count.

## Tests rewritten, and why
- `tests/coach_areas_test.gd` (owned):
  - CoachCompare → the two coach cards in JobsOpen.
  - AreaBars (5 bars, sorted, "Best at" on the first) → the hover's three ranked rows, only the best marked good, plus
    "Best at pads" on the card's face.
  - BoxerLine → the hover's `now` equals the WeekPlan line.
  - The CoachTiles/Members "tile explains" check → every card's hover explains (6 words or more).
  - Word cap 110 → 150 (above).
- `tests/office_screen_test.gd` (owned): the Staff icon now opens gym 1, the cards.
- `tests/people_slate_test.gd` (owned): unchanged and green. HeadCoachRow, Assistant_<id> and Role_<id> are each card's
  inner node.
- `tests/film_night_test.gd`: `StaffCard._facts` tile text → `StaffDesk.means(85)` / `(50)`. Same subject: the coach says
  4 / 2 film checks a night.
- `tests/tooltip_standard_test.gd`: the CoachTiles walk → each StaffCard_* hover must be a full card that breaks no rule.
- `tests/words_on_screens_test.gd`: "Versus no coach" (the bars' caption, now in the hover) → "Best at" on the card.
- `tests/office_sheet_test.gd`: it reached the staff sheet through the Staff icon. It now goes through the Fighters icon (the
  same sheets view, both sheets).
- `tests/test_jump_test.gd`: a check for the new `staff` jump.

None of these deletes a check that still has a subject.

## Pass lines (JOBS=1 through godot_slot, worktree E:\FightCamp\wt\STAFFCARDS1)
RESULT: tests/staff_cards_test.gd -> STAFF_CARDS failures=0
RESULT: tests/coach_areas_test.gd -> COACH_AREAS failures=0
RESULT: tests/people_slate_test.gd -> PEOPLE_SLATE failures=0
RESULT: tests/office_screen_test.gd -> OFFICE_SCREEN failures=0
RESULT: tests/guide_person_test.gd -> PASS guide_person_test
RESULT: tests/film_night_test.gd -> PASS film_night_test
RESULT: tests/first_week_test.gd -> PASS first_week_test
RESULT: tests/golden_path_test.gd -> PASS golden_path_test
RESULT: tests/plain_words_test.gd -> PASS plain_words_test
RESULT: tests/palette_guard_test.gd -> PASS palette_guard_test
RESULT: tests/file_limits_test.gd -> PASS file_limits_test
RESULT: tests/test_jump_test.gd -> PASS test_jump_test
RESULT: tests/words_on_screens_test.gd -> WORDS_ON_SCREENS failures=0
RESULT: tests/grey_reason_test.gd -> PASS grey_reason_test
RESULT: tests/one_look_test.gd -> PASS one_look_test
RESULT: tests/office_sheet_test.gd -> PASS office_sheet_test

Still red, and not from this branch:
- `tests/tooltip_standard_test.gd`: `broken=1`, on the reception screen, not on Staff.
  `TIPFAULT reception [long] label="BODY 54-71"`, from `scripts/ui/modals/Interview.gd:118`, which came in with today's
  KNOWBUILD1 merge (1f12a0087). Every Staff card hover in that test passes. This is outside my files, so I left it for the
  coordinator.
- `tests/face_frame_test.gd`: the one `bout | ... OppArt/Body | mh_boxer_13.png` row. It already fails in the nightly run
  (`ops/AgentComms/nightly/latest.txt`). All three Staff faces pass.

## What still differs from the mockup
- Cards are 330 tall with a 146 px strip (mockup: 356 and 150), so that two rows fit the 756 px window.
- On a 320-wide card the face is a strip 314 px wide, so there are 3 px at each side (face_frame rule, above).
- There is no "Let go" on Luke Reid or the mat coach (the game has no such act).
- The mat coach runs "5 classes" at $170 and brings in $203: the game's own numbers (the mockup said 2 classes).
- The mockup's foot line "The pulsing button is the hire the gym needs first" is cut down to "Hover a card for what each job
  changes.", because once a coach is signed nothing pulses.
- With no coach, JOBS OPEN has seven cards, which narrows them to 232 px and wraps some facts to two lines (the mockup draws
  five).
- The hover is not in the stills (`jump_snapshot` cannot pin a hover); its contents are checked by `coach_areas_test` and
  `tooltip_standard_test`.
