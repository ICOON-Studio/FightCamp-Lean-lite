# C134 — CONTINUATION 4 — CODEX — **BLENDER AND HIGGSFIELD ARE YOURS NOW**

**The operator granted these two on 2026-09-20: "make sure codex has access to the blender plugin
and higgsfield".** No scope bound, no usage limit. Runs 2 and 3 stopped only because my task files
told them where to stop; this one does not.

`codex exec` is one-shot, so this file is the whole context.

```powershell
$env:CODEX_REPO   = "C:\Users\user\AppData\Local\Temp\FightCamp-C134"
$env:CODEX_MODEL  = "gpt-6-astra"
$env:CODEX_EFFORT = "medium"
& "C:\Users\user\OneDrive\Documents\ChatGPT\Game\Tools\codex_task.cmd" `
    "C:\Users\user\AppData\Local\Temp\FightCamp-C134\research\C134_CONTINUE_4.md" `
    "$env:TEMP\c134_cont4_last.txt"
```

---

## STEP 0 — REPORT WHAT YOU CAN ACTUALLY REACH, BEFORE ANYTHING ELSE

**I do not know whether your sandbox can do either of these, and guessing would waste your run.**
You are launched `-s workspace-write` scoped to your worktree, which restricts WRITES and may also
restrict the network. So first, cheaply, and report the answers in your digest:

1. Can you EXECUTE `D:/Tools/Blender/blender-5.2.1-windows-x64/blender.exe --version`?
2. Can you WRITE to your own worktree and to `$env:TEMP`? (Assume you cannot write to `D:`.)
3. Do you have NETWORK access? `blender --version` needs none; Higgsfield needs it.

**If Blender runs but the network does not, do the Blender work and say Higgsfield is unreachable
from your sandbox — I will drive it from mine.** Do not spend the run fighting the sandbox.

---

## WHY THIS MATTERS TO YOUR OWN FINDING — READ THIS FIRST

You proved the armbar defect rather than patching around it: **retargeting discarded 1.020 m X and
0.844 m Z of the attacker's hip travel.** That is the single most useful thing in three runs,
because it says a bought paired film cannot be placed correctly by offsets at all — the motion was
already destroyed upstream. It is also why no side-control SKU would have fixed C134.

**THE RETARGET ADD-ON IS IN THAT BLENDER.** So the defect you proved is now fixable at its source
instead of compensated for downstream. That is the highest-value thing in this file. Authoring a
hold from nothing stays CLOSED — you tried it four times and rejected it correctly.

## BLENDER — WHAT IS INSTALLED AND THE FIVE TRAPS ALREADY PAID FOR

`D:/Tools/Blender/blender-5.2.1-windows-x64/blender.exe`, portable build, config in its own
`portable/` folder. **The add-ons are installed ONLY in this copy** — the operator's
`C:/Program Files/Blender Foundation/Blender 5.2/` has neither. Run headless:
`blender.exe --background --python <script.py> -- <args>`.

**Retarget extension v5.2.0** (KBS-DEV, GPL) at `portable/extensions/user_default/retarget/`,
158 operators, core is `armature.retarget_*`. Working scripts are in the repo at
`Tools/blender_bakeoff/`, and the write-up is `research/BAKEOFF_BLENDER_RETARGET.md`.

Five traps, all found on 2026-09-14 and all still true — **do not rediscover these:**

1. A RamsterZ FBX imports as **68 EMPTIES, not an armature**. Rebuild an armature from
   `T_pose.fbx`, aim the bones joint-to-child, bake the clip through a constant per-bone offset.
2. "Bind to Active Armature" constrains the SELECTED rig to the ACTIVE one — so the
   **clip-carrying rig must be the active one**.
3. Called from a script, the bind needs the class default `current_m` set, and **the add-on's own
   bake makes no action while reporting FINISHED**. Bake with
   `nla.bake(visual_keying=True, clear_constraints=True)` instead.
4. Import our Tripo GLBs with `bone_heuristic="TEMPERANCE"`. The default leaves arm bones sideways
   and leg bones pointing UP.
5. Blender 5 API: `Bone.select` is gone — use `bpy.ops.pose.select_all`.

**Your hip-travel finding is trap-1 territory.** A constant per-bone offset bake is exactly the
thing that would discard root translation, so look there first.

## HIGGSFIELD — HOW IT AUTHENTICATES, WHAT IT COSTS, AND WHAT IS ALREADY MEASURED

**There is no API key anywhere in the repo and you must not create one.** Higgsfield authenticates
through its own Blender add-on (`bl_ext.user_default.higgsfield_blender`) by DEVICE SIGN-IN: the
add-on prints a code and **the operator approves it on their phone**. `Tools/higgsfield/signin_addon.py`
runs that flow in headless Blender. If a session is already live in the portable Blender's config,
you inherit it; if not, print the code, say so, and stop — **do not try to obtain credentials any
other way.**

**Cost and the one hard rule:** text-to-motion is **0.1 credit per job whatever its length**, and
there are ~923.9 credits. **ONE ACTION PER JOB.** A 24-of-30 sample of multi-beat timelines FROZE;
a 7-second, 8-shot timeline cost the same 0.1 as a one-second clip, so there is no reason to batch
beats into one job. Drivers: `Tools/higgsfield/t2m_batch.py`, `render_t2m_best.py`, `score_t2m.py`,
`compose_takedown.py`.

**AND THE GRAPPLING ANSWER IS ALREADY MEASURED NEGATIVE — DO NOT PAY TO RE-RUN IT.**
`research/HIGGSFIELD_MMA_PIPELINE_STUDY.md`: 8 two-fighter generations across two prompt
styles and two seeds came back as **ONE BODY, 8 of 8**; of 4 armbar prompts **none reached the
ground at all** (three stood, one "sat" in the air); and `compose_takedown.py` scored **0 of 36** on
deliberately aligned pairs — every attacker stops at the grab (follow-through 0.00–0.06 m) and the
torsos interpenetrate in 16–81% of frames.

**What is genuinely untested is narrow:** whether a HELD, static two-body pose behaves differently
from the dynamic entries that were tested. That is worth a handful of 0.1-credit jobs and no more.
**If the first three come back as one body, stop and say so** — that is the same answer again.

## THE ORDER I RECOMMEND, AND YOU MAY OVERRIDE IT WITH A REASON

1. **Step 0's reachability report.**
2. **The retarget fix for the hip travel you measured.** Highest value, needs no credits, and it is
   your own finding.
3. **Re-check the armbar and strangle contacts** once the retarget preserves root motion — they may
   simply come right.
4. **Only then, Higgsfield, and only the held-pose question**, a few jobs at 0.1 each.

## WHAT IS NOT YOURS

- **NO ENGINE EDITS.** Report, do not edit. **AND YOUR LAST REPORT FOUND A REAL ONE: the refreshed
  BJJ bout ends in KO.** That is mine and I am on it — S27 landed the damage calibration and it
  amplified the phantom head-contact impacts you had already flagged in BJJ bouts. A jiu-jitsu match
  ending by knockout is wrong and it is an engine defect, not a presentation one. Keep reporting it.
- **NO PURCHASES.** SKU, id, price, then stop. Still no verified SKU for a ground hold, and your
  hip-travel finding is why buying one would not have helped.
- **NO HAND-AUTHORED HOLDS.** Closed.
- **NO FULL SUITE.** Mine at integration.
- **NO REBASE.** I merge your branch.

## THE TREE MOVED UNDER YOU AGAIN, AND IT IS THE LAST TIME FOR A WHILE

S27 shipped: the pace is calibrated (`throw_gate_base` now defaults to `THROW_GATE_CALIBRATED`),
`WEAR_SCALE` 3.0, `HEAD_SHOCK_BASE` 0.10, the recovery band 0.05/0.45, and
`FightIntent.preferred_range`'s base 1.2 → 1.39 arm lengths. **Knockdowns now convert: 35% of bouts
carry one and 65% of those end by stoppage, against J20's 35.1% and 63.5%.** So seed 77321 looks
different again and bouts END more often.

- **Re-run your review harness before trusting any timestamp in your own digest.**
- **Engine-caused test drift is mine to re-pin, not yours to chase.** You handled that correctly
  twice; keep doing it.

## GATES

```
GODOT_EXE=%CD%\.godotbin\Godot_v4.7.2-stable_win64_console.exe
python Godot/tools/check_scripts.py <touched .gd>
python Godot/tools/run_tests.py --only c134   (then --only grapple, --only pair, --only stage)
```

**Ceilings, not exact counts — land better and say so.** `--only c134` fails=0; `--only grapple`
fails=0 (you got it there, keep it); `--only pair` fails=1 or better (`fight_pair_live` is PARKED by
the operator's 2026-09-15 ruling); `--only stage` fails=2 or better (parked presenter contract plus
`fight_stage_realism`, red before you touched anything).

## THE RULES THAT STILL BIND YOU

- **A wrong position is worse than no clip.** Unshown and reported is success; faked is failure.
- **Green tests do not finish this. The deliverable is what the operator sees moving.**
- **Open the output before trusting the gate** — you have done this on every run and it is why the
  work is trustworthy.
- **Commit after each step. An honest partial beats an uncommitted whole.**
- **THE SCRATCH DIRECTORY IS NOT A BIN.** One recording per route, delete before re-recording,
  `.c134/` is never committed.
- Stage explicit paths (`git add -- <paths>`, then `git show --stat HEAD`).
- Push `codex/c134-bjj-presentation`, update `research/C134_BJJ_PRESENTATION.md`, and send
  `python Tools/agent_comms.py send --from codex --to claude --subject "C134 ready"`.
  Do not edit `HANDOFF.md`.
