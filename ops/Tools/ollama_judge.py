"""ollama_judge.py - the local judge (gemma4:12b vision on Ollama) when Gemini and Claude's eyes are both out (S385).

Operator S385: "ollama is installed on the pc check if you can put more work on it". The loops held 16 h on 11-05 with
Gemini's prepay dry (HTTP 402) and Claude's weekly limit hit at the same time. seat_dispatch.judge tries Gemini, then
Claude's eyes (claude_judge.py), then this:

    python Tools/ollama_judge.py <film.mp4> [--kind fight|bjj] [--what LABEL] [--intent TEXT] [--model gemma4:12b]

Same contact sheets as claude_judge (eyes bursts) and the same FIGHT_PROMPT / BJJ_PROMPT, so the "Score: N/10" line
reads the same. Calibration S385 against Claude's eyes on the same sheets: BJJ9R16 2 vs 2.5, FIGHT9R13 6 vs 5.5,
FIGHT9R12 5.5 vs 6 (75-114 s a film). Its film times and details are LOW TRUST (a 12B model), so the verdict file says
so. Gates: refuses while the PC watchdog is RED; unloads the model right after (keep_alive 0) - loaded it held 11.5 GB
of RAM and took the PC RED once (S385). Exit 0 with a verdict, 1 without.
"""
from __future__ import annotations

import argparse
import base64
import json
import sys
import urllib.request
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))
import claude_judge  # noqa: E402  (the sheets and the sheet note)
import gemini_judge  # noqa: E402  (the same prompts as Argon)

URL = "http://127.0.0.1:11434/api/chat"
MODEL = "gemma4:12b"
VERDICT = Path(__file__).resolve().parent.parent / "AgentComms" / "pc_verdict.json"


def pc_red() -> bool:
    try:
        return str(json.loads(VERDICT.read_text(encoding="utf-8")).get("state", "")) == "RED"
    except (OSError, ValueError):
        return False


def judge(mp4: Path, kind: str, what: str, intent: str, model: str = MODEL, every: float = 10.0) -> Path | None:
    if pc_red():
        print("OLLAMA_JUDGE skipped: PC watchdog RED")
        return None
    shots = claude_judge.sheets(mp4, claude_judge.out_dir(mp4), every)
    if not shots:
        print(f"OLLAMA_JUDGE no contact sheets for {mp4}")
        return None
    prompt = (gemini_judge.BJJ_PROMPT if kind == "bjj" else gemini_judge.FIGHT_PROMPT) + (f"\nContext: {intent}" if intent else "")
    prompt += claude_judge.SHEET_NOTE.replace("Open EVERY image with your Read tool before you answer, in order.",
                                              "The images are attached in this order: " + ", ".join(s.name for s in shots) + ".")
    body = {"model": model, "stream": False, "think": False, "keep_alive": 0,
            "options": {"num_ctx": 32768, "temperature": 0.2},
            "messages": [{"role": "user", "content": prompt,
                          "images": [base64.b64encode(s.read_bytes()).decode() for s in shots]}]}
    try:
        req = urllib.request.Request(URL, json.dumps(body).encode(), {"Content-Type": "application/json"})
        text = str(json.loads(urllib.request.urlopen(req, timeout=1800).read())["message"]["content"]).strip()
    except (OSError, ValueError, KeyError) as e:
        print(f"OLLAMA_JUDGE failed: {e}")
        return None
    if "score" not in text.lower():
        print(f"OLLAMA_JUDGE no score line: {text[-300:]}")
        return None
    md = mp4.with_suffix(".gemini_argon.md")
    md.write_text(f"# JUDGE: local {model} (Ollama) on {len(shots)} eyes contact sheets ({what or mp4.name}) - the film "
                  f"judge (operator S399: Ollama only). LOW TRUST: check film times and details on the film before acting on them.\n\n"
                  f"{text}\n", encoding="utf-8")
    print(f"OLLAMA_JUDGE {md}")
    return md


def main(argv: list[str]) -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("film")
    ap.add_argument("--kind", default="fight", choices=["fight", "bjj"])
    ap.add_argument("--what", default="")
    ap.add_argument("--intent", default="")
    ap.add_argument("--model", default=MODEL)
    ap.add_argument("--every", type=float, default=10.0)
    a = ap.parse_args(argv)
    return 0 if judge(Path(a.film), a.kind, a.what, a.intent, a.model, a.every) else 1


if __name__ == "__main__":
    sys.exit(main(sys.argv[1:]))
