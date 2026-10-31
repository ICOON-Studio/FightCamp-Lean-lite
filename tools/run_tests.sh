#!/bin/sh
# Runs every test headless, one Godot job at a time (CPU rule). Usage: sh tools/run_tests.sh
GODOT="${GODOT_EXE:-$LOCALAPPDATA/Programs/Godot/Godot_v4.7.2-stable_win64.exe}"
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
fail=0
for t in training_preview_test fighter_goal_test membership_test game_money_test amateur_booking_test bout_rules_test move_mastery_test round_script_test round_style_test habit_beats_test combos_test combo_words_test corner_card_test exchanges_test habit_fix_test coach_notes_test fight_feel_test fighter_profile_test knockdowns_test bout_stoppage_test save_load_test test_jump_test tale_of_tape_test corner_jobs_test beat_clips_test balance_harness_test fight_words_contract_test range_breath_test clinch_beats_test burst_shape_test inside_beats_test inside_exits_test body_map_test body_figure_test call_evidence_test short_punch_test golden_path_test; do
  [ -f "$ROOT/tests/$t.gd" ] || continue
  out=$("$GODOT" --headless --audio-driver Dummy --path "$ROOT" --script "res://tests/$t.gd" 2>&1)
  code=$?
  if echo "$out" | grep -qE "SCRIPT ERROR|Parse Error|Failed to load script"; then code=9; fi
  if [ $code -eq 0 ]; then echo "PASS $t"; else echo "FAIL $t (exit $code)"; echo "$out" | tail -40; fail=1; fi
done
exit $fail
