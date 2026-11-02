"""build_playable.py - the operator's playable Windows build (S74).

    python Tools/build_playable.py

Writes Builds/FightCamp_Godot/: FightCamp.exe (the Godot 4.7.2 runtime, which
auto-loads the same-named .pck beside it - no export templates needed),
FightCamp_console.exe (same, with a console for crash logs), FightCamp.pck
(research/docs/tests/tools excluded by export_presets.cfg) and assets/ holding
the RAW .glb/.fbx/.exr (+ RAW_IMAGES) the runtime reads through GLTFDocument (an export ships only
their imported copies; scripts/RawAsset.gd reads them from beside the exe).
"""
import os, shutil, subprocess, sys
ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
GODOT_DIR = os.path.join(ROOT, "Godot")
OUT = os.path.join(ROOT, "Builds", "FightCamp_Godot")
BIN = os.path.join(os.environ["LOCALAPPDATA"], "Programs", "Godot")
SKIP = {"research", "docs", "tests", "tools", ".godot", ".test_saves", ".vscode"}
# S145 (PLAYTEST P10 audit): images the runtime reads RAW (RawAsset.read / Image.load_from_file), so the
# imported copy in the .pck does not serve them. .exr = VenueCrowd's VAT; these PNGs = MetaHumanRig._png and
# Office3D._cutout. A new raw image read needs its path here or it is missing in the exe only.
RAW_IMAGES = {
    "assets/models/metahuman/mh_skin_micro_normal.png",
    "assets/ui/bot_art/belt_world_title.png",
    "assets/ui/trophy_fight_night_cutout.png",
    "assets/ui/trophy_grand_prix_cutout.png",
    "assets/ui/trophy_performance_night_cutout.png",
}

def _pck_paths(pck: str) -> set:
    """The pck's file table (Godot 4.7 GDPC: header, dir offset at byte 32; each entry = u32 len, path padded with
    NULs to 4, u64 offset, u64 size, 16-byte md5, u32 flags). A substring scan is not enough: a path whose length
    is a multiple of 4 carries no NUL, and '<name>.svg.import' contains '<name>.svg'."""
    import struct
    data = open(pck, "rb").read()
    at = struct.unpack("<Q", data[32:40])[0]
    count = struct.unpack("<I", data[at:at + 4])[0]
    at += 4
    paths = set()
    for _ in range(count):
        length = struct.unpack("<I", data[at:at + 4])[0]
        paths.add(data[at + 4:at + 4 + length].rstrip(bytes(1)).decode("utf-8").removeprefix("res://"))
        at += 4 + length + 8 + 8 + 16 + 4
    return paths

def _raw_svgs_missing(pck: str) -> list:
    """Icon svgs IconKit.gd reads as text (FileAccess) must be in the pck as RAW files; an imported svg only
    has '<name>.svg.import' in the table."""
    paths = _pck_paths(pck)
    missing = []
    for sub in ("assets/icons/lucide", "assets/icons/flags/4x3"):
        for f in sorted(os.listdir(os.path.join(GODOT_DIR, sub))):
            if f.endswith(".svg") and (sub + "/" + f) not in paths:
                missing.append(sub + "/" + f)
    return missing

def main() -> int:
    os.makedirs(OUT, exist_ok=True)
    rc = subprocess.run([os.path.join(BIN, "Godot_v4.7.2-stable_win64.exe"), "--headless",  # S162b: the console build pops a terminal on the operator's monitor
                         "--path", GODOT_DIR, "--export-pack", "Windows Desktop",
                         os.path.join(OUT, "FightCamp.pck")], capture_output=True, text=True).returncode
    if rc != 0 or not os.path.exists(os.path.join(OUT, "FightCamp.pck")):
        print("EXPORT FAILED rc=%d" % rc); return 1
    missing = _raw_svgs_missing(os.path.join(OUT, "FightCamp.pck"))
    if missing:
        # S145 PLAYTEST P10: IconKit/flags read the raw .svg text; an imported-only svg is a blank square in the exe.
        print("EXPORT INCOMPLETE: %d raw icon svg(s) not in the pck (set importer=\"keep\" in their .import), e.g. %s"
              % (len(missing), ", ".join(missing[:5]))); return 1
    shutil.copy2(os.path.join(BIN, "Godot_v4.7.2-stable_win64.exe"), os.path.join(OUT, "FightCamp.exe"))
    shutil.copy2(os.path.join(BIN, "Godot_v4.7.2-stable_win64_console.exe"), os.path.join(OUT, "FightCamp_console.exe"))
    n = size = 0
    for d, dirs, files in os.walk(GODOT_DIR):
        dirs[:] = [x for x in dirs if not (d == GODOT_DIR and x in SKIP)]
        # S75 legal inventory: assets/_local holds the Reallusion CC export, which its
        # licence does not let us ship. It never leaves the PC, in any build.
        dirs[:] = [x for x in dirs if x != "_local"]
        for f in files:
            rel = os.path.relpath(os.path.join(d, f), GODOT_DIR).replace("\\", "/")
            if f.lower().endswith((".glb", ".fbx", ".exr")) or rel in RAW_IMAGES:
                src = os.path.join(d, f)
                dst = os.path.join(OUT, os.path.relpath(src, GODOT_DIR))
                os.makedirs(os.path.dirname(dst), exist_ok=True)
                if not os.path.exists(dst) or os.path.getmtime(dst) < os.path.getmtime(src):
                    shutil.copy2(src, dst)
                n += 1; size += os.path.getsize(src)
    shutil.copy2(os.path.join(ROOT, "Tools", "playable", "WHAT_TO_TRY.txt"), os.path.join(OUT, "WHAT_TO_TRY.txt"))
    print("BUILD OK %s  pck=%d MB  raw models=%d (%d MB)" % (OUT, os.path.getsize(os.path.join(OUT, "FightCamp.pck")) >> 20, n, size >> 20))
    return 0

if __name__ == "__main__":
    sys.exit(main())
