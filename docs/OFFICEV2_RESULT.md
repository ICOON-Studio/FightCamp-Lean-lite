# OFFICEV2 - the office Goals panel and the Fighters / Staff sheets (S538)

Owner: Q-S294-302 (a goals view in the dashboard; fighters and coaches as sheets with right-click actions), Q-S294-304
"Yes, build them", C475 "tooltip on goals give some tips". Spec: ops/previews/s538_look/office_goals.png,
office_sheets.png, office_sheets_menu.png.

## What is in the game now
- GOALS panel, middle row of the office dashboard. Left: the club's dated things, soonest first, with the days left
  (open bout offers, booked bouts, the month bill, nationals entries, an entered no-gi open, the club show). Right: one
  row a fighter - what he wants, how far (bar + chip), by when, what a miss costs.
- Each goal row's tooltip is a tip read from the career: the targets with their numbers and weekly pace, and the one
  thing to do this week (for example "Ask for a bout before Mon 2 Feb: the Fights page."). A click on a row opens the
  page behind it; a goal talk that is waiting opens the talk.
- The big fighter cards are now a strip of chips (face, class, flag, Stamina, Mood); the staff strip sits beside it.
- The Fighters and Staff icons open two sheets inside the desktop (the route stays the office). A click on a heading
  sorts, a second click turns it round. "Columns" ticks columns on and off (12 of 16 shown for fighters at the start);
  the sheet remembers while the game runs. The test club fills both.
- Right-click on a row opens a menu of acts the game already has, each run through the same Main.act / nav the game's
  own screens use. A line that cannot be done today is grey and says why (for example "needs 5 bouts (has 4)").
  Fighters: see the bout offer, fighter page, fight plan, this week's training, goal talk, watch the tape, enter the
  nationals, change the stipend, study the opponent, hear the pro offer. Staff: hire, let go (jobs that have it),
  evening coach add / cut, open the staff page.

## Left out (the mockup marks them NEEDS BUILDING) - the next ask
- "Release from the club" for a fighter: the game has no such act.
- "Let go" for the club coach: the game has no such act (the staff jobs and the evening coaches have one).
- The reasons behind a mood (the game keeps one number) and a by-date for the belt: not drawn.

## Found and fixed while finishing
- A goal row's bar and by-date never showed: Dictionary.merge kept the row's defaults (-1). Now overwritten.
- On a CRLF checkout a two-line roster cell kept a "\r", which made the no-gi row taller. The sheet strips it.
- The dashboard ran 40 px past the screen with the new row: calendar cells 54 -> 46 px, staff lines cut at two lines.

## Evidence
Tests (headless): OFFICE_GOALS failures=0, OFFICE_SHEET failures=0, OFFICE_DESK failures=0, OFFICE_SCREEN failures=0,
GYM_HUB failures=0, GOLDEN_PATH failures=0, MENU_MONEY failures=0, MONEY_SLATE failures=0.
Stills from the real game, test club, hidden desktop (tools/officev2_still.gd): docs/previews/officev2/
office_goals_real.png, office_goals_tip_real.png, office_sheets_real.png, office_sheets_columns_real.png,
office_sheets_menu_real.png, office_staff_menu_real.png.

## Differs from the mockup
- The mockup's numbers were a week-6 club; the stills are the test club on day 12, so no offer or bout is pending.
- Coaches have no portraits in the game yet: the sheet shows the coach icon (the head coach has his picture).
- A coach for hire reads "Place taken" while the club coach's place is filled.
