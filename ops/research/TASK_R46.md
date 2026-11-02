# TASK R46 — THE DESK, THE MONEY (Claude)

**Status: ASSIGNED 2026-09-07.** Build. One file. Follows R45 in THE SCREENS
CATCH UP CYCLE and spends the same backlog: a finished read with no caller,
and a Maria pack drawn against nothing.

Model: Opus, effort high, Fast off. One session; end it when the stage ships.

## Why this exists

R45 spent C23 and C25 on the screen a bout ends on. **Four read APIs still
have no caller outside `Godot/tests/`**: `get_gym_ledger_read` (C27),
`get_athlete_purse_read` (C28), `get_championship_read` (C26) and
`get_organization_read` (C24). M10 landed the same day and drew the first two
as one desk — **the newest art in the project, against the oldest orphan
read.** That is this stage.

The gym's money surface is `OfficeHubPanel.gd`'s THE DESK tab, and it still
draws C9's `get_office_desk()` through `UIKit.desk_ledger()` — cash, three
payroll lines, a projected bill. Since then the gym gained **an inflow it has
never shown** (R44 membership, `count × rate`, both authored and the count
frozen by operator decision `e26823d`), C27 gave it labelled inflow/outflow
lines with `net_weekly` and a floored `runway_weeks`, and C28 broke the
fighter's purse open line by line. The desk shows none of it.

## Owned files

- `Godot/scripts/OfficeHubPanel.gd` (772 lines) — **the only script this
  stage may edit.**
- `Godot/tests/office_hub_panel_test.gd` — extend, do not rewrite.

**No `GameState.gd` edit of any kind. No `UIKit.gd` edit** — `desk_ledger()`
stays exactly as it is (the Kit Book renders it and its parity is tested);
R46 simply stops calling it and draws the gym week in the panel from tokens.

## Anchors

| What | Where |
| --- | --- |
| Tab consts, `MODULE_TABS` | `OfficeHubPanel.gd:48`, `:53` |
| `rebuild()`, where the reads are taken once | `:122` |
| `_build_desk()` — the region this stage replaces | `:215` |
| `_build_month()` — KEEP, unchanged | `:245` |
| `_build_sponsor()` — KEEP, unchanged | `:288` |
| `_build_desk_side()` — NEEDS ANSWERING alerts | `:364` |
| The reads | `GameState.gd:9692` `get_gym_ledger_read()`, `:9702` `get_athlete_purse_read(athlete_id)` |
| The art | `DesignLibrary/screens/books/m10_01..06*.png` |
| The rulings | `research/M10_THE_BOOKS_THE_SCREEN.md`, `M8_THE_BOOKS.md` |
| The reads' shapes | `research/C27_DIGEST.md`, `C28_DIGEST.md` |

## What to build

**THE DESK becomes M10's desk. Two wallets that are never totaled.**

**Left column (`LIST_W` 1030), top to bottom:**

1. **THE GYM'S WEEK**, from `get_gym_ledger_read()`, replacing the
   `UIKit.desk_ledger()` call at `:219`. Cash now; the labelled **inflow**
   lines including R44's membership; the labelled **outflow** lines (payroll,
   upkeep); **`net_weekly` as the centre of the block**, the largest number on
   it. Every line carries its source in the M8 grammar (below).
2. **RUNWAY** — `runway_weeks` as a countdown, **DIM when falling**; `-1` is
   *not falling* and reads MUTED/TEXT. No projection curve, no bankruptcy
   plate, no loan offer, no member trend, no sparkline.
3. **THIS MONTH** (`_build_month`) and **THE PARTNER** (`_build_sponsor`),
   unchanged, shifted down to fit. The gold **OPEN THE BOOKS** action stays —
   the desk still hands off to the contracts rather than restating them.

**Right column (`SIDE_X` 1050, `SIDE_W` 444):**

4. **THE FIGHTER'S PURSE**, from `get_athlete_purse_read(athlete_id)`:
   `wallet_now`, `career_earnings`, then the bout rows **newest first** —
   four gross lines, three deduction lines, one wallet credit. **A never-
   collectible manager share is a present `$0` row wearing ABSENT, never a
   missing row.** Logistics is named as **the fighter's own uncovered travel
   and accommodation** (J6 A1) — never a commission, a tax or a gym cut.
   Which fighter: a new `purse_id: String` (do **not** reuse `selected_id`,
   which belongs to the BOOKS tab), defaulting to the first fighter row of
   `get_office_books().contracts`, chosen from a surname chip strip of at most
   five; a `set_purse_for_test(id)` hook beside the other `*_for_test`
   helpers at `:747`.
5. **NEEDS ANSWERING** (`_build_desk_side`'s alerts) survives, compact, below
   the purse. It is the only thing on the desk allowed a warning colour, and
   only through `UIKit.alert_strip` as today.

**The M8 / M10 token grammar, held — do not reopen:**

| Role | Token |
| --- | --- |
| Evidenced (standing engine figure) | `TEXT` |
| Invented / AUTHORED chip (membership, sponsorship) | `LINK` |
| Absent (present `$0`, empty by refusal) | `MUTED` |
| Falling balance, falling runway | `DIM` |
| Shell tint | `GYM_DEFAULT` |

`SELECT` **does not exist** in `UITokens.gd`. GOLD, SODIUM, BAD, AMBER, GO and
GOOD are **unused on money** — including negative cash, where `desk_ledger()`
uses `BAD` today and this desk must not.

## Out of scope

- No `GameState.gd`, no `UIKit.gd`, no `.tscn`, no `assets/data/`, no new
  read, no write, no settle, no billing change.
- No combined total across the two wallets. No `gym_cut` on the purse.
- No membership growth, trend or projection — J8 N2/N3 froze the count and the
  screen must not imply it is about to move.
- No rail change, no new route, no tab rename: `MODULE_TABS` and the `books`
  tab id stay as they are (`CareerRoot.gd:48`, `SceneRouter.gd:101` depend on
  them).
- No runtime import of Maria's board PNGs. Code-drawn from tokens only.
- C24 and C26 are not this stage.

## Parse gate

```
python Godot/tools/check_scripts.py Godot/scripts/OfficeHubPanel.gd
```

## Test

```
Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tests/office_hub_panel_test.gd
```

Then the systems this touches — `sponsorship_test.gd`, `weight_move_test.gd`,
`objectives_board_test.gd`, `live_refresh_test.gd`, `gym_ledger_read_test.gd`,
`athlete_purse_read_test.gd` — and the full suite ONCE in the background right
before the commit.

## Done

Commit and push `master`, write `research/R46_DIGEST.md` (short), append
the Claude HANDOFF block, mark the task done with
`python Tools/agent_comms.py done --task R46`, and end the session.
