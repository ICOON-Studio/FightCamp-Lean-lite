"""card_crop.py - where the blue boxer stands in each of his frame runs, for the hand's picture cards (S569).

Owner S569: "remove the buttons and replace with the decribed action with a single fighter , do not draw both of them ,
it has to be like a card and make them smaller so all can fit"; "make the cards loop their animaitons while thei are on the
panel". Until runs of blue alone exist (masks or one-man renders), a card shows the run cropped tight on blue: this writes
img/anim/card_crop.json {run: [x, y]} - the centre of blue's shorts in the FIRST frame, in frame pixels, unmirrored.
    python proto/twohands/tools/card_crop.py
"""
import json
from pathlib import Path
from PIL import Image

D = Path(__file__).resolve().parent.parent / "img" / "anim"
runs = json.loads((D / "frames.json").read_text(encoding="utf-8"))["runs"]
out = {}
for name, v in sorted(runs.items()):
    if not name.startswith("blue_") or not v.get("files"):
        continue
    p = D / v["files"][0]
    if not p.exists():
        continue
    im = Image.open(p).convert("RGBA"); w, h = im.size; px = im.load(); sx = sy = n = 0
    for y in range(0, h, 2):
        for x in range(0, w, 2):
            r, g, b, a = px[x, y]
            if a > 200 and b > 140 and b > r + 60 and b > g + 30:
                sx += x; sy += y; n += 1
    if n > 20:
        out[name] = [round(sx / n), round(sy / n), w]
(D / "card_crop.json").write_text(json.dumps(out, separators=(",", ":")), encoding="utf-8")
print("CARD_CROP", len(out), "runs")
