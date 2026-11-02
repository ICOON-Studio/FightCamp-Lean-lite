---
name: feedback_ready_true_is_not_proof_it_launches
description: "A resolver saying ready=true only proves a path matched - prove the mechanism end to end on something you can observe, and never let a .tmp staging folder win a search"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 79d91b9d-dd8f-4640-9607-fe7da8006134
  modified: 2026-09-21T14:12:27.527Z
---

**The ops board's launch resolver reported `ready: true` for the Claude desktop
app, and what it had found was a year-old copy in a staging folder.**

`launch_target.resolve()` fell through its candidate list to a depth-3 walk of
`%PROGRAMFILES%` and returned

    C:\Program Files\WindowsApps.tmp\Claude_1.8555.1.0_x64__...\app\claude.exe

`WindowsApps.tmp` is where Windows stages an MSIX *during an update*, and it is
not cleaned up. It held **1.8555.1.0** while the installed package was
**2.2553.1.0**. A green button that starts the wrong app is worse than one that
admits it cannot find anything, because nobody goes looking.

**Why:** "ready" in a resolver means *a path matched my pattern*. It does not
mean the thing runs, that it is the current version, or that the OS will even
permit launching it — packaged apps under `WindowsApps` are ACL-locked and want
an AppUserModelID, not a path.

**How to apply:**
- **Exclude staging and backup directories from any search**: `.tmp`, `.old`,
  `$`-prefixed. A half-finished install must never win.
- **Prove the launch mechanism on something you can watch.** I could not tell
  whether launching Claude worked, because Claude was already running and would
  just focus. So I ran the identical code path against Calculator's AUMID — a
  packaged app that was *not* running — and watched the process count go 0 → 1.
  That is proof; a 200 or a `ready: true` is not.
- Prefer an identity the OS owns (AUMID, package family) over a filesystem path
  that carries a version number, and make readiness mean *the package is
  installed* rather than *a file exists*.

Related: [[feedback_open_the_output_before_the_gate]],
[[project_opsboard_launch_button]], [[feedback_godot_verification_gate]].
