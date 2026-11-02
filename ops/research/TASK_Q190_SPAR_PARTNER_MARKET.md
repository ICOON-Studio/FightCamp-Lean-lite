# TASK Q190 - QWEN - THE SPARRING-PARTNER MARKET: HIRE A PARTNER WHO FIGHTS LIKE THE OPPONENT (S87)
Owner: qwen. Assigned S87, 2026-09-26. Model: qwen3-coder, medium, `--yolo`. Branch `qwen/q190-spar-partners`.
Worktree: `C:/Users/user/AppData/Local/Temp/FightCamp-Q164` (`git fetch origin && git checkout -B qwen/q190-spar-partners
origin/master`).

## Why
S87 shipped watchable gym spars between two of the player's OWN fighters, and your Q189 edge now reaches the engine
(merged - your byte-identity tool crashed on line 78, `scorecards` is an Array; Claude fixed it and re-proved 15/15 old vs
new. Next time run the tool and READ its output before quoting a number). S88 lets the player HIRE a sparring partner
when the gym has nobody of the right size or style (G120, `research/G120_VISITING_SPARRING.md`). This task builds
the market the S88 screen will call.

## What would a human do?
The head coach phones around or posts a spec: weight, stance, height, a style clone of the next opponent. He wants the
same class (+-1), equal or slightly better experience, and pays by level: amateurs trade rounds or pay a small drop-in,
regional pros take a day rate plus fuel, world-level partners take a weekly rate plus flights (G120 s1-2). A partner who
cannot legally be in the fighter's ruleset is not a partner.

## The contract (S88 calls this exactly - names, argument order, keys)
New file `Godot/scripts/SparPartnerMarket.gd` (`extends RefCounted`, static functions, preload only what it needs).
- `LEVELS := ["amateur", "regional", "world"]`
- `DAY_PRICE := {"amateur": [0, 80], "regional": [200, 600], "world": [400, 1200]}` (G120 s6, game cash per day).
- `static func candidates(fighter: Dictionary, spec: Dictionary, level: String, seed_value: int, count: int = 4) -> Array`
  `spec = {"stance": "orthodox"|"southpaw"|"", "height_cm": float or 0, "style": String or ""}` (the opponent to clone; empty
  keys = no preference). Returns `count` partners, each a FIGHTABLE athlete dict (the shape `FightRealtime.begin` takes -
  build it the way `FightOpponentGenerator.gd` builds an opponent) plus `"partner": {"level", "price_per_day",
  "travel_days", "match_pct"}`. EVERY partner: same sex as `fighter`, same discipline, weight class within +-1 of his,
  its own stats/name/height/reach (never two identical partners, never a copy of `fighter`), `id` prefixed `"partner|"`.
- `static func match_pct(partner: Dictionary, spec: Dictionary) -> int` 0-100: stance equal +40, height within 3 cm +30
  (linear to 0 at 12 cm), style equal +30; empty spec keys give their share in full. Sort `candidates` by it, best first.
- `static func price(level: String, days: int, roll: float) -> int` = lerp of `DAY_PRICE[level]` by `roll` x `days`.
- Deterministic for a seed.

## The work
1. The module above. `FightOpponentGenerator.gd` is the model for a fightable athlete - read it whole if under 600 lines,
   else `rg -n "func "` and windows.
2. Test `Godot/tests/spar_partner_market_test.gd`: legality (sex, discipline, +-1 class) over 3 rulesets x 3 levels x
   10 seeds; no two partners identical (stats + height + name); sorted by match; prices inside the bands; determinism
   (same seed twice == same list, the one legitimate same-seed use); and ONE spar per ruleset: a roster-shaped fighter vs
   his best partner through `FightRealtime.begin(... {"spar": "light", ...})` + `run_to_completion` runs with no script
   error and lands punches. Name the population in the output. Prove the test with two mutants (drop the class gate;
   return the fighter's own stats) and say they were caught.

## Owned files
`Godot/scripts/SparPartnerMarket.gd`, `Godot/tests/spar_partner_market_test.gd`, `research/Q190_DIGEST.md`.
Do NOT edit `GameState.gd` (16,700 lines - S88 wires the market in) or `FightRealtime.gd`.

## Tier
A NEW module and a NEW test, no existing script edited: parse gate (`python Godot/tools/check_scripts.py <files>`) and
the ONE test (`Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tests/spar_partner_market_test.gd`).
No suite. If `run_tests.py` in your worktree complains about imports, run the test directly and say so.

## Research
All research is open: root `RESEARCH_INDEX.md` (G120, G117). Do NOT read HANDOFF.md, CURRENT_STATUS.md or
HANDOFF_ARCHIVE.md.

## Done
Commit (explicit paths), push the branch, write the digest (population, a sample of 4 partners printed, mutants), then
`python Tools/agent_comms.py send --from qwen --to claude --topic Q190 --body "<legal n/n, mutants caught, sample>"`.

## The trap
"Different" means different, not a jittered copy: a partner built by adding +-1 to the fighter's own stats is the
identical-fighter fixture wearing a new name (CLAUDE.md, NEVER TEST IDENTICAL FIGHTERS). Generate each partner from his
own level and style, the way the opponent generator does.
