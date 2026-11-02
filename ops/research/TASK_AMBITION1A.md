# TASK AMBITION1A - the four-axis fighter ambition engine (pure module + test) (S199)
Model: Qwen (qwen3-coder) - pure module, no UI, no GameState. Worktree E:/FightCamp/wt/NIGHTLY2. NEW branch qwen/ambition1a:
`git fetch && git checkout -B qwen/ambition1a origin/master` (leave other untracked files alone; commit explicit paths only).

## Owned files
- `Godot/scripts/rules/Ambition.gd` (NEW)
- `Godot/tests/ambition_test.gd` (NEW)

## Spec (operator approved, board Q-S196-4 header 4; source `research/LUDO_ROUND33_S198.txt` lines 284-296)
Today the profile shows "NOTHING HE WANTS RIGHT NOW - A CONTENT FIGHTER" for everybody. `class_name Ambition extends RefCounted`, pure static,
no RNG, no GameState, preload nothing. Every Monday the caller passes a fighter FACTS dict; the module returns the active wants.
- `static func evaluate(facts: Dictionary) -> Array` -> array of `{id, title, demand, patience_days, strength}` sorted by strength desc.
  facts keys (all optional, missing = not triggered): `gym_cut_pct` (0-100), `purse_vs_peers` (ratio, 1.0 = average), `days_idle` (days since
  last bout / no booked bout), `has_booked_bout` (bool), `shares_prime_ring_with_lower_ranked` (bool), `wins`, `losses`, `draws`.
  - want_purse: `gym_cut_pct > 25` OR `purse_vs_peers < 1.0`. Demand "A better purse split or a sponsorship renegotiation". strength = max of
    `(gym_cut_pct-25)/25` and `(1.0-purse_vs_peers)`, clamped 0..1; patience 30 days.
  - want_activity: `days_idle > 70` and not `has_booked_bout`. Demand "A fight booked within 21 days". strength = clamp((days_idle-70)/70,0,1); patience 21.
  - want_status: `shares_prime_ring_with_lower_ranked`. Demand "Exclusive afternoon ring access". strength 0.5; patience 28.
  - want_hardware: `wins >= 6 and losses == 0 and draws == 0` (a 6-0 record; more wins also counts while unbeaten). Demand "A regional title fight".
    strength 0.8; patience 18.
  Name every threshold/patience as a top-level `const`. A strength that is exactly 0 for a triggered want becomes the floor 0.1 (it is active).
- `static func header(wants: Array, days_left: int) -> Dictionary` -> `{text, color, active}`: no wants -> the current content line
  `"NOTHING HE WANTS RIGHT NOW  ·  A CONTENT FIGHTER"`, color `#7A8499`, active false; with wants -> strongest drive:
  `"ACTIVE DESIRE: DEMANDING <DEMAND UPPERCASE> (PATIENCE: <N> DAYS)"`, color `#F59E0B`, active true. Use the want's own patience minus elapsed
  days if `days_left` >= 0 passed, else its full patience; never negative.
- `static func resolve(want_id: String, accept: bool) -> Dictionary` -> accept: `{composure: +15, stamina_burn_mult: 0.90, days: 30, trait: ""}`;
  reject: `{training_focus_mult: 0.80, churn_risk_add: 0.15, trait: "UNSETTLED"}`. Unknown id -> `{ok:false, reason:"unknown want"}`; otherwise `ok:true`.

## Test - `Godot/tests/ambition_test.gd` (extends SceneTree; prints `AMBITION total=N fails=M`; quit(1) on fail)
(a) empty facts -> no wants, header is the content line, color #7A8499; (b) each of the four triggers fires at its boundary and not one step
below (gym cut 25 vs 26, idle 70 vs 71, 5-0 vs 6-0, a 6-1 record does NOT trigger hardware); (c) booked bout suppresses activity;
(d) two wants -> sorted by strength, header names the strongest, amber; (e) resolve accept/reject numbers exactly as above, unknown id refused;
(f) the input facts dict is never mutated. Name 3 REAL mutants you ran red (e.g. `>` to `>=` on idle, losses ignored, accept/reject swapped).

## Gates
`python Godot/tools/check_scripts.py Godot/scripts/rules/Ambition.gd Godot/tests/ambition_test.gd`; then
`"%LOCALAPPDATA%\Programs\Godot\Godot_v4.7.2-stable_win64.exe" --headless --path Godot --script tests/ambition_test.gd` -> exit 0, no FAIL, no
SCRIPT ERROR. Typed GDScript (never `:=` on a Variant). No reused local variable names in one function (even across blocks).
## Prior research
LUDO_ROUND33_S198.txt Header 4; scripts/DevelopmentPanel.gd:229 (read-only: where the content line shows).
## What would a human do?
A coach notices a fighter sulking: no fights for months, a bad purse split, never getting the good ring time, an unbeaten run with no title shot.
## Prefab check
None - our own rules.
## The one trap
Do not commit AgentComms/messages files or the existing untracked ones. Commit on qwen/ambition1a, push; never master; never open windows,
image viewers or browsers.
