"""gemini_miro.py - Gemini 4 Argon as a design seat on the Miro board (S368, operator: "give acces to argon on miro board to
add ideas and check the design").

Argon has no Miro login; this is its seat. Claude reads a frame with the Miro tools (canvas_read_as_svg -> a file), adds
the frame's pictures (the mockups/stills it shows, local files), and Argon answers as JSON: design checks and ideas, each a
sticky of <= 10 words with a one-line why. Claude posts them in the frame's "Argon" lane beside Claude/Kalli/John and the
operator's YOUR NOTES. The answer is kept in ops/research/ARGON_MIRO_<topic>_S<n>.md; every run is on the Gemini meter.
    python Tools/gemini_miro.py --svg frame.svg --image a.png [--image b.png] --topic BJJMATCH --session 368
                                [--ask "the question for this frame"] [--model argon|flash]
"""
from __future__ import annotations

import argparse
import base64
import json
import sys
import time
from pathlib import Path

import requests

import gemini_meter
from gemini_judge import API, MODELS, _fail, api_key

ROOT = Path(__file__).resolve().parent.parent
MIME = {".png": "image/png", ".jpg": "image/jpeg", ".jpeg": "image/jpeg", ".webp": "image/webp"}

PROMPT = """You are Argon, a design seat on the Miro board of a tiny game studio. The game: FightCamp, a PC management sim
(deep, not mobile) - you run a boxing gym (women's amateur boxing first, the demo) and its no-gi BJJ side (the road to
black belt); you plan the week's training, book fights and watch them in 3D, and decide in the corner. The player WATCHES
the fights and makes the calls; there is no controller fighting.

Attached: one Miro frame as SVG text (its cards, its stickies - the other seats' opinions: Claude, Kalli = game design,
John = real-world numbers - and YOUR NOTES, the operator's own) and the pictures the frame shows.
{ask}
Check the design (is it clear, is it fun, is it true to the real sport, does it fit a management sim, what is missing or
contradictory) and add ideas the frame does not have yet. Do not repeat what a sticky already says. Answer JSON only:
{{"score": <1-10, how ready this design is to build>,
 "check": [{{"note": "<= 10 words", "why": "one sentence", "about": "the card/sticky it is about"}}],
 "ideas": [{{"note": "<= 10 words", "why": "one sentence"}}],
 "biggest_risk": "one sentence"}}
At most 6 checks and 6 ideas; be specific to this frame, not generic game-design advice."""


def ask_argon(svg: str, images: list[Path], ask: str, model: str, key: str) -> tuple[dict, dict]:
    parts: list[dict] = [{"text": PROMPT.format(ask=f"The question for this frame: {ask}" if ask else "")},
                         {"text": "MIRO FRAME (canvas SVG):\n" + svg}]
    for p in images:
        parts.append({"inlineData": {"mimeType": MIME[p.suffix.lower()], "data": base64.b64encode(p.read_bytes()).decode()}})
    body = {"contents": [{"role": "user", "parts": parts}],
            "generationConfig": {"responseMimeType": "application/json"}}
    r = requests.post(f"{API}/v1beta/models/{MODELS[model]}:generateContent", json=body, timeout=600,
                      headers={"x-goog-api-key": key})
    if not r.ok:
        _fail(r, "generateContent")
    data = r.json()
    out = (data.get("candidates") or [{}])[0].get("content", {}).get("parts", [])
    text = "\n".join(p.get("text", "") for p in out if not p.get("thought")).strip()
    try:
        notes = json.loads(text)
    except ValueError:
        raise SystemExit(f"ARGON answered no JSON:\n{text[:1500]}")
    return notes, data.get("usageMetadata", {})


def main(argv: list[str]) -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("--svg", required=True)
    ap.add_argument("--image", action="append", default=[])
    ap.add_argument("--topic", required=True)
    ap.add_argument("--session", required=True)
    ap.add_argument("--ask", default="")
    ap.add_argument("--model", choices=sorted(MODELS), default="argon")
    args = ap.parse_args(argv)
    images = [Path(p) for p in args.image]
    for p in images:
        if not p.is_file() or p.suffix.lower() not in MIME:
            raise SystemExit(f"not a png/jpg/webp file: {p}")
    svg = Path(args.svg).read_text(encoding="utf-8")
    t0 = time.time()
    notes, usage = ask_argon(svg, images, args.ask, args.model, api_key())
    tin = int(usage.get("promptTokenCount", 0))
    tout = int(usage.get("candidatesTokenCount", 0)) + int(usage.get("thoughtsTokenCount", 0))
    row = gemini_meter.add(args.model, tin, tout, f"miro: {args.topic}")
    out = ROOT / "research" / f"ARGON_MIRO_{args.topic}_S{args.session}.md"
    lines = [f"# Argon on the Miro frame '{args.topic}' (S{args.session})", "",
             f"{MODELS[args.model]}; tokens in {tin:,}, out {tout:,}, ${row['usd']:.4f}, {time.time() - t0:.0f} s; "
             f"pictures: {', '.join(p.name for p in images) or 'none'}.", "", f"Score {notes.get('score')}/10. "
             f"Biggest risk: {notes.get('biggest_risk', '')}", "", "## Checks"]
    lines += [f"- **{c.get('note')}** - {c.get('why')} (on: {c.get('about', '')})" for c in notes.get("check", [])]
    lines += ["", "## Ideas"] + [f"- **{i.get('note')}** - {i.get('why')}" for i in notes.get("ideas", [])]
    out.write_text("\n".join(lines) + "\n", encoding="utf-8")
    print(f"GEMINI_MIRO {MODELS[args.model]} in={tin} out={tout} usd={row['usd']:.4f} -> {out}")
    print(json.dumps(notes, indent=1, ensure_ascii=False))
    return 0


if __name__ == "__main__":
    sys.exit(main(sys.argv[1:]))
