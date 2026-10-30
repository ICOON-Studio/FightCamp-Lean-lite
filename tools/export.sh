#!/bin/sh
# Builds Builds/FightCamp.exe + FightCamp.pck. Runs the tests first (a red test stops the build).
# No export templates are installed on this PC, so (like the old project's builds) the exe is the Godot 4.7.2
# program itself renamed; it runs the game from FightCamp.pck beside it. Usage: sh tools/export.sh
GODOT="$LOCALAPPDATA/Programs/Godot/Godot_v4.7.2-stable_win64.exe"
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
sh "$ROOT/tools/run_tests.sh" || { echo "tests failed: no build"; exit 1; }
mkdir -p "$ROOT/Builds"
"$GODOT" --headless --audio-driver Dummy --path "$ROOT" --export-pack "Windows Desktop" "$ROOT/Builds/FightCamp.pck" >/dev/null 2>&1 || exit 1
cp "$GODOT" "$ROOT/Builds/FightCamp.exe"
cp "$ROOT/docs/WHAT_TO_TRY.txt" "$ROOT/Builds/WHAT_TO_TRY.txt"
# The 3D fight reads its boxers and clips as raw glTF bytes (scripts/fight3d/RawAsset.gd): an export packs only the
# imported copies, so the raw files ship beside the exe under the same relative paths.
mkdir -p "$ROOT/Builds/assets/models/metahuman" "$ROOT/Builds/assets/anim/metahuman"
cp "$ROOT"/assets/models/metahuman/mh_*.glb "$ROOT"/assets/models/metahuman/mh_*.json "$ROOT/Builds/assets/models/metahuman/"
cp "$ROOT"/assets/anim/metahuman/*.glb "$ROOT/Builds/assets/anim/metahuman/"
# S312: MHRig.dress reads the skin micro-normal raw too (MICRO_NORMAL); every build before shipped skin without it.
cp "$ROOT"/assets/models/metahuman/mh_skin_micro_normal.png "$ROOT/Builds/assets/models/metahuman/"
# S310: the ops board's "Test: ..." buttons open these shortcuts (Explorer drops plain arguments).
powershell -NoProfile -ExecutionPolicy Bypass -File "$(cygpath -w "$ROOT/tools/make_shortcuts.ps1" 2>/dev/null || echo "$ROOT/tools/make_shortcuts.ps1")"
echo "built $ROOT/Builds/FightCamp.exe"
