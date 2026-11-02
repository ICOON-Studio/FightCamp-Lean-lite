# TASK U63 — CURSOR — THE OPS BOARD LEARNS THE ROADMAP

Model: Composer, **medium effort**. Owner: cursor.

**Test tier: NO GODOT AT ALL.** This is the Python/HTML ops board, not game code.
No parse gate, no `.gd`, no test suite. The gate is that the page renders
correctly on a phone-width viewport and the server still starts with one command.

Read THIS FILE and the files it names. Do NOT read `HANDOFF.md`,
`CURRENT_STATUS.md`, `HANDOFF_ARCHIVE.md` or any digest.

---

## WHY THIS EXISTS — THE OPERATOR'S ASK, VERBATIM

> *"I want a proper plan of what the next 5-10 sessions will be focused on and I
> want to be able to see this on the opsboard. And on it also I want to be able
> to see what is being worked at the moment and what the next task is with a
> short summary of each session. Also on the opsboard I want a proper roadmap for
> the completion of each stage and of the whole game overall."*

**The roadmap already exists and is already written.** You are not authoring it.
You are rendering it.

## THE SOURCE — AND THERE IS EXACTLY ONE

`AgentComms/roadmap.json`. Read it whole; it is small.

**DO NOT hand-copy any of its content into `index.html` or `server.py`.** Not the
session titles, not the stage names, not the percentages, not the blocked
questions. The server reads the JSON and serves it; the page renders whatever it
is given.

This is not a style preference. **This project found EIGHT instances in one day of
a fact authored in one place, hand-copied into a second, and the copy drifting
while a gate checked the copy** — a validator with its own vocabulary, a test with
its own copy of a screen's dictionary, a const with its own copy of a data file.
`Tools/render_roadmap.py` already renders `ROADMAP.md` from this same JSON for
exactly that reason. **A third copy pasted into the board's HTML would be the
ninth instance, in the tool built to watch for them.**

If a field you want is not in the JSON, **add it to the JSON**, do not inline it.

## WHAT TO ADD TO THE BOARD

The board is `Tools/opsboard/` — a stdlib Python HTTP server plus one responsive
page, currently serving: Suite status, Now, Attention, Usage proxies, History.
It runs at `127.0.0.1:8787` and on the LAN for the operator's phone.

Add these, in this order down the page, **above** the existing Usage and History
sections and **below** Suite status:

### 1. NOW / NEXT — the top of the page, the first thing visible

Two cards side by side on desktop, stacked on a phone.

- **NOW**: `roadmap.now` — session id, title, owner, status, the summary, and
  the gate line. Visually the loudest thing on the page.
- **NEXT**: `roadmap.next` — session id, title, owner, summary.

The operator opens this on a phone to answer "what is happening and what is
after it". If they have to scroll to find that, the task has failed.

### 2. WAITING ON YOU

`roadmap.blocked_on_operator` — each entry shows the id, **which session it
blocks**, and the question. If the array is empty, show nothing at all (not an
empty box).

**Make this visually urgent.** These are the only items where the project is
stopped and only the operator can unstop it.

### 3. THE ROADMAP — stages

`roadmap.stages`, in order. Each stage: id, title, the goal line, a **progress
bar** for `percent`, the session ids it covers, and its `done_when` list
(collapsed by default on a phone; a stage with four bullets should not push
everything else off the screen).

### 4. THE SESSIONS — the 5-10 session plan

`roadmap.sessions` as a list or table: id, stage, title, owner, status, summary.
**Mark the `in_progress` one clearly** and visually de-emphasise `planned` ones.
On a phone this must not scroll sideways.

### 5. WHERE THE GAME IS

`roadmap.assessment` — the `one_line` quote, the `source` attribution, and each
entry in `bars` as a labelled progress bar with its note.

## OWNED FILES

| File | Note |
| --- | --- |
| `Tools/opsboard/server.py` | Yours. Add a roadmap endpoint / include it in the payload the page already polls. |
| `Tools/opsboard/index.html` | Yours. Render the sections above. |
| `Tools/opsboard/README.md` | Yours. Document the new sections and that the roadmap source is `AgentComms/roadmap.json`. |

**Do NOT touch** `AgentComms/roadmap.json` (Claude owns it),
`Tools/render_roadmap.py`, `ROADMAP.md`, anything under `Godot/`, or
`HANDOFF.md`. Do NOT modify `Tools/agent_comms.py`.

## THE GATE

- `python Tools/opsboard/server.py` still starts with one command, stdlib only,
  no npm, no build step, and still prints the LAN URL.
- The page still auto-refreshes without the operator touching it, and the new
  sections refresh with it.
- **No horizontal scrolling at 390pt width, anywhere, ever.** That is the
  original U30 requirement and it still binds.
- Every existing section still works. This is additive.
- **If `AgentComms/roadmap.json` is missing or unparseable, the board must still
  serve the rest of the page** and say plainly that the roadmap could not be
  read. It must not white-screen.

## THE TRAP SPECIFIC TO THIS TASK

**The percentages in the JSON are someone's judgement, not measurements, and the
board must not dress them up as measurements.** `assessment.bars` carries a
`source` field naming who assessed it and when — render that attribution beside
the bars. A progress bar with no provenance reads as a fact; this project has
spent a whole day on numbers that read as facts and were not.

Second: the operator reads this **on an iPhone, one-handed**. Every decision
between "more information" and "fits on the screen" goes to fits on the screen —
the detail is in `ROADMAP.md` for the desktop.

## WHEN YOU ARE DONE

```bash
git add -- Tools/opsboard/server.py Tools/opsboard/index.html Tools/opsboard/README.md
git commit
git push origin master
python Tools/agent_comms.py send --from cursor --to claude --subject U63-done --body "sections=<N> phone_width_ok=yes|no roadmap_read_from=AgentComms/roadmap.json"
```

Check `git status -s` before you stage. **Push to `master` and leave HEAD on
`master`.** Do NOT edit `HANDOFF.md`.
