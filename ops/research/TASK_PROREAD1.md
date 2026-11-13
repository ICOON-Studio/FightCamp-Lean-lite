# TASK PROREAD1 - QWEN (qwen3-coder) - professionals get read: the target line, the split, the feint, the season proof

Status: OPEN (S458, Claude main). Discipline: boxing. Model: qwen3-coder.
Mechanic: PROGRESSION (approved, owner Q-S294-211 "Yes, go ahead"). Spec: ops/research/PROGRESSION_MAP_S448.md section 4 M7 "PROFESSIONALS
GET READ" (READ IT). A PURE module + its test, OFF until the READ1 probe sizes it: no wiring, and no cost SIZE in the module - it returns
SHARES (0, 0.5, 1) and the caller multiplies by the size READ1 measures.

## Contract
OWNS: scripts/rules/ProRead.gd, tests/pro_read_test.gd
RED_TEST: tests/pro_read_test.gd -> PRO_READ failures=0
REGRESSION: the_read_test, plan_lines_test, file_limits_test, no_pronoun_test
VISUAL: no
NOT YOURS: every other file (read-only: scripts/rules/TheRead.gd for the house style; nothing to preload).

## What to build (ProRead.gd under 200 lines; pure static; ZERO preloads)
Constants: SPLIT_AT := 0.8, FEINT_LINE := "Feint", FEINT_MISS := 0.5, PROOF_FIRED := 3, HELD_TIERS := ["Sharp", "Signature"].
A bout record (what the caller keeps per bout): {"pro": bool, "fired": {line: int}} and, once read, "read": {"line": String,
"split": bool, "fired_in_read": int, "won_in_read": int}.
1. `target(history: Array, tiers: Dictionary) -> Dictionary`: history = the fighter's bouts, oldest first; tiers = {line: tier word}.
   - {} when there is no earlier PROFESSIONAL bout (amateurs are never read; the debut is never read: no professional tape).
   - Sum "fired" over the last TWO professional bouts (one if there is only one). first = the most fired line (tie: alphabetical).
   - second = the most fired OTHER line whose tier is in HELD_TIERS and whose count >= SPLIT_AT x first's count; "" if none (a wide plan
     of Usable lines never splits it).
   - Returns {"line": first, "second": second, "split": second != "", "count": first's count}.
2. `round_line(t: Dictionary, round_n: int) -> String`: "" for {}; the line when not split; split: odd rounds "line", even rounds "second".
3. `share(t: Dictionary, round_n: int, line: String, feinted: bool, roll: float) -> float`: how much of the read's cost this firing pays:
   0.0 when t is {} or line != round_line(t, round_n); 0.0 when feinted (the Feint line fired earlier this round) and roll < FEINT_MISS;
   else 1.0, or 0.5 when t["split"].
4. `proof(history: Array) -> bool`: READ-PROOF - the last two PROFESSIONAL bouts that have a "read" entry each pass: split is true, OR
   fired_in_read >= PROOF_FIRED and won_in_read * 2 >= fired_in_read. False with fewer than two such bouts.
5. `words(t: Dictionary) -> String`: "" for {}; "Their corner will wait for your <line>"; split: "Their corner will switch between your
   <line> and your <second>, round by round". No he / she / his / her, no names.

## The test (red on main first: the file does not exist)
tests/pro_read_test.gd (extends SceneTree, prints `PRO_READ failures=<n>`, quits with the count). Hand-made bout records only:
- amateur history only -> {}; one pro bout as the ONLY bout -> target from it (the second pro bout is read on the first's tape);
  empty history -> {}.
- last two pro bouts: {"1-2": 10, "Jab": 4} + {"1-2": 6, "Body hook": 5} -> line "1-2" (16), no split; an OLDER third pro bout with
  {"Jab": 50} is ignored.
- split: {"1-2": 10, "Lead hook": 9}, tiers {"Lead hook": "Sharp"} -> split, second "Lead hook"; same counts with tiers {"Lead hook":
  "Usable"} -> no split; {"Lead hook": 7} Sharp (0.7) -> no split.
- tie {"Cross": 5, "1-2": 5} -> "1-2" (alphabetical).
- round_line: split -> R1 line, R2 second, R3 line; not split -> line every round.
- share: off-target line 0; on target 1; split 0.5; feinted + roll 0.3 -> 0; feinted + roll 0.7 -> 1.
- proof: two read pro bouts {fired 3, won 2} + {fired 4, won 2} -> true; {fired 2, won 2} -> false; one split bout + one {3, 2} -> true;
  only one read bout -> false; amateur bouts between them do not count.
- words: contains the line; split names both; no pronoun.
- Two different histories give different targets (the module reads the record, not a constant).

## Traps
- Read ops/research/GDSCRIPT_TRAPS.md first (typed Dictionary reads, no `:=` on a Variant, `%%`).
- Godot jobs only through `python ops/Tools/godot_slot.py run --who PROREAD1 -- <godot.exe> ...`; the plain win64 exe, never _console.
- Do not delete or weaken any test. Under 500 lines a file. Game words (Sharp, Signature, Usable, Feint).

## Prior research
- PROGRESSION_MAP_S448.md M7; PROGRESSION_CRITIC_S448B/C briefs (the read's history); TheRead.gd (the in-bout read of habits - a
  different thing: this is the opponent's corner reading OUR professional across bouts).

## What would a human do?
A professional's corner studies the last two fights on tape and waits for the punch the boxer throws most; a boxer with two real
weapons is harder to wait for, and a feint makes the corner bite early.

## Prefab check
None: TheRead reads habits inside a bout; nothing reads across bouts.

Test command: `python ops/Tools/godot_slot.py run --who PROREAD1 -- "$LOCALAPPDATA/Programs/Godot/Godot_v4.7.2-stable_win64.exe"
--headless --audio-driver Dummy --path . --script res://tests/pro_read_test.gd`
RESULT line for the PR body: `RESULT: tests/pro_read_test.gd -> PRO_READ failures=0`.
