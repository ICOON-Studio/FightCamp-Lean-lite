"""map_board.py - the project map on our own ops board (S499; replaces the Miro board).

Operator S499: "miro subscription has been stop , is there any other tool that can do its job but free or can you create
something like miro for our project". This is that: http://127.0.0.1:8787/map - a pan-and-zoom canvas of FRAMES in ROWS,
his sticky notes on top, free, on this PC, and a session updates it with one command instead of a Miro call.

FILES (all under ops/AgentComms/map/)
    frames.json   what the map shows: {"rows": [{"title", "frames": [frame, ...]}]}  (committed; edit by hand or the CLI)
    notes.json    the sticky notes: his, and Claude's replies                            (committed; the page writes it)
    seen.json     which notes `start` has already printed                                (git-ignored)
    thumbs/       640 px previews made on demand                                         (git-ignored)

FRAME KINDS
    {"id","title","kind":"where"}                    DONE earlier / DONE this session / NOW / NEXT from where_we_are.py
    {"id","title","kind":"queue"}                    seats working + next, from roadmap.json plan and live_runs.json
    {"id","title","kind":"cards","columns":[{"title","cards":[{"text","who"}]}], "score": ""}
    {"id","title","kind":"gallery","globs":["docs/mockups/s402/*.png"],"cols":4}   pictures (repo paths, or absolute
                                                     under an IMG_ROOTS folder); newest files of a glob with "last": N
    {"id","title","kind":"links","links":[{"title","url","note"}]}
    Any frame may carry "note": one line under its title.

CLI (from the repo root)
    python ops/Tools/opsboard/map_board.py check                       every frame with its counts, missing pictures named
    python ops/Tools/opsboard/map_board.py notes [--all]               his notes not yet seen (start runs this)
    python ops/Tools/opsboard/map_board.py reply <note id> "<text>"    Claude's answer under his note
    python ops/Tools/opsboard/map_board.py done <note id>              tick his note (stays on the map, greyed)
    python ops/Tools/opsboard/map_board.py gallery <id> "<title>" --row "<row>" [--cols 4] [--last N] <glob> [<glob> ...]
    python ops/Tools/opsboard/map_board.py cards <id> "<title>" --row "<row>" --col "NOW=a|b|c" [--col ...] [--score "6/10"]
    python ops/Tools/opsboard/map_board.py rm <id>
    gallery/cards replace a frame with the same id in place, else append it to the row (a new row is made if needed).
"""
from __future__ import annotations

import glob as _glob
import hashlib
import json
import os
import sys
import threading
import time
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]          # ops/
REPO = ROOT.parent
MAP_DIR = ROOT / "AgentComms" / "map"
FRAMES = MAP_DIR / "frames.json"
NOTES = MAP_DIR / "notes.json"
SEEN = MAP_DIR / "seen.json"
THUMBS = MAP_DIR / "thumbs"
IMG_ROOTS = (REPO, Path("E:/FightCamp/critic_pack"), Path("E:/FightCamp/tmp"))
IMG_TYPES = {".png": "image/png", ".jpg": "image/jpeg", ".jpeg": "image/jpeg", ".webp": "image/webp", ".gif": "image/gif"}
THUMB_W = 640
_LOCK = threading.Lock()


def _load(path: Path, default):
    try:
        return json.loads(path.read_text(encoding="utf-8"))
    except (OSError, json.JSONDecodeError):
        return default


def _save(path: Path, data) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    tmp = path.with_suffix(path.suffix + ".tmp")
    tmp.write_text(json.dumps(data, ensure_ascii=False, indent=1) + "\n", encoding="utf-8")
    os.replace(tmp, path)


def _now() -> str:
    return time.strftime("%Y-%m-%dT%H:%M:%S")


# ---------------------------------------------------------------- pictures
def image_path(p: str) -> Path | None:
    """A picture the map may serve: an image file inside one of IMG_ROOTS (repo-relative or absolute)."""
    p = (p or "").strip().replace("\\", "/")
    if not p or ".." in p.split("/"):
        return None
    full = (Path(p) if (":" in p or p.startswith("/")) else REPO / p).resolve()
    if full.suffix.lower() not in IMG_TYPES or not full.is_file():
        return None
    for root in IMG_ROOTS:
        try:
            full.relative_to(root.resolve())
            return full
        except ValueError:
            continue
    return None


def thumb(full: Path) -> Path:
    """The 640 px JPEG preview of a picture, made once per file version."""
    st = full.stat()
    key = hashlib.sha1(f"{full}|{st.st_mtime_ns}|{st.st_size}".encode()).hexdigest()[:20]
    out = THUMBS / f"{key}.jpg"
    if not out.is_file():
        from PIL import Image  # noqa: PLC0415
        THUMBS.mkdir(parents=True, exist_ok=True)
        with Image.open(full) as im:
            im = im.convert("RGB")
            if im.width > THUMB_W:
                im = im.resize((THUMB_W, max(1, round(im.height * THUMB_W / im.width))), Image.LANCZOS)
            tmp = out.with_suffix(".tmp")
            im.save(tmp, "JPEG", quality=82)
            os.replace(tmp, out)
    return out


def _rel(full: Path) -> str:
    try:
        return full.resolve().relative_to(REPO.resolve()).as_posix()
    except ValueError:
        return full.resolve().as_posix()


def _gallery(frame: dict) -> list[dict]:
    out, missing = [], []
    for pattern in frame.get("globs", []):
        base = pattern if (":" in pattern or pattern.startswith("/")) else str(REPO / pattern)
        hits = sorted(_glob.glob(base), key=lambda f: (os.path.getmtime(f), f) if frame.get("last") else (0, f))
        hits = [h for h in hits if image_path(h)]
        if not hits:
            missing.append(pattern)
        out.extend(hits)
    if frame.get("last"):
        out = out[-int(frame["last"]):]
    frame["_missing"] = missing
    caps = frame.get("captions", {})
    return [{"p": _rel(Path(h)), "caption": caps.get(Path(h).name, Path(h).stem.replace("_real", "").replace("_", " "))} for h in out]


# ---------------------------------------------------------------- frames
def _where() -> list[dict]:
    sys.path.insert(0, str(ROOT / "Tools"))
    import where_we_are  # noqa: PLC0415
    c = where_we_are.cards()
    return [{"title": "DONE earlier", "cards": c.get("done_earlier", [])},
            {"title": "DONE in " + (c.get("session") or "this session"), "cards": c.get("done_session", [])},
            {"title": "NOW", "cards": c.get("now", [])}, {"title": "NEXT", "cards": c.get("next", [])}]


def _queue() -> list[dict]:
    plan = _load(ROOT / "AgentComms" / "roadmap.json", {}).get("plan", {})
    runs = _load(ROOT / "AgentComms" / "live_runs.json", {})
    runs = runs.get("runs", runs) if isinstance(runs, dict) else {}
    item = lambda x: {"title": x} if isinstance(x, str) else (x or {})  # noqa: E731
    seats = [{"text": f"{v.get('agent', '?')}: {v.get('title', k)}"[:110], "who": "agent"}
             for k, v in runs.items() if isinstance(v, dict) and str(v.get("status", "")).lower() in ("running", "queued", "started")]
    now = [{"text": (f"{i.get('id')}: " if i.get("id") else "") + str(i.get("title", ""))[:100], "who": i.get("who", "claude")}
           for i in map(item, plan.get("working_now", []))]
    nxt = [{"text": (f"{i.get('id')}: " if i.get("id") else "") + str(i.get("title", ""))[:100], "who": i.get("who", "claude")}
           for i in map(item, plan.get("next", []))]
    return [{"title": "Seats working", "cards": seats}, {"title": "Claude now", "cards": now}, {"title": "Up next, in order", "cards": nxt}]


def _who(w: str) -> str:
    w = (w or "claude").lower()
    return w if w in ("claude", "operator") else "agent"


def board() -> dict:
    """Everything the page draws: rows of frames with their content filled in, and the notes."""
    cfg = _load(FRAMES, {"rows": []})
    rows = []
    for row in cfg.get("rows", []):
        frames = []
        for f in row.get("frames", []):
            f = dict(f)
            kind = f.get("kind", "cards")
            try:
                if kind == "where":
                    f["columns"] = _where()
                elif kind == "queue":
                    f["columns"] = _queue()
                elif kind == "gallery":
                    f["images"] = _gallery(f)
            except Exception as exc:  # noqa: BLE001 - one broken frame never blanks the map
                f["error"] = f"{type(exc).__name__}: {exc}"
            for col in f.get("columns", []):
                col["cards"] = [{"text": c.get("text", "") if isinstance(c, dict) else str(c),
                                 "who": _who(c.get("who", "") if isinstance(c, dict) else ""),
                                 **({"done": True} if isinstance(c, dict) and c.get("done") else {})} for c in col.get("cards", [])]
            f.pop("globs", None)
            frames.append(f)
        rows.append({"title": row.get("title", ""), "frames": frames})
    return {"updated": _now(), "rows": rows, "notes": _load(NOTES, [])}


# ---------------------------------------------------------------- notes
def note_op(payload: dict) -> dict:
    """The page's saves: {"op": "save", "note": {...}} or {"op": "delete", "id": ...}. Returns {"ok", "note"|"error"}."""
    op = str(payload.get("op", ""))
    with _LOCK:
        notes = _load(NOTES, [])
        if op == "delete":
            nid = str(payload.get("id", ""))
            left = [n for n in notes if n.get("id") != nid]
            if len(left) == len(notes):
                return {"ok": False, "error": "no such note"}
            _save(NOTES, left)
            return {"ok": True}
        if op != "save" or not isinstance(payload.get("note"), dict):
            return {"ok": False, "error": "unknown op"}
        src = payload["note"]
        nid = str(src.get("id") or "")
        note = next((n for n in notes if n.get("id") == nid), None)
        if note is None:
            nums = [int(n["id"][1:]) for n in notes if str(n.get("id", ""))[1:].isdigit()]
            note = {"id": f"N{max(nums, default=0) + 1}", "who": _who(str(src.get("who", "operator"))), "created": _now()}
            notes.append(note)
        text = str(src.get("text", note.get("text", "")))[:2000]
        if text != note.get("text"):
            note["updated"] = _now()           # only a change of words is news for `start`; a drag is not
        note.update({"text": text, "frame": str(src.get("frame", note.get("frame", "")))[:60],
                     "x": round(float(src.get("x", note.get("x", 0)))), "y": round(float(src.get("y", note.get("y", 0)))),
                     "color": str(src.get("color", note.get("color", "yellow")))[:12]})
        note.setdefault("updated", note["created"])
        _save(NOTES, notes)
        return {"ok": True, "note": note}


def unseen(mark: bool = True, everything: bool = False) -> list[dict]:
    """His notes written or reworded since `start` last printed them (empty notes never count)."""
    seen = _load(SEEN, {})
    notes = [n for n in _load(NOTES, []) if n.get("who") == "operator" and str(n.get("text", "")).strip() and not n.get("done")]
    out = [n for n in notes if everything or seen.get(n["id"]) != n.get("updated")]
    if mark and out and not everything:
        seen.update({n["id"]: n.get("updated") for n in out})
        _save(SEEN, seen)
    return out


def frame_titles() -> dict:
    return {f.get("id"): f.get("title", "") for r in _load(FRAMES, {"rows": []}).get("rows", []) for f in r.get("frames", [])}


def print_notes(everything: bool = False) -> int:
    titles = frame_titles()
    rows = unseen(everything=everything)
    for n in rows:
        where = titles.get(n.get("frame"), n.get("frame") or "the map")
        print(f"  {n['id']} on \"{where}\" ({n.get('updated', '')[:16]}): {n.get('text', '').strip()}"
              + (f"   [answered: {n['reply']}]" if n.get("reply") else ""))
    return len(rows)


def _edit_note(nid: str, **fields) -> bool:
    with _LOCK:
        notes = _load(NOTES, [])
        for n in notes:
            if n.get("id") == nid:
                n.update(fields)
                _save(NOTES, notes)
                return True
    return False


# ---------------------------------------------------------------- CLI
def _put_frame(row_title: str, frame: dict) -> None:
    cfg = _load(FRAMES, {"rows": []})
    for row in cfg["rows"]:
        for i, f in enumerate(row["frames"]):
            if f.get("id") == frame["id"]:
                row["frames"][i] = frame
                _save(FRAMES, cfg)
                return
    row = next((r for r in cfg["rows"] if r.get("title") == row_title), None)
    if row is None:
        row = {"title": row_title, "frames": []}
        cfg["rows"].append(row)
    row["frames"].append(frame)
    _save(FRAMES, cfg)


def _opt(args: list[str], name: str, default=None, many: bool = False):
    vals = []
    while name in args:
        i = args.index(name)
        vals.append(args[i + 1])
        del args[i:i + 2]
    return vals if many else (vals[-1] if vals else default)


def main(argv: list[str]) -> int:
    if not argv:
        print(__doc__)
        return 0
    cmd, args = argv[0], argv[1:]
    if cmd == "notes":
        if not print_notes(everything="--all" in args):
            print("  (no new notes on the map)")
        return 0
    if cmd in ("reply", "done"):
        ok = _edit_note(args[0], **({"reply": args[1], "reply_at": _now()} if cmd == "reply" else {"done": True}))
        print("ok" if ok else f"no note {args[0]}")
        return 0 if ok else 1
    if cmd == "rm":
        cfg = _load(FRAMES, {"rows": []})
        for row in cfg["rows"]:
            row["frames"] = [f for f in row["frames"] if f.get("id") != args[0]]
        cfg["rows"] = [r for r in cfg["rows"] if r["frames"]]
        _save(FRAMES, cfg)
        return 0
    if cmd in ("gallery", "cards"):
        row, cols, last = _opt(args, "--row", "More"), _opt(args, "--cols"), _opt(args, "--last")
        score, note, colspecs = _opt(args, "--score"), _opt(args, "--note"), _opt(args, "--col", many=True)
        frame = {"id": args[0], "title": args[1], "kind": cmd}
        if note:
            frame["note"] = note
        if cmd == "gallery":
            frame["globs"] = args[2:]
            if cols:
                frame["cols"] = int(cols)
            if last:
                frame["last"] = int(last)
        else:
            frame["columns"] = [{"title": c.split("=", 1)[0], "cards": [{"text": t.strip(), "who": "claude"}
                                 for t in c.split("=", 1)[1].split("|") if t.strip()]} for c in colspecs]
            if score:
                frame["score"] = score
        _put_frame(row, frame)
        cmd = "check"
    if cmd == "check":
        for row in board()["rows"]:
            print(row["title"])
            for f in row["frames"]:
                n = len(f.get("images", [])) or sum(len(c["cards"]) for c in f.get("columns", [])) or len(f.get("links", []))
                bad = (f"  MISSING {f['_missing']}" if f.get("_missing") else "") + (f"  ERROR {f['error']}" if f.get("error") else "")
                print(f"  {f.get('id'):<14} {f.get('kind', 'cards'):<8} {n:>4}  {f.get('title')}{bad}")
        return 0
    print(f"unknown command {cmd}")
    return 2


if __name__ == "__main__":
    sys.exit(main(sys.argv[1:]))
