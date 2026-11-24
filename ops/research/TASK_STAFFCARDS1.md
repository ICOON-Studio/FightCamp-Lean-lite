# TASK STAFFCARDS1 - the Staff window as cards (S547)

Kind: build (one screen, from an approved-to-build mockup). Model: claude-opus-5-5.
Discipline: boxing (demo path). Seat: Claude worker in a console tab. Estimate: 3-4 hours.

## Why
The owner on the Staff screen (S545): "this screen is terrible". It is rows of tiles and key/value lines. S546 drew
the answer as cards: `docs/mockups/s546/staff_cards.png` (+ `staff_cards.html`, the same page as HTML/CSS: sizes,
colours and words are in it). That picture is the spec. Open it first.

## METHOD (quote in your first message)
- A SCREEN OF PEOPLE IS CARDS, NOT A SPREADSHEET (owner S544: "this is still confusing and looks like spreadheet you
  need to use art"): each person or job is a card - the face with the name over it, the job in plain words, at most
  FOUR plain facts, one button. Details on hover. Never rows of key / value as the main content.
- NO POP-UP AND NO ICON TILES (owner S545: "this looks like AI slop"). The page itself shows what changed.
- LITTLE TEXT (owner S545: "you do not need to spell everything out for the player"; "A simple You pay : 123456$ is
  enough , if more things are needed use the fucking tooltip"). A tooltip explains, it never repeats the label.
- PLAIN MENU WORDS; THE PLAYER'S PLACE IS THE GYM (owner S545: "what happened to normal words like staff"; "i do not
  understand whatis club and what is gym"). Never "club" for his own place.
- NOTHING CUT BY THE SCREEN (owner S544: "why half the screen isout of bounds"): the hosted office window is 756 px
  tall; the whole Staff page fits in it with NO scroll. `tools/jump_snapshot.gd` on the hidden desktop with
  `--log=<file>` prints BOUNDS lines into the log: none may be there. Open every picture yourself.

## Where you work
1. `git worktree add E:\FightCamp\wt\STAFFCARDS1 -b build/staffcards1` from the main checkout (E:\FightCamp\Lean), then
   `powershell -NoProfile -ExecutionPolicy Bypass -File ops\Tools\seed_godot_cache.ps1 -Worktree E:\FightCamp\wt\STAFFCARDS1`.
2. Work, test and commit ONLY inside that worktree (absolute paths; never edit the main checkout: the coordinator
   and another worker are in it).
3. Tests: `TESTS="<names>" JOBS=1 sh tools/run_tests.sh` from the worktree, through
   `python ops/Tools/godot_slot.py run --who STAFFCARDS1 -- sh tools/run_tests.sh` (headless, Dummy audio; never the
   whole suite). Before each Godot job `powershell -NoProfile -ExecutionPolicy Bypass -File ops\Tools\pc_watchdog.ps1
   -Once`: RED = wait. A parse error hangs a headless test: after every edit run the smallest test that loads the
   file. Read `ops/research/GDSCRIPT_TRAPS.md` first. Never `_console.exe`. Nothing opens on a monitor: images are
   read with the file tool only.
4. After each step: commit on `build/staffcards1` and `git push -u origin build/staffcards1` (the branch only, never
   main). The coordinator merges by diff.

## What the code says today (read before you write)
- `scripts/ui/areas/Gym.gd` l.25: `StaffCard.page(_window(main, "staff"), main, c, false)` draws the Staff window
  inside the office computer (`scripts/ui/areas/Office.gd` `HOSTED["staff"]`, its foot line says "Scroll the window
  for the jobs and the members" - that line goes: nothing scrolls).
- `scripts/ui/StaffCard.gd` (493 lines, at the limit - do NOT add to it): `page`, `_you`, `_coach`, `_roles`, `_role`,
  `_bjj`, `_members`, `_photo`, `_figure`, `ROLE_WORD`. Its acts: `hire` <coach id>, `hirerole` / `letgorole` <role
  id>, the evening coach buttons. Find each button's act in it and keep the same act and argument.
- `scripts/ui/OfficeDesk.gd` `staff_sheet(c)` l.352: every row the page needs - kind `you` | `coach` | `hire` | `role`
  | `open` | `evening`, with name, job, status, pay, runs, changes, the coach's five areas, the face.
- `scripts/ui/PromoShot.gd` `picture`: the face. `scripts/ui/Tip.gd` / `Tips.card` (see `TopCards.gd`): the hover card.
  `scripts/ui/ProScene.gd` `fact`: a fact line with its hover. `scripts/ui/Pulse.gd`: the pulsing button.
- Tests that name this page's nodes: `tests/coach_areas_test.gd`, `tests/people_slate_test.gd`,
  `tests/office_screen_test.gd`, `tests/guide_person_test.gd`, `tests/film_night_test.gd`. Node names to keep where
  the thing survives: `PeoplePage`, `HeadCoachRow`, `Assistant_<id>`, `Hire_<id>`, `Role_<id>`, `BoxerLine`.

## The steps (each ends with its tests green and one commit)
0. RED FIRST: `tests/staff_cards_test.gd` - on a quick-start career with Luke Reid hired: the Staff window has a
   section AT THE GYM and a section JOBS OPEN; every person and job is ONE card node (`StaffCard_<id>`) with a face or
   a silhouette, a name, at most four fact lines and at most one button; an open job's card has no borrowed face; the
   page's content height fits the 756 px window (no scroll bar needed); pressing a job's Hire moves its card to AT THE
   GYM with NEW on it and its button now reads "Let go"; pressing Let go moves it back. Commit it red.
1. `scripts/ui/StaffDesk.gd` (new, under 400 lines): `page(parent, main, c)` builds the two sections from
   `OfficeDesk.staff_sheet(c)`. Cards about 320 x 300 (five across in 1,700 px), as in the mockup:
   - AT THE GYM: you, the hired coach, the mat coach when a grappler trains here, each hired role, the evening
     coaches. The face (`PromoShot.picture`), the name over it, a small tag top-right (You / 3 evenings / No-gi), the
     job in plain words, facts as dots (green = what it gives, gold = "You pay: $450 a week", "Classes bring in:
     $350"), and "Let go" where the game allows it.
   - JOBS OPEN: the coaches for hire when no coach is signed (their own faces: they are people, with the signing
     fee on the button's hover), then the four roles and the evening coach as dashed cards with a grey silhouette, the
     job name, what it gives, the price, and "Hire". The ONE hire the gym needs first pulses (reuse the rule the page
     has today for its first-need hint; if it has none: no coach -> a coach; else the first role the guide names;
     else none pulses). A job that cannot be hired yet has a disabled button and the plain reason as its fourth line
     ("Not needed yet: the gym has room").
   - Hover on a card (`Tips.card`): the coach's five area bars, tactics and film checks, what the role changes with
     its numbers. Nothing of that is on the card's face.
   - The head line right of STAFF: "3 at the gym · 5 jobs open · wages $620 a week".
2. Wire it: `Gym.gd` calls `StaffDesk.page` for the hosted Staff window. `StaffCard.gd` keeps only what other pages
   still call (grep each function before deleting; delete what nothing calls, and say what went). The members /
   reputation / dues tiles leave this page ONLY if each is shown elsewhere (Finance shows members; check reputation
   and dues and write where each lives) - if one has no other home, keep it as one small line under the head, not a tile.
   The sortable Staff sheet stays where it is (the office's Fighters and staff sheets): decided by the coordinator -
   the dock's Staff icon opens the cards because that is the page he called terrible; the sheet is the list view.
3. After a click the page says what changed: the card that moved carries NEW until the page is left; no toast-only
   feedback, no pop-up. A let-go asks nothing more than the game asks today.
4. Stills: `tools/jump_snapshot.gd` jumps for (a) the Staff window on a fresh quick start (no coach), (b) with Luke
   Reid hired and a grappler training, (c) after hiring the physio (NEW on its card), into
   `docs/playtest/s547_staff/`. Add the jumps to `scripts/ui/TestJump.gd` if none fits (it is at 448 lines: stay under
   500). Open each picture, compare it with the mockup side by side, fix what differs, and write what still differs.
5. Put `_fits` in `tests/coach_areas_test.gd` back to "no scroll" and rewrite the tests that named rows the page no
   longer has (say which and why; never delete a check that still has a subject).

## Not allowed
No rule change: wages, effects, who can be hired and when stay exactly as the code has them. No new art generated
(the silhouette is drawn in code or reuses an existing grey figure). No file over 500 lines. No raw colours in a new
file (`Palette.gd`; `tests/palette_guard_test.gd` must stay green). No "club" for the player's place.

## Tests
`staff_cards_test` (new), `coach_areas_test`, `people_slate_test`, `office_screen_test`, `guide_person_test`,
`film_night_test`, `first_week_test`, `golden_path_test`, `plain_words_test`, `palette_guard_test`,
`file_limits_test`, `test_jump_test`.

## Feedback loops
None: the build changes how the Staff window is drawn and nothing a rule reads. The acts are the ones the page has
today. One check: the first-need pulse must not point at a hire the guide strip does not also name.

## Prior research
`ops/research/topics/staff_coaches.md`, `ops/research/topics/ui_screens.md`, `ops/research/S546_DIGEST.md`
(Staff, Finance and Log as office windows), memory notes "A decision screen is a scene (S544)", "No pop-up, no icon
tiles; plain menu words (S545)". The signing card build (`scripts/ui/ProspectScene.gd`, `modals/Prospect.gd`, merged
S547) is the nearest card screen in the code: copy its card pattern, not its layout.

## What would a human do?
A UI artist with the mockup beside the game would build one card, screenshot it at 1920x1080, lay it over the
mockup, fix spacing and type until they match, and only then build the other nine.

## Prefab check
None to take: the cards are ours (`UI.card`, `ProScene.fact`, `PromoShot.picture`, `Pulse`).

## VISUAL GATE
Red first: `tests/staff_cards_test.gd` red on the branch before step 1. The three stills from the real windowed game
(jump_snapshot, hidden desktop), opened by you, no BOUNDS line in the log, each checked against the mockup and the
five METHOD lines. The coordinator checks them again before the merge; the owner's eye closes it.

## Contract
OWNS: scripts/ui/StaffDesk.gd, scripts/ui/StaffCard.gd, scripts/ui/areas/Gym.gd, scripts/ui/areas/Office.gd, scripts/ui/TestJump.gd, tests/staff_cards_test.gd, tests/coach_areas_test.gd, tests/people_slate_test.gd, tests/office_screen_test.gd, tools/run_tests.sh, docs/playtest/s547_staff/, docs/STAFFCARDS1_RESULT.md
RED_TEST: tests/staff_cards_test.gd
REGRESSION: tests/coach_areas_test.gd, tests/people_slate_test.gd, tests/office_screen_test.gd, tests/guide_person_test.gd, tests/film_night_test.gd, tests/golden_path_test.gd, tests/first_week_test.gd
VISUAL: three stills of the real Staff window (no coach, coach + grappler, after a hire), opened, no BOUNDS line

## Result
`docs/STAFFCARDS1_RESULT.md` on the branch: what each step changed (files, functions), what left the page and where
it lives now, every test rewritten and why, the pass lines (`RESULT: tests/<x>_test.gd -> <exact pass line>`), the
stills, and what still differs from the mockup. Commit only your own paths with a pathspec; do not ask questions:
decide, and write what you decided.
