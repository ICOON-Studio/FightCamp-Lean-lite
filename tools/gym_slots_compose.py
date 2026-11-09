# Test of the slot method: base (his picture, main hall emptied) + pieces revealed from his own pixels.
import cv2
import numpy as np

OUT = "E:/FightCamp/tmp/s415_slots/"
main = cv2.imread("E:/FightCamp/Lean/assets/ui/art/gym_main.jpg").astype(np.float32)
base = cv2.imread(OUT + "base_display.png").astype(np.float32)
m = cv2.imread(OUT + "diff.png", 0)

SLOTS = {
    "ring": (995, 150, 300, 280),
    "cage": (606, 142, 372, 288),
    "mat_blue": (1270, 160, 300, 226),
    "bag_floor": (588, 425, 560, 310),
    "bag_back_1": (1000, 22, 44, 116), "bag_back_2": (1052, 22, 46, 116), "bag_back_3": (1114, 22, 42, 116),
    "bag_back_4": (1170, 22, 46, 116), "bag_back_5": (1224, 18, 60, 118),
    "gloves": (728, 44, 168, 86),
    "tread_1": (1206, 644, 62, 94), "tread_2": (1270, 662, 62, 76), "tread_3": (1333, 662, 62, 76), "tread_4": (1396, 662, 62, 76),
    "bike_1": (1470, 652, 48, 86), "bike_2": (1524, 652, 48, 86), "bike_3": (1578, 652, 50, 86),
    "racks_mid": (1140, 396, 380, 250),
}


def alpha_of(rect):
    x, y, w, h = rect
    mask = np.zeros(m.shape, np.uint8)
    mask[y:y + h, x:x + w] = m[y:y + h, x:x + w]
    contours, _ = cv2.findContours(mask, cv2.RETR_EXTERNAL, cv2.CHAIN_APPROX_SIMPLE)
    big = [c for c in contours if cv2.contourArea(c) > 60]
    filled = np.zeros(m.shape, np.uint8)
    cv2.drawContours(filled, big, -1, 255, -1)
    filled = cv2.dilate(filled, np.ones((5, 5), np.uint8))
    return (cv2.GaussianBlur(filled.astype(np.float32) / 255.0, (0, 0), 1.2))[..., None]


def compose(ids, name):
    out = base.copy()
    for i in ids:
        a = alpha_of(SLOTS[i])
        out = out * (1 - a) + main * a
    cv2.imwrite(OUT + name, out.round().clip(0, 255).astype(np.uint8), [cv2.IMWRITE_JPEG_QUALITY, 92])


compose([], "s0_empty.jpg")
start = ["ring", "bag_floor", "gloves", "tread_1", "tread_2"]
compose(start, "s1_start.jpg")
middle = start + ["bag_back_1", "bag_back_2", "bag_back_3", "bag_back_4", "bag_back_5", "mat_blue", "tread_3", "tread_4", "racks_mid"]
compose(middle, "s2_middle.jpg")
compose(list(SLOTS.keys()), "s3_all.jpg")
print("ok", len(SLOTS))
