# TASK U30 — CURSOR — THE OPS BOARD: WHO IS WORKING, ON WHAT, AT WHAT COST

Model: **Cursor, `-p --force --trust`.** Owner: Cursor. Base: `master` at
`9c50aa4` or later, `SUITE total=215 fails=0`. Assigned 2026-09-10.
**Operator asked for this directly and wants it FIRST next session.**

---

## Why this exists

Five agents now work this repo — Claude, Qwen, Grok, Codex and Cursor — and
the operator's only view of any of it is scrollback in a chat window. They
asked for a board: what is being worked on right now, who is on it, what it
is costing, what shipped before, and switches to take an agent in or out of
rotation.

**This is not a Godot screen.** It is an ops tool in `Tools/`, next to
`agent_comms.py`, and it is the first thing in this repo the operator will
look at every day.

## The shape, and why it is NOT a Windows app

The operator asked for a Windows app that also works on an **iPhone 13**. A
Windows binary cannot run on an iPhone, and building two clients for a
one-person dashboard is waste. **Build ONE local web app:**

* A small **Python HTTP server** in `Tools/opsboard/` (stdlib only — no Flask,
  no npm, no build step; this must start with one command on a machine that
  has nothing installed).
* It binds `0.0.0.0` on a fixed port so **Safari on the iPhone reaches it over
  the LAN** at `http://<pc-lan-ip>:<port>`. Print that exact URL on startup so
  the operator can type it into their phone.
* One responsive page. It must be **usable one-handed on a 390pt-wide iPhone
  screen** and comfortable on the desktop — single column on narrow, multi
  column on wide. No horizontal scrolling on the phone, ever.
* **Auto-refresh** (poll every few seconds, or SSE). "Real time" here means
  the page changes without the operator touching it.

## What it must show, and every field must come from real data

All of this already exists on disk. **Read it; do not invent it.**

1. **NOW — who is working on what.** For each of the five agents: their open
   task id and title, and whether a process for them is actually running.
   Source: `python Tools/agent_comms.py board` (parse its table, do not
   re-implement it) plus a live process check for `qwen`/`codex`/`cursor-agent`.
   Grok runs in a browser and has no process — show it as **"browser, not
   detectable"** rather than guessing.
2. **Elapsed time** on the current task, from the task's assignment timestamp
   or the agent's process start time. If neither is available, show a dash.
3. **COST — and this is the honest part, see below.**
4. **HISTORY.** Past tasks per agent, most recent first: id, title, the commit
   that landed it, and how long it took (first-to-last commit timestamp).
   Source: `git log` plus the `### AGENT - <ID>: ... (COMPLETE ...)` blocks in
   `HANDOFF.md` and the digests in `research/`.
5. **SUITE STATUS** — the last known `SUITE total=N fails=M`, and when. Make a
   non-zero `fails` impossible to miss.
6. **ATTENTION** — things that need the operator or Claude: unread mail counts
   per agent (`agent_comms.py board` prints them), unmerged remote branches
   (`git branch -r`), digests with no HANDOFF block, and any open task whose
   gate cannot run. `agent_comms.py triage` already computes most of this.
7. **THE SWITCHES.** One per agent: **in rotation / paused.** The operator has
   confirmed they do not need to execute anything — **it is enough that the
   selection is visible and recorded.** See below.

## TIME AND USAGE ARE THE POINT; COST IS A FOOTNOTE

**Operator steer 2026-09-10: cost "is not so important" — time metrics and
usage are what they want to see.** So lead with time, and do not let the page
be organised around a column that is mostly empty.

**Time metrics, per agent and per task — all of these are real and derivable:**

* **Elapsed on the current task** — live, ticking.
* **Duration of each finished task** — first commit to last commit on it.
* **Median and longest task duration per agent**, over its history. This is the
  number that tells the operator who is slow and on what.
* **Idle time** — how long since that agent last landed a commit. **An agent
  idle with no open task is a standing failure in this project**, so make it
  visible rather than merely absent.
* **Time of day** the work landed, so a glance shows when the machine is busy.
* **Turnaround**: assignment timestamp to first commit — how long a task sat
  before anyone started it.

**Usage, measured only:**

* **Commits landed**, **files touched**, **tests added**, **suite result at the
  time it landed** — all from `git log --numstat` and the digests.
* **Codex tokens**, parsed from its run logs, which really do print a
  `tokens used` line.
* Everything else: see below.

## COST: report what is measured, UNKNOWN for the rest

Cost is secondary here, but the honesty rule still binds. **Do not display an
estimated credit figure for any agent whose cost we cannot measure.** This is the same rule as `MINIMUM_WEEKS` in `GradeLadder` and it has
already been enforced twice this week: an absence is a finding, an invented
number is a claim.

* **Codex** genuinely reports usage — its run output contains a `tokens used`
  line. Parse it from the captured run logs and show the real number.
* **Qwen, Grok, Cursor, Claude**: we have **no per-task cost signal at all**.
  Show `UNKNOWN`, not a guess, not a model-price multiplication, not
  "approximately".
* What you CAN show truthfully for everyone: **task count**, **wall-clock
  duration**, and **commits landed**. Those are real proxies for effort and
  they are honest.
* Put a one-line note on the page saying which figures are measured and which
  are not, so the operator is never misled about which is which.

**If you find a real usage signal for another agent, use it and say where it
came from.** If you cannot, `UNKNOWN` is the correct and complete answer.

## THE SWITCHES: intent, not execution

A web page **cannot launch an agent** — only a live Claude session can. A
toggle that pretended to start or stop work would be lying to the operator.

So each switch writes to a new state file, **`AgentComms/roster.json`**:

```json
{
  "qwen":   {"in_rotation": true,  "note": "", "changed": "<iso8601>"},
  "grok":   {"in_rotation": false, "note": "operator paused", "changed": "..."},
  "codex":  {"in_rotation": true,  "note": "", "changed": "..."},
  "cursor": {"in_rotation": true,  "note": "", "changed": "..."},
  "claude": {"in_rotation": true,  "note": "", "changed": "..."}
}
```

Claude reads this at the start of every session and **does not assign or
launch a paused agent.** Label the control honestly on the page — something
like "in rotation for the next session", never "Start"/"Stop". Toggling must
take effect in the file immediately and survive a restart.

Add `roster.json` to the repo with all five `in_rotation: true` so the file
always exists.

## Presentation bar

This is the operator's daily surface, so it is held to the same bar as a game
screen: legible hierarchy, real spacing, a status colour that reads at a
glance, and **no dead space on mobile**. Dark by default — it will sit next to
a terminal. No external CDN, no web fonts, no frameworks: one HTML file, inline
CSS and JS, served by the Python server. It must work with no internet.

## Owned files

| File | Note |
| --- | --- |
| `Tools/opsboard/server.py` | New. Stdlib only. Prints the LAN URL on start. |
| `Tools/opsboard/index.html` | New. One page, inline CSS/JS, responsive. |
| `Tools/opsboard/README.md` | New. How to start it; the phone URL; what is measured vs UNKNOWN. |
| `AgentComms/roster.json` | New. All five `in_rotation: true`. |
| `research/U30_DIGEST.md` | New. Short: what is real data, what is UNKNOWN, and why. |

**Do NOT touch** anything under `Godot/scripts/` or `Godot/tests/` — this task
adds no game code. **Do NOT modify `Tools/agent_comms.py`**; call it and parse
its output. `GameState.gd` is 14,769 lines and is irrelevant here.

## Tests

There is no Godot code in this task, so **there is no parse gate and the suite
is not the gate.** Instead:

```
python Tools/opsboard/server.py --selftest
```

Add a `--selftest` mode that parses every data source once, prints one line per
section with the row count it found, and exits non-zero if a source it depends
on is missing or unparseable. That is the gate, and it must pass.

Then start it for real and confirm the page renders with live data. **Run the
Godot suite once anyway before the commit** to prove you broke nothing:
`python Godot/tools/run_tests.py` — target `SUITE total=215 fails=0`, a ceiling
not an exact count. Another agent may be running Godot; a suite line claiming
everything failed is contention, so re-run.

## Done

Commit, **push `master` directly** (you did this correctly on U28 — keep it),
write `research/U30_DIGEST.md`, then send one line:

```
python Tools/agent_comms.py send --from cursor --to claude --topic "U30-done" --body "<commit> <port and LAN url> <which cost fields are real vs UNKNOWN>"
```

`agent_comms.py` writes the mail file but does **not** stage it — `git add` it
into your commit. You missed this on U28. Stage explicit paths only.
Do NOT edit `HANDOFF.md`.

## The trap specific to this task

**The temptation is to fill the cost column.** A dashboard with `UNKNOWN` in
four of five rows looks unfinished, and the instinct is to multiply a token
estimate by a published price and call it "approximate". **Do not.** The
operator asked for costs precisely so they can make decisions with them, which
makes a fabricated figure worse than an empty cell — they would be steering
real work by a number we made up. Show task counts and durations, which are
real, and let `UNKNOWN` stand where it is the truth.

Second, smaller trap: **count and quote exactly.** A smoke test asked you the
line count of an 89-line file and you answered 91. Every number on this page
comes from parsed data — if you cannot parse it, show a dash rather than an
approximation.
