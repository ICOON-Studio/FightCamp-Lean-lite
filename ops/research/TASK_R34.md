# TASK R34 — THE FIGHT CAMP (Claude)

Model: Opus, effort high, Fast off. One session; end it when the stage ships.

Build stage. Greenlit by the operator 2026-09-06, straight after R33.

## Why this exists

Two facts, and the second one is worse than the first.

1. **`FightCampPanel.gd` (536 lines) is the LAST file in the game minting its
   own palette.** `C_TEXT`, `C_MUTED`, `C_ACID`, `C_LINE`, `C_PANEL`, `C_CARD`,
   `C_GOOD`, `C_AMBER`, `C_DANGER` at `FightCampPanel.gd:24-32`, plus raw
   `BEBAS` / `MONO` preloads. R33 killed the other one. This is the end of the
   pre-kit era.
2. **FIGHT CAMP is unreachable in the shipped game.** The panel is mounted by
   NOTHING — `grep FightCampPanel` finds only its own test. It used to be a tab
   on `AthleteProfileScreen`, which R23 deleted. `ProfileRevampPanel`'s CAMP tab
   renders a read-only summary and its `START A CAMP` button calls
   `_want("camp")` (`ProfileRevampPanel.gd:1657` → `:557`), which does nothing
   but `set_meta("wants", ...)`. A dead end.

So an entire shipped system — FIGHT CAMP D1 (focus track, protocol, sparring
partner in a role matched to the opponent, visiting coach, film study, the
projection, the report card) and the WEIGHT CUT D2 diet plan that is chosen
inside it — has no way in. The backend runs every week
(`GameState._advance_fight_camps` `1148`) for camps the player cannot start.

## Scope

**In:** the camp surface rebuilt from the kit in all three of its states
(SETUP, PROGRESS, REPORT), and a real route to it from the profile's CAMP tab
so `START A CAMP` opens SETUP.

**Out:** any change to `FightCamp.gd`'s or `WeightCut.gd`'s maths; any change to
the weekly pass (`_advance_fight_camps`); the WEIGH-IN set-piece (R27 owns it);
new camp mechanics of any kind. This stage moves no numbers.

## Dependencies, and how not to be blocked by them

- **C20** (Codex) adds `GameState.get_camp_board(athlete_id, choices)` — the
  four camp reads plus the weight state folded into one, with the projection
  for a candidate set of choices. `TASK_C20.md` has the shape.
- **K21** (Kalli) rules how it reads — where SETUP lives, how a projection
  reads before you commit to it, the week log, the report card.

Neither blocks the start. Work in this order:

1. **Convert first.** Rebuild the three states on `UIKit` + `UITokens` against
   the reads that exist today (`get_fight_camp_options` `797`,
   `get_fight_camp_projection` `947`, `get_fight_camp` `1101`,
   `get_fight_camp_report` `1118`). The private palette dies here. No new
   mechanics. This is most of the stage and needs nobody.
2. **Wire the route.** `START A CAMP` must open SETUP. `_want()` is a dead end
   today; make the CAMP tab mount the camp surface the way the work tabs mount
   their panels (`ProfileRevampPanel._mount_panel` `1698`), or open it as a
   drill-in — K21 rules which, and step 1 does not depend on the answer.
3. **Splice C20** when it lands: ONE read per rebuild, the way
   `ProfileRevampPanel` reads `get_fighter_card()`. If C20 has not landed by
   the time step 1 is done, put the read behind one private method returning
   the shape from `TASK_C20.md` and swap the body when it arrives.
4. **Apply K21's rulings** before the layout is frozen. If K21 lands after the
   layout is built, treat its pick as a change list, not a rebuild.

## What must still be true afterwards

- The modules `FightCamp.gd` and `WeightCut.gd` are untouched. Every projected benefit,
  cost and injury risk is still computed by the same code that applies it
  weekly — the screen shows, it never calculates.
- Starting a camp still goes through `start_fight_camp()` (`1003`) and its
  validation (`_validate_fight_camp_choices` `966`); pulling out still goes
  through `end_fight_camp()` (`1087`); the counter pick still goes through
  `set_fight_camp_counter()` (`1058`) and is still only offered at film depth 3.
- The gym's specialist slots still gate the visiting coach
  (`get_fight_camp_slots` `750`, `FightCamp.slots_for_gym` `108`).
- The test `fight_camp_panel_test.gd` still passes. It loads the script directly and
  looks for stable node names — keep the names it names, or update the test in
  the same commit and say so in the digest.
- The facility is a **gym**. A fight camp is the preparation for a named
  opponent and nothing else; the word "camp" never refers to the building.

## Anchors

`FightCampPanel.gd`: palette `24-32`, `setup` `41`, `_rebuild` `51`,
`_build_setup` `78`, `_pick` `234`, `_pick_partner` `240`, `_on_start` `247`,
`_build_progress` `257`, `_on_counter` `387`, `_on_leave` `396`,
`_build_report` `406`, local drawing helpers `455-535`.
`ProfileRevampPanel.gd`: tabs `21-24`, camp dispatch `94`, card slice `186`,
tab badge `628`, `_build_camp` `1534`, `_fill_camp` `1540`, START A CAMP
`1657`, the dead `_want` `557`, `_mount_panel` `1698`.
`GameState.gd`: `get_fight_camp_slots` `750`, `get_fight_camp_options` `797`,
`get_fight_camp_projection` `947`, `start_fight_camp` `1003`,
`set_fight_camp_counter` `1058`, `end_fight_camp` `1087`, `get_fight_camp`
`1101`, `get_fight_camp_report` `1118`, `_advance_fight_camps` `1148`.
`FightCamp.gd`: `focus_tracks` `75`, `protocols` `83`, `partner_roles` `91`,
`counters` `99`, `slots_for_gym` `108`, `weeks_available` `120`,
`injury_chance` `141`, `projection` `224`, `edge_lines` `266`, `film_report`
`286`, `grade` `358`. `WeightCut.gd`: `diet_plan` `98`, `status` `134`,
`projection` `223`. Kit precedent: `ProfileRevampPanel.gd`,
`TrainingHubPanel.gd`, and R33's `FightContractScreen.gd` for a set-piece.

## Owned files

- `Godot/scripts/FightCampPanel.gd` — the rebuild.
- `Godot/scripts/ProfileRevampPanel.gd` — the route only; its other tabs are
  not in scope.
- `Godot/tools/render_camp.gd` — NEW, the renders.
- `research/R34_DIGEST.md` — NEW.

`FightCamp.gd`, `WeightCut.gd` and `GameState.gd` are READ ONLY here; C20 owns
the `GameState.gd` side. Any new kit instrument goes in `UIKit.gd` WITH its
`ui_kit_manifest.json` family and a re-render, the way R33 did — the kit book
parity test fails otherwise.

## Parse gate BEFORE any test run

```
python Godot/tools/check_scripts.py Godot/scripts/FightCampPanel.gd Godot/scripts/ProfileRevampPanel.gd
```

## Tests

Stage tests first, then the systems this touches, then the suite once:

```
Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tests/fight_camp_panel_test.gd
```

then `fight_camp_test.gd`, `weight_cut_test.gd`, `profile_revamp_test.gd`,
`office_nav_and_profile_overlay_test.gd`, `ui_kit_book_test.gd`, and — if C20
landed — `camp_board_api_test.gd`. Full suite in the background, reduced to a
summary line, immediately before the commit.

## Ship

Renders into `DesignLibrary/screens/camp/` by `Godot/tools/render_camp.gd`
(SETUP with a projection, PROGRESS mid-camp, REPORT, and the honest
"no bout booked" state), digest `research/R34_DIGEST.md`, one HANDOFF
block (max 8 lines), push `master`, then **end the session**.
