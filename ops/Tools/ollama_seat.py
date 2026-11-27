"""ollama_seat.py - ONE answer from a LOCAL model (Ollama on this PC's GPU) to one message of a match (S568).

Owner S568, on the 5-second clock: "which agents can use the multiplayer version for real time counting ?", then "yes" to
trying a local model. Measured S568 on the RX 6800 XT with gemma4:12b: 1.4 s a beat (1,360 prompt tokens + a 12-token plan),
12 s for the first call (the model loads). Two settings make it fast: think=false (the model otherwise spends its whole
budget thinking and answers nothing) and num_ctx 8192 (Ollama's default here is 262,144, which made a beat take 20 s).
The rules go in the system message once (rules file); the message is the current beat only. Nothing leaves the PC.

    python ops/Tools/ollama_seat.py <message.txt> --rules <rules.txt> [--model gemma4:12b] [--max-tokens 40]
Prints the answer; stderr: OLLAMA_SEAT <seconds>s prompt <n> gen <n>.
"""
import argparse
import json
import pathlib
import sys
import time
import urllib.request

ap = argparse.ArgumentParser()
ap.add_argument("message")
ap.add_argument("--rules", default="")
ap.add_argument("--model", default="gemma4:12b")
ap.add_argument("--max-tokens", type=int, default=40)
ap.add_argument("--ctx", type=int, default=8192)
a = ap.parse_args()
rules = pathlib.Path(a.rules).read_text(encoding="utf-8") if a.rules and pathlib.Path(a.rules).exists() else ""
system = "You are a boxer in a small turn-based boxing game, playing to win. Answer ONLY the message, exactly in the form it asks for, as briefly as it allows.\n\n" + rules
body = {"model": a.model, "stream": False, "think": False, "keep_alive": "30m",
        "messages": [{"role": "system", "content": system}, {"role": "user", "content": pathlib.Path(a.message).read_text(encoding="utf-8")}],
        "options": {"num_predict": a.max_tokens, "temperature": 0.7, "num_ctx": a.ctx}}
t = time.time()
try:
    req = urllib.request.Request("http://127.0.0.1:11434/api/chat", data=json.dumps(body).encode("utf-8"), headers={"content-type": "application/json"})
    with urllib.request.urlopen(req, timeout=300) as r:
        d = json.loads(r.read().decode("utf-8"))
except Exception as e:  # Ollama not running, model missing
    sys.stderr.write("OLLAMA_SEAT error %s\n" % e)
    sys.exit(4)
sys.stdout.reconfigure(encoding="utf-8")
print(((d.get("message") or {}).get("content") or "").strip())
sys.stderr.write("OLLAMA_SEAT %.1fs prompt %s gen %s\n" % (time.time() - t, d.get("prompt_eval_count"), d.get("eval_count")))
