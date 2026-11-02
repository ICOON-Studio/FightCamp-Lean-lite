# R69 — THE BELT SAYS WHOSE IT IS (Claude, 2026-09-08)

R68 gave every belt a sanctioning promotion and exactly one surface read it.
Two things were still unsaid, and one of them was a read that shipped with no
caller at all.

## 1. Why `get_bout_title_stakes()` never had a caller

C41's problem again, but with a cause worth recording. The read needs an event
**and a bout index**; a booked offer id carries only `event|<event_id>`; and
**nothing in the game could turn one into the other.** The read was not
forgotten — it was unreachable.

Two resolvers close that, and neither invents a rule:

- `get_booked_bout_index(event_id, athlete_id)` searches the event's own bouts
  for the fighter rather than trusting a stored slot number, because a
  short-notice replacement moves people between slots after booking.
- `get_open_slot_bout_index(event_id)` answers the other half: a fighter
  negotiating a bout agreement is **not on the card yet**, so the booked
  resolver cannot find them. The slot they are being offered is the one the
  event already flags `open_slot` — the same flag the booking board and the
  intelligence report read.

On top of them, two screen-facing reads: `get_booked_bout_stakes(athlete_id)`
and `get_offer_bout_stakes(offer_id)`. Both answer `{}` rather than a blank row
when the bout is not on a world event.

## 2. The card names the belt

`get_athlete_titles()` already handed back R68's raw `organization_id`. The
**card** resolves it into the name, tier and standing a screen prints, and adds
the division label beside it.

It is done there and **not in the accessor on purpose**: `get_athlete_titles()`
is called once per roster fighter by ambitions, by the retention request scan
and by the superfight sweep, and none of them wants a sorted promotions table
built per call. The card pays for it once, on the one read that draws it.

## 3. Four surfaces say it

- **The identity strip** reads `ONE CHAMPION`, not `CHAMPION` into the air. A
  double champion holding two promotions' belts stays plain `CHAMPION` —
  naming one would be picking a favourite the fighter has not — and a belt
  whose promotion is unknown never invents one.
- **The career timeline** belt event carries the promotion: `ONE LIGHTWEIGHT
  BELT`.
- **The NEXT BOUT card** leads with `TITLE BOUT · <division>`, or
  `INTERIM TITLE`, or `UNIFICATION`.
- **The bout agreement** appends the same to its `VS …` line. That is distinct
  from the TITLE-SHOT GUARANTEE clause beside it, which promises a *future*
  shot; this says the belt is on *this* card.

## 4. The trap, asserted six ways

`is_title_bout` is **null** for a bout nobody stamped either way, and null is
"not decided yet", never "no". A screen that prints NOT A TITLE FIGHT on a null
has invented the answer C26 deliberately refused to give. Both `_stakes_words()`
(profile) and `_stakes_line()` (agreement) return the empty string for null and
for false alike, and the caller draws nothing. Asserted for `{}`, for null, for
false, and for each of the three true shapes.

## 5. Part 3 moved to U11

`PromotionsBoard.sort_by_standing_in_sport()` (R50) and
`WorldPopulation.promotions_by_standing()` (R68) are two answers to "which
promotion is bigger" and both are live. **Both task files claimed the fix and
only one owns the file it lives in** — the duplicate is inside
`PromotionsBoard.gd`, which is Cursor's under U11. Two agents editing one file
to agree on one order is the collision, not the fix. `TASK_R69.md` records the
move and Cursor was mailed.

## Verification

Parse gate 8/8. `championship_read_test` **21 checks** (8 before R68, 14 after
it), `profile_revamp_test` 0 failures with nine new assertions,
`fight_contract_screen_test` 0 failures, `contract_negotiation_test` and
`booking_board_api_test` unchanged and green. Full suite run once before the
commit.

**One test bug worth recording, because it looked like a code bug.** The first
profile assertion failed with `CHAMPION` where `ONE CHAMPION` was expected. The
engine was correct throughout: by that point in `profile_revamp_test` the
fighter it starts with has left the roster, so `get_athlete(id)` returned `{}`
and the panel was set up with an empty athlete, which reads an empty card. The
fix was in the test — take a live roster fighter — not in the read. A diagnostic
message that printed what it actually saw found it in one run; the guessing
before that found nothing.

`Godot/tests/fight_contract_screen_test.gd` was added to R69's owned files: the
production half was already owned, and shipping a changed screen with an
ungated test would have been the smaller of two sloppinesses.
