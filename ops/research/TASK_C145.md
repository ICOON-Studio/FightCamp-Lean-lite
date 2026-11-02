# TASK_C145 — CODEX — THE NAVIGATION GRAPH: WHAT CAN A PLAYER ACTUALLY REACH?

**Agent:** Codex · **Model:** `gpt-5.6-luna` · **Effort:** MEDIUM · **Fast:** off
**Launch:** `Tools\codex_task.cmd <FULL Windows path to this file>` from PowerShell.
**NOT Astra.** The operator's 2026-09-21 ruling is astra for 3D animation design only; this is
a codebase census, so it is luna at medium, the default.

**Branch:** master, main checkout. **Read this file and only the files it names.**
Do NOT read `HANDOFF.md`, `CURRENT_STATUS.md`, `HANDOFF_ARCHIVE.md` or any digest other than
`research/C89_SURFACE_CENSUS.md` (350 lines, the surface census) and
`research/C41_UIKIT_DEAD_FACTORY_AUDIT.md` (60 lines).

**Test tier — RESEARCH, no `.gd` edited: NO GATE AT ALL.** Not the parse gate, not a test.
`git status -s` before staging is the whole check. Your gate is your own check script.

---

## WHY THIS EXISTS

The operator asked for a survey of how to design a logical path to the game's scenes, and the
first question is not a design question — it is **what is already there and what can be
reached.** The repo has **6 `*Screen.gd` and 25 `*Panel.gd` = 31 surfaces**, and **seven are
already named `*HubPanel`**: Gym, Office, Rankings, Schedule, Scouting, Staff, Training.

**So the architecture is not a blank page. Nobody knows how much of it is wired.** That is what
you are measuring. **Do not design anything** — that is the operator's call and Claude's to
synthesise. You are drawing the map that exists.

## WHAT TO PRODUCE

### 1. THE SURFACE TABLE — all 31, one row each

For every `*Screen.gd` and `*Panel.gd` in `Godot/scripts/`:

- its name and line count
- **is it MOUNTED anywhere?** grep for who instantiates or preloads it. Give `file:line`.
- **is it a ROOT, a CHILD, or a MODAL?** State how you decided — a modal is typically
  constructed over a parent and dismissed, a child is mounted into a parent's container.
- **what mounts it, and what does IT mount?** Parent and children, by name.

### 2. THE REACHABILITY GRAPH — from boot

Start at the boot entry (`BootRoot.gd` / `BootChrome.gd` / `BootStage3D.gd` — find the real
one) and walk outward. For each of the 31 surfaces answer:

- **REACHABLE** — there is a path of user actions from boot to it. **Write the path out**:
  `Boot -> X -> Y -> this`.
- **ORPHANED** — nothing mounts it, or the only thing that mounts it is itself orphaned. These
  are the valuable rows.
- **TEST-ONLY** — the only caller is under `Godot/tests/`. Say so explicitly; this is the
  category most likely to be mistaken for REACHABLE.

**Report the three counts at the top of the digest.** They are the headline.

### 3. THE HUB AUDIT — the seven that claim the name

For each `*HubPanel`: what does it actually contain, how many children does it mount, and is it
reachable? **A "hub" that mounts nothing and is reached by nothing is a filename, not a hub**,
and saying so plainly is the most useful thing this task can do.

### 4. HOW A SURFACE IS PRESENTED TODAY

Count, across the 31: how many are presented as a full-screen push, how many as a modal or
overlay, how many as an inline panel inside another surface. `C89_SURFACE_CENSUS.md` already
counted `UIKit.modal(` call sites per script — **use its numbers rather than recounting**, and
say where yours disagree with it.

## WHAT NOT TO DO

- **Do not propose an architecture, a hub list, or a navigation redesign.** Not one sentence of
  recommendation. A census that editorialises gets its numbers doubted.
- **Do not edit any `.gd`.**
- **Do not read `GameState.gd` whole** — it is ~13,000 lines. `grep -n` then
  `sed -n 'A,Bp'` windows only.

## OWNED FILES

- `research/C145_THE_NAVIGATION_GRAPH.md` (new, the digest)
- `research/C145_graph.py` (new, the census script)
- `research/C145_check.py` (new, the gate)
- `research/C145_graph.json` (new, the machine-readable graph)

## THE GATE

`python research/C145_check.py` must exit 0 and must RECOMPUTE from the source, not read
`C145_graph.json` and agree with it. It must independently:

- re-derive the surface list and assert the count against a **literal pinned in the check
  script** (it is 31 today — if you find a different number, pin YOURS and say why in the
  digest);
- assert every surface the digest calls REACHABLE has a real mounting `file:line` that still
  exists;
- assert every surface called ORPHANED has **zero** non-test mounters;
- assert a degenerate case: an empty surface list reports "no surfaces" rather than dividing by
  zero.

## THE ONE TRAP

**A grep for a panel's name matches its own file, its own `class_name`, its `.uid` file and any
test that loads it.** Count those as mounters and every orphan looks reachable — which inverts
the entire answer. **Exclude the defining file, `*.uid`, and `Godot/tests/` from the mounter
count, and list in the digest exactly what you excluded.** Then sanity-check one known-good
case by hand: `FightHudPanel` should come out REACHABLE, and if your method says otherwise the
method is wrong.

## WHEN YOU ARE DONE

Commit with explicit paths (`git add -- <files>`), push master, then one line:

```
python Tools/agent_comms.py send --from codex --to claude --topic c145-ready --body "<one line>"
```

The CLI takes `--topic`, not `--subject`. Do NOT edit `HANDOFF.md`. Check `git status -s`
before staging; `AgentComms/messages` must be unstaged on any commit that is not the mail.
