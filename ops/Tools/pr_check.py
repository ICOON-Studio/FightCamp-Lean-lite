"""pr_check.py - a second pair of eyes on a seat's PR before Claude collects it (S395).

Operator S395: "okgo ahead do all". SOUND2 passed its own tests with a real bug in it: a sound waited for the contact twice. The
seats check their own work; this reads the diff cold and looks for logic faults only. Run by .github/workflows/pr-check.yml with
the Qwen plan key, and it posts one comment on the PR. A comment is advice: Claude still reads the diff before merging.

    python ops/Tools/pr_check.py <pr number> [--dry]      # needs GH_TOKEN and QWEN_API_KEY; --dry prints instead of posting
"""
from __future__ import annotations

import json
import os
import re
import subprocess
import sys
import urllib.request

URL = "https://token-plan.ap-southeast-1.maas.aliyuncs.com/compatible-mode/v1/chat/completions"
MAX_DIFF = 70000
SKIP = re.compile(r"\.(import|uid|png|jpg|ogg|wav|res|glb|mp4)$")
MARK = "<!-- pr-check -->"

PROMPT = """You review one pull request for a Godot 4 (GDScript) game. Find real bugs only: logic that does not do what the code,
its comments or its PR text says. Look hard for these:
- a delay, timer, offset, sign or unit applied twice, or not at all
- a value that a caller or the engine never reads, so the claimed effect cannot happen (a negative delay, a dead constant)
- a test that only searches source text, or passes whatever the code does
- a claim in the PR text or notes that the diff does not back up
- a callback or timer that can fire after its object has gone, or state left set on an early return
Do not report style, naming, comments, or anything you are not sure is wrong.

Answer in plain words, at most 8 findings, most serious first. For each: FILE:LINE, what goes wrong in play, and the fix in one line.
If you find nothing, answer exactly: No logic faults found.

PR title: {title}

PR text:
{body}

Diff:
{diff}
"""


def sh(*args: str) -> str:
    return subprocess.run(args, capture_output=True, text=True, encoding="utf-8", errors="replace", check=True).stdout


def trimmed_diff(raw: str) -> str:
    keep = []
    for part in re.split(r"(?m)^(?=diff --git )", raw):
        head = part.split("\n", 1)[0]
        if part and not SKIP.search(head.strip()) and "Binary files" not in part[:400]:
            keep.append(part)
    return "".join(keep)[:MAX_DIFF]


def ask(prompt: str) -> str:
    data = json.dumps({"model": os.environ.get("PR_CHECK_MODEL") or "qwen3.7-plus", "temperature": 0.1, "enable_thinking": False,
                       "messages": [{"role": "user", "content": prompt}]}).encode()
    req = urllib.request.Request(URL, data=data, headers={"Content-Type": "application/json",
                                                         "Authorization": "Bearer " + os.environ["QWEN_API_KEY"]})
    with urllib.request.urlopen(req, timeout=400) as r:
        return json.load(r)["choices"][0]["message"]["content"].strip()


def main(argv: list[str]) -> int:
    pr = argv[0]
    meta = json.loads(sh("gh", "pr", "view", pr, "--json", "title,body"))
    diff = trimmed_diff(sh("gh", "pr", "diff", pr))
    if not diff.strip():
        print("PR_CHECK nothing to read")
        return 0
    answer = ask(PROMPT.format(title=meta["title"], body=(meta["body"] or "")[:6000], diff=diff))
    text = f"{MARK}\n**Logic check** (automatic second reader, advice only)\n\n{answer}"
    print(text)
    if "--dry" not in argv:
        subprocess.run(["gh", "pr", "comment", pr, "--body", text], check=True)
    return 0


if __name__ == "__main__":
    sys.exit(main(sys.argv[1:]))
