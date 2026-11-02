# Q141 — CLEAN THE VERTEX SET, WHICH YOU HAVE NOW RECOMMENDED TWICE

**Owner:** qwen (`qwen3-coder`, MEDIUM, `--yolo` — NEVER `auto`, which leaves
you with no shell tool at all). Worktree `FightCamp-Q114`.
**Cut a FRESH branch off `origin/master` named `qwen/q141-vertex-clean`.**
**Tier: parse gate, then YOUR ONE TOOL. NO SUITE RUN.**

## YOUR Q140 SETTLED THE RADIUS AND THEN NAMED THIS AS THE REAL PROBLEM

Q140 is merged. It decided the head radius by coverage rather than by argument:
p80 under-covers the **face** by 15 mm at p90 and over-covers the **temple** by
52 mm at p90 — a **1:3.5 asymmetry** — so shrinking trades the less visible
error for the more visible one. **G71 is upheld by your measurement and Q139's
shrink is refused. `p80` stays.**

Your `f05` surprise was a good catch and it was reported rather than smoothed
over: its geomean exceeds its p80 because its head is the most spherical in the
population, so the non-vacuity ordering check fired for a real reason.

**And in BOTH Q139 and Q140 your verdict carried the same caveat: the VERTEX
SET is the problem, not the percentile.** Nobody has acted on it. This task is
that.

## THE EVIDENCE THAT THERE IS A TAIL

Q139 measured, on every one of the twelve rigs, that `max` exceeds `p80` by
**18 to 97 mm**. A skull does not have a 97 mm tail. Something is bound to the
`Head` bone that is not skull.

**And it is not only the head.** S54 measured the thorax's skin the same way
and found vertices skinned to `Head`, `Spine`, `LeftShoulder`, `Chest` and
`UpperChest` all sitting inside the thorax capsule — 642 and 654 of them. The
bind-bone grouping is doing real work but it is coarse, and
`FighterCapsules._skin_vertices` keeps **only the single highest-weight bone
per vertex**, which is where the coarseness comes from.

## THE QUESTION — three parts, and part 3 is the deliverable

**1. CHARACTERISE THE TAIL. What are the outliers, actually?**

For each of the twelve rigs, take the `Head` bone's vertex set and describe the
vertices beyond `p80`, and beyond `p95`:

- **Where are they** in the rig's own frame — above the skull, below toward the
  neck, forward of the face, behind? Use the same shoulder-derived axes Q139
  used (`axis_source: shoulders`, no fallback).
- **What is their best weight**, and what is their SECOND-best bone? A vertex
  at `Head 0.51 / Neck 0.49` is a neck vertex that the highest-weight rule
  captured for the head. **Report the weight distribution of the tail against
  the weight distribution of the core** — if the tail is systematically
  lower-weight, that is the cleaning rule handing itself to you.
- **How many are there**, as a count and a fraction.

**2. PROPOSE A CLEANING RULE, AND IT MUST BE DERIVED.**

Candidates worth measuring — do not just pick one:

- a **minimum bind weight** (drop vertices whose best weight is below `w`),
- a **blended assignment** (a vertex belongs to the bone set it is actually
  weighted to, rather than to one winner),
- a **geometric** rule (drop vertices past `k` times the median distance).

**The rule has to scale.** A fixed millimetre threshold is refused here — this
project runs twelve rigs from 1.55 m to 1.95 m and the same number cannot be
right for all of them. Whatever you choose must be a fraction, a weight, or a
percentile, not a length.

**And do not gate on an extremum.** `max` is a property of the single dirtiest
vertex; reason from `p90`/`p95`. A gate on a max invites being passed by
discarding samples, which cost this project an entire task once.

**3. SHOW WHAT MOVES.** The deliverable is a before/after table, per rig:

| column | meaning |
|---|---|
| `n_before`, `n_after` | vertices kept |
| `p80_before`, `p80_after` | the head radius as shipped vs as cleaned |
| `delta_mm` | how far the radius moves |
| `face_out_p90`, `temple_in_gap_p90` | **Q140's two coverage columns, recomputed on the cleaned set** |

**THAT LAST ROW IS THE POINT.** Q140 refused the shrink because it made face
under-coverage worse. **If cleaning the vertex set moves p80 down WITHOUT
making face coverage worse, then the shrink Q139 wanted was right all along and
was only blocked by dirty data.** If face coverage still degrades, p80 stays
and the tail was never the issue. **Either answer is a result. Say which it is
in one line.**

## NON-VACUITY — the run FAILS without these

1. **The rule must actually remove something on every rig.** If `n_before ==
   n_after` anywhere, print which rig and stop calling it a cleaning rule.
2. **It must not remove the face.** Recompute Q140's region split on the
   cleaned set and assert `face`, `temple` and `cranium` are all still
   non-empty on all twelve. A "cleaning" rule that eats the face would show up
   as a radius improvement and be completely wrong.
3. **An absurd control.** Run the rule at a setting that should remove almost
   everything and show the radius collapses. If it does not, the rule is not
   being applied where you think it is.

## OWNED FILES

- `Godot/tools/q141_vertex_clean.gd`        (NEW)
- `research/Q141_VERTEX_CLEAN.md`     (NEW)

**Do NOT change `FighterCapsules.gd` or anything shipped.** This produces a
tool and a finding; the decision to adopt a cleaning rule is Claude's, from
your table. Do NOT edit `HANDOFF.md`.

## FILES YOU MAY READ

- `Godot/tools/q139_head_sphere.gd` and `Godot/tools/q140_head_coverage.gd` —
  both yours, read whole, **reuse them rather than re-deriving axes or regions.**
- `research/Q139_HEAD_SPHERE_RADIUS.md`, `Q140_HEAD_COVERAGE.md`.
- `Godot/scripts/FighterCapsules.gd` is ~1030 lines — **do not open it whole.**
  `sed -n '860,905p'` is `_skin_vertices`, which is the function whose
  highest-weight rule you are examining. `sed -n '281,470p'` is `build_report`.
- `RESEARCH_INDEX.md` — **GREP IT, NEVER READ IT WHOLE** (234 KB). Worth
  running: `grep -i 'vertex\|skin weight\|bind' RESEARCH_INDEX.md`. **A
  negative result is a result.**

**Do NOT read `HANDOFF.md`, `CURRENT_STATUS.md`, `HANDOFF_ARCHIVE.md` or any
other digest, and do not explore to get oriented.**

## GATE

```
python Godot/tools/check_scripts.py Godot/tools/q141_vertex_clean.gd
Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tools/q141_vertex_clean.gd
```

Parse gate FIRST — a parse error **HANGS** a headless run for 600 s instead of
failing it. **rc=0 IS NOT A PASS**; read your own output.
**ONLY ONE GODOT AT A TIME IN THIS CHECKOUT.**

## TRAPS

- **`var x := <call>` fails on Variant** — `.size()`/`.get()` on an untyped
  value, and any static on a `load()`ed script. Write the type.
- **Reusing a variable name inside one function is a parse error**, even across
  separate `if`/`for` blocks.
- `%` must be `%%`, and **`%e` is not a GDScript format specifier at all** — it
  prints the literal and eats your number. Use `%.9f`.
- **Do not print `FAIL`, `failures=N>0` or `N failure(s)`** — the runner reads
  the log for those. Use `checks_failed=`.
- `ARRAY_WEIGHTS`/`ARRAY_BONES` have a **stride** — 4 or 8 per vertex. Read the
  stride from `bones.size() / verts.size()` as `_skin_vertices` does; assuming
  4 silently misreads an 8-influence mesh.

## FINISH

1. **Explicit paths** on the commit line (`git add -- <files>`). `git show
   --stat HEAD` afterwards.
2. Commit after each step.
3. Push `qwen/q141-vertex-clean`.
4. `Q141_VERTEX_CLEAN.md`: the tail characterisation, the rule with its
   derivation, the before/after table, the three non-vacuity results, and **the
   one-line verdict on whether a clean set re-opens Q139's shrink.**
5. `python Tools/agent_comms.py send --from qwen --to claude --subject
   "Q141 ready" --body "<one line, NAME THE BRANCH>"`.
