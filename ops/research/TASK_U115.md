# TASK_U115 — CURSOR — A MOVING CASCADEUR CLIP, AND THE GAP THE GATE ASKS FOR

**Agent:** Cursor · **Model:** composer-2.5 · **Effort:** medium · **Fast:** off
**Launch:** `Tools\cursor_task.cmd <this file> <workspace>` — NEVER `cursor-agent` directly.
**Branch:** `cursor/u115-moving-clip-and-gap` · **Read this file and only the files it names.**
Do NOT read `HANDOFF.md`, `CURRENT_STATUS.md`, `HANDOFF_ARCHIVE.md` or any digest other than
`research/U114_CASCADEUR_RETARGET.md` (yours, 67 lines) and
`research/U113_CASCADEUR_EXPORT.md` (yours, read §2 and §3 only).
Do not explore to "get oriented".

**Test tier — you ADD `.gd` files and edit none, so:** parse gate first
(`python Godot/tools/check_scripts.py <every .gd you touched>`), then
`python Godot/tools/run_tests.py --only clip`, then `--only pair`.
**NO full suite** — that is Claude's at integration. **`--only` DOES NOT STACK: a second
`--only` REPLACES the first. Run them as separate commands.**
**fails CEILING: the tree's four baseline reds are `athlete_development`, `fight_pair_live`
(PARKED on purpose), `fight_scoring` and `fight_stage_realism`.** Match
`AgentComms/last_suite.json` name for name; a NEW red name is a failure you caused.

---

## WHY THIS EXISTS

You proved in U114 that a Cascadeur GLB retargets: `S30_CLINCH_A.glb` gave **22 corrections,
22 bones mapped, `error=""`**. But that file is **one keyframe at t=0.0 s — a held pose, zero
seconds long.** Claude is about to author a MULTI-SECOND, MULTI-KEYFRAME clinch hold in
Cascadeur and bind it as a paired hold. **Nothing has ever proved that the animated case
survives the same path**, and if it does not, the whole stage stops at the export.

That is deliverable 1, and it is the one that matters. Deliverable 2 is the instrument the
stage's gate is written in terms of.

---

## DELIVERABLE 1 — DOES A MOVING CASCADEUR CLIP RETARGET?

**Build the fixture yourself; do not wait for Claude's export.**

Source file, on disk now:
`C:/Users/user/AppData/Local/Temp/FightCamp-cascadeur-export/S30_CLINCH_A.glb` (2.8 MB).

Write `Tools/cascadeur/make_moving_fixture.py` (pure Python, `pygltflib` or raw GLB chunk
parsing — your call, but say which in the digest). It copies that GLB and replaces its
single-sample animation with a **real 3-second, 30-sample animation** by taking the existing
t=0 rotation for each animated joint and adding a small, smooth, joint-specific oscillation —
a few degrees on the pelvis, spine and both arms, sinusoidal, returning to the start value at
the last sample so the clip loops. Write it to
`C:/Users/user/AppData/Local/Temp/FightCamp-cascadeur-export/U115_MOVING_A.glb`.
**Do not commit the GLB** (2.8 MB, and it is reproducible from the script). Commit the script.

Then put it through the real path, headless, and report the numbers:

```
Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tools/<your probe>.gd
```

Model your probe on the one U114 already wrote (the `U114_PROBE` lines in your digest).
It must print, for BOTH the static original and the moving fixture:

```
U115_PROBE clip=<path> corrections=<n> bones_mapped=<n> frames=<n> length_s=<f> error=<...>
```

**`frames` and `length_s` are the new information** — U114 only ever saw 1 and 0.0. Say
plainly whether `_source_frames` returns the 30 samples or collapses them, and whether any
per-frame data survives. If it fails, **that failure IS the deliverable** — report where, with
the error text, and do not repair it without saying so.

## DELIVERABLE 2 — `Godot/tools/pair_gap_report.gd`

S31's gate is *"the min and max inter-fighter gap in METRES across the hold"*, and there is no
tool that produces it. Write one.

A headless `--script` tool taking a binding key, which:

1. resolves it through `FightClipBinding.paired_metadata_for(key)` **or**
   `FightClipBinding.paired_strike_metadata_for(key)` — try the grapple table first, then the
   strike table, and say which one answered;
2. grafts the pair the way `PairedStagePlayer` does (that is the ONE mount driving BOTH
   skeletons — do not invent a second mount);
3. samples the bound window at **30 Hz** from `start_s` to `end_s`;
4. at each sample takes the **hip-to-hip distance in metres** — the two `pelvis` bones' global
   origins — which is the quantity `min_gap_m` / `max_gap_m` already name in
   `FightMoveScript.gd:27`. **Do not invent a second measure of distance.**

It prints exactly one machine-readable line plus one row per sample behind a `--verbose` flag:

```
PAIRGAP key=<k> table=<grapple|strike> frames=<n> min_gap_m=<f> max_gap_m=<f> mean_gap_m=<f>
```

**Prove it on a hold that already exists and is already bound:** `grapple_control`
(`Paired_FullMount_Takedown_BodyLock_Loop`, 1.667 s). Put its real numbers in the digest.
That is a mount on the canvas, so expect a SMALL hip gap; if it comes back near zero or
absurd, that is a finding about the tool and you must chase it, not report it.

Also run it on `grapple_stand_up` (window starts at 2.333 s, not 0.0) — **that one proves the
window is honoured** rather than the whole file being played.

---

## OWNED FILES

- `Tools/cascadeur/make_moving_fixture.py` (new)
- `Godot/tools/pair_gap_report.gd` (new)
- your probe script under `Godot/tools/` (new)
- `research/U115_MOVING_CLIP_AND_GAP.md` (new, the digest)
- `research/U115_check.py` (new, the gate)

**Touch NOTHING else.** Specifically: do not edit `FightClipRetarget.gd`,
`PairedStagePlayer.gd`, `FightClipBinding.gd` or any test. If deliverable 1 shows the retarget
needs a repair, **write the repair down in the digest and stop** — Claude is inside those files
this session and a concurrent edit loses one of us.

## THE GATE

`python research/U115_check.py` must exit 0. It recomputes, not restates:

- `PAIRGAP` on `grapple_control` re-run from the tool, with the min/max **pinned as literals**
  in the check script to 3 decimal places;
- `frames` on `grapple_stand_up` equal to `round(2.500 * 30)` ± 1, proving the window;
- the moving fixture's `frames` from a fresh `make_moving_fixture.py` run.

A gate that reads its answer out of the digest it is gating is not a gate. Derive every number.

## THE ONE TRAP

**A skinned glTF exposes its bones on a `Skeleton3D`, not as loose `Node3D`s** — that is your
own U114 finding and it is exactly what will bite `pair_gap_report.gd` when it goes looking for
a `pelvis`. The RamsterZ FBX pairs you are proving the tool on are mesh-free and walk as nodes;
Claude's Cascadeur pair will be skinned. **Handle both from the start** — reuse
`_index_skel` / `_index_walk` rather than writing a third indexer.

## WHEN YOU ARE DONE

Commit with explicit paths (`git add -- <files>`), push the branch, then one line:

```
python Tools/agent_comms.py send --from cursor --to claude --topic u115-ready --body "<one line>"
```

Do NOT edit `HANDOFF.md`. **Unstage `AgentComms/messages` before any commit that is not the
mail itself** — the checkout is shared and another agent's mail pre-stages there.
