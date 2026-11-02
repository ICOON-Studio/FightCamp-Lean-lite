# TASK RECEPTION1B (S209) - the reception CHECK-IN APP: pure data module + the docked app panel (cloud Cursor)

Model: Cursor (cloud seat, GitHub issue label `cursor`). Repo ICOON-Studio/FightCamp, branch cursor/issue-<n>, PR into master; never merge.
The operator approved this screen (board Q-S207-2, answer "Approve all"): `research/LUDO_ROUND43_VERDICT_S208.md` section 6.
Ludo's pixel spec: `research/LUDO_ROUND43_S208_reply2.txt` from the line "6.1 Unattended Visitor Notification Banner" (~260) to
the end, and `research/LUDO_ROUND43_S208_reply3.txt` from the top to the line "7.1 Camera & Viewport Topology" (~170). Read only those.
This task builds the DATA and the APP PANEL. The banner, the 1.2 s camera glide to the desk and the in-game hook come in RECEPTION1C
(local, with stills) - do not build them here.

## 1. NEW pure module `Godot/scripts/rules/ReceptionCheckIn.gd` (extends RefCounted, static funcs, no scene, no autoload)
- `visitor_card(visitor: Dictionary, gym: Dictionary, seed_value: int) -> Dictionary`: the app's content for one walk-in. `visitor` is
  one arrival row from `Godot/scripts/WalkIns.gd` `day_schedule()` (read WalkIns.gd and `Godot/assets/data/walk_ins.json` for its keys).
  Fields: name, age, hometown, stance, weight_kg, division (from the weight - use the project's boxing divisions: grep
  `division` in `Godot/scripts/CompetitionData.gd`), aspiration one of FITNESS / AMATEUR BOXING / PRO DREAM (derived from the
  visitor kind + a seeded roll; say the mapping in a comment), membership_options = one row per archetype in
  `Godot/assets/data/members.json` that fits the aspiration, each {id, name, monthly_dues} taken from the json (NEVER Ludo's prices),
  quick_assessment {power, speed, stamina, chin} 1-100 seeded and bounded (a walk-in is untrained: cap 55, PRO DREAM may reach 65),
  trial_offer_allowed = aspiration != FITNESS.
  Names/hometowns: reuse the game's own name generator (grep `func random_name\|_name_pool\|first_names` in Godot/scripts - use what
  exists; read the window only). Deterministic for the same (visitor, seed).
- `attend(card: Dictionary, choice: String) -> Dictionary`: choice "membership:<archetype_id>" -> {kind:"member", archetype_id,
  monthly_dues}; "trial" -> {kind:"trial"} only when trial_offer_allowed; "decline" -> {kind:"none"}. Anything else -> {kind:"invalid"}.
- `ignore(card: Dictionary) -> Dictionary` -> {kind:"walked_out"}.
  Results are DATA only (the caller applies them to GameState in RECEPTION1C).

## 2. NEW panel `Godot/scripts/ui/ReceptionCheckInPanel.gd` (Control; built in code, no .tscn)
`static func build(card: Dictionary) -> Control` - the APP DOCK at Ludo's rect(1300, 40, 592, 1000) for 1920x1080 (reply2 6.3 + reply3
6.3 continued): header (name, age, hometown), stance / weight / division row, the aspiration selector (3 chips, the card's value
pre-selected), membership list (each option name + monthly dues as "$NN / month"), quick assessment bars, OFFER FIGHTER TRIAL button
(hidden when not allowed), ATTEND/DECLINE buttons, close (X). Signals: `chose(choice: String)`, `closed()`.
Style: the profile's tokens (`Godot/scripts/ui/ProfileTabsLayout.gd` colours; ChakraPetch + JetBrainsMono fonts that
`Godot/scripts/ui/ProfileOverview.gd` preloads). Ludo's polish values: reply4 "11.1".."11.3" (soft shadow, inner glow on the active
chip, hover lift 2 px). Real data only: every number on the panel comes from the card; no invented copy beyond Ludo's labels.

## Tests (no LFS models are loaded by either - CI can run them)
- `Godot/tests/reception_checkin_test.gd`: two DIFFERENT visitors (different kind/seed) -> different cards; same (visitor, seed) ->
  identical card; every membership dues value equals members.json; assessment within bounds for 200 seeded visitors; FITNESS never
  allows the trial; attend()/ignore() return exactly the documented dicts, "trial" on a FITNESS card -> invalid.
  Mutant check: write it so that changing the 55 cap to 99 in the module would make it FAIL (bounded assertion), and say so in the PR.
- `Godot/tests/reception_checkin_panel_test.gd`: build() for both cards headless -> the dock rect is inside 1920x1080 at
  (1300,40,592,1000); every Label text fits its rect (no clipping); the trial button is hidden for FITNESS and shown otherwise; pressing
  ATTEND with a membership selected emits chose("membership:<id>"); no Label contains "Lorem", "TBD", "$0".
- Parse gate: `python Godot/tools/check_scripts.py <new files>`. Acceptance: CI "Parse gate + changed tests" green on the PR.

## Owned files
NEW Godot/scripts/rules/ReceptionCheckIn.gd, NEW Godot/scripts/ui/ReceptionCheckInPanel.gd, NEW the two tests. Nothing else (read-only:
WalkIns.gd, members.json, walk_ins.json, CompetitionData.gd, ProfileTabsLayout.gd, ProfileOverview.gd).

## The one trap
Ludo's spec quotes membership prices and example people - bind to members.json and the walk-in row, never his numbers or names.

## Prior research
LUDO_ROUND43_VERDICT_S208.md s6, LUDO_ROUND42 reception idea (approved Q-S206-3), GYM4_REDESIGN_S178.md (walk-in pools), FrontDoor.gd desk maths.
## What would a human do?
A gym's front-desk tablet: who walked in, what they want, what it costs, one tap to sign them.
## Prefab check
None - project UI kit.
