#!/bin/sh
# Runs the named tests headless, one Godot job at a time (same checks as run_tests.sh). Usage: sh tools/run_some.sh a_test b_test
GODOT="${GODOT_EXE:-$LOCALAPPDATA/Programs/Godot/Godot_v4.7.2-stable_win64.exe}"
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
fail=0
for t in "$@"; do
  out=$("$GODOT" --headless --audio-driver Dummy --path "$ROOT" --script "res://tests/$t.gd" 2>&1)
  code=$?
  if echo "$out" | grep -qE "SCRIPT ERROR|Parse Error|Failed to load script"; then code=9; fi
  if [ $code -eq 0 ]; then echo "PASS $t"; else echo "FAIL $t (exit $code)"; echo "$out" | tail -40; fail=1; fi
done
exit $fail
