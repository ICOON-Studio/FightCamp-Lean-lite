# P4PBUILD1 stage 3 - THE COACH'S READ (S533)

Design: ops/research/DESIGN_THREEP4P_V2.md section 2. Built ON (no switch). Started only after docs/TURNPRO6_RESULT.md was
on main (the win read it fixed is the range this read uses). The read changes no bout: it is words on what the game
already knows.

## What changed
- One read, one builder, on every screen an offer has: the amateur offer card, the bout's versus (short), the bout's
  report (whole), and each pro row (its own stakes). Before it sat on the list card only.
- The read is a decision, not an order: a booking block first (not safe; a weight that will be missed), then the strongest
  CHECKED gain and the strongest CHECKED cost. "No confirmed gain / cost" when there is none: no filler.
- Faults of the old read, fixed: the opponent's style was handed in and never used (now: where the opponent's game takes
  the bout, and whether the plan has a line there that is sharp enough to come off); a short rest or a heavy cut said
  "camp hard" (now: "Look for a later date", and a missed weight is never the pick); a goal's TITLE counted as progress
  (now: only a goal that still needs a bout, with its real days left); a higher-ranked name promised the ladder (now: only
  a place the table's own forecast gives, BoutRead.rank_move).
- How sure, 1 to 3: what is known, never a win chance (unknown game or a wide win range = 1; known game and a narrow
  range = 3). With no coach hired the same evidence reads "Your estimate".
- The three answers, each with its price in the game's own numbers (addendum, critic John):
  Accept (days to the bout, morale +5, the goal's bout booked, the no-bout count restarts), Pass (loyalty -3, a duck when
  it is one, the no-bout week count and its -3, the goal's days left), Later (pass, then ask for a show N days on; the
  rest gained; the other corner may say no; or "no later show can be asked for now"). One is marked as the pick.
- The read keeps a record: on Accept its one testable call rides on the bout (favoured / underdog / no call); the result
  settles it; the card shows "Read right N of the last M" from 3 resolved reads (15 kept). Draws, no-call bouts and old
  saves are never scored. The record lives on the coach: a new coach starts clean.
- Files: rules/CoachRead.gd (rewritten, pure), state/CoachReadWire.gd (new), ui/OfferCard.gd, ui/areas/BoutPage.gd,
  ui/ProFights.gd (one label a row), state/Bouts.gd (+1 line at accept), state/BoutFinish.gd (+1 line).

## Critics' lists: taken and refused
Taken: the booking block first; verified gain and cost with "no confirmed" instead of filler; evidence marks that are not
odds; the record with its denominator; later-date advice instead of camp-hard; every choice priced (John); the same read
on the bout page and the pro rows.
Refused or left: the debut house card (scripts/ui/modals/ProOffer.gd is TURNPRO6's file, and TURNPRO6 already put its
fixed read on that offer; a debut has no fixed opponent to read); a "Pass and ask for a later show" BUTTON (the ask door
opens only after the pass, and its answer is the other corner's: the read says how, the existing Ask screen does it);
clicking a reason to expand its inputs (the gain and cost lines already carry the number); John's "drop the marks" (the
design asks for them); a 60%-right balance target (needs a month replay, not a session test).

## Stills (hidden desktop, each opened)
- docs/playtest/S533/p4pbuild1/read_1_offer_card.png - Fights: the read on each offer card, the three priced answers, the pick in bold.
- docs/playtest/S533/p4pbuild1/read_2_versus.png - the bout's versus: the read in one line under Accept and Pass.
- docs/playtest/S533/p4pbuild1/read_3_report.png - the bout's report: the whole read in its own card.
- docs/playtest/S533/p4pbuild1/read_4_pro_rows.png - pro rows: each with its own read.
Seen and fixed while looking: an unsafe offer still listed a ladder gain; a 36% pro fight read "No confirmed cost".
Seen and left (not this task's files): the versus chip says "Legal, even match" on a bout the read calls a step up (-6).

## Tests (each through ops/Tools/godot_slot.py)
- coach_read_test -> COACH_READ failures=0
- p4p_coach_read_test (golden path on the real screens) -> P4P_COACH_READ failures=0
  real offer read: Coach: "Take it."  Gain: a win takes place 6 on the ladder.  Cost: the plan has no line for where the
  opponent takes the bout (mid range). | How sure: 1 of 3 (the win range is still wide) | Accept: a bout in 19 days;
  morale +5; the goal's bout is booked; the no-bout count restarts | Pass: loyalty -3; no bout booked: week 2 of 4, then
  loyalty -3; the goal still needs a bout, 21 days left | Later: pass, then ask for a show in 33 days on Fights; 14 more
  days of rest; the other corner may say no
  pro row: Coach: "Should win."  Gain: no place moves, +1 fan.  Cost: a 12% chance of being stopped.  How sure: 1 of 3 (not scouted).
- golden_path_test -> GOLDEN_PATH failures=0; save_load_test -> SAVE_LOAD checks=86 failures=0
- file_limits_test, tooltip_standard_test, no_pronoun_test, words_on_screens_test, plain_words_test, one_look_test,
  ask_wire_test, approach_wire_test, late_ask_test, offer_gone_test, rival_offer_wire_test, hot_streak_test,
  pro_ladder_test, pro_lean_test, pro_read_test, first_hour_walk_test, p4p_visit_test, p4p_corner_eye_test -> all green
