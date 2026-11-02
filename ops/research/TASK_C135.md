# TASK C135 — CODEX — CASCADEUR: THE LAST UNTRIED ROUTE TO A HELD GROUND POSITION

**Agent:** Codex · **Model:** `gpt-6-astra`, medium · worktree `FightCamp-C134`
**Assigned:** 2026-09-20 by Claude, at the operator's request
**⏳ DEADLINE: 2026-09-27.** The Cascadeur Pro trial **charges the operator EUR 37.66 on that date
unless it is unsubscribed**, and the operator asked whether we can get the answer first.

**THE DELIVERABLE IS A DECISION, NOT NECESSARILY A SHIPPED POSE.** By the 27th the operator needs
to know one thing: *did this tool solve the held-ground-position problem, or not?* A clear, evidenced
**NO** is a complete and valuable answer and it is worth the same as a yes. Do not stretch to make
it look like a success.

---

## WHY CASCADEUR, AND WHY IT IS THE LAST ROUTE

A sustained ground hold — side control, guard, half, back — is the thing that has defeated every
route this project has tried:

| route | outcome |
|---|---|
| **Hand-authoring** in Godot | **YOU tried it and rejected it** — four original resources, four iterations on torso inclination, bottom frames, crossface and posted arm, and forearm/head clearance, wrist contact and torso pressure all unreliable. Correctly closed. |
| **Generation** (Higgsfield) | **MEASURED NEGATIVE** — 8 of 8 two-fighter generations came back as ONE BODY, 0 of 4 armbar prompts reached the ground, `compose_takedown.py` scored **0 of 36**. |
| **Buying a SKU** | **NONE VERIFIED.** The top-named Unity pack (EUR 13.80, "Grapple Animation Pack") turned out to be a grappling-**hook** pack — `anim_FreeSwing`, `anim_Jump_*`. |
| **Cascadeur** | **NEVER TRIED. This task.** |

**And a held position is a POSE, not a motion** — which is exactly the shape of problem a
physics-aware posing tool exists for. That is the whole reason it is worth a week.

## WHAT I VERIFIED FOR YOU TODAY, SO YOU DO NOT SPEND A RUN ON IT

Measured on this machine 2026-09-20, not recalled:

- **`C:\Program Files\Cascadeur\cascadeur.exe`**, version **2026.2.2.0.16638**, licence active.
- **It drives headless.** `cascadeur.exe --run-python-code "print('CSC_PROBE_OK')"` printed
  `CSC_PROBE_OK` and **finished with exit code 0**. Output goes to its own log stream, so redirect
  and read the log rather than expecting clean stdout.
- The `csc` scripting namespace loads, and the modules that matter are there:
  **`fbx_import`, `rigging`, `rig_gen`, `ml`** (the AI/physics posing), plus `commands`, `samples`,
  `stubs` and `python_api_doc` under `C:\Program Files\Cascadeur\resources\scripts\`.
- **A trap I already hit:** calling a `csc` function that does not exist crashes the app with
  **exit −1 and a Qt stack trace**, which looks like a tool failure and is not. Check `stubs/` and
  `python_api_doc/` for the real signature before calling anything.

## STEP 0 — REPORT REACHABILITY IN ONE LINE EACH

You are `-s workspace-write`. Cascadeur is a LOCAL executable and needs **no network**, so it should
be reachable where Higgsfield was not — but confirm rather than assume:

1. Can you execute `"C:\Program Files\Cascadeur\cascadeur.exe" --run-python-code "print('ok')"`?
2. Can you write its output into your worktree or `$env:TEMP`? (Assume `C:\Program Files` is
   read-only to you.)

**If it will not execute, say so and stop — do not spend the run fighting the sandbox.**

## THE WORK — ONE POSITION, END TO END

**SIDE CONTROL.** One position, not five. You chose it yourself last time and the reasoning holds:
prove the route with a single seat before spending on more.

1. **Get the two rigged fighters into Cascadeur.** `f05_m_mma_light_rigged` and
   `f06_m_mma_lhw_rigged` are the pair the BJJ route already uses. `csc.fbx_import` exists; if GLB
   will not import directly, convert through the portable Blender
   (`D:\Tools\Blender\blender-5.2.1-windows-x64\blender.exe`, headless) — and note Blender trap 4,
   **import Tripo GLBs with `bone_heuristic="TEMPERANCE"`** or the arm bones come in sideways.
2. **Pose them in side control, using the tool's physics/ML posing rather than hand-keying joints.**
   That is the entire point — hand-keying is the route that already failed.
3. **Export and put it through YOUR OWN review harness.** `c134_hold_review.gd` renders four camera
   views; use it, and use the per-frame contact measurement you built to prove the hip-travel
   defect. **Report the residual in metres, not as an impression.**
4. **Judge it the way you judged your own authored attempt — and reject it if it is wrong.** A wrong
   position is worse than no clip. Unshown and reported is success; faked is failure.

## WHAT YOU MUST NOT DO

- **DO NOT SUBSCRIBE, PAY, ENTER PAYMENT DETAILS, OR CHANGE ANY BILLING OR ACCOUNT SETTING.** The
  trial and the EUR 37.66 decision are the operator's alone. If Cascadeur prompts for a purchase or
  a licence action, **stop and report the prompt verbatim.**
- **NO ENGINE EDITS.** Report them; they are mine.
- **NO NEW HAND-AUTHORED HOLDS.** That route is closed and this task is not a way back into it.
- **NO HIGGSFIELD CREDITS.** Unrelated to this task.
- **NO FULL SUITE**, and **NO REBASE** — I merge your branch.

## WHAT "SOLVED" WOULD MEAN, SO THE ANSWER IS NOT A MATTER OF TASTE

State your verdict against these, each with evidence:

1. **Contact.** Do the attacker's chest/arm and the victim's torso hold contact without
   interpenetrating? Give the residual and the interpenetration share of frames — you measured
   16–81% on the composed takedowns, so you have the method.
2. **Plausibility.** Does it read as side control to an eye, in four views, not one flattering one?
3. **Reproducibility.** Can a script regenerate it, or did it take manual GUI work? **This matters
   most for the subscription decision** — a route that needs a human in the GUI for every position
   is a different proposition from one a script can repeat.
4. **Cost per position.** Roughly how long did the one take? Four more positions at that rate is
   the real question behind the renewal.

## GATES

```
GODOT_EXE=%CD%\.godotbin\Godot_v4.7.2-stable_win64_console.exe
python Godot/tools/check_scripts.py <touched .gd>
python Godot/tools/run_tests.py --only c134   (then --only clip)
```

Ceilings: `--only c134` fails=0, `--only clip` fails=0. **If the pose is not bound, no test changes
at all and that is the expected outcome of a NO.**

## RULES

- **Commit after each step. An honest partial beats an uncommitted whole.**
- **Open the output before trusting the gate** — it is how you found the hip travel.
- `.c134/` is never committed. Cascadeur project files and exports go there or in `$env:TEMP`.
- Stage explicit paths (`git add -- <paths>`), then `git show --stat HEAD`. Unstage
  `AgentComms/messages` before committing.
- Push `codex/c134-bjj-presentation`, write `research/C135_CASCADEUR_HELD_POSE.md`, and send
  `python Tools/agent_comms.py send --from codex --to claude "C135 ready"`. Do not edit
  `HANDOFF.md`.
- Reference: `research/AGENT_TOOL_ACCESS.md` has every verified tool path on this machine and
  the five Blender retarget traps.
