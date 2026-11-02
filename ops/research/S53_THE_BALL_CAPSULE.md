# S53 — THE HEAD IS A BALL, AND IT WAS NEVER THE NECK'S PROBLEM

**Stage:** S53 (Claude, 2026-09-22). **Built:** `Godot/scripts/CapsuleShape.gd`,
`Godot/scripts/ApproachBand.gd`, classify-on-load in `FighterCapsules`, the head
promoted to a sphere on load, and `Godot/tools/s53_ball_capsules.gd` to measure
it. **Both blind contracts were already on disk and both now pass for real.**

---

## THE ONE SENTENCE

Promoting the head to a sphere is right, and it **does not unbury the neck** —
the neck reads **0.0% exposed before and after, on both rigs, at every blend**,
because the blocker that is left is the **thorax's upper cap**, not the head.
What the promotion does buy is the **thorax**: `20.3% → 26.6%` on f02 and
`15.6% → 21.1%` on f01, at every blend, with nothing measured getting worse.

---

## WHAT SHIPPED

| file | what it is |
|---|---|
| `Godot/scripts/CapsuleShape.gd` | `slenderness` / `shape` / `accepts_endpoint_inset` / `surviving_extent` / `classify`. Pure arithmetic over a length and a radius. Bands at 0.25 / 0.50 / 1.00. |
| `Godot/scripts/ApproachBand.gd` | `elevation_deg` / `in_band` / `band_for` / `banded_fraction`. **Per region, never one global horizon**, and an unknown region gets the full sphere. |
| `FighterCapsules.build_report` | now returns `shapes` (classify-on-load, per capsule), `capsules_authored` (the pre-promotion control) and `promoted`. |
| `FighterCapsules.promote_spheres` / `sphere_centre` / `sphere_volume_ratio` | D12's promotion, and the volume measure that makes a promoted sphere reportable. |
| `FighterCapsules.SPHERES_ON_LOAD = ["head"]` | the head is a sphere in every set the build hands out. |
| `Godot/tools/s53_ball_capsules.gd` | the instrument: band, exposure, banded exposure, present ratio and volume kept, per grip spot, per arm, on two rigs. |

---

## CLASSIFY ON LOAD, MEASURED ON OUR OWN TWO RIGS

`L` is the capsule's own axial length as built; `r` its p80 radius.

| capsule | f01 @1.78 m r/L | band | f02 @1.88 m r/L | band |
|---|---|---|---|---|
| `head` | **0.984** | NEEDLE | **1.186** | **BALL** |
| `neck` | **0.926** | NEEDLE | **0.710** | NEEDLE |
| `pelvis` | **0.775** | NEEDLE | **0.824** | NEEDLE |
| `foot_l` | 0.479 | STOUT | **0.514** | NEEDLE |
| `thorax` | 0.436 | STOUT | 0.464 | STOUT |
| `upper_arm_r` | 0.280 | STOUT | 0.362 | STOUT |
| `femur_r` | 0.277 | STOUT | 0.307 | STOUT |
| `forearm_r` | 0.245 | SEGMENT | 0.237 | SEGMENT |
| `shin_r` | 0.194 | SEGMENT | 0.214 | SEGMENT |
| `shoulder_span` | 0.133 | SEGMENT | 0.111 | SEGMENT |

**This agrees with Q137's twelve-rig census independently** — head BALL on 10 of
12 with median r/L 1.17, neck NEEDLE, **pelvis NEEDLE on all twelve** — and it
agrees with C164's contract, which was written before either. `build_report`
now derives the band from `CapsuleShape` rather than restating the thresholds,
so the census and the build cannot drift.

---

## THE MEASUREMENT: DOES THE HEAD SPHERE HELP?

128 approach directions, a hand of the **other** man's forearm radius, the grip
spots read from `s46_dof_set.POSES`. Control is the raw build; treatment is the
head promoted. Population named: **f01_m_box_welter @1.78 m against
f02_m_box_heavy @1.88 m** — two rigs, two statures, never one man twice.

### f02_m_box_heavy @1.88 m

| grip spot | band | exposure, control | exposure, head sphere | banded, head sphere |
|---|---|---|---|---|
| `neck@0.15` | NEEDLE | 0.0% | **0.0%** | 0.0% |
| `neck@0.50` | NEEDLE | 0.0% | **0.0%** | 0.0% |
| `thorax@0.65` | STOUT | 20.3% | **26.6%** | 35.4% |
| `thorax@0.70` | STOUT | 20.3% | **25.8%** | 34.4% |
| `thorax@0.80` | STOUT | 21.9% | **29.7%** | 39.6% |
| `pelvis@0.50` | NEEDLE | 50.0% | 50.0% | 53.8% |
| `femur`, `forearm` | — | unchanged | unchanged | — |

### f01_m_box_welter @1.78 m

| grip spot | band | exposure, control | exposure, head sphere | banded, head sphere |
|---|---|---|---|---|
| `neck@0.15` | NEEDLE | 0.0% | **0.0%** | 0.0% |
| `neck@0.50` | NEEDLE | 0.0% | **0.0%** | 0.0% |
| `thorax@0.65` | STOUT | 15.6% | **21.1%** | 28.1% |
| `thorax@0.70` | STOUT | 14.1% | **23.4%** | 31.3% |
| `thorax@0.80` | STOUT | 16.4% | **26.6%** | 35.4% |

**Worst non-adjacent overlap is unchanged to four decimals** under the
promotion (f02 `-0.0091 m`, f01 `-0.0022 m`) and **every gripped capsule is
still 100% present**. The promotion introduces no interpenetration and deletes
no gripped surface.

---

## THE FINDING THAT MATTERS: THE BLOCKER MOVED, THE NUMBER DID NOT

The neck's own count says it plainly. With the head as a capsule, f01's
`neck@0.50` is blocked by `head` on 67 of 128 directions. With the head a
sphere, it is blocked by **`thorax` on 90** — and still 0 of 128 usable.

| rig / spot | control: worst blocker | head sphere: worst blocker |
|---|---|---|
| f02 `neck@0.15` | `thorax` 89 | `thorax` **114** |
| f02 `neck@0.50` | `thorax` 74 | `thorax` **100** |
| f01 `neck@0.15` | `thorax` 63 | `thorax` **98** |
| f01 `neck@0.50` | **`head` 67** | `thorax` **90** |

**Removing one blocker handed its directions to the other.** S52 said the neck
is buried "between the thorax's cap and the head's ball"; the head half is now
gone and the thorax half was always the bigger one. The thorax runs `Chest →
Neck` with `r = 0.1231 m` (f01) / `0.1418 m` (f02), so its **upper cap reaches
that far ABOVE the Neck bone** — twice the whole neck segment on f01. No inset
and no promotion touches that, because the thorax is `STOUT` on both rigs and
`STOUT` is the band that legitimately accepts an inset.

**This is a control arm doing its job.** Every line of evidence pointed at the
head; five agents converged on it; and the thing it was expected to fix did not
move. It ships anyway — see the next section — but not for the reason it was
proposed.

---

## WHY IT SHIPS ANYWAY

Three independent reasons, none of which is "the neck":

1. **The head is not a capsule.** `r/L` is 0.984 and 1.186 on our two rigs and
   BALL on 10 of 12 in Q137's census. J42, line 223, verbatim: *"stop modeling
   as a finite-length capsule with L≈r. Use a **sphere (or ellipsoid)**
   centered on the cranial vault."* Measuring a sphere as a capsule is
   measuring a fiction, whatever the fiction scores.
2. **The thorax improves on both rigs at every blend**, +5.5 to +10.2 points,
   and that is a real gripped surface the corpus actually uses.
3. **What the promotion removes is not head.** f01's head capsule runs from the
   Head bone *up* to the skull centroid, `L = 0.1301 m`, `r = 0.1280 m`, so its
   lower cap reached **0.0686 m below the Neck bone** — into the chest. After
   promotion the sphere's lowest point sits 0.0021 m *above* the Head bone. It
   keeps **56.7%** (f01) / **61.3%** (f02) of the capsule's volume and the
   volume it loses is the lobe that was never a head.

`present_ratio` is an **axial** measure, so it reads every promoted sphere as
`0.0%` and calls it ABSENT. That is right for a capsule clamped to a point by an
endpoint inset and **wrong** for one promoted on purpose, so
`FighterCapsules.sphere_volume_ratio` reports the volume kept instead and the
two numbers are never printed as the same thing.

---

## WHERE I DEPARTED FROM D12, AND WHY

Dola's table says `r/L ≥ 1.00` is **absorbed** and the capsule should be
*"discarded entirely — it is volumetrically indistinguishable from the endpoint
sphere that contains it"*. That holds when the containing sphere belongs to a
**neighbour**. Our head is BALL on 10 of 12 rigs and the only sphere containing
it is its **own** end cap, so discarding it deletes the head from the body —
the exact failure the Present Ratio control was built to catch. **Promote,
never discard.** Her other half — *"never clamp-to-point"* — is kept intact.

Her rule also puts a promoted sphere at the **segment midpoint**. That is right
for a radius measured about a segment and wrong for a `blob`, whose radius is a
p80 **about the vertex centroid**. Putting f01's skull at the midpoint would
slide it 0.065 m down the neck and re-bury the thing this exists to expose. So
`sphere_centre` returns the centre the radius was measured about: `p1` for a
blob, the midpoint for everything else. That is the same rule, not an exception
to it — and it lands exactly where J42 says, "centered on the cranial vault".

---

## THE ELEVATION BAND IS AN INSTRUMENT AND IT REFUTES ITS OWN ESTIMATE

D12 estimated that banding the sweep to the upper hemisphere takes the neck from
0.0% to **70–90%**. **Measured on our rigs: it does not. The neck reads 0.0%
banded too**, over 64 of 128 valid directions, with or without the head sphere.
The neck is buried from *above* as well — the thorax cap is 0.1231 m of solid
capsule sitting over a 0.0594 m segment — so restricting the denominator
changes nothing about a numerator that is zero.

Where banding *does* move a number it moves it modestly and honestly: thorax
20.3% → 27.1% on f02 (96 of 128 directions valid), pelvis 50.0% → 53.8% (119 of
128).

**It is wired as an instrument and must stay one.** Dola's own self-objection is
carried in the module's header and in C165's contract: a single global horizon
would read 95% on a collarbone buried under trapezius. `band_for` is per-region
and an unknown region returns the **full sphere** with `source == "default"`, so
a region nobody has thought about behaves exactly as the code did before this
module existed. Every band in the table is `source: "estimate"` — **not one of
them has been measured**, and they say so.

---

## THE BLIND SPLIT PAID A FOURTH AND FIFTH TIME

Both contract tests were written by Codex from the same contracts, with no sight
of the modules, and both skipped green while the modules were absent.

- **C164 `capsule_shape_contract_test.gd`: 249 of 255 first run.** All six reds
  were the same defect **in the test**: the contract table quotes `r/L` to three
  decimals and the test compared with `is_equal_approx`, whose tolerance at
  0.926 is 9.3e-6 while the rounding is 7.4e-5. Corrected to half a unit in the
  last quoted place. **255/255.** Same family as C163's three reds.
- **C165 `elevation_band_contract_test.gd`: 66 of 69 first run**, and this one
  found a **real design question**, not a rounding slip. Its boundary rows build
  a direction with `Vector3(cos θ, sin θ, 0)`; `Vector3` stores float32, so
  `_direction_at_elevation(-30.0)` round-trips through `atan2` as
  **`-30.000000445292`** (measured; ±4.45e-7 deg at 30° and 60°, exactly zero at
  the poles and the horizon). Its own grid row then demands `in_band` agree with
  a raw `>= lo`, and **no implementation can satisfy both**: one row says keep
  that sample, the other says drop it. Settled in the **module** — `in_band`
  carries `BOUNDARY_EPSILON_DEG = 1e-4`, 225× the measured noise and 300,000×
  finer than the narrowest band distinction — because a 128-direction sweep must
  not lose samples to float noise. The grid now carries the module's own
  constant. **69/69.**

`elevation_deg` also answers the poles and the horizon without `atan2` at all,
so `Vector3.UP` is exactly `90.0` rather than whatever `PI/2 * (180/PI)` rounds
to. `Vector3.UP == +90.0` is asserted, not assumed — the Z-up convention passes
every symmetry test and is wrong by 90° on every real direction.

---

## NON-VACUITY, BECAUSE AN UNCHANGED CONTROL PROVES NOTHING

`s53_ball_capsules.gd` fails outright unless: the head has axial length **before**
promotion and none **after**; `build_report`'s shipped `capsules` actually
carries the promotion; an unknown region falls back to `source == "default"`;
and the neck's band admits strictly less than the unbanded sweep. Without those
four, "the number did not change" would be indistinguishable from "the
instrument could not move" — which is exactly what `fight_body_overlap_test` is
still doing and what S41's control arm did.

---

## WHAT THE SPAN FIX WOULD HAVE COST, AND WHY IT WAS NOT DONE

Q138 measured it and refused it: the neck leaves the NEEDLE band at **111 mm on
all twelve rigs**, which is **3.2 mm above ANSUR's 107.8 mm Neck Link**. At the
anatomical length `r/L` is still 0.5102. **You would need a neck longer than a
human's.** Not attempted here, by instruction.

---

## THE NEXT FIX, NAMED BY THE MEASUREMENT

1. **THE THORAX'S UPPER CAP IS THE NECK'S REMAINING BLOCKER, AND IT IS THE ONLY
   ONE LEFT.** It blocks 90–114 of 128 directions on both rigs after the head is
   gone. The thorax is `STOUT` on both, so nothing in this stage's rule touches
   it — and S48 already narrowed it 0.1909 → 0.1418 without moving the neck one
   direction. The question is not the radius. It is whether a capsule ending at
   the **Neck bone** with a hemispherical cap is the right abstraction for a rib
   cage that ends at **T1** with a flat top. That is assigned.
2. **OUR HEAD SPHERE MAY BE TOO FAT AND NOBODY HAS CHECKED.** The blob p80 is
   `0.1280 m` (f01) / `0.1299 m` (f02). J42's anthropometry puts an honest head
   sphere at **half Head Length ≈ 0.0998 m** (forehead↔occiput) or **half Head
   Breadth ≈ 0.0772 m** (temple width), *"they are not interchangeable"*. Ours is
   28–66% larger than either. A p80 of vertex distance to the centroid includes
   hair and ears. That is a measurement, on all twelve rigs, and it is assigned.
3. **NOT ONE ELEVATION BAND IS MEASURED.** Four regions, four `"estimate"`
   sources, and the fifth region anybody adds will not be in the table. The
   `"default"` row stops that becoming a silent lie; it does not make the four
   numbers true.
