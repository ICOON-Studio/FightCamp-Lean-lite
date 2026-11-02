# TASK_S18 — THE TRAINING MODIFIER MAPS DISAGREE, AND ONE TAG TRAINS NOTHING

Owner: Claude. Model: Opus, MEDIUM effort, Fast OFF. (Small, measured, two files.)
Queued by the operator's 2026-09-19 ruling: *"then the rest as per the pdf"* —
`R147_TRAINING_MAP.pdf` page 3, worked **top to bottom**. S17 delivered its
item 6 (durability/chin) because it was greenlit ahead of the list; this is
item **1**, the top of it.

**READ THIS FILE AND THE FILES IT NAMES. NOTHING ELSE.** Do not read
`HANDOFF.md` whole, `CURRENT_STATUS.md`, `HANDOFF_ARCHIVE.md` or any digest.

---

## R147 CALLED THIS "2 LINES". IT IS NOT, AND THE BRIEF IS WRONG ABOUT ITS SHAPE

`R147_ATTRIBUTES_AND_GAPS.md:151` says *"`grappling -> grapple`, `speed -> speed`
in `MODIFIER_TO_STAT` — 2 lines"*. **MEASURED 2026-09-19, and it is two
different bugs in two different maps.** Check the binding, not the brief (S14's
lesson).

**THERE ARE TWO MAPS, THEY ARE SEPARATE COPIES OF THE SAME KNOWLEDGE, AND THEY
DISAGREE:**

| map | `GameState.gd:166` `TRAINING_MODIFIER_STAT` | `AthleteStatModel.gd:67` `MODIFIER_TO_STAT` |
|---|---|---|
| what it drives | the REAL stat gain (`GameState.gd:4480`) | the caption the player reads (`canonical_stats_for_modifiers:267`) |
| `grappling` | **present** → `grapple` | **ABSENT** |
| `speed` | **ABSENT** | **ABSENT** |

So:

1. **`speed` trains nothing at all.** `arnis_safety_kit` carries
   `["technique", "speed", "defense"]`; the literal `speed` tag falls through
   `TRAINING_MODIFIER_STAT.get(..., "")` and is skipped at `:4481`. A real
   gameplay defect, one item.
2. **`grappling` trains correctly and is NOT captioned.** `modular_combat_mat`,
   `judo_tatami_area` and `grappling_dummy` all really do raise `grapple`, and
   the always-visible caption under-reports them. A presentation defect, three
   items.

**These are opposite failures and a single "2 line" edit fixes only one of
them.** Do both, and say in the digest which was which.

## THE ROOT DEFECT IS THAT THERE ARE TWO MAPS

Two hand-maintained copies of one vocabulary is why they drifted. **Consider
making `AthleteStatModel.MODIFIER_TO_STAT` the single source and having
`GameState` read it**, rather than adding the missing keys to both and leaving
the next drift to happen. `AthleteStatModel.gd` is already `preload`-safe
(`GameState.gd` reaches it today — check how before assuming). If the merge is
not clean, add the keys to both AND leave a comment on each map naming the other,
so the next reader cannot edit one alone.

## AN OPEN QUESTION — ASK, DO NOT SILENTLY DECIDE IT

`balance` (on `judo_tatami_area`, `["technique", "balance", "defense",
"grappling"]`) is in **neither** map. R147 did not name it and no ruling covers
it. It is NOT obviously any of the seven stats. **Do not add it on your own
judgement** — put it to the operator in one line, with the two candidates you
think plausible, and ship the rest without it.

The recovery-family tags (`recovery`, `mobility`, `minor_injury_care`,
`injury_rehabilitation`, `post_fight_recovery`, `low_impact_rehabilitation`,
`targeted_recovery`, `medical_assessment`) map to no stat **on purpose** — they
are recovery-category equipment. Leave them alone and do not "fix" them.

## R147's ITEM 2 IS UNVERIFIED — VERIFY BEFORE YOU FIX IT

R147 lists *"physical focuses ignore `station_legal_for_discipline` — ~5 lines"*
as item 2. **A grep on 2026-09-19 did not reproduce it**: the legality check is
applied at `GameState.gd:4609` (an explicitly chosen station), `:4620` (the
auto-pick loop) and `:4694`, each guarded only by `focus != "recovery"` /
`category == "recovery"`, which is correct. `PROGRAM_WORK_FOCUSES` is
`["ring", "bags", "strength", "cardio"]` (`:4513`).

So either R147 means a path none of those three cover, or the defect was fixed
after R147 was written. **Establish which before writing any code**, and if it
is already fixed, say so in the digest and move to item 3 rather than inventing
a change.

## OWNED FILES

- `Godot/scripts/GameState.gd` — `:166`, and the gain application at `:4470-4488`.
- `Godot/scripts/AthleteStatModel.gd` — `:67`, `:267`, and the caption builders
  at `:292` / `:304`.
- `Godot/assets/data/equipment_catalog.json` — READ ONLY unless the operator
  answers `balance`.
- new `Godot/tests/training_modifier_map_test.gd`
- new `research/S18_*`

## GATE (tier: a script edited)

```
python Godot/tools/check_scripts.py <each touched .gd>
python Godot/tools/run_tests.py --only training
python Godot/tools/run_tests.py --only equipment
python Godot/tools/run_tests.py --only athlete
python Godot/tools/run_tests.py --only gym
```
Then the FULL SUITE ONCE: `python Godot/tools/run_tests.py --timeout 2400 --jobs 3`,
**fails=6 or better as a CEILING**, failing FILENAMES matching
`AgentComms/last_suite.json` name for name. THREE jobs, not four (`nproc` is 4).
The suite is **308** tests as of S17.

**The test must assert the two maps AGREE**, key for key, and that every
`training_modifiers` tag in `equipment_catalog.json` either resolves to a real
`STAT_KEYS` entry or is a known recovery-family word — so the next tag added to
the catalogue cannot fall silently through both maps again. That single
assertion is worth more than the two key edits.

## THE TRAP SPECIFIC TO THIS TASK

`_apply_training_gain` (`:4478-4483`) deliberately de-duplicates by CANONICAL
STAT, not by tag — `"strength"+"power"` both map to `power` and must pay out
once per session, not twice. **Adding `speed` to the map changes what
`arnis_safety_kit` pays out**, so that station's session gain is a real
before/after number: measure it and put it in the digest, rather than asserting
the edit is inert.
