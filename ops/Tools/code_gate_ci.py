"""code_gate_ci.py - what .github/workflows/code-gate.yml runs on the GitHub runner for one agent CODE PR (S249).

The job runs the PR's brief contract (Tools/brief_contract.py, read from MASTER - an agent cannot widen its own brief) on the PR merged
onto master: RED_TEST must pass on the merge (and must not already pass on master), every REGRESSION test that passes on master must
pass on the merge. It posts ONE comment with a machine-readable marker line that Tools/code_gate.py reads:

    CODE_GATE_CI pr=<n> head=<sha> base=<sha> task=<id> red_on_base=MISSING|FAIL|PASS red_test=PASS|FAIL pass_line=FOUND|MISSING
                 regression=PASS|FAIL new_red=<tests> pre_red=<tests> lfs_suspect=<tests> minutes=<m> run=<id>

    python Tools/code_gate_ci.py plan <pr>                      # -> GITHUB_OUTPUT: run, task, only, red, red_name, skip
    python Tools/code_gate_ci.py failing <merge_log>            # tests that failed on the merge (comma list), for the base re-run
    python Tools/code_gate_ci.py report <pr> <merge_log> <base_log|-> <minutes>   # posts the comment (gh, GITHUB_TOKEN)
Run only in CI (it reads the runner's per-test logs in the temp dir). Stdlib only.
"""
from __future__ import annotations

import json
import os
import re
import subprocess
import sys
import tempfile
from pathlib import Path

## FIGHTCAMP_ROOT: CI runs a copy of these tools taken from master (/tmp/gate) against the checkout - a PR cannot swap the gate.
ROOT = Path(os.environ.get("FIGHTCAMP_ROOT") or Path(__file__).resolve().parent.parent)
sys.path.insert(0, str(Path(__file__).resolve().parent))
import brief_contract  # noqa: E402

REPO = os.environ.get("GITHUB_REPOSITORY", "ICOON-Studio/FightCamp-Lean")
MARKER = "<!-- CODE_GATE_CI -->"
LINE_RE = re.compile(r"^\[[ \t]*\d+/\d+\][ \t]+(PASS|FAIL)[ \t]+(\S+\.gd)[ \t]*(.*)$", re.M)
LFS_HINT = ("version https://git-lfs", "git-lfs.github.com/spec")


def _gh(*args: str) -> str:
    return subprocess.run(["gh", *args], cwd=ROOT, capture_output=True, text=True, check=True).stdout


def _out(**kv: str) -> None:
    path = os.environ.get("GITHUB_OUTPUT")
    lines = "".join(f"{k}={v}\n" for k, v in kv.items())
    if path:
        with open(path, "a", encoding="utf-8") as fh:
            fh.write(lines)
    print(lines, end="")


def plan(pr: str) -> int:
    info = json.loads(_gh("pr", "view", pr, "--repo", REPO, "--json", "title,body,headRefName,state"))
    task = brief_contract.task_for_pr(info["title"], info["body"], info["headRefName"])
    if not task:
        _out(run="0", skip="no brief found for the PR (TASK: <id> line, TASK_<id>.md or an id in the title)")
        return 0
    contract, why = brief_contract.check_brief(task)
    if why:
        _out(run="0", task=task, skip=f"brief contract invalid: {why[0]}")
        return 0
    red = contract["red_test"]["test"]
    red_name = Path(red).name
    only = [red_name[:-3]] + [s for s in contract["regression"] if s not in red_name]
    _out(run="1", task=task, only=",".join(only), red=red, red_name=red_name, pass_line=contract["red_test"]["pass_line"])
    return 0


def _results(log_text: str) -> dict[str, str]:
    return {name: verdict for verdict, name, _ in LINE_RE.findall(log_text)}


def failing(merge_log: str) -> int:
    res = _results(Path(merge_log).read_text(encoding="utf-8", errors="replace"))
    print(",".join(sorted(n[:-3] for n, v in res.items() if v == "FAIL")))
    return 0


def _test_log(name: str) -> str:
    ## the workflow copies the merge run's per-test logs to $MERGE_LOGS before the base re-run overwrites them
    p = Path(os.environ.get("MERGE_LOGS") or Path(tempfile.gettempdir()) / "fightcamp_test_logs") / (name + ".log")
    return p.read_text(encoding="utf-8", errors="replace") if p.is_file() else ""


def report(pr: str, merge_log: str, base_log: str, minutes: str) -> int:
    info = json.loads(_gh("pr", "view", pr, "--repo", REPO, "--json", "title,body,headRefName,headRefOid"))
    task = brief_contract.task_for_pr(info["title"], info["body"], info["headRefName"])
    contract, _ = brief_contract.check_brief(task)
    red_name = Path(contract["red_test"]["test"]).name
    pass_line = contract["red_test"]["pass_line"]
    merge_text = Path(merge_log).read_text(encoding="utf-8", errors="replace")
    merged = _results(merge_text)
    red_log = _test_log(red_name)
    base = _results(Path(base_log).read_text(encoding="utf-8", errors="replace")) if base_log != "-" and Path(base_log).is_file() else {}
    red_on_base = base.get(red_name, "MISSING" if not os.environ.get("RED_ON_BASE_EXISTS") else "NOT_RUN")
    red_test = merged.get(red_name, "NOT_RUN")
    found = "FOUND" if pass_line and pass_line in red_log else "MISSING"
    new_red = sorted(n for n, v in merged.items() if v == "FAIL" and n != red_name and base.get(n) != "FAIL")
    pre_red = sorted(n for n, v in merged.items() if v == "FAIL" and n != red_name and base.get(n) == "FAIL")
    lfs = sorted(n for n, v in merged.items() if v == "FAIL" and any(h in _test_log(n) for h in LFS_HINT))
    regression = "PASS" if not new_red else "FAIL"
    head = info["headRefOid"]
    base_sha = os.environ.get("BASE_SHA", "")
    run_id = os.environ.get("GITHUB_RUN_ID", "")
    marker = (f"CODE_GATE_CI pr={pr} head={head} base={base_sha} task={task} red_on_base={red_on_base} red_test={red_test} "
              f"pass_line={found} regression={regression} new_red={','.join(new_red) or '-'} pre_red={','.join(pre_red) or '-'} "
              f"lfs_suspect={','.join(lfs) or '-'} minutes={minutes} run={run_id}")
    lines = "\n".join(f"{v} {n}" for n, v in sorted(merged.items()))
    body = (f"{MARKER}\n**Code gate CI** (brief `TASK_{task}.md` from master, PR merged onto `{base_sha[:10]}`)\n\n```\n{marker}\n```\n\n"
            f"Merge run (`run_tests.py --only {os.environ.get('ONLY', '')} --jobs 2`):\n```\n{lines or '(no test lines)'}\n```\n"
            f"RED_TEST pass line `{pass_line}`: {found} in `{red_name}`'s log. Base re-run: {json.dumps(base) if base else 'not needed'}.\n"
            f"Actions minutes this run: {minutes}.")
    print(marker)
    summary = os.environ.get("GITHUB_STEP_SUMMARY")
    if summary:
        Path(summary).write_text(body, encoding="utf-8")
    _gh("pr", "comment", pr, "--repo", REPO, "--body", body)
    return 0


def main(argv: list[str]) -> int:
    cmd = argv[1] if len(argv) > 1 else ""
    if cmd == "plan" and len(argv) > 2:
        return plan(argv[2])
    if cmd == "failing" and len(argv) > 2:
        return failing(argv[2])
    if cmd == "report" and len(argv) > 5:
        return report(argv[2], argv[3], argv[4], argv[5])
    print(__doc__)
    return 2


if __name__ == "__main__":
    sys.exit(main(sys.argv))
