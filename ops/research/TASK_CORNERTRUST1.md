# TASK CORNERTRUST1 - QWEN (qwen3-coder) - a wrong corner call costs her trust; a Low fighter stops listening (rules only)

Status: OPEN (S401, Claude main). Discipline: boxing. Model: qwen3-coder.
Source: ops/research/S400_REVIEW/IDEAS_VERDICT.md, ideas 105483022 and 106015958 (both critics: TRY, small). Rules + tests only -
NO screen work in this task: the menus are waiting for the operator's OK.

## Contract
OWNS: scripts/rules/CornerTrust.gd, tests/corner_trust_test.gd, scripts/rules/FighterProfile.gd:18-31, scripts/state/LiveRound.gd:209-216, scripts/state/LiveRound.gd:430-436, scripts/state/BoutNight.gd:400-401
RED_TEST: tests/corner_trust_test.gd -> CORNER_TRUST failures=0
REGRESSION: trust_fight_test, exchanges_test, habit_fix_test, plan_bout_test, plan_bots_test, corner_jobs_test, plain_words_test, golden_path_test
VISUAL: no

## Prior research
`python ops/Tools/prior_research.py trust shout corner call`. Read: CORNER_SHOUTS_VERDICT_S250.md, topics/plans_corner.md.
S361 (Q-S294-86, operator): "her morale is the trust score, no new meter". So this task adds NO new meter: morale moves.

## What would a human do?
A fighter who hears a bad instruction and gets hit for following it trusts the corner less next time; one who has stopped trusting
the corner fights her own fight and ignores the shouting. Coaches know a quiet corner beats a wrong one. Real research points the same
way (Jowett coach-athlete relationship; Mageau & Vallerand 2003), but gives no numbers: the numbers below are design values.

## Prefab check
None needed: a few lines on our own morale table (FighterProfile.MORALE_EVENTS, apply_morale).

## How it works today (read these first)
- Morale 0..100 is trust. FighterProfile.mood: Fired up >= 75, Steady >= 50, Flat >= 30, Low < 30. FighterProfile.trust scales what she
  takes in (1.05 / 1.0 / 0.85 / 0.7).
- LiveRound.exchange (line ~209) decides `shouted`; each exchange record has "shout" (bool), "fit" (Exchanges.fit: "best", "ok",
  "wrong", "none") and "won" (bool). LiveRound.close (line ~430) is the end of a round.
- BoutNight.gd line 400 applies the win / loss / draw morale.

## The rule
1. scripts/rules/CornerTrust.gd: pure static functions, under 100 lines, no preloads beyond FighterProfile, no randomness.
   - `lands(f) -> bool`: false when her mood is Low (morale < 30), else true.
   - `ignored(b: Dictionary)`: b["calls_ignored"] + 1.
   - `tally(b: Dictionary, exs: Array)`: for each exchange with "shout" true: "wrong" fit and not won -> b["calls_wrong"] + 1;
     fit "best" or "ok" and won -> b["calls_right"] + 1. Everything else counts for nothing: a right call she lost, a wrong call she
     won anyway, fit "none", and any exchange with no shout. Saying nothing is always free.
   - `settle(f: Dictionary, opp_name: String) -> Dictionary`: once per bout (a `calls_settled` flag on f["bout"], a second call changes
     nothing). Applies FighterProfile.apply_morale(f, "call_wrong", reason) once per wrong call, at most 3 times, and
     apply_morale(f, "call_right", reason) once per right call, at most 3 times. Returns {wrong, right, ignored}.
     Reason, plain words: "Corner calls went wrong against %s" when any wrong one was counted, else "Corner calls worked against %s".
2. FighterProfile.MORALE_EVENTS: add "call_wrong": -2 and "call_right": 1.
3. LiveRound.gd - this file is 496 lines and the limit is 500, so ADD AT MOST 2 LINES:
   - line 209 becomes `var shouted := shout != "" and Exchanges.CALLS.has(shout) and CornerTrust.lands(f)`, and one new line after it:
     `if shout != "" and not shouted: CornerTrust.ignored(f["bout"])`.
   - one new line in close(): `CornerTrust.tally(f["bout"], exs)`.
   The set-up's "now" is cleared before line 209 and stays as it is. The preload goes at the top only if a line is left; otherwise reference
   the class through an existing preload-free route and say so in the PR.
4. BoutNight.gd: right after the line 400 apply_morale, `CornerTrust.settle(f, opp["name"])`. It runs at the END of the bout on purpose:
   her trust does not change inside a fight, so a bad call cannot spiral inside the same bout. It carries to the next one.
5. The feature is ON for everyone; there is no switch.

## Do
1. tests/corner_trust_test.gd FIRST (prints `CORNER_TRUST failures=<n>`). Run it on main: it must fail (no CornerTrust.gd yet). It covers:
   - tally: every row of the table above, one case each, including the "counts for nothing" rows.
   - lands: morale 29.9 false, 30.0 true, 80 true.
   - settle: 5 wrong calls take morale down by at most 3 x the "call_wrong" size scaled by heart (read her heart; bounds, not an
     exact number); 5 right calls raise it, at most 3 counted; a second settle changes nothing; 0 calls changes nothing at all.
   - real bouts, same seeds, Lucy (Data.lucy) vs Maria (Data.OPPONENTS[0]) and Erin (Data.OPPONENTS[2]), 120 nights each, TWO DIFFERENT
     fighters as always: at morale 20 a corner that shouts every time fights exactly the same rounds as a silent corner (nothing lands);
     at morale 60 it does NOT (control: the instrument can read a difference).
   - print the measured morale change per bout for an always-right and an always-wrong shouter. Always-wrong must lose more.
2. Build the module, wire it inside the OWNS windows, make the test green.
3. Run REGRESSION. Do not change any number or threshold in an existing test. If one goes red, stop and put the measured numbers in
   the PR body: Claude decides.

## Rules for this seat
Godot only through `python ops/Tools/godot_slot.py run --who qwen -- ...`, headless, `--audio-driver Dummy`. Parse check before any test.
No screens opened. Nothing outside OWNS. PR body: `RESULT: tests/corner_trust_test.gd -> CORNER_TRUST failures=0` and the printed
morale-per-bout numbers.

## The one trap
`LiveRound.gd` is at the 500-line cap, and `plain_words_test` reads every player-facing string: "exchange", "uptake" and similar engine words
may not appear in the reason text.
