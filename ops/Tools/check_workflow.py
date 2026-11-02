"""check_workflow.py - the operator's six workflow controls (S115, 2026-09-28), checked mechanically.

    python Tools/check_workflow.py                 # all roadmap/ledger checks; exit 1 on any defect
    python Tools/check_workflow.py branch <branch> <TASK_file_or_id>
                                                   # files the branch changes vs the task's `## Owned files`

The operator: "Enforce what can be checked mechanically ... automated checks can actually reject some violations."
`agent_comms.py start` prints these defects; `agent_comms.py ship` REFUSES while any remain. Do not weaken a check to
make a session pass - fix the record.
"""
import fnmatch
import contextlib
import io
import os
import json
import re
import subprocess
import sys
import tarfile
import tempfile
import shutil
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
ROADMAP = ROOT / "AgentComms" / "roadmap.json"
LEDGER = ROOT / "research" / "DECISION_LEDGER.md"
RESEARCH = ROOT / "research"

RESUME_FIELDS = ["last_working_commit", "verified_playable", "incomplete_blocked", "next_action",
                 "next_acceptance", "awaiting_operator"]
DONE_STATES = ("DONE", "MERGED", "LANDED")


def _git(*args):
    return subprocess.run(["git", *args], cwd=ROOT, capture_output=True, text=True, encoding="utf-8", errors="replace")


def roadmap_defects(plan=None):
    plan = plan if plan is not None else json.loads(ROADMAP.read_text(encoding="utf-8"))
    out = []
    # 1. one agreed definition of the finished game
    rel = plan.get("release", {})
    for key in ("definition", "done_means", "active"):
        if not rel.get(key):
            out.append("release.%s missing (control 1: one agreed definition of the finished game)" % key)
    ## The milestones ARE the ops board's roadmap stages (A-E) - never a second list.
    ms = plan.get("stages", [])
    if rel.get("milestones"):
        out.append("release.milestones exists - a second roadmap; the stages A-E are the milestones (operator 2026-09-28)")
    active = [m for m in ms if str(m.get("state", "")).upper() == "ACTIVE"]
    if len(active) != 1:
        out.append("exactly ONE stage must be ACTIVE, found %d (control 3)" % len(active))
    elif active[0].get("id") != rel.get("active"):
        out.append("release.active=%s but the ACTIVE stage is %s" % (rel.get("active"), active[0].get("id")))
    if len(active) == 1 and not (active[0].get("active_milestone") or {}).get("finish_line"):
        out.append("the ACTIVE stage %s has no active_milestone.finish_line (control 3)" % active[0].get("id"))
    for m in ms:
        if not m.get("done_when"):
            out.append("stage %s has no done_when (control 3)" % m.get("id"))
        # 5. evidence before done: DONE needs player-flow evidence that exists on disk
        if str(m.get("state", "")).upper() == "DONE":
            ev = str(m.get("flow_evidence", "")).strip()
            paths = [t for t in re.findall(r"[\w./\-]+\.(?:mp4|png|jpg|txt|md|json)", ev)]
            if not ev or not paths or not all((ROOT / p).exists() for p in paths):
                out.append("stage %s is DONE without flow_evidence files on disk (control 5: a test or a render "
                           "is not the player flow)" % m.get("id"))
    # 3. every assigned task says how it advances the ACTIVE milestone; the rest is backlog
    act = rel.get("active")
    for t in plan.get("queue", {}).get("tasks", []):
        tid = t.get("id", "?")
        if not t.get("milestone") or not t.get("advances"):
            out.append("queue task %s lacks milestone/advances (control 3)" % tid)
        elif t["milestone"] != act and not str(t.get("state", "")).upper().startswith(DONE_STATES) \
                and str(t.get("advances")) != "done":
            out.append("queue task %s serves %s, not the active %s - move it to queue.backlog (control 3)"
                       % (tid, t["milestone"], act))
    # 4. a precise resume point
    now = plan.get("now", {})
    for f in RESUME_FIELDS:
        if f not in now or (f != "awaiting_operator" and not str(now.get(f, "")).strip()):
            out.append("now.%s missing (control 4: precise resume point)" % f)
    commit = str(now.get("last_working_commit", "")).strip()
    # S295: since the lean restart the game's commits live in E:\FightCamp\Lean, written "Lean <sha>".
    repo = ROOT
    if commit.startswith("Lean "):
        repo = ROOT.parent / "Lean"
        commit = commit[len("Lean "):].strip()
    if commit and subprocess.run(["git", "cat-file", "-e", commit + "^{commit}"], cwd=repo, capture_output=True).returncode != 0:
        out.append("now.last_working_commit %s is not a commit in %s" % (commit, repo.name))
    return out


def ledger_defects():
    out = []
    if not LEDGER.exists():
        return ["DECISION_LEDGER.md missing (control 2)"]
    rows = [l for l in LEDGER.read_text(encoding="utf-8").splitlines() if re.match(r"^\| D\d+ \|", l)]
    if not rows:
        out.append("no settled-decision rows (| Dn | ...) in DECISION_LEDGER.md (control 2)")
    for l in rows:
        cells = [c.strip() for c in l.strip().strip("|").split("|")]
        if len(cells) < 4 or not all(cells[:4]):
            out.append("settled decision %s lacks decision/reason/reopen-evidence (control 2)" % cells[0])
    return out


def _owned_patterns(task_path: Path):
    text = task_path.read_text(encoding="utf-8", errors="replace")
    ## S132: the heading may carry a note ("## Owned files (edit ONLY these; ...)") or read "## Owned (...)" - five
    ## S131 room briefs did, and the gate refused a clean branch as having no section at all.
    m = re.search(r"^## Owned(?: files)?\b[^\n]*\n(.*?)(?=^## |\Z)", text, re.S | re.M)
    if not m:
        return None
    pats = []
    ## Everything after "Read-only" names files the task may NOT touch.
    owned_text = re.split(r"read-only", m.group(1), flags=re.I)[0]
    ## Paths come in backticks or as the first word of a bullet ("- Godot/x.gd (new)");
    ## S123's U197 brief used bare bullets and the gate read it as owning nothing.
    toks = re.findall(r"`([^`]+)`", owned_text)
    toks += re.findall(r"^\s*[-*]\s+([^\s`(]+)", owned_text, re.M)
    for tok in toks:
        tok = tok.strip()
        if ("/" in tok or tok.endswith((".gd", ".md", ".json", ".py"))) and tok not in pats and tok + "*" not in pats:
            pats.append(tok if not tok.endswith("/") else tok + "*")
    return pats


def branch_defects(branch: str, task: str):
    tp = Path(task) if Path(task).exists() else next(iter(sorted(RESEARCH.glob("TASK_%s*.md" % task))), None)
    if tp is None:
        return ["task file for %s not found" % task]
    pats = _owned_patterns(Path(tp))
    if pats is None:
        return ["%s has no '## Owned files' section - the branch cannot be checked (control 6)" % Path(tp).name]
    if not pats:
        return ["%s '## Owned files' names no path the gate can read - the branch cannot be checked (control 6)" % Path(tp).name]
    base = _git("merge-base", "master", branch).stdout.strip()
    files = [f for f in _git("diff", "--name-only", base, branch).stdout.splitlines() if f]
    allowed_always = ("AgentComms/mail/", "AgentComms/messages/", "research/", ".import", ".uid")
    out = []
    for f in files:
        if any(a in f for a in allowed_always):
            continue
        name = f.split("/")[-1]
        if not any(fnmatch.fnmatch(f, p) or fnmatch.fnmatch(f, "Godot/" + p) or fnmatch.fnmatch(name, p)
                   or f.startswith(p.rstrip("*")) or ("Godot/" + p.rstrip("*")) in f for p in pats):
            out.append("%s changes %s, outside %s's owned files %s" % (branch, f, Path(tp).stem, pats))
    return out


def _branch_files(base: str, branch: str):
    return [f for f in _git("diff", "--name-only", base, branch).stdout.splitlines() if f]


def _force_rmtree(path) -> None:
    """S249 (E: fell to 11 GB: 23 GB of fightcamp-branch-gate-* clones were never deleted): TemporaryDirectory.cleanup dies on the
    read-only files a checkout/.godot copy holds on Windows. Clear the read-only bit and retry each failed entry."""
    import stat

    def _retry(func, target, _exc):
        try:
            os.chmod(target, stat.S_IWRITE)
            func(target)
        except OSError:
            pass
    if path and Path(path).exists():
        shutil.rmtree(path, onexc=_retry) if sys.version_info >= (3, 12) else shutil.rmtree(path, onerror=_retry)


def _branch_worktree(branch: str, light: bool = False, changed_files=None):
    rows = _git("worktree", "list", "--porcelain").stdout.splitlines()
    found, path = False, None
    for row in rows:
        if row.startswith("worktree "):
            path = Path(row[9:])
            found = False
        elif row == "branch refs/heads/" + branch:
            found = True
        elif not row and found and path:
            return path, None
    if found and path:
        return path, None
    if _git("branch", "--show-current").stdout.strip() == branch:
        return ROOT, None
    # Some branches have no registered worktree. Materialize the exact branch
    # tree in a temporary checkout so parser/test commands never inspect ROOT.
    # GATES1B (S189): never on C: - the .godot cache copy below is ~4 GB and C: is the Windows drive (CLAUDE.md s4).
    tmp_root = Path(os.environ.get("FIGHTCAMP_GATE_TMP", "E:/FightCamp/tmp"))
    tmp = tempfile.TemporaryDirectory(prefix="fightcamp-branch-gate-", dir=str(tmp_root) if tmp_root.is_dir() else None,
                                      ignore_cleanup_errors=True)
    try:
        return _fill_gate_clone(tmp, branch, light, changed_files)
    except BaseException:
        _force_rmtree(tmp.name)  # S249: a failed archive/copy never leaves its ~8 GB clone behind
        raise


def _fill_gate_clone(tmp, branch: str, light: bool, changed_files):
    # S194: a cloud agent's branch (qwen/issue-N, arena/*) often exists only on origin - archive that ref.
    ref = branch
    if subprocess.run(["git", "rev-parse", "--verify", "--quiet", f"refs/heads/{branch}"], cwd=ROOT,
                      capture_output=True).returncode != 0:
        ref = f"origin/{branch}"
    paths = None
    if light:
        paths = ["Godot/project.godot", "Godot/scripts", "Godot/addons", "Godot/tools", "Godot/assets/fonts"]
        paths.extend(f for f in (changed_files or []) if f.startswith("Godot/") and f.endswith(".gd")
                     and subprocess.run(["git", "cat-file", "-e", f"{ref}:{f}"], cwd=ROOT,
                                        capture_output=True).returncode == 0)
    cmd = ["git", "archive", ref] + (paths or [])
    archive = subprocess.run(cmd, cwd=ROOT, capture_output=True, check=True).stdout
    with tarfile.open(fileobj=io.BytesIO(archive), mode="r:") as bundle:
        bundle.extractall(tmp.name, filter="data")
    cache = ROOT / "Godot" / ".godot"
    if cache.is_dir():
        shutil.copytree(cache, Path(tmp.name) / "Godot" / ".godot", dirs_exist_ok=True)
    project = Path(tmp.name) / "Godot" / "project.godot"
    if project.is_file():
        tools_dir = str(ROOT / "Godot" / "tools")
        if tools_dir not in sys.path:
            sys.path.insert(0, tools_dir)
        import check_scripts
        try:
            subprocess.run([check_scripts._find_godot(), "--headless", "--editor", "--path", str(project.parent), "--quit"],
                           cwd=project.parent, capture_output=True, text=True, timeout=120,
                           creationflags=getattr(subprocess, "CREATE_NO_WINDOW", 0))
        except (OSError, subprocess.TimeoutExpired):
            pass
    return Path(tmp.name), tmp


def _test_names(worktree: Path, files: list[str], branch: str):
    tests = set()
    for path in files:
        if path.startswith("Godot/tests/") and path.endswith(".gd"):
            tests.add(Path(path).stem)
        if not path.endswith(".gd") or path.startswith("Godot/tests/"):
            continue
        name = Path(path).name
        # Search test sources for path references and their class_name token.
        source = subprocess.run(["git", "show", f"{branch}:{path}"], cwd=ROOT,
                                capture_output=True, text=True, encoding="utf-8", errors="replace").stdout
        cls = re.search(r"^\s*class_name\s+(\w+)", source, re.M)
        pattern = re.escape(name) + ("|" + re.escape(cls.group(1)) if cls else "")
        r = subprocess.run(["git", "grep", "-l", "-E", pattern, branch, "--", "Godot/tests"], cwd=ROOT,
                           capture_output=True, text=True, encoding="utf-8", errors="replace")
        tests.update(Path(p.split(":", 1)[-1].replace("\\", "/")).stem for p in r.stdout.splitlines())
    tests = {n for n in tests if subprocess.run(["git", "cat-file", "-e", f"{branch}:Godot/tests/{n}.gd"],
                                                 cwd=ROOT, capture_output=True).returncode == 0}
    return sorted(tests)


def _loosened_lines(base: str, branch: str, files: list[str]):
    out = []
    num = re.compile(r"(?<![\w.])(?:\d+(?:\.\d+)?|\.\d+)(?![\w.])")
    for path in files:
        if not path.startswith("Godot/tests/") or not path.endswith(".gd"):
            continue
        diff = _git("diff", "--unified=0", base, branch, "--", path).stdout
        removed, added = [], []
        def report_hunk():
            for before, after in zip(removed, added):
                risky = r"_check\s*\(|\bconst\b|\b(?:FLOOR|BAND|MIN|MAX|THRESHOLD)\w*\b"
                if not re.search(risky, before) or not re.search(risky, after):
                    continue
                ov, nv = num.findall(before), num.findall(after)
                if ov != nv:
                    out.append(f"LOOSENED? {path}: {', '.join(ov) or '(none)'} -> {', '.join(nv) or '(none)'} | {before.strip()} => {after.strip()}")
            removed.clear()
            added.clear()
        for line in diff.splitlines():
            if line.startswith("@@"):
                report_hunk()
            elif line.startswith("-") and not line.startswith("---"):
                removed.append(line[1:])
            elif line.startswith("+") and not line.startswith("+++"):
                added.append(line[1:])
        report_hunk()
    return out


def branch_gate(branch: str, task: str, no_tests: bool = False):
    base = _git("merge-base", "master", branch).stdout.strip()
    files = _branch_files(base, branch)
    ownership = branch_defects(branch, task)
    outside = [re.search(r" changes (.*?), outside ", x).group(1) for x in ownership
               if re.search(r" changes (.*?), outside ", x)]
    owned_files = [f for f in files if f not in outside]
    changed_gd = [f for f in files if f.endswith(".gd")]
    selected_tests = [] if no_tests else _test_names(ROOT, files, branch)
    too_broad = not no_tests and len(selected_tests) > 25
    wt, temporary_worktree = _branch_worktree(branch, light=too_broad, changed_files=files)
    try:
        return _branch_gate_in(wt, branch, base, files, ownership, outside, owned_files, changed_gd, selected_tests, too_broad, no_tests)
    finally:
        ## S249: the clone goes on EVERY exit (an exception, a Ctrl+C, a test hang killed) - not only after the summary
        if temporary_worktree:
            _force_rmtree(temporary_worktree.name)


def _branch_gate_in(wt, branch, base, files, ownership, outside, owned_files, changed_gd, selected_tests, too_broad, no_tests):
    parse_lines, tests_ran, failures = [], [], []
    if changed_gd:
        rel = [str(Path(f).relative_to("Godot")).replace("\\", "/") for f in changed_gd if f.startswith("Godot/")]
        if rel:
            p = subprocess.run([sys.executable, "Godot/tools/check_scripts.py", *rel], cwd=wt, capture_output=True, text=True, encoding="utf-8", errors="replace")
            parse_lines = (p.stdout + p.stderr).splitlines()
            if p.returncode:
                failures.append("parse gate failed")
    else:
        parse_lines = ["no changed .gd files"]
    if not no_tests:
        names = selected_tests
        if too_broad:
            print("TOO BROAD - Claude picks")
        else:
            for name in names:
                p = subprocess.run([sys.executable, "Godot/tools/run_tests.py", "--jobs", "2", "--only", name],
                                   cwd=wt, capture_output=True, text=True, encoding="utf-8", errors="replace")
                output = p.stdout + p.stderr
                suite = [x for x in output.splitlines() if "SUITE " in x]
                tests_ran.append((name, suite[-1] if suite else f"exit={p.returncode}"))
                if p.returncode or any("FAIL" in x for x in output.splitlines()):
                    failures.append("test failed: " + name)
    else:
        tests_ran.append(("--no-tests", "skipped"))
    guard_io = io.StringIO()
    with contextlib.redirect_stdout(guard_io):
        if str(ROOT / "Tools") not in sys.path:
            sys.path.insert(0, str(ROOT / "Tools"))
        from ci_arena import guard_for
        guard_result = guard_for(base, branch, prefix="DEFECT:", shrink=0.30)
    guard_output = guard_io.getvalue().splitlines()
    if guard_result:
        failures.extend(x.removeprefix("DEFECT:") for x in guard_output if x.startswith("DEFECT:"))
    loosened = _loosened_lines(base, branch, files)
    failures.extend(ownership)
    print("BRANCH GATE SUMMARY")
    print("Files changed (owned): " + (", ".join(owned_files) or "none"))
    print("Files changed (outside): " + (", ".join(outside) or "none"))
    print("Parse: " + ("FAIL" if any("parse gate failed" == x for x in failures) else "PASS"))
    if "parse gate failed" in failures:
        for line in parse_lines[:8]:
            print("  " + line)
    for name, result in tests_ran:
        print(f"Test {name}: {result}")
    for line in loosened:
        print(line)
    for line in guard_output:
        if not line.startswith("test kept:"):
            print(line)
    print("Verdict: " + ("NOT MERGEABLE" if failures else "MERGEABLE"))
    return failures


def main(argv):
    if len(argv) >= 3 and argv[0] == "branch":
        no_tests = "--no-tests" in argv[3:]
        bad = branch_gate(argv[1], argv[2], no_tests)
    else:
        bad = roadmap_defects() + ledger_defects()
    for b in bad:
        print("WORKFLOW DEFECT: " + b)
    print("CHECK_WORKFLOW defects=%d" % len(bad))
    return 1 if bad else 0


if __name__ == "__main__":
    sys.exit(main(sys.argv[1:]))
