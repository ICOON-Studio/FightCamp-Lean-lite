"""S512 lean CI (operator: "Yes, switch it" - the full ~400-test suite ran on every push and PR, ~85% of the GitHub minutes;
the full suite runs on the PC at 05:00). Decides what the `ci` job runs. Writes `skip`, `full`, `tests`, `scripts` to
$GITHUB_OUTPUT (or prints them).

  push to main      -> every changed test + a parse check of every changed script (operator S512: "i do not want checks
                       on things that were not change" - nothing unchanged runs: no golden path, no regression list)
  pull request      -> the same + the agent brief's own RED_TEST (ops/research/TASK_<ID>.md; <ID> from the PR title
                       "<ID> - ..." or the branch): the test the agent wrote for its change
  notes only        -> skip (only .md, ops/, docs/ changed): the job passes at once (auto_collect needs a green check)
  workflow_dispatch -> FULL=1 runs the whole list (run_tests.sh's own default)
  no file list      -> full (never pass a change we could not read)

  python3 tools/ci_pick.py   (env: EVENT, REPO, BEFORE, AFTER, PR, TITLE, BRANCH, FULL, GH_TOKEN)
"""
import os
import re
import subprocess
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
SMOKE: list = []   # S512 operator: "i do not want checks on things that were not change"
NOTES = (".md",)
NOTE_DIRS = ("ops/", "docs/")


def gh(args):
    r = subprocess.run(["gh"] + args, capture_output=True, text=True)
    if r.returncode != 0:
        return None
    return [l.strip() for l in r.stdout.splitlines() if l.strip()]


def changed_files(env):
    if env.get("EVENT") == "pull_request" and env.get("PR"):
        return gh(["api", "--paginate", "repos/%s/pulls/%s/files" % (env["REPO"], env["PR"]), "--jq", ".[].filename"])
    before, after = env.get("BEFORE", ""), env.get("AFTER", "")
    if env.get("EVENT") == "push" and before and after and set(before) != {"0"}:
        return gh(["api", "repos/%s/compare/%s...%s" % (env["REPO"], before, after), "--jq", ".files[].filename"])
    return None


def brief_tests(env):
    m = re.match(r"\s*([A-Z][A-Z0-9_]+)\s+-\s", env.get("TITLE", ""))
    ids = ([m.group(1)] if m else []) + re.findall(r"[A-Z][A-Z0-9_]{3,}", env.get("BRANCH", "").upper())
    found = [ROOT / "ops" / "research" / ("TASK_%s.md" % i) for i in ids]
    found = [p for p in found if p.exists()]
    if not found:
        return []
    p = found[0]
    out = []
    for line in p.read_text(encoding="utf-8", errors="replace").splitlines():
        if line.startswith("RED_TEST:"):
            out += re.findall(r"tests/(\w+_test)\.gd", line)
    return out


def pick(env):
    if env.get("FULL") in ("1", "true"):
        return {"skip": "false", "full": "true", "tests": "", "scripts": ""}
    files = changed_files(env)
    if files is None:
        return {"skip": "false", "full": "true", "tests": "", "scripts": ""}
    code = [f for f in files if not f.endswith(NOTES) and not f.startswith(NOTE_DIRS)]
    if not code:
        return {"skip": "true", "full": "false", "tests": "", "scripts": ""}
    tests = list(SMOKE)
    tests += [Path(f).stem for f in code if f.startswith("tests/") and f.endswith("_test.gd")]
    if env.get("EVENT") == "pull_request":
        tests += brief_tests(env)
    tests = [t for i, t in enumerate(tests) if t not in tests[:i] and (ROOT / "tests" / (t + ".gd")).exists()]
    scripts = [f for f in code if f.endswith(".gd") and (ROOT / f).exists()]
    if not tests and not scripts:   # art, scenes, data only: nothing changed that a check here reads
        return {"skip": "true", "full": "false", "tests": "", "scripts": ""}
    return {"skip": "false", "full": "false", "tests": " ".join(tests), "scripts": " ".join(scripts)}


def main():
    res = pick(os.environ)
    out = os.environ.get("GITHUB_OUTPUT")
    lines = ["%s=%s" % kv for kv in res.items()]
    if out:
        with open(out, "a", encoding="utf-8") as fh:
            fh.write("\n".join(lines) + "\n")
    print("\n".join(lines))


if __name__ == "__main__":
    sys.exit(main())
