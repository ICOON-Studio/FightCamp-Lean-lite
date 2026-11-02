# TASK U56 — CURSOR — WHICH OF THE 287 TECHNIQUES ACTUALLY REACHES THE SCREEN

Model: Composer, medium effort. Owner: cursor.
Test tier: **MEASUREMENT TOOL — one new tool, one new report, no shipped `.gd`
behaviour changed.** Parse gate the tool, run it, and nothing else.
**Do NOT run the test suite** — it is twenty minutes, it is Claude's at
integration, and nothing you are doing can affect it.

```
python Godot/tools/check_scripts.py Godot/tools/measure_technique_demand.gd
Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tools/measure_technique_demand.gd
```

## Owned files

- `Godot/tools/measure_technique_demand.gd` — **NEW. Yours alone.**
- `research/U56_TECHNIQUE_DEMAND.md` — **NEW. Yours alone.**

Nothing else. Do not edit `FightClipBinding.gd`, `FightBeatAdapter.gd`,
`GameState.gd`, `HANDOFF.md`, or any existing test or tool.

## Why this exists

The operator's direction today: **"I want to see as many animations as possible,
make the fighters intelligent with many skills available to them."**

Here is what stands between us and that:

| | count |
|---|---|
| technique ids in `Godot/assets/data/technique_catalog.json` | **287**, across 18 discipline prefixes |
| of those, ids that resolve to a clip | **3** (`boxing_jab`, `boxing_cross`, `boxing_lead_hook`) |
| animation clips owned (Q47) | **160** |
| clips that could play if the vocabulary widened (Q56) | **102** |
| clips actually in use | **19** |

The resolution mechanism is already built and it is one line —
`FightBeatAdapter._clip_role_for` (`:556`) asks `FightClipBinding.has_clip(technique)`
under the **raw technique id first**, and only then consults
`TECHNIQUE_CLIP_ALIASES`. **So a `BINDINGS` key named exactly as an engine
technique id plays that clip, with no code change anywhere.** Widening the game's
visible vocabulary is a DATA edit.

**What nobody knows is which ids to add first.** A fighter only throws what they
have learned, the catalogue is 287 deep, and binding a clip to an id that never
fires buys nothing. **Measure the demand; do not guess it.**

## WHAT TO MEASURE

Drive seeded bouts through `FightBeatAdapter` — the same way
`Godot/tests/fight_beat_timing_test.gd` does (`_run_bouts`, `:101`, is the
pattern to copy, including its `_load_ruleset` and its two fighter dicts) — and
count **every technique id that reaches a presented beat.**

**Per ruleset**, not pooled only. A kick id that never fires in boxing and fires
constantly in kickboxing is two different findings, and pooling them hides both.
Cover at minimum `boxing`, `kickboxing`, `muay_thai` and `mma` if
`combat_rulesets.json` carries them; report which ones you actually found and
which you looked for and did not.

Use **at least 100 bouts per ruleset**, 3 rounds, and say what seeds you used so
the run reproduces.

### The table — one row per technique id that fired at least once

| technique id | ruleset | times presented | % of that ruleset's action beats | bound today? | `has_clip` | owned clip that could serve it |

- **bound today?** — `FightClipBinding.has_clip(id)` for the raw id.
- **owned clip that could serve it** — this column is the point of the study.
  Read the clip names from `research/Q47_INVENTORY.csv` (the authoritative
  inventory; do NOT read the asset folder) and name the file you would bind.
  `kickboxing_roundhouse` → `H2H_RoundhouseKick_InPlace.FBX` is the shape.
  **Where nothing we own fits, write `NONE OWNED` — that is a purchase list and
  it is worth as much as the matches.**

### Then three numbers stated plainly

1. **Coverage today** — what share of presented action beats already have a clip.
2. **Coverage after the top 20** — what share would have one if the twenty
   highest-demand unbound ids were bound to clips we already own.
3. **The ceiling** — what share could ever have one from the pack we own.

That second number is the one the operator is buying, so make it easy to find.

## Definition of done

- Both files exist. The tool runs headless and prints a machine-readable summary
  line: `U56_DEMAND rulesets=N ids_fired=X bound=Y coverage_now=A%% coverage_top20=B%% ceiling=C%%`
- Commit, push, and send one line:
  `python Tools/agent_comms.py send --from cursor --to claude --subject U56-done --body "<sha> ids_fired=X bound=Y coverage_now=A coverage_top20=B ceiling=C"`

## The traps specific to U56

1. **MEASURE THE ID THE PLAYER'S CLIP IS LOOKED UP BY, NOT THE PRETTY NAME.** A
   beat carries BOTH `technique` (the id, e.g. `kickboxing_roundhouse`) and
   `technique_name` (the human words). `_clip_role_for` resolves on the **id**.
   R103 shipped a presenter that reported `strike_head` while the player was
   actually holding `jab`, and the suite was green throughout — count the exact
   string the binding is keyed by, and print a few raw ids verbatim in your
   report so the mapping can be checked by eye.
2. **A beat with an empty `technique` is not a bug and must not be dropped
   silently.** The engine does not name a technique on every impact. Count those
   as their own row (`<unnamed>`) — that count is itself a finding, because it is
   the share of the fight that can never be improved by binding anything.
3. **Do not bind anything.** This task measures. `FightClipBinding.gd` is not
   yours and an edit to it here would collide with the follow-up that spends this
   study.
4. **Only one Godot may run at a time in this checkout.** Do not start a second
   one in parallel with your own run, and do not run the suite.
