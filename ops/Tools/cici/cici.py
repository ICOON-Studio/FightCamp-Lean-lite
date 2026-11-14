#!/usr/bin/env python3
"""cici.py - drive the Cici / Dola desktop app from this console, no human relay.

WHY THIS EXISTS. The operator pastes recipes from a Dola chat and then has to
relay our answers back by hand. That is the relay seat the 2026-09-09
direct-reach ruling exists to remove. Cici is a Chromium shell
(`--annotation=prod=Dola`), so `--remote-debugging-port` exposes its renderer to
CDP and the app becomes scriptable - exactly the arrangement
`Tools/grokbots/grokbots.py` uses for Kalli, John and Maria on port 9222.

    python Tools/cici/cici.py launch            # start it with the debug port
    python Tools/cici/cici.py status            # which chat is open
    python Tools/cici/cici.py chats             # list reachable chats
    python Tools/cici/cici.py open --chat "Octagon Blueprint"
    python Tools/cici/cici.py open --new        # a fresh chat
    python Tools/cici/cici.py read  --out reply.txt
    python Tools/cici/cici.py send  --new --file brief.md --wait 900
    python Tools/cici/cici.py attach --path research/BRIEF.md

EVERY ASSIGNMENT GOES TO A FRESH CHAT - `send --new`. Operator rule
2026-09-22: "make new chat for dola when you assign task to avoid this mess".
The mess: a long thread virtualizes its message list, so `read` came back with
the visible TAIL and D7, D8, D10 and the skills-in-3D evaluation all became
truncated digests; the same thread then answered "Something went wrong" to two
consecutive sends; and `_landed()` can match an EARLIER copy of the same task
text and call a swallowed send a success. `--new` removes all three. The one
exception is a message that needs the open thread's memory - asking her to
restate her own earlier answer - which by definition must go to the thread
that holds it.

AND `read` NOW WALKS THE WHOLE LIST, not the screenful. `--visible-only`
restores the old behaviour; there is rarely a reason to want it.

PORT 9333, NOT 9222. Grok Bot already owns 9222 and both apps are driven from
this same console; sharing a port would attach us to whichever started first.

THE APP MUST BE STARTED BY `launch`. Chromium is single-instance per
user-data-dir, so running the exe again while it is up hands off to the live
instance and SILENTLY DROPS the flag. If `status` says no CDP, the app is
running without the port and has to be fully quit first - closing its window is
not enough, it stays resident in the tray.

WHAT IT CAN AND CANNOT CARRY. The composer's attach control accepts
.pdf .txt .csv .docx .doc .xlsx .xls .pptx .ppt .md .mobi .epub .png .jpeg .jpg
.webp - read off the live `input[type=file]`. **`.py`, `.glb`, `.fbx` and `.zip`
are NOT accepted**, so a brief goes over as `.md` and code comes BACK as text in
the reply, never as a file. Do not write a task file that asks it to attach a
.py; it cannot.
"""
from __future__ import annotations

import argparse
import base64
import json
import os
import re
import subprocess
import tempfile
import sys
import time
import urllib.error
import urllib.request

# Em-dashes and CJK come back from this app routinely; Windows cp1252 would
# raise UnicodeEncodeError mid-print and lose the reply. Same guard as
# grokbots.py, and it is not optional here - the sidebar has CJK labels.
if hasattr(sys.stdout, "reconfigure"):
    sys.stdout.reconfigure(encoding="utf-8", errors="replace")
if hasattr(sys.stderr, "reconfigure"):
    sys.stderr.reconfigure(encoding="utf-8", errors="replace")

try:
    import websocket  # websocket-client
except ImportError:  # pragma: no cover
    sys.exit("missing dependency: pip install websocket-client")

PORT = 9333
CDP = f"http://127.0.0.1:{PORT}"
APP = os.path.expandvars(r"%LOCALAPPDATA%\Cici\Application\app\Cici.exe")

CHAT_URL_HINT = "dola-chat"

# Read off the live DOM 2026-09-21. The composer is a tiptap/ProseMirror
# contenteditable, NOT a <textarea> - so value assignment does nothing and the
# text has to go in as an input event (see `_type_js`).
COMPOSER_SEL = 'div.tiptap[contenteditable="true"], div.ProseMirror[contenteditable="true"]'

SETTLE_POLLS = 4       # consecutive unchanged polls that count as "reply finished"
POLL_SECONDS = 3


# --------------------------------------------------------------------------
# transport
# --------------------------------------------------------------------------
def cdp_up() -> bool:
    try:
        urllib.request.urlopen(f"{CDP}/json/version", timeout=5).read()
        return True
    except (urllib.error.URLError, OSError):
        return False


def _targets() -> list:
    with urllib.request.urlopen(f"{CDP}/json/list", timeout=10) as r:
        return json.load(r)


def _page_target(url_hint: str = CHAT_URL_HINT) -> dict:
    pages = [t for t in _targets() if t.get("type") == "page"]
    for t in pages:
        if url_hint in t.get("url", ""):
            return t
    for t in pages:                      # fall back to any real page
        if "background" not in t.get("url", ""):
            return t
    raise RuntimeError("Cici has no usable page target")


class Session:
    """One CDP websocket against the app's renderer."""

    def __init__(self, url_hint: str = CHAT_URL_HINT, timeout: int = 60):
        # suppress_origin: Chrome 128+ rejects a websocket whose Origin it did
        # not issue and would 403 every connection from here.
        self.ws = websocket.create_connection(
            _page_target(url_hint)["webSocketDebuggerUrl"],
            timeout=timeout, suppress_origin=True)
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
        return r.get("result", {}).get("value")

    def body(self) -> str:
        return self.js("document.body.innerText") or ""

    def close(self):
        try:
            self.ws.close()
        except Exception:
            pass


# --------------------------------------------------------------------------
# helpers
# --------------------------------------------------------------------------
def _jstr(s: str) -> str:
    """A Python string as a JS string literal, safe for any content."""
    return json.dumps(s)


_MD_NOISE = re.compile(r"[*_`#>\[\]()]|^\s*\d+[.)]\s*|^\s*[-+]\s+", re.M)


def _norm(s: str) -> str:
    """Markdown source and its rendered text, reduced to the same string.

    What goes into the composer is markdown; what the transcript shows is the
    rendering of it. Any comparison between the two has to drop the syntax
    first or it compares `**force**` against `force` and concludes the message
    was never sent.
    """
    return " ".join(_MD_NOISE.sub(" ", s).split())


def _type_js(text: str) -> str:
    """Put `text` into the tiptap composer.

    A ProseMirror editor keeps its own document model; setting `innerText` or a
    `value` leaves the model empty and the send button disabled. The reliable
    route is the editor's own paste handling: dispatch a real `paste` with the
    text on a DataTransfer, which ProseMirror reads and converts into document
    nodes, keeping newlines.
    """
    return """
(() => {
  const el = document.querySelector(%s);
  if (!el) return 'NO_COMPOSER';
  el.focus();
  const dt = new DataTransfer();
  dt.setData('text/plain', %s);
  const ev = new ClipboardEvent('paste', {clipboardData: dt, bubbles: true, cancelable: true});
  el.dispatchEvent(ev);
  return el.innerText.length;
})()
""" % (_jstr(COMPOSER_SEL), _jstr(text))


def reply_status(body: str) -> str:
    """'working' or 'idle', read from the app's own affordances.

    An unchanged transcript is NOT a finished reply - grokbots.py learned that
    the expensive way on J26, where a bot doing deep research showed one static
    line for minutes and four unchanged polls looked like completion. Here the
    tell is the STOP control: while the model streams, the send button becomes a
    stop button.
    """
    lowered = body.lower()
    for marker in ("stop generating", "生成中", "thinking…", "thinking..."):
        if marker in lowered:
            return "working"
    return "idle"


def _is_working(s: Session) -> bool:
    """Is the model still streaming?

    THE LABEL MUST *BE* A STOP CONTROL, NOT MERELY CONTAIN THE WORD, AND IT MUST
    BE ON SCREEN (fixed 2026-09-21). This matched /stop/i anywhere in an
    aria-label, and the app keeps a HIDDEN 0x0 element per turn whose aria-label
    is the full text of that message. A brief of mine that opened "Stop before
    the AI decision system..." therefore made every later `send` refuse with
    "the model is still streaming a previous reply" - permanently, because the
    message never goes away. Any message containing the word would do it.

    So: anchor the match at the start, cap the length so a sentence cannot pass
    as a control, and require the button to be rendered."""
    got = s.js("""
(() => {
  const isStop = (b) => {
    const lab = (b.getAttribute('aria-label') || b.getAttribute('title') || '').trim();
    if (!lab || lab.length > 40) return false;          // a sentence is not a control
    if (!/^stop/i.test(lab)) return false;            // "Stop", "Stop generating"
    const r = b.getBoundingClientRect();
    return !!b.offsetParent && r.width > 0 && r.height > 0;
  };
  const btns = [...document.querySelectorAll('button,[role="button"]')];
  return btns.some(isStop) ? 'working' : 'idle';
})()
""")
    return got == "working"


# --------------------------------------------------------------------------
# commands
# --------------------------------------------------------------------------
def cmd_launch(a) -> int:
    if cdp_up():
        print(f"Cici already up, CDP on {PORT}")
        return 0
    if not os.path.exists(APP):
        print(f"app not found: {APP}")
        return 2
    subprocess.Popen([APP, f"--remote-debugging-port={PORT}"],
                     stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
    for _ in range(40):
        time.sleep(1)
        if cdp_up():
            print(f"Cici up, CDP on {PORT}")
            return 0
    print("launched but no CDP appeared. If the app was ALREADY running without")
    print("the port, Chromium handed off to it and dropped the flag - quit it")
    print("fully (it stays in the tray after the window closes) and retry.")
    return 1


def _require_cdp() -> int | None:
    if cdp_up():
        return None
    print(f"no CDP on {PORT}. Start the app with:")
    print("  python Tools/cici/cici.py launch")
    print("If it is already running, it was started WITHOUT the debug port -")
    print("quit it fully first; closing the window leaves it in the tray.")
    return 1


def cmd_status(a) -> int:
    if (rc := _require_cdp()) is not None:
        return rc
    s = Session()
    print("page:", s.js("location.href"))
    print("streaming:", "yes" if _is_working(s) else "no")
    body = s.body()
    print(f"visible text: {len(body)} chars")
    print("--- tail ---")
    print("\n".join([l for l in body.splitlines() if l.strip()][-12:]))
    s.close()
    return 0


def cmd_chats(a) -> int:
    if (rc := _require_cdp()) is not None:
        return rc
    s = Session()
    names = s.js("""
(() => {
  const out = [];
  document.querySelectorAll('[class*="conversation-item"]').forEach(e => {
    const t = (e.innerText||'').trim().split('\\n')[0];
    if (t) out.push(t);
  });
  return out;
})()
""") or []
    if not names:
        print("(no conversation items found; the sidebar may be collapsed)")
    for n in names:
        print(" ", n)
    s.close()
    return 0


def _new_chat(s: "Session") -> bool:
    """Click the app's own New Chat control. Returns whether it moved.

    OPERATOR RULE 2026-09-22: 'make new chat for dola when you assign task to
    avoid this mess'. The mess was real and it cost this session an hour. A
    long-running thread is where every one of these defects came from:

      - the message list VIRTUALIZES, so an answer three messages back is gone
        from the DOM entirely and `read` captured a tail. D7, D8, D10 and the
        skills-in-3D evaluation ALL landed as truncated digests that way;
      - the thread accumulates a generated document as context and answered
        `Something went wrong. Please try again later.` to two consecutive
        sends before it recovered on its own;
      - `_landed()` looks for the message text in the transcript, and in a
        thread that already holds an earlier copy of the same task the probe
        matches the OLD copy - so a swallowed send reports success.

    A fresh chat per assignment removes all three at once. The cost is that
    the new chat has NO MEMORY of earlier answers, so a message that asks the
    agent to restate or build on its own previous work must go to the thread
    that holds it - `open --chat` - and only a NEW task gets `--new`.
    """
    moved = s.js("""
(() => {
  for (const el of document.querySelectorAll('div,button,a')) {
    const t = (el.innerText || '').trim();
    if (!/^new chat/i.test(t) || t.length > 40) continue;
    if (!/sidebar_nav_item|cursor-pointer/.test(el.className || '')) continue;
    el.click();
    return true;
  }
  return false;
})()
""")
    if not moved:
        return False
    time.sleep(2.0)
    return True


def cmd_open(a) -> int:
    if (rc := _require_cdp()) is not None:
        return rc
    if getattr(a, "new", False):
        s = Session()
        ok = _new_chat(s)
        s.close()
        print("opened a NEW chat" if ok else "could not find the New Chat control")
        return 0 if ok else 1
    s = Session()
    hit = s.js("""
(() => {
  const want = %s.toLowerCase();
  const items = [...document.querySelectorAll('[class*="conversation-item"]')];
  for (const e of items) {
    const t = (e.innerText||'').trim().split('\\n')[0];
    if (t && t.toLowerCase().includes(want)) {
      // The row IS an <a href="/chat/..">; its descendant <button>s are the
      // hover actions, and the first one ARCHIVES the chat (2026-09-23:
      // `open` archived "Capsule Collapse & Neck Reachability"). Click the
      // link itself, never a button inside it.
      const link = e.matches('a[href]') ? e : (e.closest('a[href]') || e.querySelector('a[href]'));
      if (!link) continue;
      link.click();
      return t;
    }
  }
  return '';
})()
""" % _jstr(a.chat))
    if not hit:
        print(f"no chat matching {a.chat!r}. `chats` lists what is reachable.")
        s.close()
        return 1
    time.sleep(2)
    print(f"opened: {hit}")
    s.close()
    return 0


COPY_BTN = '[data-testid="message_action_copy"]'

# Hook the app's OWN copy path and stash what it copies. The button copies via
# a selection plus execCommand('copy'), so the `copy` event carries the text -
# no clipboard permission, no OS clipboard, nothing for another app to race.
_CAPTURE_HOOK = """
(() => {
  window.__cici_cap = window.__cici_cap || [];
  if (!window.__cici_hooked) {
    window.__cici_hooked = true;
    const orig = navigator.clipboard && navigator.clipboard.writeText;
    if (orig) navigator.clipboard.writeText = function (t) {
      window.__cici_cap.push(t); return orig.call(navigator.clipboard, t);
    };
    const oe = document.execCommand;
    document.execCommand = function (c) {
      if (c === 'copy') {
        const sel = window.getSelection && window.getSelection().toString();
        if (sel) window.__cici_cap.push(sel);
      }
      return oe.apply(document, arguments);
    };
  }
  return 'ok';
})()
"""


def harvest(s: "Session") -> str:
    """The WHOLE transcript, every message complete.

    OPERATOR, 2026-09-22: "there is option to copy the whole html code in dolas
    chat". There is, and it is the right instrument. Every message carries a
    `message_action_copy` button, and what it copies is the FULL message -
    including a generated document's entire HTML source, which no amount of
    reading the rendered pane would ever give you.

    That matters because `document.body.innerText` is the visible tail and
    nothing else: the message list is VIRTUALIZED, so a message scrolled out of
    the viewport is removed from the DOM. Four digests on this project were
    written from captures truncated exactly that way - D7, D8, D10 and the
    skills-in-3D evaluation - each looking complete and each starting
    mid-sentence.

    So: walk the scroll container top to bottom, and at every step press every
    copy button the virtualizer has rendered. Deduplicate by content, keep
    first-seen order. The scrolling is only there to bring buttons into
    existence; the TEXT comes from the app itself, not from stitched
    screenfuls.
    """
    s.js(_CAPTURE_HOOK)
    info = s.js("""
(() => {
  let best = null, bestScore = 0;
  for (const el of document.querySelectorAll('div,main,section')) {
    const over = el.scrollHeight - el.clientHeight;
    if (over < 200) continue;
    const score = over * (el.innerText || '').length;
    if (score > bestScore) { bestScore = score; best = el; }
  }
  if (!best) return null;
  best.setAttribute('data-cici-scroll', '1');
  return [best.scrollHeight, best.clientHeight];
})()
""")
    click_all = """
(() => {
  let n = 0;
  for (const b of document.querySelectorAll(%s)) {
    if (b.getAttribute('data-cici-copied')) continue;
    b.setAttribute('data-cici-copied', '1');
    b.click();
    n++;
  }
  return n;
})()
""" % _jstr(COPY_BTN)

    if not info:
        s.js(click_all)
        time.sleep(0.8)
    else:
        scroll_h, client_h = info
        step = max(200, int(client_h * 0.75))
        for pos in list(range(0, scroll_h, step)) + [scroll_h]:
            s.js("(() => { const e = document.querySelector('[data-cici-scroll=\"1\"]');"
                 " if (e) e.scrollTop = %d; return 0; })()" % pos)
            time.sleep(0.35)      # let the virtualizer render the new window
            if s.js(click_all):
                time.sleep(0.35)  # let the clicks resolve into copy events
        s.js("(() => { const e = document.querySelector('[data-cici-scroll=\"1\"]');"
             " if (e) e.removeAttribute('data-cici-scroll'); return 0; })()")

    raw = s.js("(() => JSON.stringify(window.__cici_cap || []))()") or "[]"
    try:
        parts = json.loads(raw)
    except Exception:
        parts = []

    seen, ordered = set(), []
    for p in parts:
        p = (p or "").strip()
        if p and p not in seen:
            seen.add(p)
            ordered.append(p)
    if not ordered:
        # No copy buttons at all - fall back rather than return nothing, and
        # SAY SO, because a silent fallback is how a tail gets mistaken for a
        # whole answer in the first place.
        return ("!! NO message_action_copy BUTTONS FOUND - this is the VISIBLE"
                " TAIL ONLY and may be truncated.\n\n" + s.body())
    return "\n\n----- MESSAGE BREAK -----\n\n".join(ordered)


def cmd_read(a) -> int:
    if (rc := _require_cdp()) is not None:
        return rc
    s = Session()
    body = s.body() if getattr(a, "visible_only", False) else harvest(s)
    s.close()
    if a.out:
        with open(a.out, "w", encoding="utf-8") as fh:
            fh.write(body)
        print(f"wrote {len(body)} chars to {a.out}")
        print("NOTE: this is the WHOLE transcript, a raw capture - not a")
        print("curated deliverable. Label it as such wherever it is used.")
    else:
        print(body[-4000:])
    return 0


def cmd_attach(a) -> int:
    """Put a local file on the composer's file input via CDP."""
    if (rc := _require_cdp()) is not None:
        return rc
    path = os.path.abspath(a.path)
    if not os.path.exists(path):
        print(f"not found: {path}")
        return 2
    ext = os.path.splitext(path)[1].lower()
    allowed = {".pdf", ".txt", ".csv", ".docx", ".doc", ".xlsx", ".xls",
               ".pptx", ".ppt", ".md", ".mobi", ".epub", ".png", ".jpeg",
               ".jpg", ".webp"}
    if ext not in allowed:
        print(f"REFUSING: the app's file input does not accept {ext}.")
        print("Accepted: " + " ".join(sorted(allowed)))
        print("Send code as text in the message body instead.")
        return 2
    s = Session()
    s.call("DOM.enable")
    doc = s.call("DOM.getDocument", {"depth": -1, "pierce": True})
    node = s.call("DOM.querySelector", {
        "nodeId": doc["root"]["nodeId"], "selector": "input[type=file]"})
    if not node.get("nodeId"):
        print("no input[type=file] in the DOM right now")
        s.close()
        return 1
    s.call("DOM.setFileInputFiles", {"files": [path], "nodeId": node["nodeId"]})
    time.sleep(2)
    print(f"attached: {path}")
    s.close()
    return 0


def cmd_images(a) -> int:
    """S148: save the pictures/videos Dola generated in the open chat (operator: "dola can generate maybe?").

    Collects every rendered <img> at least --min px wide and every <video>, newest last, fetches each from INSIDE the
    page (so the app's own session serves it - nothing is exported) and writes them to --out as <stem>_NN.<ext>.
    --last N keeps only the newest N."""
    if (rc := _require_cdp()) is not None:
        return rc
    s = Session(timeout=180)
    got = s.js("""
(async () => {
  const min = %d;
  const media = [...document.querySelectorAll('img, video')].filter(el => {
    if (el.tagName === 'VIDEO') return !!(el.currentSrc || el.src);
    return el.naturalWidth >= min && el.offsetParent !== null;
  });
  const seen = new Set(); const out = [];
  for (const el of media) {
    const src = el.tagName === 'VIDEO' ? (el.currentSrc || el.src) : (el.currentSrc || el.src);
    if (!src || seen.has(src)) continue; seen.add(src);
    try {
      const r = await fetch(src); const b = await r.blob();
      const buf = new Uint8Array(await b.arrayBuffer()); let bin = '';
      for (let i = 0; i < buf.length; i += 0x8000) bin += String.fromCharCode.apply(null, buf.subarray(i, i + 0x8000));
      out.push({kind: el.tagName.toLowerCase(), type: b.type, w: el.naturalWidth || el.videoWidth || 0,
                h: el.naturalHeight || el.videoHeight || 0, b64: btoa(bin)});
    } catch (e) { out.push({kind: el.tagName.toLowerCase(), error: String(e), src: src.slice(0, 120)}); }
  }
  return out;
})()
""" % a.min)
    s.close()
    items = got or []
    if a.last:
        items = items[-a.last:]
    os.makedirs(a.out, exist_ok=True)
    saved = 0
    for i, item in enumerate(items):
        if "error" in item:
            print(f"  skip {item['kind']}: {item['error']} ({item.get('src', '')})")
            continue
        ext = {"image/png": "png", "image/jpeg": "jpg", "image/webp": "webp", "video/mp4": "mp4"}.get(item["type"], item["type"].split("/")[-1] or "bin")
        path = os.path.join(a.out, f"{a.stem}_{i:02d}.{ext}")
        with open(path, "wb") as fh:
            fh.write(base64.b64decode(item["b64"]))
        saved += 1
        print(f"  {path}  {item['kind']} {item['w']}x{item['h']}")
    print(f"saved {saved} of {len(items)}")
    return 0 if saved else 1


def cmd_send(a) -> int:
    if (rc := _require_cdp()) is not None:
        return rc

    if a.file:
        with open(a.file, encoding="utf-8") as fh:
            text = fh.read()
    else:
        text = a.message or ""
    if not text.strip():
        print("nothing to send")
        return 2

    s = Session()

    if _is_working(s):
        print("REFUSING: the model is still streaming a previous reply.")
        s.close()
        return 1

    if getattr(a, "new", False):
        if not _new_chat(s):
            print("REFUSING: --new was asked for and the New Chat control was"
                  " not found. Nothing sent.")
            s.close()
            return 1
        print("started a fresh chat for this assignment")

    before = s.body()

    got = s.js(_type_js(text))
    if got == "NO_COMPOSER":
        print("REFUSING: no composer found on this page. Is a chat open?")
        s.close()
        return 1

    # VERIFY THE TEXT LANDED BEFORE SENDING. grokbots learned that a picker or a
    # wrong pane silently swallows the payload and the send then goes somewhere
    # nobody intended. A length check is cheap and it is the whole guard.
    in_box = s.js("(() => { const e = document.querySelector(%s); return e ? e.innerText.length : -1; })()"
                  % _jstr(COMPOSER_SEL))
    if not isinstance(in_box, int) or in_box < min(20, len(text)):
        print(f"REFUSING: composer holds {in_box} chars, expected ~{len(text)}. Nothing sent.")
        s.close()
        return 1

    if a.dry_run:
        print(f"DRY RUN: {in_box} chars staged in the composer, not sent.")
        s.close()
        return 0

    s.call("Input.dispatchKeyEvent", {"type": "keyDown", "key": "Enter",
                                      "code": "Enter", "windowsVirtualKeyCode": 13,
                                      "nativeVirtualKeyCode": 13})
    s.call("Input.dispatchKeyEvent", {"type": "keyUp", "key": "Enter",
                                      "code": "Enter", "windowsVirtualKeyCode": 13,
                                      "nativeVirtualKeyCode": 13})
    ## PRESSING ENTER IS NOT SENDING. VERIFY THE MESSAGE IS IN THE CONVERSATION.
    ##
    ## 2026-09-22: this printed "sent 4909 chars" for a task that NEVER REACHED
    ## THE CHAT. The composer took the text, Enter was dispatched, the function
    ## reported success, and the transcript afterwards contained no trace of it
    ## - zero occurrences of a word that appeared 48 times once it really did
    ## send. It was reported to the operator as assigned, and it was not.
    ##
    ## So the check is the only thing that counts: take a distinctive slice of
    ## what was typed and look for it in the transcript the app is showing.
    ## Retry once - the first Enter is the one that gets swallowed - and FAIL
    ## LOUDLY rather than return 0 on an unverifiable send.
    def _landed() -> bool:
        ## A middle slice, not the opening line: the opening is often the task
        ## id, which may already appear in an earlier message in the thread.
        ##
        ## COMPARE NORMALIZED, NOT RAW. 2026-09-22: this reported FAIL on a
        ## message that had landed and was already being answered. The composer
        ## takes MARKDOWN and the transcript renders it, so `**bold**` becomes
        ## `bold`, `## Heading` becomes `Heading` and `1. item` loses its
        ## number - a raw probe can never match. The false alarm is expensive
        ## in both directions: it sent this session hunting a phantom send
        ## failure, and the obvious "fix" of resending duplicates the task.
        ## S470: SQ109 "failed" six times on a 95k brief that HAD landed each time (six chats, each answered). The
        ## middle slice sat in a markdown table, which the page renders with other separators, and 1.5 s is short
        ## for a long message. Now: letters and digits only, three slices (any one counts), polled up to 20 s.
        def _letters(x: str) -> str:
            return "".join(c.lower() for c in x if c.isalnum())
        want = _letters(text)
        if len(want) <= 120:
            probes = [want[:60]]
        else:
            probes = [want[int(len(want) * f):int(len(want) * f) + 50] for f in (0.25, 0.5, 0.75)]
        if not any(probes):
            return False
        end = time.time() + 20
        while True:
            have = _letters(s.body())
            if any(pr and pr in have for pr in probes):
                return True
            if time.time() > end:
                return False
            time.sleep(2)

    time.sleep(1.5)
    if not _landed():
        print("!! ENTER DID NOT SEND IT - the message is not in the transcript."
              " Retrying once.")
        s.call("Input.dispatchKeyEvent", {"type": "keyDown", "key": "Enter",
                                          "code": "Enter",
                                          "windowsVirtualKeyCode": 13,
                                          "nativeVirtualKeyCode": 13})
        s.call("Input.dispatchKeyEvent", {"type": "keyUp", "key": "Enter",
                                          "code": "Enter",
                                          "windowsVirtualKeyCode": 13,
                                          "nativeVirtualKeyCode": 13})
        time.sleep(2.5)
        if not _landed():
            print("FAIL: %d chars were typed into the composer and NEVER "
                  "APPEARED IN THE CONVERSATION." % len(text))
            print("      Do NOT report this task as assigned. Check the app,"
                  " then send again.")
            s.close()
            return 3

    print(f"sent {len(text)} chars - VERIFIED present in the transcript")

    if a.wait <= 0:
        s.close()
        return 0

    # ONE waiter, bounded, reading the app's own streaming state. Never a blind
    # timer: the operator's 2026-09-13 rule, and an unchanged transcript is not
    # a finished reply.
    deadline = time.time() + a.wait
    last, stable = before, 0
    while time.time() < deadline:
        time.sleep(POLL_SECONDS)
        now = s.body()
        if _is_working(s):
            stable = 0
            last = now
            continue
        if now == last and now != before:
            stable += 1
            if stable >= SETTLE_POLLS:
                break
        else:
            stable = 0
        last = now

    body = s.body()
    s.close()
    if body == before:
        print(f"no new content after {a.wait}s - it may still be thinking.")
        return 1
    ## THE WHOLE TRANSCRIPT IS ALWAYS WRITTEN TO A FILE, `--out` OR NOT.
    ##
    ## 2026-09-22: this printed only the last 40 non-blank lines under a
    ## `--- tail ---` banner and threw the rest away, WHILE HOLDING THE FULL
    ## BODY IN MEMORY. A digest was then written from that tail and committed
    ## as if it were the complete reply - the agent's lead line and two of its
    ## five sections were missing, including the answer to the question the
    ## whole brief was built around.
    ##
    ## A caller cannot read what it was never given, so the fix is HERE and not
    ## in a rule someone has to remember. Every `send` now leaves the COMPLETE
    ## capture on disk and says where, and the on-screen tail says plainly that
    ## it is a tail and how much it is hiding.
    out_path = a.out
    if not out_path:
        stamp = time.strftime("%Y%m%dT%H%M%SZ", time.gmtime())
        out_path = os.path.join(tempfile.gettempdir(),
                                "cici_reply_%s.txt" % stamp)
    with open(out_path, "w", encoding="utf-8") as fh:
        fh.write(body)

    kept = [l for l in body.splitlines() if l.strip()]
    shown = kept[-40:]
    hidden = len(kept) - len(shown)
    print("FULL REPLY WRITTEN TO %s (%d chars, %d lines)"
          % (out_path, len(body), len(kept)))
    if hidden > 0:
        print("!! WHAT FOLLOWS IS THE LAST %d LINES ONLY - %d EARLIER LINES "
              "ARE NOT SHOWN." % (len(shown), hidden))
        print("!! READ THE FILE ABOVE BEFORE QUOTING OR SUMMARISING THIS "
              "REPLY.")
        print("!! The START of a long answer - its lead line and its first "
              "sections - is exactly what a tail drops.")
    print("--- tail ---")
    print("\n".join(shown))
    return 0


def main() -> int:
    ap = argparse.ArgumentParser(description=__doc__,
                                 formatter_class=argparse.RawDescriptionHelpFormatter)
    sub = ap.add_subparsers(dest="cmd", required=True)

    sub.add_parser("launch", help="start Cici with the debug port").set_defaults(fn=cmd_launch)
    sub.add_parser("status", help="which chat is open, and is it streaming").set_defaults(fn=cmd_status)
    sub.add_parser("chats", help="list reachable chats").set_defaults(fn=cmd_chats)

    op = sub.add_parser("open", help="open a chat by name, or start a fresh one")
    og = op.add_mutually_exclusive_group(required=True)
    og.add_argument("--chat")
    og.add_argument("--new", action="store_true",
                    help="start a FRESH chat (operator rule 2026-09-22)")
    op.set_defaults(fn=cmd_open)

    rp = sub.add_parser("read", help="read the open chat WITHOUT sending anything")
    rp.add_argument("--out")
    rp.add_argument("--visible-only", action="store_true",
                    help="the on-screen tail only; the default walks the whole"
                         " virtualized list and is what you almost always want")
    rp.set_defaults(fn=cmd_read)

    at = sub.add_parser("attach", help="attach a local file to the composer")
    at.add_argument("--path", required=True)
    at.set_defaults(fn=cmd_attach)

    ip = sub.add_parser("images", help="save the pictures/videos in the open chat (S148)")
    ip.add_argument("--out", required=True, help="folder to write into")
    ip.add_argument("--stem", default="dola")
    ip.add_argument("--min", type=int, default=512, help="smallest image width kept (px)")
    ip.add_argument("--last", type=int, default=0, help="keep only the newest N")
    ip.set_defaults(fn=cmd_images)

    sp = sub.add_parser("send", help="send one message and wait for the reply")
    g = sp.add_mutually_exclusive_group(required=True)
    g.add_argument("--message")
    g.add_argument("--file", help="send this file's TEXT as the message body")
    sp.add_argument("--wait", type=int, default=600, help="seconds; 0 = fire and forget")
    sp.add_argument("--out", help="write the transcript here afterwards")
    sp.add_argument("--dry-run", action="store_true",
                    help="stage the text in the composer and stop")
    sp.add_argument("--new", action="store_true",
                    help="start a FRESH chat first. OPERATOR RULE 2026-09-22:"
                         " every ASSIGNMENT goes to a new chat. Omit it only"
                         " when the message needs the open thread's memory,"
                         " e.g. asking her to restate her own earlier answer")
    sp.set_defaults(fn=cmd_send)

    a = ap.parse_args()
    return a.fn(a)


if __name__ == "__main__":
    sys.exit(main())
