# TASK KNOWN0 - QWEN (qwen3-coder) - Knowledge.gd: when a group is known, and the five steps of how well you know a fighter (pure rule + test)

Status: OPEN (S433, Claude main). Discipline: boxing. Model: qwen3-coder.
Source: F10 KNOWN0 in `ops/research/CORE_LOOP_MAP_S432.md` section 5 (step 0, foundation fixes) and C12; RPG item 8 in
`ops/research/RPG_LAYER_MAP_S432.md` ("A GROUP IS KNOWN once three fifths of its range is gone (exposure 18)" and THE PIPS table).
Today's code, read S433: `scripts/rules/Knowledge.gd` (149 lines) has `fresh` :33, `all_seen` :38, `group_of` :43, `width` :51,
`expose` :64, `range_of` :82, `stale` :97. There is NO `known`, NO share and NO step function. The width rule is
Knowledge.gd:58 `return FLOOR + (start - FLOOR) / (1.0 + exposure / HALF)` (FLOOR 0.5, HALF 12.0). Nothing in scripts/ preloads
Knowledge.gd: only tests/knowledge_test.gd:13 does, so `range_of` reaches no screen (the map is right about that).
ONE CORRECTION TO THE MAP: "three fifths gone at exposure 18" holds only when the share is measured on the part of the range that
can narrow (start - FLOOR): at 18, width - FLOOR is 0.4 of start - FLOOR. Measured on the whole start it is wrong: Body at 18 is
width 3.5 of 8.0 = 56% gone, never 60%. So the share is `exposure / (exposure + HALF)`, read through `width`. Screens are NOT here:
the attribute board, Profile, trial card and bout sheet are Cursor's later task (they will call `shown`).

## Contract
OWNS: scripts/rules/Knowledge.gd, tests/knowledge_test.gd
RED_TEST: tests/knowledge_test.gd -> KNOWLEDGE failures=0 (24 checks)
REGRESSION: knowledge_test (its 11 checks today, kept unchanged), no_pronoun_test (scans every string in scripts/**)
VISUAL: no

## The job (keep every existing function's signature and behaviour; `range_of` is not changed)
1. Constants, added after `const FIRE_SPAR_CAP` (line 13) in Knowledge.gd, each line ending `# G`:
   `const KNOWN_SHARE := 0.6`, `const PIP_SHARES: Array[float] = [0.2, 0.4, 0.6, 0.75, 5.0 / 6.0]`, `const EPS := 0.0001`.
   In exposure that is 3, 8, 18, 36 and 60 (share s = e / (e + 12)).
2. `static func share_gone(k: Dictionary, group: String) -> float`, in THIS order: (a) 0.0 for a group not in GROUPS
   (`not GROUPS.has(group)`), even when `seen_all` is true; (b) 1.0 when `k.get("seen_all", false)`; (c) else
   `1.0 - (width(k, group) - FLOOR) / (_start_of(group) - FLOOR)`, clamped 0..1 with `clampf`. Fire reads the spar cap through
   `width` (spar alone tops at 12.5 / 24.5 = 0.51, so Fire is never known from sparring alone - that is the design).
3. `static func known(k: Dictionary, group: String) -> bool`: `share_gone(k, group) >= KNOWN_SHARE - EPS`. False for a group not
   in GROUPS (item 2a makes that so, also for an all_seen k).
4. `static func known_share(k: Dictionary) -> float`: the average of share_gone over "body", "skills", "fire".
5. `static func pip_of(k: Dictionary) -> int`: how many of PIP_SHARES `known_share(k)` has reached (each `>= s - EPS`), 0..5.
   fresh = 0, all_seen = 5. "pip" is a code name only: never put it in a string a player can read.
6. `static func shown(k: Dictionary, attr: String, truth: float, hype: float = 0.0) -> Dictionary`, in THIS order: (a) when
   `group_of(attr) == ""` (an attribute outside GROUPS): `range_of(k, attr, truth, hype)` with `"known": true` added (range_of
   already gives the exact answer there); (b) when `known(k, group_of(attr))`:
   `{"lo": truth, "hi": truth, "centre": truth, "width": 0.0, "known": true}`; (c) otherwise `range_of(k, attr, truth, hype)` with
   `"known": false` added. This is the one call screens use.
7. `stale` is not changed: a knockout cutting Fire below 18 makes Fire open again; the test proves that.

## Checks to add to tests/knowledge_test.gd (keep the 11 existing checks - 1, 2, 3a, 3b, 4, 5, 6a, 6b, 7, 8, 9 - unchanged, even
where they reuse a variable name in two loops; keep the print line `KNOWLEDGE failures=%d (%d checks)`; add the new test
functions' calls in `_initialize` after `_test9_control_can_fail()` and before the print)
On main every new check fails the same way: the test file does not compile (a parse error naming the missing static function -
known / share_gone / pip_of / shown - on Knowledge.gd), so Godot prints a SCRIPT ERROR and no KNOWLEDGE line at all.
EXACTLY ONE `_check` call per bullet label below (a label with two cases folds both into one bool): 13 new calls, 24 in all.
Use a new `K.fresh(<seed>)` (or `.duplicate()`) for each case; Fire exposure by "bout" unless the line says "spar".
- 10a Body: expose 17.9 "session" -> known false AND then +0.1 more (18.0) -> known true. 10b the same for Skills.
- 10c Fire: 500 "spar" only -> known false. 10d Fire: 12.5 "spar" + 5.5 "bout" -> known true AND 12.5 "spar" + 5.4 "bout" -> false.
- 11 share_gone equals e / (e + 12) within 0.0001 for e = 0, 0.5 ... 100 in body and skills, and never falls as e rises.
- 12 fresh: known false for all three groups; all_seen: known true for all three and share_gone 1.0; known(k, "potential")
  false for BOTH the fresh k and the all_seen k.
- 13a all three groups at the same exposure 3, 8, 18, 36, 60 -> pip_of 1, 2, 3, 4, 5; at each minus 0.05 -> one less (Fire by "bout").
- 13b fresh -> 0 AND all_seen -> 5. 13c body 18, skills 18, fire 0 -> pip_of 2 (average 0.4).
- 14 fire 18 by "bout" and body 18: stale "knockout" -> known fire false, known body still true.
- 15a known group (k with body 18 by "session", attr "strength"): shown gives lo = hi = centre = truth, width 0, known true
  (truths 0, 37.5, 100).
  15b open group (k with body 5 by "session", attr "strength", hype 0.0 and 0.7): shown's lo / hi / centre / width equal
  range_of's for the same k, attr, truth, hype (within 0.0001), and known is false.
- 16 control (can fail): the WRONG measure `(start - width) / start` says Body at exposure 18 is NOT known (0.5625 < 0.6),
  while share_gone says it is - the check passes only when both hold, so it can see the trap of item 2.

## Prior research
`python ops/Tools/prior_research.py known knowledge pips`: RPG_LAYER_MAP_S432.md section 8 (per-group speed, the pips and what each
does, the plain true number once known), CORE_LOOP_MAP_S432.md C12 (ONE range system = Knowledge.gd; "pip" is not a game word) and
its note "Knowledge.gd is called by no script". Also ops/research/TASK_KNOW1.md + KNOWLEDGE_S411.md (the built module's rules) and
ops/research/GDSCRIPT_TRAPS.md.

## What would a human do?
A coach knows a boxer's body after a few weeks of mornings, the craft after a couple of months of pads, and the heart only after
cornering them in real fights. Once you know, you stop guessing: the number is just the number. Code exactly that.

## Prefab check
None: our own rule on our own module.

## Rules
Godot only through `python ops/Tools/godot_slot.py run --who qwen -- <godot.exe> --headless --audio-driver Dummy --path . --script tests/knowledge_test.gd`
on the PC. Parse first with `--check-only --script res://scripts/rules/Knowledge.gd` and `res://tests/knowledge_test.gd`.
No file over 500 lines: Knowledge.gd is 149 now (about 200 after), knowledge_test.gd 285 (stay under 450). Do not add the test to
tools/run_tests.sh (it is already there). Change no other file. Never "he" or "she", in code or comments.
GDScript traps that apply: type every value from a call (`var s: float = K.share_gone(k, "body")`, never `:=` on a Variant);
in NEW code never declare one variable name twice in one function, even in two loops (GDSCRIPT_TRAPS.md calls it a parse
error; use `seed_a`, `seed_b`) - but leave the existing test 3 as it is; `%` in a format string
is `%%`; `k.duplicate()` before reusing a dict across cases (expose writes into it).
THE TRAP of this task: measuring the share on the whole start width (Body at 18 = 56%) instead of start - FLOOR, and comparing
floats at the exact boundary without EPS. Check 16 and 10a catch both.

## Result lines (PR body)
RESULT: tests/knowledge_test.gd -> KNOWLEDGE failures=0 (24 checks)
RESULT: tests/no_pronoun_test.gd -> NO_PRONOUN failures=0
Paste: share_gone at exposure 3 / 8 / 18 / 36 / 60 for Body, and Fire after 12.5 spar alone (expect 0.51).
