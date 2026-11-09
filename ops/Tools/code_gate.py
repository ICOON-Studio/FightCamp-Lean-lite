"""code_gate.py - the unattended merge gate for agent CODE PRs (S249; the fast lane, Tools/auto_collect.py, keeps pure ADD-only PRs).

Operator S249 asked how to stop Claude being the bottleneck on agent PRs. Decision: review moves to brief time (the brief's `## Contract`,
Tools/brief_contract.py), machines check the merge, a nightly auto-revert protects master (Tools/nightly_revert.py). Claude keeps briefs
and the exceptions this gate refuses; visual/body/animation/look PRs and money/taste/scope stay with the operator.

    python Tools/code_gate.py <pr>                 # dry run: every fact + MERGE or the refusal reasons
    python Tools/code_gate.py <pr> --act           # do the ONE next step: dispatch CI regression / send the Arena review / merge
    python Tools/code_gate.py queue [--act]        # every open agent PR in queue order; --act moves only the queue head forward
    python Tools/code_gate.py selftest             # one fixture that MERGES and one per refusal reason (no network)
    python Tools/code_gate.py arm --operator-said "<verbatim>"   # turn REAL merging on (refused before one clean nightly dry run)

MERGING IS OFF BY DEFAULT (operator S249: "Push, merge off"): --act dispatches CI and sends reviews, but a PR that passes every
check is only RECORDED as would_merge in AgentComms/code_gate.json. Real merging needs AgentComms/code_gate_armed.json (`arm`),
written only after one clean night and on the operator's own yes, quoted.
    flags: --any-state (evaluate a closed PR - proof only, never acts)  --master <sha> (treat <sha> as master - proof only)

MERGE only when ALL hold (each is one refusal reason, in this order):
  open            the PR is open and from an agent branch (arena/ grok/ cursor/ qwen/ goose/ opencode/ cline/ openhands/ codex/ ludo/)
  contract        its brief (TASK: <id> / TASK_<id>.md / id in title) has a valid `## Contract` on master
  protected       it touches no gate/tooling file (brief_contract.PROTECTED)
  visual          neither the brief (VISUAL: yes) nor its files (assets, scenes, rig/pose/anim/camera/look scripts) are visual -
                  a visual PR is NEVER merged by a machine: it is labelled `needs-operator-eye` for the visual-gate review packet
  owns            every changed file is in OWNS, and a windowed file's changed lines (master numbering) lie inside its windows
  guard           Tools/ci_arena.py guard (no deleted or gutted test)
  ci              every ci.yml check on the PR is SUCCESS
  ci_regression   a CODE_GATE_CI marker (github-actions) for THIS head, merged onto a base that is still master for code (no .gd change
                  on master since), RED_TEST red on that base (MISSING/FAIL) and PASS on the merge with its exact pass line, REGRESSION PASS
  review          a REVIEW_VERDICT APPROVE for THIS head (Arena via Tools/code_review.py, or a recorded Claude/operator verdict)
  queue           no older open agent PR touches any of the same files (merge queue: one at a time; the merge moves master, so the
                  next PR's CI marker goes stale and is re-run on the new master)
  mergeable       GitHub says the PR merges cleanly
A merge is `gh pr merge --squash --match-head-commit <sha>` (GitHub applies the diff; never whole files, never the shared checkout)
with the trailer `Auto-merged-by: code_gate` - the nightly auto-revert finds auto-merged commits by that trailer.
"""
from __future__ import annotations

import json
import re
import subprocess
import sys
import time
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
sys.path.insert(0, str(ROOT / "Tools"))
import brief_contract  # noqa: E402
import ci_arena  # noqa: E402
import code_review  # noqa: E402

REPO = "ICOON-Studio/FightCamp-Lean"
STATE = ROOT / "AgentComms" / "code_gate.json"
AGENT_PREFIXES = ("arena/", "grok/", "cursor/", "qwen/", "goose/", "opencode/", "cline/", "openhands/", "codex/", "ludo/", "cloud/",
                  "agy/", "ziva/")  # S368: Antigravity (seat_dispatch.py pushes agy/<id>) and Ziva land here too
TRAILER = "Co-Authored-By: Claude Opus 5.5 <noreply@anthropic.com>"
MERGED_TRAILER = "Auto-merged-by: code_gate"
BUDGET_RESERVE_USD = 3.0   # leave this much of the monthly Actions budget for ordinary CI + cloud agents
REDISPATCH_MIN = 60        # never dispatch the same (head, master) twice inside this many minutes
CI_MARK_RE = re.compile(r"CODE_GATE_CI pr=(\d+) head=(\S+) base=(\S+) task=(\S+) (.*?)(?:\n|$)")
## S368 Lean: the game is the repo root (scripts/, assets/); the archived old repo's Godot/ prefix is still read. Lean's 3D fight
## (scripts/fight3d/) and its screens (scripts/ui/) are pictures: every file there is visual.
VISUAL_FILE_RE = re.compile(
    r"(\.(tscn|tres|gdshader|glb|gltf|fbx|png|jpg|jpeg|webp|exr|hdr|obj|blend|res|anim|mp4)$)|"
    r"(^(Godot/)?(assets|scenes|shaders)/(?!data/))|(^(Godot/)?scripts/(fight3d|ui)/)|"
    r"(^(Godot/)?scripts/(?!rules/)(?:[^/]+/)*[^/]*(Rig|Pose|Anim|Glove|Body|Camera|Cam|Stage|3D|Shader|Material|Light|Look|Skin|"
    r"Mesh|Still|Render|Visual|Hud|HUD|Screen|Theme|Ui|UI|Panel|Browser|Page|Player|Film)[^/]*\.gd$)")


def _run(*args: str, check: bool = True) -> str:
    return subprocess.run(args, cwd=ROOT, check=check, capture_output=True, text=True, encoding="utf-8").stdout


# ---------------------------------------------------------------- the decision (pure: facts in, reasons out)

def decide(f: dict) -> list[str]:
    """Every refusal reason for one PR's facts, in gate order. [] = MERGE."""
    why: list[str] = []
    if f["state"] != "OPEN":
        why.append(f"open: PR is {f['state']}")
    if not f["branch"].startswith(AGENT_PREFIXES):
        why.append(f"open: {f['branch']} is not an agent branch")
    if not f["task"]:
        why.append("contract: no brief found (TASK: <id> line, TASK_<id>.md or an id in the title)")
        return why
    if f["contract_problems"]:
        why.append(f"contract: TASK_{f['task']}.md - {f['contract_problems'][0]}")
        return why
    c = f["contract"]
    prot = [p for p in f["files"] if p.startswith(brief_contract.PROTECTED) or p in brief_contract.PROTECTED]
    if prot:
        why.append(f"protected: touches gate/tooling {', '.join(prot[:3])}")
    vis = [p for p in f["files"] if VISUAL_FILE_RE.search(p)]
    if c.get("visual") or vis:
        why.append("visual: " + ("brief says VISUAL: yes" if c.get("visual") else f"visual files {', '.join(vis[:3])}") +
                   " - never auto-merged; visual-gate stills + the operator's OK (label needs-operator-eye)")
    owns = {o["path"]: o["windows"] for o in c["owns"]}
    for p in f["files"]:
        if p not in owns and any(o.endswith("/") and p.startswith(o) for o in owns):
            continue  # S368: a Lean contract may own a folder (docs/playtest/tells/)
        if p not in owns:
            why.append(f"owns: {p} is not in the brief's OWNS")
        elif owns[p]:
            outside = [r for r in f["hunks"].get(p, []) if not any(a <= r[0] and r[1] <= b for a, b in owns[p])]
            if outside:
                why.append(f"owns: {p} lines {outside[0][0]}-{outside[0][1]} outside its windows {owns[p]}")
    if not f["guard_ok"]:
        why.append("guard: ci_arena guard failed (a test was deleted or lost > 25% of its lines)")
    bad = [f"{n}={s}" for n, s in f["checks"] if s not in ("SUCCESS", "SKIPPED", "NEUTRAL")]  # S380: an `if:`-skipped job passes
    if not f["checks"]:
        why.append("ci: no ci.yml check ran on the PR")
    elif bad:
        why.append(f"ci: {', '.join(bad[:3])}")
    m = f["ci_marker"]
    if not m:
        why.append("ci_regression: no CODE_GATE_CI run for this head - dispatch code-gate.yml")
    elif m.get("skipped"):
        why.append("ci_regression: the CI run skipped (no valid contract seen on master)")
    else:
        if m["base"] != f["master"] and f["master_code_moved"]:
            why.append(f"ci_regression: stale - master changed code since base {m['base'][:10]}; re-run on the new master")
        if m.get("red_on_base") == "PASS":
            why.append(f"ci_regression: RED_TEST {c['red_test']['test']} already passes on master - it proves nothing")
        if m.get("red_test") != "PASS":
            why.append(f"ci_regression: RED_TEST {m.get('red_test')} on the merge")
        elif m.get("pass_line") != "FOUND":
            why.append(f"ci_regression: RED_TEST passed but its pass line '{c['red_test']['pass_line']}' is not in its log")
        if m.get("regression") != "PASS":
            why.append(f"ci_regression: REGRESSION new red on the merge: {m.get('new_red')}")
    if f["review"][0] != "APPROVE":
        why.append(f"review: {f['review'][0]} for this head" + (" (send: python Tools/code_review.py send %d)" % f["pr"]
                                                              if f["review"][0] == "NONE" else f" by {f['review'][1]}"))
    if f["ahead"]:
        why.append(f"queue: behind older PR #{f['ahead'][0][0]} touching {f['ahead'][0][1]}")
    if f["mergeable"] not in ("MERGEABLE", "UNKNOWN"):
        why.append(f"mergeable: GitHub says {f['mergeable']}")
    return why


# ---------------------------------------------------------------- facts (network + git)

def _hunks(base: str, head: str, path: str) -> list[list[int]]:
    """Old-side (master numbering) line ranges a PR's diff changes in one file."""
    out = []
    for m in re.finditer(r"^@@ -(\d+)(?:,(\d+))? \+\d+(?:,\d+)? @@", _run("git", "diff", "-U0", base, head, "--", path), re.M):
        start, count = int(m.group(1)), int(m.group(2) if m.group(2) is not None else 1)
        out.append([max(start, 1), max(start + count - 1, start)])  # a pure insertion (count 0) sits after `start`
    return out


def _ci_marker(comments: list[dict], pr: int, head: str) -> dict | None:
    found = None
    for c in comments:
        if (c.get("author") or {}).get("login") not in ("github-actions", "github-actions[bot]", "app/github-actions"):
            continue
        for m in CI_MARK_RE.finditer(c.get("body") or ""):
            if int(m.group(1)) != pr or (m.group(2) != head and m.group(2) != "-"):
                continue
            kv = dict(x.split("=", 1) for x in m.group(5).split() if "=" in x)
            found = {"head": m.group(2), "base": m.group(3), "task": m.group(4), **kv}
            if m.group(2) == "-":
                found["skipped"] = True
    return found


def open_agent_prs() -> list[dict]:
    prs = json.loads(_run("gh", "pr", "list", "--repo", REPO, "--state", "open", "--limit", "100", "--json",
                          "number,title,headRefName,files"))
    return sorted((p for p in prs if p["headRefName"].startswith(AGENT_PREFIXES) and not p["title"].startswith("REVIEW PR #")),
                  key=lambda p: p["number"])


def facts(pr: int, master: str | None = None, others: list[dict] | None = None) -> dict:
    info = json.loads(_run("gh", "pr", "view", str(pr), "--repo", REPO, "--json",
                           "number,title,body,headRefName,headRefOid,state,files,statusCheckRollup,comments,mergeable"))
    _run("git", "fetch", "--no-write-fetch-head", "-q", "origin", "main", f"refs/pull/{pr}/head")  # S368: Lean's default branch is main
    head = info["headRefOid"]
    master = master or _run("git", "rev-parse", "origin/main").strip()
    base = _run("git", "merge-base", master, head).strip()
    files = [ln.split("\t")[-1] for ln in _run("git", "diff", "--name-status", base, head).splitlines() if ln.strip()]
    task = brief_contract.task_for_pr(info["title"], info["body"], info["headRefName"])
    contract, problems = (brief_contract.check_brief(task) if task else (None, []))
    windowed = {o["path"] for o in (contract or {}).get("owns", []) if o["windows"]}
    marker = _ci_marker(info.get("comments") or [], pr, head)
    moved = False
    if marker and not marker.get("skipped") and marker["base"] != master:
        try:
            moved = bool(_run("git", "diff", "--name-only", marker["base"], master, "--", "*.gd").strip())
        except subprocess.CalledProcessError:
            moved = True
    others = open_agent_prs() if others is None else others
    mine = set(files)
    ahead = [(o["number"], sorted(mine & {x["path"] for x in o.get("files", [])})[0]) for o in others
             if o["number"] < pr and mine & {x["path"] for x in o.get("files", [])}]
    checks = [(c.get("name") or c.get("context") or "?", (c.get("conclusion") or c.get("state") or c.get("status") or "").upper())
              for c in info.get("statusCheckRollup") or [] if (c.get("workflowName") or "") != "Code gate CI"]
    import io, contextlib
    with contextlib.redirect_stdout(io.StringIO()):
        guard_ok = ci_arena.guard_for(base, head, prefix="GUARD ") == 0
    return {"pr": pr, "title": info["title"], "state": info["state"], "branch": info["headRefName"], "head": head, "master": master,
            "base": base, "files": files, "task": task, "contract": contract, "contract_problems": problems,
            "hunks": {p: _hunks(base, head, p) for p in files if p in windowed}, "guard_ok": guard_ok, "checks": checks,
            "ci_marker": marker, "master_code_moved": moved, "review": code_review.verdict_for(pr, head, info.get("comments") or []),
            "ahead": ahead, "mergeable": info.get("mergeable") or "UNKNOWN"}


# ---------------------------------------------------------------- actions

def _state() -> dict:
    try:
        return json.loads(STATE.read_text(encoding="utf-8"))
    except (OSError, ValueError):
        return {"dispatched": {}, "merged": [], "visual": {}, "log": []}


def _save(st: dict) -> None:
    st["log"] = st.get("log", [])[-200:]
    STATE.write_text(json.dumps(st, indent=1), encoding="utf-8")


ARMED = ROOT / "AgentComms" / "code_gate_armed.json"


def merge_armed() -> bool:
    """Real merging happens only with this file present: written by `arm`, after a clean night, on the operator's own yes."""
    try:
        return bool(json.loads(ARMED.read_text(encoding="utf-8")).get("operator_said"))
    except (OSError, ValueError):
        return False


def arm(argv: list[str]) -> int:
    said = argv[argv.index("--operator-said") + 1] if "--operator-said" in argv else ""
    if not said.strip():
        print("REFUSED: arm needs --operator-said \"<his words, verbatim>\" - merging goes on only on the operator's own yes")
        return 1
    try:
        nights = json.loads((ROOT / "AgentComms" / "nightly_revert.json").read_text(encoding="utf-8")).get("nights") or []
    except (OSError, ValueError):
        nights = []
    if not nights:
        print("REFUSED: no clean nightly dry run recorded yet (AgentComms/nightly_revert.json) - wait one night")
        return 1
    ARMED.write_text(json.dumps({"operator_said": said, "at": time.strftime("%Y-%m-%dT%H:%M:%S"), "after_night": nights[-1]["date"]},
                                indent=1), encoding="utf-8")
    print(f"ARMED: code_gate --act now merges (operator: \"{said}\"); disarm = delete {ARMED.relative_to(ROOT)}")
    return 0


def budget_left() -> float:
    """USD left in this month's Actions budget (hard stop) - read live, never remembered (it moved from $40 to $50 in S249)."""
    ym = time.strftime("%Y-%m").split("-")
    used = float(_run("gh", "api", f"organizations/ICOON-Studio/settings/billing/usage?year={ym[0]}&month={int(ym[1])}", "--jq",
                      '[.usageItems[] | select(.product=="actions") | .netAmount] | add // 0').strip() or 0)
    cap = float(_run("gh", "api", "organizations/ICOON-Studio/settings/billing/budgets", "--jq",
                     '[.budgets[] | select(.budget_product_sku=="actions") | .budget_amount] | max // 0').strip() or 0)
    return cap - used


def act(f: dict, why: list[str]) -> str:
    st = _state()
    stamp = time.strftime("%Y-%m-%dT%H:%M:%S")
    kinds = {w.split(":", 1)[0] for w in why}
    if not why and not merge_armed():
        ## S249 operator ("Push, merge off"): real merging is OFF until he says yes after a clean night. Record what WOULD merge.
        rec = {"pr": f["pr"], "task": f["task"], "head": f["head"], "master": f["master"], "at": stamp,
               "ci_run": (f["ci_marker"] or {}).get("run"), "review": list(f["review"])}
        would = st.setdefault("would_merge", [])
        if not any(w["pr"] == f["pr"] and w["head"] == f["head"] for w in would):
            would.append(rec)
            st["log"].append(f"{stamp} WOULD MERGE #{f['pr']} head {f['head'][:10]} (merging off)")
            _save(st)
        return f"WOULD MERGE #{f['pr']} - merging is OFF (dry run); recorded in AgentComms/code_gate.json would_merge"
    if not why:
        subject =f"S249 code-gate auto-merge PR #{f['pr']} (TASK_{f['task']}): {f['title']}"[:200]
        body = (f"Merged unattended by Tools/code_gate.py: contract OWNS {len(f['contract']['owns'])} files, CI regression run "
                f"{f['ci_marker'].get('run')} (RED_TEST {f['contract']['red_test']['test']} PASS, REGRESSION PASS), guard OK, "
                f"review {f['review'][0]} by {f['review'][1]}.\n\n{MERGED_TRAILER}\nTask: {f['task']}\nPR: #{f['pr']}\n"
                f"Regression: {','.join(f['contract']['regression'])}\n\n{TRAILER}")
        _run("gh", "pr", "merge", str(f["pr"]), "--repo", REPO, "--squash", "--match-head-commit", f["head"], "--subject", subject,
             "--body", body)
        sha = json.loads(_run("gh", "pr", "view", str(f["pr"]), "--repo", REPO, "--json", "mergeCommit"))["mergeCommit"]["oid"]
        st.setdefault("merged", []).append({"pr": f["pr"], "task": f["task"], "sha": sha, "files": f["files"], "at": stamp,
                                            "regression": f["contract"]["regression"], "red_test": f["contract"]["red_test"]["test"]})
        st["log"].append(f"{stamp} MERGED #{f['pr']} {sha[:10]}")
        _save(st)
        return f"MERGED #{f['pr']} as {sha[:10]} (pull master to see it)"
    if "visual" in kinds:
        if str(f["pr"]) not in st.setdefault("visual", {}):
            _run("gh", "pr", "edit", str(f["pr"]), "--repo", REPO, "--add-label", "needs-operator-eye", check=False)
            _run("gh", "pr", "comment", str(f["pr"]), "--repo", REPO, "--body",
                 "code_gate: VISUAL change - never merged by a machine. It goes to the visual-gate review packet (game-camera stills "
                 "via still_framing, the operator's OK). Claude collects it the normal way.", check=False)
            st["visual"][str(f["pr"])] = {"task": f["task"], "at": stamp, "title": f["title"]}
            _save(st)
        return "VISUAL -> review packet (labelled needs-operator-eye)"
    hard = kinds - {"ci_regression", "review", "queue", "mergeable"}
    if hard or "queue" in kinds:
        return "REFUSED - needs Claude: " + "; ".join(w for w in why if w.split(":", 1)[0] in hard | {"queue"})
    if "ci_regression" in kinds:
        key = f"{f['pr']}:{f['head']}:{f['master']}"
        last = st.setdefault("dispatched", {}).get(key)
        if last and time.time() - last < REDISPATCH_MIN * 60:
            return "WAITING for the dispatched code-gate run"
        left = budget_left()
        if left < BUDGET_RESERVE_USD:
            return f"HELD - Actions budget left ${left:.2f} < reserve ${BUDGET_RESERVE_USD:.2f}"
        _run("gh", "workflow", "run", "code-gate.yml", "--repo", REPO, "--ref", "main", "-f", f"pr={f['pr']}")
        st["dispatched"][key] = time.time()
        st["log"].append(f"{stamp} DISPATCHED code-gate #{f['pr']} head {f['head'][:10]} (budget left ${left:.2f})")
        _save(st)
        return f"DISPATCHED code-gate.yml for #{f['pr']} (budget left ${left:.2f})"
    if "review" in kinds:
        if f["review"][0] == "BLOCK":
            return f"BLOCKED by the reviewer ({f['review'][1]}) - Claude reads the review comment"
        meta = next(iter(sorted((ROOT / "AgentComms" / "reviews").glob(f"PR{f['pr']}_{f['head'][:8]}.json"))), None)
        if meta and json.loads(meta.read_text(encoding="utf-8")).get("sent"):
            return "WAITING for the Arena review (harvest: python Tools/code_review.py harvest)"
        rc = code_review.send(f["pr"])
        st["log"].append(f"{stamp} REVIEW {'SENT' if rc == 0 else 'NOT SENT rc=%d' % rc} #{f['pr']}")
        _save(st)
        return "REVIEW SENT to Arena" if rc == 0 else "REVIEW NOT SENT - see the prompt file (a Claude session pastes it)"
    return "WAITING (GitHub mergeability)"


def report(f: dict, why: list[str]) -> None:
    m = f["ci_marker"] or {}
    print(f"PR #{f['pr']} {f['title']}")
    print(f"  branch {f['branch']}  head {f['head'][:10]}  master {f['master'][:10]}  task {f['task'] or '-'}")
    print(f"  files {', '.join(f['files']) or '-'}")
    print(f"  ci.yml {', '.join(f'{n}={s}' for n, s in f['checks']) or '-'}")
    print(f"  code-gate CI {' '.join(f'{k}={v}' for k, v in m.items()) or '-'}")
    print(f"  review {f['review'][0]} by {f['review'][1]}  guard {'OK' if f['guard_ok'] else 'FAIL'}  ahead {f['ahead'] or '-'}")
    if why:
        print("CODE_GATE REFUSE")
        for w in why:
            print("  -", w)
    else:
        print("CODE_GATE MERGE")


# ---------------------------------------------------------------- selftest: one MERGE fixture, one fixture per refusal

def _fixture() -> dict:
    contract = {"owns": [{"path": "Godot/scripts/rules/FightLink.gd", "windows": []},
                         {"path": "Godot/scripts/FightRealtime.gd", "windows": [[100, 200]]},
                         {"path": "Godot/tests/fight_link_test.gd", "windows": []}],
                "red_test": {"test": "Godot/tests/fight_link_test.gd", "pass_line": "FIGHT_LINK failures=0"},
                "regression": ["fight_link_test", "fight_identity"], "visual": False, "keys": ["OWNS", "RED_TEST", "REGRESSION", "VISUAL"]}
    return {"pr": 300, "title": "FIGHTLINK1 wire", "state": "OPEN", "branch": "arena/abc-fightcamp", "head": "h" * 40,
            "master": "m" * 40, "base": "m" * 40, "files": ["Godot/scripts/FightRealtime.gd", "Godot/tests/fight_link_test.gd"],
            "task": "FIGHTLINK1", "contract": contract, "contract_problems": [], "hunks": {"Godot/scripts/FightRealtime.gd": [[120, 130]]},
            "guard_ok": True, "checks": [("Parse gate + changed tests", "SUCCESS")],
            "ci_marker": {"head": "h" * 40, "base": "m" * 40, "task": "FIGHTLINK1", "red_on_base": "FAIL", "red_test": "PASS",
                          "pass_line": "FOUND", "regression": "PASS", "new_red": "-", "run": "1"},
            "master_code_moved": False, "review": ("APPROVE", "arena"), "ahead": [], "mergeable": "MERGEABLE"}


def selftest() -> int:
    import copy
    cases = {"MERGE": lambda f: None}

    def case(name):
        def deco(fn):
            cases[name] = fn
            return fn
        return deco

    @case("open: closed PR")
    def _(f): f["state"] = "MERGED"
    @case("open: not an agent branch")
    def _(f): f["branch"] = "feature/x"
    @case("contract: no brief")
    def _(f): f["task"] = ""
    @case("contract: invalid block")
    def _(f): f["contract_problems"] = ["missing REGRESSION:"]
    @case("protected: touches a gate")
    def _(f): f["files"].append("ops/Tools/rule_guard.py"); f["contract"]["owns"].append({"path": "ops/Tools/rule_guard.py", "windows": []})
    @case("visual: brief VISUAL yes")
    def _(f): f["contract"]["visual"] = True
    @case("visual: rig script")
    def _(f): f["files"].append("Godot/scripts/MetaHumanRig.gd"); f["contract"]["owns"].append({"path": "Godot/scripts/MetaHumanRig.gd", "windows": []})
    @case("owns: file outside OWNS")
    def _(f): f["files"].append("Godot/scripts/GameState.gd")
    @case("owns: lines outside the window")
    def _(f): f["hunks"]["Godot/scripts/FightRealtime.gd"] = [[120, 130], [450, 460]]
    @case("guard: gutted test")
    def _(f): f["guard_ok"] = False
    @case("ci: ci.yml red")
    def _(f): f["checks"] = [("Parse gate + changed tests", "FAILURE")]
    @case("ci_regression: never ran")
    def _(f): f["ci_marker"] = None
    @case("ci_regression: stale base")
    def _(f): f["ci_marker"]["base"] = "o" * 40; f["master_code_moved"] = True
    @case("ci_regression: RED_TEST green on master")
    def _(f): f["ci_marker"]["red_on_base"] = "PASS"
    @case("ci_regression: RED_TEST fails")
    def _(f): f["ci_marker"]["red_test"] = "FAIL"
    @case("ci_regression: pass line missing")
    def _(f): f["ci_marker"]["pass_line"] = "MISSING"
    @case("ci_regression: regression new red")
    def _(f): f["ci_marker"]["regression"] = "FAIL"; f["ci_marker"]["new_red"] = "fight_identity_test.gd"
    @case("review: none yet")
    def _(f): f["review"] = ("NONE", "-")
    @case("review: BLOCK")
    def _(f): f["review"] = ("BLOCK", "arena")
    @case("queue: older PR on the same file")
    def _(f): f["ahead"] = [(299, "Godot/scripts/FightRealtime.gd")]
    @case("mergeable: conflict")
    def _(f): f["mergeable"] = "CONFLICTING"

    ## S368 Lean layout: the game at the repo root, agy/ branches from Tools/seat_dispatch.py
    def lean(f):
        f["branch"] = "agy/fightlink1"
        f["files"] = ["scripts/rules/RoundScript.gd", "tests/round_script_test.gd"]
        f["contract"]["owns"] = [{"path": "scripts/rules/RoundScript.gd", "windows": [[100, 200]]},
                                 {"path": "tests/round_script_test.gd", "windows": []}]
        f["hunks"] = {"scripts/rules/RoundScript.gd": [[120, 130]]}

    def lean_with(path):
        def mutate(f):
            lean(f)
            f["files"].append(path)
            f["contract"]["owns"].append({"path": path, "windows": []})
        return mutate

    cases["MERGE (Lean paths, agy branch)"] = lean
    cases["visual: Lean fight3d script"] = lean_with("scripts/fight3d/Referee.gd")
    cases["visual: Lean screen"] = lean_with("scripts/ui/areas/FighterPage.gd")
    cases["visual: Lean asset"] = lean_with("assets/ui/training/pads.png")
    cases["protected: Lean test runner"] = lean_with("tools/run_tests.sh")
    cases["protected: Lean project file"] = lean_with("project.godot")
    cases["MERGE (Lean owned folder)"] = lambda f: (lean(f), f["contract"]["owns"].append({"path": "docs/agy/", "windows": []}),
                                                    f["files"].append("docs/agy/FIGHTLINK1_result.md"))
    cases["owns: Lean file outside OWNS"] = lambda f: (lean(f), f["files"].append("scripts/rules/Combos.gd"))
    cases["owns: Lean lines outside the window"] = lambda f: (lean(f), f["hunks"].update({"scripts/rules/RoundScript.gd": [[300, 310]]}))

    fails = 0
    for name, mutate in cases.items():
        f = copy.deepcopy(_fixture())
        mutate(f)
        why = decide(f)
        want_kind = None if name.startswith("MERGE") else name.split(":", 1)[0]
        ok = (not why) if want_kind is None else bool(why) and why[0].startswith(want_kind)
        fails += not ok
        print(f"{'OK  ' if ok else 'FAIL'} {name:45s} -> {'MERGE' if not why else why[0]}")
    print(f"CODE_GATE_SELFTEST cases={len(cases)} failures={fails}")
    return 1 if fails else 0


def main(argv: list[str]) -> int:
    args = [a for a in argv[1:] if not a.startswith("--")]
    master = argv[argv.index("--master") + 1] if "--master" in argv else None
    if master:
        args = [a for a in args if a != master]
    proof = "--any-state" in argv or master is not None
    if args[:1] == ["selftest"]:
        return selftest()
    if args[:1] == ["arm"]:
        return arm(argv)
    if args[:1] == ["queue"]:
        prs = open_agent_prs()
        print(f"CODE_GATE queue: {len(prs)} open agent PR(s)")
        acted = False
        for p in prs:
            f = facts(p["number"], others=prs)
            why = decide(f)
            report(f, why)
            if "--act" in argv and not acted and f["task"]:
                outcome = act(f, why)
                print("  ACTION", outcome)
                acted = outcome.startswith(("MERGED", "DISPATCHED", "REVIEW SENT"))  # one queue move per run
        return 0
    if not args or not args[0].isdigit():
        print(__doc__)
        return 2
    f = facts(int(args[0]), master=_run("git", "rev-parse", master).strip() if master else None)
    if proof and f["state"] != "OPEN":
        f["state"] = "OPEN"
        print("(proof mode: the PR's closed state is ignored; nothing is acted on)")
    why = decide(f)
    report(f, why)
    if "--act" in argv and not proof:
        print("ACTION", act(f, why))
    return 0 if not why else 1


if __name__ == "__main__":
    sys.exit(main(sys.argv))
