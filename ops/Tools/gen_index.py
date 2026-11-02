#!/usr/bin/env python3
"""gen_index.py - regenerate RESEARCH_INDEX.md, the one thing every agent may read.

WHY THIS EXISTS (operator, 2026-09-22: "the agents should have all available
information on existing researches and tools").

Every task file this project writes says "read your task file and only the files
it names". That rule is a CREDIT rule and it works - HANDOFF.md whole is ~38k
tokens - but it has a cost nobody priced: an agent cannot read what it does not
know exists. There are 788 research documents, 220 Godot tools and 43 driver
scripts in this checkout, and an agent assigned a study has no way to discover
that four of them already answer part of its question.

So the answer is not "let agents explore" (that is the 38k-token read again) and
not "list it in every task file by hand" (that is a fossil that stops tracking
its subject the moment a file lands). It is a GENERATED index, one line per
artefact, regenerated on demand, that an agent GREPS rather than reads.

    python Tools/gen_index.py            # write RESEARCH_INDEX.md
    python Tools/gen_index.py --check    # non-zero if it is out of date

THE INDEX IS GREPPED, NEVER READ WHOLE. It is about 130 KB. A task file tells
the agent the two or three greps worth running; reading it end to end would cost
more than the exploration it replaces.
"""
from __future__ import annotations

import argparse
import io
import os
import re
import subprocess
import sys

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
OUT = os.path.join(ROOT, "RESEARCH_INDEX.md")


def _first_line(path: str, patterns: list[str], limit: int = 60) -> str:
    """The first line matching any pattern, cleaned. '' when nothing matches."""
    try:
        with io.open(path, encoding="utf-8", errors="replace") as fh:
            for i, line in enumerate(fh):
                if i > limit:
                    break
                for pat in patterns:
                    m = re.match(pat, line)
                    if m:
                        text = (m.group(1) if m.groups() else line).strip()
                        text = text.strip("#*`- ").replace("|", "/")
                        if text:
                            return text
    except OSError:
        pass
    return ""


def _hook(path: str) -> str:
    """The document's first real prose line, after its title."""
    try:
        with io.open(path, encoding="utf-8", errors="replace") as fh:
            seen_title = False
            for i, line in enumerate(fh):
                if i > 40:
                    break
                s = line.strip()
                if not s:
                    continue
                if s.startswith("#"):
                    seen_title = True
                    continue
                if not seen_title:
                    continue
                if s.startswith(("---", "|", "```")):
                    continue
                s = re.sub(r"[*`_]", "", s).replace("|", "/")
                return s[:150]
    except OSError:
        pass
    return ""


def _rows_research() -> tuple[list[str], list[str]]:
    """(research rows, task rows) from research."""
    base = os.path.join(ROOT, "research")
    research: list[str] = []
    tasks: list[str] = []
    for name in sorted(os.listdir(base)) if os.path.isdir(base) else []:
        if not name.endswith(".md"):
            continue
        path = os.path.join(base, name)
        title = _first_line(path, [r"^#\s+(.*)$"]) or name[:-3]
        if name.startswith("TASK_"):
            owner = _first_line(path, [r"^\*\*Owner:\*\*\s*(.*)$"]) or "?"
            tasks.append("| `%s` | %s | %s |" % (name[5:-3], owner, title[:90]))
        else:
            research.append("| `%s` | %s | %s |"
                            % (name, title[:80], _hook(path)[:110]))
    ## 2026-09-27: documents in sub-folders are research too (S101 found four
    ## the index had never listed). Listed by their path under research.
    for dirpath, _dirs, files in sorted(os.walk(base)):
        if dirpath == base:
            continue
        for name in sorted(files):
            if not name.endswith(".md"):
                continue
            path = os.path.join(dirpath, name)
            rel = os.path.relpath(path, base).replace(os.sep, "/")
            title = _first_line(path, [r"^#\s+(.*)$"]) or name[:-3]
            research.append("| `%s` | %s | %s |" % (rel, title[:80], _hook(path)[:110]))
    return research, tasks


def _rows_tools() -> tuple[list[str], list[str]]:
    """(Godot .gd tools, Tools/ drivers)."""
    gd: list[str] = []
    base = os.path.join(ROOT, "Godot", "tools")
    for name in sorted(os.listdir(base)) if os.path.isdir(base) else []:
        if not name.endswith(".gd"):
            continue
        path = os.path.join(base, name)
        doc = _first_line(path, [r"^##\s+(.*)$", r"^#\s+(.*)$"])
        gd.append("| `Godot/tools/%s` | %s |" % (name, doc[:120]))

    drivers: list[str] = []
    for sub in ("", "cici", "grokbots", "higgsfield", "opsboard", "footage",
                "cascadeur", "blender_moves", "markup"):
        base2 = os.path.join(ROOT, "Tools", sub) if sub else os.path.join(ROOT, "Tools")
        if not os.path.isdir(base2):
            continue
        for name in sorted(os.listdir(base2)):
            if not name.endswith((".py", ".cmd", ".sh", ".ps1")):
                continue
            path = os.path.join(base2, name)
            doc = _first_line(path, [r'^"""(.*)$', r"^REM\s+(.*)$",
                                     r"^#\s+(.*)$", r"^##\s+(.*)$"])
            rel = os.path.relpath(path, ROOT).replace(os.sep, "/")
            drivers.append("| `%s` | %s |" % (rel, doc[:120]))
    return gd, drivers


def build() -> str:
    research, tasks = _rows_research()
    gd, drivers = _rows_tools()
    try:
        head = subprocess.run(["git", "rev-parse", "--short", "HEAD"], cwd=ROOT,
                              capture_output=True, text=True,
                              timeout=20).stdout.strip() or "?"
    except (OSError, subprocess.SubprocessError):
        head = "?"

    out: list[str] = []
    w = out.append
    w("# RESEARCH_INDEX - what already exists in this checkout")
    w("")
    w("**GENERATED by `python Tools/gen_index.py`. Do not hand-edit - a hand-kept")
    w("index stops tracking its subject the first time it is not updated.**")
    w("")
    w("Generated at `%s`. %d research documents, %d task files, %d Godot tools, "
      "%d drivers." % (head, len(research), len(tasks), len(gd), len(drivers)))
    w("")
    w("## HOW TO USE THIS - GREP IT, DO NOT READ IT WHOLE")
    w("")
    w("This file is large on purpose. Reading it end to end costs more than the")
    w("exploration it exists to replace. Search it:")
    w("")
    w("```")
    w("grep -in 'clinch' RESEARCH_INDEX.md          # every artefact mentioning clinch")
    w("grep -in 'capsule\\|overlap' RESEARCH_INDEX.md")
    w("grep -in 'anim\\|retarget\\|clip' RESEARCH_INDEX.md")
    w("```")
    w("")
    w("Then read only the two or three documents that match. A research document")
    w("here is a FINDING, not an instruction: it reports what was true when it was")
    w("written, and if it names a file, a function or a flag, check the thing still")
    w("exists before building on it.")
    w("")
    w("**A NEGATIVE RESULT IS A RESULT.** Several documents here record that")
    w("something does NOT work - paired clip generation, a purchasable grappling")
    w("pack, a numbered referee break clock. Those are the most expensive findings")
    w("in the set and re-running them wastes a pass.")
    w("")
    w("## Research documents")
    w("")
    w("| file | title | first line |")
    w("|---|---|---|")
    out.extend(research)
    w("")
    w("## Godot tools (`--headless --path Godot --script tools/<name>`)")
    w("")
    w("| tool | what it does |")
    w("|---|---|")
    out.extend(gd)
    w("")
    w("## Drivers and scripts")
    w("")
    w("| script | what it does |")
    w("|---|---|")
    out.extend(drivers)
    w("")
    w("## Task files (the assignment record)")
    w("")
    w("| id | owner | title |")
    w("|---|---|---|")
    out.extend(tasks)
    w("")
    return "\n".join(out) + "\n"


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("--check", action="store_true",
                    help="exit non-zero if RESEARCH_INDEX.md is out of date")
    args = ap.parse_args()
    text = build()
    if args.check:
        try:
            with io.open(OUT, encoding="utf-8") as fh:
                current = fh.read()
        except OSError:
            current = ""
        # The generated-at line carries HEAD, which moves on every commit; the
        # index is only stale when its CONTENT differs.
        strip = lambda s: "\n".join(
            l for l in s.splitlines() if not l.startswith("Generated at "))
        if strip(current) != strip(text):
            print("RESEARCH_INDEX.md is out of date - run python Tools/gen_index.py")
            return 1
        print("RESEARCH_INDEX.md is current")
        return 0
    with io.open(OUT, "w", encoding="utf-8", newline="\n") as fh:
        fh.write(text)
    print("wrote %s (%d KB)" % (os.path.relpath(OUT, ROOT), len(text) // 1024))
    return 0


if __name__ == "__main__":
    sys.exit(main())
