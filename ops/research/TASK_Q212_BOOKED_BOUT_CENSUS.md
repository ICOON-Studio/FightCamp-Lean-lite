# TASK Q212 - The booked-bout census: measure boxing on the fights the GAME books

Owner: Qwen (qwen3-coder, medium, `--yolo`). Worktree `C:/Users/user/AppData/Local/Temp/FightCamp-Q212`, branch `qwen/q212-booked-census`.
Tier: NEW TOOL ONLY - no game script edited. Parse gate + running the tool. No test run, no suite.
Advances: ACTIVE MILESTONE "PLAYABLE WITH A BOXER" step 6/7 - "stoppages happen at a real rate" and the result reads as
boxing. Every boxing rate so far (Q211, U195) was measured on three HAND-PICKED even matchups, not the population the
player actually sees.

## Why
`tools/u195_engine_census.gd` pairs three differentiated but deliberately EVEN matchups. On master 22d71d18 it gives the
game arm KO+TKO 45.0% (BoxRec 47%, G108) and **draws 11.7% of all bouts**. G146 (`research/G146_BOXING_DRAW_RATE.md`)
found only a PROXY anchor: ~2-3% of all pro bouts draw. The draws are 4-4 round splits over 8 rounds, which even pairs
make likely. Real cards mix levels - and so do ours: `get_fight_offers` draws each opponent from a tier's `rating_range`.
So the honest question is: what do KO+TKO, draws and decisions look like on the bouts the GAME books?

## What would a human do?
A commission statistician does not grade judges on hand-picked even fights - they pull a season of real cards (every
bout the promoters actually made) and count methods by level. Same here: the population is the offers board.

## Prior research
- `research/G146_BOXING_DRAW_RATE.md` (draw anchor, PROXY 2-3% of all bouts; 10-10 ~1% of rounds)
- `research/G108_FINISH_RATES.md` (boxing KO+TKO 47%, finish bands by level)
- `research/Q211_DIGEST.md` (census method, the game arm's switches)
- searched: draw, draw rate, boxing, judges, scorecard, offers census

## Prefab check
None: this measures our own engine on our own matchmaking.

## Build - ONE new file `Godot/tools/q212_booked_census.gd`
1. Boot a career the way the walk does (`tools/s64_career_walk.gd` shows the autoload set-up; read it whole, it is small).
   Pick a boxing gym start. Do NOT hand-build fighters.
2. For N weeks (arg `weeks=`, default 40) take `GameState.get_fight_offers()` (`GameState.gd:7697`) for each roster
   boxer; for EACH offer build the two fighters exactly as the game does when that offer is booked and fought:
   `book_fight` (`GameState.gd:13239`), `get_booked_fight_opponent` (`:3126`), and the fight night's own
   `_realtime_begin_options` path (`FightNightScreen.gd:412/486/617`, calling `FightBeatAdapter.begin`). Reuse those
   functions - never re-derive stats. Advance the week without booking so the board refreshes (the offer rng is seeded
   by week). If booking mutates the career, book on a `duplicate(true)` or reload between bouts.
3. Run each bout headless with the GAME's switches (`FightRealtime.DEMO_SWITCHES`, as u195 does for `mode=all_on`) to
   the end. Print one row per tier and a pooled row: bouts, KO+TKO %, decision %, draw % (decision with empty
   `winner_side`), split/majority share, KD bouts %, mean rating gap. `GameState.gd` is 17,654 lines - never open it
   whole; `sed -n` windows at the anchors above only.
4. Name the population in the output (gym, weeks, tiers, catalogue `combat_rulesets.json`). NEVER identical fighters.
Deliver the numbers - do NOT tune anything. If the booked population cannot be built without editing a game script,
stop and name the blocker.

## SEND-BACK 1 (S119, Claude) - two defects in 03fca4bb, fix both, same branch
1. **The tool bypassed the game's ruleset fix.** `q212_booked_census.gd:30` hardcodes `get_ruleset("boxing")` for every
   bout. The GAME books each fighter under his OWN discipline's rules (`GameState.gd:1110-1123`, `_fight_camp_ruleset`,
   S65, operator rule 2026-09-12) - so your roster's Flyweight MMA and Flyweight wrestling men boxed bouts the game would
   never stage. Resolve the ruleset per athlete through `_fight_camp_ruleset` after `book_fight` (or the same
   WORLD_DISCIPLINE_RULESET lookup it uses), and count ONLY bouts whose resolved ruleset is boxing. Get more boxers by
   running more boxing gyms / starts or more weeks - never by relabelling. Print the population per row: discipline,
   weight class, n.
2. **"Single-judge boxing" is false.** Claude ran your tool with a print (weeks=3): every bout seats 3 judges
   (`state["_judges"].size() == 3`, 3 cards per round) and verdicts are typed `unanimous` / `unanimous_draw`
   (`JudgePanel.gd:152-167`; `RoundScoring.gd:59` gives ten-point-must 3 judges). Find what your counter read, fix it,
   and print the decision_type histogram (unanimous / split / majority / unanimous_draw / majority_draw / split_draw).
   The question the census must answer: **how often do the three judges disagree** - Claude saw zero splits in 20 bouts.
Then re-run weeks=40 and rewrite Q212_DIGEST.md (same first-line format). Still: no tuning.

## Gate (tier: new tool only)
PC watchdog first (`Tools\pc_watchdog.ps1 -Once`; RED = stop). `python Godot/tools/check_scripts.py Godot/tools/q212_booked_census.gd`.
Run: `Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tools/q212_booked_census.gd -- weeks=40`
(exe in `%LOCALAPPDATA%\Programs\Godot\`). Zero `SCRIPT ERROR` in its log.

## Owned files
`Godot/tools/q212_booked_census.gd`, `research/Q212_DIGEST.md`. Read-only: everything else.

## Deliver
Commit and push to your branch; Q212_DIGEST.md first line `booked boxing: KO+TKO N%, draw N% (census pairs 45.0% / 11.7%)`,
then the per-tier table and the run command. One `python Tools/agent_comms.py send --from qwen --to claude --topic Q212 "<one line>"`.
Do NOT edit HANDOFF.md, do NOT push master. **Trap:** a fighter that skips the booking path (stats built in the tool)
measures the tool, not the game - the same way weight_cut_test once talked a delivery into changing the game.
