#!/bin/sh
# Builds Builds/FightCamp.exe + FightCamp.pck. The full tests run once a day at 05:00 (S402 operator), not here: before an export run only the tests the change touches.
# S396 Steam: with the official 4.7.2 export templates installed it is a real RELEASE export (no DEBUG title, version info,
# icon); without them, the old way: the Godot program renamed, running FightCamp.pck beside it.
# Usage: sh tools/export.sh   |   OUT=<dir> sh tools/export.sh (another folder)   |   FULLTESTS=1 (only if asked)
GODOT="$LOCALAPPDATA/Programs/Godot/Godot_v4.7.2-stable_win64.exe"
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
OUT="${OUT:-$ROOT/Builds}"
TEMPLATE="$APPDATA/Godot/export_templates/4.7.2.stable/windows_release_x86_64.exe"
[ -z "$FULLTESTS" ] || sh "$ROOT/tools/run_tests.sh" || { echo "tests failed: no build"; exit 1; }
mkdir -p "$OUT"
if [ -f "$TEMPLATE" ]; then
	"$GODOT" --headless --audio-driver Dummy --path "$ROOT" --export-release "Windows Desktop" "$OUT/FightCamp.exe" >/dev/null 2>&1 || exit 1
else
	"$GODOT" --headless --audio-driver Dummy --path "$ROOT" --export-pack "Windows Desktop" "$OUT/FightCamp.pck" >/dev/null 2>&1 || exit 1
	cp "$GODOT" "$OUT/FightCamp.exe"
fi
cp "$ROOT/docs/WHAT_TO_TRY.txt" "$OUT/WHAT_TO_TRY.txt"
# The 3D fight reads its boxers and clips as raw glTF bytes (scripts/fight3d/RawAsset.gd): an export packs only the
# imported copies, so the raw files ship beside the exe under the same relative paths.
mkdir -p "$OUT/assets/models/metahuman" "$OUT/assets/anim/metahuman"
cp "$ROOT"/assets/models/metahuman/mh_*.glb "$ROOT"/assets/models/metahuman/mh_*.json "$OUT/assets/models/metahuman/"
cp "$ROOT"/assets/anim/metahuman/*.glb "$OUT/assets/anim/metahuman/"
# S399 ROKOKO2: the Rokoko takes are retargeted on each boxer at fight start from their raw FBX (RkRetarget._load_fbx).
mkdir -p "$OUT/assets/anim/rokoko_combat"
cp "$ROOT"/assets/anim/rokoko_combat/*.fbx "$OUT/assets/anim/rokoko_combat/"
# S312: MHRig.dress reads the skin micro-normal raw too (MICRO_NORMAL); every build before shipped skin without it.
cp "$ROOT"/assets/models/metahuman/mh_skin_micro_normal.png "$OUT/assets/models/metahuman/"
# S319: the motion blur compiles its shaders from their .glsl source at run time (addons/easy-compositor); an export
# packs only the imported copies, so the sources ship beside the exe too (every build since update 20 had no blur).
( cd "$ROOT" && find addons -name "*.glsl" | while read -r g; do mkdir -p "$OUT/$(dirname "$g")"; cp "$g" "$OUT/$g"; done )
# S310: the ops board's "Test: ..." buttons open these shortcuts (Explorer drops plain arguments).
powershell -NoProfile -ExecutionPolicy Bypass -File "$(cygpath -w "$ROOT/tools/make_shortcuts.ps1" 2>/dev/null || echo "$ROOT/tools/make_shortcuts.ps1")"
echo "built $OUT/FightCamp.exe"
