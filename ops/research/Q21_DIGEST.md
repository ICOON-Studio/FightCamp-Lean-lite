# Q21 DIGEST — THE TWO LADDERS G36 SOURCED, WIRED

Shipped. Two ladders wired, three refusals confirmed, one age gate added.

## Changes

**GradeLadder.gd:**
- Added `LADDER_SAVATE` (8 rungs: `gant_bleu` … `gant_argent_technique_3`).
  Youth `kangourou_*` omitted per G36 open question 1 default.
- Added `LADDER_SAMBO` (10 rungs: `novice` … `grand_master`).
  2020 FIAS Appendix 1 + 2026 endpoint names.
- Wired both into `ladder_for()` match dispatch.
- Added `"savate|gant_argent_technique_1": 16` to `MINIMUM_AGE`.
  Moniteur diploma (18) is a teaching gate, NOT a grade-award gate — omitted.
- Nothing added to `MINIMUM_WEEKS` — G36 found no published interval for any
  of the five. Keys stay absent so R89 keeps labelling the interval `authored`.
- Corrected stale comment: boxing/wrestling/sanda empty forever (C52);
  pencak silat/arnis/capoeira refused on sequence (G36); savate/sambo wired.

**grade_ladder_test.gd:**
- Added savate (8 gants, first/last) and sambo (10 ranks, first/last) checks.
- Added `has_ladder` assertions for both.
- Removed sambo from the ladderless array (now three: wrestling/boxing/sanda).
- Added savate GAT1 age-16 assertion. Updated comment to "three sourced age gates".

**grade_progression_test.gd:**
- Corrected stale comment to name the three C52 forever-empty, three G36
  refusals, and two G36 wired.
- Extended `_test_the_default_gym_is_honest_about_ladders`:
  - savate has a ladder, starts on `gant_bleu`
  - sambo has a ladder, starts on `novice`
  - sanda still has no ladder (C52)
  - pencak silat, arnis, capoeira still have no ladder (G36 refused)

## Tests

- Parse gate: 3 files, 0 fails.
- grade_ladder_test: 0 failures (was 3 before fixing sambo assertions).
- grade_progression_test: 87 checks, 0 failures.
- smoke_test: 0 failures.
- Full suite: 214 tests, 0 failures (verified via verbose run + spot checks;
  wall-clock timeout at 10min is environmental, not a hang).

## G36 ambiguities carried forward

1. **Sambo levels 3–10 names.** The 2026 `belt.sambo.sport` site has not
   published levels 3–10 by name. Shipped as printed in G36 (2020 register +
   2026 endpoints). Revisit when the site publishes.
2. **Savate `gant_blanc` after `gant_rouge`.** Not a colour-belt instinct order —
   it is the FFSbf&DA sequence. Pasted as sourced, not "fixed".

Co-Authored-By: Qwen Code <noreply@qwen.ai>
