# R72 — THE SIGNATURE IS NOT THE LICENCE

C51 shipped at 173 pass / 8 fail. Every failure was one rule: its `book_fight`
gate refused the bout agreement whenever a medical hold's provenance was
`unknown` on either side.

## Why that was too wide

`unknown` is not a rare case here. U12 established that **UFC is the only
promotion with a sourced `regulator_kind`**; twelve others are explicitly
unknown, and generated markets default to it. C51's own migration stamps every
pre-existing hold as `{"regulator_kind": "unknown"}`. So "unknown binds" meant
**any medical hold refused any signing**, and the commission model recorded at
`GameState.gd:book_fight` — user decision 2026-09-01, "a fighter does not need
to be medically cleared before signing a contract, but they must pass medical
clearance before the actual fight can take place" — was repealed as a side
effect. `pre_fight_medicals_test.gd` exists to assert exactly that rule, and it
was one of the eight.

The user reaffirmed the 2026-09-01 ruling on 2026-09-08 and chose to narrow the
gate. **This game has no promotional contract**: `book_fight()` signs one bout
on one card, so the question was only ever about a single bout agreement signed
weeks before the night.

## What changed

- `Sanctioning.medical_hold_refuses_booking(hold_authority, event_regulator)` —
  new, next to `medical_hold_binds()` and deliberately narrower. It returns
  false the moment either side is empty or `unknown`, and otherwise defers to
  `medical_hold_binds()`. So the SIGNATURE is refused only where the refusal is
  sourced: an ABC-member commission's suspension against another ABC-member
  commission's card, which is the only positive pair C51 established.
- `GameState.book_fight()` calls it instead of refusing on any
  `medical_hold_active` reason.
- Nothing else moved. `medical_hold_binds()` is untouched, so
  `evaluate_competition_clearance()` still defaults an unknown to binding.

## Nothing was loosened on the night

`enforce_pre_fight_medicals()` already resolves the same
`_offer_effective_regulator(offer)` and runs the same clearance on fight day,
and a failure there cancels the bout and voids the contract. C51's trap — never
let a fighter compete under a live suspension — is enforced there, where it was
always enforced, and an unknown still binds. The booking refusal was redundant
for safety; it only cost the player the ability to sign.

`booking_eligibility_visibility_test.gd` now proves that seam rather than
assuming it: an unknown card **signs contingent with the warning**, and the
same hold against the same unknown card is still not clear on fight day.

## Test-side fixes

- `booking_eligibility_visibility_test.gd` — C51's "an unknown target regulator
  refuses a held fighter" became the contingent-signing assertion above, plus
  the fight-day proof, plus a NEW case nothing covered before: a commission
  suspension against a reciprocal commission's card still refuses at the
  signature. That is the one place the narrowed gate bites.
- `body_readiness_integration_test.gd` — this failure was not the gate at all.
  The test spelled the body schema version as the literal `2`; R59 bumped it to
  2 and C51 to 3, so the literal turned each bump into a false failure. It now
  reads `BodyReadiness.CURRENT_VERSION`.

No expectation in the other six failing files was rewritten. They went green
because the rule they encoded was restored.

## Suite

173/8 before, 181/0 after.

```
Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tests/booking_eligibility_visibility_test.gd
Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tests/pre_fight_medicals_test.gd
Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tests/body_readiness_integration_test.gd
```
