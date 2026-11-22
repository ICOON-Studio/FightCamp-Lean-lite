"""KNEEROOT1 (S537): the two passes of tools/kneeroot_still.gd side by side - the bought take alone (left) and the game
(right), the same fixed camera in both halves. Stills -> <out>/<n>_<boxer>_<name>.jpg, films -> <out>/<n>_<boxer>_<film>.mp4.

    python tools/kneeroot_pair.py <frames_dir> <out_dir>
"""
import glob
import os
import subprocess
import sys

from PIL import Image, ImageDraw, ImageFont

LEFT, RIGHT = "THE BOUGHT TAKE ALONE", "THE GAME"


def font(size):
    try:
        return ImageFont.truetype("arialbd.ttf", size)
    except OSError:
        return ImageFont.load_default()


def pair(a, b, out):
    ia, ib = Image.open(a).convert("RGB"), Image.open(b).convert("RGB")
    w, h = ia.size
    cw = min(w, 1080)   # the boxer is in the middle of the picture: the middle 1080 columns of each half
    ia, ib = ia.crop(((w - cw) // 2, 0, (w + cw) // 2, h)), ib.crop(((w - cw) // 2, 0, (w + cw) // 2, h))
    w = cw
    im = Image.new("RGB", (w * 2, h))
    im.paste(ia, (0, 0))
    im.paste(ib, (w, 0))
    d = ImageDraw.Draw(im)
    d.line([(w, 0), (w, h)], fill=(255, 255, 255), width=2)
    for x, text in ((24, LEFT), (w + 24, RIGHT)):
        d.text((x + 2, 22), text, font=font(34), fill=(0, 0, 0))
        d.text((x, 20), text, font=font(34), fill=(255, 255, 255))
    im.save(out, quality=92)


def main():
    src, out = sys.argv[1], sys.argv[2]
    os.makedirs(out, exist_ok=True)
    n = 0
    for boxer in ("blue", "red"):
        for name in ("guard_side", "guard_front", "cross_side", "cross_front"):
            a = os.path.join(src, "src_%s_%s.png" % (boxer, name))
            b = os.path.join(src, "game_%s_%s.png" % (boxer, name))
            if os.path.exists(a) and os.path.exists(b):
                n += 1
                pair(a, b, os.path.join(out, "%d_%s_%s.jpg" % (n, boxer, name)))
        for film in ("cross", "idle"):
            fa = sorted(glob.glob(os.path.join(src, "src_%s_%s_*.jpg" % (boxer, film))))
            fb = sorted(glob.glob(os.path.join(src, "game_%s_%s_*.jpg" % (boxer, film))))
            k = min(len(fa), len(fb))
            if k == 0:
                continue
            n += 1
            tmp = os.path.join(out, "_tmp_%s_%s" % (boxer, film))
            os.makedirs(tmp, exist_ok=True)
            for i in range(k):
                pair(fa[i], fb[i], os.path.join(tmp, "%04d.jpg" % i))
            mp4 = os.path.join(out, "%d_%s_%s.mp4" % (n, boxer, film))
            # twice at speed, then once at quarter speed
            subprocess.run(["ffmpeg", "-y", "-loglevel", "error", "-framerate", "30", "-i", os.path.join(tmp, "%04d.jpg"),
                            "-filter_complex", "[0:v]split=3[a][b][c];[c]setpts=4*PTS[s];[a][b][s]concat=n=3:v=1,scale=trunc(iw/2)*2:trunc(ih/2)*2[v]",
                            "-map", "[v]", "-r", "30", "-pix_fmt", "yuv420p", "-crf", "20", mp4], check=True)
            # a strip of five pictures across the film, for reading without a player
            picks = [14, 19, 24, 29, 36] if film == "cross" else [int(k * (j + 0.5) / 5) for j in range(5)]   # cross: start, mid, contact, after, back
            strip = Image.new("RGB", (5 * 864, 404))
            for j in range(5):
                im = Image.open(os.path.join(tmp, "%04d.jpg" % min(k - 1, picks[j]))).resize((864, 404))
                strip.paste(im, (j * 864, 0))
            strip.save(os.path.join(out, "%d_%s_%s_strip.jpg" % (n, boxer, film)), quality=88)
            for f in glob.glob(os.path.join(tmp, "*.jpg")):
                os.remove(f)
            os.rmdir(tmp)
    print("KNEEROOT_PAIR %d files -> %s" % (n, out))


if __name__ == "__main__":
    main()
