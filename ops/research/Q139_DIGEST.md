# Q139 DIGEST — HEAD SPHERE RADIUS, MEASURED FOUR WAYS ON TWELVE RIGS

**Branch:** `qwen/q139-head-sphere-radius`
**Tool:** `Godot/tools/q139_head_sphere.gd`
**Research:** `research/Q139_HEAD_SPHERE_RADIUS.md`

## FINDINGS

1. **The p80 the head sphere ships with is 28 % larger than J42's half Head
   Length on the median rig** (spread 1.215–1.612 across 12 rigs). It is also
   25 % larger than J42's half Head Breadth when compared on its own axis
   (spread 1.164–1.424). Neither comparison favours the shipped radius.

2. **The closest match to ANSUR is halfbre** (half the lateral extent of head
   vertices on the shoulder-derived axis), at median ratio 1.247 to J42 half
   Head Breadth. The halflen (sagittal extent) is the worst at 1.409 to J42
   half Head Length. The head is wider temple-to-temble than J42 says it should
   be, and even more forehead-to-occiput than that.

3. **The p80 has a long tail on every rig.** Max distance exceeds p80 by 18 mm
   (f10, bare-knuckle heavyweight) to 97 mm (f07, MMA strawweight). The p50 is
   stable across rigs (CV ≈ 7 %); the max is not. Something out there — hair,
   ears, headguard — is NOT DETERMINABLE from vertex positions alone.

4. **The head is NOT a sphere on any rig.** Three axis-aligned half-extents
   differ by 31 % (f05, best) to 86 % (f04, worst). Halfbre is the shortest
   axis on every rig. J42 said a head is an ellipsoid with three unequal semi-
   axes; the mesh confirms it on all twelve. This is an argument against the
   sphere S53 shipped.

5. **All 12 rigs got `axis_source: shoulders`** — the shoulder line was readable
   on every rig, so the sagittal and lateral axes are skeleton-derived, not
   fallback.

## RECOMMENDATION

Do not change the radius derivation until the vertex set is cleaned. Both p80
and halfbre are inflated by ~25 % against their own J42 referents, which means
the vertex set itself — not the percentile — is the problem. Changing from p80
to p50 would shave ~10 % off the radius but would not fix a vertex set that
includes hair, ears and whatever the Tripo generator put on the skull.

## SELF-CRITIQUE

The strongest case that this measurement settles nothing: a Tripo mesh
generator's idea of a "head" has no anthropometric meaning whatsoever. ANSUR
measures living humans with calipers on named landmarks. The mesh vertices are
whatever the generator decided was "head" when it wrapped a surface around a
skeleton. Comparing p80 of vertex distance to ANSUR caliper distance is
comparing a sculpture to a person. The 28 % gap might be hair, or a different
cranial shape, or a weight map that bleeds into the neck — none of which is a
"head radius" in the anthropometric sense.

**What would settle it:** (1) a landmark probe — identify 3–5 named vertices on
one rig (top of skull, forehead, occiput, temples) and measure between them; if
those match ANSUR within 10 %, the mesh IS a head and the radius problem is
real. (2) Generator documentation — what does Tripo put in the Head weight
bucket? (3) A/B with a known-good mesh — import a scan with known cranial
dimensions and run the same tool.

Until one of those lands, the numbers are real but the comparison to ANSUR is
not.
