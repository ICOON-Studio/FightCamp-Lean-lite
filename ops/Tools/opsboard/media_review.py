"""S192 operator: "you produced stills and videos, i want to be able to see those on the opsboard to make comments".

The /review page lists (1) everything Claude SENT him - one post per batch under E:/FightCamp/review/<batch>/ with a
manifest.json (title, stage, at, files[{name, caption}]) written by Tools/review_add.py - and (2) every folder of
previews, newest first, files loaded per folder. His comments land in AgentComms/media_comments.json;
`agent_comms.py start` prints the unseen ones (quote and act) and marks them seen.

Media keys: "_sent/<batch>/<file>" for a sent file, otherwise a path relative to previews.

S223 operator: "add option for me to remove the old pictures from the opsboard ... keep the latest versions on". Remove
MOVES a post (or one file of it) into <review root>/_removed/<batch>/ - nothing is deleted, the Removed tab restores it.
A post Claude replaced carries "superseded_by" in its manifest (review_add.py --supersedes) and shows "Older version".
"""
from __future__ import annotations

import json
import os
import re
import shutil
import tempfile
from datetime import datetime, timezone
from pathlib import Path
from typing import Any

MEDIA_TYPES = {".mp4": "video/mp4", ".webm": "video/webm", ".png": "image/png", ".jpg": "image/jpeg",
               ".jpeg": "image/jpeg", ".gif": "image/gif"}
SENT_PREFIX = "_sent/"
COMMENT_MAX = 1000
REMOVED_DIR = "_removed"
_BATCH_RE = re.compile(r"^[0-9]{4}-[0-9]{2}-[0-9]{2}_[0-9]{4}_[A-Za-z0-9_]+$")


def review_root() -> Path:
    return Path(os.environ.get("FIGHTCAMP_REVIEW_DIR", r"E:\FightCamp\review")).resolve()


def comments_path(root: Path) -> Path:
    return root / "AgentComms" / "media_comments.json"


def resolve(previews: Path, rel: str) -> Path | None:
    """A media file for a key, or None (no traversal, known types only)."""
    base = review_root() if rel.startswith(SENT_PREFIX) else previews.resolve()
    sub = rel[len(SENT_PREFIX):] if rel.startswith(SENT_PREFIX) else rel
    try:
        target = (base / sub).resolve()
    except (OSError, ValueError):
        return None
    if base not in target.parents or target.suffix.lower() not in MEDIA_TYPES:
        return None
    if not target.is_file() and rel.startswith(SENT_PREFIX):
        target = (base / REMOVED_DIR / sub).resolve()  # a removed post still shows on the Removed tab
    if not target.is_file():
        return None
    return target


def _kind(p: Path) -> str:
    return "video" if MEDIA_TYPES.get(p.suffix.lower(), "").startswith("video") else "image"


def load_comments(root: Path) -> dict[str, Any]:
    try:
        data = json.loads(comments_path(root).read_text(encoding="utf-8"))
    except (OSError, json.JSONDecodeError):
        data = {}
    if not isinstance(data, dict) or not isinstance(data.get("comments"), list):
        data = {"_doc": "Operator comments on stills/videos (ops board /review). start prints unseen ones.", "comments": []}
    return data


def _save(path: Path, data: Any) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    fd, tmp = tempfile.mkstemp(prefix=path.name + ".", suffix=".tmp", dir=str(path.parent))
    with os.fdopen(fd, "w", encoding="utf-8", newline="\n") as fh:
        json.dump(data, fh, indent=2, ensure_ascii=False)
        fh.write("\n")
    os.replace(tmp, path)


def add_comment(root: Path, previews: Path, payload: dict[str, Any]) -> tuple[int, dict[str, Any]]:
    key = str(payload.get("path", ""))
    text = payload.get("text")
    if not isinstance(text, str) or not text.strip():
        return 400, {"error": "comment is empty"}
    if len(text) > COMMENT_MAX:
        return 400, {"error": "comment must be at most %d characters" % COMMENT_MAX}
    if resolve(previews, key) is None:
        return 404, {"error": "unknown file"}
    at_s = payload.get("at_s")
    row: dict[str, Any] = {"path": key, "text": text.strip(),
                           "at": datetime.now(timezone.utc).strftime("%Y-%m-%dT%H:%M:%SZ"), "seen_by_claude": False}
    if isinstance(at_s, (int, float)) and at_s >= 0:
        row["at_s"] = round(float(at_s), 1)
    data = load_comments(root)
    row["id"] = "C%d" % (len(data["comments"]) + 1)
    data["comments"].append(row)
    _save(comments_path(root), data)
    return 200, row


def _by_path(root: Path) -> dict[str, list[dict[str, Any]]]:
    out: dict[str, list[dict[str, Any]]] = {}
    for c in load_comments(root)["comments"]:
        if isinstance(c, dict):
            out.setdefault(str(c.get("path", "")), []).append(c)
    return out


def _filter(root: Path | None = None) -> dict[str, Any]:
    """S207 operator ruling: MetaHuman media only on the board (AgentComms/review_filter.json)."""
    base = root if root is not None else Path(__file__).resolve().parents[2]
    try:
        return json.loads((base / "AgentComms" / "review_filter.json").read_text(encoding="utf-8"))
    except (OSError, json.JSONDecodeError):
        return {}


def _denied(name: str, flt: dict[str, Any], rel: str = "") -> bool:
    low = name.lower()
    path_low = (rel or name).lower()
    return any(str(w).lower() in low for w in flt.get("deny_name_contains", [])) or         any(str(w).lower() in path_low for w in flt.get("deny_path_contains", []))


def _read_manifest(batch: Path) -> dict[str, Any]:
    try:
        man = json.loads((batch / "manifest.json").read_text(encoding="utf-8"))
    except (OSError, json.JSONDecodeError):
        man = {}
    return man if isinstance(man, dict) else {}


def _posts_in(base: Path, notes: dict[str, list[dict[str, Any]]]) -> list[dict[str, Any]]:
    posts: list[dict[str, Any]] = []
    if not base.is_dir():
        return posts
    for batch in base.iterdir():
        if not batch.is_dir() or batch.name.startswith("_"):
            continue
        man = _read_manifest(batch)
        captions = {str(f.get("name")): str(f.get("caption", "")) for f in man.get("files", []) if isinstance(f, dict)}
        files = []
        for p in sorted(batch.iterdir()):
            if p.suffix.lower() in MEDIA_TYPES and p.is_file():
                key = SENT_PREFIX + batch.name + "/" + p.name
                files.append({"key": key, "name": p.name, "kind": _kind(p), "caption": captions.get(p.name, ""),
                              "comments": notes.get(key, [])})
        if files:
            posts.append({"batch": batch.name, "title": str(man.get("title", batch.name)), "stage": str(man.get("stage", "")),
                          "rating": str(man.get("rating", "")), "at": str(man.get("at", "")), "mtime": batch.stat().st_mtime, "files": files,
                          "superseded_by": str(man.get("superseded_by", "")), "removed_at": str(man.get("removed_at", ""))})
    posts.sort(key=lambda p: (p["at"] or "", p["mtime"]), reverse=True)
    return posts


## S233 operator: "the boards stills page is a fckin mess can you fix it and auto clear old bs , i want to be able to see the
## recent ones". A post older than AUTO_CLEAR_DAYS, past the newest KEEP_MAX, or replaced by a newer version moves to Removed by
## itself (restorable, nothing deleted); the newest KEEP_NEWEST always stay; a post he restored ("kept") is never swept again.
AUTO_CLEAR_DAYS = 1.0
KEEP_NEWEST = 6   ## always shown, whatever their age
KEEP_MAX = 10     ## never more than this many posts on the page


def auto_clear(now: datetime | None = None) -> list[str]:
    rr = review_root()
    posts = _posts_in(rr, {})
    now = now or datetime.now()
    done: list[str] = []
    for i, p in enumerate(posts):
        if i < KEEP_NEWEST or _read_manifest(rr / p["batch"]).get("kept"):
            continue
        try:
            at = datetime.strptime(p["at"][:16].replace(" ", "T"), "%Y-%m-%dT%H:%M") if p["at"] else datetime.fromtimestamp(p["mtime"])
        except ValueError:
            at = datetime.fromtimestamp(p["mtime"])
        if p["superseded_by"] or i >= KEEP_MAX or (now - at).total_seconds() > AUTO_CLEAR_DAYS * 86400:
            stamp = {"removed_at": now.strftime("%Y-%m-%dT%H:%M"), "auto_cleared": True}
            if _move_media(rr / p["batch"], rr / REMOVED_DIR / p["batch"], None, stamp):
                done.append(p["batch"])
    return done


def sent_posts(root: Path) -> list[dict[str, Any]]:
    auto_clear()
    return _posts_in(review_root(), _by_path(root))


def removed_posts(root: Path) -> list[dict[str, Any]]:
    """Removed posts/files (restorable). Their keys still read "_sent/<batch>/<file>" so old comments stay attached."""
    return _posts_in(review_root() / REMOVED_DIR, _by_path(root))


def _move_media(src_batch: Path, dst_batch: Path, name: str | None, stamp: dict[str, Any]) -> int:
    """Move one file (or every media file) of a batch; the manifest travels with it. Returns the files moved."""
    if not src_batch.is_dir():
        return 0
    names = [name] if name else [p.name for p in src_batch.iterdir() if p.suffix.lower() in MEDIA_TYPES and p.is_file()]
    dst_batch.mkdir(parents=True, exist_ok=True)
    man = _read_manifest(src_batch) or _read_manifest(dst_batch)
    man.update(stamp)
    for k in [k for k, v in stamp.items() if v is None]:
        man.pop(k, None)
    moved = 0
    for n in names:
        src = src_batch / n
        if src.suffix.lower() not in MEDIA_TYPES or not src.is_file():
            continue
        dst = dst_batch / n
        if dst.exists():
            dst = dst_batch / ("%s_r%s%s" % (src.stem, datetime.now().strftime("%H%M%S"), src.suffix))
        shutil.move(str(src), str(dst))
        moved += 1
    if moved:
        _save(dst_batch / "manifest.json", man)
    left = [p for p in src_batch.iterdir() if p.suffix.lower() in MEDIA_TYPES and p.is_file()]
    if not left:
        for p in list(src_batch.iterdir()):
            if p.is_file():
                p.unlink()
        src_batch.rmdir()
    return moved


def _batch_and_file(payload: dict[str, Any]) -> tuple[str, str | None] | None:
    batch = str(payload.get("batch", ""))
    name = payload.get("file")
    if not _BATCH_RE.match(batch):
        return None
    if name is not None:
        name = str(name)
        if "/" in name or "\\" in name or name.startswith(".") or Path(name).suffix.lower() not in MEDIA_TYPES:
            return None
    return batch, name


def remove_media(payload: dict[str, Any]) -> tuple[int, dict[str, Any]]:
    """Body {batch, file?}: the whole post, or one file of it, moves to _removed/ (restorable)."""
    bf = _batch_and_file(payload)
    if bf is None:
        return 400, {"error": "bad batch or file"}
    rr = review_root()
    stamp = {"removed_at": datetime.now().strftime("%Y-%m-%dT%H:%M")}
    n = _move_media(rr / bf[0], rr / REMOVED_DIR / bf[0], bf[1], stamp)
    return (200, {"removed": n}) if n else (404, {"error": "nothing to remove"})


def restore_media(payload: dict[str, Any]) -> tuple[int, dict[str, Any]]:
    bf = _batch_and_file(payload)
    if bf is None:
        return 400, {"error": "bad batch or file"}
    rr = review_root()
    stamp: dict[str, Any] = {"removed_at": None, "auto_cleared": None, "kept": True}  # restored = kept: auto_clear skips it
    if bf[1] is None:
        stamp["superseded_by"] = None  # a post he restores is one he keeps: no "Older version" sweep takes it again
    n = _move_media(rr / REMOVED_DIR / bf[0], rr / bf[0], bf[1], stamp)
    return (200, {"restored": n}) if n else (404, {"error": "nothing to restore"})


def remove_older_versions() -> tuple[int, dict[str, Any]]:
    """Every post marked superseded_by moves to _removed/ (the operator's one-click "keep the latest versions")."""
    rr = review_root()
    done = []
    for p in _posts_in(rr, {}):
        if p["superseded_by"]:
            code, _ = remove_media({"batch": p["batch"]})
            if code == 200:
                done.append(p["batch"])
    return 200, {"removed_posts": done}


def mark_superseded(old_batches: list[str], new_batch: str) -> list[str]:
    """review_add.py --supersedes: stamp superseded_by on older posts (a prefix of the batch name is enough)."""
    rr = review_root()
    hit = []
    for prefix in old_batches:
        for b in rr.iterdir():
            if b.is_dir() and not b.name.startswith("_") and b.name != new_batch and b.name.startswith(prefix):
                man = _read_manifest(b)
                man["superseded_by"] = new_batch
                _save(b / "manifest.json", man)
                hit.append(b.name)
    return hit


def preview_folders(previews: Path) -> list[dict[str, Any]]:
    out = []
    base = previews.resolve()
    if not base.is_dir():
        return out
    flt = _filter()
    allow = flt.get("allow_folders")
    for d in base.iterdir():
        if not d.is_dir() or d.name.startswith("_"):
            continue
        if allow is not None and d.name not in allow:
            continue
        n = 0
        newest = 0.0
        for p in d.rglob("*"):
            if p.suffix.lower() in MEDIA_TYPES and not _denied(p.name, flt, p.relative_to(d).as_posix()):
                n += 1
                newest = max(newest, p.stat().st_mtime)
        if n:
            out.append({"folder": d.name, "count": n, "newest": newest})
    out.sort(key=lambda f: f["newest"], reverse=True)
    return out


def folder_files(root: Path, previews: Path, folder: str) -> list[dict[str, Any]]:
    base = previews.resolve()
    d = (base / folder).resolve()
    if base not in d.parents or not d.is_dir():
        return []
    flt = _filter(root)
    if flt.get("allow_folders") is not None and folder not in flt["allow_folders"]:
        return []
    notes = _by_path(root)
    files = []
    for p in sorted(d.rglob("*")):
        if p.suffix.lower() in MEDIA_TYPES and p.is_file() and not _denied(p.name, flt, p.relative_to(d).as_posix()):
            key = p.relative_to(base).as_posix()
            files.append({"key": key, "name": p.relative_to(d).as_posix(), "kind": _kind(p), "caption": "",
                          "comments": notes.get(key, [])})
    return files
