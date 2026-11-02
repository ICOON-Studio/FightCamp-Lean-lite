"""seat_queue.py - S249 (operator: remove the human bottlenecks): chat seats keep working between Claude sessions.

John / Kalli / Maria (Grok Bot, Tools/gbot.py) and Dola (Cici app, Tools/cici/cici.py) are scriptable, but only answered while a
Claude session drove them. A session now QUEUES a brief; the 30-min "FightCamp Board Reconcile" task (board_reconcile.py --apply)
drains the queue, and the answer lands in research/<stem>.md. `python Tools/agent_comms.py start` prints each new answer
once (SEAT ANSWERS) - Claude still verifies its sources, commits it and acts on it.

    python Tools/seat_queue.py add --seat john --brief research/TASK_J70.md [--stem J70_ANSWER]
    python Tools/seat_queue.py list
    python Tools/seat_queue.py drain [--dry-run]       # what the 30-min task runs (one step per item per cycle)

Per cycle, per seat, at most ONE item is in flight (replies of two briefs would mix in one thread):
  john/kalli/maria  queued -> `gbot.py send --to <bot> --file <brief>` (GROKBOT SENT = sent; anything else = unreachable, retried next
                    cycle) -> each later cycle `gbot.py thread --to <bot> --limit 60 --out <json>`: the bot's messages after the send;
                    answered once they total >= 1,500 chars and nothing new came for 15 min, or nothing new for 60 min.
  dola              queued -> `cici.py status` must reach the app's debug port (never `launch`: that opens a window on the operator's
                    screen) -> a hidden, detached `cici.py send --new --file <brief> --wait 2400 --out <transcript>` -> the transcript
                    file appears when her reply settles -> answered.
Every subprocess runs with CREATE_NO_WINDOW; nothing opens on a monitor. Log: AgentComms/seat_queue.log.
"""
from __future__ import annotations

import argparse
import ctypes
import json
import os
import re
import subprocess
import sys
import tempfile
import time
from datetime import datetime, timezone
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
QUEUE = ROOT / "AgentComms" / "seat_queue.json"
LOG = ROOT / "AgentComms" / "seat_queue.log"
SEAT_LOGS = ROOT / "AgentComms" / "seat_logs"
RESEARCH = ROOT / "research"
GBOT_SEATS = {"john": "John Research", "kalli": "Kalli", "maria": "Maria Art Director"}
SEATS = tuple(GBOT_SEATS) + ("dola",)
MAX_TRIES = 6
ANSWER_MIN_CHARS, QUIET_MIN, QUIET_MAX_MIN = 1500, 15, 60
GIVE_UP_H = 24
_NO_WINDOW = getattr(subprocess, "CREATE_NO_WINDOW", 0)
_DETACHED = 0x00000008 | 0x00000200  # DETACHED_PROCESS | CREATE_NEW_PROCESS_GROUP


def _now() -> str:
    return datetime.now().strftime("%Y-%m-%d %H:%M")


def _log(line: str) -> str:
    with LOG.open("a", encoding="utf-8") as fh:
        fh.write("%s %s\n" % (_now(), line))
    return line


def load() -> dict:
    try:
        return json.loads(QUEUE.read_text(encoding="utf-8-sig"))
    except (OSError, ValueError):
        return {"_doc": "Chat-seat briefs drained by the 30-min reconcile (Tools/seat_queue.py). status: queued -> sent -> answered "
                        "| failed. Add with `python Tools/seat_queue.py add --seat <john|kalli|maria|dola> --brief <file>`.",
                "items": []}


def save(data: dict) -> None:
    fd, tmp = tempfile.mkstemp(prefix="seat_queue.", suffix=".tmp", dir=str(QUEUE.parent))
    with os.fdopen(fd, "w", encoding="utf-8", newline="\n") as fh:
        json.dump(data, fh, indent=1, ensure_ascii=False)
        fh.write("\n")
    os.replace(tmp, QUEUE)


def _py(*args: str, timeout: int = 360) -> subprocess.CompletedProcess:
    return subprocess.run([sys.executable, *args], cwd=ROOT, capture_output=True, text=True, encoding="utf-8", errors="replace",
                          timeout=timeout, creationflags=_NO_WINDOW)


def _alive(pid: int) -> bool:
    """Windows: OpenProcess + GetExitCodeProcess (os.kill(pid, 0) would TERMINATE it on Windows)."""
    if not pid:
        return False
    if os.name != "nt":
        try:
            os.kill(pid, 0)
            return True
        except OSError:
            return False
    k32 = ctypes.windll.kernel32
    h = k32.OpenProcess(0x1000, False, int(pid))  # PROCESS_QUERY_LIMITED_INFORMATION
    if not h:
        return False
    code = ctypes.c_ulong()
    ok = k32.GetExitCodeProcess(h, ctypes.byref(code))
    k32.CloseHandle(h)
    return bool(ok) and code.value == 259  # STILL_ACTIVE


def add(seat: str, brief: str, stem: str = "") -> dict:
    seat = seat.lower()
    if seat not in SEATS:
        raise SystemExit("seat must be one of %s" % ", ".join(SEATS))
    path = Path(brief)
    rel = (path if path.is_absolute() else ROOT / path).resolve()
    if not rel.is_file():
        raise SystemExit("no such brief: %s" % brief)
    rel_s = rel.relative_to(ROOT).as_posix() if rel.is_relative_to(ROOT) else str(rel)
    stem = stem or re.sub(r"^(TASK_|BRIEF_)", "", rel.stem) + "_" + seat.upper()
    data = load()
    n = 1 + max([int(m.group(1)) for i in data["items"] if (m := re.fullmatch(r"SQ(\d+)", str(i.get("id", ""))))] or [0])
    item = {"id": "SQ%d" % n, "seat": seat, "brief": rel_s, "stem": stem, "status": "queued", "queued_at": _now(), "tries": 0}
    data["items"].append(item)
    save(data)
    _log("ADD %s %s %s -> %s" % (item["id"], seat, rel_s, stem))
    return item


def _answer_path(stem: str) -> Path:
    path = RESEARCH / ("%s.md" % stem)
    k = 2
    while path.exists():
        path = RESEARCH / ("%s_%d.md" % (stem, k))
        k += 1
    return path


def _write_answer(item: dict, body: str, extra: str = "") -> str:
    path = _answer_path(item["stem"])
    head = ("# %s - %s answer (seat queue %s)\n\nBrief: %s\nSent: %s | collected: %s by Tools/seat_queue.py (the 30-min reconcile)\n%s"
            "Verify the sources before using it.\n\n---\n\n" % (item["stem"], item["seat"].title(), item["id"], item["brief"],
                                                             item.get("sent_at", "?"), _now(), extra))
    path.write_text(head + body.strip() + "\n", encoding="utf-8")
    return path.relative_to(ROOT).as_posix()


def _skip(item: dict, why: str) -> str:
    """The seat's app is not reachable: log it and retry next cycle - never counted as a failed try."""
    item["skips"] = int(item.get("skips", 0)) + 1
    item["last_error"] = "%s %s" % (_now(), why[:300])
    return _log("SKIP %s [%s] unreachable: %s - retry next cycle" % (item["id"], item["seat"], why[:200]))


def _fail_try(item: dict, why: str) -> str:
    item["tries"] = int(item.get("tries", 0)) + 1
    item["last_error"] = "%s %s" % (_now(), why[:300])
    if item["tries"] >= MAX_TRIES:
        item["status"] = "failed"
        return _log("FAILED %s [%s] after %d tries: %s" % (item["id"], item["seat"], item["tries"], why[:200]))
    return _log("SKIP %s [%s] try %d: %s - retry next cycle" % (item["id"], item["seat"], item["tries"], why[:200]))


def _gbot_send(item: dict, dry: bool) -> str:
    if dry:
        return "DRY %s would send %s to %s" % (item["id"], item["brief"], item["seat"])
    try:
        r = _py("Tools/gbot.py", "send", "--to", item["seat"], "--file", item["brief"])
    except subprocess.TimeoutExpired:
        return _skip(item, "gbot send timed out (Grok Bot box unreachable)")
    out = (r.stdout or "") + (r.stderr or "")
    if r.returncode != 0 or "GROKBOT SENT" not in out:
        return _skip(item, "gbot send rc=%s: %s" % (r.returncode, out.strip().splitlines()[-1:] or "no output"))
    item.update(status="sent", sent_at=_now(), sent_ms=int(time.time() * 1000) - 5000)
    return _log("SENT %s -> %s (%s)" % (item["id"], item["seat"], out.strip().splitlines()[-1][:160]))


def _gbot_poll(item: dict, dry: bool) -> str:
    tmp = SEAT_LOGS / ("%s_tail.json" % item["id"])
    SEAT_LOGS.mkdir(parents=True, exist_ok=True)
    try:
        r = _py("Tools/gbot.py", "thread", "--to", item["seat"], "--limit", "60", "--out", str(tmp))
        data = json.loads(tmp.read_text(encoding="utf-8")) if r.returncode == 0 and tmp.is_file() else None
    except (subprocess.TimeoutExpired, OSError, ValueError) as exc:
        data, r = None, exc
    if not isinstance(data, dict):
        return _log("SKIP %s [%s] thread unreadable (%s) - retry next cycle" % (item["id"], item["seat"], str(r)[:120]))
    since = int(item.get("sent_ms", 0))
    mine = [e for e in data.get("entries", []) if e.get("kind") == "send-message" and int(e.get("timestampMs", 0)) > since]
    texts = [str(e["message"].get("content", "")) for e in mine if (e.get("message") or {}).get("type") == "text"]
    files = [str(e["message"].get("file_name", "")) for e in mine if (e.get("message") or {}).get("type") == "attachment"]
    chars = sum(len(t) for t in texts)
    last = max([int(e.get("timestampMs", 0)) for e in mine] or [since])
    quiet = (time.time() * 1000 - last) / 60000.0
    if texts and ((chars >= ANSWER_MIN_CHARS and quiet >= QUIET_MIN) or quiet >= QUIET_MAX_MIN):
        if dry:
            return "DRY %s answered (%d chars, quiet %.0f min)" % (item["id"], chars, quiet)
        extra = ("Attachments on the bot's box (not downloaded): %s\n" % ", ".join(files)) if files else ""
        item.update(status="answered", answered_at=_now(), answer=_write_answer(item, "\n\n".join(texts), extra), chars=chars)
        return _log("ANSWERED %s [%s] %d chars -> %s" % (item["id"], item["seat"], chars, item["answer"]))
    if not texts and quiet >= GIVE_UP_H * 60:
        item["status"] = "failed"
        return _log("FAILED %s [%s] no reply in %d h" % (item["id"], item["seat"], GIVE_UP_H))
    return "WAIT %s [%s] %d chars so far, quiet %.0f min" % (item["id"], item["seat"], chars, quiet)


def _dola_reachable() -> tuple[bool, str]:
    try:
        r = _py("Tools/cici/cici.py", "status", timeout=60)
    except subprocess.TimeoutExpired:
        return False, "cici status timed out"
    if r.returncode != 0:
        return False, "no CDP on 9333 (the app runs without its debug port or is closed; never launched from here - it opens a window)"
    if "streaming: yes" in r.stdout:
        return False, "Dola is still streaming another reply"
    return True, ""


def _dola_send(item: dict, dry: bool) -> str:
    ok, why = _dola_reachable()
    if not ok:
        return _skip(item, why) if not dry else "DRY %s dola unreachable: %s" % (item["id"], why)
    if dry:
        return "DRY %s would send %s to dola (fresh chat)" % (item["id"], item["brief"])
    SEAT_LOGS.mkdir(parents=True, exist_ok=True)
    transcript = SEAT_LOGS / ("%s_dola.txt" % item["id"])
    console = (SEAT_LOGS / ("%s_dola.log" % item["id"])).open("w", encoding="utf-8")
    proc = subprocess.Popen([sys.executable, "Tools/cici/cici.py", "send", "--new", "--file", item["brief"], "--wait", "2400",
                             "--out", str(transcript)], cwd=ROOT, stdin=subprocess.DEVNULL, stdout=console, stderr=subprocess.STDOUT,
                            creationflags=_NO_WINDOW | _DETACHED)
    item.update(status="sent", sent_at=_now(), pid=proc.pid, transcript=transcript.relative_to(ROOT).as_posix())
    return _log("SENT %s -> dola (hidden cici send pid %d, transcript %s)" % (item["id"], proc.pid, item["transcript"]))


def _dola_poll(item: dict, dry: bool) -> str:
    transcript = ROOT / str(item.get("transcript", ""))
    if _alive(int(item.get("pid", 0))):
        return "WAIT %s [dola] cici send pid %s still waiting for her reply" % (item["id"], item.get("pid"))
    if transcript.is_file() and transcript.stat().st_size > 0:
        if dry:
            return "DRY %s answered (%d bytes)" % (item["id"], transcript.stat().st_size)
        body = transcript.read_text(encoding="utf-8", errors="replace")
        item.update(status="answered", answered_at=_now(), answer=_write_answer(item, body, "(Dola's whole fresh chat: the brief, then her reply)\n"))
        return _log("ANSWERED %s [dola] %d chars -> %s" % (item["id"], len(body), item["answer"]))
    item["status"] = "queued"  # the send died without a reply: one more try next cycle
    return _fail_try(item, "cici send exited without a transcript (see %s)" % (SEAT_LOGS / ("%s_dola.log" % item["id"])).name)


def drain(dry: bool = False) -> list[str]:
    data = load()
    lines: list[str] = []
    busy = {i["seat"] for i in data["items"] if i.get("status") == "sent"}
    for item in data["items"]:
        status, seat = item.get("status"), item.get("seat")
        try:
            if status == "sent":
                lines.append(_dola_poll(item, dry) if seat == "dola" else _gbot_poll(item, dry))
            elif status == "queued" and seat not in busy:
                busy.add(seat)
                lines.append(_dola_send(item, dry) if seat == "dola" else _gbot_send(item, dry))
        except Exception as exc:  # one seat never stops the others
            lines.append(_log("ERROR %s [%s] %s" % (item.get("id"), seat, exc)))
    if not dry:
        save(data)
    return lines


def consume_answers() -> list[dict]:
    """Answered items `start` has not printed yet; marks them seen."""
    data = load()
    rows = [i for i in data["items"] if i.get("status") == "answered" and not i.get("seen_by_claude")]
    for i in rows:
        i["seen_by_claude"] = True
    if rows:
        save(data)
    return rows


def pending() -> list[dict]:
    return [i for i in load()["items"] if i.get("status") in ("queued", "sent")]


def main(argv: list[str]) -> int:
    ap = argparse.ArgumentParser(description=__doc__.split("\n")[0])
    sub = ap.add_subparsers(dest="cmd", required=True)
    a = sub.add_parser("add")
    a.add_argument("--seat", required=True, choices=SEATS)
    a.add_argument("--brief", required=True)
    a.add_argument("--stem", default="")
    sub.add_parser("list")
    d = sub.add_parser("drain")
    d.add_argument("--dry-run", action="store_true")
    args = ap.parse_args(argv)
    if args.cmd == "add":
        item = add(args.seat, args.brief, args.stem)
        print("QUEUED %s [%s] %s -> research/%s.md (the 30-min reconcile sends it)" % (item["id"], item["seat"], item["brief"], item["stem"]))
    elif args.cmd == "list":
        for i in load()["items"]:
            print("%-5s %-6s %-9s %s -> %s %s" % (i.get("id"), i.get("seat"), i.get("status"), i.get("brief"), i.get("answer") or i.get("stem"),
                                                 ("| " + i["last_error"]) if i.get("last_error") else ""))
    else:
        for line in drain(dry=args.dry_run):
            print(line)
        print("SEAT_QUEUE drained (%s)" % ("dry run" if args.dry_run else "applied"))
    return 0


if __name__ == "__main__":
    sys.exit(main(sys.argv[1:]))
