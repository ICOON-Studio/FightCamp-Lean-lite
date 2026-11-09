"""Clip sheet maker: 8 evenly spaced moments from a clip folder, split into two 2x2 sheets.

Usage: python tools/clip_sheets.py <clip_folder> <clip_name>
Output: E:/FightCamp/tmp/s413_clips/sheets/<6 random letters>_a.jpg and _b.jpg
Appends mapping to E:/FightCamp/tmp/s413_clips/KEY.txt

The trap: clip_orbit.gd films the clip plus a 0.4s tail (hold after the punch).
With FPS=30 and tail_s=0.4, the tail is 12 frames. We take moments from the first
(total_frames - 12) frames only, so the sheets show the punch, not the hold.
"""
import sys
import os
import random
import string
import shutil
from PIL import Image

FRAMES_DIR = "E:/FightCamp/tmp/s413_clips/frames"
SHEETS_DIR = "E:/FightCamp/tmp/s413_clips/sheets"
KEY_FILE = "E:/FightCamp/tmp/s413_clips/KEY.txt"
SHEET_SIZE = 1500
CELL_SIZE = 750
NUM_MOMENTS = 8
TAIL_FRAMES = 12  # 0.4s * 30fps


def make_sheets(clip_folder: str, clip_name: str) -> dict:
    """Make two 2x2 sheets from clip_folder. Returns status dict."""
    result = {
        "clip": clip_name,
        "found": os.path.isdir(clip_folder),
        "frames_filmed": 0,
        "frames_playing": 0,
        "sheets_made": False,
        "failure_reason": "",
    }
    if not result["found"]:
        result["failure_reason"] = "folder not found"
        return result

    frames = sorted([f for f in os.listdir(clip_folder) if f.endswith(".jpg")])
    result["frames_filmed"] = len(frames)

    if len(frames) < TAIL_FRAMES + 8:
        result["failure_reason"] = "under 8 playing frames"
        return result

    playing_frames = len(frames) - TAIL_FRAMES
    result["frames_playing"] = playing_frames

    indices = [int(i * (playing_frames - 1) / (NUM_MOMENTS - 1)) for i in range(NUM_MOMENTS)]
    imgs = [Image.open(os.path.join(clip_folder, frames[i])) for i in indices]

    crops = [center_crop(img, CELL_SIZE) for img in imgs]

    rand_name = "".join(random.choices(string.ascii_lowercase, k=6))

    sheet_a = make_sheet(crops[:4], rand_name + "_a")
    sheet_b = make_sheet(crops[4:], rand_name + "_b")

    if not check_sheet(sheet_a, crops[:4]) or not check_sheet(sheet_b, crops[4:]):
        result["failure_reason"] = "sheet quality check failed"
        return result

    os.makedirs(SHEETS_DIR, exist_ok=True)
    sheet_a.save(os.path.join(SHEETS_DIR, rand_name + "_a.jpg"), quality=90)
    sheet_b.save(os.path.join(SHEETS_DIR, rand_name + "_b.jpg"), quality=90)

    with open(KEY_FILE, "a", encoding="utf-8") as f:
        f.write(f"{rand_name} -> {clip_name}\n")

    result["sheets_made"] = True
    return result


def center_crop(img: Image.Image, size: int) -> Image.Image:
    """Center-crop img to a square of the given size."""
    w, h = img.size
    scale = max(size / w, size / h)
    new_w, new_h = int(w * scale), int(h * scale)
    img_resized = img.resize((new_w, new_h), Image.LANCZOS)
    left = (new_w - size) // 2
    top = (new_h - size) // 2
    return img_resized.crop((left, top, left + size, top + size))


def make_sheet(crops: list, name: str) -> Image.Image:
    """Make a 2x2 sheet from 4 cropped images."""
    sheet = Image.new("RGB", (SHEET_SIZE, SHEET_SIZE), (158, 163, 171))
    positions = [(0, 0), (CELL_SIZE, 0), (0, CELL_SIZE), (CELL_SIZE, CELL_SIZE)]
    for i, crop in enumerate(crops):
        sheet.paste(crop, positions[i])
    return sheet


def check_sheet(sheet: Image.Image, crops: list) -> bool:
    """Check that the boxer is present and moments differ."""
    import numpy as np

    arr = np.array(sheet)
    if arr.std() < 10:
        return False

    arr1 = np.array(crops[0])
    arr3 = np.array(crops[2])
    diff = np.abs(arr1.astype(int) - arr3.astype(int)).mean()
    if diff < 5:
        return False

    return True


if __name__ == "__main__":
    if len(sys.argv) != 3:
        print("Usage: python tools/clip_sheets.py <clip_folder> <clip_name>")
        sys.exit(1)
    clip_folder = sys.argv[1]
    clip_name = sys.argv[2]
    r = make_sheets(clip_folder, clip_name)
    print(f"clip={r['clip']} found={r['found']} frames_filmed={r['frames_filmed']} frames_playing={r['frames_playing']} sheets_made={r['sheets_made']}")
    if r["failure_reason"]:
        print(f"  reason: {r['failure_reason']}")
