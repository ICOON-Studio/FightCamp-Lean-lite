"""CASCTEST1: screenshot Cascadeur's own windows from INSIDE the app (it lives on the hidden desktop, so nothing
outside can grab it and nothing is shown on a monitor). PrintWindow -> BMP. OUT = file stem set by the caller."""
import ctypes, os, struct, traceback
from ctypes import wintypes
try:
    OUT
except NameError:
    OUT = 'shot'
try:
    u = ctypes.WinDLL('user32'); g = ctypes.WinDLL('gdi32'); k = ctypes.WinDLL('kernel32')
    for f in (u.GetDC, u.GetWindowDC, g.CreateCompatibleDC, g.CreateCompatibleBitmap, g.SelectObject):
        f.restype = ctypes.c_void_p
    u.GetDC.argtypes = [ctypes.c_void_p]; u.ReleaseDC.argtypes = [ctypes.c_void_p, ctypes.c_void_p]
    g.CreateCompatibleDC.argtypes = [ctypes.c_void_p]; g.CreateCompatibleBitmap.argtypes = [ctypes.c_void_p, ctypes.c_int, ctypes.c_int]
    g.SelectObject.argtypes = [ctypes.c_void_p, ctypes.c_void_p]; g.DeleteObject.argtypes = [ctypes.c_void_p]; g.DeleteDC.argtypes = [ctypes.c_void_p]
    u.PrintWindow.argtypes = [ctypes.c_void_p, ctypes.c_void_p, ctypes.c_uint]
    g.GetDIBits.argtypes = [ctypes.c_void_p, ctypes.c_void_p, ctypes.c_uint, ctypes.c_uint, ctypes.c_void_p, ctypes.c_void_p, ctypes.c_uint]
    pid = os.getpid(); wins = []
    PROC = ctypes.WINFUNCTYPE(ctypes.c_bool, ctypes.c_void_p, ctypes.c_void_p)
    def cb(h, l):
        p = wintypes.DWORD(); u.GetWindowThreadProcessId(ctypes.c_void_p(h), ctypes.byref(p))
        if p.value == pid and u.IsWindowVisible(ctypes.c_void_p(h)):
            r = wintypes.RECT(); u.GetWindowRect(ctypes.c_void_p(h), ctypes.byref(r))
            t = ctypes.create_unicode_buffer(200); u.GetWindowTextW(ctypes.c_void_p(h), t, 200)
            wins.append((h, r.right - r.left, r.bottom - r.top, t.value))
        return True
    u.EnumThreadWindows(k.GetCurrentThreadId(), PROC(cb), 0)
    print('windows:', [(w[1], w[2], w[3]) for w in wins])
    for i, (h, w, hh, title) in enumerate(sorted(wins, key=lambda x: -x[1] * x[2])[:3]):
        if w < 50 or hh < 50: continue
        dc = u.GetDC(h); mdc = g.CreateCompatibleDC(dc); bmp = g.CreateCompatibleBitmap(dc, w, hh)
        g.SelectObject(mdc, bmp)
        ok = u.PrintWindow(h, mdc, 2)
        bi = struct.pack('<IiiHHIIiiII', 40, w, -hh, 1, 32, 0, 0, 0, 0, 0, 0)
        buf = ctypes.create_string_buffer(w * hh * 4)
        g.GetDIBits(mdc, bmp, 0, hh, buf, bi, 0)
        p = os.path.join(WORKDIR, '%s_%d.bmp' % (OUT, i))
        with open(p, 'wb') as fh:
            fh.write(b'BM' + struct.pack('<IHHI', 54 + len(buf), 0, 0, 54) + bi + buf.raw)
        g.DeleteObject(bmp); g.DeleteDC(mdc); u.ReleaseDC(h, dc)
        print('shot', p, w, hh, 'PrintWindow', ok, title)
except Exception:
    print('TRACEBACK', traceback.format_exc())
