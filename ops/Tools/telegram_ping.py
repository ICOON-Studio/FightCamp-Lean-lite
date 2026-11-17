"""telegram_ping.py - a short message to the owner's phone through his own Telegram bot (S508).

Owner S508, asked whether Zapier could help: "Yes, Telegram" to phone pings. Zapier's MCP only fires when a Claude session
calls it; the pings come from our own scripts (a board question, a build export, a seat's PR), so they go straight to the
Telegram Bot API: free, no monthly limit, works with no session open. Stdlib only.

Setup (the owner, once): in Telegram open @BotFather, send /newbot, pick a name; it answers with a token. Put it in
ops/AgentComms/telegram.json as {"token": "<token>"} (git-ignored - never commit it, never paste it in a chat). Then send
any message to the new bot from your phone and run `python ops/Tools/telegram_ping.py setup`: it reads that message and
stores your chat id beside the token. `python ops/Tools/telegram_ping.py test` sends a test line.

    python ops/Tools/telegram_ping.py send "<text>"     # one line to the phone; a no-op (exit 0) until set up
    python ops/Tools/telegram_ping.py setup | test | status

Callers (never fatal: a ping that fails is logged, the caller goes on): agent_comms.py `ask` (a new board question),
tools/export.sh (a build is ready). Log: ops/AgentComms/telegram.log (no token in it).
"""
from __future__ import annotations

import json
import sys
import urllib.error
import urllib.parse
import urllib.request
from datetime import datetime
from pathlib import Path

CONF = Path(__file__).resolve().parent.parent / "AgentComms" / "telegram.json"
LOG = CONF.with_name("telegram.log")
API = "https://api.telegram.org/bot{token}/{method}"
MAX_LEN = 1000


def _conf() -> dict:
    try:
        return json.loads(CONF.read_text(encoding="utf-8"))
    except (OSError, json.JSONDecodeError):
        return {}


def _log(line: str) -> None:
    try:
        with LOG.open("a", encoding="utf-8") as f:
            f.write(f"{datetime.now():%Y-%m-%d %H:%M:%S} {line}\n")
    except OSError:
        pass


def _call(token: str, method: str, params: dict) -> dict:
    data = urllib.parse.urlencode(params).encode()
    req = urllib.request.Request(API.format(token=token, method=method), data=data)
    with urllib.request.urlopen(req, timeout=10) as resp:
        return json.loads(resp.read().decode("utf-8"))


def send(text: str) -> bool:
    """True when the message went out; False (logged) when not set up or the send failed. Never raises."""
    c = _conf()
    if not c.get("token") or not c.get("chat_id"):
        _log("SKIP not set up")
        return False
    msg = ("FightCamp: " + text.strip())[:MAX_LEN]
    try:
        ok = bool(_call(c["token"], "sendMessage", {"chat_id": c["chat_id"], "text": msg}).get("ok"))
    except (urllib.error.URLError, OSError, ValueError) as e:
        _log(f"FAIL {type(e).__name__}")
        return False
    _log(("SENT " if ok else "FAIL api ") + msg[:80].replace("\n", " "))
    return ok


def setup() -> int:
    c = _conf()
    if not c.get("token"):
        print(f"no token yet: put {{\"token\": \"...\"}} from @BotFather in {CONF}")
        return 1
    try:
        res = _call(c["token"], "getUpdates", {})
    except (urllib.error.URLError, OSError, ValueError) as e:
        print(f"Telegram did not answer ({type(e).__name__}) - check the token")
        return 1
    chats = [u["message"]["chat"]["id"] for u in res.get("result", []) if "message" in u]
    if not chats:
        print("no message to the bot yet: send it any message from your phone, then run setup again")
        return 1
    c["chat_id"] = chats[-1]
    CONF.write_text(json.dumps(c, indent=2), encoding="utf-8")
    print("chat id stored - `test` sends a line")
    return 0


def main(argv: list[str]) -> int:
    cmd = argv[1] if len(argv) > 1 else "status"
    if cmd == "send":
        send(" ".join(argv[2:]))
        return 0
    if cmd == "setup":
        return setup()
    if cmd == "test":
        return 0 if send("test ping - pings work") else 1
    c = _conf()
    print(f"token {'set' if c.get('token') else 'MISSING'}, chat {'set' if c.get('chat_id') else 'MISSING'} ({CONF})")
    return 0


if __name__ == "__main__":
    sys.exit(main(sys.argv))
