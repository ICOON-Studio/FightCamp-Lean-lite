"""audio_ear.py - can the local Ollama model (gemma4:12b, "audio" capability) pre-screen our sounds? A BLIND test first (S385).

Nobody on the team can hear but the operator. Before any model's opinion of a sound is trusted, it must prove it hears at all:
  calibrate   every sounds.json file is sent with NO name; the model picks what it is from the list of event names. Plus two
              controls it cannot get right by guessing: pure silence and white noise (answer must be "silence" / "noise").
              Accuracy well above chance (1/N) and both controls right = it hears; else its verdicts are worth nothing.
  screen <f>  only after a passing calibration: a short defect list (clipping, mush, wrong sound, too long a tail) - a pre-screen,
              never a keep. The operator's ear on the sound board is the only keep.

    python tools/audio_ear.py calibrate [--model gemma4:12b]
    python tools/audio_ear.py screen assets/audio/fight/punch_big_1.ogg

PC gates (loaded, gemma4:12b holds 11.5 GB of RAM and took the PC to RED once): refuses while the watchdog verdict is RED or
COMMIT_free < 14 GB; keep_alive 0 unloads it after every call. Writes AgentComms-free output to assets/audio/ear_calibration.json.
"""
from __future__ import annotations

import argparse
import base64
import json
import random
import re
import shutil
import subprocess
import sys
import tempfile
import urllib.request
from pathlib import Path

GAME = Path(__file__).resolve().parent.parent
MANIFEST = GAME / "assets" / "audio" / "sounds.json"
OUT = GAME / "assets" / "audio" / "ear_calibration.json"
VERDICT = GAME / "ops" / "AgentComms" / "pc_verdict.json"
URL = "http://127.0.0.1:11434/api/chat"
FFMPEG = shutil.which("ffmpeg") or "ffmpeg"
COMMIT_MIN_GB = 14.0


def pc_ok() -> str:
    try:
        v = json.loads(VERDICT.read_text(encoding="utf-8"))
    except (OSError, ValueError):
        return "no watchdog verdict (run ops/Tools/pc_watchdog.ps1 -Once)"
    if v.get("state") == "RED":
        return "watchdog RED"
    m = re.search(r"COMMIT_free=([\d.]+)GB", str(v.get("line", "")))
    if m and float(m.group(1)) < COMMIT_MIN_GB:
        return f"COMMIT_free {m.group(1)} GB < {COMMIT_MIN_GB} GB (the model needs 11.5 GB loaded)"
    return ""


def wav16(src: Path | None, synth: str = "") -> bytes:
    """16 kHz mono WAV bytes of a file, or of a synthetic control (anullsrc / anoisesrc)."""
    with tempfile.TemporaryDirectory() as td:
        out = Path(td) / "a.wav"
        args = [FFMPEG, "-y", "-hide_banner", "-loglevel", "error"]
        args += ["-f", "lavfi", "-t", "1.5", "-i", synth] if synth else ["-i", str(src)]
        args += ["-ac", "1", "-ar", "16000", str(out)]
        subprocess.run(args, capture_output=True, creationflags=getattr(subprocess, "CREATE_NO_WINDOW", 0))
        return out.read_bytes()


def ask(model: str, prompt: str, audio: bytes) -> str:
    # Ollama passes media through the `images` list; an audio-capable model reads WAV there. If it silently ignores the
    # audio, the blind calibration below shows it (chance-level accuracy, the controls wrong).
    body = {"model": model, "stream": False, "think": False, "keep_alive": 0, "options": {"temperature": 0.0},
            "messages": [{"role": "user", "content": prompt, "images": [base64.b64encode(audio).decode()]}]}
    req = urllib.request.Request(URL, json.dumps(body).encode(), {"Content-Type": "application/json"})
    return str(json.loads(urllib.request.urlopen(req, timeout=600).read())["message"]["content"]).strip()


def calibrate(model: str) -> int:
    why = pc_ok()
    if why:
        print(f"AUDIO_EAR refused: {why}")
        return 2
    d = json.loads(MANIFEST.read_text(encoding="utf-8"))
    names = sorted(d["events"]) + ["silence", "noise"]
    items = [(rel, r["event"]) for rel, r in d["files"].items()] + [("<silence>", "silence"), ("<noise>", "noise")]
    random.Random(385).shuffle(items)
    rows, right = [], 0
    for rel, truth in items:
        audio = wav16(None, "anullsrc=r=16000:cl=mono") if truth == "silence" and rel.startswith("<") else \
            wav16(None, "anoisesrc=r=16000:a=0.3") if truth == "noise" and rel.startswith("<") else wav16(GAME / rel)
        prompt = ("Listen to the attached audio clip. Which ONE of these labels describes it best? Answer with the label only.\n"
                  "Labels: " + ", ".join(names))
        try:
            ans = ask(model, prompt, audio)
        except (OSError, ValueError, KeyError) as e:
            print(f"AUDIO_EAR call failed: {e}")
            return 1
        pick = next((n for n in sorted(names, key=len, reverse=True) if n in ans.lower()), ans[:40])
        ok = pick == truth
        right += ok
        rows.append({"file": rel, "truth": truth, "answer": ans[:120], "pick": pick, "ok": ok})
        print(f"{'OK  ' if ok else 'MISS'} {truth:18} -> {pick}")
    chance = 1.0 / len(names)
    acc = right / len(items)
    controls = all(r["ok"] for r in rows if r["file"].startswith("<"))
    hears = acc >= 3 * chance and controls
    OUT.write_text(json.dumps({"model": model, "accuracy": round(acc, 3), "chance": round(chance, 3), "controls_right": controls,
                               "hears": hears, "rows": rows}, indent=1) + "\n", encoding="utf-8")
    print(f"AUDIO_EAR model={model} accuracy={acc:.2f} chance={chance:.2f} controls={'right' if controls else 'WRONG'} "
          f"hears={'yes' if hears else 'NO'} -> {OUT.relative_to(GAME)}")
    return 0


def screen(model: str, f: Path) -> int:
    why = pc_ok()
    if why:
        print(f"AUDIO_EAR refused: {why}")
        return 2
    cal = json.loads(OUT.read_text(encoding="utf-8")) if OUT.exists() else {}
    if not cal.get("hears"):
        print("AUDIO_EAR refused: no passing blind calibration (run `calibrate`); its opinion would be a guess")
        return 2
    print(ask(model, "You are a game sound engineer. List any defects in this sound effect, one per line: clipping or "
                     "distortion, muffled / low-passed, too long a tail, a click at start or end, background noise, sounds "
                     "synthetic. Then one line: what the sound is.", wav16(f)))
    return 0


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("cmd", choices=["calibrate", "screen"])
    ap.add_argument("file", nargs="?")
    ap.add_argument("--model", default="gemma4:12b")
    a = ap.parse_args()
    return calibrate(a.model) if a.cmd == "calibrate" else screen(a.model, GAME / a.file)


if __name__ == "__main__":
    sys.exit(main())
