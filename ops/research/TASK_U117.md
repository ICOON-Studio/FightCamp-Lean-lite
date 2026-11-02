# TASK_U117 — CURSOR — THE 2→3 SPINE SPLIT, DONE PROPERLY

**Agent:** Cursor · **Model:** composer-2.5 · **Effort:** medium · **Fast:** off
**Launch:** `Tools\cursor_task.cmd <this file> <workspace>` — NEVER `cursor-agent` directly.
**Branch:** `cursor/u117-spine-split` — **branch from `master`, NOT from `u116`.**
**Read this file and only the files it names.** Do NOT read `HANDOFF.md`,
`CURRENT_STATUS.md`, `HANDOFF_ARCHIVE.md`, or any digest other than
`research/U116_LEAN_SURVIVES.md` and `research/S31_THE_AUTHORED_CLINCH.md`.

**Test tier — a `.gd` IS edited:** parse gate first
(`python Godot/tools/check_scripts.py <every .gd you touched>`), then
`python Godot/tools/run_tests.py --only clip`, then `--only pair`, then `--only grapple`.
**`--only` DOES NOT STACK.** **NO full suite** — that is Claude's at integration.
**fails CEILING, matching `AgentComms/last_suite.json` name for name:** `athlete_development`,
`fight_pair_live` (PARKED), `fight_scoring`, `fight_stage_realism`.

---

## THE OPERATOR RULED ON THIS DIRECTLY, 2026-09-21

**"dont merge u116, do the 2 to 3 spine split properly"**

**U116 WAS NOT MERGED.** Only its measurement was kept — `U116_LEAN_SURVIVES.md` and
`tools/u116_spine_probe.gd` are on master; the `FightClipRetarget.gd` change is NOT. You are
starting from the unmodified retarget. **Do not re-apply the U116 silhouette change** —
`CASCADEUR_SILHOUETTE_SEGMENTS` and the gated `UpperChest` correction copy were the workaround
the operator declined. **No more silhouette tuning.**

## THE ACTUAL PROBLEM

**Cascy has TWO spine segments. Our rig has THREE.**

Source: `stomach` → `chest` → `neck`. Ours: `Spine` → `Chest` → `UpperChest` → `Neck`.
`_inherit_upper_chest` currently hands `UpperChest` **Chest's global transform**, so a
three-segment chain is driven as if it were two and one segment contributes nothing of its own.
Every fix so far has been a way of not doing the split.

**Do the split: distribute the source's two-segment bend across our three segments so the
TOTAL Hips→Neck rotation matches, and each segment carries a defensible share.**

Decide the share rule and **state it with its reasoning in the digest**. Candidates, none
pre-blessed: proportional to each target bone's rest length; proportional to the source
segments' own shares; or an even split of the second source segment across Chest and
UpperChest. Measure at least two and report both.

## THE THING U116 FOUND AND THEN THREW AWAY — START HERE

`U116_LEAN_SURVIVES.md:9`, its own words: *"head gap improved but not to the **6%** seen in
one intermediate run."*

**One intermediate configuration got `head_to_head` to 6% drift.** The authored value is
0.216 m; 6% is 0.229 m — essentially exact. **So the lean CAN be restored by this pipeline. It
was restored, and then traded away** while optimising the collar-tie number instead.

**FIND THAT CONFIGURATION AGAIN AND BUILD FROM IT.** Its digest also records that "arm
interpolation, per-frame spine split, and plain `build_corrections` were tried" — a per-frame
spine split is among them, so re-derive what it did and why it was abandoned. If you cannot
recover it, say so explicitly and report what you tried; do not quietly start over.

## THE GATE — TWO NUMBERS, AND THE ORDER MATTERS

```
Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tools/s31_contact_probe.gd -- mma_dirty_boxing
```

**1. FIRST, `head_to_head` drift at or under 10%.** It is 47% on master. This is the LEAN
PROXY: if the lean is right the two heads sit where they were authored. **6% is known
achievable, so 10% is not an ambitious bar — it is a recovered one.**

**2. THEN, `att_lhand_to_vic_neck` as low as you can take it**, reporting the number. It is
545% on master and U116 reached 337% while making `head_to_head` WORSE (47% → 58%).

**A RUN THAT IMPROVES THE COLLAR TIE WHILE `head_to_head` GETS WORSE IS REJECTED**, whatever
the headline says. That is exactly what U116 did and exactly why it was not merged: the
headline moved while the quantity that would CONFIRM the diagnosis moved the wrong way, which
means the hands moved for some other reason. **Report all five rows on every run.**

**`vic_rhand_to_att_larm` must not get worse than its 783% on master** — U116 took it to 908%.

## THE CONTROL ARM — NOT OPTIONAL

```
Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tools/pair_gap_report.gd -- grapple_control
```

must still read `min_gap_m=0.302639 max_gap_m=0.304671`. Eleven bound films ride on the
RamsterZ path. Gate anything that touches shared code on `FightClipRetarget.is_cascadeur_clip`,
as S31's two pair repairs already are.

**AND A SECOND CONTROL ARM THIS TIME:** the split must be a no-op for a source rig that ALREADY
has three spine segments. RamsterZ/UE4 has `spine_01/02/03`, so `UE4_TO_OURS` clips must be
byte-identical. Prove it — do not assert it.

## WHAT IS KNOWN, DO NOT RE-DERIVE

- `_inherit_upper_chest` as a no-op changes **NOTHING** — U116 measured it, drift stayed 545%.
  It is not the cause. Do not spend a pass there.
- Spine locals at t=0 (`tools/u116_spine_probe.gd`): Cascy `stomach` 4.0°, `chest` 9.5°,
  `neck` 34.6°. Retargeted: Spine 15.1°, Chest 16.1°, UpperChest 45.2°.
  **TREAT THOSE AS SUGGESTIVE, NOT AS A BUDGET.** They are quaternion magnitudes including
  twist, about different axes, so they are not directly comparable and the totals do not have
  to match. **If you use them, first project onto the sagittal plane so you are comparing the
  same quantity** — and say in the digest which axis you used.

## OWNED FILES

- `Godot/scripts/FightClipRetarget.gd`
- `Godot/tools/u116_spine_probe.gd` (extend it if you need more axes)
- `research/U117_THE_SPINE_SPLIT.md` (new, the digest, under 70 lines)
- `research/U117_check.py` (new, the gate)

**Touch NOTHING else.** Not `FightClipBinding.gd`, not `PairedStagePlayer.gd`, not
`tools/s31_contact_probe.gd` — that is the instrument you are measured by and editing it is
marking your own homework — and no test.

## THE GATE SCRIPT

`python research/U117_check.py` must exit 0 and must RECOMPUTE: re-run the contact probe
and assert `head_to_head` drift against a **literal pinned to 1 decimal place**, assert
`att_lhand_to_vic_neck` against its own pinned literal, assert `vic_rhand_to_att_larm` is no
worse than 783%, and assert `grapple_control` still reads 0.302639/0.304671 to six places.

## IF YOU CANNOT REACH 10% ON THE HEAD GAP

**That is a result and you ship it.** Report the best you reached, the share rule that got you
there, and which of the candidate rules you measured. A measured partial with a named cause
beats a number massaged into range — and this time the partial has a control arm that says
whether the lean actually moved.

## THE ONE TRAP

**`get_bone_global_pose` returns the REST pose on a headless skeleton** — every angle comes out
constant and wrong while looking fine. Read poses with `FightPoseBridge.globals_at(skel, anim,
t)`, as `s31_contact_probe.gd` and `pair_gap_report.gd` both do.

## WHEN YOU ARE DONE

Commit with explicit paths (`git add -- <files>`), push the branch, then one line:

```
python Tools/agent_comms.py send --from cursor --to claude --topic u117-ready --body "<one line>"
```

Do NOT edit `HANDOFF.md`. **Unstage `AgentComms/messages` before any commit that is not the
mail itself.**
