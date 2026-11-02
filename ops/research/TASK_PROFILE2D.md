# TASK PROFILE2D (S206) - the fighter profile's FIGHT RECORD, CONTRACT and CAMP tabs (new file ProfileTabsB.gd)

Model: Cursor (cloud seat, issue label `cursor`). Repo ICOON-Studio/FightCamp, branch cursor/issue-<n>, PR into master; never merge.
Companion: PROFILE2C (local Cursor, running) builds the 7-tab host + TECHNIQUES / MEDICAL / TRAINING PLAN and will CALL your three
builders - do not edit ProfileOverview.gd, ProfileTabs.gd, GymHallPanel.gd or GameState.gd.
Operator S206 (verbatim): "this session i want to see a proper player profile card with its subtabs fully completed and showing
everything that they should show". Design: Ludo round 41 TEXT spec - global shell + style tokens at the top of
`research/LUDO_ROUND41_S206_reply1.txt`; FIGHT RECORD = `LUDO_ROUND41_S206_reply2.txt` from "SECTION 4" to the end plus the
start of `LUDO_ROUND41_S206_reply3.txt` (4.2 continued); CONTRACT & MONEY = reply3 SECTION 5; CAMP = reply3 SECTION 6.

## THE RULE ABOVE LUDO'S SPEC: build his LAYOUT, bind only REAL data
Ludo's rects (inside the body area y 120..1064 at 1920x1080), colours (#0B0F17 bg, #121826 panels, #1E293B borders, #F8FAFC /
#94A3B8 text, #D69E2E gold, #22C55E green, #EF4444 red, #6366F1 violet), fonts (use the project's ChakraPetch + JetBrainsMono that
ProfileOverview.gd preloads - we have no Inter) and EMPTY STATES are the design. His values are examples; a field is shown ONLY when
a real read below supplies it, otherwise the element is left out. Never a placeholder number or an invented name. kg / $ only.

## Real reads (all on master - open each before use; GameState.gd is ~19k lines: read ONLY the windows given)
- FIGHT RECORD: `GameState.get_fight_log(id)` (GameState.gd:15896, `sed -n 15896,15916p`) -> rows built by
  `Godot/scripts/FightLog.gd`; `GameState.get_fight_record_stats(id)` -> `Godot/scripts/FightRecordStats.gd` summarize()
  (record, streak, form, purses, splits). The old profile's record tab shows how those rows are read: `ProfileRevampPanel.gd`
  lines 1882-2567 (`_build_record`: keys week, year, opponent_name, result, method, round, event_name, title_fight, purse,
  scorecard / judges / total_a / total_b, rival_name...). Scorecards only when the row has them; punch counts only if the row has
  them (FightLog / BoutRead) - else leave Ludo's "Punch Metrics" out.
- CONTRACT: `GameState.get_manager_contract_view(id)` (`sed -n 15298,15420p`), the fighter card's `request`
  (`GameState.get_fighter_card(id)`, `sed -n 16636,16760p`), and the old contract tab as the read reference:
  `ProfileRevampPanel.gd` lines 2568-3109 (`_build_contract`: weekly_salary, market_salary, wage_to_sign, weeks_remaining,
  expires_week, share_percent, expected_purse, request {kind, ask, deadline_weeks, actions}, promises_kept/broken). Buttons emit
  signals only: `respond_request(action_id)`, `raise_wage`, `propose_contract` - the caller wires them to GameState
  (respond_to_request / raise_athlete_wage / propose_manager_contract) exactly as the old panel does.
- CAMP: `GameState.get_camp_summary(id)` (`sed -n 1785,1840p`), `GameState.get_fight_week_card(id)` (`sed -n 18776,18860p`),
  scouting through `Godot/scripts/rules/ScoutFidelity.gd` and the opponent compare rows through
  `Godot/scripts/rules/OpponentCompare.gd` (merged today: rows(mine, theirs, opponent_id, scout_level), reach_line, summary);
  weight path through `Godot/scripts/WeightCut.gd` (status / limit_for / family_for / diet_plan). No bout booked -> Ludo's CAMP empty
  state ("NO ACTIVE FIGHT CAMP SCHEDULED" + an OPEN MATCHMAKER button that emits `open_matchmaker`).

## Build - NEW `Godot/scripts/ui/ProfileTabsB.gd` (`extends RefCounted`, static funcs)
1. `static func ctx_for(gs: Node, athlete_id: String) -> Dictionary` - the ONLY function that touches GameState (via has_method
   guards): returns {"fight_log", "record_stats", "contract_view", "card", "camp", "fight_week", "opponent", "scout_level",
   "weight_status"} for the three builders.
2. `static func record(athlete: Dictionary, ctx: Dictionary) -> Control`, `contract(athlete, ctx) -> Control`,
   `camp(athlete, ctx) -> Control` - each a Control sized to the body area (0,0 .. 1888x944 relative; the host positions it),
   laid out per Ludo s4 / s5 / s6 with real fields only, and each with its EMPTY STATE for a new signing (no bouts / no request /
   no camp). Signals are emitted from the returned root Control (add_user_signal) so the host can connect them.

## Acceptance (tier: new UI script)
- NEW `Godot/tests/profile_tabs_b_test.gd` (SceneTree `_initialize()`, prints `PROFILE_TABS_B total=N fails=M`, quit(1) on fail):
  build each tab from literal ctx fixtures for TWO DIFFERENT fighters - a veteran (11 bouts incl. a decision with three judges'
  cards, a KO loss, a title fight; contract with an open raise request and a deadline; a booked bout with scout level 2) and a new
  signing (no bouts, no request, no bout). Check: record shows W-L-D and one row per bout, newest first, the decision row's
  scorecard; contract shows salary, weeks left and the request with its action buttons emitting respond_request; camp shows the
  opponent, weeks to the fight and compare rows with "unknown" edges at scout level 1; every empty state text for the new
  signing; NO Label contains "lb", "Inter", "lorem", "Marcus", "Thorne" (invented names / units); ctx_for(null, "x") returns a
  Dictionary without crashing. RED on master first (missing script), then green.
- Parse: `python Godot/tools/check_scripts.py Godot/scripts/ui/ProfileTabsB.gd Godot/tests/profile_tabs_b_test.gd`; run the test
  `godot --headless --path Godot --script tests/profile_tabs_b_test.gd`; CI green on the PR. No LFS models (load_models false).
GDScript 4: type Variant returns (`var n: int = ...`), `const` not `static const`, `for x in arr`, `dict.has()`, `is_empty()`.
Never delete or shrink an existing test.

## Owned files
New Godot/scripts/ui/ProfileTabsB.gd, new Godot/tests/profile_tabs_b_test.gd. Nothing else.

## Prior research
LUDO_ROUND41_S206_reply1-3.txt (this design), LUDO_ROUND40_S205_profile.txt (empty states), LUDO_ROUND37_VERDICT_S202.md (no invented
numbers), the old ProfileRevampPanel record/contract/camp tabs (how the real data is read today).

## What would a human do?
Football Manager's History / Contract / Match Preparation screens: one frame, real numbers, honest blanks, every button a decision.

## Prefab check
None - project UI kit.

## The one trap
Ludo's spec names fields we do not store (gym_cut ledger waterfalls, sparring_load, punch stats per bout). Check each key exists in
the real read before drawing it - a missing key means the element is left out, not filled.
