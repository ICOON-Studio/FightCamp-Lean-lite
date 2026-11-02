# TASK OFFERS_CARD_M42 - rebuild the Schedule OFFERS rows as Maria's offer_row cards

Model: Arena (free coding worker). Owner branch: arena/<chat-id>-fightcamp. Tier: script edited -> parse gate + the focused test + neighbours.
Operator (S169): the Schedule OFFERS table "looks like 2004". Spec of record: `research/M42_HUB_MOCKUPS_FULL.md` section 2.4
(lines 106-129). Current look: `previews/s170_offers4/24_offers_signed.png` (a 66 px strip + a 30 px "MatchupStrip" of metrics,
all caps, tiny).

## Prior research
`python Tools/prior_research.py offer_row` - M42 2.4 (spec), G154 (offer desk), Q219 (pro verdict chip), U4 (amateur row). The Fight Business demo
walk (`S170_FIGHT_BUSINESS_WALK.md`) shows a plain table; we want a CARD, not a table.

## What would a human do?
Read one card top to bottom: WHO (name, record, division) -> is it a fair fight (one plain sentence) -> WHAT I GET (purse) -> WHEN/WHERE -> a big
Accept. The grade chip (EVEN / STEP UP / ...) stays the first thing the eye lands on.

## Prefab check
Reuse UIKit primitives only (`UIKit.block`, `chip`, `caps`, `display`, `button`, `tip`). No new theme token, no new art.

## Owned files
- `Godot/scripts/ScheduleHubPanel.gd` (~4,000 lines; NEVER read whole). Windows: `_amateur_row` 2326-2400, `_wrap_fight_card` 1971-2005,
  OFFERS builder 1470-1533 (`booking_offer_row` call at 1531), `_place_fight_metrics` ~1900-1968.
- `Godot/scripts/UIKit.gd` `booking_offer_row` 4790-4884 (pro offers).
- New test `Godot/tests/offer_card_test.gd`.

## Build
One card per offer, 120-168 px tall, same node NAMES kept where tests read them (`AmateurOfferRow%d`, `Pairing`, `Verdict`, `FightRead`,
`MatchupStrip`, `Hit` - grep `Godot/tests` first; keep them or update that test in the same commit with the reason).
Fields (M42 2.4): opponent display name large; `record - division - tier` meta line; the match-up sentence (`_matchup_line`) as body text;
PURSE eyebrow + amount (amateur: `NO PURSE` stays honest); date/weeks-out + venue; primary ACCEPT-style open button top-right, the existing
select flow (`_on_amateur_row` / `_on_offer_row`) stays the press. First card one surface level up. Win-chance, stance, weeks metrics from
`_place_fight_metrics` move INTO the card as a right-hand column - do not drop any of them.
Empty state unchanged. A gate/blocked reason is still drawn and named, never hidden.

## Acceptance (the one test)
`offer_card_test.gd`: build the panel with a hand-made amateur entry and a hand-made pro offer (no autoload, no LFS model); assert (a) every
offer card is >= 110 px tall and its children stay inside the card rect, (b) the opponent name, the sentence and the purse text are present,
(c) the grade chip text is unchanged, (d) pressing the card sets `selected_offer`. Run:
`Godot_v4.7.2-stable_win64.exe --headless --path Godot --script tests/offer_card_test.gd` (NOT `_console.exe`).
Neighbours that MUST stay green: `python Godot/tools/run_tests.py --only schedule --jobs 2`, `--only amateur`, `--only booking`, `--only fight_card`.

## The one trap
Many tests find nodes by name and by the 66 px row height; changing the height without grepping `Godot/tests` for `AmateurOfferRow`,
`BookingOfferRow`, `FightRead`, `66.0` turns neighbours red. Do not delete or weaken a test to go green (CI guard fails gutted tests).
