"""Verify/reapply affinity only within an explicitly owned process tree."""
import ctypes as c
from ctypes import wintypes as w
import json
from pathlib import Path
import sys
import time

from mh2_suspend import Entry, k

k.SetProcessAffinityMask.argtypes=[w.HANDLE,c.c_size_t]
k.SetProcessAffinityMask.restype=w.BOOL
k.GetProcessAffinityMask.argtypes=[w.HANDLE,c.POINTER(c.c_size_t),c.POINTER(c.c_size_t)]
k.GetProcessAffinityMask.restype=w.BOOL

def snapshot():
    handle=k.CreateToolhelp32Snapshot(2,0)
    if handle==c.c_void_p(-1).value: raise c.WinError(c.get_last_error())
    rows={}
    item=Entry(); item.size=c.sizeof(item)
    try:
        more=k.Process32FirstW(handle,c.byref(item))
        while more:
            rows[int(item.pid)]=(int(item.parent),str(item.exe))
            more=k.Process32NextW(handle,c.byref(item))
    finally: k.CloseHandle(handle)
    return rows

def apply_tree(root_pid,mask,ue_only=False):
    rows=snapshot()
    pids=[root_pid]
    for parent in pids:
        pids.extend(pid for pid,(ppid,_) in rows.items() if ppid==parent and pid not in pids)
    verified=[]
    for pid in pids:
        if pid not in rows: continue
        name=rows[pid][1]
        if ue_only and not name.lower().startswith(('unrealeditor','shadercompileworker')): continue
        handle=k.OpenProcess(0x0200|0x0400,False,pid)
        if not handle: continue  # A short-lived child may have exited since the snapshot.
        try:
            before=c.c_size_t(); system=c.c_size_t(); actual=c.c_size_t()
            if not k.GetProcessAffinityMask(handle,c.byref(before),c.byref(system)): continue
            if before.value!=mask:
                if not k.SetProcessAffinityMask(handle,mask): raise c.WinError(c.get_last_error())
            if not k.GetProcessAffinityMask(handle,c.byref(actual),c.byref(system)): continue
            assert actual.value==mask,(pid,name,actual.value,mask)
            verified.append(dict(pid=pid,exe=name,before=before.value,mask=actual.value))
        finally: k.CloseHandle(handle)
    return verified

if __name__=='__main__':
    # Sidecar for an already-running owned batch. Anchor is its known UE child.
    rows=snapshot()
    if sys.argv[1]=='--root':
        root=int(sys.argv[2])
        anchor=None
    else:
        anchor=int(sys.argv[1])
        assert rows[anchor][1].lower().startswith('unrealeditor')
        root=rows[anchor][0]
    assert rows[root][1].lower().startswith('python')
    print('MH4_AFFINITY_MONITOR root='+str(root)+' known_ue='+str(anchor),flush=True)
    history=[]
    while root in snapshot():
        history.extend(apply_tree(root,3,ue_only=True))
        time.sleep(2)
    out=Path(__file__).resolve().parents[2]/'previews/mh4/affinity_batch_3.json'
    out.write_text(json.dumps(history,indent=2)+'\n')
    print('MH4_AFFINITY_VERIFIED samples='+str(len(history)),flush=True)
