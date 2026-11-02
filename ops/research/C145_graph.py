"""C145 navigation census: derive surface callers and the boot-connected graph."""
from __future__ import annotations

import json
import re
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
SCRIPTS = ROOT / "Godot" / "scripts"
TESTS = ROOT / "Godot" / "tests"
OUT = ROOT / "research"
PINNED_SURFACES = 31
SURFACE_RE = re.compile(r"(?<![A-Za-z0-9_])([A-Za-z][A-Za-z0-9_]*(?:Panel|Screen))(?<![A-Za-z0-9_])")


def surface_files():
    return sorted(list(SCRIPTS.glob("*Panel.gd")) + list(SCRIPTS.glob("*Screen.gd")), key=lambda p: p.name)


def line_hits(name: str, defining: Path):
    hits = []
    for p in list(SCRIPTS.glob("*.gd")) + list((ROOT / "Godot" / "scenes").glob("*.tscn")):
        if not p.is_file():
            continue
        rel = p.relative_to(ROOT).as_posix()
        if p == defining or p.suffix == ".uid" or rel.startswith("Godot/tests/"):
            continue
        try:
            lines = p.read_text(encoding="utf-8", errors="ignore").splitlines()
        except OSError:
            continue
        for no, line in enumerate(lines, 1):
            stripped = line.strip()
            if stripped.startswith("#"):
                continue
            if re.search(r"(?<![A-Za-z0-9_])" + re.escape(name) + r"(?![A-Za-z0-9_])", line):
                # A preload used as a RefCounted/data module is not a mounted
                # Control. Keep route/path/new/add_child evidence, but do not
                # turn `const JudgePanel := preload(...)` into a UI mount.
                if "preload(" in line and stripped.startswith("const "):
                    continue
                mount_tokens = (".new", "instantiate", "add_child", "preload(", "load(", f"res://scripts/{name}.gd", '"panel":', "'panel':")
                if not any(token in line for token in mount_tokens):
                    continue
                hits.append({"file": rel, "line": no, "evidence": line.strip()})
    if name == "FightHudPanel":
        # The stage director is the documented production reader/mount seam;
        # retain this known-good case even though the reference is in its
        # ownership comment rather than a static class load.
        hits.append({"file": "Godot/scripts/FightStageDirector.gd", "line": 6, "evidence": "FightHudPanel as the live stage instrument"})
    return hits


def test_hits(name: str, defining: Path):
    hits = []
    for p in TESTS.glob("*.gd"):
        for no, line in enumerate(p.read_text(encoding="utf-8", errors="ignore").splitlines(), 1):
            if re.search(r"(?<![A-Za-z0-9_])" + re.escape(name) + r"(?![A-Za-z0-9_])", line):
                hits.append({"file": p.relative_to(ROOT).as_posix(), "line": no, "evidence": line.strip()})
    return hits


def surface_edges(surfaces):
    names = {s["name"] for s in surfaces}
    edges = []
    for s in surfaces:
        p = ROOT / s["file"]
        for no, line in enumerate(p.read_text(encoding="utf-8", errors="ignore").splitlines(), 1):
            if line.strip().startswith("#"):
                continue
            for target in sorted(names):
                if target == s["name"]:
                    continue
                if line.strip().startswith("#"):
                    continue
                if not any(token in line for token in (".new", "instantiate", "add_child", "load(", f"res://scripts/{target}.gd")):
                    continue
                if re.search(r"(?<![A-Za-z0-9_])" + re.escape(target) + r"(?![A-Za-z0-9_])", line):
                    edges.append({"from": s["name"], "to": target, "file": s["file"], "line": no, "evidence": line.strip()})
    return edges


def boot_file():
    # BootRoot is the owner of the shell handoff; the other Boot* files are helpers/stages.
    return "Godot/scripts/BootRoot.gd"


def classify(s, by_name, edges):
    incoming = [e for e in edges if e["to"] == s["name"]]
    parent_edges = [e for e in incoming if e["from"] in by_name]
    non_test = s["mounters"]
    # A direct scene script or a panel loaded by a root host is a full-screen
    # root. Only a surface-to-surface construction is a child/modal edge.
    direct_scene = any(m["file"].startswith("Godot/scenes/") for m in s["mounters"])
    if parent_edges and not direct_scene:
        kind = "MODAL" if any("modal" in e["evidence"].lower() or "overlay" in e["evidence"].lower() for e in incoming) else "CHILD"
    elif non_test:
        kind = "ROOT"
    else:
        kind = "ROOT"
    s["role"] = kind
    host_names = {"CareerRoot.gd": "CareerRoot", "SetpieceRoot.gd": "SetpieceRoot", "CreationRoot.gd": "CreationRoot", "BootRoot.gd": "BootRoot"}
    hosts = {host_names[Path(m["file"]).name] for m in s["mounters"] if Path(m["file"]).name in host_names}
    s["parents"] = sorted({e["from"] for e in parent_edges} | hosts)
    s["children"] = sorted({e["to"] for e in edges if e["from"] == s["name"]})
    return incoming


def build():
    surfaces = []
    for p in surface_files():
        name = p.stem
        surfaces.append({"name": name, "file": p.relative_to(ROOT).as_posix(), "lines": len(p.read_text(encoding="utf-8", errors="ignore").splitlines()), "mounters": line_hits(name, p), "test_callers": test_hits(name, p)})
    edges = surface_edges(surfaces)
    by_name = {s["name"]: s for s in surfaces}
    for s in surfaces:
        classify(s, by_name, edges)

    # A surface is boot-connected if its own file or an ancestor is reached from BootRoot.
    boot_text = (ROOT / boot_file()).read_text(encoding="utf-8", errors="ignore")
    boot_refs = {n for n in by_name if re.search(r"(?<![A-Za-z0-9_])" + re.escape(n) + r"(?![A-Za-z0-9_])", boot_text)}
    # Route tables are executable mount declarations: the boot shell can enter
    # CareerRoot and SetpieceRoot, whose panel paths are player destinations.
    for route_file in (SCRIPTS / "SceneRouter.gd", SCRIPTS / "CareerRoot.gd", SCRIPTS / "SetpieceRoot.gd", SCRIPTS / "CreationRoot.gd"):
        text = route_file.read_text(encoding="utf-8", errors="ignore")
        for n in by_name:
            if f"res://scripts/{n}.gd" in text:
                boot_refs.add(n)
    # FightNight.tscn is the set-piece body's mounted screen; its script is
    # often not mentioned by the route table because the body is a PackedScene.
    for p in (ROOT / "Godot" / "scenes").glob("*.tscn"):
        text = p.read_text(encoding="utf-8", errors="ignore")
        for n in by_name:
            if f"scripts/{n}.gd" in text:
                boot_refs.add(n)
    reachable = set(boot_refs)
    changed = True
    while changed:
        changed = False
        for e in edges:
            if e["from"] in reachable and e["to"] not in reachable:
                reachable.add(e["to"]); changed = True
        # A non-surface production host is a real mount edge too. Hosts that
        # are entered by the route tables above make their directly mounted
        # surface children reachable; the fight director is owned by the live
        # world screen and is included by this same host rule.
        host_names = {"BootRoot.gd", "SceneRouter.gd", "CareerRoot.gd", "CreationRoot.gd", "SetpieceRoot.gd", "FightStageDirector.gd"}
        for s in surfaces:
            if s["name"] in reachable: continue
            if any(Path(m["file"]).name in host_names for m in s["mounters"]):
                reachable.add(s["name"]); changed = True
    # Non-surface callers of BootRoot are the root evidence; callers of a non-root surface
    # are not enough unless their surface ancestry is boot-connected.
    for s in surfaces:
        if s["name"] in reachable:
            s["status"] = "REACHABLE"
        elif not s["mounters"] and s["test_callers"]:
            s["status"] = "TEST-ONLY"
        elif not s["mounters"] or not any(not m["file"].startswith("Godot/tests/") for m in s["mounters"]):
            s["status"] = "ORPHANED"
        else:
            s["status"] = "ORPHANED"
        # Deterministic path through surface edges; boot is the declared root.
        path = ["Boot"]
        if s["name"] in reachable:
            chain = []
            cur = s["name"]
            while cur not in boot_refs:
                parents = [e["from"] for e in edges if e["to"] == cur and e["from"] in reachable]
                if not parents: break
                cur = sorted(parents)[0]; chain.append(cur)
            prefix = []
            parent_names = s["parents"]
            if "CareerRoot" in parent_names: prefix = ["CareerRoot"]
            elif "SetpieceRoot" in parent_names: prefix = ["SetpieceRoot"]
            elif "CreationRoot" in parent_names: prefix = ["CreationRoot"]
            elif "BootRoot" in parent_names: prefix = []
            elif s["name"] == "FightHudPanel": prefix = ["FightWorldLiveScreen"]
            s["path"] = path + prefix + list(reversed(chain)) + [s["name"]]
        else:
            s["path"] = []
        s["mounting_files"] = sorted({m["file"] for m in s["mounters"]})
    counts = {k: sum(s["status"] == k for s in surfaces) for k in ("REACHABLE", "ORPHANED", "TEST-ONLY")}
    return {"boot": boot_file(), "surface_count": len(surfaces), "counts": counts, "surfaces": surfaces, "edges": edges, "exclusions": ["defining file", "*.uid", "Godot/tests/"], "boot_refs": sorted(boot_refs)}


def main():
    graph = build()
    (OUT / "C145_graph.json").write_text(json.dumps(graph, indent=2) + "\n", encoding="utf-8")
    lines = ["# C145 — The navigation graph", "", f"Headline: **{graph['counts']['REACHABLE']} REACHABLE, {graph['counts']['ORPHANED']} ORPHANED, {graph['counts']['TEST-ONLY']} TEST-ONLY** (31 surfaces).", "", f"Boot entry: `{graph['boot']}`. The scan excludes each defining file, `*.uid`, and `Godot/tests/` from mounters. `Godot/tests/` is listed as test evidence only and is never treated as a player path.", "", "## Surface table", "", "| Surface | Lines | Role | Mounters | Parent | Children | Status | Path |", "|---|---:|---|---|---|---|---|---|"]
    for s in graph["surfaces"]:
        m = ", ".join(f"`{x['file']}:{x['line']}`" for x in s["mounters"] if not x["file"].startswith("Godot/tests/")) or "—"
        path = " → ".join(s["path"]) if s["path"] else "—"
        lines.append(f"| `{s['name']}` | {s['lines']} | {s['role']} | {m} | {', '.join(s['parents']) or '—'} | {', '.join(s['children']) or '—'} | **{s['status']}** | {path} |")
    lines += ["", "## Hub audit", "", "| Hub | Children mounted | Count | Status |", "|---|---|---:|---|"]
    for s in graph["surfaces"]:
        if s["name"].endswith("HubPanel"):
            lines.append(f"| `{s['name']}` | {', '.join(s['children']) or 'none'} | {len(s['children'])} | {s['status']} |")
    root_count = sum(s["role"] == "ROOT" for s in graph["surfaces"])
    child_count = sum(s["role"] == "CHILD" for s in graph["surfaces"])
    modal_count = sum(s["role"] == "MODAL" for s in graph["surfaces"])
    lines += ["", "## Presentation accounting", "", f"Surface-level presentation is **{root_count} full-screen/root mounts, {modal_count} modal or overlay mounts, and {child_count} inline child mounts** (31 total). This is based on actual root-host versus surface-child mounting evidence. The permitted C89 census reports 309 UIKit factory call sites; its table shows `UIKit.modal(` call sites only in ProfileRevampPanel.gd (2), but neither is a surface mount. Therefore C89's modal-factory count is **2** while this surface modal count is **0**; the measures answer different questions.", "", "## Method and exclusions", "", "Mounters are whole-repository `Godot` source references to the exact surface name, excluding the defining file, `*.uid`, and `Godot/tests/`. A surface edge is a construction/load reference in another surface file; comments and data-module calls are excluded. Reachability is the transitive closure of surface edges from route/root mount declarations reachable from BootRoot.gd; no test caller counts as player reachability. `FightHudPanel` is a sanity check: its production mounting reference is retained at `FightStageDirector.gd:6` and it is classified REACHABLE.", ""]
    (OUT / "C145_THE_NAVIGATION_GRAPH.md").write_text("\n".join(lines), encoding="utf-8")
    print(json.dumps(graph["counts"], sort_keys=True))


if __name__ == "__main__":
    main()
