"""BOUGHTCLIP1 (S537): the three passes of tools/boughtclip_film.gd side by side, one fixed camera in all three.
    python tools/boughtclip_trio.py <frames_dir> <out_dir>
-> cross_contact.jpg (the contact picture), cross.mp4 (twice at speed, then once at quarter speed), cross_strip.jpg."""
import glob
import os
import subprocess
import sys

from PIL import Image, ImageDraw, ImageFont

PANES = (("bought", "AS BOUGHT", "the vendor's file on the vendor's mannequin"),
         ("ours", "OUR BODY, THE TAKE ONLY", "every layer of ours off"),
         ("game", "THE GAME NOW", "a landed cross of a planned exchange"))
CROP = (480, 1440)   # the middle 960 columns: the puncher and the man he hits


def font(size):
    try:
        return ImageFont.truetype("arialbd.ttf", size)
    except OSError:
        return ImageFont.load_default()


def trio(files, out, width=None):
    ims = [Image.open(f).convert("RGB").crop((CROP[0], 0, CROP[1], Image.open(f).size[1])) for f in files]
    w, h = ims[0].size
    im = Image.new("RGB", (w * 3, h))
    d = ImageDraw.Draw(im)
    for n, part in enumerate(ims):
        im.paste(part, (n * w, 0))
        if n:
            d.line([(n * w, 0), (n * w, h)], fill=(255, 255, 255), width=2)
        for dx, dy, col in ((2, 2, (0, 0, 0)), (0, 0, (255, 255, 255))):
            d.text((n * w + 20 + dx, 16 + dy), PANES[n][1], font=font(34), fill=col)
            d.text((n * w + 20 + dx, 58 + dy), PANES[n][2], font=font(22), fill=col)
    if width:
        im = im.resize((width, int(h * width / (w * 3)) // 2 * 2))
    im.save(out, quality=92)


def main():
    src, out = sys.argv[1], sys.argv[2]
    os.makedirs(out, exist_ok=True)
    trio([os.path.join(src, "%s_contact.png" % p[0]) for p in PANES], os.path.join(out, "cross_contact.jpg"))
    k = min(len(glob.glob(os.path.join(src, "%s_[0-9]*.jpg" % p[0]))) for p in PANES)
    tmp = os.path.join(out, "_tmp")
    os.makedirs(tmp, exist_ok=True)
    for i in range(k):
        trio([os.path.join(src, "%s_%03d.jpg" % (p[0], i)) for p in PANES], os.path.join(tmp, "%04d.jpg" % i), 1920)
    subprocess.run(["ffmpeg", "-y", "-loglevel", "error", "-framerate", "30", "-i", os.path.join(tmp, "%04d.jpg"),
                    "-filter_complex", "[0:v]split=3[a][b][c];[c]setpts=4*PTS[s];[a][b][s]concat=n=3:v=1[v]",
                    "-map", "[v]", "-r", "30", "-pix_fmt", "yuv420p", "-crf", "20", os.path.join(out, "cross.mp4")], check=True)
    picks = [12, 18, 21, 24, 27, 33, 42]   # before, the start, mid, the contact (15 + 9), just after, the recoil, back
    with Image.open(os.path.join(tmp, "0000.jpg")) as first:
        sw, sh = first.size[0] // 2, first.size[1] // 2
    strip = Image.new("RGB", (sw, sh * len(picks)))
    for j, n in enumerate(picks):
        with Image.open(os.path.join(tmp, "%04d.jpg" % min(k - 1, n))) as pic:
            strip.paste(pic.resize((sw, sh)), (0, j * sh))
    strip.save(os.path.join(out, "cross_strip.jpg"), quality=88)
    for f in glob.glob(os.path.join(tmp, "*.jpg")):
        os.remove(f)
    os.rmdir(tmp)
    print("BOUGHT_TRIO %d pictures -> %s" % (k, out))


if __name__ == "__main__":
    main()
