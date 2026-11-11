# TASK TRAINREAD1 - QWEN (qwen3-coder) - the coach's read: which training each fighter needs, from the numbers and the style

Status: OPEN (S429, Claude main). WORDS (operator S429: "\"fix the hole\" i do not understand it , maybe use fix weakness ?"): the read is called `weakness`, never "hole", in code, lines and tests. Discipline: boxing. Model: qwen3-coder.
Source: the operator, S429: "on the new 3-4 fighter start try to use the guide to pinpoint different trainings according to
different ratings and styles of fighters". Design: ops/research/FOURSTART1_MAP_S429.md section 3. This task is the PURE rule
only. No screen, no guide wiring (a later Cursor task).

## Contract
OWNS: scripts/rules/TrainRead.gd, tests/train_read_test.gd
RED_TEST: tests/train_read_test.gd -> TRAIN_READ failures=0
REGRESSION: no_pronoun_test
VISUAL: no

## The module: scripts/rules/TrainRead.gd (extends RefCounted, pure static, under 200 lines)
Preload only: res://scripts/rules/TrainingPreview.gd (`headroom(potential, current)`), res://scripts/rules/Recruit.gd
(`CLASSES`: style -> [strength, weakness, the stat it is built on, the stat it lacks]) and res://scripts/rules/WeekCoach.gd
(`BUILDS`: stat -> morning session ids, `BUILDER`: stat -> the session's plain name). Read those three files first.

Constants (name them exactly; the test pins them):
`FIGHT_DAYS := 14`, `REST_FATIGUE := 70.0`, `WEAK_GAP := 6.0`, `WEAK_PACE := 1.0`, `WEAPON_PACE := 0.5`, `MAX_WORDS := 11`.
`TRAINABLE`: the keys of WeekCoach.BUILDS (a stat with no morning session, such as fight_iq, is never named).

`static func read(f: Dictionary, day: int, hurt: bool = false) -> Dictionary`
f is a fighter dict as the game keeps it: `first` (name), `style`, `pot` (int), `stats` {stat: float}, `fatigue` (float),
`bout` ({} or {"day": int, "opp": {"first": ...}}). It returns
`{kind, stat, session, session_name, say, why, pace, alt}` and never changes f. The rules, in this order:
1. `fight`: f.bout is not empty and 0 <= bout.day - day <= FIGHT_DAYS. stat "" and session "".
2. `rest`: hurt, or fatigue >= REST_FATIGUE.
3. `weakness`: among TRAINABLE stats take the lowest; if (the mean of ALL the fighter's stats - that stat) >= WEAK_GAP and
   headroom(pot, stat) >= WEAK_PACE -> that stat, session = WeekCoach.BUILDS[stat][0].
4. `weapon`: the style's built-on stat (Recruit.CLASSES[style][2]); if it is TRAINABLE and its headroom >= WEAPON_PACE.
   When the style is unknown or its built-on stat is not TRAINABLE, use the fighter's HIGHEST trainable stat instead.
5. `craft`: otherwise (every road is slow): pads, a new punch. stat "" and session "pads".
`pace` = the headroom of the named stat (0.0 when none). `alt` = {stat, session, pace} of the best OTHER trainable stat by
headroom (so the screen can say what the other choice gives); {} for fight and rest.

`say`: ONE line the old trainer says. At most MAX_WORDS words, it contains f.first, and it never uses he, she, him, her,
his, hers (tests/no_pronoun_test.gd scans every script's text: write the lines so no such word appears anywhere in the
file, comments included). Use these shapes, with the names filled in:
- fight: "<First> fights in <n> days. Keep the legs fresh."  (n = bout.day - day; "fights tomorrow" at 1, "fights today" at 0)
- rest: "<First> is worn out. A rest morning first."
- weakness: "<First>'s weakness: <stat words>. <Session name> first."
- weapon: "<First> wins on <stat words>. Sharpen it: <session name>."
- craft: "<First> is what the numbers say. Teach a new punch."
Stat words: power "power", speed "speed", technique "technique", defense "defence", conditioning "the engine", chin "the chin".
`why`: two short lines for the tooltip, numbers to two decimals:
"<Session name>: <stat words> +<pace> a week." then "<Alt session name>: <alt stat words> +<alt pace> a week." (one line
when alt is {}; for fight "Bout in <n> days: no building now."; for rest "Tiredness <n>: rest before more work.").

`static func kinds() -> Array` returns ["fight", "rest", "weakness", "weapon", "craft"].

## The test: tests/train_read_test.gd (extends SceneTree, prints "ok   " / "FAIL " lines, ends `TRAIN_READ failures=<n>`,
quits with code 1 on any failure; copy the shape of tests/rank_line_test.gd)
Fighters differ (never test identical fighters). Use these three from scripts/state/Data.gd (copy the numbers, do not load
Data): Lucy (Out-boxer, pot 84: power 58.4, speed 63.2, technique 60.1, defense 57.3, conditioning 61.6, fight_iq 59.0, chin
66.0), Samira (Slugger, pot 82: 66.0, 57.0, 54.5, 50.5, 60.0, 54.0, 63.0), Tess (Pressure fighter, pot 76: 62.0, 55.0,
58.5, 58.0, 64.0, 59.5, 67.0), same stat order. Checks, at least:
1. Samira -> weakness, defense, session WeekCoach.BUILDS["defense"][0], pace 1.25.
2. Lucy -> weapon, speed, pace about 0.83 (within 0.01).
3. Tess with a bout 10 days away -> fight, and say contains "10 days".
4. Tess with no bout -> craft (conditioning's pace 0.48 is under WEAPON_PACE).
5. Any fighter with fatigue 75 -> rest; with hurt = true -> rest; a bout 10 days away still wins over rest (fight first).
6. Samira with defense raised to 58.0 -> weapon, power (the read changes as the fighter changes).
7. A bout 15 days away is NOT fight; 14 days is; a bout in the past (day after bout.day) is not.
8. For every read above: say has at most 11 words, contains the first name, and none of he / she / him / her / his / hers as
   a whole word (case-insensitive); why is not empty; read() did not change f (compare a deep copy).
9. alt is another stat than the named one, and its pace equals TrainingPreview.headroom for it.
10. An unknown style ("Brawler") does not crash: weapon on the highest trainable stat, or craft.
11. Same input twice gives the same output.
12. Mutant proof, in the test itself: build a fighter exactly ON each threshold (gap 6.0 -> weakness; gap 5.9 -> not weakness;
    headroom exactly 0.5 -> weapon; fatigue 69.9 -> not rest).

## Prior research
ops/research/FOURSTART1_MAP_S429.md (the design and the four starters' expected reads), scripts/rules/GuideLines.gd (the
guide's voice: short lines, the name, no pronoun), ops/research/GDSCRIPT_TRAPS.md (Variant `:=`, `%%`).

## What would a human do?
A coach who takes over four boxers watches each for a round and says one thing: this one gets hit too much, that one must
keep the hands fast, the old one is ready to fight and needs no more miles. Different bodies, different work.

## Prefab check
TrainingPreview.headroom, Recruit.CLASSES and WeekCoach.BUILDS exist and are reused. No asset or library applies.

Run: `<godot.exe> --headless --audio-driver Dummy --path . --script res://tests/train_read_test.gd` and the same for
tests/no_pronoun_test.gd. Add `train_read_test` to the TESTS list in tools/run_tests.sh (after rank_line_test).
RESULT lines for the PR body: `RESULT: tests/train_read_test.gd -> TRAIN_READ failures=0` and
`RESULT: tests/no_pronoun_test.gd -> NO_PRONOUN failures=0`.
