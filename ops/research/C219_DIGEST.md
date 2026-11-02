# C219 — calm room idles

Implemented on `codex/c219-calm-idle`. Office owner, staff-room coaches and
lobby desk hand use `calm_idle.res`. The physio's worst-shape fighter is back
on the table using `lying_idle.res`, with the existing worst-id selection and
medical label. The floor's default fight idle is unchanged. `_add_body`
already had the optional clip argument, so only the two constants were added
to TrainingFloor3D.

## Source and bake

CMU Graphics Lab subject 77, [catalogue](https://mocap.cs.cmu.edu/search.php?subjectnumber=77):

| Output | Capture | Selected window | Loop |
|---|---|---|---|
| `calm_idle.res` | **77_02 — standing**, 60 Hz | 0–5 s | 5 s, arms down, captured small weight/posture changes |
| `lying_idle.res` | **77_18 — laying down on back, getting up, careful ready pose**, 60 Hz | Initial 0–1.3 s supine settling only | Slowed 3x to 3.9 s; excludes get-up/ready pose |

[CMU's terms](https://mocap.cs.cmu.edu/) permit inclusion in commercially sold
products and prohibit direct resale of the data, even after conversion. This
is custom commercial-use permission, **not CC0**. Attribution: the data used
in this project was obtained from mocap.cs.cmu.edu; the database was created
with funding from NSF EIA-0196217.

Original ASF/AMC, derived GLBs, exact rebuild instructions and licence are in
[`c219_source/SOURCE.md`](../assets/anim/boot/c219_source/SOURCE.md).
The existing ASF→BVH→Blender→GLB pipeline feeds the production silhouette
retarget at 30 Hz onto f01's 22-bone skeleton. The last 0.6 s blends to the
opening pose. Standing faces +Z. Supine torso axes are corrected to face up;
the existing `FightLegIK` solver fits the captured limb motion to the narrow
pad with arms beside the body. This is a **table-adapted settling capture**,
not a separately recorded breathing take or an unmodified source motion.
There are no hand-authored animation key sequences.

The CMU reference hips are at zero, so the normal reference-height carry is
empty. The lying resource explicitly supplies the hips track, with a -0.09 m
local offset. The room mount stays at floor datum and `_add_body` still lifts
the body by 0.925 m. Adding the table's height again would float the patient.

## Posed mesh contact — achieved beside wanted

[`c219_bake.gd`](../tools/c219_bake.gd), `-- measure`, samples the complete loop
at 60 Hz, including its wrap. It evaluates **all skin weights and inverse bind
matrices** for selected original mesh vertices against each posed skeleton,
then applies the skeleton's world transform. It does not use a rest AABB or
assume an imported vertex unit is a metre. Both live skeleton world scales
were `(1,1,1)` after loading these rigs; their imported bind transforms and
0.925 m lift are included in the reported world-space metres.

Standing measures each foot's lower skinned surface separately. Lying selects
posterior spine/chest vertices from the rest mesh, evaluates them in the pose,
and measures the back's lower contact surface against the **0.78 m** pad. It
also requires the back footprint inside the pad and the anatomical chest
forward axis to point upward throughout the loop (dot >0.95).

| Clip / distinct rig | World contact Y range (m) | Achieved worst absolute gap | Wanted |
|---|---|---|---|
| Calm / f01 welterweight | -0.004166…0.023716 | **0.023716 m** | ≤0.030 m from floor |
| Calm / f10 heavyweight | -0.003928…0.028216 | **0.028216 m** | ≤0.030 m from floor |
| Lying / f01 welterweight | 0.763524…0.800521 | **0.020521 m** | ≤0.050 m from pad |
| Lying / f10 heavyweight | 0.767558…0.806673 | **0.026673 m** | ≤0.050 m from pad |

301 standing and 236 lying samples per rig. Foot selections contain 1,011 /
1,200 vertices; posterior back selections 718 / 721. Different rig SHA-256s
are asserted. Rest-to-posed hand displacement exceeds 0.67 m and each contact
range changes over time: a rest-only reading fails. Minimum face-up dot is
0.998643 / 0.992577. These are tolerance measurements, not claims of exact
zero penetration or a complete collision audit of every mesh vertex.

- [Raw contact output](../docs/previews/c219/contact.txt) and [JSON](../docs/previews/c219/contact.json): `C219_CONTACT rows=4 failures=0`.
- [Negative control](../docs/previews/c219/contact_mutant.txt): lift the actual body mount by 0.10 m; **all four rows fail**, engine exit 1. No resource is changed by this mode.
- Four fixed phases, both rigs: [0%](../docs/previews/c219/rigs_00.png), [33%](../docs/previews/c219/rigs_33.png), [66%](../docs/previews/c219/rigs_66.png), [99%](../docs/previews/c219/rigs_99.png).

## Room renders

All four task-named capture scripts ran through `Tools/godot_hidden.ps1`;
their final logs contain no script/runtime errors. The room images and the
two-rig phase images were visually inspected. Standing hands are down; the
patient faces up with arms alongside the body. Existing Tripo clothing/gloves
remain. The physio read contains identity/medical data but no sex/model field,
so its visible body is the f01 representative bound to the correct worst id.

Office — [before](../docs/previews/c219/office_before.png):

![Office after](../docs/previews/c219/office_after.png)

Lobby — [before](../docs/previews/c219/lobby_before.png):

![Lobby after](../docs/previews/c219/lobby_after.png)

Staff room — [before](../docs/previews/c219/staff_room_before.png):

![Staff room after](../docs/previews/c219/staff_room_after.png)

Physio — [before](../docs/previews/c219/physio_before.png):

![Physio after](../docs/previews/c219/physio_after.png)

## Gates and scope

- Parse: seven touched `.gd` files, `CHECK total=7 fails=0`; later bake-tool edits re-parsed before execution, `CHECK total=1 fails=0`.
- Final room gate: `python Godot/tools/run_tests.py --jobs 2 --only office_room,staff_room,physio_room,front_door,training_floor` → **`SUITE total=5 fails=0`**.
- No full suite, PC watchdog, browser, paid generation, or HANDOFF/status/archive reads or edits.
- Direct C219 assignment/self-contained intake took precedence over generic mailbox task discovery. The repository bake tools were used; `game-dev` was not installed.
- The fresh worktree needed a headless editor import for fonts and global-class caches. It rewrote many existing `.import` sidecars. Automatic review rejected a broad cleanup as potentially discarding unrelated changes; those sidecars, unused audition files and original capture-path image changes remain **unstaged**, excluded from C219 commits. Only named task files and the requested C219 evidence are delivered.
