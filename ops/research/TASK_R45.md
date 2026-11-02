# TASK R45 — THE POST-FIGHT SCREEN (Claude)

**Status: ASSIGNED 2026-09-07.** Depends on R38 (the three judges), C23
(`get_post_fight_read`), C25 (`get_scorecard_read`), C26/C29
(`get_belt_scale_read`), M4, M5 and M9. The eleventh legacy-replacement-era
screen stage, and the first that spends the read backlog instead of adding
to it.

Model: Opus, effort high, Fast off. One session.

## Why this exists

**Six read APIs are consumed by tests only.** `get_post_fight_read` (C23),
`get_scorecard_read` (C25), `get_gym_ledger_read` (C27),
`get_athlete_purse_read` (C28), `get_championship_read` (C26) and
`get_organization_read` (C24) have zero callers outside `Godot/tests/`. Five
Maria packs (M4, M5, M7, M8, M9) are drawn and unbuilt. The engine and the
art have run three cycles ahead of the screens.

The sharpest instance is the screen a bout ends on. `FightResultPanel.gd`
(R27, 415 lines) still prints C11's one-card result: a winner, a method, a
round count and a settlement. Since then the engine learned to score a bout
with **three judges** (R38 `JudgePanel.gd`) and to emit **UD / SD / MD and
three draw types** — and the screen says "DECISION". The range the fight was
argued over (R35–R37) is aggregated by C23 and thrown away at the door. R42
can block a belt and the result screen does not mention it.

**The seam is already open and costs nothing:** `FightNightScreen.gd` still
holds the live `_fight_state` at `_present_player_result()` (`:595`), one
line above the `payload_from_sim` call at `:596`. The post-fight read is one
call away from the panel that needs it.

## What to build

Deepen the existing panel. **This is not a new screen and not a rewrite** —
`FightResultPanel` keeps its frame, its ONE GREEN Continue, its route
contract and its four statics.

1. **Carry the reads onto the payload.** In `FightNightScreen._present_player_result()`
   (`:595`), before the route, put `get_post_fight_read(_fight_state)` (C23)
   and `get_scorecard_read(_result)` (C25) on the payload under their own
   keys. Both are pure reads; nothing is settled or advanced here.
2. **The judges' grid replaces the single card column.** `_build_scorecards()`
   (`:147`) currently walks `merged["scorecards"]` into
   `UIKit.scorecard_row()`. It becomes C25's `judges` array: N columns of
   per-round scores with the consensus row, the `disagreement_rounds` marked
   and the `swing_round` called out. M5 drew all of it —
   `DesignLibrary/screens/post_fight/m5_01`–`m5_06`, and `m5_05` is the
   one-judge layout every non-ten-point discipline still uses.
3. **The decision stamp says what the decision was.** C25 gives
   `decision_type` and `decision_label`; M4's stamp family
   (`m4_04_decision_stamps.png`, M5's R38 pass `m5_04`) covers UD / SD / MD,
   the three draws and the finishes. `describe()` (`:361`) must agree with the
   stamp — a split decision does not read "the judges cannot separate them".
4. **The range card, slotted.** C23's `range` block — per-round dominant band,
   `bout_band`, `bout_owner`, `owner_share` — in M4's slot
   (`M4_POST_FIGHT_READ.md` §Range card). This is the one place the R35–R37
   work is ever read back after the bout.
5. **The belt, when the scale blocked it.** If the payload's bout carries
   `title_blocked_by_weight`, say so with M9's mark
   (`DesignLibrary/screens/belt_scale/m9_*`): **LINK candour, not BAD, not
   AMBER** — a rule holding, not an error. No ceremony, no STRIPPED banner;
   R42 shipped none and this screen must not invent a tribunal.
6. **The honest empties.** M4 §Honest empties governs: a KO has no cards and
   says so; a bout with one judge is not dressed as three; a legacy result
   with no `cards` array is not backfilled with zeroes.

## Out of scope

- **No engine, no settlement, no scoring change.** Nothing in
  `FightSimulation.gd`, `RoundScoring.gd`, `JudgePanel.gd`, `PostFightRead.gd`
  or `ScorecardRead.gd` is edited. If a read is missing a field, name it in the
  digest as an engine gap — do not add it here.
- **No `GameState.gd` edits.** Codex holds the record-write region for C30
  this cycle. Every read this screen needs already has a wrapper.
- No new route, no new set-piece phase, no crowning change, no second
  Continue.
- Do not touch the ring itself beyond the payload lines at
  `FightNightScreen.gd:595`–`:612`.
- No judges as people — J1 ruled they are a panel, not characters, and M4/M5
  both refused faces. Judge 1/2/3 is the whole of it.
- No new UIKit variant unless one is unavoidable; if one is added,
  `ui_kit_book_test.gd` and `ui_kit_test.gd` stay green and the kit book is
  regenerated in the same commit.

## Files

- `Godot/scripts/FightResultPanel.gd`
- `Godot/scripts/FightNightScreen.gd` — the payload lines only.
- `Godot/scripts/UIKit.gd` — only if a variant is unavoidable.
- `Godot/tests/setpiece_panels_test.gd`

## Parse gate (before any test run)

```
python Godot/tools/check_scripts.py Godot/scripts/FightResultPanel.gd Godot/scripts/FightNightScreen.gd Godot/tests/setpiece_panels_test.gd
```

## Test

```
Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tests/setpiece_panels_test.gd
```

Then `setpiece_root_test.gd`, `scorecard_read_test.gd`,
`post_fight_read_test.gd` and `ui_kit_test.gd`, and the full suite once in the
background before the commit.

## Done

Digest `research/R45_DIGEST.md`, the HANDOFF block, push `master`. The
report ends with the headless test command above.
