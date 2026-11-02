# S364 digest (2026-11-02) - update 66: what Ana drills, what each open is decided on

Lean commits: 2767c1c (drill plans + the opens' lean), 146f59a (wording), 4ffdb77 (bout-without-opponent guard), exe still.
Model: Opus 5.5. The operator said "Keep going" after S363 shipped; this is Kalli K-BELTROAD1 parts 2 and 3
(research/K_BELTROAD1_KALLI.md).

## What now works
1. **WHAT THE CLASSES DRILL** (NoGi.drilling / drilling_for, f["drill"]; Ana's TO BLUE BELT card, three buttons):
   - Coach's pick: the default, the move closest to a weapon.
   - For the next open: the least-owned move of the group the next open is decided on. It finishes that move before the
     next (f["drill_on"]). When the whole group is owned, it pushes the group's best move toward a signature.
   - Her favourite: her best owned move under 50, pushed to a SIGNATURE (50, "signature" in gold on the list).
   A plan with nothing left to drill falls back to the coach's pick.
2. **Each open is decided on one syllabus group**, in turn ("decided on escapes and survival" ...). Her own in that group moves
   her match odds by LEAN_W x (own - 0.5) = +-0.25. A signature move in the group adds 0.05. Each open shows her
   first-match chance as a word beside Enter (LONG SHOT under 0.40, EVEN, FAVOURITE over 0.60).
3. **Defect fixed (seen in export):** grey_reason_test crashed once in about 12 runs, at fight night's end, on a bout dict
   that had no opponent (Home.events and FightPoster read it). Both now skip such a bout and push_warning its keys. The
   writer was NOT found: every f["bout"][...] writer and the short-notice swap were read, and 10 more runs did not
   reproduce it. The warning will name it next time.

## Decided, with the measurement (Kalli's spec changed twice)
- Kalli's "the gap" (her weakest group) wandered between groups as each one caught up, and finished nothing.
- At LEAN_W 0.12 and at 0.30, ten weeks on the gap still LOST to the coach's pick inside the gap's own open (0.667 vs 0.680).
  Owning one more move lifts the general belt share by 1/14 x 0.30 = 0.021, which outweighs a small lean.
- So the plan became "for the next open" (Kalli's own reason for the gap: "opponents in the next open lean on a particular
  group"), it finishes a move before the next, and the lean weighs +-0.25 inside the 0.2-0.8 cap. Measured: 5 weeks for the
  takedowns open beat the coach's pick there (0.723 vs 0.709) and cost belt time (share 0.64 vs 0.72). It is now a real trade.
- Consequence: Ana is FAVOURITE at the Regional (escapes 0.93 owned -> 0.76). Her best group deciding an open is meant
  to show.
- The weigh-in (Kalli part 3) is NOT built: the no-gi athletes have no weight model. It waits for one.

## Evidence
- tests/drill_pick_test.gd (new): the plans, finishing a move, the fallbacks, the lean +-0.25 and the signature, the 5-week
  trade, the words, and the page (plan pressed -> chosen, the list marks the drilled move, each open names its lean and
  her chance). no_gi_test's 400-open base-odds block now runs without a lean (its subject is the base odds).
- export.sh 115/115. Stills from the exported build on the hidden desktop (docs/playtest/S364/exe) were opened. They caught
  the chance word wrapping under the open's line, which is now moved beside Enter.

## Next (decision)
Ana's no-gi side as gym business (Kalli part 4: BJJ members on their own dues, a medal brings members, a blue belt can
teach the beginners' class). Then the open bout-without-opponent writer, if the warning shows up.
