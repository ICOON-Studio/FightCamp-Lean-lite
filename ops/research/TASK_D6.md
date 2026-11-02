# TASK_D6 — DOLA — SCALE YOUR RIG TO OURS, AND DERIVE THE OFFSETS

**Owner:** Dola (Cici app, driven by `Tools/cici/cici.py send --file`)
**No Godot, no checkout.** You run your own solver. Reply in chat with the full
text and the tables.

## D5 was clean and it did not transfer — here is exactly why

Your arms-only control reproduced 5/13 exactly and your spine cleared eight
poses to 13/13. **We ran the same thirteen poses, same schedule, same weights,
all-pairs scoring, on our real rig** (f01 at 1.78 m vs f02 at 1.88 m):
**3/13 arms-only, 4/13 with the spine, 3/13 with an elbow added too.** The +1 was
one pose crossing a bound by 0.7 mm.

Your mechanism is REAL — underhook penetration fell 0.1042 → 0.0613 → 0.0239 m
across the three DOF sets. Two things stopped it turning into passes, and both
are measured, not guessed:

1. **Your fighter is 1.00 m tall. Ours is 1.8471 m** (arms 1.615×, legs 2.098×,
   torso 1.434×). Both are judged on the SAME absolute bounds — pen ≤ 0.006 m,
   grip ≤ 0.012 m. Your eight cleared poses landed at grip 0.0073–0.0118 m; on
   our body that band is 0.0135–0.0218 m, outside the bound before the solver
   starts.
2. **`pen_pair` on our rig is never a limb reaching wrong.** It is
   `forearm/thorax` (collar tie: **0.1274 m of forearm inside the other man's
   chest while the grip sits 0.0061 m from its target**), `upper_arm/thorax`,
   `pelvis/pelvis`. The POSE's own contact spec — `pelvis↔pelvis off 0.02–0.03` —
   pins two men with 0.50 m of torso each at a hip gap a 1.00 m body can hold
   and a 1.85 m body cannot.

## Three parts, run in this order, every number printed

### Part 1 — SCALE YOUR RIG TO 1.85 m, change nothing else

Multiply every `p0`, `p1`, `jnt`, `dir` AND every radius in `LIMBS` by
**1.847**, keep every offset in `POSES` as authored, keep every pass bound as
authored, keep the schedule. Re-run all thirteen poses, arms-only and
arms+spine. **Print the same table as D5.**

The prediction from our rig is that the standing holds now FAIL on penetration,
not grip. If they pass, that is the finding — it means the difference is our
capsule set, not the scale, and we need to know that.

### Part 2 — DERIVE THE OFFSETS FROM THE RADII, then re-run at 1.85 m

Every contact offset in `POSES` is currently a number somebody typed. **Replace
each with a function of the two capsules' radii and print the function.** The
question is: for a pelvis-to-pelvis contact in a collar tie, what SURFACE gap do
two men with radius-r₁ and radius-r₂ pelvises actually stand at? Derive it (an
anthropometric stance width, a fraction of the sum of radii — whatever you can
justify), apply the same rule at 1.00 m and at 1.85 m, and show the table at both
scales. **The rule must give back roughly your original offsets at 1.00 m** — if
it does not, it is a different pose, not a derivation.

### Part 3 — THE BOUNDS AS A FRACTION OF STATURE

Re-express `PASS_PEN` and `PASS_GRIP` as fractions of stature (0.006 / 1.00 and
0.012 / 1.00 at your scale), apply them at 1.85 m (0.0111 and 0.0222), and
re-run Part 2's table. **This is the control arm for the derivation**: if derived
offsets pass at scaled bounds and fail at absolute bounds, the bounds were the
problem; if they fail at both, the offsets are.

## What I need back

- Three tables: Part 1 (scaled, authored offsets, absolute bounds), Part 2
  (scaled, derived offsets, absolute bounds), Part 3 (scaled, derived offsets,
  scaled bounds). Thirteen rows each, pen_m / grip_m / pass, worst pen PAIR named.
- **The offset rule, as a formula, one line per contact type**
  (pelvis↔pelvis, forearm↔neck, forearm↔thorax, femur↔pelvis, head↔pelvis).
- A one-line statement per pose: does it now pass, and what changed it.

## THE TRAP

**Reporting pen 0.0000 on a pose you did not score all pairs on.** D5 said
all-pairs and we believe it; keep it. **Second trap:** scaling positions but not
radii, or radii but not offsets — Part 1 scales EVERYTHING except the two things
the experiment holds fixed (offsets, bounds), and says so in its header.
**Third:** if Part 1 passes 13/13 at 1.85 m, do not celebrate; that result says
our fifteen-capsule set is the difference, and Part 2 still runs.
