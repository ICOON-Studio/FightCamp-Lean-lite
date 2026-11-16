"""Picture strips of detected punches, for checking the analyzer by eye.  (Claude, S495)
One row per punch: five frames (onset, half-way, impact, +0.06 s, +0.12 s) cropped around both boxers, with the two
skeletons (A yellow, B magenta), the punching arm in white, a ring on the glove at impact and the call written above.
Open the JPG with a file viewer tool; nothing here opens a window."""
import cv2
import numpy as np

SK = [(5, 7), (7, 9), (6, 8), (8, 10), (5, 6), (5, 11), (6, 12), (11, 12), (11, 13), (13, 15), (12, 14), (14, 16)]
COL = ((0, 255, 255), (255, 0, 255))
ARM = {"left": ((5, 7), (7, 9)), "right": ((6, 8), (8, 10))}


def draw_people(img, kpt, seen, i, arm=None, who=None):
    for b in (0, 1):
        if not seen[i, b]:
            continue
        k = kpt[i, b]
        for a, c in SK:
            if k[a, 2] > 0.3 and k[c, 2] > 0.3:
                hot = who == b and arm is not None and (a, c) in ARM[arm]
                cv2.line(img, (int(k[a, 0]), int(k[a, 1])), (int(k[c, 0]), int(k[c, 1])), (255, 255, 255) if hot else COL[b], 4 if hot else 2)
        cv2.putText(img, "AB"[b], (int(k[5, 0]), int(k[5, 1]) - 50), 0, 1.2, COL[b], 3)


def event_row(cap, boxers, ev, tile=(384, 288), extra_boxes=None):
    kpt, seen, frames = boxers["kpt"], boxers["seen"], boxers["frame"]
    fps = float(boxers["fps"])
    m = ev["m"]
    idx = [m["onset"], (m["onset"] + m["impact"]) // 2, m["impact"], m["impact"] + int(round(0.06 * fps)), m["impact"] + int(round(0.12 * fps))]
    idx = [min(len(frames) - 1, max(0, i)) for i in idx]
    pts = kpt[idx][seen[idx]][:, :, :2].reshape(-1, 2)
    pts = pts[(pts > 1).all(1)]
    if len(pts) == 0:
        pts = np.array([m["glove"]], np.float32)
    x1, y1, x2, y2 = pts[:, 0].min(), pts[:, 1].min(), pts[:, 0].max(), pts[:, 1].max()
    cx, cy = (x1 + x2) / 2, (y1 + y2) / 2
    half_h = max((y2 - y1) * 0.6, (x2 - x1) * 0.6 * tile[1] / tile[0], 80)
    half_w = half_h * tile[0] / tile[1]
    who = "AB".index(ev["boxer"])
    tiles = []
    for n, i in enumerate(idx):
        cap.set(cv2.CAP_PROP_POS_FRAMES, int(frames[i]))
        ok, img = cap.read()
        if not ok:
            img = np.zeros((1080, 1920, 3), np.uint8)
        draw_people(img, kpt, seen, i, ev["hand"], who)
        if n == 2:
            cv2.circle(img, (int(m["glove"][0]), int(m["glove"][1])), 18, (0, 255, 0), 3)
        for (bx1, by1, bx2, by2) in (extra_boxes or []):
            cv2.rectangle(img, (int(bx1), int(by1)), (int(bx2), int(by2)), (0, 0, 255), 2)
        h, w = img.shape[:2]
        xa, xb, ya, yb = int(max(0, cx - half_w)), int(min(w, cx + half_w)), int(max(0, cy - half_h)), int(min(h, cy + half_h))
        t = cv2.resize(img[ya:yb, xa:xb], tile, interpolation=cv2.INTER_AREA)
        cv2.putText(t, "f%d" % int(frames[i]), (6, tile[1] - 8), 0, 0.5, (255, 255, 255), 1)
        tiles.append(t)
    row = np.hstack(tiles)
    bar = np.zeros((26, row.shape[1], 3), np.uint8)
    text = "%.2fs  %s  %s %s -> %s, %s" % (ev["t"], ev["boxer"], ev["hand"], ev["type"], ev["target"], ev["result"])
    if ev.get("note"):
        text += "   [" + ev["note"] + "]"
    cv2.putText(bar, text, (6, 19), 0, 0.6, (255, 255, 255), 1)
    return np.vstack([bar, row])


def sheet(video, boxers, events, out_jpg, per_sheet=6):
    """Writes out_jpg (and _2, _3 ... when there are more than per_sheet rows). -> list of files."""
    cap = cv2.VideoCapture(video)
    files = []
    for s in range(0, len(events), per_sheet):
        rows = [event_row(cap, boxers, ev) for ev in events[s:s + per_sheet]]
        name = out_jpg if s == 0 else out_jpg.replace(".jpg", "_%d.jpg" % (s // per_sheet + 1))
        cv2.imwrite(name, np.vstack(rows), [cv2.IMWRITE_JPEG_QUALITY, 82])
        files.append(name)
    return files
