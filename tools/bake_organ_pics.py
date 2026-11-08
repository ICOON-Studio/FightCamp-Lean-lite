# bake_organ_pics.py - draws the fight HUD's organ close-ups (BodyCallouts) in the muscle holo's look (S381).
#
# WHY (operator on the LIVER close-up, S381: "add liver picture on the circle ?"): the LIVER card showed a zoomed crop of the
# blue ecorche holo, which reads as nothing at 60 px. Every ORGAN card now shows the organ itself, drawn here from our own
# outline (no picture from anywhere else): glowing cyan edges on the holo's dark plate, a darker see-through inside, a few
# fibre lines, the same light from the upper left as the holo.
#
#   python tools/bake_organ_pics.py            -> assets/ui/body/organ_liver.png, organ_ribs.png, organ_brain.png (128 x 128, opaque)
#
# The liver, front view as the body faces the viewer: the big right lobe on the VIEWER'S LEFT (her right side, under her
# right ribs), the dome of its top under the diaphragm, the thin left lobe tapering to a point on the viewer's right, the
# falciform line between the lobes running down to the notch on the lower edge, the gallbladder's fundus peeking out under
# the right lobe's lower edge. It fills about 0.82 of the circle so the ring never cuts it.
import math
import os

import numpy as np
from PIL import Image, ImageDraw, ImageFilter

OUT_DIR = "assets/ui/body"
S = 512                      # drawn at 4x, saved at 128
OUT = 128
PLATE = (9, 15, 23)          # BodyHolo.PLATE, the holo's scanner plate
PLATE_HI = (16, 30, 44)
EDGE = (175, 238, 255)       # the holo's lit rim
BODY_HI = (90, 205, 245)     # its lit muscle
BODY_LO = (26, 108, 168)      # its shade
GALL = (70, 215, 195)        # the gallbladder: a teal, so it reads as its own sac

# Our liver outline on a 256 grid (x right = viewer's right, y down), clockwise from the right lobe's outer edge.
LIVER = [
    (18, 122), (24, 94), (40, 74), (64, 60), (96, 53), (126, 56), (148, 63), (160, 70),   # the dome over the right lobe
    (174, 69), (198, 74), (220, 85), (236, 97), (246, 108),                              # the left lobe's top to its tip
    (230, 116), (208, 123), (186, 130), (170, 135),                                      # its lower edge
    (164, 146), (155, 140),                                                              # the notch (ligamentum teres)
    (138, 150), (120, 162), (100, 176), (80, 188), (56, 196), (36, 190), (22, 170),      # the right lobe's lower edge
]
FALCIFORM = [(160, 70), (161, 96), (162, 120), (160, 142)]
GALLBLADDER = (110, 176, 11, 19, -28)   # centre x, y, half width, half length, tilt (deg) - its fundus below the edge
# Fibre lines (the ecorche's striations): sweeps across each lobe, following its shape.
FIBRES = [
    [(34, 110), (60, 90), (96, 78), (140, 76)],
    [(30, 140), (58, 118), (96, 104), (146, 98)],
    [(40, 170), (70, 148), (108, 132), (150, 122)],
    [(176, 86), (204, 92), (230, 102)],
    [(174, 106), (200, 110), (224, 112)],
]


def catmull(pts, closed, steps=14):
    """A smooth curve through the points (Catmull-Rom)."""
    out = []
    n = len(pts)
    rng = range(n) if closed else range(n - 1)
    for i in rng:
        p0 = pts[(i - 1) % n] if closed or i > 0 else pts[i]
        p1, p2 = pts[i], pts[(i + 1) % n]
        p3 = pts[(i + 2) % n] if closed or i + 2 < n else pts[(i + 1) % n]
        for s in range(steps):
            t = s / steps
            t2, t3 = t * t, t * t * t
            out.append(tuple(0.5 * ((2 * p1[k]) + (-p0[k] + p2[k]) * t + (2 * p0[k] - 5 * p1[k] + 4 * p2[k] - p3[k]) * t2
                                    + (-p0[k] + 3 * p1[k] - 3 * p2[k] + p3[k]) * t3) for k in (0, 1)))
    if not closed:
        out.append(pts[-1])
    return out


def fit(pts, base=None):
    """The 256 grid to the 512 canvas: the organ's box centred, scaled to 0.82 of the circle's width."""
    base = base or LIVER
    xs = [p[0] for p in base]
    ys = [p[1] for p in base]
    cx, cy = (min(xs) + max(xs)) / 2.0, (min(ys) + max(ys)) / 2.0
    k = 0.82 * S / (max(xs) - min(xs))
    return [(S / 2 + (x - cx) * k, S / 2 + 6 + (y - cy) * k) for x, y in pts], k


def mask_of(poly):
    m = Image.new("L", (S, S), 0)
    ImageDraw.Draw(m).polygon(poly, fill=255)
    return np.asarray(m, dtype=np.float32) / 255.0


def ellipse_poly(cx, cy, rx, ry, deg, n=48):
    a = math.radians(deg)
    return [(cx + rx * math.cos(t) * math.cos(a) - ry * math.sin(t) * math.sin(a),
             cy + rx * math.cos(t) * math.sin(a) + ry * math.sin(t) * math.cos(a))
            for t in (2 * math.pi * i / n for i in range(n))]


def blur(a, r):
    im = Image.fromarray(np.clip(a * 255.0, 0, 255).astype(np.uint8))
    return np.asarray(im.filter(ImageFilter.GaussianBlur(r)), dtype=np.float32) / 255.0


def stroke(lines, width, closed=False):
    m = Image.new("L", (S, S), 0)
    d = ImageDraw.Draw(m)
    for ln in lines:
        pts = ln + [ln[0]] if closed else ln
        d.line(pts, fill=255, width=width, joint="curve")
    return np.asarray(m, dtype=np.float32) / 255.0


def organ(rgb, m, light_from):
    """A holo organ's body: lit from the upper left, darker and see-through inside, bright towards its rim."""
    yy, xx = np.mgrid[0:S, 0:S].astype(np.float32) / S
    lit = np.clip(1.0 - (xx - light_from[0]) * 0.9 - (yy - light_from[1]) * 1.1, 0.0, 1.0)[..., None]
    col = np.asarray(BODY_LO, np.float32) * (1 - lit) + np.asarray(BODY_HI, np.float32) * lit
    inner = blur(m, 22)
    rim = np.clip((m - inner) * 2.6, 0.0, 1.0)[..., None]
    body = col * (0.68 + 0.32 * rim) + np.asarray(EDGE, np.float32) * rim * 0.35
    a = (m * (0.80 + 0.20 * rim[..., 0]))[..., None]
    return rgb * (1 - a) + body * a


def add(rgb, glow, col, k):
    return rgb + glow[..., None] * np.asarray(col, np.float32) * k


def bake_liver():
    yy, xx = np.mgrid[0:S, 0:S].astype(np.float32)
    r = np.hypot(xx - S / 2, yy - S / 2) / (S / 2)
    rgb = np.asarray(PLATE, np.float32) + (np.asarray(PLATE_HI, np.float32) - np.asarray(PLATE, np.float32)) * np.clip(1 - r, 0, 1)[..., None]
    rgb = rgb * (1.0 - 0.10 * ((yy.astype(int) // 6) % 2 == 0))[..., None]   # the scanner's faint lines
    outline, k = fit(catmull(LIVER, True))
    gx, gy, gw, gl, gt = GALLBLADDER
    gall, _ = fit(ellipse_poly(gx, gy, gw, gl, gt))
    gm = mask_of(gall)
    # The gallbladder first, under the liver: its fundus shows below the lower edge.
    rgb = rgb * (1 - gm[..., None] * 0.8) + np.asarray(GALL, np.float32) * 0.55 * gm[..., None] * 0.8
    rgb = add(rgb, stroke([gall], 5, True), GALL, 0.9)
    lm = mask_of(outline)
    rgb = organ(rgb, lm, (0.15, 0.20))
    fib = stroke([fit(catmull(f, False))[0] for f in FIBRES], 3) * lm
    rgb = add(rgb, blur(fib, 1.2), EDGE, 0.30)
    falc = stroke([fit(catmull(FALCIFORM, False))[0]], 6) * lm
    rgb = add(rgb, falc, EDGE, 0.55)
    edge = stroke([outline], 10, True)
    rgb = add(rgb, blur(edge, 14), BODY_HI, 0.9)    # the glow outside
    rgb = add(rgb, blur(edge, 2), EDGE, 0.85)       # the lit rim
    img = Image.fromarray(np.clip(rgb, 0, 255).astype(np.uint8), "RGB").resize((OUT, OUT), Image.LANCZOS)
    path = os.path.join(OUT_DIR, "organ_liver.png")
    img.save(path)
    print("ORGAN_PICS wrote", path, img.size)


def plate():
    yy, xx = np.mgrid[0:S, 0:S].astype(np.float32)
    r = np.hypot(xx - S / 2, yy - S / 2) / (S / 2)
    rgb = np.asarray(PLATE, np.float32) + (np.asarray(PLATE_HI, np.float32) - np.asarray(PLATE, np.float32)) * np.clip(1 - r, 0, 1)[..., None]
    return rgb * (1.0 - 0.10 * ((yy.astype(int) // 6) % 2 == 0))[..., None]


def save(rgb, name):
    img = Image.fromarray(np.clip(rgb, 0, 255).astype(np.uint8), "RGB").resize((OUT, OUT), Image.LANCZOS)
    path = os.path.join(OUT_DIR, name)
    img.save(path)
    print("ORGAN_PICS wrote", path, img.size)


# S405 the rib cage, front view, on the same 256 grid: the sternum down the middle, six ribs a side curving out and down.
RIB_BOX = [(30, 30), (226, 226)]


def bake_ribs():
    rgb = plate()
    lines = [fit(catmull([(128, 42), (128, 90), (128, 142), (128, 172)], False), RIB_BOX)[0]]
    for i in range(6):
        y = 50 + i * 21
        out = 36 + i * 3
        for sign in (-1, 1):
            pts = [(128 + sign * 10, y), (128 + sign * 46, y - 8 + i), (128 + sign * (92 - i * 2), y + 10 + i), (128 + sign * (100 - out + 28), y + 40 + i * 2)]
            lines.append(fit(catmull(pts, False), RIB_BOX)[0])
    m = blur(stroke(lines, 22), 1.5)
    rgb = organ(rgb, m, (0.15, 0.20))
    edge = stroke(lines, 26) - stroke(lines, 18)
    rgb = add(rgb, blur(np.clip(edge, 0, 1), 10), BODY_HI, 0.8)
    rgb = add(rgb, blur(np.clip(edge, 0, 1), 1.5), EDGE, 0.75)
    save(rgb, "organ_ribs.png")


# S405 the brain, seen from the side: the cerebrum, the cerebellum behind it, the brain stem, and the folds.
BRAIN = [(40, 130), (42, 92), (66, 62), (104, 44), (148, 44), (190, 58), (216, 90), (222, 124), (206, 150), (176, 160), (150, 168), (120, 172), (88, 172), (58, 160)]
BRAIN_FOLDS = [
    [(62, 100), (86, 84), (104, 96), (128, 76), (150, 90), (176, 78), (198, 100)],
    [(58, 134), (84, 118), (106, 132), (132, 112), (156, 128), (182, 112), (206, 130)],
    [(84, 158), (108, 148), (130, 156), (152, 146), (172, 152)],
    [(120, 50), (112, 72), (124, 104), (116, 136), (126, 168)],
]
BRAIN_BOX = BRAIN + [(150, 236), (208, 198)]


def bake_brain():
    rgb = plate()
    stem = fit(catmull([(152, 166), (150, 192), (140, 234)], False), BRAIN_BOX)[0]
    cere = fit(ellipse_poly(178, 178, 32, 20, 8), BRAIN_BOX)[0]
    sm = blur(stroke([stem], 34), 1.5)
    rgb = organ(rgb, sm, (0.15, 0.20))
    cm = mask_of(cere)
    rgb = organ(rgb, cm, (0.15, 0.20))
    rgb = add(rgb, blur(stroke([cere], 6, True), 2), EDGE, 0.7)
    outline = fit(catmull(BRAIN, True), BRAIN_BOX)[0]
    lm = mask_of(outline)
    rgb = organ(rgb, lm, (0.15, 0.20))
    folds = stroke([fit(catmull(f, False), BRAIN_BOX)[0] for f in BRAIN_FOLDS], 5) * lm
    rgb = add(rgb, blur(folds, 1.2), EDGE, 0.55)
    edge = stroke([outline], 10, True)
    rgb = add(rgb, blur(edge, 14), BODY_HI, 0.9)
    rgb = add(rgb, blur(edge, 2), EDGE, 0.85)
    save(rgb, "organ_brain.png")


if __name__ == "__main__":
    bake_liver()
    bake_ribs()
    bake_brain()
