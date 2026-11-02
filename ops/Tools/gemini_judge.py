"""gemini_judge.py - Gemini watches a game video and judges the motion (S367, operator: "Use the script route").

AI Studio in the browser failed on every video once his paid key was linked (HTTP 500 "Token count failed", Argon and
Flash alike), so this sends the clip through the Gemini API's own file upload instead. The key is the operator's: he
sets it with `setx GEMINI_API_KEY "..."`; this reads it from the process or from HKCU\\Environment (a setx value reaches
new Explorer processes only) and never prints it. Every run is logged with its exact token counts by gemini_meter.py,
so the ops board's Gemini strip shows the real spend.

    python Tools/gemini_judge.py <clip.mp4> [--model argon|flash] [--fps 24] [--kind fight|clip]
                                 [--intent "Video = the rear hook beat"] [--prompt-file p.txt] [--what "label"]

Writes <clip>.gemini_<model>.md beside the clip and prints the answer. Video is sampled at --fps (the API's default is
1 frame a second - a snap or a foot slide is invisible at 1; pilot S367: ops/research/GEMINI_JUDGE_PILOT_S367.md).
"""
from __future__ import annotations

import argparse
import json
import os
import sys
import time
from pathlib import Path

import requests

sys.path.insert(0, str(Path(__file__).resolve().parent))
import gemini_meter  # noqa: E402

API = "https://generativelanguage.googleapis.com"
MODELS = {"argon": "gemini-4-argon", "flash": "gemini-3.8-flash"}

FIGHT_PROMPT = """You are judging footage from our boxing management game: a live round of women's amateur boxing,
two lightweights (red top vs blue top) and a referee, filmed by the game's broadcast camera. On-screen overlays (body
maps, rings, the clock, the shout bar) are UI - ignore them except where they hide the action.
Judge it as a boxing fan AND an animation director would. Give timestamps (mm:ss) for every claim.
1) Does it look like real boxing? Footwork and range, punch selection and variety, defence (blocks, slips, distance),
   clinches, the referee's movement, how hits land and what they do to the receiver.
2) Animation defects: snapping or popping between moves, foot sliding or skating, feet floating or sinking, gloves or
   arms passing through heads or bodies, punches that react without contact (or contact without a reaction), the same
   move repeated robotically, frozen or puppet-like stretches, wrong speed (too fast/slow for real boxers).
3) Camera: framing, cuts, anything blocking the view.
4) The 5 worst moments and the 3 best, each with a timestamp and one line.
5) Verdict: one line, and a score 1-10 for "watchable as a sports broadcast".
Be specific; do not guess - if the camera hides something, say so."""

CLIP_PROMPT = """You are a strict animation supervisor for a boxing game. The video is ONE motion-capture clip on our boxer,
shown on a turntable (the camera circles once; the boxer stays in place). Judge the MOTION only.
{intent}
Report: 1) does it read as the intended move to a boxing fan; 2) defects with timestamps - snapping/popping, foot
sliding, float/sink, glove through head/body, joints bent wrong or hyperextended, jitter, wrong speed, weight transfer
(punch driven from feet and hips; rear hand at the chin), balance - write 'none seen' when a check passes;
3) verdict SHIP / FIX / CUT with a one-line reason. Do not guess; say when the turntable hides something."""


def api_key() -> str:
    key = os.environ.get("GEMINI_API_KEY", "").strip()
    if not key and sys.platform == "win32":
        try:
            import winreg
            with winreg.OpenKey(winreg.HKEY_CURRENT_USER, "Environment") as k:
                key = str(winreg.QueryValueEx(k, "GEMINI_API_KEY")[0]).strip()
        except OSError:
            key = ""
    if not key:
        raise SystemExit('GEMINI_API_KEY is not set. The operator runs, in his own terminal: setx GEMINI_API_KEY "<key>"')
    return key


def _fail(r: requests.Response, step: str) -> None:
    try:
        why = r.json().get("error", {}).get("message", r.text[:300])
    except ValueError:
        why = r.text[:300]
    raise SystemExit(f"GEMINI {step} failed: HTTP {r.status_code}: {why}")


def upload(path: Path, key: str) -> dict:
    size = path.stat().st_size
    start = requests.post(f"{API}/upload/v1beta/files", timeout=60, headers={
        "x-goog-api-key": key, "X-Goog-Upload-Protocol": "resumable", "X-Goog-Upload-Command": "start",
        "X-Goog-Upload-Header-Content-Length": str(size), "X-Goog-Upload-Header-Content-Type": "video/mp4",
        "Content-Type": "application/json"}, json={"file": {"display_name": path.name}})
    if not start.ok:
        _fail(start, "upload start")
    url = start.headers.get("x-goog-upload-url")
    if not url:
        raise SystemExit("GEMINI upload start returned no upload URL")
    done = requests.post(url, timeout=600, data=path.read_bytes(), headers={
        "Content-Length": str(size), "X-Goog-Upload-Offset": "0", "X-Goog-Upload-Command": "upload, finalize"})
    if not done.ok:
        _fail(done, "upload")
    f = done.json()["file"]
    for _ in range(90):  # video is processed before it can be used
        if f.get("state") == "ACTIVE":
            return f
        if f.get("state") == "FAILED":
            raise SystemExit(f"GEMINI could not process {path.name}: {f.get('error')}")
        time.sleep(2)
        g = requests.get(f"{API}/v1beta/{f['name']}", headers={"x-goog-api-key": key}, timeout=60)
        if not g.ok:
            _fail(g, "file status")
        f = g.json()
    raise SystemExit("GEMINI file still processing after 3 minutes")


def judge(path: Path, model: str, fps: int, prompt: str, key: str) -> tuple[str, dict]:
    f = upload(path, key)
    body = {"contents": [{"role": "user", "parts": [
        {"fileData": {"mimeType": "video/mp4", "fileUri": f["uri"]}, "videoMetadata": {"fps": fps}},
        {"text": prompt}]}]}
    try:
        r = requests.post(f"{API}/v1beta/models/{MODELS[model]}:generateContent", json=body, timeout=900,
                          headers={"x-goog-api-key": key})
        if not r.ok:
            _fail(r, "generateContent")
        data = r.json()
    finally:
        requests.delete(f"{API}/v1beta/{f['name']}", headers={"x-goog-api-key": key}, timeout=60)
    parts = (data.get("candidates") or [{}])[0].get("content", {}).get("parts", [])
    text = "\n".join(p.get("text", "") for p in parts if not p.get("thought")).strip()
    return text, data.get("usageMetadata", {})


def main(argv: list[str]) -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("clip")
    ap.add_argument("--model", choices=sorted(MODELS), default="argon")
    ap.add_argument("--fps", type=int, default=24)
    ap.add_argument("--kind", choices=["fight", "clip"], default="fight")
    ap.add_argument("--intent", default="")
    ap.add_argument("--prompt-file")
    ap.add_argument("--what", default="")
    args = ap.parse_args(argv)
    clip = Path(args.clip)
    if not clip.is_file():
        raise SystemExit(f"no such clip: {clip}")
    if args.prompt_file:
        prompt = Path(args.prompt_file).read_text(encoding="utf-8")
    elif args.kind == "fight":
        prompt = FIGHT_PROMPT + (f"\nContext: {args.intent}" if args.intent else "")
    else:
        prompt = CLIP_PROMPT.format(intent=f"Intended move: {args.intent}" if args.intent else "")
    key = api_key()
    t0 = time.time()
    text, usage = judge(clip, args.model, args.fps, prompt, key)
    tin = int(usage.get("promptTokenCount", 0))
    tout = int(usage.get("candidatesTokenCount", 0)) + int(usage.get("thoughtsTokenCount", 0))
    row = gemini_meter.add(args.model, tin, tout, args.what or f"{args.kind}: {clip.name} at {args.fps} fps")
    out = clip.with_suffix(f".gemini_{args.model}.md")
    out.write_text(f"# Gemini ({MODELS[args.model]}) on {clip.name} at {args.fps} fps\n\n"
                   f"Tokens in {tin:,}, out {tout:,} (thinking included), ${row['usd']:.4f}, {time.time() - t0:.0f} s.\n\n"
                   f"{text}\n", encoding="utf-8")
    print(f"GEMINI_JUDGE {MODELS[args.model]} in={tin} out={tout} usd={row['usd']:.4f} -> {out}")
    print(text)
    return 0


if __name__ == "__main__":
    sys.exit(main(sys.argv[1:]))
