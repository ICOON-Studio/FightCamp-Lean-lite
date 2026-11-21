# OFFERBUILD1 - result (S535, owner Q-S294-296 "Yes, build it")

Brief: `ops/research/TASK_OFFERBUILD1.md`. Spec: the approved mockup `ops/previews/s535_offer_mockup/offer.png`
(owner C448 "this looks too much like the tale of tape, maybe change it ?"). Prior research read: `docs/OFFERTAPE1_RESULT.md`
part 2, memory notes names-only-in-headers (S448), only-actionable-info (S398), screen-logic-of-the-moment (S439),
tooltips-explain (S532).

## What is built
A bout offer now opens as the host club's letter instead of the versus card with the tale of the tape.
- Centre, on paper: the club's crest and name, "Bout offer", the matchmaker's line, The night, Time to prepare, To the club,
  Sanction, IF YOUR BOXER WINS / LOSES, the reply line and the answer-by stamp.
- Left: our boxer (painted body on the club crest, record, Last 5, streak, shape and mood, on the scale, what a pass costs).
- Right: the coach's read (verdict, win chance with its range on a bar, gain, risk, how sure) and the opponent (painted
  body, Last 5, streak, style, best punch or "not on tape", WHAT DECIDES IT: record, reach, experience, the scouting line).
- Under the letter: Pass (its cost), Full report, Accept the bout (date and money). Full report is the old report page
  (matchup, win chance and ranks, scouting file, terms); its button back now reads "Back to the offer".

## Where each number comes from (nothing typed in)
| On screen | Source |
|---|---|
| The night, answer-by stamp, days left, "Reply by <weekday>" | the offer's own `day` / `expires`, `Clock.fmt` |
| Time to prepare | the offer's day less today |
| $450 ticket cut | `BoutRules.TICKET_CUT` |
| Sanction word and "4 bouts against 6" | the offer's `mismatch`, `own_bouts`, `their_bouts`, `AmateurBooking.NOVICE_MAX_BOUTS`; weight from `Sim.weigh_forecast` |
| Ladder place after a win / a loss | `BoutRead.rank_move` on `Region.rankings` |
| Members, record, loyalty after a win / a loss | `BoutRules.WIN_MEMBERS` / `LOSS_MEMBERS` / `STOPPED_LOSS_MEMBERS`, the boxer's record, `Loyalty.move_for` (a Loyal boxer's halved losses included) |
| Last 5 and streak, both corners; record and reach | `TapeForm` + `TapeRows` (read on copies: the page changes nothing in the career) |
| Shape and mood | `FighterProfile.fatigue` / `mood`, the words fight night uses |
| On the scale | `Sim.weigh_forecast` |
| What a pass costs | `Bouts.pass_price` |
| Verdict, gain, risk, how sure | `CoachRead.read(CoachReadWire.facts)`, the same read as the offer card |
| Win chance, its range, "a rough guess" | `BoutCompare.win_read` |
| Best punch | the opponent's file: shown only once tape has found it (`OppFile.known`), else "not on tape" |
| Scouting n of m | `BoutRead.stage` |

## Differences from the mockup, on purpose
- No "Sent Mon 12 Jan" on the letter head: an offer keeps no sent day, and nothing is typed in.
- The coach's words are the game's own (`CoachRead`): on the still the same offer reads "Too soon", 30%, because the real
  numbers say so; the mockup's "A step up" and 43% were sample values.
- An unsafe pair keeps the letter: Sanction reads "Not safe" with the reason, Accept is off, Pass costs nothing. The
  win and loss boxes still describe the bout as if it were sanctioned (not changed: the mockup did not cover it).

## Files
- New: `scripts/ui/OfferLetter.gd` (385 lines: the page, the letter, the answer row), `scripts/ui/OfferSides.gd` (399: the
  three slates), `tests/bout_offer_letter_test.gd`. The brief allowed splitting the page into parts.
- `scripts/ui/areas/BoutPage.gd` (169): the offer's first screen is `OfferLetter.build`; the report body is unchanged.
- Three older tests looked for the versus card on the offer and were moved to the letter (outside the brief's OWNS list,
  needed to keep them honest): `tests/versus_test.gd`, `tests/p4p_coach_read_test.gd` (one check), `tests/camp_slate_test.gd`
  (the offer half walks the read's slate). `VersusPanel` stays: fight night's tape and the report switch still use it.

## Tests (headless, through the Godot queue)
- Red first, on the untouched BoutPage: `bout_offer_letter_test` rc 1, "FAIL: the offer opens on the letter page".
- Green after: bout_offer_letter_test 0 failures (83 checks: every section, the old table gone, each number against its
  source, "not on tape", names only in the headers, no tooltip repeating its label, the page inside 1920x1080, Full report
  and back, an unsafe pair, Accept books), versus_test 0, p4p_coach_read_test 0, camp_slate_test 0, tape_rows_test 0,
  tape_form_test 0, offer_gone_test 0, palette_guard_test (new raw colours 0), golden_path_test 0.

## Still (hidden desktop, the real flow, `layout_snapshot.gd only=12_bout,11_bout_unsafe noguide`)
- `ops/previews/s535_offer_mockup/built/12_bout_real.png` beside `ops/previews/s535_offer_mockup/offer.png`; the unsafe
  pair: `built/11_bout_unsafe_real.png`. Opened and compared: same layout, words and look.
- Not checked on a picture: the Largest text size, and an offer where the weight is at risk (covered by code only).
