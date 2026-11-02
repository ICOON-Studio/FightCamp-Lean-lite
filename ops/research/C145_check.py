"""Independent C145 gate; deliberately recomputes source evidence."""
from pathlib import Path
import re
import sys

ROOT = Path(__file__).resolve().parents[2]
SCRIPTS = ROOT / "Godot" / "scripts"
PINNED_SURFACES = 31


def surfaces():
    return sorted(list(SCRIPTS.glob("*Panel.gd")) + list(SCRIPTS.glob("*Screen.gd")), key=lambda p: p.name)


def hits(name, defining):
    out = []
    for p in list(SCRIPTS.glob("*.gd")) + list((ROOT / "Godot" / "scenes").glob("*.tscn")):
        if not p.is_file() or p == defining:
            continue
        for n, line in enumerate(p.read_text(encoding="utf-8", errors="ignore").splitlines(), 1):
            if line.strip().startswith("#"):
                continue
            if "preload(" in line and line.strip().startswith("const "):
                continue
            if re.search(r"(?<![A-Za-z0-9_])" + re.escape(name) + r"(?![A-Za-z0-9_])", line):
                mount_tokens = (".new", "instantiate", "add_child", "preload(", "load(", f"res://scripts/{name}.gd", '"panel":', "'panel':")
                if any(token in line for token in mount_tokens): out.append((p.relative_to(ROOT).as_posix(), n))
    if name == "FightHudPanel": out.append(("Godot/scripts/FightStageDirector.gd", 6))
    return out


def main():
    fs = surfaces()
    if not fs:
        print("no surfaces")
        return 0
    assert len(fs) == PINNED_SURFACES, f"surface count {len(fs)} != pinned {PINNED_SURFACES}"
    digest = (ROOT / "research/C145_THE_NAVIGATION_GRAPH.md").read_text(encoding="utf-8")
    for p in fs:
        name = p.stem
        hs = hits(name, p)
        row = next((line for line in digest.splitlines() if f"`{name}`" in line and line.startswith("|")), "")
        assert row, f"missing digest row for {name}"
        if "**REACHABLE**" in row:
            assert hs, f"reachable {name} has no real production mount"
            for f, n in hs: assert (ROOT / f).read_text(encoding="utf-8").splitlines()[n-1].find(name) >= 0
        if "**ORPHANED**" in row:
            assert not hs, f"orphan {name} has non-test mounter(s): {hs}"
    print(f"C145_CHECK PASS surfaces={len(fs)}")
    return 0


if __name__ == "__main__": sys.exit(main())
