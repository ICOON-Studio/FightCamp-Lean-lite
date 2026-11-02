# C51 digest — the hold that crosses a border

Implemented on `master` after U12 `c3109bc`.

## Decision

Medical holds now retain `body_state.medical_hold_authority` with the issuing
`regulator_kind` and the event jurisdiction. Existing saves migrate
additively: an old hold keeps its clock and becomes explicitly `unknown`
provenance, which binds conservatively.

Events now carry `effective_regulator`. It defaults to the organization's
stored `regulator_kind` plus the event's own `country`; an event may override
the effective regulator. The organization's headquarters/country is never
used as a substitute for the event jurisdiction.

The only sourced positive reciprocity pair implemented here is
`athletic_commission` ↔ `athletic_commission` (ABC-member commission to
ABC-member commission). No global reciprocity was assumed. `house_plus_officials`
and `national_sport_authority` do not reciprocate by default. If either the
holding authority or the target event regulator is `unknown`, the hold binds
and `book_fight` refuses the bout. A known non-reciprocal hold may remain a
contingent booking, but fight-day medical enforcement still applies.

The existing body read exposes `hold.authority`, so a screen can name both the
holding body and jurisdiction without creating a new read.

## Verification

- `BodyReadiness.gd` stores and reads authority; its focused test covers
  additive migration, Nevada commission provenance, ABC reciprocity, a known
  house-rules non-match, and unknown binding.
- `GameState.gd` resolves event overrides, applies the target-card gate in
  `book_fight`, stamps hold provenance at settlement, and surfaces authority
  through `get_body_read`.
- `booking_eligibility_visibility_test.gd` covers a commission hold against a
  house-rules event, an unknown event refusal, and the body-read authority.

`C51` does not invent suspension lengths, drug-testing rules, or reciprocity
for any pair not established above.
