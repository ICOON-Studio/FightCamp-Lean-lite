#!/usr/bin/env python3
"""Drive the Grok Bot desktop app from a shell, over Chrome DevTools Protocol.

Grok Bot is an Electron app with NO command line interface - there is no
"grokbots CLI" to install, and the Grok Build CLI it reports installing lives
inside its own sandbox, not on this machine. But Electron is Chromium, so
launching it with --remote-debugging-port exposes its renderer to CDP and the
app becomes scriptable: this is what lets Kalli, John and Maria be assigned and
collected without a human retyping every message.

What this does NOT change: the bots still have no checkout, no Godot and no way
to run the suite. They stay one-file, no-test agents, and a module and its test
remain two tasks written from one contract.

Commands
--------
  python Tools/grokbots/grokbots.py launch      start the app with the debug port
  python Tools/grokbots/grokbots.py status      which chat is open, and the sidebar
  python Tools/grokbots/grokbots.py chats       list the bot chats it can reach
  python Tools/grokbots/grokbots.py read --to Kalli --wait 600 --out reply.txt
  python Tools/grokbots/grokbots.py send --to Kalli --message "..."
  python Tools/grokbots/grokbots.py send --to John --file task.md --dry-run

`send` refuses unless the chat actually open in the app matches --to, so a
stray click cannot deliver a task to the wrong bot. --dry-run prints exactly
what would be typed and sends nothing.

Requires: pip install websocket-client
"""
from __future__ import annotations

import argparse
import json
import os
import subprocess
import sys
import time
import urllib.error
import urllib.request

# Reconfigure stdout to UTF-8 so em-dashes, arrows and curly quotes from bot
# replies survive Windows cp1252. Guarded for environments where stdout has no
# reconfigure (e.g. frozen binaries, some test harnesses).
if hasattr(sys.stdout, "reconfigure"):
    sys.stdout.reconfigure(encoding="utf-8", errors="replace")
if hasattr(sys.stderr, "reconfigure"):
    sys.stderr.reconfigure(encoding="utf-8", errors="replace")

try:
    import websocket  # websocket-client
except ImportError:  # pragma: no cover
    sys.exit("missing dependency: pip install websocket-client")

CDP = "http://127.0.0.1:9222"
PORT = 9222
APP = r"C:\Program Files\Grok Bot\Grok Bot.exe"
SETTLE_POLLS = 4      # consecutive unchanged polls that count as "reply finished"
POLL_SECONDS = 3


def reply_status(body: str) -> str:
    """'working', 'stopped' or 'idle', read from the app's own status line.

    J26 (2026-09-12): `send` printed "reply settled after ~15s" and a tail that was
    OUR OWN MESSAGE. The transcript grew when the task was posted, and a bot doing
    deep research shows one static "<bot> is working" line for many minutes, so
    four unchanged polls looked like a finished reply. An unchanged transcript is
    not a reply. The status lines are short and stand alone, so only a whole line
    counts - a reply that merely contains the words cannot trip this.
    """
    import re

    for line in reversed([l.strip() for l in body.splitlines() if l.strip()][-8:]):
        if re.fullmatch(r".{1,80} stopped without replying", line):
            return "stopped"
        if re.fullmatch(r".{1,80} is working", line):
            return "working"
    return "idle"


# --------------------------------------------------------------------------
# transport
# --------------------------------------------------------------------------
def _page_target():
    with urllib.request.urlopen(f"{CDP}/json/list", timeout=10) as r:
        for t in json.load(r):
            if t.get("type") == "page":
                return t
    raise RuntimeError("Grok Bot has no page target")


def cdp_up() -> bool:
    try:
        urllib.request.urlopen(f"{CDP}/json/version", timeout=5).read()
        return True
    except (urllib.error.URLError, OSError):
        return False


class Session:
    """One CDP websocket against the app's renderer."""

    def __init__(self, timeout: int = 60):
        # suppress_origin: Chrome 128+ rejects a websocket whose Origin it did
        # not issue, and would otherwise 403 every connection from here.
        self.ws = websocket.create_connection(
            _page_target()["webSocketDebuggerUrl"], timeout=timeout, suppress_origin=True
        )
        self._id = 0

    def call(self, method: str, params: dict | None = None) -> dict:
        self._id += 1
        mine = self._id
        self.ws.send(json.dumps({"id": mine, "method": method, "params": params or {}}))
        while True:
            msg = json.loads(self.ws.recv())
            if msg.get("id") == mine:
                if "error" in msg:
                    raise RuntimeError(f"{method}: {msg['error']}")
                return msg.get("result", {})

    def js(self, expression: str):
        r = self.call("Runtime.evaluate", {
            "expression": expression,
            "returnByValue": True,
            "awaitPromise": True,
            "userGesture": True,
        })
        if "exceptionDetails" in r:
            raise RuntimeError(json.dumps(r["exceptionDetails"])[:400])
        v = r.get("result", {}).get("value")
        if isinstance(v, str):
            try:
                return json.loads(v)
            except json.JSONDecodeError:
                return v
        return v

    def key(self, kind: str, key: str, code: str, vk: int) -> None:
        self.call("Input.dispatchKeyEvent", {
            "type": kind, "key": key, "code": code,
            "windowsVirtualKeyCode": vk, "nativeVirtualKeyCode": vk,
        })

    def close(self) -> None:
        try:
            self.ws.close()
        except Exception:
            pass


# --------------------------------------------------------------------------
# page queries. Kept as JS strings because the renderer is the only place that
# knows this app's DOM; nothing here depends on a class name staying stable
# beyond the composer's contenteditable and the header.
# --------------------------------------------------------------------------
JS_OPEN_CHAT = 'JSON.stringify(((document.querySelector("header")||{}).innerText||"").trim())'

JS_BODY = 'JSON.stringify(document.body.innerText||"")'

JS_CHATS = """(() => {
  const seen = new Set(), out = [];
  for (const e of document.querySelectorAll('[aria-label]')) {
    const al = (e.getAttribute('aria-label') || '').trim();
    if (!al || seen.has(al)) continue;
    if (/^(Search|New chat|Attach file|Start voice input|Open account menu)$/i.test(al)) continue;
    seen.add(al); out.push(al);
  }
  return JSON.stringify(out);
})()"""

JS_FOCUS_COMPOSER = """(() => {
  const ed = document.querySelector('[contenteditable="true"], textarea');
  if (!ed) return JSON.stringify(false);
  ed.focus();
  if (ed.tagName !== 'TEXTAREA') {
    const r = document.createRange();
    r.selectNodeContents(ed);
    r.collapse(false);
    const sel = getSelection();
    sel.removeAllRanges();
    sel.addRange(r);
  }
  return JSON.stringify(true);
})()"""

JS_COMPOSER_TEXT = """JSON.stringify((() => {
  const ed = document.querySelector('[contenteditable="true"], textarea');
  if (!ed) return "";
  return (ed.value !== undefined ? ed.value : ed.innerText) || "";
})().trim())"""

JS_CLICK_NEW_CHAT = """(() => {
  const els = Array.from(document.querySelectorAll('[aria-label]'));
  const hit = els.find(e => (e.getAttribute('aria-label')||'').trim().toLowerCase() === 'new chat');
  if (!hit) return JSON.stringify(false);
  hit.click();
  return JSON.stringify(true);
})()"""

JS_PICK_CHAT_TARGET = """(() => {
  const want = %s.toLowerCase();
  const same = e => (e.innerText || e.textContent || '').trim().toLowerCase() === want;
  // S146: the New-chat picker row is a VISIBLE button[role=option] (.sand-new-chat-row). The old any-element
  // search hit an earlier zero-size sidebar node first, so the click did nothing and the picker stayed open.
  const visible = e => { const r = e.getBoundingClientRect(); return r.width > 0 && r.height > 0; };
  let hit = Array.from(document.querySelectorAll('[role="option"], .sand-new-chat-row')).find(e => same(e) && visible(e));
  if (!hit) hit = Array.from(document.querySelectorAll('button, [role="menuitem"], a, div')).find(e => same(e) && visible(e));
  if (!hit) return JSON.stringify(false);
  hit.click();
  return JSON.stringify(true);
})()"""


def _open_chat_by_name(s: Session, name: str) -> bool:
    expr = """(() => {
      const want = %s.toLowerCase();
      const els = Array.from(document.querySelectorAll('[aria-label]'));
      const lab = e => (e.getAttribute('aria-label')||'').trim().toLowerCase();
      let hit = els.find(e => lab(e) === "open " + want + "'s chat");
      // The PINNED BOT row decorates its own label - "John Research, Unread
      // activity" - and an exact match therefore MISSES it and falls through to
      // a bare "John Research", which is an ARCHIVED CONVERSATION further down
      // the sidebar. That is why reads kept coming back with last Tuesday's
      // transcript while the bot was plainly working: the picker was opening a
      // different, older thread and the caller had no way to tell.
      // Prefer the decorated live row; the bare label is the fallback.
      if (!hit) hit = els.find(e => lab(e).startsWith(want + ","));
      if (!hit) hit = els.find(e => lab(e) === want);
      if (!hit) return JSON.stringify(false);
      hit.click();
      return JSON.stringify(true);
    })()""" % json.dumps(name)
    return bool(s.js(expr))


# --------------------------------------------------------------------------
# commands
# --------------------------------------------------------------------------
def cmd_launch(_args) -> int:
    if cdp_up():
        print(f"already listening on {PORT}")
        return 0
    if not os.path.exists(APP):
        print(f"Grok Bot not found at {APP}")
        return 2
    subprocess.Popen([APP, f"--remote-debugging-port={PORT}"],
                     close_fds=True,
                     creationflags=getattr(subprocess, "DETACHED_PROCESS", 0))
    for _ in range(30):
        time.sleep(2)
        if cdp_up():
            print(f"Grok Bot up, CDP on {PORT}")
            return 0
    print("timed out waiting for the debug port")
    return 1


def _require_cdp() -> int | None:
    if cdp_up():
        return None
    print("no CDP on 9222. The app must be started with the debug port:")
    print("  python Tools/grokbots/grokbots.py launch")
    print("A normal launch of Grok Bot does NOT open the port.")
    return 2


def cmd_status(_args) -> int:
    bad = _require_cdp()
    if bad:
        return bad
    s = Session()
    try:
        print("open chat:", s.js(JS_OPEN_CHAT))
        body = s.js(JS_BODY) or ""
        print(f"visible text: {len(body)} chars")
        print("--- sidebar ---")
        for line in body.splitlines()[:24]:
            if line.strip():
                print("  " + line[:100])
    finally:
        s.close()
    return 0


def cmd_chats(_args) -> int:
    bad = _require_cdp()
    if bad:
        return bad
    s = Session()
    try:
        for c in s.js(JS_CHATS) or []:
            print(" ", c)
    finally:
        s.close()
    return 0


def cmd_read(args) -> int:
    """Open a bot's chat and dump what is on screen, sending nothing.

    `send` could deliver a task and `status` could only describe whichever chat
    happened to be open, so collecting three bots' replies meant sending three
    junk messages to switch chats. That is half a round trip and it pollutes the
    transcript. This is the other half: open, optionally wait for the reply to
    settle, print, send nothing.
    """
    bad = _require_cdp()
    if bad:
        return bad
    s = Session()
    try:
        if not _open_chat_by_name(s, args.to):
            print(f"could not find a chat named {args.to!r}; try: grokbots.py chats")
            return 2
        time.sleep(1.5)
        who = (s.js(JS_OPEN_CHAT) or "").strip()
        print(f"open chat: {who!r}")
        if args.to.lower() not in who.lower():
            print(f"REFUSING: open chat is not {args.to!r}.")
            return 2

        body = s.js(JS_BODY) or ""
        if args.wait:
            # Same settle rule `send` uses, minus the "it grew" precondition -
            # here the reply may have finished before we ever looked.
            last, stable = body, 0
            for i in range(args.wait // POLL_SECONDS):
                time.sleep(POLL_SECONDS)
                now = s.js(JS_BODY) or ""
                if now != last:
                    last, stable = now, 0
                else:
                    stable += 1
                    if stable >= SETTLE_POLLS and reply_status(now) != "working":
                        print(f"settled after ~{(i + 1) * POLL_SECONDS}s")
                        break
            else:
                print("still changing when the wait ran out; showing what is on screen")
            body = last

        # Say what the app says, so one read answers "is it done?" without a
        # polling loop - re-opening a chat every 30 s while the bot worked is the
        # likeliest reason J26's first run stopped without replying.
        print(f"bot status: {reply_status(body)}")
        if args.out:
            with open(args.out, "w", encoding="utf-8") as fh:
                fh.write(body)
            print(f"wrote {len(body)} chars to {args.out}")
            return 0
        print("--- transcript ---")
        for line in body.splitlines()[-args.lines:]:
            if line.strip():
                print("  " + line[:200])
    finally:
        s.close()
    return 0


def cmd_newchat(args) -> int:
    """Open a bot's chat and click the app's 'New chat' control.

    The bots' chats grow without limit — every send re-reads the whole history,
    so each task costs more than the last. This resets the context so the next
    send starts from an empty transcript.

    Never exits 0 silently on a miss: a silent no-op here would look exactly
    like success and quietly keep costing money.
    """
    bad = _require_cdp()
    if bad:
        return bad
    s = Session()
    try:
        if not _open_chat_by_name(s, args.to):
            print(f"FAIL: could not find a chat named {args.to!r}; try: grokbots.py chats")
            return 2
        time.sleep(1.5)

        who = (s.js(JS_OPEN_CHAT) or "").strip()
        if args.to.lower() not in who.lower():
            print(f"FAIL: open chat is not {args.to!r} (got {who!r}). Nothing clicked.")
            return 2

        if args.dry_run:
            print(f"dry run: would click 'New chat' then pick {args.to!r} from the dropdown")
            return 0

        if not s.js(JS_CLICK_NEW_CHAT):
            print(f"FAIL: 'New chat' control not found in {args.to!r}'s chat. Chat NOT reset.")
            return 2

        time.sleep(1.0)
        picker = JS_PICK_CHAT_TARGET % json.dumps(args.to)
        if not s.js(picker):
            print(f"FAIL: {args.to!r} not found in the 'New chat' dropdown. Chat NOT reset.")
            return 2

        time.sleep(1.5)
        print(f"ok: started a new chat with {args.to!r}")
    finally:
        s.close()
    return 0


def cmd_send(args) -> int:
    bad = _require_cdp()
    if bad:
        return bad

    text = args.message
    if args.file:
        with open(args.file, encoding="utf-8") as fh:
            text = fh.read()
    if not text or not text.strip():
        print("nothing to send")
        return 2

    s = Session()
    try:
        if not _open_chat_by_name(s, args.to):
            print(f"could not find a chat named {args.to!r}; try: grokbots.py chats")
            return 2
        time.sleep(1.5)

        who = (s.js(JS_OPEN_CHAT) or "").strip()
        print(f"open chat: {who!r}")
        if args.to.lower() not in who.lower():
            print(f"REFUSING: open chat is not {args.to!r}. Nothing sent.")
            return 2

        if getattr(args, "new", False):
            if not s.js(JS_CLICK_NEW_CHAT):
                print(f"FAIL: 'New chat' control not found for {args.to!r}. Nothing sent.")
                return 2
            time.sleep(1.0)
            picker = JS_PICK_CHAT_TARGET % json.dumps(args.to)
            if not s.js(picker):
                print(f"FAIL: {args.to!r} not found in the 'New chat' dropdown. Nothing sent.")
                return 2
            time.sleep(1.5)
            print(f"started a new chat with {args.to!r} before sending")

        who = (s.js(JS_OPEN_CHAT) or "").strip()
        print(f"open chat: {who!r}")
        # 2026-09-13: `send --to Kalli --new` left the New-chat recipient PICKER open.
        # Its header text is "To:\nCreate new Bot\nCreate group chat\nMaria Art
        # Director\nJohn Research\nKalli" - it CONTAINS every bot's name, so the
        # substring check below passed and K28 went into a John Research chat.
        # A header that is a picker is never a chat with the target.
        first_line = (who.splitlines() or [""])[0].strip().lower()
        if first_line == "to:" or "create new bot" in who.lower():
            print(f"REFUSING: the New-chat picker is still open, not a chat with {args.to!r}. Nothing sent.")
            return 2
        if args.to.lower() not in who.lower():
            print(f"REFUSING: open chat is not {args.to!r}. Nothing sent.")
            return 2

        print(f"--- would send ({len(text)} chars) ---")
        print(text[:800] + ("..." if len(text) > 800 else ""))
        if args.dry_run:
            print("--- dry run, nothing sent ---")
            return 0

        before = len(s.js(JS_BODY) or "")
        if not s.js(JS_FOCUS_COMPOSER):
            print("no composer on this screen; nothing sent")
            return 2

        # S81: images the bot must SEE (it has no repo). One multi-file input in the DOM.
        paths = [os.path.abspath(x) for x in (getattr(args, "attach", None) or [])]
        if paths:
            missing = [x for x in paths if not os.path.exists(x)]
            if missing:
                print(f"REFUSING: attachment not found: {missing}. Nothing sent.")
                return 2
            s.call("DOM.enable")
            doc = s.call("DOM.getDocument", {"depth": -1, "pierce": True})
            node = s.call("DOM.querySelector", {
                "nodeId": doc["root"]["nodeId"], "selector": "input[type=file]"})
            if not node.get("nodeId"):
                print("REFUSING: no file input on this screen. Nothing sent.")
                return 2
            s.call("DOM.setFileInputFiles", {"files": paths, "nodeId": node["nodeId"]})
            print(f"attached {len(paths)} file(s); waiting for upload")
            time.sleep(4.0 + 2.0 * len(paths))
            s.js(JS_FOCUS_COMPOSER)

        s.call("Input.insertText", {"text": text})
        time.sleep(1.0)
        if not (s.js(JS_COMPOSER_TEXT) or ""):
            print("composer stayed empty after insertText; nothing sent")
            return 2

        s.key("keyDown", "Enter", "Enter", 13)
        s.key("keyUp", "Enter", "Enter", 13)
        print("sent; waiting for the reply...")

        last, stable, grew = "", 0, False
        for i in range(args.timeout // POLL_SECONDS):
            time.sleep(POLL_SECONDS)
            now = s.js(JS_BODY) or ""
            if now != last:
                grew = grew or len(now) > before
                last, stable = now, 0
            else:
                stable += 1
                status = reply_status(now)
                if status == "stopped":
                    print("the bot STOPPED WITHOUT REPLYING - there is nothing to collect")
                    break
                if grew and stable >= SETTLE_POLLS and status != "working":
                    print(f"reply settled after ~{(i + 1) * POLL_SECONDS}s")
                    break
        else:
            status = reply_status(last or "")
            print(f"timed out waiting for a settled reply (bot status: {status}); showing what is on screen")
            if status == "working":
                print("the bot is STILL WORKING - collect later with ONE `read --out`, do not poll it")

        if getattr(args, "out", None):
            # S146: the tail is 30 lines; a multi-part answer needs the whole reply on disk.
            with open(args.out, "w", encoding="utf-8") as fh:
                fh.write(last or "")
            print(f"wrote {len(last or '')} chars to {args.out}")
        print("--- tail ---")
        for line in (last or "").splitlines()[-30:]:
            if line.strip():
                print("  " + line[:120])
    finally:
        s.close()
    return 0


def main() -> int:
    ap = argparse.ArgumentParser(description=__doc__.splitlines()[0])
    sub = ap.add_subparsers(dest="cmd", required=True)

    sub.add_parser("launch", help="start Grok Bot with the debug port").set_defaults(fn=cmd_launch)
    sub.add_parser("status", help="which chat is open").set_defaults(fn=cmd_status)
    sub.add_parser("chats", help="list reachable chats").set_defaults(fn=cmd_chats)

    rp = sub.add_parser("read", help="open a bot's chat and read it WITHOUT sending anything")
    rp.add_argument("--to", required=True, help="bot name, e.g. Kalli / John Research / Maria Art Director")
    rp.add_argument("--wait", type=int, default=0, metavar="SECONDS",
                    help="wait up to this long for the transcript to stop changing (default: read once)")
    rp.add_argument("--lines", type=int, default=40, help="trailing lines to print (default 40)")
    rp.add_argument("--out", help="write the whole transcript to this file instead of printing a tail")
    rp.set_defaults(fn=cmd_read)

    np = sub.add_parser("newchat", help="reset a bot's chat to a fresh context")
    np.add_argument("--to", required=True, help="bot name, e.g. Kalli / John Research / Maria Art Director")
    np.add_argument("--dry-run", action="store_true", help="print what would be clicked, click nothing")
    np.set_defaults(fn=cmd_newchat)

    sp = sub.add_parser("send", help="send one message to one bot and read the reply")
    sp.add_argument("--to", required=True, help="bot name, e.g. Kalli / John Research / Maria Art Director")
    sp.add_argument("--message", help="text to send")
    sp.add_argument("--file", help="read the text from this file instead")
    sp.add_argument("--new", action="store_true", help="start a fresh chat before sending")
    sp.add_argument("--dry-run", action="store_true", help="print what would be sent, send nothing")
    sp.add_argument("--timeout", type=int, default=180, help="seconds to wait for the reply")
    sp.add_argument("--attach", action="append", help="image/file to upload with the message (repeatable)")
    sp.add_argument("--out", help="also write the whole on-screen reply to this file")
    sp.set_defaults(fn=cmd_send)

    args = ap.parse_args()
    return args.fn(args)


if __name__ == "__main__":
    sys.exit(main())
