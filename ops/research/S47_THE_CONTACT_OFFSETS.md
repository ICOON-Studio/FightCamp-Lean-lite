# S47 — THE CONTACT OFFSETS, DERIVED. AND WHY IT WAS NOT THE OFFSETS.

**Session:** S47, 2026-09-22. **Stage:** derive the contact offsets off our own
rig instead of inheriting them from a ~1 m source build, and report the residual
with the offsets that produced it.

## The rejection criterion, written before the numbers

> S46 found the residual is arm-through-torso, not a limb reaching wrong, and
> blamed the pose's own contact spec — pelvis-to-pelvis offsets of 0.02–0.03 m
> authored against a 1.00 m body. The derivation PASSES if offsets taken off our
> own rig materially reduce `pen_max` on the poses S46 named. **No bound is
> widened to rescue it.** If a pose still fails on a derived offset, that is the
> finding.

**No bound was relaxed. `PASS_PEN_M` and `PASS_GRIP_M` are untouched. The
derivation did not rescue it — and the reason it did not is the stage.**

## First, a correction to the brief, because the derivation depended on it

The handover said the offsets pin the two pelvises 0.02–0.03 m apart and that
"two men with 0.50 m of torso each cannot stand 0.03 m apart at the hips without
one being inside the other."

**`off` is already a SURFACE gap, not a centre distance.**
`FightPoseSolver.evaluate` computes `capsule_gap(a, b) - off`, and `capsule_gap`
is `d - (r_a + r_b)` — the radii are subtracted before the offset is applied.
0.03 m of *surface* gap is reachable at any stature, so scale alone is not the
mechanism.

The real mechanism is one step further in, and it is worse:

> A 0.03 m pelvis **surface** gap puts the two men chest to chest — 0.29 m centre
> to centre on our rig. The collar tie then asks a **0.4848 m arm** to place its
> hand on a neck **0.29 m away**. The arm is longer than the gap it has to cross,
> so the only way to satisfy the grip is to fold the forearm *through* the other
> man's chest. The 0.1274 m is the overshoot.

That reading is testable, and testing it is what found the real defect.

## The derivation, and every term comes off the rig

A hold is taken at **arm's length** or it is **wrapped**, and the pose says which:
a grip on the other man's `thorax` or `pelvis` means the arm is round him and the
trunks genuinely touch; a grip that only reaches his `neck` or `head` means he is
held off at the end of an extended arm.

| class | wanted trunk-to-trunk SURFACE gap |
|---|---|
| arm's length | `reach_A − r_a − r_b`, with `reach_A = \|upper_arm_A\| + \|forearm_A\|` |
| wrapped | `0.0` — touching means touching |

Measured on f01: `reach = 0.2508 + 0.2340 = 0.4848 m`;
`r_pelvis` f01 = 0.1703, f02 = 0.1946. So the derived collar-tie pelvis gap is
**0.1200 m against an authored 0.0300 m** — four times wider, and one arm length
centre to centre.

**The classifier is a rule, not a constant: 2 poses arm's length, 11 wrapped.**
Only trunk-to-trunk contacts are derived; `femur_r/femur_r 0.08` in the sprawl is
a legs-apart stance this rule says nothing about, so it keeps its authored value
and is printed as `kept`. A rule that rewrote it anyway would be guessing.

**One poses table, never a copy.** The thirteen poses are read out of
`tools/s46_dof_set.gd`'s own constant map rather than pasted, so the control arm
and the derived arm are provably the same corpus.

## The result: 3/13 → 4/13, and the named poses barely moved

| pose | authored `pen_m` | derived `pen_m` | worst pair (derived) |
|---|---|---|---|
| collar_tie | 0.1274 | **0.1223** | `forearm_r/thorax` |
| double_collar | 0.0707 | 0.0971 | `forearm_l/upper_arm_l` |
| front_headlock | 0.1261 | 0.1270 | `forearm_r/thorax` |
| rear_naked | 0.0935 | 0.0935 | `forearm_r/thorax` |
| single_leg | 0.0053 | **0.0016** ✓ | `upper_arm_r/femur_r` |

`authored=3/13 derived=4/13`. Seven poses moved; two improved, five worsened
slightly. **A 5 mm improvement on a 127 mm defect is not a fix.**

## The probe that settled it: the stance WAS achieved

A contact offset is a *want*. Whether the solver reached it is a separate fact,
and a stage that reports "derived offsets did not fix it" without checking which
of the two happened has found nothing.

```
== ANATOMY PROBE: collar_tie, on the DERIVED solve ==
  pelvis surface gap  wanted 0.1200  achieved 0.1156 m  (miss -0.0044)
  pelvis centre separation, horizontal: 0.5027 m  (one arm = 0.4848 m)
  worst pair forearm_r/thorax: pen 0.1223 m
    A.forearm_r  p0=(0.061,1.691,-0.148) p1=(-0.000,1.916,-0.149) r=0.0574
    B.thorax     p0=(-0.153,1.572,-0.121) p1=(-0.111,1.874,-0.102) r=0.1909
    B capsule radius 0.1909 m vs penetration 0.1223 m -> the capsule is the obstruction
  B.thorax spans y 1.572..1.874 (r 0.1909); B.neck spans y 1.874..1.927
```

**The two men are standing exactly one arm apart, as derived, and the forearm is
still a hand's depth inside the chest.** So it is neither the DOF set (S46) nor
the stance (here). That leaves the capsules themselves.

## THE FINDING: the neck is unreachable on both bodies

For every capsule the corpus uses as a grip target, sample 512 points round its
own surface and count how many a hand could occupy without entering another
capsule **of the same body**.

| target (f02) | r | len | exposed | buried by | deepest |
|---|---|---|---|---|---|
| `femur_l` | 0.1400 | 0.4636 | 69.1% | femur_r | 0.1809 |
| `femur_r` | 0.1423 | 0.4636 | 69.7% | femur_l | 0.1806 |
| `forearm_r` | 0.0696 | 0.2940 | 75.0% | upper_arm_r | 0.0235 |
| **`neck`** | 0.0550 | 0.0774 | **0.0%** | **thorax** | **0.1610** |
| `pelvis` | 0.1946 | 0.2361 | 88.5% | femur_r | 0.0429 |
| `thorax` | 0.1909 | 0.3054 | 59.8% | upper_arm_r | 0.1355 |

f01 reads the same way: **`neck` 0.0% exposed, buried 0.1230 m inside `thorax`.**

**No hand can touch the neck from any direction, on either body, without entering
the thorax capsule. Every neck grip in the corpus is unsatisfiable by
construction** — and a solver told to satisfy one can only answer by burying the
hand, which is precisely what `pen_pair` has been reporting since S43.

The correlation is exact. The four poses that grip or contact the neck —
`collar_tie`, `double_collar`, `front_headlock`, `rear_naked` — are four of the
five worst penetrations in the corpus.

### Why the thorax swallows the neck

`FighterCapsules` derives a radius as the **p80 of the skin vertices dominated by
that bone**, which is the right derivation for a limb. On these meshes the
**Chest** bone owns the deltoids and the lats, so its p80 is a shoulder-width
half-breadth, not a chest depth: **r = 0.1909 m on a 0.3054 m segment.** A
capsule whose radius is 0.625× its length is a ball, and its upper cap reaches
0.1909 m above the Chest joint — past the shoulders and over the whole neck
(0.0774 m long, r 0.0550).

A single-radius capsule cannot represent a torso that is ~0.38 m wide and ~0.22 m
deep. The p80 takes the wide axis, and the depth axis pays for it.

## What this rules out, and what it names

- **Not the DOF set.** S46 measured three sets; the residual moved, the verdict
  did not. Do not add a fourth joint.
- **Not the contact offsets.** Derived here off the rig, the stance was achieved
  to 4 mm, and the defect did not move.
- **Not the pass bounds.** Scaling them by stature (×1.847) takes the corpus to
  7/13 and leaves all four neck poses red — 0.1223 m against a 0.0111 m bound is
  eleven times over. **The engine's `PASS_*` constants were NOT changed**; the
  scaled column is reported beside the real one so the question is answered
  without relaxing the gate that answers it.
- **It is the capsule model.** The next stage is the torso: either a multi-segment
  trunk (upper chest / lower chest as separate capsules, the way
  `FighterCapsules` already splits the femur), or a non-circular cross-section,
  or a thorax radius derived from chest **depth** rather than the p80 of a vertex
  set that includes the arms.

**Cheapest decisive next test**, and it needs no new geometry: re-derive the
thorax radius from the Chest vertices' spread **along the body's own forward
axis** rather than the isotropic p80, re-run the reachability audit, and see
whether `neck` exposure goes above zero. If it does, the corpus is testable again;
if it does not, the trunk must be split.

## Non-vacuity — could this instrument have read differently?

- poses whose `pen_max` moved at all: **7/13** (two improved, five worsened)
- classifier split **arms_length=2 wrapped=11** — the rule can say no
- derived collar-tie pelvis gap **0.1200 m** against an authored 0.0300 m, asserted
- the reachability audit is a finding, not a failure: the tool exits 0 and prints
  `unreachable_grip_targets=2` separately from `fails=0`

## Population

**f01_m_box_welter at 1.78 m against f02_m_box_heavy at 1.88 m** — two different
rigs at two different statures, named in the artefact's own output. Never one
fighter twice, and never two men from one stat block. The corpus is the same
thirteen poses S43/S46 used, read from S46's own table.

## The command

```
Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tools/s47_contact_offsets.gd
```

## D6 — the control experiment on Dola's rig, and why its numbers are not ours

D6 ran the same three parts on her own 1 m rig scaled to 1.847 m and reported
0/13 authored, 9/13 derived, 13/13 with stature-scaled bounds — and recommended
we adopt both. **Two reasons not to take that at face value, both visible in her
own reply:**

1. **Her offset rule is fitted, not derived.** `off = k·(r₁+r₂)` with per-pair k
   of 0.15 / 0.12 / 0.10 / 0.08 / 0.05, and her own justification line says the
   rule was *"chosen to recover ~original offsets at 1.0 m scale"*. That is
   fitting to the fossil, which is the failure mode
   `gates-must-derive-not-copy` exists to stop.
2. **Her rig cannot see this defect.** Her worst pairs are `thorax↔pelvis` and
   `pelvis↔pelvis` at 0.005 m. Ours is `forearm_r/thorax` at 0.1223 m — twenty
   times larger — because she has nine limbs and we score fifteen capsules
   all-pairs. Her 13/13 is a statement about a nine-limb abstraction.

Her Part 1 also reports 0/13 where our own authored arm reads 3/13 on the same
thirteen poses, which is the same non-transfer S46 already recorded for D5. The
useful half of D6 is the **form** `off = f(radii)` — size-covariant rather than
absolute — and that form is what the rule above uses, with the term taken off our
rig instead of chosen to match a remembered number.
