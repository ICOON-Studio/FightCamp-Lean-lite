# TASK_U116 — CURSOR — MAKE THE COLLAR TIE SURVIVE THE RETARGET

**Agent:** Cursor · **Model:** composer-2.5 · **Effort:** medium · **Fast:** off
**Launch:** `Tools\cursor_task.cmd <this file> <workspace>` — NEVER `cursor-agent` directly.
**Branch:** `cursor/u116-lean-survives` · **Read this file and only the files it names.**
Do NOT read `HANDOFF.md`, `CURRENT_STATUS.md`, `HANDOFF_ARCHIVE.md`, or any digest other than
`research/S31_THE_AUTHORED_CLINCH.md`. Do not explore to "get oriented".

**Test tier — a `.gd` IS edited:** parse gate first
(`python Godot/tools/check_scripts.py <every .gd you touched>`), then
`python Godot/tools/run_tests.py --only clip`, then `--only pair`, then `--only grapple`.
**`--only` DOES NOT STACK — a second one REPLACES the first. Separate commands.**
**NO full suite** — that is Claude's at integration.
**fails CEILING, matching `AgentComms/last_suite.json` name for name:** the tree's four
baseline reds are `athlete_development`, `fight_pair_live` (PARKED on purpose), `fight_scoring`
and `fight_stage_realism`. A NEW red name is a failure you caused.

---

## WHY THIS EXISTS — AND YOU ALREADY OWN THE SUSPECT

S31 authored a cage clinch in Cascadeur and bound it to `mma_dirty_boxing`. It plays, and its
hips are right. **Its arms are not.** `tools/s31_contact_probe.gd` measures the authored
contacts in the game against what Cascadeur produced:

```
S31CONTACT measure                   authored      min      max     mean    drift
S31CONTACT att_lhand_to_vic_neck        0.073    0.447    0.497    0.471     545%
S31CONTACT att_rhand_to_vic_neck        0.097    0.447    0.500    0.473     387%
S31CONTACT vic_rhand_to_att_larm        0.083    0.710    0.758    0.733     783%
S31CONTACT head_to_head                 0.216    0.307    0.328    0.318      47%
S31CONTACT hip_to_hip                   0.746    0.754    0.802    0.778       4%
```

**READ THE SHAPE, NOT THE WORST ROW.** The error GROWS UP THE CHAIN — hips 4%, heads 47%,
hands 387–783%. A broken arm map would be wrong at the shoulder and no worse at the wrist.
This is a rotation lost low in the spine that the arms inherit and amplify.

**AND IT IS THE LEAN.** Our fighters are 1.047× Cascy, so the authored 0.216 m head-to-head
should arrive at ~0.226 m. It arrives at **0.318 m** — the two men stand straighter than they
were authored. The pose has a **28-degree forward lean**; straighten it and the heads separate
and the hands, furthest out on the chain, stop reaching the other man's neck. Every number
fits that one cause.

**THE PRIME SUSPECT IS YOUR OWN U114 CODE, AND YOU FLAGGED IT AS UNFORECAST AT THE TIME.**
Cascy has no third spine segment, so `FightClipRetarget._inherit_upper_chest` gives our
`UpperChest` **Chest's global `Transform3D`**. Our clavicles and arms hang off `UpperChest`.
**This was never tested** — S31 had already shipped its suite when the defect was found.

## THE WORK, CHEAPEST FIRST

1. **Make `_inherit_upper_chest` a no-op and re-measure.** One line. If the drift falls, the
   lean was being eaten there and the rest is refinement. If it does not move, say so plainly
   and go to 2 — a negative result here is worth reporting, not hiding.
2. **Print the retargeted vs source LOCAL rotation for `Spine`, `Chest`, `UpperChest` at
   t=0** and find which one loses the 28 degrees. Put the per-bone degrees in the digest.
3. **Only then look at the arms themselves.** Do not start here.

## THE GATE — ONE NUMBER, AND IT IS NOT THE HIP GAP

```
Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tools/s31_contact_probe.gd -- mma_dirty_boxing
```

**Drive `att_lhand_to_vic_neck` drift UNDER 30%.** It is 545% today. Under 30% is a collar tie
on a differently-proportioned body; the contacts are joint-centre distances on a 1.70 m rig and
our fighters are larger, so it will never read 0%.

**DO NOT GATE ON `hip_to_hip`.** It already passes at 4% and it is precisely what kept this
defect invisible. **Report all five rows every time**, including any that get worse.

**IF YOU CANNOT REACH 30%, THAT IS A RESULT AND YOU SHIP IT.** Report the best drift you
reached, what you changed to get there, and which of the three steps moved it. A measured
partial with a named cause beats a number massaged into range.

## THE CONTROL ARM — NOT OPTIONAL

**The bought RamsterZ pack must not move.**

```
Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tools/pair_gap_report.gd -- grapple_control
```

must still read `min_gap_m=0.302639 max_gap_m=0.304671`. S31 broke that pack TWICE while
repairing the authored one, and both times every other number still looked fine. Eleven bound
films ride on `UE4_TO_OURS` and the RamsterZ path — **a fix that moves them has broken eleven
things to repair one.** If your change has to touch shared code, gate it on
`FightClipRetarget.is_cascadeur_clip` the way S31's two pair repairs already are.

## OWNED FILES

- `Godot/scripts/FightClipRetarget.gd`
- `research/U116_LEAN_SURVIVES.md` (new, the digest — under 70 lines)
- `research/U116_check.py` (new, the gate)
- a probe under `Godot/tools/` if step 2 needs one

**Touch NOTHING else.** Do NOT edit `Godot/scripts/FightClipBinding.gd`,
`Godot/scripts/PairedStagePlayer.gd`, `tools/s31_contact_probe.gd`, or any test —
`s31_contact_probe.gd` is the instrument you are measured by and editing it is marking your
own homework. Codex is writing a blind contract test for this in parallel; **do not look for
it and do not read any `codex/` branch.**

## THE GATE SCRIPT

`python research/U116_check.py` must exit 0 and must RECOMPUTE, not restate: re-run the
contact probe, assert `att_lhand_to_vic_neck` drift against a literal pinned to 1 decimal
place, and assert `grapple_control` still reads 0.302639/0.304671 to 6 places.

## TWO TRAPS

1. **`get_bone_global_pose` returns the REST pose on a headless skeleton.** Every distance
   comes out constant and wrong while looking fine. Read poses with
   `FightPoseBridge.globals_at(skel, anim, t)` — `s31_contact_probe.gd` and
   `pair_gap_report.gd` both already do.
2. **`var x := <call>` fails when the call returns Variant.** Write the type. A parse error
   does not fail a headless test, it HANGS it until the timeout.

## WHEN YOU ARE DONE

Commit with explicit paths (`git add -- <files>`), push the branch, then one line:

```
python Tools/agent_comms.py send --from cursor --to claude --topic u116-ready --body "<one line>"
```

Do NOT edit `HANDOFF.md`. **Unstage `AgentComms/messages` before any commit that is not the
mail itself** — the checkout is shared and another agent's mail pre-stages there.
