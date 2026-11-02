# R33 — THE BOOKING (digest)

Stage R33, greenlit 2026-09-06 after C18. Two halves: `FightContractScreen.gd`
— the **last pre-kit screen in the game** — rebuilt on `UIKit` + `UITokens`,
and the graded BOARD it was missing, now SCHEDULE's OFFERS tab. Codex C19 and
Kalli K20 both landed inside the stage and are both applied.
Renders: `DesignLibrary/screens/booking/{board,terms,clauses,countered,walked,plan}.png`
by `Godot/tools/render_booking.gd`; kit book 304 variants across 24 families.

## What shipped

- **The palette is dead.** `C_BG`, `C_PANEL`, `C_PAPER`, `C_LINE`, `C_TEXT`,
  `C_MUTED`, `C_ACID`, `C_AMBER`, `C_RED`, `C_GREEN` and the three raw font
  preloads are gone; every colour, font and size comes from `UITokens`.
  `ManagementChrome` and its BACK-button hijack are gone with them.
  `FightCampPanel.gd` (536 lines) is now the only file left in the game that
  mints its own palette — its own later stage, out of R33's scope.
- **It is a set-piece, not a document under a management header.**
  `UIKit.setpiece_chrome()`: WAY OUT top left (ESC now closes too), the
  promoter and venue as the eyebrow, BOUT AGREEMENT as the stakes, the
  negotiation round as the clock, the two fighters right. The route is
  unchanged — `ScheduleHubPanel._on_book()` still mounts it as
  `FightContractOverlay` over the board, over a scrim.
- **Left: THE AGREEMENT.** The same fourteen clauses in the same four
  groups, on kit rows with `chevron_header` group titles. Read-only clauses
  ("fixed by the card") simply carry no control.
- **Right, new: THE PROPOSITION / THE GATE / THE PACKAGE / THE PROMOTER.**
  THE GATE surfaces the number that was invisible before — the gate the
  points clause takes a slice of — and it is `terms["gate_estimate"]`, the
  same value `FightContract.clause_cost()` prices against. One number, not
  two. THE PACKAGE adds up exactly what `package_value()` adds up. THE
  PROMOTER carries the counter, the objection or the walk-away and how many
  rounds of talking are left.
- **The readouts follow the fields live.** Moving a figure or flipping a
  clause re-prices THE GATE, THE PACKAGE and the foot's clause line at once
  (`_refresh_readouts()`), so a clause is never priced against a stale gate.
- **Toggles are buttons, not CheckBoxes,** and say which way they are set in
  words as well as fill: GUARANTEED / NOT GUARANTEED, REMATCH GUARANTEED /
  NO REMATCH, PROMOTER COVERS / NOT COVERED. An unchecked CheckBox indicator
  is invisible on this ground.
- **Gold is spent once per board:** ACCEPT AS OFFERED on the terms page (the
  chrome passes `gold: "none"`), the agreed package on the plan page's clock.
- Fixed on the way past, all found by looking at the renders:
  - three clause notes carried literal `%%` (plain strings, never
    `%`-formatted, so they rendered as "15%%");
  - the catchweight note read "0 fights at the billed class";
  - **the money fields silently rounded the promoter to a multiple of 50.**
    `SpinBox.step` was 50, so a counter of $625 displayed as $650 and the
    screen misreported the promoter's own position. Money fields now hold any
    integer (`step` 1) and move by 50 on the arrows (`custom_arrow_step`).
    The percent field keeps step 10 — there the step is a real rule.

## THE BOARD (K20's ruling, built)

K20 ruled the board is **not** a new rail item and the agreement is **not**
another tab: SCHEDULE owns a third tab, OFFERS, because booking is weekly desk
work beside dated cards; the AGREEMENT stays a set-piece over it because a
negotiation needs isolation and a counter must feel like a deal, not a tab flip.

- `ScheduleHubPanel` gains OFFERS: it reads `get_booking_board("")` once per
  rebuild for the whole roster and grades nothing itself. Rows are best-verdict
  first (C19 sorts); the bar carries the selected row's fighter, tier and
  verdict line, and its one gold — OPEN AGREEMENT on a TAKE IT row. A blocked
  row says why in C19's words and the button is simply off.
- `BOOK SELECTED` on THE CARDS and `OPEN AGREEMENT` on OFFERS now share one
  mount, `_open_agreement()`. The old route is unchanged.

## The kit family (K20 section E, all eight named instruments)

`UIKit`'s new **THE BOOKING** family: `verdict_chip` (C19's five words —
K19 already ruled letter grades out), `reason_chip` (tone good/warn/bad/flat),
`gate_estimate_pair`, `nego_round_pips` (1/4 … FINAL), `counter_strip`
(headline + money delta + the promoter's own sentence), `walk_away_stamp` (BAD
semantic, never gold), `booking_offer_row`, and the `booking_chip` primitive
they share. 20 variants in the kit book; `booking_chip` is declared a helper.

These chips **measure** their text with `Font.get_string_size` instead of
estimating it from a character count the way `chip()` does, and clip what is
left over: a booking reason is long enough that the estimate overruns its own
fill and lands on the next chip. The row also bounds its reason strip between
the money and the gate — a chip that will not fit is counted, not squeezed in.

## What K20 changed on the AGREEMENT

A change list, not a rebuild — the layout held.

- **The gold moved to PROPOSE TERMS.** ACCEPT AS OFFERED is slate; walk-away is
  never gold. (The board spends its own gold on OPEN.)
- **Round pips** replace the "N of 4 rounds left" sentence, and the last pip is
  FINAL because `MAX_ROUNDS` is where the promoter stops.
- **One counter strip** carries the headline, how far the package moved
  (`+$215`) and `counter_reason()`'s sentence — with the duplicated
  "PROMOTER COUNTER:" prefix trimmed so it is said once. A walk-away swaps it
  for the stamp.
- **Three reason chips, then "+N MORE"**, and a chip that only repeats the
  verdict line never takes one of the three.
- **Pair blocks are slate**, TOTAL PACKAGE included.
- Kept, because K20 kept them: the BOUT AGREEMENT title and document rhythm,
  the fight-plan picker *after* accept, C19's verdict words, and the gate on
  both surfaces.

## What did NOT change

`FightContract.gd` is untouched — `opening_terms` → `evaluate_proposal` →
accepted / countered / walked away, the ceiling, the walk-away ratio,
`MAX_ROUNDS`. `get_fight_offers()`'s generation rules are untouched. Weight
class and sex matchmaking still hold and are **never** shown as advice: they
are rules, enforced in generation. The mandatory fight plan is still the only
path to a booked bout (`sign_fight_contract()`).

## C19 arrived mid-stage

Codex's `get_booking_board()` appeared in the shared working tree, uncommitted,
while R33 was rendering — Codex pushes its own deliverables, so
`GameState.gd` and `booking_board_api_test.gd` are NOT in R33's commit. The
splice needed no code: THE PROPOSITION started printing verdicts, verdict lines
and reason chips the moment the method existed, and the walk-away re-grades to
LOCKED on the spot (`walked.png`). Codex's snapshot-and-restore of `career`
around the read answers hazard 1 cleanly. Two notes went to it by mailbox:
`_booking_offer_fits()` demands exact weight-class equality, so an EVENT OPEN
SLOT never reaches the board for a fighter `get_booking_class_check()` accepts
(the promoter re-pairs within the fighter's class); and `blocked_reason` is
emitted into `reasons[]` and `verdict_line` as well, so a blocked offer said the
same sentence three times — the screen now drops a chip that repeats the verdict
line and truncates one past 34 characters, because `UIKit.chip` sizes its fill
from a character estimate a long string overruns.

## Open, and how it lands

- **C19 (Codex) is not committed yet.** `_booking_entry()` is the one private read
  — `get_booking_board(athlete_id)`, once per rebuild, entry matched by offer
  id, the way `ProfileRevampPanel` reads `get_fighter_card()`. There was no
  body to swap. Without the method it says NOT GRADED rather than inventing a
  grade. Verdict → chip: TAKE IT gym, RISKY amber, TRAP bad, everything else
  standard; reason tone good/warn/bad/flat likewise.
- **Kit gap still open:** the kit has no editable money / points / percent
  field and no toggle row, and K20 did not name one. `_spin()`, `_toggle_box()`
  and `_clause_row()` stay local to the screen, styled from `UITokens` only —
  they mint no colour. They promote into `UIKit` the day a second screen needs
  an editable figure.
- **Not built, and out of scope:** K20's STATES board sketches short-notice,
  grudge and title dressings on a row. C19 already emits those as reasons, so
  they arrive as chips today; a dedicated dressing is a later pass.

## Tests

`fight_contract_screen_test.gd` 17/17, then `contract_negotiation_test`,
`contract_clauses_test`, `fight_contract_test`,
`booking_eligibility_visibility_test`, `organization_fight_offer_test`,
`schedule_hub_panel_test`, `booking_board_api_test`, `ui_kit_book_test` — all
rc=0. The kit book was re-rendered (`tools/render_kit.gd`, windowed) and
rebuilt (`DesignLibrary/build_kit_book.py`) so the parity check passes with the
new family. Full suite green before the commit.

```
Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tests/fight_contract_screen_test.gd
```
