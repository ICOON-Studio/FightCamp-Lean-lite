#!/usr/bin/env python3
"""xai_ask.py - ask a Grok "bot" (John / Kalli / Maria) through the xAI API instead of the Grok Bot desktop app.

S224 (operator: "dont you use xai api for grok bots ?"): gbot broke when the Grok Bot app moved its bot roster to its cloud
machine. This calls https://api.x.ai directly with the repo secret XAI_API_KEY. It runs in GitHub Actions
(.github/workflows/xai-research.yml) so Claude never handles the key:

    gh workflow run xai-research.yml -f task=research/TASK_J68_CORNER_MINUTE.md -f bot=john -f out=research/J68_REPLY_XAI.md

Locally (only if the operator set XAI_API_KEY in his own shell): python Tools/xai_ask.py --task <file> --bot john --out <file>.
Stdlib only. Tries the Responses API with live web search first (research needs sources), falls back to chat completions.
"""
import argparse, base64, json, os, sys, time, urllib.error, urllib.request

API = "https://api.x.ai/v1"
BOTS = {
    "john": "You are John, a senior research analyst for FightCamp, a PC boxing gym management simulation. Answer with real-world "
            "numbers, each with its source (study, population, year) or marked ESTIMATE. Search the web. Never invent a citation. "
            "Give the longest complete answer the question needs.",
    "kalli": "You are Kalli, a senior game designer for FightCamp, a PC deep management sim (Football Manager / Motorsport Manager "
             "depth) about running a boxing gym. Give concrete, buildable mechanisms with exact numbers, how the player sees them, "
             "and how they fail if abused. No research filler.",
    # S231 (operator: "setup a project manager bot to review and update the board and guide you and dola and whatever else
    # a project manager does"): Tools/pm_bot.py sends it a snapshot of the ops board; its reply is a review + board edits.
    "pm": "You are Paul, the project manager of FightCamp, a PC boxing-gym management sim (Godot 4) built by a tiny studio: "
          "the operator (CEO, playtester) approves; Claude is the developer who briefs, reviews and merges; agents do the work "
          "(Arena = cloud pure modules + tests, Goose = long cloud jobs, Cursor = Godot UI, Codex = big code, Ludo = lead game/art "
          "designer, Dola = fresh-eyes research, John = deep research, Kalli = game design, Maria = art direction, Grok Dev = code). "
          "The goal is a playable boxing demo with ALL mechanics on. You get a snapshot of the ops board. "
          "DEMO SCOPE CHECK (S235, operator: \"how did that got past ludo and paul ??\" - a kickboxing low-kick test in an MMA room "
          "ran 3 agent rounds as demo work): the demo is BOXING ONLY, its fight palette limited to certified boxing moves. Before "
          "you rank, keep or delegate any row, ask which discipline it is: a row whose move, test or fixture is MMA, kickboxing, Muay "
          "Thai, judo, wrestling, BJJ, clinch-grappling or kicks/knees is OFF-DEMO - say so by id and put it in park, never in NEXT 5; "
          "a row that does not say its discipline is UNKNOWN - ask Claude to label it, do not assume boxing. Be blunt and specific: "
          "cite row ids, commits and dates from the snapshot only - never invent a row, a result or a number. When the snapshot has a "                    "section where THE OPERATOR WRITES TO YOU DIRECTLY, start with 0 TO THE OPERATOR: answer each message by its id, plainly, "                    "in a few lines, as his project manager (what you will do, what you need from him). Output, in order: "
          "1 STATUS (3 lines: what moved, what is stuck, distance to a playable demo); 2 STALE OR DEAD (rows/runs with no "
          "progress, each with keep/park/close and why); 3 NEXT 5 (the five highest-value items, each with owner seat and the "
          "acceptance test); 4 DELEGATION (every free seat gets one task - name it); 5 FOR CLAUDE (what to stop, start, fix "
          "first); 6 FOR LUDO (operator S232: \"paul should communicate with ludo not dola\" - one ask for Ludo, the lead game + art "
          "designer, written as the exact question Claude pastes into Ask Ludo: design, mechanics, art or the code he writes); 7 OPERATOR (only money/taste/scope questions, max 3); "
          "8 BOARD EDITS as one fenced json block: {\"close\": [ids], \"park\": [ids], \"focus\": [ids], \"notes\": {id: text}}.",
    "maria": "You are Maria, art director for FightCamp, a stylised 3D boxing gym management sim (Godot 4). Give concrete art "
             "direction: hex colours, materials, lighting, camera framing, references by name.",
}


def _post(path, body, key, timeout):
    req = urllib.request.Request(API + path, data=json.dumps(body).encode("utf-8"), method="POST",
                                 headers={"Authorization": "Bearer " + key, "Content-Type": "application/json"})
    with urllib.request.urlopen(req, timeout=timeout) as r:
        return json.loads(r.read().decode("utf-8"))


def _stream(path, body, key, timeout):
    """S224: a long reasoning answer over one silent request was dropped by the server after ~4 min (RemoteDisconnected).
    Streaming keeps bytes flowing. Collects Responses-API output_text deltas and chat-completions content deltas."""
    body = dict(body, stream=True)
    req = urllib.request.Request(API + path, data=json.dumps(body).encode("utf-8"), method="POST",
                                 headers={"Authorization": "Bearer " + key, "Content-Type": "application/json",
                                          "Accept": "text/event-stream"})
    parts = []
    with urllib.request.urlopen(req, timeout=timeout) as r:
        for raw in r:
            line = raw.decode("utf-8", "replace").strip()
            if not line.startswith("data:"):
                continue
            payload = line[5:].strip()
            if payload == "[DONE]":
                break
            try:
                ev = json.loads(payload)
            except ValueError:
                continue
            if ev.get("type") == "response.output_text.delta":
                parts.append(ev.get("delta", ""))
            for ch in ev.get("choices", []) or []:
                parts.append((ch.get("delta") or {}).get("content") or "")
    return "".join(parts)


def _get(path, key):
    req = urllib.request.Request(API + path, headers={"Authorization": "Bearer " + key})
    with urllib.request.urlopen(req, timeout=60) as r:
        return json.loads(r.read().decode("utf-8"))


def _responses_text(data):
    out = []
    for item in data.get("output", []):
        for c in item.get("content", []) or []:
            if c.get("type") in ("output_text", "text") and c.get("text"):
                out.append(c["text"])
    return "\n".join(out) or data.get("output_text", "")


def _images(task: str) -> list:
    """S227: a task line `IMAGE: <repo path>` attaches that picture (operator S220: pictures are uploaded, never described)."""
    out = []
    for line in task.splitlines():
        if line.startswith("IMAGE:"):
            path = line[len("IMAGE:"):].strip()
            ext = os.path.splitext(path)[1].lower().lstrip(".")
            mime = "image/jpeg" if ext in ("jpg", "jpeg") else "image/" + (ext or "png")
            data = base64.b64encode(open(path, "rb").read()).decode("ascii")
            out.append((path, "data:%s;base64,%s" % (mime, data)))
    return out


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--task", required=True)
    ap.add_argument("--bot", default="john", choices=sorted(BOTS))
    ap.add_argument("--out", required=True)
    ap.add_argument("--model", default=os.environ.get("GROK_RESEARCH_MODEL", ""))
    ap.add_argument("--timeout", type=int, default=1500)
    a = ap.parse_args()
    key = os.environ.get("XAI_API_KEY", "")
    if not key:
        print("XAI_API_KEY missing", file=sys.stderr)
        return 3
    try:
        models = [m.get("id", "") for m in _get("/models", key).get("data", [])]
    except Exception as e:  # listing is diagnostics only
        models = []
        print("models list failed:", e)
    print("xAI models:", ", ".join(models), flush=True)
    # S224 first run listed grok-4.3 ... grok-4.7 + dated 4.20 builds: take the highest plain grok-<major>.<minor> (text models only).
    plain = []
    for m in models:
        parts = m.split("-")
        if len(parts) == 2 and parts[0] == "grok" and parts[1].replace(".", "").isdigit():
            plain.append((tuple(int(x) for x in parts[1].split(".")), m))
    model = a.model or (max(plain)[1] if plain else "grok-4.7")
    task = open(a.task, encoding="utf-8").read()
    system = BOTS[a.bot]
    images = _images(task)
    print("images attached:", ", ".join(p for p, _ in images) or "none", flush=True)
    user_resp = [{"type": "input_text", "text": task}] + [{"type": "input_image", "image_url": u, "detail": "high"} for _, u in images]
    user_chat = [{"type": "text", "text": task}] + [{"type": "image_url", "image_url": {"url": u, "detail": "high"}} for _, u in images]
    t0 = time.time()
    text, route = "", ""
    try:
        text = _stream("/responses", {"model": model, "input": [{"role": "system", "content": system},
                                                                {"role": "user", "content": user_resp if images else task}],
                                      "tools": [{"type": "web_search"}]}, key, a.timeout)
        route = "responses+web_search (stream)"
    except urllib.error.HTTPError as e:
        print("responses API failed:", e.code, e.read().decode("utf-8", "replace")[:400], flush=True)
    except Exception as e:
        print("responses API failed:", repr(e), flush=True)
    if not text:
        text = _stream("/chat/completions", {"model": model, "messages": [{"role": "system", "content": system},
                                                                          {"role": "user", "content": user_chat if images else task}]}, key, a.timeout)
        route = "chat/completions (stream, no web search)"
    head = "# %s reply via xAI API (model %s, route %s, %d chars, %.0f s)\n# Task: %s\n\n" % (
        a.bot.capitalize(), model, route, len(text), time.time() - t0, a.task)
    os.makedirs(os.path.dirname(os.path.abspath(a.out)), exist_ok=True)
    open(a.out, "w", encoding="utf-8").write(head + text + "\n")
    print("wrote", a.out, len(text), "chars via", route)
    return 0 if text.strip() else 1


if __name__ == "__main__":
    sys.exit(main())
