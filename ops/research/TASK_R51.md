# TASK R51 — THE YEARS TURN: A FIGHTER FINALLY GETS OLDER (Claude)

**Status: COMPLETE 2026-09-07 (R51a and R51b both landed).** The first stage of THE
YEARS. Owns the player's side of the clock. `WorldPopulation.gd` is C34's
this cycle and is not to be opened.

**SPLIT 2026-09-07, because C34 stopped on it.** Codex rebased, found no
`Godot/scripts/Aging.gd`, and correctly refused to author a second age curve.
So the module landed on its own, ahead of the pass that consumes it:

- **R51a COMPLETE** — `Godot/scripts/Aging.gd` + `Godot/tests/aging_test.gd`
  (35 checks). The published contract below is live and C34 is unblocked.
- **R51b OPEN** — the rest of this file: `_advance_aging` in `GameState.gd`,
  retirement arriving as an ask, the headlines, `get_aging_read`.

If the contract ever has to change, tell Codex the same day: two callers
share it now.

Model: Opus, effort high, Fast off. One session.

## Why this exists (verified 2026-09-07, not assumed)

- **Nothing in the codebase ever writes `age`.** It is generated once
  (`WorldPopulation._generate_athlete:552`, `rng.randi_range(18, 31)`) and
  read in a dozen projections. No fighter has ever had a birthday.
- **Nothing ever writes `status: "retired"`.** It is READ at
  `GameState.gd:5519` and `:5691` when picking opponents, and written
  nowhere. The retirement branch has been dead code since it landed.
- **`career.time.season` is written once** at `:2657` and read nowhere.
- The calendar year already works: `ShellChrome.date_parts(career_week,
  career_day)` (`ShellChrome.gd:33`) derives a real date from the epoch
  Monday 5 January 2026. **The clock turns; the people do not.**
- R14's career-goals note has said "retire-on-top waits for aging" since
  2026-09-04. This is that.

## Owned files

- `Godot/scripts/Aging.gd` — **new**, pure: statics only, no node access,
  no RNG (a birthday is derived, never rolled).
- `Godot/scripts/GameState.gd` — the pass and the read. **12,9xx lines:
  never open it whole.** Anchors below; read `sed -n 'A,Bp'` windows.
- `Godot/tests/aging_test.gd` — new.

**Do not touch:** `WorldPopulation.gd` (C34), `CareerEpilogue.gd` (G9), any
`*Panel.gd`. No screen this stage.

## Anchors in `GameState.gd`

| line | what |
| --- | --- |
| `2656` | `career.time` — `season`, `week`, `career_week`, `career_day` |
| `4758` | `advance_day()` |
| `4900` | `advance_week()` |
| `5519`, `5691` | the two `status == "retired"` readers |
| `6408` | `respond_to_request(athlete_id, action)` |
| `6577` | `_advance_requests(career_week, overrides)` — the ask system |
| `7043` | `_advance_rivalries(career_week, overrides)` — copy this shape |
| `10041` | `_push_news(headlines, week)` |

## The `Aging.gd` contract — C34 CONSUMES THIS VERBATIM

Fix it here and tell Codex if it ever changes.

```gdscript
static func birth_week_for(athlete_id: String) -> int              # 1..52, derived from the id, stable forever
static func band_for(age: int, discipline: String) -> String       # "maturing" | "peak" | "declining"
static func peak_window(discipline: String) -> Dictionary          # {"from": int, "to": int}
static func year_step(athlete: Dictionary, new_age: int) -> Dictionary
    # {"stats": {stat_key: delta}, "potential": delta, "band": String}
static func retirement_pressure(athlete: Dictionary, career_week: int) -> int   # 0..100
```

## Settled

- **A birthday is DERIVED from the id, never authored.** No save migration,
  and an existing save's fighters get birthdays spread across the year
  instead of the whole world ageing on 1 January.
- `_advance_aging(career_week, overrides)` joins the weekly pass beside
  `_advance_rivalries`, and takes an `overrides` dict so the test is
  deterministic (house rule).
- **The roster is never silently retired.** A fighter over the pressure line
  ASKS to retire through the existing request system and the player answers;
  nobody disappears from the roster without the player seeing it. World
  athletes are C34's and are not touched here.
- **Bounded.** No stat moves more than a small step per year, `potential`
  never rises after the peak window, and the dice of any existing system are
  unchanged. This stage must not alter a single fight outcome.
- Headlines through `_push_news`: a milestone birthday and a retirement get
  one line each; a routine birthday gets none — thirty birthdays would drown
  the feed.
- Read-only projection `get_aging_read(athlete_id)` for the screen a later
  stage will build. No screen, no new UIKit factory, no new token now.

## Parse gate

```
python Godot/tools/check_scripts.py Godot/scripts/Aging.gd Godot/scripts/GameState.gd
```

## Tests

```
--script tests/aging_test.gd
```

Then the systems the pass sits beside: `fighter_requests_test.gd`,
`retention_test.gd`, `career_goals_test.gd`, `daily_progression_test.gd`,
`athlete_development_test.gd`, `rivalries_test.gd`. Then the full suite ONCE
in the background before the commit.

## Done

Commit and push `master`, write `research/R51_DIGEST.md` (short),
convert this block in `HANDOFF.md` to COMPLETE, regenerate `TASKS.md`, and
tell Codex the `Aging.gd` contract is live with `agent_comms.py send`.
