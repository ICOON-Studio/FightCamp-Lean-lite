---
name: project_opsboard_launch_button
description: "The ops board on 8787 now runs from the checkout and can start the Claude desktop app from the operator's phone - plus the three traps that had stopped it (frozen exe, pythonw/cmd, a 4s cache on a 32s build)"
metadata: 
  node_type: memory
  type: project
  originSessionId: 79d91b9d-dd8f-4640-9607-fe7da8006134
  modified: 2026-09-21T14:11:58.819Z
---

**`http://192.168.178.115:8787/` starts the Claude desktop app from the
operator's phone.** Fixed 2026-09-21 when they asked "can you fix the opsboard
so that i can lauch this app from my phone if i have to?"

The board's scheduled task `FightCamp Ops Board` now runs
`python.exe -u Tools/opsboard/server.py --port 8787 --log AgentComms/opsboard.log`
from the CHECKOUT, keeping its original **S4U** principal (so it is up before
anyone logs in) and its **5-minute** self-healing trigger. It therefore stays
current with every `git pull` — no rebuild, no frozen binary.

**Four traps, all of which had to be cleared before the button worked:**

1. **8787 was the frozen `FightCampOpsBoard.exe`**, built 2026-09-12, which
   answers **404** on `/api/launch`. A page cannot add an endpoint to a frozen
   binary, which is why the board showed its own "cannot start anything yet"
   banner. `Tools/opsboard/UseSourceBoard.ps1 -Replace` is the switch-over;
   `-Undo` restores, and the original task XML is exported to
   `Tools/opsboard/_main_task_backup.xml` first.

2. **Claude is an MSIX package and must be launched by AppUserModelID**, not by
   path — `shell:AppsFolder\Claude_pzs8sxrjxfjjc!Claude` handed to
   `explorer.exe`. Its exe lives under `C:\Program Files\WindowsApps`, which is
   ACL-locked and carries a version that changes on every update. The old path
   search had resolved `ready: true` against a **stale staged copy in
   `WindowsApps.tmp` — version 1.8555.1.0 while the installed package was
   2.2553.1.0**. See [[feedback_ready_true_is_not_proof_it_launches]].

3. **Neither `pythonw.exe` nor `cmd.exe /c` can run this server from a task.**
   `pythonw` has no console, so once the server has written enough to stdout the
   write blocks forever — a board that LISTENS AND DOES NOT SERVE, the worst
   shape a fault can take because it looks alive from outside. `cmd /c` mis-parses
   the nested quotes in `/c ""py" -u "server.py" >> "log" 2>&1"` and returns
   `0x1` instantly with nothing written. Hence `server.py --log`.

4. **`_SNAPSHOT_TTL_S` was 4.0 seconds on a 32-second computation**, so every
   5-second page poll rebuilt from scratch and no panel ever painted.
   `collect_snapshot` shells out to `agent_comms.py board` (**17 s**) and
   `triage --no-fetch` (**7 s**). Now 60 s, warmed in a daemon thread after the
   socket binds (never before — the task probes the port within 20 s and would
   tear the board down as failed), and **stale-while-revalidate** so no reader
   ever waits. 32.6 s → 0.0028 s.

**The security shape is unchanged and must stay that way:** `/api/launch` takes
a target NAME from `AgentComms/launch_targets.json` and nothing else — never a
path or a command — because the board binds 0.0.0.0 on the LAN with no
authentication. Adding a target is a commit.
