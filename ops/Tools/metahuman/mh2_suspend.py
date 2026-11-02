"""Suspend/resume only descendants of an owned launch; no process-name matching."""
import ctypes as c
from ctypes import wintypes as w

class Entry(c.Structure):
    _fields_ = [("size", w.DWORD), ("usage", w.DWORD), ("pid", w.DWORD),
                ("heap", c.c_size_t), ("module", w.DWORD), ("threads", w.DWORD),
                ("parent", w.DWORD), ("priority", w.LONG), ("flags", w.DWORD),
                ("exe", w.WCHAR * 260)]

k = c.WinDLL("kernel32", use_last_error=True)
n = c.WinDLL("ntdll")
k.CreateToolhelp32Snapshot.argtypes = [w.DWORD, w.DWORD]
k.CreateToolhelp32Snapshot.restype = w.HANDLE
k.Process32FirstW.argtypes = [w.HANDLE, c.POINTER(Entry)]
k.Process32NextW.argtypes = [w.HANDLE, c.POINTER(Entry)]
k.OpenProcess.argtypes = [w.DWORD, w.BOOL, w.DWORD]
k.OpenProcess.restype = w.HANDLE
k.CloseHandle.argtypes = [w.HANDLE]
n.NtSuspendProcess.argtypes = [w.HANDLE]
n.NtResumeProcess.argtypes = [w.HANDLE]

def resume(handles):
    for handle in reversed(handles):
        n.NtResumeProcess(handle)
        k.CloseHandle(handle)

def suspend_tree(owned_pid):
    snapshot = k.CreateToolhelp32Snapshot(2, 0)
    if snapshot == c.c_void_p(-1).value:
        raise c.WinError(c.get_last_error())
    parents = {}
    entry = Entry()
    entry.size = c.sizeof(entry)
    try:
        more = k.Process32FirstW(snapshot, c.byref(entry))
        while more:
            parents[int(entry.pid)] = int(entry.parent)
            more = k.Process32NextW(snapshot, c.byref(entry))
    finally:
        k.CloseHandle(snapshot)
    pids = [owned_pid]
    for parent in pids:
        pids.extend(pid for pid, ppid in parents.items() if ppid == parent and pid not in pids)
    handles = []
    try:
        for pid in pids:
            handle = k.OpenProcess(0x0800, False, pid)
            if not handle:
                raise c.WinError(c.get_last_error())
            if n.NtSuspendProcess(handle) != 0:
                k.CloseHandle(handle)
                raise RuntimeError(f"Cannot suspend owned PID {pid}")
            handles.append(handle)
    except BaseException:
        resume(handles)
        raise
    return handles
