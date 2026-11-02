---
name: project_c134_bjj_presentation
description: "C134 - Codex finishing the BJJ/grappling 3D presentation; run 1 cut off by the 5h limit, run 2 relaunches from a file in the repo"
metadata: 
  node_type: memory
  type: project
  originSessionId: a3475d8c-1635-429c-ad7f-025c0811adb7
  modified: 2026-09-20T13:20:08.791Z
---

Assigned 2026-09-20. **Run 1 was cut off by Codex's 5-hour usage limit at 189,061 tokens, mid-edit,
with every file uncommitted.** Claude found the work on disk, parse-gated it (fails=0) and pushed it
as `812d0fd6` on `codex/c134-bjj-presentation`.

**Codex does not resume.** `codex exec` is one-shot and the thread is gone. Run 2 starts cold from
**`research/C134_CONTINUE.md`** — a file in the repo, deliberately, because the first
prompt lived in a session scratchpad that a `/clear` would orphan. It carries the launch line
(`CODEX_REPO=…FightCamp-C134`, `CODEX_MODEL=gpt-6-astra`, `CODEX_EFFORT=medium`; `codex_task.cmd`
honours all three) and run 2's scope: fix the mount contact defect, author ONE held position (side
control), then fill `PENDING_FINAL_RESULTS` — committing after each.

**Run 1's real finds:** `discipline=bjj` was silently running **boxing**; the arena defect was deeper
than the task said (`ArenaSurface` pointed BJJ at an incomplete `bjj_ibjjf` preset while the room
built every spec with `ArenaRig` — now `MatRig` + a validated `grappling_mat`); a binding gate that
checks source *and* destination seat; BJJ beats counted as **unshown** rather than borrowing generic
strikes. **Not done:** no animation authored, so guard/half/side/back holds stay unshown, tap and
release unverified, and the films that do play have measured contact defects.

**It corrected the task three times, all fairly** — 12 unarmed + 4 weapon pairs (not 13); the task
understated what already existed; and **seed 810039, which the task named, produces no grapple beats
at all in 120 s** — 77321 is the fixture.

**Engine defect it reported and did not fix (correctly):** a BJJ bout's `FightRealtime` log carries
head-contact IMPACT actions with wear (seed 77321, tick 16, `head_neck`, wear 0.067). Strikes are
landing in a submission-grappling ruleset; presentation suppression does not repair damage or
scoring.

**Two traps worth keeping:** Codex's sandbox cannot execute a binary outside its workspace — that is
what "Codex cannot boot Godot" always meant; both Godot exes now sit in `.godotbin/` in the worktree
and both are needed. And a completion watcher must key on the **process exiting**, never on the
out-file existing — the out-file survives the previous run and fires a false completion.

Related: [[project_agent_host_capabilities]], [[feedback_collect_before_you_assign]],
[[feedback_never_gate_an_extremum]].
