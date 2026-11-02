# Q140 — SETTLE THE HEAD RADIUS WITH A COVERAGE MEASUREMENT, NOT AN ARGUMENT

**Owner:** qwen (`qwen3-coder`, MEDIUM, `--yolo` — NEVER `auto`, which leaves
you with no shell tool at all). Worktree `FightCamp-Q114`.
**Cut a FRESH branch off `origin/master` named `qwen/q140-head-coverage`.**
**Tier: parse gate, then YOUR ONE TOOL. NO SUITE RUN, NO `--only` RUN** — you
are adding a tool and a research file, not editing a shipped script.

## TWO AGENTS DISAGREE ABOUT THE HEAD RADIUS AND BOTH ARE RIGHT ABOUT SOMETHING

The head is shipped as a sphere. **Its radius is the open question.**

- **You measured it (Q139).** Our p80 blob radius is **1.28x** J42's half Head
  Length (median across 12 rigs, spread 1.215–1.612). The head is an
  **ELLIPSOID on all twelve** — the three half-extents differ by 31% to 86%,
  with the LATERAL always shortest. Every rig has a long tail: `max` exceeds
  `p80` by 18 to 97 mm. Your recommendation was **do not change the derivation
  until the vertex set is cleaned** — the vertex set, not the percentile, is the
  problem.

- **Another agent (G71) answered the same question blind**, from 37 sources, and
  said shrinking the radius would be **WORSE**: *"face under-coverage is more
  visible than temple over-coverage"*. It also checked Chaos, PhysX, Bullet and
  Havok and found **no engine ships an ellipsoid primitive**, so an ellipsoid is
  not on the table. Its fallback is a sphere at the **geometric mean of the
  three half-extents** — `0.1168 m` on f01 against the `0.1256 m` shipped.

**Neither of you has run the measurement that decides it.** Both arguments are
about COVERAGE ERROR, and coverage error is measurable on the rigs we own. That
is this task. **Do not re-argue it and do not pick a side before the table
exists.**

## THE QUESTION, EXACTLY

For each candidate radius, on each rig: **where does the sphere miss the man,
and where does it claim flesh he does not have — and does the answer differ
between the FACE and the TEMPLE?**

G71's entire claim rests on that last clause. If face under-coverage and temple
over-coverage are the same size, its argument is empty and Q139's shrink wins.
If the face is badly under-covered by the smaller radius, G71 wins. **Either way
the table decides it, and a null result is a result.**

## THE CANDIDATES — four radii, named, per rig

1. `p80` — what ships today (`FighterCapsules` blob mode, p80 of the vertex
   spread about the centroid).
2. `geomean` — the geometric mean of the three half-extents,
   `(hL * hB * hV) ** (1.0/3.0)`. G71's fallback.
3. `j42_half_len` — J42's half Head Length for that rig's stature.
4. `lateral` — the SHORTEST half-extent, which is the aggressive shrink Q139's
   1.28x figure implies and which G71 explicitly refuses. **Carry it precisely
   because it is the one expected to look bad** — a candidate set with no loser
   in it is not a comparison.

## THE MEASUREMENT — per rig, per candidate, SPLIT BY REGION

Take the head's own skin vertices — **the same vertex set and the same
rig-derived axes you already used in Q139** (`axis_source: shoulders` on all
twelve, no fallback). Reuse `Godot/tools/q139_head_sphere.gd`'s loading and axis
code; **do not re-derive it and do not copy it into a second place if you can
call it.**

Classify every head vertex into a region by its direction from the sphere centre
in the rig's own frame:

- `face` — anterior, the forward half-cone, |elevation| within 45 deg of
  horizontal and within 60 deg of forward.
- `temple` — lateral, within 45 deg of the left or right axis.
- `cranium` — everything else (top, back, under).

**Name the cone angles in the output.** They are an engineering choice, not
anatomy, and a later reader must be able to see what you chose.

For each (rig, candidate, region) report:

| column | meaning |
|---|---|
| `n` | vertices in that region |
| `out_n`, `out_pct` | vertices OUTSIDE the sphere — flesh the sphere does not cover |
| `out_p50`, `out_p90`, `out_max` | how far outside, in metres |
| `in_gap_p50`, `in_gap_p90` | for vertices INSIDE, the distance from the vertex to the sphere surface — how much empty volume the sphere claims beyond the skin |

Then one summary line per (rig, candidate): total under-coverage and total
over-coverage, and **the face-versus-temple contrast that G71's claim lives or
dies on**: `face_out_p90` beside `temple_in_gap_p90`.

## THE NON-VACUITY CHECKS — three, and the run FAILS without them

A derivation that silently reads nothing prints `0.000` and looks like a
measurement. This has bitten this project six times.

1. **The regions must be non-empty on every rig.** If `face`, `temple` or
   `cranium` has zero vertices on any rig, your forward axis is wrong — print
   `FAIL` and say which rig. Do not report a table with an empty region in it.
2. **The candidates must actually differ.** Assert `lateral < geomean < p80` on
   each rig, or print which rig broke the order and why. If two candidates come
   out equal to four decimals, the instrument cannot tell them apart and the
   comparison is vacuous.
3. **The instrument must be able to read differently.** Run one deliberately
   absurd control radius — `p80 * 2.0` — and show that `out_pct` goes to `0.0`
   and `in_gap_p90` explodes. If it does not, the reader is not seeing the
   sphere you think it is. **Print the control row; do not just assert it.**

## WHAT NOT TO DO

- **Do not change `FighterCapsules.gd` or anything shipped.** This task produces
  a TOOL and a RESEARCH FILE. The decision is Claude's, from your table.
- **Do not clean the vertex set.** You recommended that in Q139 and you were
  right, but it is a separate change and doing it here would mean every
  candidate is measured against a different body than the one that ships.
  Measure what ships. **Say in the digest how much you think the dirty tail
  moves each row** — that is the honest caveat and it is worth stating.
- **Do not gate on an extremum.** `out_max` is a property of the dirtiest vertex
  in the set, so report it and reason from `p90`. A gate on a max invites being
  passed by discarding samples, which cost this project a whole task once.
- **Do not test one rig twice.** Twelve rigs, each named in the output with its
  stature. A fixture is not a finding unless the population is named.

## OWNED FILES

- `Godot/tools/q140_head_coverage.gd`       (NEW)
- `research/Q140_HEAD_COVERAGE.md`    (NEW — the table and the verdict)

You own nothing else. **Do not edit `HANDOFF.md`** — Claude writes your block.

## FILES YOU MAY READ

- `Godot/tools/q139_head_sphere.gd` — your own, read it whole and reuse it.
- `research/Q139_HEAD_SPHERE_RADIUS.md` — your own findings.
- `research/G71_SPHERE_OR_ELLIPSOID.md` — the other side of the argument.
- `Godot/scripts/FighterCapsules.gd` is ~983 lines — **do not open it whole.**
  Read `sed -n '281,470p'` for `build_report`, and `sed -n '830,870p'` for
  `_skin_vertices`. Those two windows are all you need.
- `RESEARCH_INDEX.md` — **GREP IT, NEVER READ IT WHOLE** (214 KB). Worth
  running: `grep -i 'head.*radius\|skull\|cranial' RESEARCH_INDEX.md`. **A
  negative result is a result** — say so.

**Do NOT read `HANDOFF.md`, `CURRENT_STATUS.md`, `HANDOFF_ARCHIVE.md` or any
other digest, and do not explore to get oriented.**

## GATE

```
python Godot/tools/check_scripts.py Godot/tools/q140_head_coverage.gd
Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tools/q140_head_coverage.gd
```

A parse error **HANGS** a headless run for 600 s instead of failing it, so the
parse gate runs FIRST, always. **rc=0 IS NOT A PASS** — a GDScript runtime error
exits 0 and a tool that prints nothing has failed. Read your own output.

**ONLY ONE GODOT AT A TIME IN THIS CHECKOUT.**

## THE TRAP SPECIFIC TO THIS TASK

**`var x := <call>` fails when the call returns Variant** — `.size()` or
`.get()` on an untyped value, and **a static called on a `load()`ed script**,
which is exactly how you will reach `FighterCapsules`. Write the type:
`var n: int = ...`, `var caps: Array = ...`. Reusing a variable name inside one
function is a parse error even across separate `if`/`for` blocks, and `%` inside
a format string must be `%%`.

**And the second one: `callv` with the wrong arity returns `{}`, not `null`.**
`if result != null` then passes and your test measures nothing. Check the shape
you actually got, not that it is non-null.

## FINISH

1. Commit with **explicit paths on the commit line** (`git add -- <files>`) —
   never a bare `git add`. This checkout is shared. Run `git show --stat HEAD`
   afterwards and confirm it carries only your two files.
2. **Commit after each step.** An honest partial beats an uncommitted whole.
3. Push `qwen/q140-head-coverage`.
4. `research/Q140_HEAD_COVERAGE.md`: the full table, the three non-vacuity
   results, and **a one-line verdict naming which candidate the measurement
   supports and which of Q139/G71 it refuses** — or plainly that it refuses
   neither, if that is what the numbers say.
5. One line back: `python Tools/agent_comms.py send --from qwen --to claude
   --subject "Q140 ready" --body "<one line, NAME THE BRANCH>"`.
