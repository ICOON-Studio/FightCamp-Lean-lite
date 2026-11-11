"""HUMANFIGHT1: numbered frame sheets from a film, for critics who cannot watch video. Consecutive frames at 24 a second
(ffmpeg resamples the 30 fps film), each cell stamped with its frame number and film time, COLS x ROWS a sheet.

  python tools/film_sheets.py <film.mp4> <out_dir> <name> <start_s> <seconds> [--fps 24] [--cols 4] [--rows 3] [--cell 640]
      [--crop x:y:w:h]   (crop in film pixels before scaling, e.g. to drop the side panels)

Writes <out_dir>/<name>_01.jpg ... and prints each sheet's frame range. Frame numbers count from 1 at <start_s>, so
"frame 37 of <name>" is start_s + 36 / fps seconds into the film.
"""
import subprocess
import sys
import tempfile
from pathlib import Path

from PIL import Image, ImageDraw, ImageFont


def arg(flag, default):
    return type(default)(sys.argv[sys.argv.index(flag) + 1]) if flag in sys.argv else default


def main():
    film, out_dir, name, start, secs = sys.argv[1], Path(sys.argv[2]), sys.argv[3], float(sys.argv[4]), float(sys.argv[5])
    fps, cols, rows, cell = arg("--fps", 24.0), arg("--cols", 4), arg("--rows", 3), arg("--cell", 640)
    crop = arg("--crop", "")
    out_dir.mkdir(parents=True, exist_ok=True)
    with tempfile.TemporaryDirectory() as tmp:
        vf = ("crop=%s," % crop if crop else "") + "fps=%g,scale=%d:-2" % (fps, cell)
        subprocess.run(["ffmpeg", "-loglevel", "error", "-y", "-ss", "%.3f" % start, "-t", "%.3f" % secs, "-i", film,
                        "-vf", vf, "-q:v", "3", str(Path(tmp) / "f_%04d.jpg")], check=True)
        frames = sorted(Path(tmp).glob("f_*.jpg"))
        try:
            font = ImageFont.truetype("arialbd.ttf", max(16, cell // 26))
        except OSError:
            font = ImageFont.load_default()
        per = cols * rows
        for s in range(0, len(frames), per):
            chunk = frames[s:s + per]
            with Image.open(chunk[0]) as first:
                w, h = first.size
            sheet = Image.new("RGB", (w * cols, h * rows), (0, 0, 0))
            for k, f in enumerate(chunk):
                with Image.open(f) as src:
                    im = src.copy()
                d = ImageDraw.Draw(im)
                label = "%s #%d  %.2fs" % (name, s + k + 1, start + (s + k) / fps)
                box = d.textbbox((6, 4), label, font=font)
                d.rectangle((box[0] - 4, box[1] - 2, box[2] + 4, box[3] + 2), fill=(0, 0, 0))
                d.text((6, 4), label, fill=(255, 235, 60), font=font)
                sheet.paste(im, ((k % cols) * w, (k // cols) * h))
            path = out_dir / ("%s_%02d.jpg" % (name, s // per + 1))
            sheet.save(path, quality=88)
            print("SHEET %s frames %d-%d (%.2f-%.2f s)" % (path.as_posix(), s + 1, s + len(chunk), start + s / fps, start + (s + len(chunk) - 1) / fps))


if __name__ == "__main__":
    main()
