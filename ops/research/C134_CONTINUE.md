# C134 — CONTINUATION 1 — CODEX

*(Deliberately NOT named `TASK_*`: C134 is one task with one open row on the board, and a
second `TASK_` file would show Codex holding two.)*

**This is the prompt for the SECOND Codex run on C134.** The first run was cut off by the 5-hour
usage limit at 189,061 tokens on 2026-09-20, mid-edit. It does **not** resume: `codex exec` is
one-shot and its conversation thread is gone. This file replaces that context.

Launch it (PowerShell, from anywhere):

```powershell
$env:CODEX_REPO   = "C:\Users\user\AppData\Local\Temp\FightCamp-C134"
$env:CODEX_MODEL  = "gpt-6-astra"
$env:CODEX_EFFORT = "medium"
& "C:\Users\user\OneDrive\Documents\ChatGPT\Game\Tools\codex_task.cmd" `
    "C:\Users\user\AppData\Local\Temp\FightCamp-C134\research\C134_CONTINUE.md" `
    "$env:TEMP\c134_cont_last.txt"
```

To watch it live, run that inside a visible PowerShell window and pipe through
`Tee-Object -FilePath <log>`. **A watcher must key on the PROCESS exiting, not on the out-file
existing** — the out-file survives from the previous run and will fire a false completion.

---

## READ FIRST, IN THIS ORDER, AND NOTHING ELSE

1. `research/C134_BJJ_PRESENTATION.md` — **your own digest from run 1.** It is the handover.
2. `research/TASK_C134.md` — the original task: ownership, assets, licences, acceptance.

Everything from run 1 is **already committed and pushed** on your branch
`codex/c134-bjj-presentation` (`812d0fd6`). Your workspace
`C:/Users/user/AppData/Local/Temp/FightCamp-C134` is unchanged and still has `.godotbin/` and the
warm import cache. **Do not redo stage 1. Do not re-audit the assets. Do not rebase.**

---

## WHERE RUN 1 GOT TO — ACCEPTED AS TRUE, DO NOT RE-DERIVE

Shipped and committed: the `discipline`/`rounds` parameters (BJJ was silently running **boxing**),
BJJ on `MatRig` with a validated `grappling_mat` spec, the source-and-destination binding gate, the
refusal counters, and BJJ action beats counted as **unshown** rather than borrowing generic strikes.

Not done, and this is the remaining work:

- **No original animation was authored.** `guard`, `half`, `side`, `back` and `over_under` holds are
  still unshown. This is the largest hole and a BJJ match is mostly held positions.
- **Tap and release** unverified and unshown.
- The films that DO play carry defects you measured yourself: body/limb intersections in the mount
  (~5.5 s), disconnected armbar contacts (9.5–11.5 s), questionable strangle contact, abrupt pose
  changes at clip boundaries.
- The digest's final section still reads `PENDING_FINAL_RESULTS`.

Your fixture is **seed 77321** (810039 produces no grapple beats in 120 s on either route).

---

## THIS RUN'S SCOPE — BOUNDED ON PURPOSE, DO NOT EXCEED IT

The usage limit is real and it will cut you off again. **Do the smallest thing that proves the
route, in this order, committing after each.**

### 1. Fix the mount contact defect (highest value, no new assets)

The mount hold is the one seat that already plays. It intersects. Fix the paired offset / contact
so the two bodies sit correctly — this is `.pair.json` offset work and `FightStagePlayer`
positioning, not new film. **A correct mount beats five wrong positions.**

### 2. Author ONE held position end to end: `side` control

Prove the authoring route with a single seat before spending on more. A two-body HOLD is a static
pose per body plus small idle motion — cheap compared to anything dynamic. Put it under
`Godot/assets/anim/authored/` with a manifest entry marking it **authored**, not bought. Bind it,
show it, record it.

**If after an honest attempt you conclude a hold cannot be authored to an acceptable standard with
the tools available, STOP AND SAY SO with what you tried.** That is a valid, useful result and it
is the trigger for a purchase proposal — which the operator must approve, and which you must not
act on yourself.

### 3. Fill in `PENDING_FINAL_RESULTS` and re-record

Only after 1 and 2. Gates, evidence, and the two match recordings.

**THE SCRATCH DIRECTORY IS NOT A BIN — KEEP IT BOUNDED.** Run 1 left **2.4 GB** of `.avi` in
`.c134/` (`bjj-final-77321` 969 MB, `mma-final-77321` 687 MB, `mma-77321` 418 MB, `bjj` 212 MB,
`sequence` 82 MB). A recording pair costs about 1.7 GB, so accumulating a set per run fills the
disk in a few runs.

- **Delete the previous `.avi` for a route before you re-record it**, or write to the same filename
  so it is overwritten. Never add a new timestamped name per attempt.
- **Keep at most ONE recording per route** — the current `bjj` and the current `mma`. The `.log`
  and `.jpg` files are small and may stay.
- `.c134/` is never committed, and the digest already carries the commands that regenerate any of
  it, so nothing there is precious.

**Do not start step 2 before step 1 is committed.** If you run low, commit what works and write the
digest — an honest partial is worth far more than an uncommitted whole. **Run 1 lost nothing only
because Claude found the work on disk; do not rely on that twice.**

---

## GATES

```
GODOT_EXE=%CD%\.godotbin\Godot_v4.7.2-stable_win64_console.exe
python Godot/tools/check_scripts.py <touched .gd>
python Godot/tools/run_tests.py --only grapple      (also --only pair, --only stage)
```
`fight_pair_live` and `fight_stage_presenter_contract` are **red on purpose** by the operator's
ruling — not your failures. Never run the full suite; that is Claude's at integration.

Watch it with `.godotbin\Godot_v4.7.2-stable_win64.exe --path Godot --rendering-method
gl_compatibility --script tools/c134_match_review.gd -- seed=77321 discipline=bjj`.

---

## THE RULES THAT STILL BIND YOU

- **A wrong position is worse than no clip.** Unshown and reported is success; faked is failure.
- **Green tests do not finish this.** The deliverable is what the operator sees moving.
- **The engine is not yours.** Report it, do not edit it — including the finding you already made,
  that a BJJ bout carries head-contact IMPACT actions with wear.
- **Never purchase.** Propose, with SKU, id and price, and stop.
- Stage explicit paths (`git add -- <paths>`, then `git show --stat HEAD`). The worktree carries
  ~1,000 `.import` files and ~700 extracted textures of Godot churn and a 2.4 GB `.c134/` scratch —
  **none of it is yours and none of it is ever committed.**
- Push `codex/c134-bjj-presentation`, update `research/C134_BJJ_PRESENTATION.md`, and send
  `python Tools/agent_comms.py send --from codex --to claude --topic "C134 ready" --body "<one line>"`.
  Do not edit `HANDOFF.md`.
