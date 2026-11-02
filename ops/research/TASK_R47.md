# TASK R47 — THE BELT ON THE BOARD (Claude)

**Status: ASSIGNED 2026-09-07.** Build. Third stage of THE SCREENS CATCH UP
CYCLE, and it spends the second-to-last orphan read against Maria's oldest
unbuilt pack.

Model: Opus, effort high, Fast off. One session; end it when the stage ships.

## Why this exists

R45 spent C23 and C25. R46 spent C27 and C28. **`get_championship_read`
(C26) is still called by nothing outside `Godot/tests/`**, and M7 THE BELT —
drawn 2026-09-06, eight boards — has never been built.

`RankingsHubPanel.gd`'s CHAMPIONS tab (`:395`) reads raw
`get_championships()` and hands five keys to `UIKit.belt_holder_row()`:
`label`, `holder_id`, `holder_name`, `vacant`, `note`. That is a holder list.
**It cannot say a belt is INTERIM, why it is vacant, how long the reign has
run, or how many times it has been defended** — all of which C26 already
returns, and all of which M7 already dressed. R41 writes `title_status` at
booking, R42 can vacate a belt at the scale, and the board still prints one
name or a blank.

## Owned files

- `Godot/scripts/RankingsHubPanel.gd` (621 lines) — the main file.
- `Godot/scripts/UITokens.gd` — **two new constants only** (see the ruling).
- `Godot/tests/rankings_hub_panel_test.gd` — extend, do not rewrite.

**No `GameState.gd` edit. No `UIKit.gd` edit** — `belt_holder_row()` stays
exactly as it is (the Kit Book renders it and its parity is tested); R47
stops calling it and draws the belt entry in the panel from tokens, exactly
as R46 did with `desk_ledger()`.

## Anchors

| What | Where |
| --- | --- |
| Tabs, `WEIGHT_CLASSES`, `DISCIPLINE_ORDER` | `RankingsHubPanel.gd:42`, `:44`, `:49` |
| `rebuild()`, where the reads are taken once | `:104` |
| `_build_champions()` — the region this stage replaces | `:395` |
| `_on_belt_row()`, `select_belt_for_test()` | `:506`, `:608` |
| `contract_for_test()` | `:557` |
| The read | `GameState.gd:9651` `get_championship_read(division_key)` |
| The read's shape | `ChampionshipRead.gd:7` `empty()` — every key it can return |
| The division key | `WorldPopulation.division_key(discipline, weight, sex)` |
| The art | `DesignLibrary/screens/championship/m7_01..08*.png` |
| The ruling | `research/M7_THE_BELT.md` |

## The token ruling — read this before drawing anything

M7 names four tokens that **do not exist in `UITokens.gd`**: `sodium`, `ice`,
`select` and `condition`. M10 already verified and recorded that **`SELECT`
does not exist**. This stage settles all four; do not re-litigate them.

| M7 role | What R47 does |
| --- | --- |
| Champion = SODIUM `#F2C14E` | **Add `const SODIUM := Color("#f2c14e")`** to `UITokens.gd`. M7's written argument holds: GOLD is M5's verdict word and a belt lives on the board all week. |
| Interim = ICE `#5EC8E0` | **Add `const ICE := Color("#5ec8e0")`** to `UITokens.gd`. Outline and dashed ring only — never a solid fill, never below-weight against the recognised name. |
| Title-bout flag = SELECT | **Refused.** `SELECT` does not exist and is not being invented. The flag wears `LINK`, the same mark R45 used for M9's belt-not-on-the-line. |
| Reign numbers = CONDITION | **`LINK`.** Countable instruments, not ceremony. No gold digits. |

**Those two constants are the ONLY lines this stage may add to
`UITokens.gd`.** No ramp, no variant, no edge colour, no re-spend of an
existing token.

Held from M7 and not reopened: **VACANT is a MUTED empty plate, never BAD.**
CHAMPION / INTERIM / VACANT are **not** mapped onto GOOD / AMBER / BAD —
those are M6's medical family. M6's **HELD** stays `BAD` and may sit beside
the recognised champion's name as *body* chrome; it is never used for
interim. GOLD and GO are unused in this pack.

## What to build

**THE CHAMPIONS tab becomes M7's division board.** One entry per weight
class, same skeleton in all three states — no layout jump.

Per entry, from `get_championship_read(key)`:

1. **The belt mark** — a fixed slot: solid `SODIUM` for `champion`, `ICE`
   outline plus dashed ring for `interim`, `MUTED` empty plate for `vacant`.
   **One mark per entry. Never two solid CHAMPION marks** (J3 Q3: the engine
   cannot hold two champions and the screen must not imply one).
2. **The division line** — `division_label`, as the read gives it.
3. **The status chip** — CHAMPION / INTERIM / VACANT, left severity bar in
   the entry's own token.
4. **The holder band, fixed height** — the recognised `holder` in `SODIUM`;
   when `is_interim`, the `interim_holder` on a **second line inside the same
   band** in `ICE`, copy "STANDING IN", never "ALSO CHAMPION" or "CO-CHAMP".
   A belt held out shows `champion_unavailable_weeks` beside the recognised
   name as M6 body chrome.
5. **The reign strip** — `defenses`, `since_week`, `last_defended_week` in
   `LINK`. A vacant-title win starting at zero defences is a real zero and
   reads as one.
6. **Honest empties.** `vacancy_reason` arrives as
   `{"value": "", "source": "absent"}` — **the read never infers why a belt
   is vacant and neither does the board**: an absent reason draws a `DIM`
   line saying the save does not record one. A world with no belt seeded
   keeps the existing "NO BELT HAS BEEN EARNED IN THIS WORLD YET". Never
   invent a champion, never keep a vacated name greyed in the holder slot.
7. **OPEN HOLDER survives** (`:397`) and stays the tab's one primary action.

## Out of scope

- No `GameState.gd`, no `UIKit.gd`, no `.tscn`, no `assets/data/`, no new
  read, no write, no title logic.
- No ceremony: no podium, no confetti, no UNDISPUTED language, no dual
  straps, no trophy case (M7).
- No real federation likeness — no WBC/IBF/UFC strap shape or wordmark
  (J1 §4.1).
- THE DIVISION and P4P tabs are not this stage. `TABS`, the route and the
  rail item stay as they are.
- No runtime import of Maria's board PNGs. Code-drawn from tokens only.
- C24 `get_organization_read` is the stage after this one.

## Parse gate

```
python Godot/tools/check_scripts.py Godot/scripts/RankingsHubPanel.gd Godot/scripts/UITokens.gd
```

## Test

```
Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tests/rankings_hub_panel_test.gd
```

Then the systems this touches — `championship_read_test.gd`,
`titles_rankings_test.gd`, `title_flag_test.gd`, `rankings_api_test.gd`,
`ui_kit_book_test.gd` (the token file moved) — and the full suite ONCE in the
background right before the commit.

**A belt with an interim holder is unlikely to exist in the seeded save.**
Install one in the test the way R46 installed a settled bout: write the
`title_status`, `interim_holder_id` and reign fields the engine already
persists, rebuild, assert, and clear it again. All three states must be
drawn by the test, not just the one the seed happens to hold.

## Done

Commit and push `master`, write `research/R47_DIGEST.md` (short),
append the Claude HANDOFF block, mark the task done with
`python Tools/agent_comms.py done --task R47`, and end the session.
