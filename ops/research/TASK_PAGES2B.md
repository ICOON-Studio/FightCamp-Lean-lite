# TASK PAGES2B - CURSOR (Auto) - the Fighters page as painted: one wide row a fighter

Status: OPEN (S438, Claude main). Discipline: boxing (the no-gi athlete gets the same row with her own words).
Model: auto (operator S439 on Q-191: "Use Auto model"; PAGES2 died in 10 s on the usage limit, this is the same task re-run).
Source: the operator approved painting 1 of the Fighters page (docs/mockups/s432/ludo/fighters_paint-v1.png; the words
are docs/mockups/s431/final/squad.html; the contents are fixed in ops/research/CORE_LOOP_MAP_S432.md section 3,
"FIGHTERS PAGE, approved", lines 74-88: read them first, they are the spec). Today the Roster tab is a plain sortable
table (scripts/ui/RosterTable.gd). This task replaces that table with the painted rows, from data the game has TODAY.
You cannot see pictures: the layout below is measured off the painting; Claude opens every still.

## Contract
OWNS: scripts/ui/RosterRows.gd, scripts/ui/RosterRowBits.gd, scripts/ui/areas/Fighters.gd, tests/roster_rows_page_test.gd, tests/roster_slate_test.gd, docs/PAGES2_RESULT.md
RED_TEST: tests/roster_rows_page_test.gd -> ROSTER_ROWS_PAGE failures=0
REGRESSION: roster_row_test, roster_slate_test, roster_cards_test, roster_flag_test, roster_summary_test, fighter_profile_test, file_limits_test, no_pronoun_test
VISUAL: ops/previews/pages2/fighters_real.png
NOT YOURS: scripts/rules/RosterRow.gd and tests/roster_row_test.gd (Qwen's ROSTERROW1: step 1 below is ITS task; start
only once it is on main, and build the rows from RosterRow.row), scripts/ui/RosterTable.gd (leave the file; `needs_line` stays in use; the Roster tab stops calling
`RosterTable.build`), UI.gd, WoodKit.gd, Halo.gd, every rule module (read them; never change a rule to fill a cell).

## The row (1920 x 1080 page; a row is 1826 wide x 198 high, rows 200 apart, the first at y 190)
Columns, left edge x and width, in the painting's order. Header words in gold small caps above the first row.
| col | x | w | what it shows (top to bottom) | from |
|---|---|---|---|---|
| FIGHTER | 46 | 370 | round face pin 120 (Halo.cutout look, never a square); a red badge on the pin when she needs you; name on a navy label; weight class + age; style word + stance; record + the road line in gold | Roster, Faces, FighterProfile, BeltRoad / the rank a fight earned |
| OVERALL | 430 | 300 | a ring 0-100 with the number inside; five thin upright bars with their numbers: Head, Hands, Guard, Cardio, Legs (the five groups of FighterProfile); a gold dot under the group where she is the best of the roster; "Best move: <move> <mastery> <word>" | FighterProfile groups, MoveMastery |
| TIREDNESS | 744 | 120 | the number large, a bar with a tick at 80, one word (Fresh / Tired / "3 rest days") | the same read the fighter page uses |
| WEIGHT | 872 | 120 | kg large, a bar with the limit tick, "limit 65.0", or amber "0.9 kg over" ONLY when a weigh-in is coming | weight rules as the fighter page reads them |
| MOOD | 1002 | 120 | number, bar, word | mood as the fighter page reads it |
| COACH SAYS, THIS WEEK | 1132 | 310 | Coach's one change with its tag (FIX / REST / DRILL) and its weekly gain; under it the goal ring: goal, days left, status | CoachCheck / NextStep, FighterGoal |
| NEXT FIGHT | 1452 | 230 | days large + a tag (OFFER / BOOKED / OPEN), opponent name and record, date and answer-by; or "No bout" + when the next offers come | BoutRules / the offer the Fights page shows |
| DO NEXT | 1690 | 180 | ONE pin with its words: the single most urgent thing (a gold filled button when it stops the clock: Answer offer; else a round icon pin: Set a goal, Rest 3 days, Enter the open) | Needs (state/Needs.gd) in its own order |
A row that needs the player has the warm red-brown plate behind it (the first row in the painting); the others sit on
the slate with a thin line between rows. Click anywhere on a row = her page (as the table did); the DO NEXT pin does
its own action through `main.act` exactly as the same need does on Home.
Numbers are large (36 px or more), captions 18 px or more, nothing under 16 px (the operator: "fonts are small").
Every bar tweens to its value (MenuFx; the house rule "every bar tweens"). Words a player cannot act on go to the
hover, not the row.

## The job
1. `scripts/rules/RosterRow.gd` (pure, static): `row(c: Career, fighter_id) -> Dictionary` with one key a column,
   each holding plain values and words (no nodes), and `best_of(c) -> Dictionary` (group -> fighter id, the gold
   dot). It READS the same functions the fighter page and Home read today; where two screens could disagree, call the
   one function both use. `tests/roster_row_test.gd` FIRST, red on main: on the quick-start career and on a career
   with a booked bout, an open offer, a tired fighter (80+), an overweight fighter with a weigh-in in 3 days and one
   without, a met goal, and the no-gi athlete: each column's values equal what the fighter page's own read gives for
   the same fighter (assert against those functions, not against typed numbers); DO NEXT equals the first need
   `Needs` lists for her; "kg over" appears only with a weigh-in coming.
2. `scripts/ui/RosterRows.gd` builds the page part (header words + one row a fighter) from RosterRow.row;
   `RosterRowBits.gd` holds the small drawn pieces (the ring, the upright bar, the tick bar, the tag chip) so no file
   passes 500 lines. Use WoodKit / UI theme variations and Halo for the pin; no new colours outside UI.gd / WoodKit.
3. `Fighters._roster` shows RosterRows in place of RosterTable.build. Keep the tab's "Needs you" line and the fight
   card line only if they say something the rows do not (if a row now says it, remove the line and note it).
4. `tests/roster_rows_page_test.gd`: Main.tscn at 1920x1080, the Fighters area, Roster tab: one row a fighter of the
   career; every column of every row holds a non-empty value; no Control ends past x 1920; no font under 16;
   `SlateWalk.faults(page)` is empty; clicking a row opens that fighter's page; the DO NEXT pin of a fighter with an
   open offer opens the offer.
5. The still: `python tools/hidden_desktop.py run --timeout=180 <godot.exe> --path . --windowed --resolution
   1920x1080 --script res://tools/layout_snapshot.gd -- ops/previews/pages2` (through godot_slot; it writes
   `*_real.png`). Name the Fighters still in docs/PAGES2_RESULT.md with the list of what the painting shows that
   today's game cannot fill, each with the reason.

## Not in this task (the painting shows them; today's game does not have them)
The tabs "All four / Club week / Compare two / Find a fighter" and the THIS WEEK strip (they come with the club week);
the role word, loyalty and hype (their maps are not built); four fighters at the start (FOURSTART1). Keep today's
tabs. Show a column's real value or leave the cell's second line empty: never a made-up word or a placeholder.

## Traps
- ops/research/GDSCRIPT_TRAPS.md first (Variant `:=`, `%%`, Label sizing: set custom_minimum_size and autowrap
  before trusting a width).
- Words: "Cardio" never "Engine"; say what a number does; staff by role ("Coach"); no pronoun for a fighter in a
  built string (no_pronoun_test).
- New features ship ON: no switch, no opt-in flag.
- A test that only your own function can pass is not a test (S420): step 1 asserts against the page the player
  already has.
- The S400 lesson: build the painting, do not invent a layout. If a cell does not fit its width, shorten the hover's
  share, not the font.

## Prior research
ops/research/CORE_LOOP_MAP_S432.md section 3; docs/mockups/s431/final/squad.html; docs/STRUCTURE_DESIGN_S395.md 5.4
(the table this replaces); ops/research/CRITIC_PACK.md.

## What would a human do?
A manager opens the squad page to answer one question a fighter: is she fine, and what does she need from me this
week. Each row answers it left to right: who, how good, how she is today, what Coach wants, what is coming, the one
thing to press.

## Prefab check
RosterTable.rows already gathers most cells; FighterTile / FighterCard draw the face and bars; NeedRing, StatBar and
Halo exist. Reuse them before drawing anything new.

Every Godot job through the queue: `python ops/Tools/godot_slot.py run --who cursor -- <godot.exe> --headless
--audio-driver Dummy --path . --script res://tests/roster_row_test.gd` (the plain win64 exe, never the console one).
Parse first: `--check-only` on each touched file. Under 500 lines a script.
RESULT lines for the PR body: `RESULT: tests/roster_row_test.gd -> ROSTER_ROW failures=0` and
`RESULT: tests/roster_rows_page_test.gd -> ROSTER_ROWS_PAGE failures=0`.
