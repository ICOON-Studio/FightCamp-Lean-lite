#!/usr/bin/env python3
"""pm_bot.py - Paul, FightCamp's project-manager bot (xAI API, persona "pm" in Tools/xai_ask.py).

S231, operator: "setup a project manager bot to review and update the board and guide you and dola and whatever else a
project manager does". The board lives on this PC (127.0.0.1:8787), so the bot cannot read it: this script packs the
board's sources into one snapshot, sends it through the xai-research workflow (the key stays a repo secret), and
collects the review.

    python Tools/pm_bot.py snapshot          # write AgentComms/pm/PM_SNAPSHOT.md only (no network)
    python Tools/pm_bot.py ask [--wait]      # snapshot -> gh workflow run xai-research.yml (bot=pm, snapshot inline, no commit)
                                             #   --wait: poll the run, then collect (the board runs this, hidden)
    python Tools/pm_bot.py collect           # newest review (branch xai/PM_REVIEW_* or the run artifact) -> AgentComms/pm/
    python Tools/pm_bot.py message "<text>"  # the operator's message to Paul (the board's box does this) - answered next ask
    python Tools/pm_bot.py apply <review.md> # apply the review's BOARD EDITS json (notes only; close/park need --yes)

Claude reads the review (FOR CLAUDE / FOR LUDO / DELEGATION; operator S232: "paul should communicate with ludo not dola") and acts on it; the operator sees the latest review on the
board's main page (AgentComms/pm/latest.md) and talks to Paul there (operator S231: "where can i communicate with paul ?").
Stdlib only.
"""
import datetime, json, os, re, subprocess, sys

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
PM_DIR = os.path.join(ROOT, "AgentComms", "pm")
SNAPSHOT = os.path.join(PM_DIR, "PM_SNAPSHOT.md")
INBOX = os.path.join(PM_DIR, "inbox.json")
NO_WINDOW = 0x08000000 if os.name == "nt" else 0  # CREATE_NO_WINDOW (operator: nothing opens on his screens)
LOCK = os.path.join(PM_DIR, "asking.lock")


def load_inbox() -> dict:
    try:
        with open(INBOX, encoding="utf-8") as f:
            data = json.load(f)
        return data if isinstance(data, dict) else {"messages": []}
    except (OSError, ValueError):
        return {"messages": []}


def save_inbox(data: dict) -> None:
    os.makedirs(PM_DIR, exist_ok=True)
    tmp = INBOX + ".tmp"
    with open(tmp, "w", encoding="utf-8", newline="\n") as f:
        json.dump(data, f, ensure_ascii=False, indent=2)
    os.replace(tmp, INBOX)


def add_message(text: str, sender: str = "operator") -> dict:
    data = load_inbox()
    msgs = data.setdefault("messages", [])
    row = {"id": "P%d" % (len(msgs) + 1), "from": sender, "at": datetime.datetime.now().strftime("%Y-%m-%d %H:%M"),
           "text": text.strip()[:4000], "status": "waiting"}
    msgs.append(row)
    save_inbox(data)
    return row
# The same rule `start` uses to hide finished rows (agent_comms._CLOSED_STATE).
CLOSED = re.compile(r"^\[*\s*(S\d+[a-z]?\s*[:-]?\s*)?(DONE|MERGED|COLLECTED|REJECTED|TAKEN OVER|PARTLY DONE|SUPERSEDED|PARKED)", re.I)


# S231: Paul's first review planned Codex jobs - the operator ruled Codex out in S228. Rulings he must plan inside.
STANDING_RULINGS = [
    "S228: assign Codex NOTHING (collecting a finished Codex run is fine). Ludo writes code, Claude integrates/tests/merges.",
    "Claude briefs, reviews and merges; implementation goes to agent seats (Arena first, cloud), Claude codes only when no seat fits.",
    "Ludo (Ask Ludo) is the lead game + art designer: every design/mechanics/art question goes to Ludo first, the operator approves the verdict.",
    "S232 operator: \"paul should communicate with ludo not dola\" - Paul's own asks (section 6 FOR LUDO, reference/look questions) go to Ludo, never Dola.",
    "At most 14 FOCUS rows; a new row enters only when one leaves; PARKED rows need the operator's call.",
    "Ask the operator only about money, taste or scope; questions go on the board.",
    "PC limits: 84 C / 80% CPU = no heavy job; at most 3 PC agents; headless work goes to cloud seats.",
    "A visual fix closes only on a game-camera still + the operator's OK; a test must go red on the shipped tree first.",
    "Organisations are real, fighters fictional; never invent a body, fee or number.",
]


def _load(rel):
    with open(os.path.join(ROOT, rel), encoding="utf-8") as f:
        return json.load(f)


def _git(*args):
    return subprocess.run(["git", *args], cwd=ROOT, capture_output=True, text=True, encoding="utf-8", creationflags=NO_WINDOW).stdout.strip()


def _cut(text, n):
    text = " ".join(str(text).split())
    return text if len(text) <= n else text[: n - 3] + "..."


def build_snapshot() -> str:
    road = _load("AgentComms/roadmap.json")
    out = ["# FightCamp ops board snapshot for the project manager",
           "Taken %s at commit %s." % (datetime.datetime.now().strftime("%Y-%m-%d %H:%M"), _git("rev-parse", "--short", "HEAD")), ""]
    waiting = [m for m in load_inbox().get("messages", []) if m.get("status") in ("waiting", "thinking")]
    if waiting:
        out += ["## THE OPERATOR WRITES TO YOU DIRECTLY - answer these first, in section 0 TO THE OPERATOR"]
        out += ["- %s (%s, %s): %s" % (m["id"], m.get("from"), m.get("at"), m.get("text")) for m in waiting] + [""]
    out += ["## Objective", _cut(road.get("objective", ""), 900), ""]
    out += ["## Standing operator rulings (binding - never plan against them)"] + ["- " + r for r in STANDING_RULINGS] + [""]
    now = road.get("now", {})
    out += ["## Now (recorded next action)", _cut(now.get("summary", ""), 600), _cut(now.get("next_action", ""), 3000), ""]
    plan = road.get("plan", {})
    for key in ("goal", "working_now", "next", "parked", "done_recently"):
        if plan.get(key):
            out += ["## Board plan: %s" % key, _cut(json.dumps(plan[key], ensure_ascii=False), 1800), ""]
    tasks = road.get("queue", {}).get("tasks", [])
    open_rows = [t for t in tasks if isinstance(t, dict) and not CLOSED.match(str(t.get("state", "")))]
    out += ["## Open queue rows (%d open of %d; focus cap 14)" % (len(open_rows), len(tasks))]
    for t in open_rows:
        out.append("- %s [%s] %s :: %s" % (t.get("id"), t.get("owner"), _cut(t.get("title", ""), 160), _cut(t.get("state", ""), 500)))
    out.append("")
    if road.get("blocked_on_operator"):
        out += ["## Blocked on the operator", _cut(json.dumps(road["blocked_on_operator"], ensure_ascii=False), 1200), ""]
    runs = _load("AgentComms/live_runs.json").get("runs", {})
    out += ["## Agent runs (live_runs.json)"]
    for rid, r in runs.items():
        if isinstance(r, dict):
            out.append("- %s | %s | %s | started %s | %s" % (rid, r.get("agent"), r.get("status"), r.get("started"), _cut(r.get("title", ""), 220)))
    out.append("")
    qs = _load("AgentComms/questions.json").get("questions", [])
    pending = [q for q in qs if isinstance(q, dict) and not q.get("answer")]
    out += ["## Operator questions still open (%d)" % len(pending)]
    out += ["- %s: %s" % (q.get("id"), _cut(q.get("text", q.get("question", "")), 300)) for q in pending[-10:]]
    out.append("")
    comments = _load("AgentComms/media_comments.json").get("comments", [])
    out += ["## Operator comments on stills (newest 15)"]
    ## S249: board_reconcile marks a comment "addressed" when a master commit cites its id - say so, it is not open work
    out += ["- %s %s: %s%s" % (c.get("id"), os.path.basename(str(c.get("path", ""))), _cut(c.get("text", ""), 240),
                               " [ADDRESSED, %s]" % c["addressed"] if c.get("addressed") else "") for c in comments[-15:]]
    out.append("")
    nightly = os.path.join(ROOT, "AgentComms", "nightly", "latest.txt")
    if os.path.exists(nightly):
        with open(nightly, encoding="utf-8", errors="replace") as f:
            lines = [l.rstrip() for l in f if "FAIL" in l or "SUITE" in l]
        out += ["## Nightly test suite (failures)"] + lines[:40] + [""]
    out += ["## Last 20 commits", _git("log", "-20", "--format=%h %ad %s", "--date=short"), ""]
    return "\n".join(out)


def cmd_snapshot():
    os.makedirs(PM_DIR, exist_ok=True)
    text = build_snapshot()
    with open(SNAPSHOT, "w", encoding="utf-8", newline="\n") as f:
        f.write(text)
    print("PM snapshot %d chars -> %s" % (len(text), os.path.relpath(SNAPSHOT, ROOT)))
    return text


## S231: the snapshot rides in the workflow's `task_text` input - nothing is committed, so a board-triggered ask never
## touches the shared checkout's git state. workflow_dispatch inputs cap at 65,535 chars in total.
MAX_INLINE = 60000


def _run(args, **kw):
    return subprocess.run(args, cwd=ROOT, capture_output=True, text=True, encoding="utf-8", creationflags=NO_WINDOW, **kw)


def cmd_ask(wait: bool = False):
    if os.path.exists(LOCK) and (datetime.datetime.now().timestamp() - os.path.getmtime(LOCK)) < 1800:
        print("Paul is already thinking (asking.lock) - the new message rides on the next ask")
        return 0
    os.makedirs(PM_DIR, exist_ok=True)
    with open(LOCK, "w") as f:
        f.write(str(os.getpid()))
    try:
        text = cmd_snapshot()
        if len(text) > MAX_INLINE:
            with open(SNAPSHOT, "w", encoding="utf-8", newline="\n") as f:
                f.write(text[:MAX_INLINE])
        data = load_inbox()
        asked = [m["id"] for m in data.get("messages", []) if m.get("status") == "waiting"]
        for m in data.get("messages", []):
            if m["id"] in asked:
                m["status"] = "thinking"
        save_inbox(data)
        stamp = datetime.datetime.now().strftime("%Y%m%d_%H%M%S")
        rel_out = "AgentComms/pm/PM_REVIEW_%s.md" % stamp
        started = datetime.datetime.utcnow().strftime("%Y-%m-%dT%H:%M:%SZ")
        run = _run(["gh", "workflow", "run", "xai-research.yml", "-f", "task=AgentComms/pm/PM_SNAPSHOT.md", "-f", "bot=pm",
                    "-f", "out=" + rel_out, "-F", "task_text=@" + SNAPSHOT])
        print(run.stdout.strip() or run.stderr.strip())
        if run.returncode != 0:
            _mark(asked, "waiting")
            return run.returncode
        if not wait:
            print("PM review requested (%s); collect with: python Tools/pm_bot.py collect" % rel_out)
            return 0
        return _wait_and_collect(started, asked)
    finally:
        try:
            os.remove(LOCK)
        except OSError:
            pass


def _mark(ids, status, review=""):
    data = load_inbox()
    for m in data.get("messages", []):
        if m["id"] in ids:
            m["status"] = status
            if review:
                m["review"] = review
    save_inbox(data)


def _wait_and_collect(started_utc: str, asked: list) -> int:
    import time
    run_id = ""
    for _ in range(90):  # ~30 min
        time.sleep(20)
        if not run_id:
            listed = _run(["gh", "run", "list", "--workflow", "xai-research.yml", "--limit", "5", "--json", "databaseId,createdAt"]).stdout
            for row in json.loads(listed or "[]"):
                if row.get("createdAt", "") >= started_utc:
                    run_id = str(row["databaseId"])
            continue
        view = json.loads(_run(["gh", "run", "view", run_id, "--json", "status"]).stdout or "{}")
        if view.get("status") == "completed":
            break
    rc = cmd_collect()
    if rc == 0:
        _mark(asked, "answered", "AgentComms/pm/latest.md")
    else:
        _mark(asked, "waiting")
    return rc


def _from_artifact():
    """S231: the workflow's push back to GitHub can fail (HTTP 500, S224 too) - the reply is still kept as the run's
    `xai-reply` artifact. Take the newest successful-or-failed run of xai-research.yml that has one."""
    import tempfile
    runs = subprocess.run(["gh", "run", "list", "--workflow", "xai-research.yml", "--limit", "10", "--json", "databaseId"],
                          cwd=ROOT, capture_output=True, text=True, creationflags=NO_WINDOW).stdout
    for run in json.loads(runs or "[]"):
        tmp = tempfile.mkdtemp(prefix="pm_review_")
        got = subprocess.run(["gh", "run", "download", str(run["databaseId"]), "-n", "xai-reply", "-D", tmp], cwd=ROOT, capture_output=True, creationflags=NO_WINDOW)
        if got.returncode != 0:
            continue
        for name in sorted(os.listdir(tmp)):
            if name.startswith("PM_REVIEW_") and name.endswith(".md"):
                with open(os.path.join(tmp, name), encoding="utf-8") as f:
                    return name, f.read()
    return "", ""


def cmd_collect():
    subprocess.run(["git", "fetch", "-q", "origin", "+refs/heads/xai/PM_REVIEW_*:refs/remotes/origin/xai/PM_REVIEW_*"], cwd=ROOT, capture_output=True, creationflags=NO_WINDOW)
    branches = sorted(b.strip() for b in _git("branch", "-r", "--list", "origin/xai/PM_REVIEW_*").splitlines() if b.strip())
    name, text = "", ""
    if branches:
        branch = branches[-1]
        name = branch.split("/")[-1] + ".md"
        text = _git("show", "%s:AgentComms/pm/%s" % (branch, name))
    art_name, art_text = _from_artifact()
    if art_text and art_name > name:
        branch, name, text = "artifact", art_name, art_text
    if not text:
        print("no PM review yet (no xai/PM_REVIEW_* branch, no xai-reply artifact)")
        return 1
    os.makedirs(PM_DIR, exist_ok=True)
    for path in (os.path.join(PM_DIR, name), os.path.join(PM_DIR, "latest.md")):
        with open(path, "w", encoding="utf-8", newline="\n") as f:
            f.write(text + "\n")
    print("PM review %s (%d chars) -> AgentComms/pm/%s + latest.md" % (branch, len(text), name))
    return 0


def cmd_apply(review_path, yes):
    with open(review_path, encoding="utf-8") as f:
        text = f.read()
    blocks = re.findall(r"```json\s*(\{.*?\})\s*```", text, re.S)
    if not blocks:
        print("no BOARD EDITS json block")
        return 1
    edits = json.loads(blocks[-1])
    path = os.path.join(ROOT, "AgentComms", "roadmap.json")
    with open(path, encoding="utf-8") as f:
        road = json.load(f)
    by_id = {t.get("id"): t for t in road["queue"]["tasks"] if isinstance(t, dict)}
    day = datetime.date.today().isoformat()
    changed = []
    for rid, note in (edits.get("notes") or {}).items():
        if rid in by_id:
            by_id[rid]["state"] = "[PM %s: %s] %s" % (day, _cut(note, 300), by_id[rid].get("state", ""))
            changed.append("note " + rid)
    for verb in ("close", "park"):
        for rid in edits.get(verb) or []:
            if rid not in by_id:
                continue
            if not yes:
                print("PROPOSED %s %s (rerun with --yes after Claude agrees)" % (verb, rid))
                continue
            word = "SUPERSEDED" if verb == "close" else "PARKED"
            by_id[rid]["state"] = "%s [PM %s] %s" % (word, day, by_id[rid].get("state", ""))
            changed.append("%s %s" % (verb, rid))
    with open(path, "w", encoding="utf-8", newline="\n") as f:
        json.dump(road, f, ensure_ascii=False, indent=2)
        f.write("\n")
    print("applied:", ", ".join(changed) or "nothing")
    return 0


def main(argv):
    if not argv or argv[0] not in ("snapshot", "ask", "collect", "apply", "message"):
        print(__doc__)
        return 2
    if argv[0] == "snapshot":
        cmd_snapshot()
        return 0
    if argv[0] == "ask":
        return cmd_ask("--wait" in argv)
    if argv[0] == "message":
        print(add_message(" ".join(argv[1:])))
        return 0
    if argv[0] == "collect":
        return cmd_collect()
    return cmd_apply(argv[1], "--yes" in argv)


if __name__ == "__main__":
    sys.exit(main(sys.argv[1:]))
