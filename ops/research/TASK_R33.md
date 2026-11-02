# TASK R33 — THE BOOKING (Claude)

Model: Opus, effort high, Fast off. One session; end it when the stage ships.

Build stage. Greenlit by the operator 2026-09-06 after C18 landed.

## Why this exists

Two facts that turned out to be the same file.

1. **`FightContractScreen.gd` (702 lines) is the last pre-kit screen in the
   game.** R21–R32 rebuilt every rail hub on `UIKit`; R28 retired the last
   pre-kit scenes. This one survived and still defines its own palette
   (`C_BG`, `C_PANEL`, `C_PAPER`, `C_ACID` … at `FightContractScreen.gd:16-25`)
   instead of `UITokens`. Only one other file does — `FightCampPanel.gd` (536),
   the profile tab, which is NOT in this stage.
2. **Booking is where the C18 survey found our biggest read gap.** We price the
   terms and never grade the proposition. Pound for Pound grades every bout it
   offers and prints the reasons as chips; our screen shows money and clauses
   and never says whether the fight is a good idea.

Converting a screen means re-deciding its layout anyway, so the grade goes in
on the same pass rather than being retrofitted later.

## Scope

**In:** the booking board and the bout agreement, rebuilt from the kit, with the
grade on the board and the gate projection surfaced.

**Out:** `FightCampPanel.gd` (its own later stage), the fight scene and C17's
gates (deferred by the operator, and nothing here touches them), any change to
`FightContract.gd`'s negotiation maths, any change to `get_fight_offers()`'s
generation rules.

## Dependencies, and how not to be blocked by them

- **C19** (Codex) adds `GameState.get_booking_board(athlete_id)` — the graded
  offers. `TASK_C19.md` has the dictionary shape.
- **K20** (Kalli) rules how it reads — verdict vocabulary, board vs drill-in,
  where the gate projection lives, whether the agreement stays a document.

Neither blocks the start. Work in this order:

1. **Convert first.** Rebuild the screen on `UIKit` + `UITokens` against the
   data that exists today. No new mechanics. The old palette constants die
   here. This is most of the stage and needs nothing from anyone.
2. **Splice C19** when it lands: the board reads `get_booking_board()` ONCE per
   rebuild, the way `ProfileRevampPanel` reads `get_fighter_card()`. The screen
   computes no verdict of its own. If C19 has not landed by the time step 1 is
   done, define the read behind one private method returning the shape from
   `TASK_C19.md` and swap the body when it arrives.
3. **Apply K20's rulings** before the layout is frozen. If K20 lands after the
   layout is built, treat its pick as a change list, not a rebuild.

## What must still be true afterwards

- The file `FightContract.gd` is untouched. The negotiation — `opening_terms` →
  `evaluate_proposal` → accepted / countered / walked away, the ceiling, the
  walk-away ratio, `MAX_ROUNDS` — behaves exactly as it does now.
- Weight-class and sex matchmaking still hold. They are rules, not advice, and
  they never appear as a reason chip.
- The route from `ScheduleHubPanel` still works
  (`ScheduleHubPanel.gd:21` `CONTRACT_SCENE`, and the note at `:899`).
- Every clause still prices through `FightContract.clause_cost()`, and the gate
  projection shown to the player is the same `gate_for()` the clause is priced
  against — one number, not two.

## Anchors

`FightContractScreen.gd`: `_build_shell` `87`, title `141`, page switch `352`
(`document`) and `358` (`plan`), the plan page guard `425`, the editable term
controls `44-58`. `FightContract.gd`: `gate_for` `88`, `money_on_table` `93`,
`clause_cost` `98`, `clause_summary` `113`, `is_main_event` `134`,
`rounds_for_tier` `138`, `opening_terms` `145`, `settlement_for` `214`,
`evaluate_proposal` `256`, `counter_reason` `298`. `GameState.gd`:
`get_fight_offers` `5146`, `get_rivalry_fight_offers` `6674`,
`get_champion_superfight_offers` `9440`, `get_division_rankings` `9359`,
the weekly-tick warning `10619`, `get_fight_week_card` `11792`. Kit precedent:
`ScheduleHubPanel.gd`, `RankingsHubPanel.gd`, `ShellChrome.gd`.

## Owned files

Added 2026-09-06 when `agent_comms.py done --task R33` had no section to gate
against and fell back to the anchor names.

- `Godot/scripts/FightContractScreen.gd` — the rebuild.
- `Godot/tools/render_booking.gd` — NEW, the renders.
- `research/R33_DIGEST.md` — NEW.

`FightContract.gd`, `GameState.gd` and `ScheduleHubPanel.gd` are READ ONLY
here; C19 owns the `GameState.gd` side.

## Parse gate BEFORE any test run

```
python Godot/tools/check_scripts.py Godot/scripts/FightContractScreen.gd
```

## Tests

Stage tests first, then the systems this touches, then the suite once:

```
Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tests/fight_contract_screen_test.gd
```

then `contract_negotiation_test.gd`, `contract_clauses_test.gd`,
`fight_contract_test.gd`, `booking_eligibility_visibility_test.gd`,
`organization_fight_offer_test.gd`, `schedule_hub_panel_test.gd`,
`ui_kit_book_test.gd`, and — if C19 landed — `booking_board_api_test.gd`.
Full suite in the background, reduced to a summary line, immediately before the
commit.

## Ship

Renders into `DesignLibrary/screens/booking/` by a `Godot/tools/render_*.gd`,
digest `research/R33_DIGEST.md`, one HANDOFF block (max 8 lines), push
`master`, then **end the session** — one session per stage.
