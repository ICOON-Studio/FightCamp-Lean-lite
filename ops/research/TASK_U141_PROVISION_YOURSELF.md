# TASK_U141 — CURSOR — PROVISION YOURSELF, AND TELL ME WHAT YOU WERE MISSING

**Model: `composer-2.5`, medium effort.** Fresh branch off `origin/master` named
`cursor/u141-provision`. **Run this AFTER U140 lands** — one task per launch.

---

## WHY YOU ARE BEING ASKED THIS

The operator asked me what tools, plugins or MCP servers he should install for
you. I gave him my guesses. **You are better placed to answer it than I am**,
because you are the one that hits the wall.

His instruction was: *"ask it to install whatever it needs"*. That is now a
standing rule in `.cursor/rules/00-project.mdc` — you do not need permission to
install a package; you need to make it survive the container and say what it
bought.

This task is the audit that makes that rule useful.

---

## WHAT I WANT

### 1. What did you actually lack?

Go back over your own recent work — U136 (capsule overlay), U138, U139 (the blind
contract test), U140 (the room's look). For each, answer honestly:

- **Where did you guess because you could not measure?** Not "it would have been
  nice to have" — where did a missing tool make you write something you could not
  verify?
- **Where did you burn time on something a tool does in one call?**
- **What did you decline to attempt** because the environment could not support
  it?

That list is the deliverable. Everything below is secondary to it.

### 2. THE ONE I MOST WANT ANSWERED: can you see?

**Nearly every task on this project is judged by eye.** U140 is a before/after
render. The clip audit is contact sheets. The arena is a picture. The project's
own rule, paid for four times, is that a green gate on an unwatched clip means
nothing — `boxing_double_jab` was bound to a single jab and nobody noticed for
weeks.

You can PRODUCE images: Xvfb and Mesa are installed so the non-headless
`tools/render_*.gd` and `tools/capture_*.gd` scripts work in your container.

**But can you READ one back?** Can you open a PNG you just rendered and say what
is in it? Test it — render something, try to look at it, and report plainly
whether you can. If you cannot, say so, because it changes how every visual task
on this project should be written: I would stop asking you to judge renders and
start asking you to produce them with numeric assertions beside them.

### 3. Godot API accuracy

This repo has a standing section titled *"GDScript gotchas that cost a fix cycle
every stage"* — Variant inference, `%%` in format strings, redeclared variables,
anchors versus size, autoload identifiers in scene scripts. Some of that is
Godot 4.7 API surface that is easy to get subtly wrong.

Would a **Godot editor MCP** help? Several exist —
`hybridindie/godot-mcp` (184 tools, inspection-only by default),
`AkiraZ1/godot-mcp`, `Coding-Solo/godot-mcp`, `godot-editor-mcp` on PyPI. I have
run none of them and I am not recommending one.

**The open question is whether a LIVE EDITOR session even works in your
container**, which is headless Linux with Xvfb. If you want to try one, try it,
and report whether it runs at all before reporting whether it helps. A negative
result here is genuinely useful — it would close a question I cannot close from
this side.

### 4. Install what you need

Per the standing rule: install it, **add it to `.cursor/install.sh`** under the
same idempotent guard the existing five steps use, and say what it bought.

Already present, do not reinstall: Godot 4.7.2 at `$GODOT_EXE`, python3 as
`python`, Xvfb + Mesa, the import cache.

Worth knowing from 2026-09-23: `rtmlib` + `onnxruntime` is a two-stage
multi-person pose pipeline that found two people on **100%** of close-grappling
frames where MediaPipe Pose found them on **0%**. Keep MediaPipe beside it, not
instead of it — RTMPose is 17 keypoints in pixels, MediaPipe is 33 world
landmarks in metres, and metres is what retargeting needs.

**And weigh this against installing anything:** the repo already carries roughly
220 Godot tools and 116 drivers, indexed in `RESEARCH_INDEX.md` — **grep it,
never read it whole.** A package that duplicates one of those adds a second thing
to keep in step. Say what you checked for before installing.

---

## GATE

- If you touch `.cursor/install.sh`, **run it** and show it completes.
- Parse gate any `.gd` you touch.
- **No full suite.** If you install nothing that affects the engine, no test run
  is needed at all — this is largely a research task and `git status -s` is the
  whole check.

## WHAT TO SEND

`research/U141_DIGEST.md`, then one line with
`python Tools/agent_comms.py send --from cursor --to claude --subject U141`
naming the branch. Do NOT edit `HANDOFF.md`.

**The most valuable section will be the honest one:** what you could not do, and
what you faked your way around. Nobody is marking you down for it — that list is
the entire point of the task.
