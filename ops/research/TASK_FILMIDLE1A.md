# TASK FILMIDLE1A - the three idle film-room tasks (pure module + test) (S199)
Model: Qwen (qwen3-coder) - pure module, no UI, no GameState. Worktree E:/FightCamp/wt/NIGHTLY2. NEW branch qwen/filmidle1a:
`git fetch && git checkout -B qwen/filmidle1a origin/master` (leave other untracked files alone; commit explicit paths only).

## Owned files
- `Godot/scripts/rules/FilmIdle.gd` (NEW)
- `Godot/tests/film_idle_test.gd` (NEW)

## Spec (operator approved, board Q-S196-4, HEADERS2 item 7; source `research/LUDO_ROUND33_S198.txt` lines 359-371)
When no bout is booked the Film Room offers three tape reels. `class_name FilmIdle extends RefCounted`, pure static, no RNG, no GameState, no preloads.
Money is in dollars, days are whole numbers; the caller owns cash and the clock.
- `const TASK_SCOUT := "scout_top10"`, `TASK_MASTER := "master_tape"`, `TASK_SHORTLIST := "shortlist"`; costs as named consts: scout $120 per week,
  master tape $250 one-time; scout reveal 5 percentage points per day of the top-10 contenders' fog; master tape = 150 Mastery XP to ONE named style card.
- `static func header(booked: bool) -> Dictionary` -> unbooked: `{text: "FILM ROOM: DIVISION RECONNAISSANCE & ARCHIVE STUDY", color: "#38BDF8", reels: ["scout_top10","master_tape","shortlist"]}`;
  booked: `{text: "", color: "", reels: []}` (the booked-fight film board is someone else's).
- `static func scout_day(state: Dictionary) -> Dictionary` -> state `{fog: Dictionary}` where fog maps contender id -> reveal percent 0..100. One call = one day:
  every listed contender gains 5, clamped at 100; returns `{ok, state(new copy), revealed_ids(newly reaching 100)}`. Empty fog -> `{ok:false, reason:"no contenders"}`.
  `static func scout_week_cost(weeks: int) -> int` = 120 x max(weeks,0).
- `static func master_tape(state: Dictionary, tape_id: String, style_card: String, cash: int) -> Dictionary` -> state keys `owned_tapes: Array`, `mastery_xp: Dictionary`.
  Refuses (`ok:false`, reason text) when cash < 250, tape already owned, or style_card empty. On success: cash_after = cash - 250, `mastery_xp[style_card] += 150`,
  tape added to owned; returns `{ok, state, cash_after, xp_gained: 150}`.
- `static func shortlist(candidates: Array, our_rating: float) -> Dictionary` -> candidates = `[{id, name, rating}]`, EXACTLY 3 required else
  `{ok:false, reason:"pick exactly 3"}`. odds per candidate = clamp(0.5 + (our_rating - rating) / 100.0, 0.05, 0.95), rounded to 2 decimals; returns
  `{ok, lines: ["<name>: 63% to win", ...] (best odds first), best_id}`. Ties keep input order.
- Inputs are never mutated.

## Test `film_idle_test.gd` (extends SceneTree; prints `FILMIDLE total=N fails=M`; quit(1) on fail, never quit(0) on pass)
(a) header booked vs unbooked exact text/colour/reels; (b) scout: 20 days takes a 0% contender to 100 exactly and reports it revealed on day 20 only, never above 100, empty fog refused,
week cost 0/120/360; (c) master tape: $249 refused, $250 ok leaves exact cash, second purchase of the same tape refused, xp accumulates across two DIFFERENT tapes on the same card (300);
(d) shortlist: 2 and 4 candidates refused, odds clamp at both ends (rating gap +60 -> 0.95, -60 -> 0.05), best_id correct, tie order; (e) no input mutated. Name 3 REAL mutants you ran red.

## Gates
`python Godot/tools/check_scripts.py Godot/scripts/rules/FilmIdle.gd Godot/tests/film_idle_test.gd`; then
`"%LOCALAPPDATA%\Programs\Godot\Godot_v4.7.2-stable_win64.exe" --headless --path Godot --script tests/film_idle_test.gd` -> exit 0, no FAIL, no SCRIPT ERROR.
Typed GDScript (never `:=` on a Variant); no reused local variable names in one function.
## Prior research
LUDO_ROUND33_S198.txt Header 7; scripts/DevelopmentPanel.gd / film room screen text "NO OPPONENT ON FILM" (read-only: where the dead header shows - grep it).
## What would a human do?
A coach with no fight booked watches tape of the division to learn who is coming, studies a classic fight to steal an idea, and ranks three possible opponents.
## Prefab check
None - our own rules.
## The one trap
Do not commit AgentComms/messages files or the existing untracked ones. Commit on qwen/filmidle1a, push; never master; never open windows, image viewers or browsers.
