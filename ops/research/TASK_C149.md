# TASK_C149 — The CMU SOURCE hand-to-hand distance, measured blind

**Owner: Codex.  Model: gpt-5.6-luna, MEDIUM effort.**
**Test tier: NO GODOT, NO `.gd`, NO SUITE. Pure Python. `git status -s` before
you stage is the whole check.**

---

## WHAT THIS IS AND WHY IT IS BLIND

S34 asks for **two numbers side by side**: the hand-to-hand distance in a known
paired mocap capture, and the same distance after that capture goes through our
Godot retarget. A drift percentage with no source figure beside it proves
nothing.

**You are writing the SOURCE half, and you are writing it BLIND.** Claude is
writing an independent reader of the same files at the same time. **Do not look
for, read, or import Claude's version** — if one exists at
`Tools/cmu_asf_amc.py` when you start, ignore it completely and write your own
at the path below. Two readers built from the format spec that agree are
evidence; one reader checked against itself is not. If they disagree, that
disagreement is the finding and it gets settled in the data, not by one side
adopting the other.

## THE FIXTURE

`AssetLibrary/cmu_paired/` holds CMU Graphics Lab mocap, ASF/AMC:

| file | what |
|---|---|
| `18.asf` | subject 18's skeleton — **fighter A** |
| `19.asf` | subject 19's skeleton — **fighter B** |
| `18_05.amc` | A's motion, trial 05 |
| `19_05.amc` | B's motion, trial 05 |

Trial 05 is **"A pulls B by the elbow; B resists"**, 438 frames each, captured
at **120 Hz**, frame-synchronised and sharing one world coordinate space. That
shared space is the whole point — it is what makes this ground truth.

**SUBJECT 18 AND SUBJECT 19 ARE TWO DIFFERENT BODIES WITH DIFFERENT ASF
SKELETONS. KEEP THEM THAT WAY.** Do not load one skeleton twice. This project
has a standing rule against identical fixtures and it has cost it four times;
here it would also silently destroy the measurement, because two copies of one
body trivially agree.

## THE FORMAT, SO YOU NEED NO OTHER SOURCE

**ASF** (skeleton) sections: `:units`, `:root`, `:bonedata`, `:hierarchy`.

- `:units` carries `length` (e.g. `0.45`) and `angle deg`.
- Each `:bonedata` `begin … end` block gives `id`, `name`, `direction` (a unit
  vector), `length` (in ASF length units), `axis <rx> <ry> <rz> XYZ` (the
  bone's rotation-axis offset, in the stated order), and an optional
  `dof rx ry rz` naming WHICH channels that bone has and in what order.
- `:hierarchy` lists `<parent> <child> [child …]` per line, rooted at `root`.
- `:root` gives `order TX TY TZ RX RY RZ`, `axis`, `position`, `orientation`.

**AMC** (motion): after a `:DEGREES` header, frames are an integer line (`1`,
`2`, …) followed by one line per moving bone — `<name> <v1> <v2> …` — where the
values are that bone's channels **in its own `dof` order**, degrees. `root` has
six: three translation then three rotation, in the `:root order`.

**FORWARD KINEMATICS.** For each bone, with `C` the axis rotation built from
`axis` in its stated order and `M` the motion rotation built from the frame's
channels in `dof` order, the bone's local transform is `C · M · C⁻¹`, applied to
the parent's global rotation; the bone's distal joint sits at the parent joint
plus `parent_global_rotation · direction · length`. The root takes the frame's
translation and rotation directly.

**UNITS.** ASF lengths are in the file's own unit. The CMU conversion to metres
is **`0.056444`** m per ASF length unit (it is `(1/0.45) · 2.54/100`). Apply it
to the root translation too. Every number you print is **metres**.

## WHAT TO DELIVER

**1. `Tools/cmu_source_probe.py`** — yours alone, standard library only (no
numpy dependency you have not verified is installed; plain `math` is enough).
It must expose, and a later caller will use these exact names:

```python
parse_asf(path)                 -> dict   # skeleton
parse_amc(path)                 -> list   # one entry per frame
joint_world_positions(asf, frame_channels) -> dict  # bone name -> (x, y, z) METRES
```

and run as `python Tools/cmu_source_probe.py` to print the report below.

**2. THE REPORT.** Hand-to-hand distance per frame, **all four A-hand/B-hand
pairings**, over the 438 frames of `18/19_05`:

```
CMU SOURCE 18/19_05 frames=<n> fps=120
  <pairing>  min=<m> p10=<m> p50=<m> p90=<m> max=<m>
```

for `A_lhand→B_lhand`, `A_lhand→B_rhand`, `A_rhand→B_lhand`,
`A_rhand→B_rhand`, **and** `closest_hand_pair` (the minimum over the four at
each frame, then percentiled). The CMU bone names are `lhand` and `rhand`.

Also print, on its own line, the **root-to-root** separation percentiles.

**3. `research/C149_CMU_SOURCE.md`** — the table, the method in a
paragraph, and the self-checks below with their actual values.

## SELF-CHECKS — these are your gate, and they are derived, not copied

Print each with PASS/FAIL and its real number. **Exit non-zero if any fail.**

1. **Frame counts match**: `18_05.amc` and `19_05.amc` both parse to **438**
   frames. Unequal counts mean the pairing is wrong and nothing downstream is
   valid.
2. **The two skeletons differ.** Print at least three bone lengths that are NOT
   equal between `18.asf` and `19.asf`. If they are all identical you have
   loaded one file twice — stop and say so.
3. **Bone lengths are rigid.** For each subject, recompute every bone's length
   from your own world positions on frame 0, frame 219 and frame 437; the
   spread must be under **1 mm**. This is the check that catches a wrong
   rotation order, and it catches it without anyone telling you the answer.
4. **Root separation agrees with the published figure.** R155 measured
   `18/19_05` root separation at **min 0.77, p10 0.84, p50 0.99, max 1.71** m.
   Yours must land within **±0.02 m** of each. If it does not, report the
   discrepancy loudly rather than tuning a constant until it matches — R155
   could be the thing that is wrong, and saying so is a real result.

**DO NOT gate on an exact hand-distance value.** Nobody knows it yet; that is
why we are measuring. Gate on the four structural checks above only.

## OWNED FILES

- `Tools/cmu_source_probe.py` (new)
- `research/C149_CMU_SOURCE.md` (new)

Read `AssetLibrary/cmu_paired/*.asf` and `*.amc` freely — they are small
(7 KB skeletons, ~340 KB motions). Read
`research/R155_CMU_PAIRED_GROUND_TRUTH.md` for the fixture's provenance
and nothing else. **Do NOT read `HANDOFF.md`, `CURRENT_STATUS.md`,
`HANDOFF_ARCHIVE.md` or any digest, and do not explore to get oriented.**

## THE TRAP SPECIFIC TO THIS TASK

**The axis transform is where every ASF reader goes wrong, and check 3 is what
catches it.** `C · M · C⁻¹` is not the same as `M · C` or `C · M`, and a reader
that drops the `C⁻¹` still produces plausible-looking motion with subtly wrong
limb placement — the skeleton stays connected, so nothing obviously breaks, and
the hand positions are quietly wrong by centimetres. Bone lengths recomputed
from world positions stay rigid under the correct composition and drift under
the wrong one. **Run check 3 before you trust a single distance you print.**

Second trap: a bone with **no `dof` line has no channels and does not appear in
the AMC at all** (`lhipjoint`, `lclavicle` and friends). It is not missing data
— it is a fixed offset. Treat an absent bone as identity rotation, do not skip
it in the chain, or every bone below it lands in the wrong place.

## WHEN DONE

Commit and push to master, write the digest, and send one line with
`python Tools/agent_comms.py send --from codex --to claude --subject c149-done`.
Do NOT edit `HANDOFF.md`.
