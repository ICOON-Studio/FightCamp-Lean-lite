# TASK R50TRAIT1 - QWEN (qwen3-coder) - every trait's lines: what it does now, the next line, and an upside as well as a downside (one pure module + its test)

Status: OPEN (S440, Claude main). Discipline: boxing. Model: qwen3-coder.
Mechanic: R50 "Recruit as an RPG card, trial first" (critics 7/8 and 5/7, average 6.75, ops/research/MECHANICS_BUILD_STATE_S440.md):
what is missing is "trait upside lines". Source: ops/research/RPG_LAYER_MAP_S432.md section 5 TRAITS: THEY MATTER AT LINES (lines
127-148: READ IT FIRST, it is the spec) and section 18's TRAITLINE1. The RPG layer map passed two critics at 7 and 7. Today a recruit
card shows two words (Recruit.GOOD / Recruit.BAD: "Listens", "Stubborn") and nothing says where a trait's effect starts, what the next
line does, or that a "bad" score can also help. THIS task is only the pure rule module: no screen (the Character tab is later), no new
hook in the fight (the two NEW lines are flagged, not wired).

## Contract
OWNS: scripts/rules/TraitLine.gd, tests/trait_line_test.gd
RED_TEST: tests/trait_line_test.gd -> TRAIT_LINE failures=0
REGRESSION: corner_jobs_test, push_back_test, recruit_test, fighter_profile_test, file_limits_test
VISUAL: no
NOT YOURS: every other file (tools/run_tests.sh too). Read, never edit: scripts/rules/CornerJobs.gd (111 lines: talk() 95-111, the
temper 65 / confidence 50 and 45 / discipline 60 lines), scripts/rules/PushBack.gd (107: LOW_DISCIPLINE line 21, HIGH_TRAIT 22),
scripts/rules/Exchanges.gd (372: uptake() 201), scripts/rules/Knockdowns.gd (138: REF_STOP 15, KO_ODDS 16), scripts/rules/Recruit.gd
(155: GOOD / BAD words 27-40), scripts/rules/FighterProfile.gd (170: TRAITS line 7).

## The job: scripts/rules/TraitLine.gd (pure, static, under 260 lines; preloads CornerJobs, PushBack, Exchanges, Knockdowns, Recruit)
THE FIVE: coachability, heart, confidence, temper, discipline (FighterProfile.TRAITS less loyalty, which is its own bar).
1. `const LINES`: per trait, rows {at, dir: "under"|"from", side: "up"|"down", word, does, source: "code"|"new"} (RPG map 5's table):
   - coachability: under 40, down, "Stubborn", "a corner habit fix holds half", new; from 70, up, "Listens", "the round's third shout
     lands in full too", new.
   - confidence: under 45, down, "Fragile", "the truth turns against them: -2", code; from 45, up, "Confident", "a hard talk never
     sinks the next round", code; under 50, up, "", "Fire up lifts +2.0, not +1.5", code (a low score's upside).
   - temper: from 65, down, "Short fuse", "Fire up turns wild (-2, hurt x1.6)", code; from 65, up, "", "Calm down works: +1", code.
   - discipline: under 45, down, "", "skips 1 alone morning in 3", new; under PushBack.LOW_DISCIPLINE, down, "Wanders off the plan",
     "pushes back on a Hard week", code; from 60, up, "Disciplined", "the truth works: +1.2, not +0.3", code.
   - heart: no line ("every 10 points count"): two rows with at -1, one up ("stays up: the referee's stop odds x(1.4 - heart / 100)")
     and one down ("stays down sooner: (1 - heart / 100) x 0.7 after a bad count"), source code.
   The numbers inside each `does` that the code holds are built from the code where a constant exists (PushBack.LOW_DISCIPLINE,
   Knockdowns.KO_ODDS); the inline literals in CornerJobs.talk have no constant, so the TEST proves each line against talk() itself.
2. `now(trait, v) -> Array`: the rows in force at value v ("under" means v < at, "from" means v >= at; heart's rows always).
3. `word(trait, v) -> String`: the strongest word in force (Recruit's GOOD / BAD words where the trait matches; "" when none).
4. `next_line(trait, v) -> Dictionary` {at, word, does, side, points}: the nearest line v has not crossed in the direction the trait
   grows with good work (up for coachability, confidence, discipline; DOWN for temper, where lower is better), whatever crossing it
   brings (the RPG map: "the NEXT line, what crossing it does"; `side` says whether crossing it is a gain or a loss, e.g. confidence 47
   -> at 50, the Fire up upside is lost); {} when none is left; heart: {}.
5. `crossed(trait, before, after) -> Array`: the rows whose state changed between the two values, each with {row, now: "in force" /
   "gone"}, for the Monday review ("coachability 40: corner fixes now hold in full").
6. `hover(trait, v) -> String`: the per-point effect: coachability "takes in <Exchanges.uptake(v, 0) x 100 rounded> in 100 of each full
   shout"; heart the two Knockdowns factors at v; others "".
7. `card(p) -> Array` of {trait, value, word, next}: one row per trait for a fighter's personality Dictionary.

## The test FIRST: tests/trait_line_test.gd (extends SceneTree, prints `TRAIT_LINE failures=N`, quits with N)
RED ON MAIN: run it on main first: the preload of the missing TraitLine.gd fails to load. Say so in the PR body. Assert at least:
- EVERY "code" line agrees with the code on both sides of it: CornerJobs.talk("fire", p) edge at confidence at-1 and at (2.0 against
  1.5); talk("truth") at confidence 44 / 45 and at discipline 59 / 60; talk("fire") hurt and edge at temper 64 / 65; talk("calm") edge
  at temper 64 / 65; the discipline "pushes back" line's `at` equals PushBack.LOW_DISCIPLINE (all read in the test);
- every trait of the five has at least one "up" row and one "down" row (the R50 ask: an upside as well as a downside);
- "new" rows are exactly the three the RPG map marks NEW (coachability 40, coachability 70, discipline 45);
- two DIFFERENT real prospects (deep copies of Data.PROSPECTS rows: Tess, coachability 36, and Kira, 84): word("coachability") reads
  "Stubborn" and "Listens"; card() differs between them;
- next_line: coachability 36 -> at 40, 4 points; 84 -> {}; temper 70 -> at 65 (downward), 5 points; heart -> {};
- crossed("coachability", 39, 40) names the Stubborn row as gone; crossed(39, 39) is empty;
- hover("coachability", 84) holds the number Exchanges.uptake(84, 0) gives, rounded in 100s;
- no pronoun in any `does`, word or hover string;
- MUTANTS inside the test: a copy of now() that reads "under" as `<=`, and a copy of next_line that ignores temper's downward
  direction, must each FAIL the same asserts; print `MUTANT caught` for each.

## Traps
- ops/research/GDSCRIPT_TRAPS.md first (typed Dictionary reads, no `:=` on a Variant, `%%` for a literal percent).
- The one trap: the table must not drift from the code. That is why every "code" row is proved against CornerJobs.talk / PushBack in
  the test, on both sides of its line; a row you cannot prove that way is marked "new", never "code".
- Words: game words for a player (Recruit's words), no pronoun, never "Engine" (it is "Cardio"). Do NOT delete or weaken any test.
- Write the PR body last, from the final run.

## Prior research
`python ops/Tools/prior_research.py trait line` -> RPG_LAYER_MAP_S432.md (section 5, the spec), topics/personality.md (the five traits and
their real basis), KALLI_RECEPTION_RPG_S354.md (the recruit card as an RPG card).

## What would a human do?
A coach sizing up a new boxer says "stubborn, but if he starts listening the corner will get through" and "hothead: never fire him up,
calm him down". Each trait cuts both ways, and the coach knows where it starts to matter.

## Prefab check
None: a table over the game's own corner rules, proved against them.

Test command: `"%LOCALAPPDATA%\Programs\Godot\Godot_v4.7.2-stable_win64.exe" --headless --audio-driver Dummy --path . --script res://tests/trait_line_test.gd`
(the plain win64 exe, never the console one). Parse first: `--check-only` on both files.
RESULT lines for the PR body: `RESULT: tests/trait_line_test.gd -> TRAIT_LINE failures=0`.
