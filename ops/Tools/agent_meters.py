"""agent_meters.py (S214) - one numeric meter per paid/metered agent, for the ops board and Tools/agent_router.py.

Operator S214: "can it show meters for codex too and the other paid agents and take decisions ?"
Every meter is read live from its own source; a source that cannot be read says so (live=False) instead of guessing.

  claude      ~/.claude/mods/model-router-live/claude_usage.json  (written by the usage-meter mod in every session)
  codex       rate_limits in the newest ~/.codex/sessions log      (ChatGPT plan quota: lost if unused - use it first)
  github      gh api billing (Actions minutes + the $40 hard-stop budget), via the ops board's own reader
  openrouter  openrouter.ai/api/v1/key with ~/.fightcamp/openrouter_key.txt (Cline's key)
  router      today's model-router spend from the per-session event files (what the routing saved vs all-Opus)

    python Tools/agent_meters.py          # print the meters as JSON
"""
from __future__ import annotations

import json
import re
import sys
from datetime import datetime, timezone
from pathlib import Path
from typing import Any

ROOT = Path(__file__).resolve().parents[1]
LIVE = Path.home() / ".claude" / "mods" / "model-router-live"
STALE_H = 6.0  # a reading older than this is shown but not trusted for decisions


def _iso(ts: float | None) -> str | None:
    return None if ts is None else datetime.fromtimestamp(ts, timezone.utc).isoformat(timespec="seconds")


def _age_h(iso: str | None) -> float | None:
    if not iso:
        return None
    try:
        return (datetime.now(timezone.utc) - datetime.fromisoformat(iso.replace("Z", "+00:00"))).total_seconds() / 3600.0
    except ValueError:
        return None


def _meter(agent: str, plan: str, windows: list[dict[str, Any]], as_of: str | None, source: str, paid: str, note: str = "") -> dict[str, Any]:
    age = _age_h(as_of)
    worst = max((float(w["used_pct"]) for w in windows if w.get("used_pct") is not None), default=None)
    return {"agent": agent, "plan": plan, "windows": windows, "worst_used_pct": worst, "as_of": as_of,
            "age_h": None if age is None else round(age, 2), "live": bool(windows) and age is not None and age < STALE_H,
            "source": source, "paid": paid, "note": note}


def claude() -> dict[str, Any]:
    src = LIVE / "claude_usage.json"
    try:
        d = json.loads(src.read_text(encoding="utf-8"))
    except (OSError, ValueError):
        return _meter("claude", "Claude plan", [], None, str(src), "plan", "no reading yet - the usage-meter mod writes it")
    windows = []
    if d.get("fiveHour") is not None:
        windows.append({"name": "5h", "used_pct": d["fiveHour"], "resets_at": d.get("fiveHourResets")})
    if d.get("weekly") is not None:
        windows.append({"name": "week", "used_pct": d["weekly"], "resets_at": d.get("weeklyResets")})
    return _meter("claude", "Claude plan (all models)", windows, d.get("at"), str(src), "plan")


def codex() -> dict[str, Any]:
    files = sorted(Path.home().glob(".codex/sessions/*/*/*/*.jsonl"), key=lambda p: p.stat().st_mtime, reverse=True)
    for f in files[:5]:
        try:
            text = f.read_text(encoding="utf-8", errors="replace")
        except OSError:
            continue
        hits = re.findall(r'"rate_limits":(\{"limit_id".*?"rate_limit_reached_type":[^}]*\})', text)
        if not hits:
            continue
        try:
            rl = json.loads(hits[-1])
        except ValueError:
            continue
        windows = []
        for key in ("primary", "secondary"):
            w = rl.get(key) or None
            if w:
                mins = int(w.get("window_minutes") or 0)
                windows.append({"name": "week" if mins >= 10000 else ("5h" if mins == 300 else "%dm" % mins),
                                "used_pct": w.get("used_percent"), "resets_at": _iso(w.get("resets_at"))})
        reached = rl.get("rate_limit_reached_type")
        return _meter("codex", "ChatGPT %s (Codex)" % rl.get("plan_type", "?"), windows, _iso(f.stat().st_mtime), str(f),
                      "plan", "LIMIT REACHED: %s" % reached if reached else "plan quota is lost if unused - use it first")
    return _meter("codex", "ChatGPT plan (Codex)", [], None, "~/.codex/sessions", "plan", "no session log with rate_limits")


def github() -> dict[str, Any]:
    try:
        sys.path.insert(0, str(ROOT / "Tools" / "opsboard"))
        from server import github_actions_meter  # type: ignore
        d = github_actions_meter()
    except Exception as exc:  # noqa: BLE001 - a meter never breaks the board
        return _meter("github", "GitHub Actions", [], None, "gh api", "money", "read failed: %s" % exc)
    if not d.get("ok"):
        return _meter("github", "GitHub Actions", [], None, "gh api", "money", str(d.get("why", "")))
    now = datetime.now(timezone.utc).isoformat(timespec="seconds")
    windows = [{"name": "free minutes", "used_pct": round(100.0 * d["used_min"] / float(d["free_min"]), 1), "resets_at": None}]
    if d.get("budget_usd"):
        windows.append({"name": "$ budget", "used_pct": round(100.0 * float(d["paid_usd"]) / float(d["budget_usd"]), 1), "resets_at": None})
    return _meter("github", "GitHub Actions (%s)" % d.get("org", ""), windows, now, "gh api billing", "money",
                  "$%.2f of $%.0f paid this month (hard stop)" % (float(d["paid_usd"]), float(d.get("budget_usd") or 0)))


def openrouter() -> dict[str, Any]:
    key_file = Path.home() / ".fightcamp" / "openrouter_key.txt"
    if not key_file.is_file():
        return _meter("openrouter", "OpenRouter (Cline)", [], None, str(key_file), "money", "no key file")
    try:
        import urllib.request
        req = urllib.request.Request("https://openrouter.ai/api/v1/key", headers={"Authorization": "Bearer " + key_file.read_text().strip()})
        d = json.load(urllib.request.urlopen(req, timeout=15)).get("data", {})
    except Exception as exc:  # noqa: BLE001
        return _meter("openrouter", "OpenRouter (Cline)", [], None, "openrouter.ai", "money", "read failed: %s" % exc)
    limit = d.get("limit")
    used = float(d.get("usage") or 0)
    windows = [{"name": "credit", "used_pct": round(100.0 * used / float(limit), 1) if limit else 0.0, "resets_at": None}]
    return _meter("openrouter", "OpenRouter (Cline)", windows, datetime.now(timezone.utc).isoformat(timespec="seconds"), "openrouter.ai",
                  "money", "free tier" if d.get("is_free_tier") else "$%.2f spent this month" % float(d.get("usage_monthly") or 0))


def router_today() -> dict[str, Any]:
    """Today's routed Claude requests from the model-router mod's event files (all sessions)."""
    today = datetime.now(timezone.utc).strftime("%Y-%m-%d")
    by_model: dict[str, int] = {}
    turns = 0
    for f in LIVE.glob("*.jsonl"):
        try:
            lines = f.read_text(encoding="utf-8").splitlines()
        except OSError:
            continue
        for line in lines:
            if today not in line[:40]:
                continue
            try:
                e = json.loads(line)
            except ValueError:
                continue
            if e.get("event") == "route" and e.get("kind") == "main":
                by_model[str(e.get("model"))] = by_model.get(str(e.get("model")), 0) + 1
            elif e.get("event") == "deciding":
                turns += 1
    return {"day": today, "prompts": turns, "requests_by_model": by_model}


def all_meters() -> dict[str, Any]:
    return {"at": datetime.now(timezone.utc).isoformat(timespec="seconds"),
            "meters": [claude(), codex(), github(), openrouter()], "router_today": router_today()}


if __name__ == "__main__":
    print(json.dumps(all_meters(), indent=1))
