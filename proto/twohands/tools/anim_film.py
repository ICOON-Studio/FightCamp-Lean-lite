"""anim_film.py - RINGANIM1 (S552): the before / after film of the Ring Switches stage for the owner's eye.

    python proto/twohands/tools/anim_film.py <out.mp4> <run> [<run> ...] [--speed 0.25]

BEFORE (left): what the page showed until S552 - the guard for 0.22 s, then the action's one still for 0.9 s.
AFTER (right): the run's frames at their recorded times, the contact held 0.25 s (the page's own timings, switch.html).
Each beat is played one after the other; --speed 0.25 plays it at quarter speed. Reads the web pictures the page uses
(proto/twohands/img, img/anim/frames.json), mirrored as the page mirrors them (the player is blue, on the left).
"""
from __future__ import annotations

import json
import subprocess
import sys
import tempfile
from pathlib import Path

from PIL import Image, ImageDraw, ImageFont, ImageOps

HERE = Path(__file__).resolve().parent
IMG = HERE.parent / "img"
FPS = 30
W = 560
HOLD = 0.25


def font(px: int):
    try:
        return ImageFont.truetype("segoeuib.ttf", px)
    except OSError:
        return ImageFont.load_default()


def stage(pic: Image.Image, label: str) -> Image.Image:
    """The page's stage: the dark wall, the blue canvas, two ropes, the picture mirrored and a little larger than the box."""
    h = int(W * 0.62)
    im = Image.new("RGB", (W, h), (28, 34, 48))
    d = ImageDraw.Draw(im)
    d.rectangle([0, int(h * 0.56), W, h], fill=(62, 94, 148))
    d.rectangle([0, int(h * 0.30), W, int(h * 0.30) + 3], fill=(201, 56, 47))
    d.rectangle([0, int(h * 0.43), W, int(h * 0.43) + 3], fill=(232, 225, 214))
    side = int(h * 1.26)
    p = ImageOps.mirror(pic.convert("RGBA")).resize((side, side), Image.LANCZOS)
    im.paste(p, ((W - side) // 2, int(-0.17 * h)), p)
    d.text((10, 8), label, fill=(227, 171, 69), font=font(20))
    return im


def before(run: str) -> list[tuple[Image.Image, float]]:
    still = run.replace("overhand", "rear_hook")
    p = IMG / (still + ".webp")
    if not p.exists():   # an action that had no picture at all: the guard stayed up
        return [(Image.open(IMG / "guard.webp"), 1.12)]
    return [(Image.open(IMG / "guard.webp"), 0.22), (Image.open(p), 0.90)]


def after(run: str, table: dict) -> list[tuple[Image.Image, float]]:
    r = table[run]
    out = []
    for i, f in enumerate(r["files"]):
        wait = (r["offs"][i + 1] - r["offs"][i]) if i + 1 < len(r["files"]) else 0.20
        if i == r.get("contact", -1):
            wait += HOLD
        out.append((Image.open(IMG / "anim" / f), wait))
    return out


def at(seq: list[tuple[Image.Image, float]], t: float) -> Image.Image:
    for im, wait in seq:
        if t < wait:
            return im
        t -= wait
    return seq[-1][0]


def main(argv: list[str]) -> int:
    speed = 1.0
    if "--speed" in argv:
        i = argv.index("--speed")
        speed = float(argv[i + 1])
        del argv[i:i + 2]
    out, runs = Path(argv[0]), argv[1:]
    table = json.loads((IMG / "anim" / "frames.json").read_text(encoding="utf-8"))["runs"]
    with tempfile.TemporaryDirectory() as tmp:
        n = 0
        for run in runs:
            b, a = before(run), after(run, table)
            dur = max(sum(w for _, w in b), sum(w for _, w in a)) + 0.35
            for k in range(int(dur / speed * FPS)):
                t = k / FPS * speed
                left = stage(at(b, t), "BEFORE: one still")
                right = stage(at(a, t), "AFTER: frame by frame")
                sheet = Image.new("RGB", (W * 2 + 12, left.height + 40), (21, 18, 17))
                sheet.paste(left, (0, 0))
                sheet.paste(right, (W + 12, 0))
                ImageDraw.Draw(sheet).text((10, left.height + 8), run.replace("_", " ") + ("" if speed == 1.0 else "   (%.2fx speed)" % speed), fill=(242, 233, 221), font=font(20))
                sheet.save(Path(tmp) / ("f%05d.png" % n))
                n += 1
        out.parent.mkdir(parents=True, exist_ok=True)
        subprocess.run(["ffmpeg", "-y", "-loglevel", "error", "-framerate", str(FPS), "-i", str(Path(tmp) / "f%05d.png"),
                        "-vf", "pad=ceil(iw/2)*2:ceil(ih/2)*2", "-pix_fmt", "yuv420p", "-c:v", "libx264", "-crf", "20", str(out)], check=True)
    print("ANIM_FILM %s frames=%d runs=%d speed=%s" % (out, n, len(runs), speed))
    return 0


if __name__ == "__main__":
    sys.exit(main(sys.argv[1:]))
