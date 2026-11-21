# P4PBUILD1 stage 1 - THE VISIT (S533)

Design: ops/research/DESIGN_THREEP4P_V2.md section 3. Built ON (no switch).

## What changed
- A beaten amateur opponent may ask to train at the club. It needs evidence from the bout (a heard, fitted call on the ropes
  followed by an exchange off them, or the same planned line winning twice on the ropes), then a seeded roll:
  5% + 0.1% a reputation point (to 10%) + 3% evidence + up to 7% for the share of planned exchanges won, never above 25%.
  Never after a loss, a pro bout, with reception taken, no free place, or inside the 120-day wait.
- The visitor IS the region's boxer: name, club, ladder place and record (the loss just taken included). Signing moves that
  record to the roster, removes the boxer from the region's table and drops offers that named them.
- Three answers at reception, each with its cost on the card: Sign now (place N of M, $250 stipend), Pass (no ask for 120
  days), Trial first (the next Monday inside the week; the coach's read then shows, and one more day to decide).
- The week running out counts as a pass (120 days). The last day stops the clock and is named on Home's needs.
- A night with evidence but no visitor says so on the result ("The other corner saw it ..."), so the player learns the rule.
- Save and load keep the visitor, the trial day, the cooldown and the link to the region's boxer.
- Files: scripts/rules/CardAsk.gd (rewritten, pure), scripts/state/VisitWire.gd (new), BoutFinish, Sim, Clock, Needs,
  ui/modals/Interview, ui/RosterActs, ui/ResultPage, handbook entry "The visit".

## Critics' lists: taken and refused
Taken: the 25% cap and the share-not-count bonus (Dola: no farming by long bouts); the "noticed, no visitor" line (Dola);
identity by the region's own row so the record cannot fork (Arena); real costs on all three answers (Arena).
Refused: visits after losses or pro bouts (the design says no); a streak bonus (farmable); the visit changing the bout's
odds (Dola 4: the fight stays the fight); a per-opponent roll cooldown (needs a measurement first).

## Stills (hidden desktop, each opened)
- docs/playtest/S533/p4pbuild1/visit_2_reception.png - reception: the three answers and the cost line.
- docs/playtest/S533/p4pbuild1/visit_4_reception_after_trial.png - after the trial Monday: the coach's read, Trial gone.
- docs/playtest/S533/p4pbuild1/21b_result_card_ask_real.png - result page: the ask line.
- docs/playtest/S533/p4pbuild1/21c_result_visit_note_real.png - result page: seen, no visitor.
Seen in the stills and not fixed here: the result fixture of layout_snapshot is a LOST bout (the real game never shows the
ask after a loss); on Home the need sits under "More below" when other needs come first (Reception is lit red).

## Tests (each through ops/Tools/godot_slot.py)
- card_ask_test -> CARD_ASK failures=0
- p4p_visit_test (golden path: rules, wire, save/load, real screens, 60 real bouts) -> P4P_VISIT failures=0
  (real bouts=60 wins=30 with_evidence=20 visits=1; a boxer with drilled plan lines on 60 different fight nights. A day-one
  boxer's lines are under Usable and never fire, so that boxer brings no visitor: the visit rewards a drilled plan.)
- golden_path_test -> GOLDEN_PATH failures=0; save_load_test -> SAVE_LOAD checks=86 failures=0
- refuse_walkin_test, first_hour_test, first_hour_walk_test, recruit_test, newcomers_test, rival_offer_wire_test,
  offer_gone_test, result_tabs_test, file_limits_test, tooltip_standard_test, no_pronoun_test, plain_words_test,
  words_on_screens_test -> all failures=0 / PASS

## Addendum (third critic, John): no dominant pick
"Trial first" was free knowledge. It now has a price in the game's own terms: on the trial's morning a seeded roll (1 in 4,
CardAsk.TRIAL_LOSS) finds the boxer talked round by the old club: no read, no visitor, and the 120-day wait runs. "Sign now"
pays the stipend and the place on a guess of the potential. The card and the Trial button's tip say both.
Test: p4p_visit_test -> "trial mornings=200 lost=51", P4P_VISIT failures=0.
Refused from John's list: a plain win qualifying without evidence (the design's point is that the plan earns the visit);
signing without the stipend and "train here for one camp" (new contract kinds: scope, the owner's call).
