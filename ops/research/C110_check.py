"""C110 gate (written by Claude before launch). Run from the repo root: python research/C110_check.py

C110 is a static audit of every source of uneven frames in the live 3D room. Nothing here trusts Codex's list:
- every quote must sit within 3 lines of its cited line (a file on the branch is read with `git show`);
- the four hot paths are DERIVED from the source (FightWorldLiveScreen._process and _pump_to, FightStagePlayer.advance,
  the AnimationPlayer callback-mode line) and each must be covered by at least one row;
- every project setting is re-read from project.godot: a value must match what is written, and "default" means
  the key is really absent;
- every answer except q3 must cite a file:line that is also a sources row.
"""
import json
import re
import subprocess
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
GODOT = ROOT / "Godot"
JSON_PATH = GODOT / "research" / "C110_live_room_frames.json"
MD_PATH = GODOT / "research" / "C110_LIVE_ROOM_FRAMES.md"
ROOM = "Godot/scripts/FightWorldLiveScreen.gd"
PLAYER = "Godot/scripts/FightStagePlayer.gd"
BRANCH = "origin/claude/watchable-room"
KINDS = {"per_frame_alloc", "unbounded_loop", "catch_up", "first_use_compile", "physics_vs_process", "clock_source",
         "vsync_fps_setting", "blocking_load", "text_redraw", "other"}
WHEN = {"every_frame", "on_event", "once_at_start"}
REQUIRED_SETTINGS = ["display/window/vsync/vsync_mode", "application/run/max_fps",
                     "physics/common/physics_ticks_per_second", "physics/common/physics_interpolation",
                     "application/run/low_processor_mode", "rendering/renderer/rendering_method"]

failures = []
_cache = {}


def fail(msg):
    failures.append(msg)
    print("FAIL:", msg)


def lines_of(rel):
    if rel in _cache:
        return _cache[rel]
    path = ROOT / rel
    text = None
    if path.is_file():
        text = path.read_text(encoding="utf-8")
    else:
        r = subprocess.run(["git", "show", "%s:%s" % (BRANCH, rel)], cwd=str(ROOT), capture_output=True)
        if r.returncode == 0:
            text = r.stdout.decode("utf-8", "replace")
    _cache[rel] = text.splitlines() if text is not None else None
    return _cache[rel]


def func_range(rel, signature):
    lines = lines_of(rel) or []
    start = next((i + 1 for i, l in enumerate(lines) if l.startswith(signature)), 0)
    if not start:
        return (0, 0)
    end = len(lines)
    for i in range(start, len(lines)):
        if re.match(r"(static )?func |const |var |## ", lines[i]) and not lines[i].startswith("\t"):
            end = i
            break
    return (start, end)


def settings():
    found = {}
    section = ""
    for raw in (GODOT / "project.godot").read_text(encoding="utf-8").splitlines():
        line = raw.strip()
        m = re.match(r"\[(.+)\]$", line)
        if m:
            section = m.group(1)
            continue
        if "=" in line and section and not line.startswith(";"):
            key, _, value = line.partition("=")
            found["%s/%s" % (section, key.strip())] = value.strip()
    return found


def main():
    for p in (JSON_PATH, MD_PATH):
        if not p.is_file():
            fail("missing %s" % p.relative_to(ROOT))
    if failures:
        return finish()
    data = json.loads(JSON_PATH.read_text(encoding="utf-8"))
    rows = data.get("sources", [])
    if len(rows) < 6:
        fail("sources has %d rows; at least 6 expected" % len(rows))
    cited = []
    for i, row in enumerate(rows):
        missing = [k for k in ("file", "line", "quote", "kind", "when", "what", "video_hides_it", "probe") if k not in row]
        if missing:
            fail("source %d lacks %s" % (i, ", ".join(missing)))
            continue
        rel = str(row["file"])
        lines = lines_of(rel)
        if lines is None:
            fail("source %d: %s is neither on disk nor on %s" % (i, rel, BRANCH))
            continue
        line_no = int(row["line"])
        quote = str(row["quote"]).strip()
        if not quote or not any(quote in w for w in lines[max(0, line_no - 4):line_no + 3]):
            fail("source %d: quote %r is not within 3 lines of %s:%d" % (i, quote, rel, line_no))
        if row["kind"] not in KINDS:
            fail("source %d: kind %r" % (i, row["kind"]))
        if row["when"] not in WHEN:
            fail("source %d: when %r" % (i, row["when"]))
        for key in ("what", "video_hides_it", "probe"):
            if not str(row[key]).strip():
                fail("source %d: empty %s" % (i, key))
        cited.append((rel, line_no))

    hot = {
        "FightWorldLiveScreen._process": (ROOM, func_range(ROOM, "func _process(")),
        "FightWorldLiveScreen._pump_to": (ROOM, func_range(ROOM, "func _pump_to(")),
        "FightStagePlayer.advance": (PLAYER, func_range(PLAYER, "func advance(")),
    }
    player_lines = lines_of(PLAYER) or []
    cb = next((i + 1 for i, l in enumerate(player_lines) if "callback_mode_process" in l), 0)
    hot["FightStagePlayer callback_mode_process"] = (PLAYER, (max(1, cb - 3), cb + 3))
    for name, (rel, (a, b)) in hot.items():
        if not a:
            fail("could not derive %s from the source" % name)
        elif not any(r == rel and a <= n <= b for r, n in cited):
            fail("no sources row inside %s (%s:%d-%d)" % (name, rel, a, b))

    written = settings()
    given = {str(s.get("key")): str(s.get("value")).strip() for s in data.get("project_settings", [])}
    for key in REQUIRED_SETTINGS:
        if key not in given:
            fail("project_settings lacks %s" % key)
            continue
        if given[key] == "default":
            if key in written:
                fail("%s is written in project.godot as %s, not absent" % (key, written[key]))
        elif written.get(key) != given[key]:
            fail("%s: project.godot says %r, the JSON says %r" % (key, written.get(key), given[key]))

    answers = data.get("answers", {})
    for q in ("q1", "q2", "q3", "q4", "q5", "q6"):
        text = str(answers.get(q, "")).strip()
        if not text:
            fail("answers.%s is empty" % q)
            continue
        if q == "q3":
            continue
        refs = [(m.group(1), int(m.group(2))) for m in re.finditer(r"(Godot/[\w/]+\.gd):(\d+)", text)]
        if not any(any(r == rel and abs(n - line) <= 3 for rel, line in cited) for r, n in refs):
            fail("answers.%s cites no file:line that is a sources row" % q)

    md = MD_PATH.read_text(encoding="utf-8").splitlines()
    if next((l for l in md if l.strip()), "").strip() != "## DECISIONS":
        fail("the digest does not open with ## DECISIONS")
    if len(md) > 40:
        fail("the digest is %d lines, 40 at most" % len(md))
    return finish()


def finish():
    if failures:
        print("C110_check: %d failure(s)" % len(failures))
        sys.exit(1)
    print("C110_check: PASS")
    sys.exit(0)


if __name__ == "__main__":
    main()
