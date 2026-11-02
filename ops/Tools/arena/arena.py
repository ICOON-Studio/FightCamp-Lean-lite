#!/usr/bin/env python3
"""Drive arena.ai Agent Mode from a shell (S176, operator 2026-10-06: "build it" - an Arena driver for the cloud).

Arena has no CLI or API, so this uses a DEDICATED Chrome profile (E:\\FightCamp\\arena_profile, never the operator's
own profile and nothing of any other project) started with a debug port, and talks to it over the Chrome DevTools
Protocol with websocket-client, the same transport as Tools/grokbots/grokbots.py and Tools/cici/cici.py.

ONE-TIME: `python Tools/arena/arena.py launch` opens that Chrome at arena.ai; the operator signs in with Google once
(the profile keeps the login). After that a cloud session drives it through pc.yml job=agent.

  launch                      start Chrome (port 9444) on arena.ai
  status                      is it up, which page, signed in?
  send --file TASK_x.md       new Agent chat, pick the repo + master, paste the task, press Send
       [--dry-run]            go as far as typing the prompt, then STOP before Send and report what it saw

NOT VERIFIED against the live site yet (S176): selectors follow AGENT_TOOLS.md "Arena" (contenteditable message box,
button "Send message", repository selector under the prompt box). Run `send --dry-run` first and read the output.
Rules from AGENT_TOOLS.md hold: a NEW chat per task, nothing private in the prompt, Claude reviews and merges the PR.
"""
import argparse, json, os, subprocess, sys, time, urllib.request, urllib.error

import websocket  # pip install websocket-client

PORT = 9444
CDP = f"http://127.0.0.1:{PORT}"
PROFILE = r"E:\FightCamp\arena_profile"
URL = "https://arena.ai"
CHROMES = [r"C:\Program Files\Google\Chrome\Application\chrome.exe",
           r"C:\Program Files (x86)\Google\Chrome\Application\chrome.exe",
           os.path.expandvars(r"%LOCALAPPDATA%\Google\Chrome\Application\chrome.exe")]
REPO = "ICOON-Studio/FightCamp-Lean"


def cdp_up() -> bool:
    try:
        urllib.request.urlopen(f"{CDP}/json/version", timeout=5).read()
        return True
    except (urllib.error.URLError, OSError):
        return False


class Page:
    def __init__(self):
        with urllib.request.urlopen(f"{CDP}/json/list", timeout=10) as r:
            pages = [t for t in json.load(r) if t.get("type") == "page"]
        if not pages:
            raise RuntimeError("Chrome has no page")
        self.ws = websocket.create_connection(pages[0]["webSocketDebuggerUrl"], timeout=60, suppress_origin=True)
        self._id = 0

    def call(self, method, **params):
        self._id += 1
        self.ws.send(json.dumps({"id": self._id, "method": method, "params": params}))
        while True:
            msg = json.loads(self.ws.recv())
            if msg.get("id") == self._id:
                if "error" in msg:
                    raise RuntimeError(str(msg["error"]))
                return msg.get("result", {})

    def js(self, expr):
        res = self.call("Runtime.evaluate", expression=expr, returnByValue=True, awaitPromise=True)
        return res.get("result", {}).get("value")


def cmd_launch(_a) -> int:
    if cdp_up():
        print(f"already listening on {PORT}")
        return 0
    exe = next((c for c in CHROMES if os.path.exists(c)), None)
    if not exe:
        print("Chrome not found")
        return 2
    os.makedirs(PROFILE, exist_ok=True)
    subprocess.Popen([exe, f"--remote-debugging-port={PORT}", f"--user-data-dir={PROFILE}", "--no-first-run", URL],
                     close_fds=True, creationflags=getattr(subprocess, "DETACHED_PROCESS", 0))
    for _ in range(30):
        time.sleep(2)
        if cdp_up():
            print(f"Chrome up on {PORT}, profile {PROFILE}: sign in to arena.ai with Google once")
            return 0
    print("timed out waiting for the debug port")
    return 1


def _need() -> int | None:
    if cdp_up():
        return None
    print(f"no Chrome on {PORT}: run `python Tools/arena/arena.py launch` on the PC first (this tool never starts it from a job)")
    return 3


def cmd_status(_a) -> int:
    if (rc := _need()) is not None:
        return rc
    p = Page()
    print(json.dumps({"url": p.js("location.href"), "title": p.js("document.title"),
                      "signed_in": p.js("!/sign in|log in/i.test(document.body.innerText.slice(0,2000))")}))
    return 0


def _click_text(p: Page, text: str) -> bool:
    return bool(p.js("""(()=>{const w=%s.toLowerCase();
      const e=[...document.querySelectorAll('button,[role=button],[role=option],a,li')]
        .find(x=>(x.innerText||x.getAttribute('aria-label')||'').trim().toLowerCase()===w
              ||(x.innerText||'').toLowerCase().includes(w));
      if(!e) return false; e.click(); return true;})()""" % json.dumps(text)))


def cmd_send(a) -> int:
    if (rc := _need()) is not None:
        return rc
    task = open(a.file, encoding="utf-8").read()
    p = Page()
    p.call("Page.navigate", url=URL)
    time.sleep(5)
    report = {"agent_mode": _click_text(p, "Agent")}
    time.sleep(2)
    report["repo_selector"] = _click_text(p, REPO.split("/")[1]) or _click_text(p, REPO)
    time.sleep(1)
    report["master"] = _click_text(p, "master")
    ok = p.js("""(()=>{const b=document.querySelector('[contenteditable=true]'); if(!b) return false; b.focus(); return true;})()""")
    report["box"] = bool(ok)
    if ok:
        p.call("Input.insertText", text=task)
    time.sleep(1)
    report["typed_chars"] = p.js("(document.querySelector('[contenteditable=true]')||{innerText:''}).innerText.length")
    if a.dry_run:
        report["sent"] = False
        print(json.dumps(report))
        return 0 if report["box"] else 4
    if not report["box"] or not report["typed_chars"]:
        print(json.dumps(report))
        return 4
    before = p.js("document.querySelectorAll('[data-message-id],[class*=message]').length")
    report["send_click"] = _click_text(p, "Send message")
    time.sleep(4)
    report["messages_before_after"] = [before, p.js("document.querySelectorAll('[data-message-id],[class*=message]').length")]
    report["sent"] = bool(report["send_click"])
    print(json.dumps(report))  # one click only: Arena's first click can render late - never re-click on a guess
    return 0 if report["sent"] else 5


def main() -> int:
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    sub = ap.add_subparsers(dest="cmd", required=True)
    sub.add_parser("launch").set_defaults(fn=cmd_launch)
    sub.add_parser("status").set_defaults(fn=cmd_status)
    sp = sub.add_parser("send")
    sp.add_argument("--file", required=True)
    sp.add_argument("--dry-run", action="store_true")
    sp.set_defaults(fn=cmd_send)
    a = ap.parse_args()
    return a.fn(a)


if __name__ == "__main__":
    sys.exit(main())
