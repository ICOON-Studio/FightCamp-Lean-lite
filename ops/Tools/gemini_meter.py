"""gemini_meter.py - what our Gemini runs cost (S367, operator: "can you add the api meter on the board").

Gemini runs in AI Studio in the operator's browser (his paid key, "Default Gemini Project"; operator: "use gemini on the
browser"), so there is no usage feed to read: every judging run is logged here with the token counts AI Studio shows and
priced at Google's published rates. The ops board's Gemini strip (/api/gemini) sums the month.

    python Tools/gemini_meter.py add --model argon --in 20696 --out 1800 --what "fight film round 2"
    python Tools/gemini_meter.py add --model flash --in 20696 --out 1500 --what "pilot, 3 clips" --free
    python Tools/gemini_meter.py budget 11          # the monthly cap in USD (set the same cap in Google Cloud billing)
    python Tools/gemini_meter.py                    # this month's summary
"""
from __future__ import annotations

import argparse
import json
import sys
import time
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
LOG = ROOT / "AgentComms" / "gemini_usage.jsonl"
BUDGET = ROOT / "AgentComms" / "gemini_budget.json"

## USD per 1M tokens (input, output). AI Studio's model picker, read 2026-11-02: Gemini 4 Argon $2 / $10 through
## 2026-11-30, then $4 / $20; Gemini 3.8 Flash $0.75 / $3.75 through 2026-12-31. Re-read the picker when a date passes.
PRICES = {
    "argon": [("2026-11-30", 2.0, 10.0), ("9999-12-31", 4.0, 20.0)],
    "flash": [("2026-12-31", 0.75, 3.75), ("9999-12-31", 0.75, 3.75)],
}
NAMES = {"argon": "Gemini 4 Argon", "flash": "Gemini 3.8 Flash"}

## S372 spend brake (operator: "how it reached the limit in 5 hours?"). Google's project cap stopped every call on 2026-11-03
## at EUR 15.38 counted, while this log priced the same calls (4.04M in / 57k out, matching AI Studio's Usage page) at
## USD 8.65: the cap counts about GOOGLE_FACTOR x the published-rate estimate. check() runs before every paid call and
## refuses one that would take the month's Google-counted spend past the budget, or one film too long to be a judge film.
GOOGLE_FACTOR = 1.8          # measured S372 (15.38 / 8.65); re-measure when the itemised bill posts
DEFAULT_BUDGET = 14.0        # Google-counted, under his EUR 15 cap; `gemini_meter.py budget <n>` when he raises the cap
MAX_CALL_TOKENS = 400_000    # a judge film is ~220-260k (walk-in + 90 s at 24 fps); FIGHT9R1's frozen 6.5-min menu was 737k
TOKENS_PER_FRAME = 80        # measured S372: 737,511 tokens / (398 s x 24 fps); 256k / ~125 s x 24


def budget_usd() -> float:
    try:
        return float(json.loads(BUDGET.read_text(encoding="utf-8"))["budget_usd"])
    except (OSError, ValueError, KeyError, TypeError):
        return DEFAULT_BUDGET


def month_counted() -> float:
    """This month's spend as Google's cap counts it (our published-rate log x GOOGLE_FACTOR)."""
    month = time.strftime("%Y-%m")
    return round(sum(float(r.get("usd", 0)) for r in rows() if str(r.get("at", "")).startswith(month)) * GOOGLE_FACTOR, 4)


def video_tokens(seconds: float, fps: int) -> int:
    return int(seconds * fps * TOKENS_PER_FRAME) + 2000


def check(model: str, tokens_in: int, what: str, tokens_out: int = 4000, allow_long: bool = False) -> None:
    """Raise SystemExit (no call made) when this call would pass the month's budget or is too long a film."""
    if tokens_in > MAX_CALL_TOKENS and not allow_long:
        raise SystemExit(f"GEMINI BRAKE: {what} is ~{tokens_in:,} tokens (cap {MAX_CALL_TOKENS:,} a call) - cut the film to the "
                         f"part being judged, or pass --allow-long")
    est = price(model, time.strftime("%Y-%m-%d"), tokens_in, tokens_out) * GOOGLE_FACTOR
    spent, budget = month_counted(), budget_usd()
    if spent + est > budget:
        raise SystemExit(f"GEMINI BRAKE: {what} (~{est:.2f}) would take this month to {spent + est:.2f} of the {budget:.2f} budget "
                         f"(Google-counted). Raise it with `python ops/Tools/gemini_meter.py budget <n>` after the cap at "
                         f"ai.studio/spend goes up.")


def price(model: str, day: str, tokens_in: int, tokens_out: int) -> float:
    for until, p_in, p_out in PRICES[model]:
        if day <= until:
            return round((tokens_in * p_in + tokens_out * p_out) / 1e6, 4)
    return 0.0


def add(model: str, tokens_in: int, tokens_out: int, what: str, free: bool = False) -> dict:
    day = time.strftime("%Y-%m-%d")
    row = {"at": time.strftime("%Y-%m-%dT%H:%M:%S"), "model": model, "in": tokens_in, "out": tokens_out,
           "usd": 0.0 if free else price(model, day, tokens_in, tokens_out), "free": free, "what": what}
    LOG.parent.mkdir(parents=True, exist_ok=True)
    with LOG.open("a", encoding="utf-8") as f:
        f.write(json.dumps(row, ensure_ascii=False) + "\n")
    return row


def rows() -> list[dict]:
    if not LOG.is_file():
        return []
    out = []
    for line in LOG.read_text(encoding="utf-8").splitlines():
        try:
            out.append(json.loads(line))
        except ValueError:
            pass
    return out


def summary() -> dict:
    month = time.strftime("%Y-%m")
    mine = [r for r in rows() if str(r.get("at", "")).startswith(month)]
    budget = None
    try:
        budget = float(json.loads(BUDGET.read_text(encoding="utf-8"))["budget_usd"])
    except (OSError, ValueError, KeyError, TypeError):
        pass
    usd = round(sum(float(r.get("usd", 0)) for r in mine), 4)
    by_model: dict[str, dict] = {}
    for r in mine:
        m = by_model.setdefault(NAMES.get(r["model"], r["model"]), {"runs": 0, "usd": 0.0})
        m["runs"] += 1
        m["usd"] = round(m["usd"] + float(r.get("usd", 0)), 4)
    return {"ok": True, "month": month, "runs": len(mine), "in_tokens": sum(int(r.get("in", 0)) for r in mine),
            "out_tokens": sum(int(r.get("out", 0)) for r in mine), "usd": usd, "budget_usd": budget,
            "google_counted": round(usd * GOOGLE_FACTOR, 2), "brake_budget": budget_usd(),
            "by_model": by_model, "last": mine[-1] if mine else None,
            "source": "logged per run (AI Studio in his browser shows no usage feed); priced at the picker's rates"}


def main(argv: list[str]) -> int:
    ap = argparse.ArgumentParser()
    sub = ap.add_subparsers(dest="cmd")
    a = sub.add_parser("add")
    a.add_argument("--model", choices=sorted(PRICES), required=True)
    a.add_argument("--in", dest="tin", type=int, required=True)
    a.add_argument("--out", dest="tout", type=int, required=True)
    a.add_argument("--what", required=True)
    a.add_argument("--free", action="store_true", help="a free-tier run (before his paid key was linked)")
    b = sub.add_parser("budget")
    b.add_argument("usd", type=float)
    args = ap.parse_args(argv)
    if args.cmd == "add":
        print(json.dumps(add(args.model, args.tin, args.tout, args.what, args.free)))
    elif args.cmd == "budget":
        BUDGET.write_text(json.dumps({"budget_usd": args.usd}) + "\n", encoding="utf-8")
        print(f"budget set: ${args.usd:.2f} a month")
    else:
        print(json.dumps(summary(), indent=1))
    return 0


if __name__ == "__main__":
    sys.exit(main(sys.argv[1:]))
