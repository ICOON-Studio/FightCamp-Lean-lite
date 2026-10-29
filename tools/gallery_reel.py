"""S305: the move-set review reel from tools/fight3d_gallery.gd frames: one labelled 2.2 s clip per case, joined into
<out_dir>/move_reel.mp4, plus <out_dir>/move_sheet_<n>.jpg contact sheets (10 cases a sheet, 6 frames a case).
    python tools/gallery_reel.py <out_dir>
"""
import pathlib
import subprocess
import sys

FONT = "C\\:/Windows/Fonts/arial.ttf"


def esc(text: str) -> str:
    return text.replace("\\", "\\\\").replace(":", "\\:").replace("'", "’").replace("%", "\\%")


def main(out: pathlib.Path) -> None:
    labels = (out / "cases.txt").read_text(encoding="utf-8").splitlines()
    parts = []
    for i, label in enumerate(labels):
        src = out / f"{i:02d}" / "f%02d.jpg"
        dst = out / f"case_{i:02d}.mp4"
        draw = (f"drawtext=fontfile='{FONT}':text='{i + 1}. {esc(label)}':x=10:y=10:fontsize=15:fontcolor=white:"
                "box=1:boxcolor=black@0.6:boxborderw=6")
        subprocess.run(["ffmpeg", "-v", "error", "-y", "-framerate", "15", "-i", str(src), "-vf", draw,
                        "-c:v", "libx264", "-pix_fmt", "yuv420p", "-r", "30", str(dst)], check=True)
        parts.append(dst)
    lst = out / "parts.txt"
    lst.write_text("".join(f"file '{p.as_posix()}'\n" for p in parts), encoding="utf-8")
    subprocess.run(["ffmpeg", "-v", "error", "-y", "-f", "concat", "-safe", "0", "-i", str(lst), "-c", "copy",
                    str(out / "move_reel.mp4")], check=True)
    for s in range(0, len(labels), 10):
        rows = []
        for i in range(s, min(s + 10, len(labels))):
            rows.append(out / f"{i:02d}")
        inputs = []
        for d in rows:
            for k in (0, 6, 10, 14, 20, 28):
                inputs += ["-i", str(d / f"f{k:02d}.jpg")]
        n = len(rows) * 6
        grid = "".join(f"[{j}:v]scale=220:-1[v{j}];" for j in range(n))
        grid += "".join(f"[v{j}]" for j in range(n)) + f"xstack=inputs={n}:grid=6x{len(rows)}"
        subprocess.run(["ffmpeg", "-v", "error", "-y", *inputs, "-filter_complex", grid, "-frames:v", "1",
                        str(out / f"move_sheet_{s // 10 + 1}.jpg")], check=True)
    print(f"REEL cases={len(labels)} -> {out / 'move_reel.mp4'}")


if __name__ == "__main__":
    main(pathlib.Path(sys.argv[1]))
