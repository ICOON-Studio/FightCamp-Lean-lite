"""S237: call one Ziva MCP tool (the Ziva plugin in the editor of E:/FightCamp/wt/ZIVA) from a shell.

    python Tools/ziva_mcp.py <tool> '<json args>' [--out DIR]

Prints the text parts of the result; image parts are saved as PNG in --out (default E:/FightCamp/tmp/ziva_out) and their
paths printed. The server is the plugin's sidecar (logs: %APPDATA%/Godot/app_userdata/FightCamp/ziva/logs/*_sidecar.log);
it exists only while that editor runs (Tools/godot_hidden.ps1 -e --path E:/FightCamp/wt/ZIVA/Godot).
"""
import base64
import json
import os
import sys
import time
import urllib.request

URL = os.environ.get("ZIVA_MCP_URL", "http://127.0.0.1:7012/api/mcp")


def _post(payload, session=""):
    headers = {"Content-Type": "application/json", "Accept": "application/json, text/event-stream"}
    if session:
        headers["mcp-session-id"] = session
    req = urllib.request.Request(URL, data=json.dumps(payload).encode("utf-8"), headers=headers, method="POST")
    with urllib.request.urlopen(req, timeout=900) as resp:
        sid = resp.headers.get("mcp-session-id", session)
        raw = resp.read().decode("utf-8", "replace")
    body = raw
    for line in raw.splitlines():
        if line.startswith("data:"):
            body = line[5:]
    return sid, (json.loads(body) if body.strip() else {})


def call(tool, args):
    sid, _ = _post({"jsonrpc": "2.0", "id": 1, "method": "initialize",
                    "params": {"protocolVersion": "2025-06-18", "capabilities": {}, "clientInfo": {"name": "fightcamp", "version": "1"}}})
    _post({"jsonrpc": "2.0", "method": "notifications/initialized"}, sid)
    _, res = _post({"jsonrpc": "2.0", "id": 2, "method": "tools/call", "params": {"name": tool, "arguments": args}}, sid)
    return res


def main():
    argv = sys.argv[1:]
    out = "E:/FightCamp/tmp/ziva_out"
    if "--out" in argv:
        i = argv.index("--out")
        out = argv[i + 1]
        del argv[i:i + 2]
    tool = argv[0]
    args = {}
    if len(argv) > 1:
        args = json.load(open(argv[1], encoding="utf-8")) if os.path.isfile(argv[1]) else json.loads(argv[1])
    args.setdefault("reasoning", "FightCamp playtest step driven by Claude.")
    os.makedirs(out, exist_ok=True)
    res = call(tool, args)
    if "error" in res:
        print("ZIVA ERROR", json.dumps(res["error"])[:2000])
        sys.exit(1)
    stamp = time.strftime("%H%M%S")
    n = 0
    for part in res.get("result", {}).get("content", []):
        if part.get("type") == "text":
            print(part.get("text", ""))
        elif part.get("type") == "image":
            n += 1
            path = os.path.join(out, "%s_%s_%d.png" % (tool, stamp, n))
            with open(path, "wb") as fh:
                fh.write(base64.b64decode(part.get("data", "")))
            print("ZIVA IMAGE", path)
    if res.get("result", {}).get("isError"):
        sys.exit(1)


if __name__ == "__main__":
    main()
