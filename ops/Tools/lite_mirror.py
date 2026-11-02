"""Code-only mirror of FightCamp for Arena (S264).

Operator S264, after Arena's sandbox failed to clone the repo again: "this is happening every session, find a way this
cannot happen again". Cause: ICOON-Studio/FightCamp is 6.7 GB (GitHub size; the master tree alone is 3.7 GB - 1.8 GB of
preview videos under Godot/docs, 664 MB of research captures, models, audio). Arena clones it whole for every new chat
and its sandbox times out at random ("git clone failed: Cloning into '/home/user/FightCamp'...").

Fix: Arena works on ICOON-Studio/FightCamp-lite instead - the master tree with every binary, video, baked animation and
big file left out (~90 MB, short history). Paths are identical, so a lite diff applies to master as it is.

  push    build the lite tree from origin/master and push it to FightCamp-lite master (a no-op when nothing changed).
          One lite commit per source commit, trailer `Lite-Source: <master sha>`.
  relay   every open FightCamp-lite PR -> the same branch name on ICOON-Studio/FightCamp (its diff applied onto the
          master commit it was built from, plumbing only - no working tree is touched) + a PR there with the same title
          and body. CI, auto_collect, collect_ready, ci_arena guard and check_workflow then see a normal arena/* PR.
          A lite PR whose relayed PR is merged or closed is closed on the lite side too.
  sync    push + relay (the 30-min reconcile runs this).
  status  print the lite head, its source and the relay table.

State: AgentComms/lite_relay.json. Never deletes anything on the main repo; force-pushes only the relayed arena/*
branches it created itself.
"""
from __future__ import annotations

import json
import os
import re
import subprocess
import sys
import tempfile
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
MAIN_REPO = "ICOON-Studio/FightCamp"
LITE_REPO = "ICOON-Studio/FightCamp-lite"
LITE_URL = "https://github.com/%s.git" % LITE_REPO
BRANCH = "master"
LITE_REF = "refs/lite/master"
STATE = ROOT / "AgentComms" / "lite_relay.json"
MAX_BLOB = 2 * 1024 * 1024
_NO_WINDOW = getattr(subprocess, "CREATE_NO_WINDOW", 0)

SKIP_PREFIX = (
    "Godot/docs/", "Godot/assets/anim/", "AssetLibrary/", "Tools/cascadeur/", "AgentComms/prompts/", "AgentComms/backup/",
    "AgentComms/nightly/", ".github/",  # .github: CI runs once, on the relayed PR in the main repo
)
SKIP_PART = ("/_captures/",)
SKIP_EXT = set((
    "png jpg jpeg webp gif bmp tif tiff mp4 mov webm mkv avi m4v mp3 wav ogg flac aac glb gltf fbx bin blend blend1 exr "
    "hdr ttf otf woff woff2 zip 7z gz tgz rar uasset umap pdf psd tga dds ktx ktx2 res scn npz npy pt pth onnx import "
    "bvh c3d abc usd usdc usdz obj mtl dna exe dll so dylib svg ico xcf kra casc ma mb max pkl h5 safetensors"
).split())

LITE_README = """# FightCamp-lite (code-only mirror)

This repository is a CODE-ONLY mirror of ICOON-Studio/FightCamp master, built by Tools/lite_mirror.py.
Binary assets, videos, models, baked animations and preview captures are NOT here - every script, test, tool, brief
(research/TASK_*.md), data file and AGENTS.md is, at the same paths.

Work on your own branch and open the PR HERE, into master. It is relayed automatically to ICOON-Studio/FightCamp
(same branch name, same title and body), where CI runs and Claude reviews and merges. Never merge anything yourself.
Tests that load .glb/.fbx/.png/audio assets cannot run here (the same rule as CI: no LFS) - write pure-module tests.
"""


def _git(args, *, env=None, input_text=None, check=True, timeout=600, raw=False):
    """Bytes in, bytes out (text-mode pipes on Windows turn \\n into \\r\\n and corrupt --index-info / patches)."""
    e = dict(os.environ)
    if env:
        e.update(env)
    data = input_text.encode("utf-8") if isinstance(input_text, str) else input_text
    p = subprocess.run(["git"] + args, cwd=str(ROOT), capture_output=True, input=data, env=e, timeout=timeout,
                       creationflags=_NO_WINDOW)
    if check and p.returncode != 0:
        raise RuntimeError("git %s failed: %s" % (" ".join(args[:3]),
                                                  (p.stderr or p.stdout).decode("utf-8", "replace").strip()[:400]))
    return p.stdout if raw else p.stdout.decode("utf-8", "replace")


def _gh(args, check=True, timeout=120):
    p = subprocess.run(["gh"] + args, cwd=str(ROOT), capture_output=True, text=True, encoding="utf-8",
                       errors="replace", timeout=timeout, creationflags=_NO_WINDOW)
    if check and p.returncode != 0:
        raise RuntimeError("gh %s failed: %s" % (" ".join(args[:3]), (p.stderr or p.stdout).strip()[:400]))
    return p.stdout


def _load_state():
    try:
        return json.loads(STATE.read_text(encoding="utf-8"))
    except Exception:
        return {"_doc": "Tools/lite_mirror.py relay table: FightCamp-lite PR -> relayed branch/PR on FightCamp", "prs": {}}


def _save_state(st):
    STATE.write_text(json.dumps(st, indent=1, ensure_ascii=False) + "\n", encoding="utf-8")


def keep(path: str, size: int) -> bool:
    if path.startswith(SKIP_PREFIX) or any(s in "/" + path for s in SKIP_PART):
        return False
    ext = path.rsplit(".", 1)[-1].lower() if "." in path.rsplit("/", 1)[-1] else ""
    if ext in SKIP_EXT:
        return False
    return size <= MAX_BLOB


def _fetch_lite():
    """refs/lite/master <- FightCamp-lite master (absent on the very first push)."""
    p = subprocess.run(["git", "fetch", "--no-tags", LITE_URL, "+%s:%s" % (BRANCH, LITE_REF)], cwd=str(ROOT),
                       capture_output=True, text=True, timeout=600, creationflags=_NO_WINDOW)
    return p.returncode == 0


def _source_of(lite_commit: str) -> str:
    msg = _git(["log", "-1", "--format=%B", lite_commit])
    m = re.search(r"^Lite-Source: ([0-9a-f]{40})", msg, re.M)
    return m.group(1) if m else ""


def build_tree(src: str) -> tuple[str, int]:
    rows = _git(["ls-tree", "-r", "-l", "-z", "--full-tree", src])  # -z: raw paths, never C-quoted
    keep_lines, n = [], 0
    for line in rows.split("\0"):
        if not line:
            continue
        meta, path = line.split("\t", 1)
        mode, typ, sha, size = meta.split()
        if typ != "blob" or mode == "160000":
            continue
        if not keep(path, int(size) if size != "-" else 0):
            continue
        keep_lines.append("%s %s\t%s" % (mode, sha, path))
        n += 1
    ## S264: an LFS pointer in the mirror makes the agent's clone fetch (or fail on) the LFS object - leave every
    ## path whose .gitattributes filter is lfs out (the first push uploaded 5 AssetLibrary .unitypackage objects).
    paths = [ln.split("\t", 1)[1] for ln in keep_lines]
    attrs = _git(["check-attr", "-z", "--stdin", "filter"], input_text="\0".join(paths) + "\0").split("\0")
    lfs = {attrs[i] for i in range(0, len(attrs) - 2, 3) if attrs[i + 2] == "lfs"}
    if lfs:
        keep_lines = [ln for ln in keep_lines if ln.split("\t", 1)[1] not in lfs]
        n -= len(lfs)
    readme_sha = _git(["hash-object", "-w", "--stdin"], input_text=LITE_README).strip()
    keep_lines.append("100644 %s\tLITE_README.md" % readme_sha)
    with tempfile.TemporaryDirectory() as td:
        env = {"GIT_INDEX_FILE": str(Path(td) / "lite.index")}
        _git(["read-tree", "--empty"], env=env)
        _git(["update-index", "-z", "--index-info"], env=env, input_text="\0".join(keep_lines) + "\0")
        tree = _git(["write-tree"], env=env).strip()
    return tree, n


def push(force: bool = False) -> str:
    _git(["fetch", "--no-tags", "origin", BRANCH], timeout=600)
    src = _git(["rev-parse", "origin/" + BRANCH]).strip()
    have = _fetch_lite()
    parent = _git(["rev-parse", LITE_REF]).strip() if have else ""
    if parent and _source_of(parent) == src and not force:
        return "LITE_MIRROR up to date (lite %s = master %s)" % (parent[:8], src[:8])
    tree, n = build_tree(src)
    if parent and _git(["rev-parse", parent + "^{tree}"]).strip() == tree:
        return "LITE_MIRROR tree unchanged at master %s (no code change)" % src[:8]
    subject = _git(["log", "-1", "--format=%s", src]).strip()
    msg = "lite: %s\n\n%s\n\nLite-Source: %s\n" % (src[:8], subject[:200], src)
    args = ["commit-tree", tree, "-m", msg] + (["-p", parent] if parent else [])
    commit = _git(args, env={"GIT_AUTHOR_NAME": "FightCamp Dev", "GIT_COMMITTER_NAME": "FightCamp Dev"}).strip()
    _git(["push", LITE_URL, "%s:refs/heads/%s" % (commit, BRANCH)], timeout=900, env={"GIT_LFS_SKIP_PUSH": "1"})
    _git(["update-ref", LITE_REF, commit])
    return "LITE_MIRROR pushed %s (master %s, %d files)" % (commit[:8], src[:8], n)


def _relay_one(pr: dict, st: dict) -> str:
    num = str(pr["number"])
    rec = st["prs"].get(num, {})
    head = pr["headRefOid"]
    branch = pr["headRefName"]
    if rec.get("lite_head") == head and rec.get("main_pr"):
        return ""
    if rec.get("closed"):
        return ""
    local = "refs/lite/pr/%s" % num
    _git(["fetch", "--no-tags", LITE_URL, "+refs/pull/%s/head:%s" % (num, local)], timeout=600)
    base = _git(["merge-base", local, LITE_REF]).strip()
    src = _source_of(base)
    if not src:
        return "LITE_RELAY #%s skipped: its base %s has no Lite-Source" % (num, base[:8])
    diff = _git(["diff", "--binary", "--full-index", base, local], raw=True)
    if not diff.strip():
        return "LITE_RELAY #%s has no change yet" % num
    _git(["fetch", "--no-tags", "origin", src], check=False)
    with tempfile.TemporaryDirectory() as td:
        env = {"GIT_INDEX_FILE": str(Path(td) / "relay.index")}
        _git(["read-tree", src], env=env)
        _git(["apply", "--cached", "--binary", "-"], env=env, input_text=diff)
        tree = _git(["write-tree"], env=env).strip()
    msg = "%s\n\nRelayed from %s#%s @ %s (Tools/lite_mirror.py)\n" % (pr["title"], LITE_REPO, num, head[:12])
    commit = _git(["commit-tree", tree, "-p", src, "-m", msg]).strip()
    _git(["push", "--force", "origin", "%s:refs/heads/%s" % (commit, branch)], timeout=600)
    body = (pr.get("body") or "") + "\n\n---\nRelayed from %s#%s (branch `%s`, head %s) by Tools/lite_mirror.py - " \
        "Arena works on the code-only mirror; review and merge here.\n" % (LITE_REPO, num, branch, head[:12])
    if rec.get("main_pr"):
        _gh(["pr", "edit", str(rec["main_pr"]), "--repo", MAIN_REPO, "--body", body], check=False)
        out = "LITE_RELAY #%s -> %s#%s updated (%s)" % (num, MAIN_REPO, rec["main_pr"], commit[:8])
    else:
        url = _gh(["pr", "create", "--repo", MAIN_REPO, "--base", BRANCH, "--head", branch,
                   "--title", pr["title"], "--body", body]).strip()
        rec["main_pr"] = int(url.rstrip("/").rsplit("/", 1)[-1])
        out = "LITE_RELAY #%s -> %s (%s)" % (num, url, commit[:8])
        _gh(["pr", "comment", num, "--repo", LITE_REPO, "--body",
             "Relayed to %s - CI and review happen there." % url], check=False)
    rec.update({"branch": branch, "lite_head": head, "main_commit": commit, "source": src, "title": pr["title"]})
    st["prs"][num] = rec
    return out


def relay() -> list[str]:
    st = _load_state()
    out = []
    if not _fetch_lite():
        return ["LITE_RELAY lite repo not reachable"]
    prs = json.loads(_gh(["pr", "list", "--repo", LITE_REPO, "--state", "open", "--json",
                          "number,headRefName,headRefOid,title,body", "--limit", "50"]) or "[]")
    for pr in prs:
        try:
            line = _relay_one(pr, st)
        except Exception as exc:
            line = "LITE_RELAY #%s failed: %s" % (pr["number"], exc)
        if line:
            out.append(line)
    ## close the lite side once the relayed PR is merged or closed
    for num, rec in st["prs"].items():
        if rec.get("closed") or not rec.get("main_pr"):
            continue
        try:
            state = _gh(["pr", "view", str(rec["main_pr"]), "--repo", MAIN_REPO, "--json", "state", "--jq", ".state"]).strip()
        except Exception:
            continue
        if state in ("MERGED", "CLOSED"):
            _gh(["pr", "close", num, "--repo", LITE_REPO, "--comment",
                 "%s#%s is %s - closing the mirror PR." % (MAIN_REPO, rec["main_pr"], state.lower())], check=False)
            rec["closed"] = state
            out.append("LITE_RELAY #%s closed (%s#%s %s)" % (num, MAIN_REPO, rec["main_pr"], state))
    _save_state(st)
    return out


def sync() -> list[str]:
    lines = []
    try:
        lines.append(push())
    except Exception as exc:
        lines.append("LITE_MIRROR push failed: %s" % exc)
    try:
        lines += relay()
    except Exception as exc:
        lines.append("LITE_RELAY failed: %s" % exc)
    return lines


## S303 (operator Q-S294-6 "you fix both"): `--lean` runs the same mirror + relay for the restarted game -
## E:\FightCamp\Lean (ICOON-Studio/FightCamp-Lean, private) -> ICOON-Studio/FightCamp-Lean-lite (public, code only).
## Bought or licensed assets (MetaHuman bodies, Punch Pro clips, fonts) never go: their folders and extensions are skipped.
LEAN_README = """# FightCamp-Lean-lite (code-only mirror)

This repository is a CODE-ONLY mirror of ICOON-Studio/FightCamp-Lean main (a Godot 4.7.2 boxing-management game),
built by Tools/lite_mirror.py --lean. Models, animations, fonts and images are NOT here - every script, test, tool and
data file is, at the same paths. Read CLAUDE.md first: tests are pure rule-module tests (tests/*_test.gd), run with
  godot --headless --audio-driver Dummy --path . --script res://tests/<name>.gd

Work on your own branch and open the PR HERE, into main. It is relayed automatically to ICOON-Studio/FightCamp-Lean
(same branch name, same title and body), where Claude reviews and merges. Never merge anything yourself, and never
delete or weaken a test to go green.
"""


def _use_lean() -> None:
    global ROOT, MAIN_REPO, LITE_REPO, LITE_URL, LITE_REF, STATE, SKIP_PREFIX, LITE_README, BRANCH
    STATE = ROOT / "AgentComms" / "lite_relay_lean.json"
    ROOT = Path(r"E:\FightCamp\Lean")
    MAIN_REPO = "ICOON-Studio/FightCamp-Lean"
    LITE_REPO = "ICOON-Studio/FightCamp-Lean-lite"
    LITE_URL = "https://github.com/%s.git" % LITE_REPO
    LITE_REF = "refs/lite/main"
    BRANCH = "main"
    SKIP_PREFIX = ("assets/models/", "assets/anim/", "assets/fonts/", "Builds/", ".godot/", ".github/")
    LITE_README = LEAN_README


def main() -> int:
    if "--lean" in sys.argv:
        sys.argv.remove("--lean")
        _use_lean()
    cmd = sys.argv[1] if len(sys.argv) > 1 else "status"
    if cmd == "push":
        print(push(force="--force" in sys.argv))
    elif cmd == "relay":
        print("\n".join(relay()) or "LITE_RELAY nothing to relay")
    elif cmd == "sync":
        print("\n".join(sync()))
    elif cmd == "status":
        have = _fetch_lite()
        if have:
            head = _git(["rev-parse", LITE_REF]).strip()
            print("LITE head %s source %s" % (head[:8], _source_of(head)[:8]))
        print(json.dumps(_load_state().get("prs", {}), indent=1))
    else:
        print(__doc__)
        return 2
    return 0


if __name__ == "__main__":
    sys.exit(main())
