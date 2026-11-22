"""CASCTEST1: answer Cascadeur's own dialogs from inside the app (nobody can click on a hidden desktop).
DO = ('close'|'enter'|'click', title, x_fraction, y_fraction). 'Apply AutoPhysics' asks
"Which frames should AutoPhysics results be applied to?"  [All Frames] [Only keys]."""
import ctypes, os, traceback
from ctypes import wintypes
try:
    DO
except NameError:
    DO = ('list', '', 0, 0)
try:
    u = ctypes.WinDLL('user32'); k = ctypes.WinDLL('kernel32')
    u.PostMessageW.argtypes = [ctypes.c_void_p, ctypes.c_uint, ctypes.c_size_t, ctypes.c_ssize_t]
    wins = []
    PROC = ctypes.WINFUNCTYPE(ctypes.c_bool, ctypes.c_void_p, ctypes.c_void_p)
    def cb(h, l):
        if u.IsWindowVisible(ctypes.c_void_p(h)):
            t = ctypes.create_unicode_buffer(200); u.GetWindowTextW(ctypes.c_void_p(h), t, 200)
            r = wintypes.RECT(); u.GetClientRect(ctypes.c_void_p(h), ctypes.byref(r))
            wins.append((h, t.value, r.right, r.bottom))
        return True
    u.EnumThreadWindows(k.GetCurrentThreadId(), PROC(cb), 0)
    print('windows:', [(w[1], w[2], w[3]) for w in wins])
    act, title, fx, fy = DO
    n = 0
    for h, t, w, hh in wins:
        if act == 'list' or t != title: continue
        if act == 'close':
            u.PostMessageW(h, 0x0010, 0, 0)
        elif act == 'enter':
            u.PostMessageW(h, 0x0100, 0x0D, 0); u.PostMessageW(h, 0x0101, 0x0D, 0)
        elif act == 'click':
            lp = (int(hh * fy) << 16) | int(w * fx)
            u.PostMessageW(h, 0x0200, 0, lp); u.PostMessageW(h, 0x0201, 1, lp); u.PostMessageW(h, 0x0202, 0, lp)
        n += 1
        if act != 'close': break
    print(act, title, 'sent to', n)
except Exception:
    print('TRACEBACK', traceback.format_exc())
