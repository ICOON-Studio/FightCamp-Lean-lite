"""poster_faces.py - the fight poster's heads (S387, operator on the halftone: "looks bad").

Each slate promo shot (assets/ui/face/studio) cropped to head and shoulders by the same marks as PromoShot, the flat slate backdrop
keyed out to white, so the halftone prints the fighter alone on clean paper, and the tones stretched so a dark and a pale fighter
both print with contrast. Writes assets/ui/face/poster/<stem>.jpg.

    python tools/poster_faces.py
"""
import json
from pathlib import Path

import numpy as np
from PIL import Image

ROOT = Path(__file__).resolve().parent.parent
SRC = ROOT / "assets/ui/face/studio"
OUT = ROOT / "assets/ui/face/poster"
CROP_H = 0.52       # PromoShot.CROP_H
ABOVE_EYES = 0.23   # PromoShot.ABOVE_EYES
KEY_NEAR, KEY_FAR = 16.0, 44.0   # colour distance from the backdrop: fully paper, fully fighter


def bake(stem: str, marks: dict) -> None:
    im = Image.open(SRC / f"{stem}.jpg").convert("RGB")
    w, h = im.size
    x = min(max(marks["nose"][0] - CROP_H / 2, 0.0), 1.0 - CROP_H)
    y = min(max(marks["eye_l"][1] - ABOVE_EYES, 0.0), 1.0 - CROP_H)
    a = np.asarray(im.crop((int(x * w), int(y * h), int((x + CROP_H) * w), int((y + CROP_H) * h))), dtype=np.float32)
    back = np.asarray(im, dtype=np.float32)[:40, :40].reshape(-1, 3).mean(axis=0)
    keep = np.clip((np.linalg.norm(a - back, axis=2) - KEY_NEAR) / (KEY_FAR - KEY_NEAR), 0.0, 1.0)
    grey = a @ np.array([0.299, 0.587, 0.114], dtype=np.float32)
    body = grey[keep > 0.9]
    lo, hi = np.percentile(body, 2), np.percentile(body, 98)
    tone = np.clip((grey - lo) / max(hi - lo, 1.0), 0.0, 1.0) * 235.0
    out = tone * keep + 255.0 * (1.0 - keep)
    Image.fromarray(out.astype(np.uint8)).convert("RGB").save(OUT / f"{stem}.jpg", quality=92)


def main() -> None:
    OUT.mkdir(parents=True, exist_ok=True)
    marks = json.loads((ROOT / "assets/ui/face/promo_face.json").read_text(encoding="utf-8"))
    for stem, m in sorted(marks.items()):
        bake(stem, m)
    print(f"poster heads: {len(marks)}")


if __name__ == "__main__":
    main()
