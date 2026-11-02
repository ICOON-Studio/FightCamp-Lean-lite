# TASK BODYREACT1 - ZIVA - every landed body shot visibly hurts the boxer who takes it

Status: OPEN (S370, Claude). Seat: Ziva (Smart, effort max), worktree E:\FightCamp\wt\ZIVA_LEAN (on main 4c5e58b+).
Discipline: boxing (the demo).

## Why
Operator S369, watching Tess vs Amy live: "hits on body still no reaction from other fighter". He said it in S305
("body shots do not seem to have any impact") and S310 ("body shots still have no reaction"); both fixes are in the code
and he still cannot see them, so the job starts by measuring what the live fight really shows.

## What exists (read first)
- scripts/fight3d/BeatClips.gd:57-60 - a body hook's reaction clips (pro_hit_by_gutshot_v3, _v2_short, kidneyshot_v1,
  gutshot_v2, react_body).
- scripts/fight3d/HitSnap.gd:27-31, 86+ - a LANDED body shot folds her (trunk curl + elbow drop, FOLD_HOLD_S 0.45 s);
  a BLOCKED one is the elbow brace (BeatFire.gd:121).
- scripts/fight3d/BeatFire.gd:95-125 - where a landed punch fires its reaction; Exchanges.BODY_COST (the energy it costs).

## The job
1. A probe (NEW tools/body_react_probe.gd, headless like tools/clinch_check.gd, or windowed on the hidden desktop if it
   needs the picture): play 3 live rounds (the fight3d_play.gd flow) and for EVERY landed body shot (any punch whose
   target is the body: body_hook, body_cross, body jab, kidney...) print one BODYREACT line: the move, the reaction clip
   that played (or none), the trunk curl in degrees at its deepest, the hips' backward travel (m), the time from contact
   to the first visible move (s). Then BODYREACT_SUMMARY with PASS/FAIL. Bars: every landed body shot reacts (none = 0),
   trunk curl >= 18 deg, the first move <= 0.15 s after contact (research G147), the fold held >= 0.35 s.
2. Fix what the probe finds: punch names that never reach the body path, reactions too small to read from the broadcast
   camera (3-4 m away), a fold the guard layer cancels, a reaction clip that starts too late. Keep head-shot reactions
   exactly as they are.
3. Film one round before and after (tools/fight3d_play.gd, 1280x720, --fixed-fps 30) and leave both mp4s in
   docs/playtest/BODYREACT1/.

## Acceptance (Claude measures on your branch)
- body_react_probe: BODYREACT_SUMMARY PASS over 3 rounds (at least 6 landed body shots measured, else VOID).
- beat_clips_test, fight_flow_test, golden_path_test, fight_feel_test green; tools/move_player_probe.gd green.
- The operator watches the after film.

## Rules
Branch ziva/bodyreact1 from origin/main. Godot only headless or on the hidden desktop (python tools/hidden_desktop.py run
...), --audio-driver Dummy, probes at --fixed-fps 30; nothing opens on the operator's monitors. No script over 500 lines.
Commit only your files; Claude collects.

## Contract
OWNS: tools/body_react_probe.gd, scripts/fight3d/HitSnap.gd, scripts/fight3d/BeatClips.gd, scripts/fight3d/BeatFire.gd:90-130, docs/playtest/BODYREACT1/
RED_TEST: tools/body_react_probe.gd -> BODYREACT_SUMMARY
REGRESSION: beat_clips_test, fight_flow_test, golden_path_test, fight_feel_test
VISUAL: yes
