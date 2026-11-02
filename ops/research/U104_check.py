"""U104 gate (written by Claude, 2026-09-14). Run from the repo root (or the worktree root):
    python research/U104_check.py <find_moment.log> <watch_live_room.log> <compare.mp4>

- the finder drove bouts and printed MOMENT lines and MOMENTS_DONE, with no SCRIPT ERROR,
- the room recording printed ONE MOMENT_FRAME whose show clock is at or just past a MOMENT's impact (0 to 0.1 s late):
  the frame is keyed to the room's own presented clock, not to a guessed walk-in,
- the comparison video exists, is 30 fps, holds 2 x half x 30 (+-2) frames, and is wider than it is tall (two shots
  side by side), with a sheet PNG beside it.
Never edit this file to pass.
"""
import os
import re
import sys

fails = []


def fail(msg):
    fails.append(msg)
    print("FAIL " + msg)


if len(sys.argv) < 4:
    print("usage: python research/U104_check.py <find.log> <room.log> <compare.mp4> [half=1.5]")
    sys.exit(2)
find_log = open(sys.argv[1], encoding="utf-8", errors="replace").read()
room_log = open(sys.argv[2], encoding="utf-8", errors="replace").read()
mp4 = sys.argv[3]
half = float(sys.argv[4]) if len(sys.argv) > 4 else 1.5

if "SCRIPT ERROR" in find_log:
    fail("find_moment log has a SCRIPT ERROR")
moments = [(int(m.group(1)), float(m.group(2))) for m in re.finditer(r"MOMENT seed=(\d+) impact_s=([0-9.]+) round=\d+ contact=(clean|glancing|absorbed)", find_log)]
if not moments:
    fail("no MOMENT lines with a landed contact")
if "MOMENTS_DONE" not in find_log:
    fail("find_moment never printed MOMENTS_DONE")
if "SCRIPT ERROR" in room_log:
    fail("watch_live_room log has a SCRIPT ERROR")
frames = re.findall(r"MOMENT_FRAME frame=(\d+) show_s=([0-9.]+)", room_log)
if len(frames) != 1:
    fail("watch_live_room printed %d MOMENT_FRAME lines, wants exactly 1" % len(frames))
else:
    show_s = float(frames[0][1])
    late = [show_s - t for _, t in moments if 0.0 <= show_s - t <= 0.1]
    if not late:
        fail("MOMENT_FRAME show_s=%.3f is not 0-0.1 s after any MOMENT impact (%s)" % (show_s, ", ".join("%.2f" % t for _, t in moments[:6])))
    if int(frames[0][0]) < 60:
        fail("MOMENT_FRAME frame=%s is inside the first two seconds - before the walk-in could have finished" % frames[0][0])

if not os.path.isfile(mp4):
    fail("no comparison video at %s" % mp4)
else:
    try:
        import cv2
        cap = cv2.VideoCapture(mp4)
        n = int(cap.get(cv2.CAP_PROP_FRAME_COUNT))
        fps = cap.get(cv2.CAP_PROP_FPS)
        w = cap.get(cv2.CAP_PROP_FRAME_WIDTH)
        h = cap.get(cv2.CAP_PROP_FRAME_HEIGHT)
        want = int(round(2 * half * 30))
        if abs(n - want) > 2:
            fail("comparison has %d frames, wants %d +-2" % (n, want))
        if abs(fps - 30.0) > 0.5:
            fail("comparison is %.2f fps, wants 30" % fps)
        if not w > h * 1.5:
            fail("comparison is %dx%d - not two shots side by side" % (w, h))
    except ImportError:
        fail("OpenCV is not importable - cannot read the video")
    sheet = mp4[:-4] + "_sheet.png"
    if not os.path.isfile(sheet):
        fail("no sheet at %s" % sheet)

if fails:
    print("U104_CHECK FAIL %d" % len(fails))
    sys.exit(1)
print("U104_CHECK PASS moments=%d frame=%s" % (len(moments), frames[0][0]))
