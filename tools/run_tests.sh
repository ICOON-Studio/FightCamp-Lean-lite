#!/bin/sh
# Runs every test headless, JOBS at a time (S336, operator "the heat fixed": 4 on a GREEN PC; JOBS=2 beside agents, JOBS=1
# serial). Results print in list order; a test fails on its exit code, a script error or a parse error. Usage: sh tools/run_tests.sh
GODOT="${GODOT_EXE:-$LOCALAPPDATA/Programs/Godot/Godot_v4.7.2-stable_win64.exe}"
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
JOBS="${JOBS:-4}"
TMP="$(mktemp -d)"
TESTS="training_preview_test fighter_goal_test membership_test game_money_test amateur_booking_test bout_rules_test move_mastery_test round_script_test round_style_test habit_beats_test combos_test combo_words_test corner_card_test exchanges_test habit_fix_test coach_notes_test fight_feel_test fighter_profile_test knockdowns_test bout_stoppage_test save_load_test test_jump_test tale_of_tape_test corner_jobs_test beat_clips_test balance_harness_test fight_words_contract_test range_breath_test clinch_beats_test burst_shape_test inside_beats_test inside_exits_test body_map_test body_load_test body_rates_test body_track_test pace_aim_test body_figure_test body_turn_test faces_test call_evidence_test short_punch_test gym_bills_test money_close_test injury_roll_test training_load_test body_report_test injuries_test season_path_test champ_draw_test champs_test pro_debut_test bout_burn_test the_read_test grapple_db_test grapple_pose_test grapple_graph_test grapple_grip_test grapple_timing_test grapple_contact_test strike_map_test next_step_test golden_path_test"
for t in $TESTS; do [ -f "$ROOT/tests/$t.gd" ] && echo "$t"; done | xargs -P "$JOBS" -I{} sh -c   '"$0" --headless --audio-driver Dummy --path "$1" --script "res://tests/{}.gd" > "$2/{}.out" 2>&1; echo $? > "$2/{}.rc"'   "$GODOT" "$ROOT" "$TMP"
fail=0
for t in $TESTS; do
  [ -f "$ROOT/tests/$t.gd" ] || continue
  code=$(cat "$TMP/$t.rc" 2>/dev/null || echo 99)
  if grep -qE "SCRIPT ERROR|Parse Error|Failed to load script" "$TMP/$t.out" 2>/dev/null; then code=9; fi
  if [ "$code" -eq 0 ]; then echo "PASS $t"; else echo "FAIL $t (exit $code)"; tail -40 "$TMP/$t.out"; fail=1; fi
done
rm -rf "$TMP"
exit $fail
