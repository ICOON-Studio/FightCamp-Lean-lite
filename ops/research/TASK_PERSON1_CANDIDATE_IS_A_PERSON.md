# TASK PERSON1 - every candidate fighter is a person: a style, one strength and one flaw in a sentence (design review finding 6)

Model: Qwen (qwen3-coder). Worktree E:/FightCamp/wt/GYM4D, branch qwen/person1 from origin/master (already checked out).
Tier: script edited + new test -> parse gate + the new test + `run_tests.py --jobs 2 --only candidate,interview,scouting_hub`.

## Prior research
`python Tools/prior_research.py candidate style strength flaw` -> DEMO_DESIGN_REVIEW_S172.md finding 6: "the first fighter is not a
person. Card v2 gives 1-20 numbers + band words + VS OUR GYM, but still no style/trait. Fix: ... each with a style and one strength +
one flaw in a sentence (D35 s7, s9 minute 3-8)."

## What would a human do?
A coach describes a kid in one breath: "Pressure fighter. Hits like a mule, but he's gone by round four."

## Prefab check
None: a sentence from data the candidate row already carries.

## Owned files
- `Godot/scripts/CandidateCard.gd` (402 lines - read it whole). Add `static func person_sentence(row: Dictionary) -> String`:
  - STYLE: the plan name of `row["fight_plan"]` via `FightPlans.plan_by_id(id).get("name")` (preload `res://scripts/FightPlans.gd`;
    read it for the name key), capitalised, then "."; when there is no plan, "Style still to be read."
  - STRENGTH = his highest of the six FIGHTER_STATS (const at line 20; values in `row["stats"]`, 0-100 - check one row's shape with a
    print), FLAW = his lowest. Ties break in FIGHTER_STATS order. Words from a new const table, one plain phrase each, e.g.
    power "hits hard" / "no pop in his hands"; technique "clean and correct" / "sloppy shape"; speed "fast hands" / "a step slow";
    defense "hard to hit" / "gets hit too often"; conditioning "a deep tank" / "tires late"; fight_iq "reads the fight" /
    "fights on instinct". Sentence = "<Style>. <Strength, capitalised>, but <flaw>." e.g. "Pressure fighter. Hits hard, but tires late."
  - When strength and flaw are equal (all six stats equal), skip the clause: "<Style>. An even all-rounder."
  - Show it on the card: one line under the verdict sentence in `_identity` (find where `verdict_sentence` is drawn), same font as the
    verdict, colour T.TEXT_2, node name "PersonLine". Staff cards (is_staff) do not get it.
- NEW `Godot/tests/candidate_person_test.gd` (extends SceneTree, prints `CANDIDATE PERSON PASS`, quits 0; else `FAIL <why>`, quits 1).

## Acceptance (the one test)
`Godot_v4.7.2-stable_win64.exe --headless --path Godot --script tests/candidate_person_test.gd` -> `CANDIDATE PERSON PASS`, rc 0:
- hand rows: power 80 / conditioning 30 / rest 50 with a real boxing plan id from FightPlans -> "<Plan name>. Hits hard, but tires late.";
  defense 75 / speed 20 -> "Hard to hit, but a step slow."; all six 50 -> "... An even all-rounder."; no plan -> starts "Style still to be read.".
- THREE different generated candidates from a real career (copy the setup of tests/fight_camp_test.gd lines 84-95: begin_new_career,
  generate_starter_boxing_floor, finalize_new_career "Cyprus"/"Nicosia"; then read the recruitment rows the scouting hub shows - find
  the getter with `grep -n "func get_.*candidate\|func get_.*prospect" scripts/GameState.gd`): each sentence non-empty, <= 80 chars, and
  not all three identical.
- `CandidateCard.build(...)` for a fighter row contains a Label named "PersonLine" with that sentence; for a staff row it does not.
- MUTANT: make person_sentence return the strength word for the flaw too -> red. Say in the commit that you ran it.
Parse gate first: `python Godot/tools/check_scripts.py scripts/CandidateCard.gd tests/candidate_person_test.gd`.

## The one trap
GameState.gd is ~19,000 lines: grep and `sed -n` windows only, no edits. Headless Godot ONLY with `Godot_v4.7.2-stable_win64.exe
--headless` (never `_console.exe`). Open no images, browsers or windows. Commit with `git add -- <paths>`, push your branch, stop.
