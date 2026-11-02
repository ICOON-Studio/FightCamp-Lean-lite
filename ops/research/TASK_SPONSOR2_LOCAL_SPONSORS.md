# TASK SPONSOR2 - a boxing club is sponsored by local businesses, never by fight organisations (K88, design review finding 9)

Model: Qwen (qwen3-coder). Worktree E:/FightCamp/wt/GYM4D (has the Godot import cache), branch qwen/sponsor2-local from origin/master.
Tier: script edited + test rewritten -> parse gate + `tests/sponsorship_test.gd` + `run_tests.py --only sponsor --only office_hub --only ledger --jobs 2`.

## Prior research
`python Tools/prior_research.py sponsor local business` -> J4/J5 (the gym's ledger: sponsorship is authored balance, no real deals).
Design of record: `research/K88_SPONSORS_KALLI.md` (Kalli, S182) - 15 fictional sponsors in tiers C/B/A/S, one condition each,
and the ruling "Fight organisations should never be weekly club sponsors; they book cards and pay purses."
The defect: a London boxing club was offered the "Cyprus Mixed Martial Arts Federation" as its sponsor, because `Sponsorship.gd` builds
offers from `real_organizations.json`.

## What would a human do?
A small club's sponsors are the coffee shop, the physio and the car garage on its street; they pay a small weekly cheque for a simple ask.

## Prefab check
None: data file + the existing pure module.

## Owned files
- NEW `Godot/assets/data/sponsors.json`: `{"schema_version": 1, "sponsors": [ {id, tier, name, kind, weekly_cash, condition: {type, target}, pitch} x15 ]}`
  copied from K88_SPONSORS_KALLI.md section 2, word for word (ids = snake_case of the name). Condition types:
  - "keep 2 fighters fit" -> `{"type": "available_roster_min", "target": 2}` (exists)
  - "a fighter on a card every 4 weeks" -> `{"type": "recent_fight_card", "target": 4}` (exists)
  - "gym reputation stays above N" -> `{"type": "reputation_min", "target": N}` (new)
  - "a win in the next 8 weeks" -> `{"type": "win_within", "target": 8}` (new: met while a gym win happened in the last 8 weeks, OR the
    contract is younger than 8 weeks - the deal gives you the 8 weeks first)
  - "no fighter fails a weigh-in" -> `{"type": "no_missed_weight", "target": 0}` (new: met unless a gym fighter missed weight during the
    contract)
- `Godot/scripts/Sponsorship.gd` (259 lines, read it whole): offers come from sponsors.json (loaded once, `load_catalog()`), filtered by
  tier reputation exactly as today; `weekly_cash` from the file (drop the TIER_WEEKLY_CASH roll); `organization_name` = sponsor name
  (keep the key - OfficeHubPanel reads it), plus `kind` and `pitch`. Drop the EntityPathway / outfitting / fighter_patches fields from
  the offer (organisations only). `condition_status` handles the three new types with a plain-words `label` ("HOLD GYM REPUTATION ABOVE
  25", "A WIN IN THE NEXT 8 WEEKS", "NOBODY MISSES WEIGHT"). Add `record_result(career, week, won: bool)` (stores `last_win_week`) and
  `record_missed_weight(career, week)` (stores `missed_weight_weeks` array). Keep `ensure_state/summary` signatures; the `catalog`
  argument is ignored for offers (leave a one-line comment why). Bump SCHEMA_VERSION to 2 (old saves re-roll offers; an ACTIVE old
  contract is kept as is).
- `Godot/scripts/GameState.gd` (~19,000 lines - NEVER read whole; only these two windows):
  `sed -n 15735,15742p` - beside `Sponsorship.record_fight_card(career, career_week)` add `Sponsorship.record_result(career, career_week, result == "win")`.
  `sed -n 2455,2470p` - where `missed_weight = true` is set, call `Sponsorship.record_missed_weight(career, int(career.get("time", {}).get("career_week", 1)))`
  (only for a gym fighter; read what the function has in scope).
- `Godot/scripts/OfficeHubPanel.gd` (`sed -n 805,880p`): the offer row shows the sponsor `pitch` as its second line (UIKit.tip on the
  name gives `kind`). Nothing else.
- `Godot/tests/sponsorship_test.gd` (241 lines): update the fixtures to the new catalog; keep every behaviour assertion that still applies.

## Acceptance (the one test)
`Godot_v4.7.2-stable_win64.exe --headless --path Godot --script tests/sponsorship_test.gd` -> its PASS line, rc 0, and it asserts:
- reputation 0 -> 3 offers, all tier C, every name in sponsors.json, NONE whose name contains "Federation", "Association", "Championship",
  "UFC", "ONE" or any `name` from real_organizations.json (load the file and compare).
- reputation 30 -> offers may include B, never A/S; reputation 100 -> S possible.
- each new condition type: met/unmet both ways (reputation 26 vs 24 for target 25; win_within: young contract met, week 10 with no win
  unmet, win in week 9 met; no_missed_weight: met, then record_missed_weight -> unmet).
- settle_week pays `weekly_cash` only when met.
- MUTANT: point the offers back at `catalog.organizations` -> the test goes red. Say in the commit that you ran it.
Parse gate first: `python Godot/tools/check_scripts.py scripts/Sponsorship.gd scripts/GameState.gd scripts/OfficeHubPanel.gd tests/sponsorship_test.gd`.

## The one trap
`GameState.gd` and its 19k lines: two 3-line edits only. Headless Godot ONLY with `Godot_v4.7.2-stable_win64.exe --headless` (never
`_console.exe` - it opens a terminal on the operator's screen). Open no images, browsers or windows. Commit with `git add -- <paths>`,
push your branch, stop. Claude reviews and merges.
