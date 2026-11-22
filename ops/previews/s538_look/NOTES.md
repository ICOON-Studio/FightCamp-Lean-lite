# LOOKMOCK538 - three mockups for the owner's look (S538)

Owner, verbatim: "the result page needs more graphics,use tooltips/modals to shorten things"; "the office needs a something
like a goals tab to see what is pending what each fighter wants , probably fit it in the dashboard"; "also maybe the fighters
and coaches screens inside the desktop , could they be like excel sheets and when plqayer right clicks on a name can do
various actions".

Mockups only: nothing under scripts/ changed. Each page is 1920x1080 HTML rendered with `python tools/render_mockup.py`.
The numbers on the result page are the real page's (ops/previews/p4pbuild1/21_result_real.png). The office numbers are
EXAMPLE values for the test club (the test club was not run for these pictures); the source column says which function
gives each number in the game.

Files: `look.css` (Palette.gd colours, the game's fonts), `office.css` + `frame.js` (the office desktop's frame),
`result_v2.html/.png`, `result_v2_modal.html/.png` (the same page with the modal open), `office_goals.html/.png`,
`office_sheets.html/.png` (column chooser open), `office_sheets_menu.html/.png` (right-click menus open).

## 1. Result page v2 (result_v2.png, result_v2_modal.png)

No fact of today's page is dropped. What moved:

| Today | In v2 | Source |
|---|---|---|
| Two name cards, text only | Same cards with the boxers' portraits; the rank line gets a ladder icon | ResultPage.gd (header), Faces.stem |
| Judges: 3 rows of score boxes | Same boxes as one strip with ROUND 1/2/3/CARD headings and a colour key | ResultScorecard.gd (the judges' cards) |
| "Nothing in the plan for big loaded shots: lost 3 of 3." | Glove icon + headline "No answer for the big loaded shots" + three red pips "lost 3 of 3" | ResultCause.gd (the cause line) |
| Changes tried, the new line, two bars, "even fight" | Unchanged as a bar pair (the task says it already is one); the even-fight mark sits above | ResultCause.gd / FixLab (the 40-night test) |
| "Even the best plan only gets close... Training closes the rest." + "Measured: 40 more nights..." | TOOLTIP on the bars (drawn open) | ResultCause.gd |
| Three round cards: exchange boxes, "all 3 judges...", "Energy at the bell" | One ROUND BY ROUND card: each exchange a bar up (your boxer) or down (the opponent) sized by the margin, its score under it; three judge squares; two energy gauges | ResultTabs.gd / ResultScorecard.gd (exchanges, energy) |
| What it cost: three numbers, "Nothing lasting", "Took 64 punches, 21 to the body" | The body figure with hooked lines (the ResultMarks look): 43 to the head, 21 to the body, NOTHING LASTING; the three counters under it | ResultMarks.gd figure()/line(), BodyMap |
| Rank box "Unranked: 1 win from entering" | In the left name card and in the ladder tile | Region.our_rank |
| Bottom line of five numbers | Five icon tiles: ticket cut, ladder points, members, what it taught, host favour (two pips) | ResultPage.gd (the footer row) |
| "The plan's clue: The plan had double jab 6 times and it never got off..." | A sixth tile: six empty pips "Double jab: 0 of 6"; the sentence is in its tooltip and in the modal | ResultPage.gd (the clue line) |
| Buttons The plan, lit up / Back home | Same, plus "More: the whole read" | - |

Tooltip (one drawn open, on the plan-test bars): the two long sentences of the measured fix.
Every other tile, bar and round carries its own sentence the same way (stated on the page, not drawn).

Modal "THE WHOLE READ" (second still): every sentence of today's page, word for word, in five blocks - why it was lost
and the measured fix; the plan's clue; what it cost; rank and the club; the cards.

Two things to know:
- "43 to the head" is 64 punches taken minus 21 to the body. Today's page prints only 64 and 21; if the fight does not
  keep a head count, this number needs one line of code or the callout reads "64 punches, 21 to the body".
- Names appear only in the two header cards; the body says "your boxer" / "the opponent".

## 2. Office goals panel (office_goals.png)

The GOALS panel sits in the dashboard's middle row (not a new screen), gold edge, 1228 x 318.

What shrinks: the FIGHTERS panel. Its big picture cards become a strip of four chips in the bottom row (class, flag,
stamina, mood); the full list is the Fighters sheet (mockup 3). MONEY loses 27 px of height. STAFF moves beside the
fighter strip. NEEDS YOU, NEXT FOUR WEEKS and MAIL are as today.

Left half, THE CLUB, PENDING - dated things, soonest first, each with a countdown:

| Row | Source |
|---|---|
| Bout offer ends | OfficeDesk.calendar chip `offer_ends`; RosterRow._open_offer |
| Bills due (rent $1,800) | OfficeDesk.calendar chip `bills`; GymBills (rent) |
| Nationals entries close | OfficeDesk.calendar chip `champs`; Champs |
| No-gi open, entered | OfficeDesk.calendar chip `open`; the grappler's `entered` days |
| Bout + its fight week | OfficeDesk.calendar chips `bout`, `fight_week` |

NEEDS YOU stays the "act now" list (HomeNeeds.ranked, top 3); PENDING is everything with a date, acted on or not.

Right half, WHAT EACH FIGHTER WANTS - one row a fighter: portrait chip, the want, how far, by when, what a miss costs.

| Column | Source |
|---|---|
| Want (title) | FighterGoal.ARCHETYPES `title` through Sim.goal_read(c, f) |
| Target line ("stamina 63.9 / 65.9", "no bout") | FighterGoal.progress `per_target` lines (_format_target_line) |
| How far (bar, %) and ON TRACK / AT RISK | FighterGoal.progress `share_done`, `status`; card() |
| By (days left, date) | FighterGoal.card `days_left`; Clock.fmt |
| If missed "mood -20", met "mood +10" | FighterGoal.FAILURE_MORALE_DELTA / SUCCESS_MORALE_DELTA (outcome()) |
| "Promised: top of our show", by date | Promises.gd (kind `show_top`, `by_day`), open_for(list, fid) |
| "loyalty -12", kept "+10" | Promises.BROKEN / KEPT |
| "no goal set: goal talk waiting" | the fighter's `goal_talk` flag (RosterTable._boxer_cells), act `goaltalk` |
| The grappler: "Blue belt, 62%" | BeltRoad.next_belt, BeltRoad.readiness `share` |
| Fighter strip: flag, stamina, mood | OfficeDesk.fighter_cards (_boxer / _grappler) |

Would need building (said on the picture): the REASONS behind a mood - the game keeps one mood number
(FighterProfile.mood), no list of why; and a deadline for the belt (BeltRoad has none, so the row says "no date",
"nothing lost").

## 3. Office sheets (office_sheets.png, office_sheets_menu.png)

The Fighters and Staff icons open sheets inside the desktop: one row a person, click a heading to sort, a "Columns"
chooser on each header row (still 1 shows it open: 12 of 16 fighter columns on).

The game already has a sortable fighter table (RosterTable.gd: COLS, sort_col, _sort_by). The sheet is that table moved
into the desktop, plus three new things: more columns, the column chooser, the right-click menu.

Fighter columns and their source:

| Column | Source |
|---|---|
| Fighter (face, name, age, style) | RosterTable._boxer_cells `fighter`; Faces.stem; the fighter dict `age`, `style` |
| Class | fighter dict `wc`, `limit` (OfficeDesk._class_word) |
| Record | `w`, `l` (`pro_w`, `pro_l` once pro) |
| Rank | Region.our_rank; the grappler shows nothing |
| The road | NextStep.road; the grappler's belt |
| Next | fighter `bout` (opponent, day), RosterRow._open_offer; the grappler's `entered` |
| Weight | `weight` - `limit` |
| Condition | FighterProfile.fatigue -> WhiteboardKit.fatigue_word |
| Stamina | Attrs.of(f).stamina (grappler: stats.cardio) |
| Mood | FighterProfile.mood(morale) + the number |
| Goal | Sim.goal_read; BeltRoad for the grappler |
| Stipend | GymSpend (set_stipend / set_half); $250 is the decided amateur stipend |
| Off by default: Rating, Ready for the bout, Age, Style and stance | StatBlock.overall, CoachCheck.score, fighter dict |

Staff columns: name; job (Data.COACHES `kind`, StaffRoles.LIST `name`); status (hired / for hire / job open:
`c.coach`, `c.staff_roles`); pay (`salary`, StaffRoles `wage` / `per_bout`, GameMoney.COACH_SIGNING_FEE); runs
(OfficeDesk.staff `line`, the coach's `note`); the five coaching areas (Data.COACHES `areas`); what it changes
(StaffRoles `effect`). "How he fits each boxer" exists on the Staff page (StaffCard._boxer / _points) and is a hover here.

Right-click on a fighter (still 2) - every line is an action the game already has, and names the screen it opens:

| Menu line | Act (file) | Opens |
|---|---|---|
| See the bout offer | `openBout` (BoutActs) | Fights: the offer |
| Open the fighter page | `fighter` (Main) | Fighter |
| Fight plan | `plan` (RosterActs) | the plan board |
| This week's training | `weekplan` (BoutActs) | Training: the week |
| Goal talk | `goaltalk` (BoutActs) | the goal talk |
| Watch the tape | `taperoom` (RosterActs) | Fight analysis |
| Enter the nationals | `enterchamp` (BoutActs) | Nationals |
| Change the stipend | `stipend` (GymActs) | Finance: stipends |
| Study the opponent (grey: no bout booked) | `study` (BoutActs) | the opponent file |
| Hear the pro offer (grey: 7 wins and a top 3 rank) | `prooffer` (RosterActs), Roster.pro_ready | the pro offer |
| Release from the club | NEEDS BUILDING - no such act in the game | - |

Right-click on staff: Open the staff page (`go` staff), Evening classes on / off (`eveningcoach`, GymActs), How he fits
each boxer (Staff page card). On a job row: Hire (`hirerole`) and Let go (`letgorole`, a week's notice). On a coach for
hire: Hire (`hire`, $1,000 to sign). NEEDS BUILDING: letting the club coach go (no act found).

Not drawn, to check before a build: making a promise from the menu (Promises.gd has the rules; the screen that offers
one was not traced), and the walk-in / prospect rows (invite, trial, sign, pass - RosterActs has them all).

The two menus are drawn open together only for the picture; the game would open one at a time.
