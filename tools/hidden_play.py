"""Play a windowed program on the never-shown desktop: start it, photograph it, click and type into it, film it.

For playtesting an installed reference game (owner 2026-11-10: "can you playtest the boxing manager on the background
hidden desktop"; proven that day on a Godot/Vulkan game, report ops/research/BOXING_MANAGER_PLAYTEST_S426.md) and for
driving our own windowed build by hand. Nothing reaches a monitor; the install folder of the program is never touched.

  python tools/hidden_play.py start <exe> [args...]   RUN THIS IN THE BACKGROUND: it stays alive as the program's
                                                      keeper (a tool shell ends a child whose starter has exited)
  python tools/hidden_play.py wins                    its windows; exit code 1 if ANY is on the visible desktop
  python tools/hidden_play.py alive | stop            stop = by PID, with its children
  python tools/hidden_play.py seq <step> [<step>...]  steps run in order:
      click:x,y  rclick:x,y  dclick:x,y  move:x,y  drag:x0,y0,x1,y1  wheel:x,y,notches (minus = down)
      key:enter[,esc,...]  "text:Some words"  wait:seconds
      shot:name[,mode]     -> <dir>/name.png   (mode pw3 default; pw2, pw0, blt to compare)
      rec:name,seconds[,fps] -> <dir>/name.mp4 (silent; needs ffmpeg; `touch <dir>/rec_stop` ends it early)

  --dir=<folder> before the command: where the PID file, the program's log and the pictures go
  (default E:/FightCamp/tmp/hidden_play, outside git). Coordinates are client pixels of the picture `shot` saves.

How it works, and the traps:
- Every call is one short process whose main thread JOINS the hidden desktop (SetThreadDesktop): window messages only
  travel inside one desktop, and real input devices never reach a hidden one.
- Pictures: PrintWindow with flag 3 (client area + full content). Flag 0 and BitBlt come back blank for a GPU window.
- Input: posted messages, sent to the deepest child window under the point (a game is one window, a toolkit program
  is a tree). A click is a mouse move, then button down, then up. Keys go to the focused child.
- Some toolkits (Tk for one) read the REAL mouse button, not the message: they can be photographed but not clicked.
  Games on Godot and plain Windows controls take posted input (both tested 2026-11-10).
- Godot builds take `--audio-driver Dummy --windowed` (a hidden window still plays sound).
- Run `wins` before each stage of a playtest and `stop` at once if it reports a visible window.
- Never click a game's Discord / Forum / web links: they open a browser on the real desktop.
"""
import ctypes
import struct
import subprocess
import sys
import time
import zlib
from ctypes import wintypes
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))
import hidden_desktop  # noqa: E402  (start() and the desktop's name)

DESKTOP = hidden_desktop.DESKTOP
DEFAULT_DIR = Path(__file__).resolve().parents[2] / "tmp" / "hidden_play"
GENERIC_ALL = 0x10000000
user32 = ctypes.WinDLL("user32", use_last_error=True)
gdi32 = ctypes.WinDLL("gdi32", use_last_error=True)
kernel32 = ctypes.WinDLL("kernel32", use_last_error=True)
ENUMPROC = ctypes.WINFUNCTYPE(wintypes.BOOL, wintypes.HWND, wintypes.LPARAM)

user32.OpenDesktopW.restype = wintypes.HANDLE
user32.SetThreadDesktop.argtypes = [wintypes.HANDLE]
user32.EnumDesktopWindows.argtypes = [wintypes.HANDLE, ENUMPROC, wintypes.LPARAM]
user32.EnumWindows.argtypes = [ENUMPROC, wintypes.LPARAM]
user32.GetDC.restype = wintypes.HDC
user32.GetDC.argtypes = [wintypes.HWND]
user32.ReleaseDC.argtypes = [wintypes.HWND, wintypes.HDC]
user32.PrintWindow.argtypes = [wintypes.HWND, wintypes.HDC, wintypes.UINT]
user32.PostMessageW.argtypes = [wintypes.HWND, wintypes.UINT, wintypes.WPARAM, wintypes.LPARAM]
user32.GetClientRect.argtypes = [wintypes.HWND, ctypes.POINTER(wintypes.RECT)]
user32.GetWindowRect.argtypes = [wintypes.HWND, ctypes.POINTER(wintypes.RECT)]
user32.MapVirtualKeyW.argtypes = [wintypes.UINT, wintypes.UINT]
user32.IsWindow.argtypes = [wintypes.HWND]
user32.ChildWindowFromPointEx.restype = wintypes.HWND
user32.ChildWindowFromPointEx.argtypes = [wintypes.HWND, wintypes.POINT, wintypes.UINT]
user32.MapWindowPoints.argtypes = [wintypes.HWND, wintypes.HWND, ctypes.POINTER(wintypes.POINT), wintypes.UINT]
user32.IsChild.argtypes = [wintypes.HWND, wintypes.HWND]
gdi32.CreateCompatibleDC.restype = wintypes.HDC
gdi32.CreateCompatibleDC.argtypes = [wintypes.HDC]
gdi32.CreateCompatibleBitmap.restype = wintypes.HBITMAP
gdi32.CreateCompatibleBitmap.argtypes = [wintypes.HDC, ctypes.c_int, ctypes.c_int]
gdi32.SelectObject.restype = wintypes.HGDIOBJ
gdi32.SelectObject.argtypes = [wintypes.HDC, wintypes.HGDIOBJ]
gdi32.BitBlt.argtypes = [wintypes.HDC, ctypes.c_int, ctypes.c_int, ctypes.c_int, ctypes.c_int, wintypes.HDC,
                         ctypes.c_int, ctypes.c_int, wintypes.DWORD]
gdi32.GetDIBits.argtypes = [wintypes.HDC, wintypes.HBITMAP, wintypes.UINT, wintypes.UINT, ctypes.c_void_p,
                            ctypes.c_void_p, wintypes.UINT]
gdi32.DeleteObject.argtypes = [wintypes.HGDIOBJ]
gdi32.DeleteDC.argtypes = [wintypes.HDC]
kernel32.OpenProcess.restype = wintypes.HANDLE
kernel32.WaitForSingleObject.argtypes = [wintypes.HANDLE, wintypes.DWORD]
kernel32.GetExitCodeProcess.argtypes = [wintypes.HANDLE, ctypes.POINTER(wintypes.DWORD)]

VK = {"enter": 0x0D, "esc": 0x1B, "space": 0x20, "tab": 0x09, "left": 0x25, "up": 0x26, "right": 0x27,
      "down": 0x28, "back": 0x08, "f1": 0x70, "f5": 0x74, "f11": 0x7A, "pgdn": 0x22, "pgup": 0x21,
      "home": 0x24, "end": 0x23, "del": 0x2E}
BITMAP_HEADER = "<IiiHHIIiiII"


def family(pid):
    """pid and every descendant with its image name (a relaunch through a launcher would be a child)."""
    out = subprocess.run(["powershell", "-NoProfile", "-Command",
                          "Get-CimInstance Win32_Process | ForEach-Object "
                          "{ \"$($_.ProcessId),$($_.ParentProcessId),$($_.Name)\" }"],
                         capture_output=True, text=True).stdout
    kids, names = {}, {}
    for row in out.splitlines():
        p, pp, n = (row.split(",", 2) + ["", ""])[:3]
        if p.strip().isdigit() and pp.strip().isdigit():
            kids.setdefault(int(pp), []).append(int(p))
            names[int(p)] = n.strip()
    fam, todo = {}, [pid]
    while todo:
        x = todo.pop()
        if x not in fam:
            fam[x] = names.get(x, "ended")
            todo += kids.get(x, [])
    return fam


def windows(desk, pids):
    """(hwnd, pid, visible, title, class, (x, y, w, h)) of every top-level window of pids; desk None = visible desktop."""
    found = []

    def cb(hwnd, _):
        owner = wintypes.DWORD()
        user32.GetWindowThreadProcessId(hwnd, ctypes.byref(owner))
        if owner.value in pids:
            r = wintypes.RECT()
            user32.GetWindowRect(hwnd, ctypes.byref(r))
            title, cls = ctypes.create_unicode_buffer(200), ctypes.create_unicode_buffer(100)
            user32.GetWindowTextW(hwnd, title, 200)
            user32.GetClassNameW(hwnd, cls, 100)
            found.append((hwnd, owner.value, bool(user32.IsWindowVisible(hwnd)), title.value, cls.value,
                          (r.left, r.top, r.right - r.left, r.bottom - r.top)))
        return True

    proc = ENUMPROC(cb)
    user32.EnumWindows(proc, 0) if desk is None else user32.EnumDesktopWindows(desk, proc, 0)
    return found


def join_hidden():
    """Move this thread to the hidden desktop (it must own no window yet); returns the desktop handle."""
    h = user32.OpenDesktopW(DESKTOP, 0, False, GENERIC_ALL)
    if not h or not user32.SetThreadDesktop(h):
        raise OSError(ctypes.get_last_error(), "cannot join the hidden desktop (was anything started there?)")
    return h


def main_window(desk, pid):
    """The biggest visible window of pid on the hidden desktop."""
    big = [(w[5][2] * w[5][3], w[0]) for w in windows(desk, {pid}) if w[2] and w[5][2] > 200 and w[5][3] > 200]
    if not big:
        raise SystemExit("no visible window for PID %d on the hidden desktop" % pid)
    return max(big)[1]


def write_png(path, w, h, bgra):
    rows, stride = bytearray(), w * 4
    for y in range(h):
        row, rgb = bgra[y * stride:(y + 1) * stride], bytearray(w * 3)
        rgb[0::3], rgb[1::3], rgb[2::3] = row[2::4], row[1::4], row[0::4]
        rows += b"\0" + rgb

    def chunk(tag, data):
        return struct.pack(">I", len(data)) + tag + data + struct.pack(">I", zlib.crc32(tag + data) & 0xffffffff)

    Path(path).write_bytes(b"\x89PNG\r\n\x1a\n" + chunk(b"IHDR", struct.pack(">IIBBBBB", w, h, 8, 2, 0, 0, 0))
                           + chunk(b"IDAT", zlib.compress(bytes(rows), 6)) + chunk(b"IEND", b""))


class Grabber:
    """Reads the window's client area as BGRA bytes, as often as asked."""

    def __init__(self, hwnd):
        r = wintypes.RECT()
        user32.GetClientRect(hwnd, ctypes.byref(r))
        self.hwnd, self.w, self.h = hwnd, r.right, r.bottom
        self.wdc = user32.GetDC(hwnd)
        self.mdc = gdi32.CreateCompatibleDC(self.wdc)
        self.bmp = gdi32.CreateCompatibleBitmap(self.wdc, self.w, self.h)
        self.info = struct.pack(BITMAP_HEADER, 40, self.w, -self.h, 1, 32, 0, 0, 0, 0, 0, 0)
        self.buf = ctypes.create_string_buffer(self.w * self.h * 4)

    def grab(self, mode="pw3"):
        old = gdi32.SelectObject(self.mdc, self.bmp)
        if mode == "blt":
            gdi32.BitBlt(self.mdc, 0, 0, self.w, self.h, self.wdc, 0, 0, 0x00CC0020)
        else:
            user32.PrintWindow(self.hwnd, self.mdc, {"pw3": 3, "pw2": 2, "pw1": 1, "pw0": 0}[mode])
        gdi32.SelectObject(self.mdc, old)
        gdi32.GetDIBits(self.mdc, self.bmp, 0, self.h, self.buf, self.info, 0)
        return self.buf.raw

    def close(self):
        gdi32.DeleteObject(self.bmp)
        gdi32.DeleteDC(self.mdc)
        user32.ReleaseDC(self.hwnd, self.wdc)


def shot(hwnd, out, mode="pw3"):
    g = Grabber(hwnd)
    for _ in range(4):  # a window caught mid-repaint comes back one flat colour: look again
        raw = g.grab(mode)
        colours = len(set(raw[i:i + 4] for i in range(0, len(raw), 4 * 997)))
        if colours >= 3:
            break
        time.sleep(0.15)
    g.close()
    write_png(out, g.w, g.h, raw)
    print("shot %s %dx%d colours_sampled=%d%s" % (out, g.w, g.h, colours, "  (BLANK?)" if colours < 3 else ""))


def record(hwnd, out, seconds, fps, stop_file):
    g = Grabber(hwnd)
    ff = subprocess.Popen(["ffmpeg", "-y", "-loglevel", "error", "-f", "rawvideo", "-pix_fmt", "bgra",
                           "-s", "%dx%d" % (g.w, g.h), "-r", str(fps), "-i", "-", "-an",
                           "-vf", "pad=ceil(iw/2)*2:ceil(ih/2)*2", "-c:v", "libx264", "-preset", "veryfast",
                           "-crf", "27", "-pix_fmt", "yuv420p", "-threads", "2", str(out)],
                          stdin=subprocess.PIPE, creationflags=0x4000 | 0x08000000)  # below normal, no window
    stop_file.unlink(missing_ok=True)
    t0, n = time.time(), 0
    while time.time() - t0 < seconds and not stop_file.exists() and user32.IsWindow(hwnd):
        try:
            ff.stdin.write(g.grab())
        except OSError:
            break
        n += 1
        time.sleep(max(0.0, t0 + n / fps - time.time()))
    ff.stdin.close()
    ff.wait()
    g.close()
    print("rec %s frames=%d seconds=%.1f" % (out, n, time.time() - t0))


class GUITHREADINFO(ctypes.Structure):
    _fields_ = [("cbSize", wintypes.DWORD), ("flags", wintypes.DWORD), ("hwndActive", wintypes.HWND),
                ("hwndFocus", wintypes.HWND), ("hwndCapture", wintypes.HWND), ("hwndMenuOwner", wintypes.HWND),
                ("hwndMoveSize", wintypes.HWND), ("hwndCaret", wintypes.HWND), ("rcCaret", wintypes.RECT)]


def lparam(x, y):
    return (int(y) << 16) | (int(x) & 0xFFFF)


def under(hwnd, x, y):
    """The deepest child window under client point (x, y) of hwnd, and that point in the child's own pixels.
    A game is one window; a toolkit program (Qt, Tk, a launcher) is a tree, and a posted message is not routed down it."""
    pt, cur = wintypes.POINT(int(x), int(y)), hwnd
    while True:
        child = user32.ChildWindowFromPointEx(cur, pt, 0x0001 | 0x0002)  # skip invisible and disabled
        if not child or child == cur:
            return cur, pt.x, pt.y
        user32.MapWindowPoints(cur, child, ctypes.byref(pt), 1)
        cur = child


def focused(hwnd, last_clicked):
    """Where keys go: the program's focused child, else the child last clicked in this call, else the window."""
    info = GUITHREADINFO()
    info.cbSize = ctypes.sizeof(info)
    thread = user32.GetWindowThreadProcessId(hwnd, None)
    ok = user32.GetGUIThreadInfo(thread, ctypes.byref(info)) and info.hwndFocus
    if ok and (info.hwndFocus == hwnd or user32.IsChild(hwnd, info.hwndFocus)):
        return info.hwndFocus
    return last_clicked or hwnd


def step(hwnd, out_dir, name, a, state):
    def mouse(msg, wp, x, y):
        to, cx, cy = under(hwnd, x, y)
        user32.PostMessageW(to, msg, wp, lparam(cx, cy))
        return to

    if name == "wait":
        time.sleep(float(a[0]))
    elif name == "shot":
        shot(hwnd, str(out_dir / (a[0] + ".png")), a[1] if len(a) > 1 else "pw3")
    elif name == "rec":
        record(hwnd, out_dir / (a[0] + ".mp4"), float(a[1]), float(a[2]) if len(a) > 2 else 4.0, out_dir / "rec_stop")
    elif name == "move":
        mouse(0x0200, 0, a[0], a[1])
    elif name in ("click", "rclick", "dclick"):
        down, up, held = (0x0204, 0x0205, 2) if name == "rclick" else (0x0201, 0x0202, 1)
        mouse(0x0200, 0, a[0], a[1])
        time.sleep(0.12)
        for _ in range(2 if name == "dclick" else 1):
            state["clicked"] = mouse(down, held, a[0], a[1])
            time.sleep(0.09)
            mouse(up, 0, a[0], a[1])
            time.sleep(0.09)
    elif name == "drag":
        x0, y0, x1, y1 = map(int, a[:4])
        to, cx, cy = under(hwnd, x0, y0)  # the whole drag belongs to the window it starts in
        post = lambda msg, wp, x, y: user32.PostMessageW(to, msg, wp, lparam(x - x0 + cx, y - y0 + cy))  # noqa: E731
        post(0x0200, 0, x0, y0)
        time.sleep(0.1)
        post(0x0201, 1, x0, y0)
        for i in range(1, 11):
            time.sleep(0.03)
            post(0x0200, 1, x0 + (x1 - x0) * i // 10, y0 + (y1 - y0) * i // 10)
        time.sleep(0.05)
        post(0x0202, 0, x1, y1)
    elif name == "wheel":
        to = mouse(0x0200, 0, a[0], a[1])
        time.sleep(0.05)
        for _ in range(abs(int(a[2]))):  # the wheel message carries SCREEN pixels; the programs tried read only the delta
            user32.PostMessageW(to, 0x020A, ((120 if int(a[2]) > 0 else -120) & 0xFFFF) << 16, lparam(a[0], a[1]))
            time.sleep(0.04)
    elif name == "key":
        to = focused(hwnd, state.get("clicked"))
        for k in a:
            vk = VK.get(k.lower()) or (int(k, 16) if k.lower().startswith("0x") else ord(k.upper()))
            scan = user32.MapVirtualKeyW(vk, 0)
            user32.PostMessageW(to, 0x0100, vk, 1 | (scan << 16))
            time.sleep(0.06)
            user32.PostMessageW(to, 0x0101, vk, 1 | (scan << 16) | (0xC0 << 24))
            time.sleep(0.06)
    elif name == "text":
        to = focused(hwnd, state.get("clicked"))
        for ch in a[0]:
            user32.PostMessageW(to, 0x0102, ord(ch), 1)
            time.sleep(0.03)
    else:
        raise SystemExit("unknown step: " + name)


def main(argv):
    out_dir = DEFAULT_DIR
    while argv and argv[0].startswith("--dir="):
        out_dir = Path(argv.pop(0)[6:])
    if not argv or argv[0] not in ("start", "wins", "alive", "stop", "seq"):
        print(__doc__)
        return 2
    try:
        ctypes.WinDLL("shcore").SetProcessDpiAwareness(2)  # coordinates = real pixels
    except OSError:
        pass
    out_dir.mkdir(parents=True, exist_ok=True)
    pid_file, cmd = out_dir / "pid.txt", argv[0]
    if cmd == "start":
        exe = argv[1]
        pid = hidden_desktop.start(argv[1:], cwd=str(Path(exe).parent), log=str(out_dir / "program.log"))
        pid_file.write_text(str(pid))
        print("PID", pid, "- keeping it alive; log", out_dir / "program.log", flush=True)
        h = kernel32.OpenProcess(0x00100000 | 0x1000, False, pid)
        kernel32.WaitForSingleObject(h, 6 * 3600 * 1000)
        code = wintypes.DWORD(0)
        kernel32.GetExitCodeProcess(h, ctypes.byref(code))
        print("program ended, exit code", hex(code.value))
        return 0
    pid = int(pid_file.read_text())
    if cmd == "alive":
        h, code = kernel32.OpenProcess(0x1000, False, pid), wintypes.DWORD(0)
        running = bool(h) and kernel32.GetExitCodeProcess(h, ctypes.byref(code)) and code.value == 259
        print("PID", pid, "running" if running else "ended")
        return 0 if running else 1
    if cmd == "stop":
        print(subprocess.run(["taskkill", "/PID", str(pid), "/T", "/F"], capture_output=True, text=True).stdout.strip())
        return 0
    if cmd == "wins":
        fam = family(pid)
        seen = [w for w in windows(None, set(fam)) if w[2]]
        print("process family:", fam)
        print("ON THE VISIBLE DESKTOP:", seen if seen else "none")
        desk = user32.OpenDesktopW(DESKTOP, 0, False, GENERIC_ALL)
        for w in windows(desk, set(fam)):
            if w[2]:
                print("hidden:", w)
        return 1 if seen else 0
    hwnd = main_window(join_hidden(), pid)
    state = {}
    for s in argv[1:]:
        name, _, rest = s.partition(":")
        step(hwnd, out_dir, name, [rest] if name == "text" else rest.split(","), state)
    return 0


if __name__ == "__main__":
    sys.exit(main(sys.argv[1:]))
