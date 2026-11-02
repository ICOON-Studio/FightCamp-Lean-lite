"""Where a launchable app lives on this PC, and how to start it. ONE definition.

Both the ops board (`Tools/opsboard/server.py`) and `Tools/agent_comms.py` need this, and a whitelist copied into a
second place is exactly the defect that cost this project a day when `FightClipBinding`'s metadata copy silently dropped
`native_speed_mps` and every walk refused. So it lives here once and both import it.

THE REQUEST NEVER CARRIES A PATH OR A COMMAND. Callers pass a target NAME that must already exist in
`AgentComms/launch_targets.json`; everything executed comes from that file. The board binds 0.0.0.0 with no
authentication, which is how the operator's phone reaches it, so a launcher that ran what it was told would be a remote
shell on the house network. Adding a target is a commit.
"""
from __future__ import annotations

import json
import os
import subprocess
from pathlib import Path
from typing import Any

CONFIG_RELATIVE = Path("AgentComms") / "launch_targets.json"


def load_targets(root: Path) -> list[dict[str, Any]]:
    path = root / CONFIG_RELATIVE
    if not path.is_file():
        return []
    try:
        doc = json.loads(path.read_text(encoding="utf-8"))
    except (OSError, json.JSONDecodeError):
        return []
    rows = doc.get("targets", []) if isinstance(doc, dict) else []
    return [row for row in rows if isinstance(row, dict) and str(row.get("id", ""))]


def expand(raw: str) -> str:
    """%LOCALAPPDATA%-style expansion that also survives the variable being unset."""
    return os.path.expandvars(os.path.expanduser(str(raw))).replace("\\", "/")


def _shallow_find(roots: list[str], names: list[str], max_depth: int) -> Path | None:
    """A depth-bounded walk, so a target that moved between installer versions is still found without scanning a disk."""
    wanted = {name.lower() for name in names}
    for root_raw in roots:
        root = Path(expand(root_raw))
        if "%" in str(root) or not root.is_dir():
            continue
        stack: list[tuple[Path, int]] = [(root, 0)]
        while stack:
            here, depth = stack.pop()
            try:
                entries = list(here.iterdir())
            except OSError:
                continue
            for entry in entries:
                try:
                    if entry.is_file() and entry.name.lower() in wanted:
                        return entry
                    if entry.is_dir() and depth < max_depth and not _is_staging(entry):
                        stack.append((entry, depth + 1))
                except OSError:
                    continue
    return None


## A HALF-FINISHED INSTALL MUST NEVER WIN THE SEARCH.
##
## `C:\Program Files\WindowsApps.tmp` is where Windows stages an MSIX while it
## updates, and it is NOT cleaned up. On this PC it held **Claude 1.8555.1.0**
## while the installed package was **2.2553.1.0**, and because the walk hit the
## `.tmp` tree first the board resolved `ready: true` against a stale binary a
## year out of date. A green button that starts the wrong app is worse than one
## that admits it cannot find anything.
def _is_staging(entry: Path) -> bool:
    name = entry.name.lower()
    return name.endswith(".tmp") or name.endswith(".old") or name.startswith("$")


SHELL_APPS_FOLDER = "shell:AppsFolder\\"


def _installed_package(aumid: str) -> str:
    """The installed package directory for an AppUserModelID, or "".

    An AUMID is `<Name>_<publisherhash>!<AppId>`, and the package unpacks to
    `%PROGRAMFILES%/WindowsApps/<Name>_<version>_<arch>__<publisherhash>`. The
    version moves on every update, so the check globs on the two halves that do
    not - which is also what makes it survive the next Claude release.
    """
    family = aumid.split("!", 1)[0]
    if "_" not in family:
        return ""
    name, _, publisher = family.rpartition("_")
    if not name or not publisher:
        return ""
    store = Path(expand("%PROGRAMFILES%/WindowsApps"))
    if not store.is_dir():
        return ""
    try:
        hits = sorted(store.glob("%s_*__%s" % (name, publisher)))
    except OSError:
        return ""
    return str(hits[-1]) if hits else ""


def resolve(target: dict[str, Any]) -> dict[str, Any]:
    """Where this target lives, or every place it was looked for - an absence has to be diagnosable from a phone."""
    tried: list[str] = []
    found: Path | None = None

    ## A PACKAGED (MSIX/Store) APP IS NOT A FILE YOU CAN RUN, and Claude is one.
    ##
    ## Its exe lives under `C:\Program Files\WindowsApps`, which is ACL-locked -
    ## handing that path to explorer does not reliably start the app, and the
    ## path itself carries a version that changes under you. The supported way
    ## in is the AppUserModelID through the Apps folder, which is what a Start
    ## menu tile is. So an `aumid` target resolves to `shell:AppsFolder\<aumid>`
    ## and readiness is "the package is installed", not "a file exists".
    aumid = str(target.get("aumid", "")).strip()
    if aumid and os.name == "nt":
        package = _installed_package(aumid)
        tried.append("package %s (AppUserModelID %s)" % (package or "NOT INSTALLED", aumid))
        if package:
            return {
                "id": str(target.get("id", "")),
                "label": str(target.get("label", target.get("id", ""))),
                "why": str(target.get("why", "")),
                "found": SHELL_APPS_FOLDER + aumid,
                "ready": True,
                "tried": tried,
                "windows_only": False,
            }
    for candidate in target.get("candidates", []) or []:
        expanded = expand(str(candidate))
        tried.append(expanded)
        if "%" in expanded:
            continue
        if Path(expanded).is_file():
            found = Path(expanded)
            break
    if found is None:
        search = target.get("search", {}) or {}
        roots = [str(r) for r in (search.get("roots", []) or [])]
        names = [str(n) for n in (search.get("names", []) or [])]
        if roots and names:
            depth = int(search.get("max_depth", 2))
            tried.append("search %s for %s (depth %d)" % (
                ", ".join(expand(r) for r in roots), "/".join(names), depth))
            found = _shallow_find(roots, names, depth)
    return {
        "id": str(target.get("id", "")),
        "label": str(target.get("label", target.get("id", ""))),
        "why": str(target.get("why", "")),
        "found": str(found) if found else "",
        "ready": found is not None,
        "tried": tried,
        "windows_only": os.name != "nt",
    }


def launch(root: Path, target_id: str) -> dict[str, Any]:
    target = next((t for t in load_targets(root) if str(t.get("id", "")) == target_id), None)
    if target is None:
        return {"ok": False, "error": "unknown target", "id": target_id}
    if os.name != "nt":
        return {"ok": False, "id": target_id,
                "error": "not running on Windows, so there is nothing here to start"}
    info = resolve(target)
    if not info["ready"]:
        return {"ok": False, "error": "not found on this PC", "id": target_id, "tried": info["tried"]}

    found = info["found"]
    ## THROUGH EXPLORER, AND THIS IS NOT A DETAIL. The ops board's scheduled task
    ## runs -LogonType S4U (its README: pre-logon start), which is a
    ## NON-INTERACTIVE session - a GUI started directly from there can end up
    ## with no desktop to draw on. Handing the path to the logged-on user's own
    ## shell is the ordinary way round that, and it is also the only way to run
    ## a .lnk without turning on a shell and thereby handing this function a
    ## command line.
    explorer = expand("%WINDIR%/explorer.exe")
    gui = bool(target.get("gui", True))
    if found.startswith(SHELL_APPS_FOLDER):
        ## Handed to explorer VERBATIM. It is an Apps-folder moniker, not a path,
        ## so the usual slash flip would corrupt it - and it is still one argv
        ## entry, never a shell string, so nothing here can become a command.
        args = [explorer, found]
    elif found.lower().endswith(".lnk") or gui:
        args = [explorer, found.replace("/", "\\")]
    else:
        args = [found]
    for extra in target.get("args", []) or []:
        args.append(str(root) if str(extra) == "<repo_root>" else expand(str(extra)))

    try:
        ## DETACHED: the app must outlive whatever started it, and must never
        ## take the board or agent_comms down with it.
        subprocess.Popen(  # noqa: S603
            args,
            cwd=str(root),
            shell=False,
            close_fds=True,
            creationflags=getattr(subprocess, "DETACHED_PROCESS", 0)
            | getattr(subprocess, "CREATE_NEW_PROCESS_GROUP", 0),
        )
    except OSError as exc:
        return {"ok": False, "error": str(exc), "id": target_id, "ran": args}
    return {"ok": True, "id": target_id, "ran": args, "found": found}
