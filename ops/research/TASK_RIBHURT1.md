# TASK RIBHURT1 - QWEN (qwen3-coder) - a boxer whose ribs (or face) took a beating is likelier to come out with a rib injury (or a cut)

Status: OPEN (S434, Claude main). Discipline: boxing. Model: qwen3-coder.
Operator S434: "do ribs get hurt, if not when will it be fixed ?"

## The defect (read in today's code, S434)
The fight keeps a body map per corner (scripts/rules/BodyMap.gd: PLACES head, left_eye, right_eye, nose, left_ribs, right_ribs;
100 = fresh, lower = hurt; the bout result carries it as m["body_map"], read by scripts/state/AfterFight.gd:70-80 with
BodyMap.value(map, "a", place)). But scripts/state/Injuries.gd after_bout (~line 167-190) hands InjuryRoll.bout_roll only
{"places": {"head": clampf(100 - dmg x 2.2, 0, 100)}, ...}. So in scripts/rules/InjuryRoll.gd:
- bout_chance reads the worst place it is given: only the head;
- the face-cut rule (a cut weighs x2 when an eye or the nose is at or under FACE_CUT_LINE 35) never fires from a bout;
- the rib injury (BOUT_TYPES ["ribs", 10, 21, 35]) is one injury in ten whatever the ribs took.

## Contract
OWNS: scripts/rules/InjuryRoll.gd (bout_roll and one new constant; 194 lines), scripts/state/Injuries.gd (after_bout's places
only; 258 lines), tests/rib_injury_test.gd (NEW)
RED_TEST: tests/rib_injury_test.gd -> RIB_INJURY checks=5 failures=0
REGRESSION: injury_roll_test, injuries_test, injury_why_test, stand_down_wire_test, golden_path_test, attr_ten_test, camp_protocol_test
VISUAL: no

## The job
1. InjuryRoll: add `const RIB_HURT_LINE := 35.0` beside FACE_CUT_LINE and `const HURT_WEIGHT := 3` (a comment: S434 RIBHURT1).
   In bout_roll, beside face_cut: `ribs_hurt` = either "left_ribs" or "right_ribs" in places at or under RIB_HURT_LINE. When
   ribs_hurt, the ribs row weighs x HURT_WEIGHT in BOTH loops (exactly as cut does with face_cut; keep cut's x2 as it is).
   bout_chance is unchanged (it already reads the worst place it is given).
2. Injuries.after_bout: build `places` = {"head": <today's formula>} and, when m has a non-empty "body_map" with an "a" side,
   add left_eye, right_eye, nose, left_ribs, right_ribs from BodyMap.value(m["body_map"], "a", place) (preload BodyMap). Use
   the same `places` dict for bout_roll and for bout_cause (both calls today build the head dict twice: build it once).
   Never change the head formula or the head-stoppage path.
3. Measure (print it in the test and paste it in the PR body): over seeds 0..9999, a bout with head 70 and every other place
   100, against the same bout with left_ribs 20: the injury chance, the share of injuries that are ribs, and that are cuts.
   And over the game path (item d below): how many of 2,000 seeded bouts end injured, before your change (Injuries passing
   only the head) and after. Report both; do not gate an exact count.

## The checks (tests/rib_injury_test.gd; extends SceneTree; copy tests/injury_roll_test.gd's shape; last line
`RIB_INJURY checks=%d failures=%d` counted, never typed)
a. bout_roll over seeds 0..9999 with places {head 70, left_ribs 20}: the ribs share of injuries is at least 2x the share with
   {head 70, left_ribs 100}.   <- RED on main
b. the face cut still works: {head 70, nose 20} gives a cut share at least 1.5x {head 70, nose 100} (unchanged rule, now
   reachable).
c. no body map (an old save, m without "body_map"): after_bout behaves exactly as today (same roll for the same seed).
d. the GAME path: Injuries.after_bout on a quick-start career (Career.quick_start(), seed fixed, Data.lucy as the fighter) with
   m = {"stopped": "", "outcome": "loss", "damage": {"a": 20.0}, "rounds": [1, 2, 3], "body_map": <a BodyMap map whose "a"
   left_ribs is 15>} over 400 seeds (vary c.seed): rib injuries come up at least 2x as often as with left_ribs 100.   <- RED on main
e. no new kind of injury and no days changed: every type rolled is in BOUT_TYPES, days inside its row.
Build the body map with BodyMap's own functions (read BodyMap.gd for how a map is made and a place set; do not hand-build its
inner dicts if a function exists).

## Prior research
`python ops/Tools/prior_research.py ribs "body shot" injury cut`: BodyMap / AIMWIRE1 (S432: the rib targets reach the fight),
J12_RECOVERY_AND_THE_YEARS.md and the S327 injury work (InjuryRoll rows and their days).

## What would a human do?
A coach whose boxer took a body beating checks the ribs after the bout; a boxer cut around the eyes gets the cut looked at.
The injury that comes out of a fight follows where the damage went.

## Prefab check
None: our own injury rows and body map.

## Rules
Godot only through `python ops/Tools/godot_slot.py run --who qwen -- <godot.exe> --headless --audio-driver Dummy --path . --script <script>`
(`<godot.exe>` = %LOCALAPPDATA%\Programs\Godot\Godot_v4.7.2-stable_win64.exe). Parse first with `--check-only --script res://<file>`.
No file over 500 lines. Do not add the test to tools/run_tests.sh. Keep every signature. Never he or she in text.
GDScript traps (ops/research/GDSCRIPT_TRAPS.md): type values read from a Dictionary; `%` in a format string is `%%`; one variable
name per function.
THE REGRESSIONS: injury counts in other tests may move a little (more places reach the roll). Run each before and after and paste
both lines. NEVER change another test's bar, seed or sample to make it pass: if one goes red, leave it red and report its numbers.

## Result lines (PR body)
RESULT: tests/rib_injury_test.gd -> RIB_INJURY checks=5 failures=0 (and the FAIL lines it read on main)
RESULT: the step 3 measurements (chance and shares; injured bouts of 2,000 before and after)
RESULT: tests/<each REGRESSION test>.gd -> <its pass line before> / <after>
