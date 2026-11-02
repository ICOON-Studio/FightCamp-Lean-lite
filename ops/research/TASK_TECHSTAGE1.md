# TASK TECHSTAGE1 - technique mastery stages reach the live fight (slice 1 of the Ludo r46 verdict) - Codex

STATUS: APPROVED - operator board Q-S212-1 "Yes - build it as in the verdict" (2026-10-12 19:10Z).
Model: Codex gpt-6.1-sol, medium (multi-file engine work in FightRealtime).

## Goal
Every certified boxing move (25, `assets/data/certified_moves.json`) has a mastery STAGE 1-4 per fighter (LEARNED, DRILLED,
SPARRING-PROVEN, SIGNATURE), and the live boxing engine uses it, so a drilled move is visibly chosen more, thrown faster, lands
more and costs less stamina than an undrilled one. Behind a new switch `technique_stages` (GameSwitches + FightRealtime.DEMO_SWITCHES;
headless default OFF, as every switch).

## Spec
1. Pure module `Godot/scripts/rules/TechniqueStage.gd` (static, no autoloads):
   - `stage_of(record: Dictionary) -> int` from {reps, spar_rounds, fight_lands}: 1 by default; 2 at reps >= DRILLED_REPS (DESIGN 1,800);
     3 at 2 + spar_rounds >= 25; 4 at 3 + fight_lands >= 30. Constants at the top, labelled DESIGN.
   - `mods(stage: int) -> Dictionary` = {choice, speed, accuracy, stamina, tired_hold, counter_window, damage}, multipliers:
     stage 1 {0.45, 0.88, 0.88, 1.18, 0.55, 0.75, 0.90}; 2 {0.75, 0.95, 0.95, 1.07, 0.72, 0.90, 0.96}; 3 {1.0 x6 except tired_hold 0.88};
     4 {1.45, 1.06, 1.08, 0.88, 0.97, 1.20, 1.10}. (Verdict CHANGED: Ludo's stage-1 numbers were too punitive.)
   - `record_for(athlete: Dictionary, technique_id: String) -> Dictionary` reading `athlete["technique_stage"][id]`; when absent, a
     MIGRATION view: reps from `technique_progress[id].reps_completed` (+ move-card minutes x 3 from `MoveCards`, + pad-card mastery),
     spar_rounds from `technique_progress[id].live_rounds_completed`, fight_lands 0. A T1/T2 move never trained = stage 1.
2. FightRealtime: build `fighter["technique_stage_mods"] = {id: mods}` once at fighter build (next to `pad_card_progress`,
   FightRealtime.gd ~2270-2290) when the switch is ON; read it at the existing knobs - find them, do not invent new paths:
   move choice weight (FightIntent / the palette pick near FightRealtime.gd:4306 and FightMoves.gd:1231), strike speed/duration,
   hit chance, stamina cost, the fatigue gate (a stage-1 move only when stamina >= 1 - tired_hold band), counter/pad window
   (PadChains window, FightRealtime.gd:9462-9490 is the model for a per-move hook), damage. OFF = byte-identical log.
3. GameState: `athlete["technique_stage"]` written by training (AthleteDevelopment.gd:350-368 session progress adds reps; sparring
   adds spar_rounds) - keep `technique_progress` untouched (learning gate stays as is).

## Owned files
- `Godot/scripts/rules/TechniqueStage.gd` (new), `Godot/tests/technique_stage_test.gd` (new), `Godot/tests/technique_stage_fight_test.gd` (new)
- `Godot/scripts/FightRealtime.gd` (NEVER read whole: grep + `sed -n` windows around the anchors above)
- `Godot/scripts/AthleteDevelopment.gd` (lines 340-380), `Godot/scripts/GameSwitches.gd` (one key), `Godot/tests/game_switches_test.gd` (add the key)

## Acceptance
- `technique_stage_test.gd` (pure): stage thresholds, mods monotonic stage 1 -> 4 for choice/speed/accuracy/damage, stamina falling;
  migration from a technique_progress record; never-trained T1 = stage 1.
- `technique_stage_fight_test.gd`: two DIFFERENT boxers (different stats + plans, CLAUDE.md s5) where the tested one has
  boxing_slip_counter at stage 1 vs stage 4 (all else equal for that boxer), 200 seeded bouts each arm, switch ON: slip-counter lands
  rise within +30% .. +70% (bounded, never exact); total stamina spent on it falls; CONTROL arm with the switch OFF: stage 1 and 4
  logs byte-identical. Mutant: set stage 4 mods = stage 1 and see the band check go red.
Parse gate: `python Godot/tools/check_scripts.py <every touched .gd>`.
Tests: the two new tests headless (`Godot_v4.7.2-stable_win64.exe --headless --path Godot --script tests/<name>.gd`, exe in
%LOCALAPPDATA%\Programs\Godot\), then `python Godot/tools/run_tests.py --only technique,q226,switch_gate,pad_chain,certified,game_switches --jobs 2`
(ONE comma list; `--jobs 1` if the watchdog is not GREEN).

## Prior research
LUDO_ROUND46_VERDICT_S213.md + reply; G115_DRILL_MASTERY_RATES.md (log-hours, consolidation); C61_DIGEST (skill narrows, not only
raises); Q41_SKILL_AND_OUTPUT.md; Q226 strands (E3) as the bounded-edge precedent; PadChains/MoveCards (per-move mastery hooks).

## What would a human do?
A coach says "his slip is on pads, not in sparring yet" - stage names are coach words. A boxer throws what he has drilled; an
undrilled punch comes late and tired.

## Prefab check
No Godot asset models technique mastery in a fight sim; pure GDScript over our data.

## The one trap
FightRealtime.gd is huge and shared by MMA/kickboxing/muay thai: gate EVERY read behind the switch and the boxing ruleset, keep
the OFF log byte-identical (determinism tripwire), and never test two identical fighters.
Windows: no popups, never open images; `powershell -NoProfile -ExecutionPolicy Bypass -File Tools\pc_watchdog.ps1 -Once` before Godot runs.
Commit on codex/techstage1 and push.
