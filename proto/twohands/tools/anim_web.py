"""anim_web.py - RINGANIM1 (S552): the frame runs of tools/pics2d_anim.gd as web pictures for Ring Switches, and one
strip per run for the owner's eye (all frames side by side, the time from the contact under each).

    python proto/twohands/tools/anim_web.py <render_dir> [<render_dir> ...] [--strips <dir>] [--no-web] [--alias new=old ...] [--skip <part> ...]

Each <render_dir> holds <run>_<k>.png and frames.json. Web copies: 480 px webp in proto/twohands/img/anim/, their table in
proto/twohands/img/anim/frames.json (merged: a later run of the same name replaces the earlier one). A run whose contact
frame failed the picture gate is NOT copied (the page then keeps its still) and is printed.
--alias new=old: the page's run `new` plays the frames of `old` (said in the table as "same_as").
--skip <part>: runs whose name holds <part> get a strip but no web copy (a take that reads wrong is shown, not shipped).
MASK1 (S559): a frame with <run>_<k>_mask.png beside it (tools/pics2d_mask.gd) gets its mask copied too, 480 px, every
pixel snapped to the nearest part colour or made clear (lossless, palette PNG); the run's row lists them as "masks".
"""
from __future__ import annotations

import json
import sys
from pathlib import Path

from PIL import Image, ImageDraw, ImageFont

HERE = Path(__file__).resolve().parent
OUT = HERE.parent / "img" / "anim"
WEB_PX = 480
STRIP_PX = 300
## tools/pics2d_mask.gd PART: the eight part colours (blue lead, rear, legs, torso; red lead, rear, legs, torso)
MASK_RGB = [(255, 0, 0), (0, 255, 0), (0, 0, 255), (255, 255, 0), (255, 0, 255), (0, 255, 255), (255, 128, 0), (128, 0, 255)]


def mask_web(src: Path, dst: Path) -> None:
    """The mask at the web size, nearest-neighbour, each pixel the nearest part colour (or clear under half alpha)."""
    im = Image.open(src).convert("RGBA")
    im = im.resize((WEB_PX * im.width // im.height, WEB_PX), Image.NEAREST)
    pal = Image.new("P", (1, 1))
    flat = [0, 0, 0] + [c for rgb in MASK_RGB for c in rgb]
    pal.putpalette(flat + [0] * (768 - len(flat)))
    rgb = Image.new("RGB", im.size, (0, 0, 0))
    rgb.paste(im, mask=im.getchannel("A"))
    q = rgb.quantize(palette=pal, dither=Image.Dither.NONE)
    clear = im.getchannel("A").point(lambda v: 255 if v < 128 else 0)
    q.paste(0, mask=clear)   # index 0 = clear
    q.info["transparency"] = 0
    q.save(dst, "PNG", optimize=True, transparency=0)


def font(px: int):
    try:
        return ImageFont.truetype("segoeui.ttf", px)
    except OSError:
        return ImageFont.load_default()


def strip(src: Path, name: str, row: dict, dst: Path) -> Path:
    files, offs = row["files"], row["offs"]
    h = STRIP_PX
    first = Image.open(src / files[0])
    w = h * first.width // first.height   # a knockdown's pictures are twice as wide (same size of man)
    sheet = Image.new("RGB", (w * len(files), h + 34), (38, 46, 62))
    draw = ImageDraw.Draw(sheet)
    for k, f in enumerate(files):
        im = Image.open(src / f).convert("RGBA").resize((w, h), Image.LANCZOS)
        tile = Image.new("RGBA", (w, h), (38, 46, 62, 255) if offs[k] != 0 else (84, 62, 30, 255))
        tile.alpha_composite(im)
        sheet.paste(tile.convert("RGB"), (k * w, 0))
        label = "contact" if offs[k] == 0 else ("%+.2f s" % offs[k])
        draw.text((k * w + 8, h + 6), label, fill=(240, 232, 220), font=font(18))
    draw.text((8, 6), "%s  (%s)" % (name, row.get("clip", "")), fill=(227, 171, 69), font=font(18))
    dst.mkdir(parents=True, exist_ok=True)
    p = dst / (name + "_strip.png")
    sheet.save(p)
    return p


def main(argv: list[str]) -> int:
    dirs, strips, web, alias, skip = [], None, True, {}, []
    it = iter(argv)
    for a in it:
        if a == "--strips":
            strips = Path(next(it))
        elif a == "--no-web":
            web = False
        elif a == "--skip":
            skip.append(next(it))
        elif a == "--alias":
            new, old = next(it).split("=")
            alias[new] = old
        else:
            dirs.append(Path(a))
    table_p = OUT / "frames.json"
    table = json.loads(table_p.read_text(encoding="utf-8")) if table_p.exists() else {"runs": {}}
    kept = skipped = 0
    for d in dirs:
        doc = json.loads((d / "frames.json").read_text(encoding="utf-8"))
        runs = doc["runs"]
        if doc.get("camera"):   # RENDERFIT1 (S559): the ring camera's numbers ride along; the page slides every picture by red's metres in with them
            cam = dict(doc["camera"])
            first = next((d / r["files"][0] for r in runs.values() if r.get("files")), None)
            if first is not None and first.exists():
                cam["render_px"] = Image.open(first).height   # axis_px is in render px: the page scales it by the drawn height / this
            if table.get("camera") and table["camera"].get("axis_px") != cam.get("axis_px"):
                print("CAMERA DIFFERS %s: %s v %s (two cameras in one table)" % (d, cam.get("axis_px"), table["camera"].get("axis_px")))
            table["camera"] = cam
        for name, row in sorted(runs.items()):
            if strips is not None:
                strip(d, name, row, strips)
            if not web:
                continue
            if any(part in name for part in skip):
                print("NOT SHIPPED %s (--skip)" % name)
                table["runs"].pop(name, None)
                skipped += 1
                continue
            if row.get("gate_fails"):
                print("SKIPPED %s: %s" % (name, "; ".join(row["gate_fails"])))
                skipped += 1
                continue
            OUT.mkdir(parents=True, exist_ok=True)
            names, masks = [], []
            for f in row["files"]:
                mk = d / (Path(f).stem + "_mask.png")
                if mk.exists():
                    mask_web(mk, OUT / mk.name)
                    masks.append(mk.name)
                im = Image.open(d / f).convert("RGBA")
                im = im.resize((WEB_PX * im.width // im.height, WEB_PX), Image.LANCZOS)   # the height is the size: a wide picture stays wide
                wn = Path(f).with_suffix(".webp").name
                im.save(OUT / wn, "WEBP", quality=76)
                names.append(wn)
            table["runs"][name] = {"files": names, "offs": row["offs"], "contact": row.get("contact", -1), "clip": row.get("clip", "")}
            if masks and len(masks) == len(names):
                table["runs"][name]["masks"] = masks
            if row.get("range"):   # S562 GLIDE1: the page range the run was made at (3 Long, 2 Mid, 1 Inside): the page picks it by the range the men stand at
                table["runs"][name]["range"] = row["range"]
            if row.get("hit"):   # C509: the glove's place on the contact picture (share of width, height) - the page draws the hit there
                table["runs"][name]["hit"] = row["hit"]
            kept += 1
    for new, old in alias.items():
        if old in table["runs"]:
            table["runs"][new] = dict(table["runs"][old], same_as=old)
    if web:
        table_p.write_text(json.dumps(table, indent=1), encoding="utf-8")
        size = sum(p.stat().st_size for p in OUT.glob("*.webp"))
        print("ANIM_WEB kept=%d skipped=%d runs_in_table=%d webp=%.1f MB" % (kept, skipped, len(table["runs"]), size / 1e6))
    return 0


if __name__ == "__main__":
    sys.exit(main(sys.argv[1:]))
