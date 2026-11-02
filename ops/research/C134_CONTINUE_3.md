# C134 — CONTINUATION 3 — CODEX — **NO SCOPE BOUND**

**THERE IS NO USAGE LIMIT AND THERE IS NO SCOPE BOUND. Operator, 2026-09-20: "no limit on codex
either".** Runs 2 and 3 each stopped because the task file I wrote told them where to stop — run 2
at a bound written for a 5-hour cap that had already been lifted, run 3 at "the three things". That
was my mistake twice. **This file has no such list. Work until C134 is visually acceptable or until
you hit something you genuinely cannot do, and say which.**

`codex exec` is one-shot, so this file is the whole context.

Launch (PowerShell, from anywhere):

```powershell
$env:CODEX_REPO   = "C:\Users\user\AppData\Local\Temp\FightCamp-C134"
$env:CODEX_MODEL  = "gpt-6-astra"
$env:CODEX_EFFORT = "medium"
& "C:\Users\user\OneDrive\Documents\ChatGPT\Game\Tools\codex_task.cmd" `
    "C:\Users\user\AppData\Local\Temp\FightCamp-C134\research\C134_CONTINUE_3.md" `
    "$env:TEMP\c134_cont3_last.txt"
```

---

## READ FIRST, IN THIS ORDER, AND NOTHING ELSE

1. `research/C134_BJJ_PRESENTATION.md` — **your own digest, three runs deep.** The handover.
2. `research/TASK_C134.md` — the original task: ownership, assets, licences, acceptance.
3. `research/M20_THE_SHOT.md` — **NEW, and you have not seen it.** Maria's camera spec,
   collected out of the group chat on 2026-09-20 after being unreachable for nine days. It is the
   answer to the occlusion problem you found. See below.

Everything from runs 1–3 is committed and pushed on `codex/c134-bjj-presentation` (`dad2bb59`).
Your workspace `C:/Users/user/AppData/Local/Temp/FightCamp-C134` is unchanged, with `.godotbin/`
and the warm import cache. **Do not redo stage 1. Do not re-audit the assets. Do not rebase.**

Fixture: **seed 77321.**

---

## WHAT IS SETTLED — ACCEPTED AS TRUE, DO NOT RE-DERIVE OR RE-ATTEMPT

- **The mount placement fix WORKED** (180° about the posed hips, −0.12 m on the shared pair X) and
  it is the template for placement work.
- **The seam verdict was right.** "Every film completes" was the wrong expectation; a mount-only
  film must end when the displayed seat departs. `seat_cut` is the correct distinction.
- **The terminal-mount hang is fixed** and FIGHT OVER – SUBMISSION is visibly verified.
- **HAND-AUTHORING A HOLD IS CLOSED. DO NOT TRY IT AGAIN.** Four original resources, four
  iterations, rejected on your own visual evidence. That verdict stands and it was the right call.
- **PURCHASING IS THE OPERATOR'S AND IT IS NOT YET DECIDED.** Claude checked two leads on
  2026-09-20 (`research/R144_LINE12_SKU_SEARCH.md`): the Unity Asset Store's
  "Grapple Animation Pack" (EUR 13.80) whose name matches perfectly is a **grappling-hook** pack —
  `anim_FreeSwing`, `anim_Jump_*`, zero ground work — and RamsterZ's front page lists nothing
  ground-based. **No SKU is verified. Propose, never buy.**

---

## WHAT IS LEFT, IN YOUR OWN WORDS — AND THE ONE I WANT FIRST

Your run-3 digest names these as unmet: **tap hand gesture, animated separation** (bodies snap to
standing and the camera catches up), **several ground positions unshown**, the **armbar retarget
cause unproven**, and on the MMA route **no ground film at all plus arena posts occluding the
fighters, notably at 250 s**.

### START WITH THE ARMBAR RETARGET CAUSE, BECAUSE IT DECIDES EVERYTHING ELSE

You wrote: "No accepted rigid placement found; **exact retarget cause remains unproven**." That
sentence is the most valuable thing in the digest and it is unfinished. **Prove it.**

The question is: is a bought paired ground film placeable AT ALL on these rigs, or is the retarget
itself wrong? Two offsets failed to establish wrist grip AND leg/torso relationship *through the
roll*, which smells like the two halves drifting apart over time rather than a constant offset —
and that is a different defect with a different fix.

**Why this comes first: if the retarget cannot hold a bought paired film together, then buying a
side-control SKU will not fix C134 either, and the operator is about to be asked to spend money on
exactly that.** A proven answer here is worth more than three more positions.

Measure it rather than eyeballing it: take the two halves' joint positions per frame and report
whether the attacker's grip point and the victim's wrist **diverge over the clip** (drift) or sit at
a fixed offset (placement). C104/C105's foot-lock work and `tools/c134_hold_review.gd` give you the
pattern. Name the number.

### THEN THE OCCLUSION, BECAUSE YOU NOW HAVE MARIA'S SPEC

`M20_THE_SHOT.md` is new to you and it directly answers "arena posts occlude fighters":

- **Q55's establishing shot does NOT survive** — `(0, 1.80, 2.60)` / `look_at` 0.35 / fov 42 is
  ground-fight scale, too close, too much floor.
- Replace with **M14 HOME**: eye **3.8–4.2 m above the FLOOR**, stand-off **9–11 m**, pitch
  **−20 to −22°**, **fov 50**, `look_at` the pair's mid-torso (deck + ~1.0 m).
- **The camera must be told RING deck 1.2700 m vs CAGE 0.1300 m** (MEASURED) — eye is above the
  FLOOR, not above the canvas.
- Always in frame: both fighters' full silhouettes.

The five boards `m20_01…m20_05` are images still in Maria's 1:1 chat and are NOT in the repo; work
from the numbers.

### THEN: animated separation, the tap gesture, and any ground position you can show honestly

No ordering imposed. **A wrong position is worse than no clip** — unshown and reported is success,
faked is failure. That rule has not changed and it is why runs 2 and 3 were worth having.

---

## WHAT IS NOT YOURS

- **NO ENGINE EDITS.** Report, do not edit. That includes the two findings you keep correctly
  reporting and which Claude owns: BJJ bouts carrying unnamed head-contact IMPACT actions with wear
  (41 by 120 s), and grapple events losing presentation priority to action beats.
- **NO PURCHASES.** SKU, id, price, then stop.
- **NO HAND-AUTHORED HOLDS.** Closed, see above.
- **NO FULL SUITE.** Claude's at integration.
- **NO REBASE.** Claude merges your branch.

## THE TREE WILL MOVE UNDER YOU, AND THAT DRIFT IS MINE NOT YOURS

S26 landed the fight's pace calibration on master and Claude is now landing the **damage half** in
the same arc (`ImpactModel.WEAR_SCALE` and `HEAD_SHOCK_BASE`, against 3.9% knockdowns per landed
distance power-head strike and 63.5% of knockdowns ending KO/TKO). **Both move every seeded
trajectory, so seed 77321's beat timeline will change again.**

- **Re-run your review harness before trusting any timestamp in your own digest.**
- **If a test of yours goes red because a bout changed, that is engine drift and it is Claude's to
  re-pin — say so in the digest and move on. Do not re-pin engine numbers and do not tune your
  presentation to chase a moving bout.**
- You already handled this correctly once: run 3 reported "S26 is already in this worktree, seed
  77321 MMA now schedules zero grapple films" without changing an engine pin. Keep doing that.

## GATES

```
GODOT_EXE=%CD%\.godotbin\Godot_v4.7.2-stable_win64_console.exe
python Godot/tools/check_scripts.py <touched .gd>
python Godot/tools/run_tests.py --only c134   (then --only grapple, --only pair, --only stage)
```

**Ceilings, not exact counts — if you land better, say so and push.**
- `--only c134`: **fails=0.**
- `--only grapple`: **fails=2 or better** — run 3 left 2 and documented both; four seam occurrence
  assertions went red on engine drift, which is mine.
- `--only pair`: **fails=1 or better** — `fight_pair_live` is PARKED by the operator's 2026-09-15
  ruling and is not your failure.
- `--only stage`: **fails=1 or better** — `fight_stage_realism` was red before you touched anything.

## THE RULES THAT STILL BIND YOU

- **Green tests do not finish this. The deliverable is what the operator sees moving.**
- **Open the output before trusting the gate** — you did this four times across three runs and it
  is why the work is trustworthy. Keep doing it.
- **Commit after each step. An honest partial beats an uncommitted whole.** Run 1 lost nothing only
  because its work was found on disk; do not rely on that.
- **THE SCRATCH DIRECTORY IS NOT A BIN.** A recording pair is ~1.7 GB. Delete the previous `.avi`
  for a route before re-recording, or write to the same filename. At most ONE recording per route.
  `.c134/` is never committed.
- Stage explicit paths (`git add -- <paths>`, then `git show --stat HEAD`). The worktree carries
  ~1,000 `.import` files, ~700 extracted textures and a multi-GB `.c134/` scratch — none of it is
  yours and none of it is ever committed.
- Push `codex/c134-bjj-presentation`, update `research/C134_BJJ_PRESENTATION.md`, and send
  `python Tools/agent_comms.py send --from codex --to claude --subject "C134 ready"`.
  Do not edit `HANDOFF.md`.
