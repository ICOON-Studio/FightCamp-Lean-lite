"""S370 the playthrough guide as an animated GIF (operator: "a gif animated guid explaining your playthrough each step").

Reads the TOUR lines tools/guide_tour.gd printed (file | title | what it is for), lays a caption band under each frame -
STEP n/N, the title, what the screen is for, and (amber) what is still unclear there - and writes guide.gif + guide.mp4.
    python tools/guide_gif.py <tour_dir> <tour_log> <out_dir>
"""
import re
import subprocess
import sys
from pathlib import Path

from PIL import Image, ImageDraw, ImageFont

W, H, BAND = 1280, 720, 190
FONT = "C:/Windows/Fonts/segoeui.ttf"
BOLD = "C:/Windows/Fonts/segoeuib.ttf"
SECONDS = 4.0

# Titles the tour could not name itself (her page's tabs, scripts/ui/areas/FighterPage.gd TABS).
TITLES = {
    "step_09.png": ("Her page - Attributes and moves", "Every number against its ceiling, and how well she throws each punch."),
    "step_10.png": ("Her page - Body", "Weight, the limit for her class, diet and any injury."),
    "step_11.png": ("Her page - Training", "THE WEEK: each day's session on the whiteboard, the goal lines it moves, the fatigue it costs."),
    "step_24.png": ("Weight made", "On the scale: under the limit, fight night is tomorrow."),
    "step_29.png": ("The scorecards", "Skip bout plays the rest in words: three judges, what decided it, the money and members it brought."),
}
# What is still unclear on each screen (S370 playthrough + S367 critic + S369 playtest). Empty = reads fine.
UNCLEAR = {
    "step_07.png": "Two places for one job: this list, and the real week on her page (Training tab).",
    "step_11.png": "You can feel a session move a goal line - but the goal itself is a row of text, not a test she can pass.",
    "step_12.png": "FIXED S370: whole points and 'N% to next', the sessions behind each gain named. Still a lot of empty page.",
    "step_14.png": "The opponent's file is thin until the camp's tape - you say yes before you can learn.",
    "step_18.png": "FIXED S370: the answer always goes into her plan and says which line it replaces.",
    "step_20.png": "The plan is rated against her style only, with no rounds; it never shows in the ring.",
    "step_21.png": "FIXED S370: move cards stitched into a strip - each join judged, strength, gas, speed, damage, odds.",
    "step_28.png": "The plan you made is not on screen; the calls do not say which line they serve.",
    "step_30.png": "What decided it is here, but THE PLAN, LIT UP waits behind a button.",
}


def wrap(draw, text, font, width):
    words, lines, cur = text.split(), [], ""
    for w in words:
        t = (cur + " " + w).strip()
        if draw.textlength(t, font=font) <= width:
            cur = t
        else:
            lines.append(cur)
            cur = w
    if cur:
        lines.append(cur)
    return lines


def main(tour_dir: Path, log: Path, out: Path) -> None:
    steps = []
    for line in log.read_text(encoding="utf-8", errors="replace").splitlines():
        m = re.match(r"TOUR (step_\d+\.png) \| (.*?) \| (.*?) \| screen=", line)
        if m:
            name, title, what = m.groups()
            title, what = TITLES.get(name, (title, what))
            steps.append((name, title, what))
    out.mkdir(parents=True, exist_ok=True)
    frames = out / "frames"
    frames.mkdir(exist_ok=True)
    f_big, f_mid, f_small = ImageFont.truetype(BOLD, 34), ImageFont.truetype(FONT, 25), ImageFont.truetype(BOLD, 18)
    for i, (name, title, what) in enumerate(steps, 1):
        shot = Image.open(tour_dir / name).convert("RGB").resize((W, H), Image.LANCZOS)
        img = Image.new("RGB", (W, H + BAND), (24, 22, 20))
        img.paste(shot, (0, 0))
        d = ImageDraw.Draw(img)
        d.rectangle([0, H, int(W * i / len(steps)), H + 6], fill=(214, 68, 52))
        d.text((28, H + 18), f"STEP {i} / {len(steps)}", font=f_small, fill=(214, 68, 52))
        d.text((150, H + 10), title, font=f_big, fill=(245, 240, 232))
        y = H + 58
        for ln in wrap(d, what, f_mid, W - 56)[:2]:
            d.text((28, y), ln, font=f_mid, fill=(205, 200, 190))
            y += 32
        note = UNCLEAR.get(name, "")
        if note:
            for ln in wrap(d, "STILL UNCLEAR: " + note, f_mid, W - 56)[:2]:
                d.text((28, y + 4), ln, font=f_mid, fill=(240, 176, 64))
                y += 32
        img.save(frames / f"f_{i:02d}.png")
    fr = f"1/{SECONDS}"
    pal = out / "palette.png"
    subprocess.run(["ffmpeg", "-loglevel", "error", "-y", "-framerate", fr, "-i", str(frames / "f_%02d.png"),
                    "-vf", "scale=1100:-1:flags=lanczos,palettegen=max_colors=192", str(pal)], check=True)
    subprocess.run(["ffmpeg", "-loglevel", "error", "-y", "-framerate", fr, "-i", str(frames / "f_%02d.png"), "-i", str(pal),
                    "-lavfi", "scale=1100:-1:flags=lanczos[x];[x][1:v]paletteuse=dither=bayer:bayer_scale=4",
                    "-loop", "0", str(out / "guide.gif")], check=True)
    subprocess.run(["ffmpeg", "-loglevel", "error", "-y", "-framerate", fr, "-i", str(frames / "f_%02d.png"),
                    "-vf", "fps=30,format=yuv420p", "-c:v", "libx264", "-crf", "22", str(out / "guide.mp4")], check=True)
    print(f"GUIDE {len(steps)} steps -> {out / 'guide.gif'} ({(out / 'guide.gif').stat().st_size // 1024} KB), guide.mp4")


if __name__ == "__main__":
    main(Path(sys.argv[1]), Path(sys.argv[2]), Path(sys.argv[3]))
