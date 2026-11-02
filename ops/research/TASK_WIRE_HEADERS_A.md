# TASK_WIRE_HEADERS_A - the fighter's wants in the profile drawer header (Cursor)

Model: Cursor default (composer). Owner: Cursor. Stage S202. Queue row WIRE-HEADERS (part A of 3; B = Matchmaking stages
in the fight contract, C = FilmIdle in the film room - NOT in this task).

## Goal
The fighter-profile drawer (`Godot/scripts/ui/FighterReadoutPanel.gd`, rebuilt S202: one row of 9 vertical meters,
~392 px wide) shows, under the name/meta line, what the fighter WANTS right now - the pure module
`Godot/scripts/rules/Ambition.gd` (`Ambition.evaluate(facts) -> Array` of wants, strongest first; each want has
`id`, `title` e.g. "BETTER PURSE", `demand`, `patience_days`, `strength` 0.1-1.0). Behind a NEW switch `ambition_header`,
OFF by default. With the switch off the drawer is byte-for-byte what it is today.

## Spec
1. `GameState.gd` (19,187 lines - NEVER read whole; `sed -n 17880,17900p` shows the switch pattern):
   add `func is_ambition_header_on() -> bool: return bool(career.get("ambition_header", OS.get_cmdline_user_args().has("ambition_header")))`
   next to `is_hud2_on()` (~line 17888). Add `func ambition_facts(fighter_id: String) -> Dictionary` that builds the facts
   `Ambition.evaluate` reads (read `Ambition.gd` lines 30-144 for every key: `gym_cut_pct`, `purse_vs_peers`, `days_idle`,
   `has_booked_bout`, `shares_prime_ring_with_lower_ranked`, `wins`, `losses`, `draws`) from what GameState already holds
   (grep for the athlete record, booked bouts, last fight day, purse split). A fact GameState does not hold yet is LEFT OUT
   of the dict (Ambition then reads its safe default) - never invented. Write one comment per key naming its source.
2. `GymHallPanel.gd` `_open_profile_drawer` (line ~282): when `gs.is_ambition_header_on()`, pass
   `{"scout_level": 3, "wants": Ambition.evaluate(gs.ambition_facts(id))}` to `FighterReadoutPanelScript.build`.
3. `FighterReadoutPanel.gd` `_build_header` (line ~121) / `_assemble`: when `opts` has `wants` (an Array), add under
   `HeaderText/Meta` a node `HeaderText/Wants` (HFlowContainer) with one chip per want, max 2 shown (strongest first),
   chip text = `title`, colour `Ambition.COLOR_AMBER` when `strength >= 0.5` else `Ambition.COLOR_CONTENT`; chip tip
   (`UIKit.tip`, never `tooltip_text`) = `demand` + " - patience %d days". No wants -> one muted label "Content".
   The drawer must stay within `DEFAULT_WIDTH` (392 px) - chips wrap, never widen the panel.
4. Test `Godot/tests/wire_ambition_header_test.gd` (new, SceneTree, `_check` + `print("WIREAMBITION total=%d fails=%d")`):
   (a) switch OFF: built panel has no `HeaderText/Wants`; (b) switch ON with a fixture athlete idle 120 days and no bout:
   a chip "ACTIVITY"-titled want exists (use the real title from Ambition.gd), amber; (c) a content fighter shows
   "Content"; (d) panel `get_combined_minimum_size().x <= FighterReadoutPanel.DEFAULT_WIDTH + 0.5` with 2 chips;
   (e) MUTANT: temporarily make your chip builder ignore `strength` -> (b)'s amber check must FAIL; put it back.
   Two fixture fighters must DIFFER (stats, record, idle days) - never identical fighters.

## Owned files (only these)
- `Godot/scripts/ui/FighterReadoutPanel.gd` (~370 lines, read whole)
- `Godot/scripts/GymHallPanel.gd` (~850 lines; `_open_profile_drawer` ~282)
- `Godot/scripts/GameState.gd` (19,187 lines; ONLY the two new funcs near line 17888)
- `Godot/tests/wire_ambition_header_test.gd` (new)

## Gates (tier: script edited)
- Parse: `python Godot/tools/check_scripts.py <each touched .gd>` before any test.
- Focused: `Godot_v4.7.2-stable_win64.exe --headless --path Godot --script tests/wire_ambition_header_test.gd`
  (exe in `%LOCALAPPDATA%\Programs\Godot\`; NEVER the `_console.exe`).
- Regression: `python Godot/tools/run_tests.py --jobs 2 --only fighter_readout_panel,profile_drawer,drawer_host,ambition`
  - all green. The exit code alone is not a pass (SCRIPT ERROR / FAIL lines fail it).

## The one trap
`fighter_readout_panel_test.gd` and `profile_drawer_test.gd` pin node paths (`Header/HeaderText/Name`, `.../Meta`,
`HeadlineGrid/HeadlineCard_<key>/CardBody/Value|Bar|Label`). Add `Wants`; rename nothing.

## Prior research
`python Tools/prior_research.py ambition header wants`: HEADERS1_CENSUS.md (Qwen S199) lists the profile header as a
header with no mechanic behind it - this task is its fix. PERSONALITY_RESEARCH.md: "Gym Loyalty" is an ambition
(Ambitions.gd, a different, long-arc module - do not merge the two).

## What would a human do?
Football Manager shows a player's current concern as a short line on his profile ("wants a new contract") with the
detail on hover - one or two at most, coloured only when it is urgent. Same here.

## Prefab check
Godot built-ins only (HFlowContainer, Label, StyleBoxFlat via UIKit). No asset or addon.

## Rules
Work only in your worktree; commit and push branch `cursor/wire-headers-a` (never master, never HANDOFF.md, never
AgentComms/). Never open a window, image viewer or browser. Final message: the red output on master (your test before
the change), the green outputs, and which ambition facts GameState could NOT supply.
