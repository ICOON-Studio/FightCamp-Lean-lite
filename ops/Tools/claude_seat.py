"""claude_seat.py - ONE answer from a Claude model to the last message of a match file (S567, the agents' league).

Owner S567: "make it a league with the agents and you play also on opus". The league's Claude player is one Messages API
call a beat: the whole match so far is the file, the reply is printed. Billed to the Console API credit (the key lives
OUTSIDE the repo, in the .fightcamp folder under the user profile (console_api_key.txt), the one ops/Tools/sdk_run.py uses). No tools, no files.

    python ops/Tools/claude_seat.py <match_so_far.md> [--model claude-opus-5-5] [--max-tokens 1200]
"""
import argparse
import json
import os
import pathlib
import sys
import urllib.request

ap = argparse.ArgumentParser()
ap.add_argument("file")
ap.add_argument("--model", default="claude-opus-5-5")
ap.add_argument("--max-tokens", type=int, default=1200)
a = ap.parse_args()
key = (pathlib.Path(os.environ["USERPROFILE"]) / ".fightcamp" / "console_api_key.txt").read_text(encoding="utf-8").strip()
text = pathlib.Path(a.file).read_text(encoding="utf-8")
body = {"model": a.model, "max_tokens": a.max_tokens,
        "system": "You are a boxer in a match of a small turn-based boxing game, playing to win. The user message is the whole match so far. Answer ONLY its LAST message, exactly in the form it asks for.",
        "messages": [{"role": "user", "content": text}]}
req = urllib.request.Request("https://api.anthropic.com/v1/messages", data=json.dumps(body).encode("utf-8"),
                             headers={"x-api-key": key, "anthropic-version": "2023-06-01", "content-type": "application/json"})
try:
    with urllib.request.urlopen(req, timeout=180) as r:
        d = json.loads(r.read().decode("utf-8"))
except urllib.error.HTTPError as e:
    sys.stderr.write("CLAUDE_SEAT HTTP %s %s\n" % (e.code, e.read().decode("utf-8", "replace")[:300]))
    sys.exit(4)
sys.stdout.reconfigure(encoding="utf-8")
print("".join(b.get("text", "") for b in d.get("content", []) if b.get("type") == "text").strip())
sys.stderr.write("CLAUDE_SEAT usage %s\n" % json.dumps(d.get("usage", {})))
