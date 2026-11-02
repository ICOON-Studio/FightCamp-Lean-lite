# C135 - Cascadeur did not produce a bindable side control

2026-09-20, `codex/c134-bjj-presentation`; gpt-6-astra, medium.

**NO VERIFIED SOLUTION. No Cascadeur-posed side control is verified good enough
to bind: contact residual is unmeasured (metres; null), and interpenetration
share is unmeasured (null), because no physics/ML-posed pair was produced.**
Those are missing measurements, not zero metres or zero penetration.
This is an incomplete posing evaluation / automation blocker, not a measured
rejection of a completed Cascadeur pose and not proof of GUI incapability.

## Reachability and actual progress

- Executable: YES. `print('ok')` printed `ok`, OS exit 0, version 2026.2.2.
- Output: YES. Redirected stdout/stderr into this worktree under `.c134/c135/`.
- Both native GLBs imported directly, 22 joints each; no FBX conversion needed.
- Native quick-rig creation succeeded for both with explicit object-ID mappings
  and `ImportOptions.scale_factor=100.0`. Each has 215 objects, 21 rigid bodies,
  43 AutoPhysicsApply points and 45 AutoPosingLink behaviours.
- With automatic AutoPosing creation disabled before leaving rig mode, an
  explicit documented `AutoPosingTool.add(session)` returned for both rigs.
  A returned callback and rig links do NOT establish a successful ML pose solve.
- Exported both unposed rigs and re-imported them with the specified portable
  Blender / TEMPERANCE. Each has one skinned mesh, 22 bones, no animation.
  These diagnostic GLBs retain centimetre-valued coordinates (heights 185 and
  100), not metre-ready stage assets. They are NOT side-control candidates.

## Blocker, with bounded diagnosis

The installed stub and runtime AutoPosingTool expose only `activate`, `add`,
`deactivate`, `update`; `csc.tools.auto_posing` exports no helper functions.
I did not establish an API for setting ML controller targets or performing a
paired pose solve. The available joint-data setters would return to the
prohibited hand-authoring route, so I did not use them to manufacture a hold.
This describes the API surface inspected, not every possible private API.

An explicit add after automatic creation stalled and crashed with OS exit
-1073741819 (0xC0000005), reproduced with add alone. Disabling automatic
creation first resolved that call. Therefore that crash is NOT evidence that
Cascadeur's posing itself fails. The successful rig/export processes still
returned OS exit -1073740940 (0xC0000374) after their log claimed exit 0;
these runs are not claimed clean exits. Blender verification exited 0.

Earlier quick-rig failures were invocation/setup errors: missing rig-mode
initialization, template name resolution, and metre-scale hinge degeneracy.
The final script uses native object IDs and centimetre import scale. Initial
`.casc` saves were not valid archives; direct save also reported `Failed to
create temporary file to save the scene`. The initial checkpoint's claim of
saved usable projects is withdrawn. Import counts were valid independently.
No undocumented/nonexistent csc function was deliberately invoked.

Computer Use found no targetable Cascadeur window during the stalled headless
call. No licence/payment dialog was observed. No billing/account action,
subscription, cancellation, purchase, provider job or payment entry occurred.

## Acceptance and remaining work

| Requirement | Evidence / result |
|---|---|
| Contact residual, metres | null; no solved held pair to sample |
| Interpenetration share | null; no posed pair to run mesh BVHs against |
| Four-view plausibility | not evaluated; no candidate |
| Reproducibility | import / rig construction / unposed export scripted; side-control solve not demonstrated |
| Cost | about 16 minutes to import, diagnose rig setup and test API access; no completed-position time available |

`c134_hold_review.gd` was read but not run: it currently auditions the existing
bound `grapple_control` film. Running it unchanged would show bought mount
footage, not a Cascadeur side control. No candidate means no honest four-view
or per-frame contact result. Four further positions cannot be costed from
this run. The existing C134 contact-drift and C136 crossing-triangle methods
remain suitable once a genuine exported pair exists; no old measurements
were substituted. No pose was bound and no tests changed.

## Reproduction and evidence

Run `c135_cascadeur_import.py` or `c135_cascadeur_rig.py` inside Cascadeur with
`--run-python-code "exec(open('<absolute script path>').read())"`, redirecting
logs into `.c134/c135/`. The latter is an unposed rig/API diagnostic, not a
side-control recipe. Paths target this authorized worktree. Inspect its exports
with portable Blender `--background --factory-startup --python
Godot/tools/c135_inspect_exports.py`.

`C135_EVIDENCE/import.json`, `rig_summary.json`, `export_inspection.json`, and
`rig7.txt` through `rig10.txt` preserve the useful results and contradictory
process exits. Bulky diagnostic exports/logs remain uncommitted in `.c134/`.

Task/user restrictions superseded the general startup rebase and HANDOFF
rules. No branch switch, engine change, hand-authored hold, HANDOFF read/edit,
full suite, or prohibited orientation read occurred.

## Gates

All Cascadeur and Blender work completed before Godot gates. No `.gd` changed,
so a touched-script parse gate is not applicable. Python syntax: 3 files,
0 failures. `--only c134`: SUITE total=5 fails=0. Then `--only clip`:
SUITE total=9 fails=0. Both runner exits 0; no isolated retry was necessary.
No full suite. Evidence: `C135_EVIDENCE/gates.json`.
