# Q139 — HOW FAT IS OUR HEAD, REALLY? THE SPHERE RADIUS, MEASURED FOUR WAYS ON TWELVE RIGS

**Owner:** qwen (`qwen3-coder`, MEDIUM, `--yolo` never `auto`).
**Model: qwen3-coder. Effort: medium.**
**Tier: parse gate on any `.gd` you touch, then your ONE new tool. NO SUITE RUN,
NO `--only`** — you are adding a measuring tool and touching no shipped script,
so the suite buys nothing and costs twenty minutes.

## THE QUESTION, IN ONE LINE

**S53 promoted the head to a sphere and nobody has checked whether the radius is
honest.** Measure it four ways on all twelve rigs and say which one a head
actually is.

## WHY IT IS OPEN

`FighterCapsules.build_report` derives the head's radius as `mode: "blob"` — the
**p80 of every head-weighted skin vertex's distance to their own centroid**. On
our two reference rigs that lands at **0.1280 m** (f01 @1.78 m) and **0.1299 m**
(f02 @1.88 m).

John's J42 anthropometry (`research/J42_THE_HEAD_AS_A_VOLUME.md`, ANSUR II
male) puts an honest head sphere at one of two places, **and says plainly they
are not interchangeable**:

| basis | J42's male mean | what it covers |
|---|---|---|
| half **Head Length** | **0.0998 m** | forehead ↔ occiput |
| half **Head Breadth** | **0.0772 m** | temple ↔ temple |

**Ours is 28% larger than the first and 66% larger than the second.** A p80 of
vertex distance to a centroid includes hair, ears and whatever the Tripo
generator put on the skull, and no one has separated those from the cranium.
**A head sphere that is 0.13 m where a head is 0.10 m puts 3 cm of phantom skull
between a hand and a neck** — and S53 measured the neck at 0.0% exposed with the
thorax as the blocker, so this is directly on the critical path for the next
fix, not housekeeping.

## WHAT TO BUILD

**ONE new tool: `Godot/tools/q139_head_sphere.gd`.** A `SceneTree` script, same
shape as `Godot/tools/q137_slenderness_census.gd`, which you wrote and which is
the pattern to copy — it already loads every rig in
`CaptureFighterRoster.ROSTER`, scales with `FighterPhysique.height_scale` and
prints a table per rig. **Read that file and reuse its rig loop.**

For **every rig in the roster**, using the head-weighted skin vertices in the
rig's own metres (i.e. after `height_scale`), print one row per rig with:

| column | what it is |
|---|---|
| `fid`, `stature_m` | which rig, at what target height |
| `n_verts` | how many head-weighted vertices the measurement is over |
| `p80_m` | **the radius we ship today** — p80 of vertex distance to the centroid |
| `p50_m`, `p95_m`, `max_m` | the same distance at those percentiles |
| `halflen_m` | **half the head's extent along the rig's own SAGITTAL (front-back) axis** |
| `halfbre_m` | **half the head's extent along the rig's own LATERAL (left-right) axis** |
| `halfvert_m` | half the head's extent along **Y** |
| `j42_len_m`, `j42_bre_m` | J42's `0.0998` and `0.0772`, **scaled to this rig's stature** (see below) |

**THE AXES ARE DERIVED FROM THE SKELETON, NEVER ASSUMED.**
`FighterCapsules._forward_axis(skel, a, b)` already derives a forward and a
lateral axis from the **shoulder line** and reports in its own `source` string
when it could not and fell back. Call it (it is `static`) and **print which
source you got on every rig** — a rig whose shoulders could not be read has a
sagittal axis nobody chose, and a number measured on it is not a measurement.

**SCALE J42's FIGURES BEFORE COMPARING THEM.** `0.0998 m` is an adult male mean
at an ANSUR mean stature; our rigs run 1.78–1.88 m and beyond. Scale linearly by
`stature / 1.755` (ANSUR II male mean stature, **state this assumption in the
output as an assumption**) and print both the raw and the scaled figure, so a
reader can refuse your scaling and still use the row.

## WHAT TO ANSWER, IN WORDS, AT THE END

1. **Which of `p80`, `halflen`, `halfbre` is closest to J42's anthropometry, and
   by how much, across the twelve rigs?** Give the median ratio and the spread,
   not one rig.
2. **Is the p80 inflated by a long tail?** `p95` and `max` against `p50` say so
   if it is. If `max` is far past `p95` on most rigs, name what is out there —
   hair, ears, a headguard — if you can tell from the vertex positions, and say
   **NOT DETERMINABLE** if you cannot.
3. **Is the head's shape close to a sphere at all?** `halflen` vs `halfbre` vs
   `halfvert` on each rig. J42 says a head is an **ellipsoid with three unequal
   semi-axes**. If those three differ by more than ~15% on most rigs, say so
   plainly — that is an argument against the sphere we just shipped, and it is
   worth more to us than agreement.
4. **Your recommendation**, in one sentence: which basis should
   `FighterCapsules` derive the head radius from, and at what percentile.

## NEVER TEST IDENTICAL FIGHTERS, AND NAME THE POPULATION

All twelve rigs, each at its own roster stature. **Print the population in the
tool's own output** — rig ids and statures — so a later reader can tell a
finding from a fixture. Do not add a synthetic rig and do not measure one rig
twice.

## Owned files

- `Godot/tools/q139_head_sphere.gd` (new)
- `research/Q139_HEAD_SPHERE_RADIUS.md` (the table and the four answers)
- `research/Q139_DIGEST.md`

**You own NOTHING else. Do NOT edit `FighterCapsules.gd`** — this task measures,
it does not change the radius. Changing it is a later decision that needs this
table first.

## Files you may read, and nothing else

- `Godot/tools/q137_slenderness_census.gd` — your own; the rig loop to copy.
- `Godot/scripts/FighterCapsules.gd` — **it is ~950 lines; do NOT open it
  whole.** Read `sed -n '150,270p'` for `CAPSULE_DEFS` and the head's `blob`
  entry, `sed -n '300,440p'` for `build_report`'s blob branch, and
  `grep -n '_forward_axis\|_skin_vertices\|_percentile' Godot/scripts/FighterCapsules.gd`
  for the three helpers you need.
- `research/J42_THE_HEAD_AS_A_VOLUME.md` — read the table around line 53
  and the conclusions at 223; it is 22 KB, so grep rather than read it whole.
- `research/S53_THE_BALL_CAPSULE.md` — why this is being asked.

Do **NOT** read `HANDOFF.md`, `CURRENT_STATUS.md`, `HANDOFF_ARCHIVE.md` or any
other digest, and do not explore to "get oriented".

`RESEARCH_INDEX.md` is 789 documents and 220 tools, one line each — **GREP IT,
NEVER READ IT WHOLE.** Worth running: `grep -i 'head' RESEARCH_INDEX.md`,
`grep -i 'anthropom' RESEARCH_INDEX.md`. **A negative result is a result.**

## Gate

```
python Godot/tools/check_scripts.py Godot/tools/q139_head_sphere.gd
```

Then run your tool once and paste its real output into the research file:

```
Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tools/q139_head_sphere.gd
```

**rc=0 IS NOT A PASS** — a GDScript runtime error exits 0. Read the output and
check every rig produced a row. A tool that silently measures nothing prints
`0.000` and looks like a finding.

## Traps that will cost you a pass

- **`var x := <call>` fails when the call returns Variant.** Write the type:
  `var n: int = ...`. A `.size()` or `.get()` on an untyped value is Variant.
- **`%` inside a format string must be `%%`.**
- **Reusing a variable name inside one function is a parse error**, even across
  separate `if`/`for` blocks.
- **A `SceneTree` script must `quit()` on EVERY path including its error paths.**
  Two probes that did not hung for 80 minutes on 2026-09-22 and left six
  orphaned Godot processes behind. Put `quit()` on every return.
- **Headless `get_bone_global_pose()` returns the REST pose.** You want the rest
  pose here, so use `get_bone_global_rest` explicitly and say that you did,
  rather than getting it by accident.
- **A parse error HANGS a headless run for 600 s instead of failing it.** Parse
  gate first, always.

## Rules

- **DO NOT fetch and DO NOT rebase** — the checkout is current.
- Never `git stash`, `git reset --hard`, `git checkout .`, `git clean` or
  `git add -A`. Stage explicit paths only, and `git show --stat HEAD` after.
- Work in worktree `FightCamp-Q114`, cut a FRESH branch off `origin/master`.
- Commit after each step — an honest partial beats an uncommitted whole.
- Commit, push, write the digest, send one line with
  `python Tools/agent_comms.py send`. **Do NOT edit `HANDOFF.md`.**

## And then argue against yourself

End the digest with the strongest case that **this measurement does not settle
anything** — that a mesh generator's idea of a head has no anthropometric
meaning at all, so comparing it to ANSUR is comparing a sculpture to a person.
Say what would settle it instead. **Name your own weakest point unprompted.**
