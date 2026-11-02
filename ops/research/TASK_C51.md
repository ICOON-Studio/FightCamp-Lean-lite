# TASK C51 — THE HOLD THAT CROSSES A BORDER (codex)

Model: gpt-5.6-luna, effort **medium**, Fast off. One session.
**GATE SATISFIED 2026-09-08 — C51 RUNS NOW.** This task reads `regulator_kind`,
and U12 is what creates it. U12 merged to `master` as **c3109bc** ("Merge U12:
the organization says what kind of thing it is"), so the field is live on all 18
catalogue rows: `athletic_commission`, `house_plus_officials`,
`national_sport_authority` and `unknown`, with `unknown` a STORED value rather
than an absence. Nine rows (GLORY, RWS, LUX, ROAD FC, Kunlun, IBJJF, UWW, IJF,
WT) deliberately keep `unknown` — size and country were not allowed to fill them
in, so **treat `unknown` as a real answer and never infer a regulator from a
country**.

## Why this exists

Your own C49 finding, and it is a gameplay hole rather than a data gap:

> Medical holds are one athlete-level `medical_hold_until_week` clock in
> `BodyReadiness` / `GameState`, with **no jurisdiction or reciprocity
> dimension**.

So a Nevada suspension is silently a Saitama suspension. J3 D7 says the
opposite in as many words: **suspension reciprocity is ABC-member, not global.**
The game ships organizations in both worlds — US commission cards, RIZIN under
JMOC, ONE under house rules with a host overlay — and treats every hold as if
the whole planet honoured it.

C49 also recommended the second half: an **event-level effective regulator
override**, because a promotion running cards in three countries is regulated
three ways and the organization-level default cannot say that alone.

## What to build

1. **The hold records where it came from.** `medical_hold_until_week` gains the
   authority that issued it — the organization's `regulator_kind` and the
   jurisdiction, taken from the event, not invented.
2. **An event carries its effective regulator**, defaulting to the
   organization's and overridable per event. This is C49's recommended shape.
3. **`book_fight` honours a hold according to reciprocity, not universally.**
   An ABC-member commission hold binds another ABC-member commission's card; it
   does not automatically bind a non-member card. **Where the answer is
   unknown, the hold BINDS** — the safe direction is refusing a bout, never
   clearing a fighter the game is unsure about.
4. **A screen can say which body is holding the fighter**, through the existing
   body/clearance read rather than a new one.

## Out of scope

Drug testing (J3 D9 owns it), and inventing a suspension length for any
jurisdiction. R54/R59/R60 already settled that a hold is lifted by CLEARANCE
and never by an invented day count — do not add one here.

## Owned files

```
Godot/scripts/BodyReadiness.gd
Godot/scripts/Sanctioning.gd
Godot/scripts/GameState.gd
Godot/tests/body_readiness_test.gd
Godot/tests/booking_eligibility_visibility_test.gd
research/C51_DIGEST.md
```

**Not owned:** `Godot/assets/data/real_organizations.json` and
`Godot/scripts/Sponsorship.gd` — U12 owns the catalogue fields you are
consuming. If `regulator_kind` is missing or wrong for an organization, say so
in your mail; do not correct the catalogue yourself.

`GameState.gd` is **14,072 lines — never open it whole**: `grep -n medical_hold`
and `grep -n 'func book_fight'`, then read only those windows.
`BodyReadiness.gd` is 731 lines and `Sanctioning.gd` 131 — the latter reads
whole.

## Parse gate

```
python Godot/tools/check_scripts.py Godot/scripts/BodyReadiness.gd Godot/scripts/Sanctioning.gd Godot/scripts/GameState.gd Godot/tests/body_readiness_test.gd Godot/tests/booking_eligibility_visibility_test.gd
```

## Test

```
Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tests/body_readiness_test.gd
Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tests/booking_eligibility_visibility_test.gd
```

Then the full suite once in the background before the commit. Fails=0 or better.

## The one trap

**Unknown must refuse the bout, not allow it.** Every other read in this
project treats an unknown as absent and prints nothing — that is right for a
label and wrong for a gate. A fighter under a head-injury hold who slips onto a
card because the game could not decide whether Japan honours a Nevada
suspension is the worst bug this system can produce. Default to binding, and
say in the digest exactly which pairs of regulators you could source as
reciprocal.
