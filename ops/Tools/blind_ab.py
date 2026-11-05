"""blind_ab.py - a blind A/B judge: our clip beside a shipped boxing game's clip, sides drawn at random (S386).

Operator S386: "have a separate sub-agent check it visually ... a really harsh critic ... compare them side by side blind
and say which one looks better. use my own free agents". The reference is a shipped AAA boxing game's footage (kept in
E:/FightCamp/tmp, never in the repo, never shipped). Neither clip is named; the judge sees "LEFT = A, RIGHT = B" only.
The key (which side is ours) is written apart from what the judge gets, then the answers are de-blinded.

    python ops/Tools/blind_ab.py --ours <clip.mp4> --ref <ref.mp4> [--what LABEL] [--judges gemini,ollama]
                                 [--seconds 6] [--ref-from 0] [--out DIR]

PASS only when EVERY judge that answered picks ours (operator: "dont stop until each sub-agent is utterly wowed").
Writes <out>/ab.mp4, ab.key.json, ab.<judge>.md and ab.verdict.json; prints AB_VERDICT <json>.
"""
from __future__ import annotations

import argparse
import base64
import json
import re
import secrets
import subprocess
import sys
import os
import urllib.request
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))

PROMPT = """You are a HARSH animation director at a AAA studio reviewing two short clips of 3D boxing games, side by side.
LEFT half = A, RIGHT half = B. They are two different games; you are not told which. Judge ONLY the motion and body
quality of the boxers, never the graphics budget (lighting, skin shaders, crowd, resolution, camera, UI): a clip with
plainer rendering can still win on motion. Look at every frame:
- transitions between moves: does a punch blend from the pose before it, or snap from a default pose? Any pop in one frame?
- body integrity: limbs through bodies, an arm through its own torso, heads inside chests, legs crossing through legs,
  feet sliding or floating, knees bending wrong.
- weight and contact: do punches land on something, do hits move the receiver believably, is there follow-through.
- footwork and spacing: real boxing range, steps, pivots.
Be brutal and concrete: give a timestamp (s.ss) for every flaw. Then answer with these three lines exactly at the end:
Winner: A or B
Score A: N/10
Score B: N/10
"""


def run(cmd: list[str]) -> None:
    subprocess.run(cmd, check=True, capture_output=True)


def build(ours: Path, ref: Path, out: Path, seconds: float, ref_from: float, ours_from: float) -> dict:
    ours_left = secrets.randbelow(2) == 0
    a, b = (ours, ref) if ours_left else (ref, ours)
    fa, fb = (ours_from, ref_from) if ours_left else (ref_from, ours_from)
    vf = ("[0:v]trim=start={fa}:duration={d},setpts=PTS-STARTPTS,fps=30,scale=960:540:force_original_aspect_ratio=decrease,"
          "pad=960:540:(ow-iw)/2:(oh-ih)/2[a];[1:v]trim=start={fb}:duration={d},setpts=PTS-STARTPTS,fps=30,"
          "scale=960:540:force_original_aspect_ratio=decrease,pad=960:540:(ow-iw)/2:(oh-ih)/2[b];[a][b]hstack=2[v]"
          ).format(fa=fa, fb=fb, d=seconds)
    ab = out / "ab.mp4"
    run(["ffmpeg", "-y", "-loglevel", "error", "-i", str(a), "-i", str(b), "-filter_complex", vf, "-map", "[v]", "-an",
         "-c:v", "libx264", "-crf", "20", "-pix_fmt", "yuv420p", str(ab)])
    key = {"ours": "A" if ours_left else "B", "ours_clip": str(ours), "ref_clip": str(ref)}
    (out / "ab.key.json").write_text(json.dumps(key, indent=1), encoding="utf-8")
    return key


def parse(text: str) -> dict:
    w = re.search(r"Winner:\s*\**\s*([AB])\b", text)
    sa = re.search(r"Score A:\s*\**\s*([0-9.]+)", text)
    sb = re.search(r"Score B:\s*\**\s*([0-9.]+)", text)
    return {"winner": w.group(1) if w else None, "A": float(sa.group(1)) if sa else None,
            "B": float(sb.group(1)) if sb else None}


def judge_gemini(ab: Path) -> str | None:
    import gemini_judge
    try:
        key = gemini_judge.api_key()
        text, _ = gemini_judge.judge(ab, "argon", 24, PROMPT, key)
        return text
    except (SystemExit, Exception) as e:  # noqa: BLE001 - a judge that cannot answer is skipped, never a pass
        print(f"AB gemini failed: {e}")
        return None


def judge_ollama(ab: Path, out: Path) -> str | None:
    import claude_judge
    import ollama_judge
    if ollama_judge.pc_red():
        print("AB ollama skipped: PC RED")
        return None
    shots = claude_judge.sheets(ab, out / "sheets", 1.5)
    if not shots:
        return None
    body = {"model": ollama_judge.MODEL, "stream": False, "think": False, "keep_alive": 0,
            "options": {"num_ctx": 32768, "temperature": 0.2},
            "messages": [{"role": "user", "content": PROMPT + "\nThe clip is given as contact sheets in time order: "
                          + ", ".join(s.name for s in shots) + ". Each frame shows A on the left half, B on the right half.",
                          "images": [base64.b64encode(s.read_bytes()).decode() for s in shots]}]}
    try:
        url = os.environ.get("AB_OLLAMA_URL", ollama_judge.URL)   # S386: the app's server lost E:/ollama/models; a 2nd on :11435
        req = urllib.request.Request(url, json.dumps(body).encode(), {"Content-Type": "application/json"})
        return str(json.loads(urllib.request.urlopen(req, timeout=1800).read())["message"]["content"]).strip()
    except (OSError, ValueError, KeyError) as e:
        print(f"AB ollama failed: {e}")
        return None


def main(argv: list[str]) -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("--ours", required=True)
    ap.add_argument("--ref", required=True)
    ap.add_argument("--what", default="")
    ap.add_argument("--judges", default="gemini,ollama")
    ap.add_argument("--seconds", type=float, default=6.0)
    ap.add_argument("--ref-from", type=float, default=0.0)
    ap.add_argument("--ours-from", type=float, default=0.0)
    ap.add_argument("--out", default="")
    a = ap.parse_args(argv)
    ours, ref = Path(a.ours), Path(a.ref)
    out = Path(a.out) if a.out else ours.with_suffix("").parent / (ours.stem + "_ab")
    out.mkdir(parents=True, exist_ok=True)
    key = build(ours, ref, out, a.seconds, a.ref_from, a.ours_from)
    res = {"what": a.what or ours.name, "judges": {}}
    for j in [s.strip() for s in a.judges.split(",") if s.strip()]:
        text = judge_gemini(out / "ab.mp4") if j == "gemini" else judge_ollama(out / "ab.mp4", out) if j == "ollama" else None
        if not text:
            continue
        (out / f"ab.{j}.md").write_text(text + "\n", encoding="utf-8")
        p = parse(text)
        theirs = "B" if key["ours"] == "A" else "A"
        res["judges"][j] = {"picked_ours": p["winner"] == key["ours"], "ours_score": p[key["ours"]], "ref_score": p[theirs]}
    got = res["judges"]
    res["pass"] = bool(got) and all(v["picked_ours"] for v in got.values())
    (out / "ab.verdict.json").write_text(json.dumps(res, indent=1), encoding="utf-8")
    print("AB_VERDICT " + json.dumps(res))
    return 0 if got else 1


if __name__ == "__main__":
    sys.exit(main(sys.argv[1:]))
