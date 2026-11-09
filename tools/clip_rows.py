"""Clip row maker: 8 evenly spaced frames from a clip folder in one row, 2400 px wide.

Usage: python tools/clip_rows.py <clip_folder> <clip_name>
Output: E:/FightCamp/tmp/s412_clips/rows/<6 random letters>.jpg
Appends mapping to E:/FightCamp/tmp/s412_clips/KEY.txt
"""
import sys
import os
import random
import string
from PIL import Image

ROWS_DIR = "E:/FightCamp/tmp/s412_clips/rows"
KEY_FILE = "E:/FightCamp/tmp/s412_clips/KEY.txt"
ROW_WIDTH = 2400
NUM_FRAMES = 8


def make_row(clip_folder: str, clip_name: str) -> dict:
    """Make a row of 8 frames from clip_folder. Returns status dict."""
    result = {
        "clip": clip_name,
        "found": os.path.isdir(clip_folder),
        "frames_filmed": 0,
        "row_made": False,
        "failure_reason": "",
    }
    if not result["found"]:
        result["failure_reason"] = "folder not found"
        return result

    frames = sorted([f for f in os.listdir(clip_folder) if f.endswith(".jpg")])
    result["frames_filmed"] = len(frames)

    if len(frames) < 8:
        result["failure_reason"] = "under 8 frames"
        _write_failure_row(result)
        return result

    indices = [int(i * (len(frames) - 1) / (NUM_FRAMES - 1)) for i in range(NUM_FRAMES)]
    imgs = [Image.open(os.path.join(clip_folder, frames[i])) for i in indices]

    cell_w = ROW_WIDTH // NUM_FRAMES
    cell_h = int(imgs[0].height * cell_w / imgs[0].width)
    row = Image.new("RGB", (ROW_WIDTH, cell_h), (158, 163, 171))
    for i, img in enumerate(imgs):
        img_resized = img.resize((cell_w, cell_h), Image.LANCZOS)
        row.paste(img_resized, (i * cell_w, 0))

    os.makedirs(ROWS_DIR, exist_ok=True)
    rand_name = "".join(random.choices(string.ascii_lowercase, k=6))
    out_path = os.path.join(ROWS_DIR, f"{rand_name}.jpg")
    row.save(out_path, quality=90)

    with open(KEY_FILE, "a") as f:
        f.write(f"{rand_name}.jpg -> {clip_name}\n")

    result["row_made"] = True
    return result


def _write_failure_row(result: dict):
    """Write a failure marker to KEY for clips that could not make a row."""
    os.makedirs(ROWS_DIR, exist_ok=True)
    with open(KEY_FILE, "a") as f:
        f.write(f"FAILURE -> {result['clip']} ({result['failure_reason']})\n")


if __name__ == "__main__":
    if len(sys.argv) != 3:
        print("Usage: python tools/clip_rows.py <clip_folder> <clip_name>")
        sys.exit(1)
    clip_folder = sys.argv[1]
    clip_name = sys.argv[2]
    r = make_row(clip_folder, clip_name)
    print(f"clip={r['clip']} found={r['found']} frames={r['frames_filmed']} row_made={r['row_made']}")
    if r["failure_reason"]:
        print(f"  reason: {r['failure_reason']}")
