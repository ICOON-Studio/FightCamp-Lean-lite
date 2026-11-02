# TASK_CALLEVIDENCE1 - the number behind each corner call (Lean repo)

Model: qwen3-coder (Qwen seat - small pure module + unit test)
Discipline: boxing (demo)
Repo: the Lean game, worked in the worktree named in the prompt. Godot 4.7.2, GDScript.

## Why
Operator S316: "the decision on the round has no real data i think for the player to pick a tactic". Plan approved
Q-S294-29 "Yes, build it" (Game research/S316_BODY_MAP_PLAN.md step 4): "Each of the eight calls shows the number
that argues for it ('Go to the body - Maria's ribs: hurt, 9 landed')" and "what she left open".
The data exists: `scripts/rules/BodyMap.gd` (map of six places per boxer + `tally(beats)`), HabitBeats fires
`[{who, habit, t}]`, energy at the bell. This task turns them into short lines. Claude puts them on the corner card.

## Prior research
S316_BODY_MAP_PLAN.md (design); a real chief second reads output, landed by kind, where she is hurt, tells and energy
(G132, topics/body_damage.md). Calls: `BoutRules.CORNER` keys long, body, lead, hands, let_go, calm, tie, finish.

## What would a human do?
A chief second at the stool says one fact per instruction: "Her ribs are going - 4 to the body landed, go downstairs."
One number each, both fighters named (never a bare "she"/"her" - two women in the ring, operator S309).

## Prefab check
Nothing to import: string building over our own data. Our code.

## Build: scripts/rules/CallEvidence.gd (new, < 200 lines, `extends RefCounted`, static funcs only, ZERO preloads)
"a" = our fighter, "b" = the opponent. names = [ours, the opponent's], e.g. ["Lucy", "Maria"].

`static func lines(map: Dictionary, tally: Dictionary, fires: Array, energy: Dictionary, names: Array,
	habit_words: Dictionary) -> Dictionary`
- map = BodyMap map ({"a": {"places": {place: 0..100}, ...}, "b": {...}}); read a place as `places.get(p, 100.0)`
  (relief is not needed here).
- tally = BodyMap.tally(beats) shape: {"a"/"b": {"thrown": {kind: n}, "landed": {kind: n}, "pct": {kind: n}}}, kinds
  jab, straight, hook, uppercut, body, total.
- energy = {"a": 0..100, "b": 0..100} at the bell.
- Returns {call: line} for ALL EIGHT keys, each a single sentence of at most 70 characters, each containing at least one
  digit:
  - "long":   "{a}'s jab: {landed} of {thrown} landed"  (thrown 0 -> "{a} threw no jabs")
  - "body":   "{b}'s ribs: {v} ({band}) - {n} to the body landed"  v = the lower of b's two ribs, n = a's landed body
  - "lead":   "{b} threw {n} punches, landed {m}"  (b's total thrown / landed: a waiting counter-puncher throws little)
  - "hands":  "{a} took {n} to the head; {place} {v}"  n = b's landed jab+straight+hook+uppercut, place/v = a's lowest
              of head, left eye, right eye, nose (place in words: "nose", "left eye", ...)
  - "let_go": "{a} threw {x}, {b} threw {y}"
  - "calm":   "{a}'s energy: {e} at the bell"  (e rounded to an int)
  - "tie":    "{b} landed {n} hooks and uppercuts"  (b's hook + uppercut landed)
  - "finish": "{b}'s {place}: {v} ({band})"  the lowest of b's six places
  Bands from the settled numbers: fine > 55, hurt <= 55, critical <= 35, doctor <= 15 (copy the four constants; no
  preload). Values print as ints.
`static func open_line(fires: Array, names: Array, habit_words: Dictionary) -> String`
- The opponent's ("b") habit that fired most this round: "{b} {words}: {n} times" (n == 1 -> "once"), words from
  habit_words[habit] (e.g. {"drops_right_after_jab": "drops her right after the jab"}); a habit missing from
  habit_words uses the habit id with "_" -> " ". Ties: the earliest first fire (lowest t). No "b" fire -> "".
`lines()` also returns key "open" = open_line(...).

## Test: tests/call_evidence_test.gd (new, `extends SceneTree`, prints `CALL_EVIDENCE failures=<n>`, quits 1 on failure)
Build the inputs by hand (no RoundScript, no preloads in the test except CallEvidence.gd).
1. All eight call keys + "open" present; every call line <= 70 chars, contains a digit, contains no standalone word
   "she" or "her" (case-insensitive, whole word) - BUT habit words may contain "her" only inside the "open" line.
2. Numbers: a jab 3 of 7 -> long line contains "3 of 7"; b ribs left 61 right 48, a body landed 4 -> body line contains
   "48 (hurt)" and "4 to the body"; a energy 37.6 -> calm contains "38".
3. finish picks b's lowest place of six (set nose 30 -> "nose: 30 (critical)"); hands picks a's lowest face/head place.
4. Bands at the edges: 56 fine, 55 hurt, 35 critical, 15 doctor.
5. open_line: fires b drops_right_after_jab at t 5 and 20, b low_lead_hand at t 2, a slow_starter at t 1 ->
   "Maria drops her right after the jab: 2 times"; one fire -> "once"; ties -> lowest first t; no b fire -> "".
6. Zero thrown: tally all zeros -> long line "Lucy threw no jabs"; nothing crashes on an empty map {}.

## Commands
- Parse: `"%LOCALAPPDATA%\Programs\Godot\Godot_v4.7.2-stable_win64.exe" --headless --audio-driver Dummy --path .
  --check-only --script scripts/rules/CallEvidence.gd` (and the test) - no "Parse Error" lines.
- The one test (tier: new test file only): `... --headless --audio-driver Dummy --path . --script
  tests/call_evidence_test.gd` -> `CALL_EVIDENCE failures=0`.

## Contract
OWNS: scripts/rules/CallEvidence.gd, tests/call_evidence_test.gd   (Lean repo)
RED_TEST: tests/call_evidence_test.gd
REGRESSION: tests/body_map_test.gd
VISUAL: none (words; Claude checks the corner card still after wiring)

## VISUAL GATE
No still in this task; Claude takes the corner card still on the game's camera after wiring. Do not open any window.

## The one trap
Two women in the ring: every line names who it is about. Test 1 rejects a bare "she"/"her".
Do not touch any other file. Do not open any window. Do not push. Commit on your branch with a clear message.
