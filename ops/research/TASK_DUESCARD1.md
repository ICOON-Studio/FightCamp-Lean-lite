# TASK DUESCARD1 - CURSOR (Grok 4.7 High) - the dues choice as three painted price boards on Club > Money

Status: OPEN (S424, Claude main). Discipline: boxing. Model: grok-4.7-high.
Source: the operator on the board. Q-S294-176: "ok for the mechanism but the design needs better presentation". Q-S294-177
(the painted concept): "Yes, build it".

## The picture (the bar)
docs/mockups/s424/dues_painted_v4.png (Ludo's paint of the approved layout; every number on it is right). Build note from
Claude, given to him with the question: the painted people go ABOVE the numbers (as in try 1, top left of
docs/mockups/s424/dues_painted_four.jpg), so the numbers stay clear. Small text on the paint is garbled: the words are below.
Cursor cannot see images: Claude checks the stills. Build from the description here; open the PNG only for proportions.

## Contract
OWNS: scripts/ui/MoneyPanels.gd, scripts/ui/DuesBoards.gd, scripts/rules/Membership.gd, scripts/state/GymSpend.gd, scripts/state/Career.gd, tests/dues_card_test.gd
(DuesBoards.gd and the test are new. MoneyPanels.gd 333 lines: `_dues` (line ~190) calls DuesBoards.build and nothing else.
GymSpend.gd 385: only set_dues (line ~221) and end_week (line ~374). Career.gd 185: one exported field.)
RED_TEST: tests/dues_card_test.gd -> DUES_CARD failures=0
REGRESSION: money_slate_test, menu_money_test, money_close_test, gym_spend_test, membership_test, save_load_test, golden_path_test, words_on_screens_test, file_limits_test
VISUAL: Claude renders Club > Money on the hidden desktop after the merge. Do not render.

## What to build
1. Membership.gd: `static func band_preview(reputation: int, cap: int, band: String, draw_mult: float, youth_on: bool) -> Dictionary`
   -> {"members": mini(roundi(natural_members(reputation, band) * draw_mult), cap), "month": members * fee(band),
   "home_5y": 10.0 * intake_chance(band) if youth_on else 0.0}. Pure. (Two intakes a year, five years.)
2. DuesBoards.gd (new, under 250 lines): `static func build(main, c: Career) -> Control`: three boards side by side, Cheap,
   Standard, Premium (Membership.DUES_ORDER). Each board: the wood frame + slate of the shared theme (WoodKit.gd, the same
   pieces the Overview's panels use), and from top to bottom:
   - the band name (big) and "$25 a month" (the fee);
   - the painting: assets/ui/dues/dues_cheap.jpg / dues_standard.jpg / dues_premium.jpg (768 px squares; show the middle
     band of the picture, about 16:7, cover-cropped, never stretched);
   - three rows, icon + number + a two-word caption: money a month ($ icon), members (people icon), home-grown boxers in
     5 years (glove icon, one decimal). Numbers from band_preview with the career's reputation, GymSpend.member_cap(c),
     GymBonus.members(c.gym_plan) and the youth section's state. Colour each number against the band in force: green
     better, red worse, words colour the same. With no youth section the boxers row reads "needs a youth section", greyed.
   - the band in force: a gold frame and a brass plate "IN FORCE" at the board's foot. A band chosen for next month (see 3):
     a paper tag "From next month" pinned at the top corner.
   - the explanation lives in the tooltip only (his rule: no explaining words on the face): e.g. Premium: "Adults who come
     for fitness. +$130 a month, 1 in 5 junior trials pass (now 1 in 3). From next month; members leave over 4 weeks." -
     built from the numbers, never typed.
   - when the place is full, the Cheap board's members row says "the place is full" in red (today's rule, kept).
3. A change takes effect next month: Career gets `@export var dues_band_next: String = ""`. Clicking a board that is not in
   force asks once ("Change dues to Cheap from next month?" Yes / No, the game's own confirm), then sets dues_band_next and
   adds the news line. GymSpend.end_week: on the first week of a new month (use the month GymBills already counts), if
   dues_band_next is set, call set_dues with it and clear it. Clicking the band in force clears a pending change. A save
   without the field loads as "" (save_load_test).
4. The board row replaces today's three buttons in `_dues`; the board's name stays "DuesBoard" and each board is named
   "Dues_<band>" (tests and GymActs read those names; keep `main.act("dues", band)` as the click path, now via the confirm).

## tests/dues_card_test.gd (red on main)
Builds a career (TestJump or Career.new as money_slate_test does), opens Club > Money, then checks: three boards named
Dues_cheap/standard/premium; each shows its fee, members, money and boxers numbers equal to band_preview; the IN FORCE
plate is on the band in force only; a click on another band + Yes sets dues_band_next, not dues_band; four end_weeks later
(across a month turn) dues_band is the new band and dues_band_next is ""; no explanation words on the face (every Label
under 40 characters except the tooltip); each painting's TextureRect has a texture. Prove each check red on main first.

## Prior research
ops/research/DUES_DESIGN_MAP_S423.md (the design and its S424 note), ops/research/DUES_CHOICE_S422.md, scripts/ui/WoodKit.gd,
scripts/ui/MoneyPanels.gd `_chalk` / `_dues`, tests/money_slate_test.gd, ops/research/GDSCRIPT_TRAPS.md.

## What would a human do?
Walk into a boxing club and read the price boards on the wall: the price, who trains at it, what it brings.

## Prefab check
None: our own theme pieces and Ludo's three paintings (assets/ui/dues, S424).

## Rules
Godot only through `python ops/Tools/godot_slot.py run --who cursor -- <godot.exe> --headless --audio-driver Dummy --path . --script <script>`.
No file over 500 lines. Never "he" or "she" in text. New features ship ON (no switch). Do not change the dues numbers.

## The one trap
The 5-year money balance between the bands is known to be off (premium earns most in every case; branch claude/duesband1).
Show the true numbers; do not tune anything to make a board look better.

## Result lines (PR body)
RESULT: tests/dues_card_test.gd -> DUES_CARD failures=0
RESULT: tests/money_slate_test.gd -> the test's own pass line
RESULT: tests/save_load_test.gd -> the test's own pass line
