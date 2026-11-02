# S363 digest (2026-11-02) - update 65: the stripe is your call, Ana's week in the week review

Lean commit: 6f1758c (StripeCall, Ana in the week review, update 65 notes, stills). Model: Opus 5.5.
Seat answer collected: SQ26 Kalli K-BELTROAD1 (research/K_BELTROAD1_KALLI.md, 6,084 chars; the operator asked
"Collect bot replies" mid-session, so the drain was run by hand instead of waiting for the 30-min job).

## Kalli's verdict (read in full)
"The belt road is a good-looking progress bar with no decisions in it." The stripe is "a notification with a button". The
open is "a coin flip with an entry fee". Her ONE first change was the stripe as a choice, and it was built as she specified,
with the two changes listed below. The rest of her review is the queue for the coming sessions: (2) a weekly drill choice
(the coach's pick stands, so it takes 0 or 1 clicks), (3) the opens' bracket lean, the weigh-in and the chance shown as a
word, (4) the BJJ side's members.

## What now works
1. **StripeCall** (scripts/rules/StripeCall.gd, pure). When a stripe is due there are three calls:
   - GIVE IT NOW: morale +6, loyalty +3.
   - HOLD IT BACK: no stripe; the drilled move gains x1.15 (NoGi.HUNGRY) until she gets it; morale -8, loyalty -5. Under
     50 loyalty she asks about another club (Mail). One hold per stripe.
   - GIVE IT EARLY (none due, and she is at least half way to the next stripe): morale +10. From the second early stripe
     on, members -2 and her next open is a tough bracket (-0.05 a match, NoGi.TOUGH).
   The coach advises from her state: thin loyalty or low morale means give it now; at 70+ morale she is hungry and he
   says hold. The belt log records "Stripe 3 held back" and "given early". The button tooltips name each cost.
   DECIDED (not in Kalli's spec): a hold also costs 5 loyalty. Without it nothing in the game lowers loyalty, so her
   "asks about another club" line could never fire.
2. **Morale is read.** NoGi.win_chance adds (morale - 60) / 400, so morale 100 is +0.10 a match and 20 is -0.10. Her open
   results move morale (Kalli part 3): +4 a win, -3 a points loss, -6 a tap. The S361 lesson applied: a number nothing reads
   is not a mechanic.
3. **Ana in the week review** (WeekReview._grappler, data from Grapplers.week_report via Sim.end_week):
   - ON THE MAT, under the boxers: her classes (133 of 200 to blue), the drilled move's bar filling toward a weapon at 30,
     her open match by match, her morale and loyalty.
   - The stripe calls appear in the review itself. A call swaps the buttons for what happened, removes the "your call"
     note and refreshes the morale line.
   - The surprise lands last (ReviewReveal.grappler_headline): a medal, then a new weapon, then "Stripe N is due: your call."
   Grapplers marks the week (mat_week on Sunday, open_week on the open's Saturday) and the report clears it.
4. Ana's page (COACH'S CALL) shows the same three buttons (GrapplerPage.stripe_buttons, shared by the page and the review)
   plus her morale, loyalty and any held stripe.

## Evidence
- tests/stripe_call_test.gd (new, 32 checks): the calls' gates and numbers, hold x1.15 measured on a real week, the 2nd
  early stripe costing members and odds, the advice, morale in the opens, a real 2-week career where the report has Ana's
  armbar going 28 -> 31.2 (the headline names it), and HOLD pressed inside the review. This test reads red on the shipped
  tree: no Drill_ana node, no StripeCall.
- Also green: no_gi (updated for the new stripe API), review_reveal, golden_path, save_load, week_actual, belt_road,
  test_jump, tips; then the whole list through export.sh.
- Stills on the hidden desktop (docs/playtest/S363, tools/s363_stills.gd), all opened. They caught one defect: after a call,
  the "Stripe 3 is due: your call" note and the old morale line stayed on screen. It is fixed and the test checks it.
  Known and left alone: on Ana's page, the record card's bottom log line sits below 1080 (the page scrolls).

## Next (decision)
Kalli part 2, the weekly drill choice. The coach's pick (the move closest to owned, as today) stays the default, marked
COACH'S PICK. The alternatives are the gap (her weakest group) and her favourite (an owned move pushed toward a signature
at 50). Each is wired to something that reads it: the gap feeds the opens' bracket lean (part 3), and the signature gives
+0.05 in the matches where it applies. Then part 3: the bracket lean, the weigh-in and the chance as a word.
