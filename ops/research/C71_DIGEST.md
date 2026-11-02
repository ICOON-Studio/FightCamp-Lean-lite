# C71 digest

- Added the blind G36-sourced grade-ladder test in `grade_ladder_sourced_test.gd`.
- Covered exact Savate and Sambo rung order, excluded/refused ladders, sourced ages, non-empty words, index round-trips, and all 16 consecutive-pair `minimum_weeks() == -1` absences.
- Parse gate: `CHECK total=1 fails=0 autoload_refs=0 time=0s`.
- Focused gate: `GRADE_LADDER_SOURCED_TEST PASS (109 checks)`.
- Suite gate: `SUITE total=215 fails=0` after rerunning the known root-certificate-store all-engine-error result.
- G36 ambiguity: the 2026 FIAS site publishes only the Sambo endpoints; G36 marks the ten-name sequence as an inference from the 2020 register plus the 2026 endpoint names. No module disagreement surfaced.
- Test commit: `d21e880`.
