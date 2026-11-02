# TASK S9 — CLAUDE — THE THREE-WAY PRESENTATION SPLIT: EXACT, SUBSTITUTE, DEGRADE

Model: Opus, HIGH effort, Fast OFF.

## Why this before any binding

The operator watched the first recording of the room and said the motion looked
terrible. `measure_technique_demand.gd` answers 30.3% coverage, and that number
**cannot say which complaint is true**, because the room resolves an action beat
THREE ways and coverage folds two of them together:

- **EXACT** — `has_clip` is true, `clip_role` plays. The beat shows what was thrown.
- **SUBSTITUTE** — `clip_missing` is set and `FightStagePlayer.NEAREST_CLIP` finds
  a stand-in, "the NEAREST we own". The beat shows the WRONG move (R127's
  watched-clip problem).
- **DEGRADE** — nothing plays, `presented_thrower_idle`, and **the man holds his
  guard while the engine says he threw** (`FightWorldLiveScreen.gd:718`). This is
  what reads as a frozen fighter. One HUD frame of the delivered recording shows
  `played 5 / degraded 5`.

A substitute is a binding-quality problem; a degrade is a missing clip, ours to
bind or a purchase. Different complaints, different fixes. Measure the split
first, bind second.

## The trap that ate an earlier attempt

`FightWorldLiveScreen._pump_to` SCHEDULES beats and does NOT present them.
`_named_plays` and `_degrades` are incremented in `_process` when a scheduled
entry comes due, so a probe that pumps a bout headless reads zero for both and
looks like a fight where nothing happened.

**So drive the split off `FightBeatAdapter` the way `measure_technique_demand.gd`
does.** The beat carries `has_clip` and `clip_missing`;
`FightStagePlayer.NEAREST_CLIP` plus
`bound_roles()`/`punch_roles()`/`technique_roles()`/`locomotion_roles()` decides
substitute against degrade with no room at all.

## Owned files

- `Godot/tools/measure_presentation_split.gd` — NEW. The instrument.
- `research/S9_PRESENTATION_SPLIT.md` — NEW. Its report (written by the tool).

Do not edit `FightClipBinding.gd`, `FightStagePlayer.gd` or
`FightWorldLiveScreen.gd` in this task. S9 measures; S9's step 2 binds.

## Anchors

- `Godot/scripts/FightWorldLiveScreen.gd:710-724` — the three states and the two
  HUD counters (`_named_plays`, `_degrades`).
- `Godot/scripts/FightStagePlayer.gd:979` — `NEAREST_CLIP`, 11 entries.
- `Godot/scripts/FightStagePlayer.gd:994` — `_thrower_clip`, the state machine.
- `Godot/scripts/FightStagePlayer.gd:188-207` — what is grafted, and therefore
  what a substitute may resolve to.
- `Godot/scripts/FightBeatAdapter.gd:815-821` (standing) and `:1031-1035` (ground)
  — where `has_clip` / `clip_missing` are written onto a beat.
- `Godot/scripts/FightWorldLiveScreen.gd:865` — a grapple beat is shown only when
  `FightClipBinding.is_paired(technique)`; there is no NEAREST for the ground.
- `Godot/tools/measure_technique_demand.gd` — the harness to copy, and the
  population to reuse.

## Population (NEVER IDENTICAL FIGHTERS)

Reuse `measure_technique_demand._pair()` verbatim, so the split is commensurate
with U56's own 30.3%: A is reach 183 cm, power 60 / technique 62 / speed 58 /
defense 55 / conditioning 60 / fight_iq 50 / grapple 40; B is reach 176 cm, power
55 / technique 48 / speed 62 / defense 58 / conditioning 70 / fight_iq 55 /
grapple 70. Neither carries a `technique_progress` record, so each is handed his
RULESET's whole tier 1-2 palette — both men are legal for every ruleset measured,
and they are differentiated by attributes inside it, never by removing techniques.
The report names the population AND the catalogue (`combat_rulesets.json`).

## What the report must contain

1. The five-way split over action beats, pooled and per ruleset: EXACT,
   SUBSTITUTE, DEGRADE, GENERIC (an unnamed beat playing its category role) and
   SILENT (a beat that claims a clip the player has not grafted — a tripwire that
   must read 0).
2. **The room-equivalent two-way line**, so the split can be read against the
   recording's own HUD: `played = EXACT + SUBSTITUTE + GENERIC`, `degraded =
   DEGRADE`.
3. The ground split separately: PAIRED against GRAPPLE DEGRADE. There is no
   NEAREST for a grapple beat.
4. The degrade queue — the ids that produce the frozen fighter, ranked.
5. The substitute table — which id is showing which other move, ranked.
6. Dead `NEAREST_CLIP` rows (a substitute whose id has since been bound exactly).

## Gate

Research tier plus the parse gate, because a new `.gd` is touched:

    python Godot/tools/check_scripts.py Godot/tools/measure_presentation_split.gd

No test is run: this task edits no script the suite loads, and a new tool cannot
break another test.

## Run

    godot --headless --path Godot --script tools/measure_presentation_split.gd
