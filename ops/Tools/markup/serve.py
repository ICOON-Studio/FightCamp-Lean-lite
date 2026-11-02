#!/usr/bin/env python3
"""Markup Board: the local server behind Tools/markup/markup_board.html.

Serves the board on http://127.0.0.1:8765/ and writes every saved board
into Feedback/<YYYY-MM-DD>-<nn>/ as original.png, marked.png, marks.json
and README.md (the digest any agent can read). Standard library only, so
it runs anywhere Python does and owes nothing to anyone.

Run:   python Tools/markup/serve.py [port] [--no-browser]
Demo:  open http://127.0.0.1:8765/?demo to load a sample image.
"""
import base64
import datetime
import json
import os
import re
import sys
import webbrowser
from http.server import BaseHTTPRequestHandler, ThreadingHTTPServer

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.abspath(os.path.join(HERE, "..", ".."))
FEEDBACK = os.path.join(ROOT, "Feedback")
PAGE = os.path.join(HERE, "markup_board.html")
IMG_DIR = os.path.join(ROOT, "previews", "ui_s185")
DEMO = os.path.join(ROOT, "DesignLibrary", "kit", "renders", "party.png")
TOOLS = ("pin", "box", "arrow", "pen")
INTENTS = ("wrong", "change", "keep", "move")
INTENT_KEY = ("Intent key: WRONG = this is wrong, fix it; CHANGE = adjust this; "
              "KEEP = this is good, keep it; MOVE = move it from the arrow's tail to its head.")
MAX_BODY = 60 * 1024 * 1024


def next_id(root, today):
    """The next free <today>-<nn> folder name under root."""
    n = 0
    if os.path.isdir(root):
        for name in os.listdir(root):
            m = re.match(re.escape(today) + r"-(\d\d)$", name)
            if m:
                n = max(n, int(m.group(1)))
    return "%s-%02d" % (today, n + 1)


def decode_image(data_url):
    """(extension, bytes) from a PNG or JPEG data URL."""
    m = re.match(r"data:image/(png|jpeg);base64,(.+)$", data_url or "", re.S)
    if not m:
        raise ValueError("expected a PNG or JPEG data URL")
    return ("jpg" if m.group(1) == "jpeg" else "png"), base64.b64decode(m.group(2))


def _num(value, default=0.0):
    try:
        return round(float(value), 1)
    except (TypeError, ValueError):
        return default


def _pt(d):
    d = d if isinstance(d, dict) else {}
    return {"x": _num(d.get("x")), "y": _num(d.get("y"))}


def clean_mark(raw, n):
    """One mark as the agents will read it: numbered, typed, percent coords."""
    raw = raw if isinstance(raw, dict) else {}
    tool = raw.get("tool") if raw.get("tool") in TOOLS else "pin"
    intent = raw.get("intent") if raw.get("intent") in INTENTS else "wrong"
    mark = {"n": n, "tool": tool, "intent": intent, "note": str(raw.get("note", "")).strip()[:500]}
    if tool == "arrow":
        mark["from"] = _pt(raw.get("from"))
        mark["to"] = _pt(raw.get("to"))
    else:
        mark.update(_pt(raw))
        if tool in ("box", "pen"):
            mark["w"] = _num(raw.get("w"))
            mark["h"] = _num(raw.get("h"))
        if tool == "pen":
            pts = raw.get("points") if isinstance(raw.get("points"), list) else []
            mark["points"] = [[_num(p[0]), _num(p[1])] for p in pts if isinstance(p, list) and len(p) == 2][:400]
    return mark


def describe(mark):
    """One digest line: '3. KEEP pin at 12.4%,8.1% - the stamina row'."""
    if mark["tool"] == "arrow":
        where = "from %s%%,%s%% to %s%%,%s%%" % (mark["from"]["x"], mark["from"]["y"], mark["to"]["x"], mark["to"]["y"])
    elif mark["tool"] == "pin":
        where = "at %s%%,%s%%" % (mark["x"], mark["y"])
    else:
        where = "at %s%%,%s%% size %sx%s%%" % (mark["x"], mark["y"], mark["w"], mark["h"])
    line = "%d. %s %s %s" % (mark["n"], mark["intent"].upper(), mark["tool"], where)
    return line + (" - " + mark["note"] if mark["note"] else "")


def digest(fid, payload, marks, files):
    width, height = int(payload.get("width") or 0), int(payload.get("height") or 0)
    lines = ["# Feedback %s" % fid, ""]
    if payload.get("title"):
        lines.append("**Title:** %s  " % payload["title"])
    if payload.get("source"):
        lines.append("**Source:** %s  " % payload["source"])
    lines.append("**Image:** `%s` (%dx%d px); marked copy `%s`  " % (files["original"], width, height, files["marked"]))
    lines.append("**Marks:** %d. Coordinates are percentages of the image, origin top-left; exact values in `marks.json`." % len(marks))
    lines += ["", "## Marks", ""]
    lines += [describe(m) for m in marks]
    lines += ["", INTENT_KEY, "Answer the user by mark number, e.g. \"point 3\"."]
    return "\n".join(lines) + "\n"


def save_feedback(payload, root=FEEDBACK, today=None):
    """Validate a board payload and write its folder. Returns {id, folder, marks}."""
    if not isinstance(payload, dict):
        raise ValueError("payload must be an object")
    ext, original = decode_image(payload.get("original"))
    _, marked = decode_image(payload.get("marked"))
    marks = [clean_mark(m, i + 1) for i, m in enumerate(payload.get("marks") or [])]
    if not marks:
        raise ValueError("no marks")
    today = today or datetime.date.today().isoformat()
    fid = next_id(root, today)
    folder = os.path.join(root, fid)
    os.makedirs(folder)
    files = {"original": "original." + ext, "marked": "marked.png"}
    with open(os.path.join(folder, files["original"]), "wb") as f:
        f.write(original)
    with open(os.path.join(folder, files["marked"]), "wb") as f:
        f.write(marked)
    doc = {
        "id": fid,
        "title": str(payload.get("title", "")).strip(),
        "source": str(payload.get("source", "")).strip(),
        "saved": datetime.datetime.now().isoformat(timespec="seconds"),
        "image": {"file": files["original"], "width": int(payload.get("width") or 0), "height": int(payload.get("height") or 0)},
        "marked": files["marked"],
        "coordinates": "percent of image size, origin top-left, x right, y down",
        "marks": marks,
    }
    with open(os.path.join(folder, "marks.json"), "w", encoding="utf-8") as f:
        json.dump(doc, f, indent=2)
    with open(os.path.join(folder, "README.md"), "w", encoding="utf-8") as f:
        f.write(digest(fid, payload, marks, files))
    return {"id": fid, "folder": folder, "marks": len(marks)}


class Handler(BaseHTTPRequestHandler):
    def log_message(self, *args):
        pass

    def _send(self, code, body, ctype):
        self.send_response(code)
        self.send_header("Content-Type", ctype)
        self.send_header("Content-Length", str(len(body)))
        self.end_headers()
        self.wfile.write(body)

    def do_GET(self):
        path = self.path.split("?")[0]
        if path in ("/", "/index.html"):
            with open(PAGE, "rb") as f:
                self._send(200, f.read(), "text/html; charset=utf-8")
        elif path.startswith("/img/"):
            # Review images: only a plain file name from the HUD mock-up folder (no path parts).
            name = os.path.basename(path[5:])
            full = os.path.join(IMG_DIR, name)
            if name.lower().endswith((".png", ".jpg")) and os.path.isfile(full):
                with open(full, "rb") as f:
                    self._send(200, f.read(), "image/png" if name.lower().endswith(".png") else "image/jpeg")
            else:
                self._send(404, b"not found", "text/plain")
        elif path == "/demo.png" and os.path.exists(DEMO):
            with open(DEMO, "rb") as f:
                self._send(200, f.read(), "image/png")
        else:
            self._send(404, b"not found", "text/plain")

    def do_POST(self):
        if self.path != "/save":
            self._send(404, b'{"error": "not found"}', "application/json")
            return
        length = int(self.headers.get("Content-Length") or 0)
        if length > MAX_BODY:
            self._send(413, b'{"error": "image too large"}', "application/json")
            return
        try:
            payload = json.loads(self.rfile.read(length).decode("utf-8"))
            result = save_feedback(payload)
            print("saved %s (%d marks)" % (result["id"], result["marks"]))
            self._send(200, json.dumps(result).encode("utf-8"), "application/json")
        except Exception as exc:  # report to the page, keep serving
            self._send(400, json.dumps({"error": str(exc)}).encode("utf-8"), "application/json")


def main(argv):
    port = next((int(a) for a in argv if a.isdigit()), 8765)
    server = ThreadingHTTPServer(("127.0.0.1", port), Handler)
    url = "http://127.0.0.1:%d/" % port
    print("Markup Board on %s  (saves into %s)  Ctrl+C stops it" % (url, FEEDBACK), flush=True)
    if "--no-browser" not in argv:
        webbrowser.open(url)
    try:
        server.serve_forever()
    except KeyboardInterrupt:
        pass


if __name__ == "__main__":
    main(sys.argv[1:])
