# TASK STORYMODE1A (S218) - story and guidance as two switches, 3 presets, one-way convert to sandbox (pure rules + test)

Model: Arena (cloud, free). Repo ICOON-Studio/FightCamp, base `master`. Work on your own `arena/...` branch, open a PR, NEVER merge.
No LFS-loading code or tests. Do not delete or shorten any existing test. Owned files: `Godot/scripts/StoryCampaign.gd` (338 lines,
read it whole) and a NEW `Godot/tests/story_mode_presets_test.gd`. Touch nothing else (NOT GameState.gd, NOT CreationFlowPanel.gd -
a later task wires the screens).

## Why
The CEO approved (board Q-S212-12, "Approve - build it") Ludo round 52 (`research/LUDO_ROUND52_VERDICT_S217.md`, read it): the
story can be skipped and the game played as a plain management sim, and the story IS the tutorial. Ludo's refinement: two
INDEPENDENT switches - STORY (mode "on" = campaign interrupts / "beside" = inbox only / "off") and GUIDANCE (on/off) - and
New Career offers presets. Leaving the story is ONE-WAY.

## Prior research
`LUDO_ROUND52_VERDICT_S217.md` (the spec + Claude's corrections), `StoryCampaign.gd` (today: `mode` on|beside|off, `default_state`,
`normalized`, `set_mode`, `resolve_defaults`), `Godot/tests/story_campaign_test.gd` (must stay green).
## What would a human do?
A game designer gives a new player a guided first season, a returning player the same story without hand-holding, and a sandbox
player every system on day 1 - and lets anyone walk away from the story without losing their gym.
## Prefab check
None - this extends our own pure story module.

## Do - in `StoryCampaign.gd` (keep every existing function's behaviour for existing callers)
1. State gains two keys: `"guidance": bool` (default true) and `"converted": bool` (default false). `default_state` and
   `normalized` carry them (a non-bool or missing value -> the default). Old saves without them load as guidance true, converted false.
2. Presets:
```gdscript
const PRESETS := {
	"house_that_holds": {"mode": "on", "guidance": true},     # recommended: story ON + guidance ON (Mara Solano, Calder House)
	"guided_sandbox": {"mode": "off", "guidance": true},      # no named cast, neutral checklist
	"open_sandbox": {"mode": "off", "guidance": false},       # every system open on day 1
	"campaign_veteran": {"mode": "on", "guidance": false},    # custom: replays without hand-holding
}
const PRESET_ORDER := ["house_that_holds", "guided_sandbox", "open_sandbox"]   # what New Career shows; veteran = custom
const DEFAULT_PRESET := "house_that_holds"
static func apply_preset(state_in: Variant, preset_id: String) -> Dictionary   # unknown id -> state unchanged (normalized copy)
static func preset_of(state_in: Variant) -> String   # the preset whose mode+guidance match, else "custom" ("beside" is custom)
static func set_guidance(state_in: Variant, on: bool) -> Dictionary   # allowed any time, also after convert
static func convert_to_sandbox(state_in: Variant) -> Dictionary
static func is_converted(state_in: Variant) -> bool
```
3. `convert_to_sandbox`: mode "off", converted true; `shown`, `done`, `flags`, `baseline`, `player_name` and `guidance` unchanged
   (records survive; the world is not touched). ONE-WAY: after it, `set_mode` and `apply_preset` can never make mode anything but
   "off" (apply_preset still applies the preset's guidance). Converting twice is a no-op.
4. BESIDE expiry (Ludo edge case): in mode "beside", a shown card whose default clock runs out is resolved NEUTRALLY by
   `resolve_defaults`: `done[id] = {"choice": "expired", "week": week}`, `flags["expired_" + id] = true`, and its `fired` entry has
   `"choice": "expired"` and `"effects": {}`. Mode "on" keeps today's behaviour (the card's default choice and its effects).
   Mode "off" fires nothing (as today).
5. `read()` in mode "off" returns `current` {} and `inbox` [] (story state stays, nothing is shown).

## Test - new `Godot/tests/story_mode_presets_test.gd`
`extends SceneTree`; prints `STORY_MODE_PRESETS_TEST PASS (<n> checks)` or `FAIL ...` lines; `quit(0)`/`quit(1)`. Blind, from THIS
contract. Ludo's tests 1, 2 and 6 at the rules level:
1. sandbox_zero_story: `apply_preset(default_state(), "open_sandbox")` -> mode off, guidance false; over 52 weeks of
   `resolve_defaults` + `read` with facts that make cards eligible, nothing fires, `current` {} and `inbox` [] every week.
2. abandon_story_state: a state with shown/done/flags/baseline/player_name -> `convert_to_sandbox` keeps them byte-identical
   (compare `var_to_str`), mode off, converted true; then `set_mode(s, "on")`, `set_mode(s, "beside")`,
   `apply_preset(s, "house_that_holds")` all leave mode "off"; `set_guidance` still toggles.
3. beside_card_expiry: mode beside, a card shown at week 1 -> at the expiry week `resolve_defaults` resolves it with choice
   "expired", flag `expired_<id>`, effects {}; the same card in mode "on" fires its default choice (today's behaviour).
4. Presets: each PRESET_ORDER id round-trips through `preset_of`; mode beside -> "custom"; unknown preset id -> unchanged.
5. Old save: `normalized({"mode": "on"})` -> guidance true, converted false; garbage values -> defaults.
6. Mutant checks inside the test (each must show the assertion would go red): (a) a convert that leaves `set_mode` able to turn the
   story back on; (b) a beside expiry that applies the default choice's effects.
Also keep `Godot/tests/story_campaign_test.gd` and `story_campaign_game_test.gd` green (CI runs changed tests only - run them in
your sandbox if you can, and say so in the PR).

## Gate (CI runs it)
Parse gate on the changed files, then `Godot_v4.7.2-stable_win64.exe --headless --path Godot --script tests/story_mode_presets_test.gd`
prints the PASS line.

## The one trap
GDScript: `normalized` must type-check before reading (`state_in is Dictionary`); use `bool(...)` only after checking the value IS
a bool (a string "false" is truthy). Do not rename or change the signature of any existing static func - GameState calls them.
