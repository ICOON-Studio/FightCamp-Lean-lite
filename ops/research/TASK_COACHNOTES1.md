# TASK COACHNOTES1 - QWEN - the coach's notes card fills in as you get to know a fighter (Lean, fight model step 5)

Model: Qwen (qwen3-coder, --yolo). Discipline: boxing (demo). Repo: E:\FightCamp\Lean (NOT the old Game repo).
Workspace: your own worktree E:\FightCamp\wt\LEAN_COACHNOTES1 (branch qwen/coachnotes1). Commit there; do not push.

## Why
Every fighter carries 2 habits (`f["habits"]`, ids from `scripts/rules/FighterProfile.gd` HABITS) and a personality
(`f["personality"]` = {heart, temper, confidence, discipline, coachability, loyalty}: 30..85). The player should LEARN
them, not read them off a sheet: a coach's notes card per fighter fills in with the coach's own words as he sees her in
sparring and fights (docs/FIGHT_MODEL.md "How the player learns it"). Kalli wrote the words in
`assets/data/fight_habits.json`: each habit has 3 `notes` lines; `trait_notes[<trait>]` has a `high` and a `low` line.
You write ONE pure module that decides what the coach has seen and the card's lines. Claude wires it into the screens.

## Owned files (create both; touch nothing else)
- `scripts/rules/CoachNotes.gd` (new, under 200 lines, `extends RefCounted`, static functions only, ZERO preloads)
- `tests/coach_notes_test.gd` (new, `extends SceneTree`, same shape as `tests/habit_beats_test.gd`; print
  `COACH_NOTES failures=<n>`; quit(1 if failures else 0))

## The module
```
const HIGH := 70.0   # a trait at or above this is notable (the coach says the "high" line)
const LOW := 40.0    # at or below: the "low" line; in between the coach has nothing to say about it
const SPAR_ODDS := 0.35
## What can be seen of f: "habit:<id>" for each of her habits, "trait:<key>" for each notable trait (HIGH/LOW).
static func seeable(f: Dictionary) -> Array
## One event the coach watched. source "fight" | "sparring" | "film" (an opponent's tape).
## fight: reveals one unseen habit if any is left, else one unseen notable trait.
## film: reveals one unseen habit (traits never show on tape).
## sparring: with chance SPAR_ODDS reveals one unseen item (habits first).
## Stores ids in f["notes_seen"] (Array of strings, created if missing; never a duplicate). Returns the ids revealed now.
static func reveal(f: Dictionary, source: String, rng: RandomNumberGenerator) -> Array
## The card's lines in reveal order: [{"id": "habit:drops_right_after_jab", "line": "<Kalli's words>"}].
## A habit's line = one of its 3 notes, picked by abs(hash(str(f["id"]) + id)) % 3 (the same line every time for her).
## A trait's line = trait_notes[key]["high"] or ["low"]. bank = the parsed fight_habits.json Dictionary.
## Ids the bank does not know are skipped. `{name}` in a line becomes f["name"].
static func card(f: Dictionary, bank: Dictionary) -> Array
## "2 of 4 seen" for the card's header: [seen, seeable].
static func progress(f: Dictionary) -> Array
```

## Tests (all must pass; load the bank with JSON.parse_string(FileAccess.get_file_as_string("res://assets/data/fight_habits.json")))
Fighters: build them as plain Dictionaries (two that DIFFER - CLAUDE.md "never test identical fighters"):
A = {"id": "f1", "name": "Tess", "habits": ["drops_right_after_jab", "fades_late"],
     "personality": {"heart": 82.0, "temper": 35.0, "confidence": 55.0, "discipline": 60.0, "coachability": 72.0, "loyalty": 50.0}}
B = {"id": "f2", "name": "Grace", "habits": ["slow_starter", "wide_hook_tell"],
     "personality": {"heart": 45.0, "temper": 60.0, "confidence": 50.0, "discipline": 41.0, "coachability": 55.0, "loyalty": 65.0}}
1. A new fighter's card is empty and progress is [0, n]; A has 2 habits + 3 notable traits (heart, temper, coachability)
   = 5 seeable; B has 2 + 0 = 2 (no trait at or past the bounds).
2. reveal("fight") on A: 1st and 2nd reveal her two habits, 3rd-5th her three traits, 6th returns [] (nothing left).
3. reveal("film") never reveals a trait; reveal("sparring") over 1,000 seeds reveals something in 30-40% of first calls.
4. Never a duplicate in f["notes_seen"]; never an id she does not have; card lines come from the bank verbatim (after
   {name}); the same fighter gets the same habit line on every call.
5. An old save without "notes_seen" or "personality" or "habits" works (empty card, no error).
6. Unknown habit ids in f["habits"] are skipped by card() (no error).
Write test 1 first and see it fail (the module missing), then build the module.

## The one test command (from the worktree root)
```
"%LOCALAPPDATA%\Programs\Godot\Godot_v4.7.2-stable_win64.exe" --headless --audio-driver Dummy --path . --script tests/coach_notes_test.gd
```
NEVER the `_console.exe`. Output must show `COACH_NOTES failures=0` and no `SCRIPT ERROR`. A script error in
`_initialize` HANGS the run (quit is never reached): if there is no output in 60 s, kill it and fix the error.
Also run `tests/fighter_profile_test.gd` the same way (must stay green).

## Contract
OWNS: scripts/rules/CoachNotes.gd, tests/coach_notes_test.gd   (Lean repo)
RED_TEST: tests/coach_notes_test.gd -> COACH_NOTES failures=0
REGRESSION: fighter_profile_test
VISUAL: no (Claude wires the card into the fighter screen and checks a still)

## The one trap
GDScript `:=` on a Variant from a Dictionary is a parse error: `var line: String = str(row["high"])`. `hash()` can be
negative: use `absi(hash(...)) % 3`.

## Prior research
Kalli K-HABITS1 (old repo research/K_HABITS1_KALLI.md = Lean assets/data/fight_habits.json); Lean docs/FIGHT_MODEL.md
"How the player learns it"; HabitBeats.gd (S301) for the habit ids in play.

## What would a human do?
A real coach keeps a mental (or literal) notebook: after a fight he knows her tells; after weeks of sparring he knows her
temper and her heart; tape of an opponent shows habits, never character. One note at a time, in his own words.

## Prefab check
No asset or library: a small pure rules module over our own data file. None needed.
