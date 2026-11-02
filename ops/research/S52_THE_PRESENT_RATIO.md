# S52 — THE PRESENT RATIO, AND WHAT IT REFUSED ON ITS FIRST USE

**Stage:** S52 (Claude). **Landed 2026-09-22.**
**Brief:** `D11_HEAD_CAP_ANSWER.md`, `TASK_C163_PRESENCE_CONTRACT.md`.
**Instrument:** `Godot/tools/s52_present_ratio.gd`.
**Population:** `f01_m_box_welter` @1.78 m against `f02_m_box_heavy` @1.88 m —
two different rigs at two different statures, never one man twice. Corpus: the
13 poses in `tools/s46_dof_set.gd`, grip spots read from their own grip records.

---

## THE HEADLINE, IN THREE LINES

1. **The tree today is not arm A.** The endpoint inset was never implemented
   here. Every capsule in the shipped tree reads **100.0% present**, and the
   neck is `0.0% | 100.0%` → **OBSCURED**: buried, not erased.
2. **All three of Dola's arms are erasures on our rigs, and none of them ships.**
   Arm A deletes the neck and halves the thorax while buying **zero** exposure.
   Arm B **consumes the head capsule entirely**. Arm C is both.
3. **Arm C, D11's recommendation, reads `3.9% | 7.4%` → ABSENT on f01.** On her
   rig it read `99.4% | 100.0%`. **The result does not transfer**, and the
   Present Ratio control is what caught it — on its first real use, refusing
   the very recommendation that motivated building it.

---

## WHAT WAS BUILT

| file | what it is |
|---|---|
| `Godot/scripts/CapsulePresence.gd` | the pair and its five-band verdict, to C163's contract |
| `Godot/scripts/FighterCapsules.gd` | `build_report` now returns `extents`; `inset_endpoints` + `INSET_ARMS` |
| `Godot/tools/s52_present_ratio.gd` | the measurement, all four arms side by side on both rigs |
| `Godot/tests/capsule_extents_test.gd` | 13 checks on the denominator and the arms |
| `Godot/tests/capsule_presence_contract_test.gd` | Codex's blind test, three swapped calls corrected |

**The denominator is taken from the build, never recomputed in the probe.**
`build_report` captures the bone-to-bone distance **before** anything moves an
endpoint and returns it as `extents[name].authored_m`. A gate that derives its
own denominator from the thing it is judging cannot fail, and that class of
defect has cost this project a day more than once.

---

## THE MEASUREMENT

`Exposure %` is the share of 128 approach directions that put a hand of the
**other man's** forearm radius tangent to the grip spot without entering another
capsule of the same body. `Present %` is `CapsulePresence.present_ratio`.
Verdict is `CapsulePresence.classify`. Pass window: exposure ≥ 90 **and**
present ≥ 95.

### f02_m_box_heavy @1.88 m — the man being gripped

| arm | neck@0.50 | thorax@0.70 | shortened vs bone-to-bone |
|---|---|---|---|
| **current** (the tree) | `0.0% \| 100.0%` OBSCURED | `20.3% \| 100.0%` OBSCURED | none — every capsule 100% present |
| **A** thorax+neck | `0.0% \| 29.0%` **ABSENT** | `11.7% \| 53.6%` **ABSENT** | thorax 53.6%, neck 29.0% |
| **B** head only | `0.0% \| 100.0%` OBSCURED | `25.8% \| 100.0%` OBSCURED | **head 0.0000/0.0774 = 0.0%** |
| **C** both | `5.5% \| 29.0%` **ABSENT** | `14.8% \| 53.6%` **ABSENT** | thorax 53.6%, neck 29.0%, **head 0.0%** |

### f01_m_box_welter @1.78 m — the man gripping back

| arm | neck@0.50 | thorax@0.70 | shortened vs bone-to-bone |
|---|---|---|---|
| **current** (the tree) | `0.0% \| 100.0%` OBSCURED | `14.1% \| 100.0%` OBSCURED | none — every capsule 100% present |
| **A** thorax+neck | `0.0% \| 7.4%` **ABSENT** | `10.9% \| 56.4%` **ABSENT** | thorax 56.4%, neck 7.4% |
| **B** head only | `0.0% \| 100.0%` OBSCURED | `23.4% \| 100.0%` OBSCURED | **head 0.0021/0.0594 = 3.6%** |
| **C** both | `3.9% \| 7.4%` **ABSENT** | `14.1% \| 56.4%` **ABSENT** | thorax 56.4%, neck 7.4%, **head 3.6%** |

**Overlap is unchanged by every arm** — worst non-adjacent pair stays −0.0091 m
(f02) and −0.0022 m (f01), both gaps. Dola's zero-overlap claim does hold here.
It is the only one of her claims that does.

---

## WHY EACH ARM FAILS, AND WHY IT IS NOT HER MISTAKE

### Arm A buys nothing at all

On her rig arm A took the neck from 0.0% to **92.7% exposed**. On ours it takes
it from 0.0% to **0.0%**. The worst-blocker column says why in one word: under
`current` the neck's blocker is `thorax`; under arm A it is **`head`**, 106 of
128 directions on f01. Insetting the thorax does not clear the neck, it hands
the job to the head blob. The neck was blocked from **both** sides the whole
time — which is the same lesson `_grip_reachability_audit` already carries in a
comment, arrived at from the other direction: *a diagnosis naming one cause out
of an early-exit loop is an artefact of iteration order.*

And it is not free. The thorax drops from 100% present to **53.6%**, and its
own exposure falls with it (f02 `20.3% → 11.7%`). **Arm A makes both measured
quantities worse on both rigs.**

### Arm B deletes the head

This is the one nobody forecast. `head` is a **blob**: it runs from the Head
bone to the skull's own vertex centroid, and its radius is a skull half-width.
**That radius is larger than the segment's own length** — 0.0774 m of segment
on f02 against a radius that consumes all of it. Dola's rule insets an endpoint
by the capsule's own radius, so on a capsule that is already a ball the inset
runs the far endpoint through the near one. Clamped, it collapses to a point:
**0.0% present on f02, 3.6% on f01.**

Arm B's thorax exposure gain — a real `+5.5` to `+10.2` points on both rigs —
is therefore **exactly** the effect Codex named when he objected to exposure
alone: *"accessibility can improve by DELETING PROTECTIVE GEOMETRY."* The
thorax became easier to reach because the head stopped existing. Without the
Present Ratio beside it, arm B is the most attractive number in this table.

### Arm C inherits both

`3.9% | 7.4%` on f01. Her arm C was `99.4% | 100.0%`.

### She predicted this, one segment early

> *"The rule `boneY ± r` tapers every joint segment to a needle at both ends —
> scale this to spine, shoulders, hips, and you do not have an anatomical rig
> any more; you have a stick figure with collision balloons."*

She named the **shoulder girdle** as the case she had not tested and was not
confident about. The generalisation actually broke one segment earlier, on the
**head** — and for the reason her own sentence gives. J41 (John, landed today)
measured the same boundary independently from the anthropometry side and agrees:
the inset survives on bony clavicle (r/L ≈ 0.04) and soft upper arm (r/L ≈ 0.17),
and a capsule is the **wrong abstraction** where r/L is large. **r/L ≥ 0.5 is a
needle, and our head blob is past it.**

### One coincidence, named so nobody reads it as validation

Our f01 arm-A neck reads **7.4% present**, which is Dola's number to the
decimal. It is not a cross-check: she had `0.0081 / 0.1090` and we have
`0.0044 / 0.0594`, two different rigs that happen to share `r/L ≈ 0.926`. The
agreement is arithmetic, not evidence.

---

## WHAT SHIPS, AND WHAT DOES NOT

**SHIPS:** the instrument (`CapsulePresence`, `extents`, `s52_present_ratio.gd`,
both tests). **`inset_endpoints` ships as code and is wired to nothing** — it is
the control arm the next attempt needs, and `INSET_ARMS["current"]` is empty, so
the default build is byte-identical to before.

**DOES NOT SHIP:** arms A, B and C. A change that makes the measured thing worse
does not ship because its failure is informative — that is the pelvis lesson, and
this is the same shape: every line of evidence pointed at the endpoint inset and
the measurement refused it.

---

## THE NEXT FIX, NAMED

**The blockers are radii, not endpoints.** The neck is buried between the
thorax's cap and the head's ball, and an endpoint inset cannot move a sphere
centred on a bone. Two candidates, in order:

1. **The head blob's radius derivation.** A capsule whose radius exceeds its own
   length is a ball wearing a capsule's name, and it is the neck's deepest
   blocker on both rigs under every arm. S48 fixed exactly this shape of defect
   on the thorax by deriving the radius on a **measured axis** (`mode: depth`)
   rather than isotropically. The head has had no such pass. **Do that pass
   before touching an endpoint again**, and print `Exposure % | Present Ratio %`
   for it.
2. **Whether 0.0% is the right target at all.** S47B already found the neck
   reads 0.0% on Perchance's shipping rig too, and concluded an assertion false
   on every capsule humanoid is not measuring the engine. A neck is reached from
   above and from the side; the corpus's own grips have a mean elevation, and
   `_grip_reachability_audit` already prints it. **An elevation-banded exposure
   may be the honest denominator**, and it would cost nothing to measure.

**Do not roll `boneY ± r` out past the neck.** Dola said so, J41 said so from
the anthropometry, and S52 now says so from our own rigs.

---

## THE BLIND SPLIT PAID AGAIN, AND IT CAUGHT A REAL THING

C163 was written against the same contract with no sight of the module, and the
module was written with no sight of the test. First run: **54 of 57 green**, and
the three reds were all in the test, not the module.

```
classify(94.99, 100.0) == "PARTIAL"    labelled "present below 95"
classify(49.99,  90.0) == "DELETED"    labelled "present below 50"
classify(50.0,   90.0) == "PARTIAL"    labelled "present at 50"
```

The signature is `classify(exposure_pct, present_pct)`. These four rows probe
the **present** axis, so the varying number belongs in the **second** slot; as
landed they put it first, which measured the exposure boundary a second time
under a present label. The labels name the intent exactly, so the reading is not
in doubt.

**Everything else in the test had the order right** — the exposure rows above
it, the three real arms below it, and the 36-cell `passes`/`classify` agreement
grid, which is the strongest part of the file and agreed with the module on
every cell. Corrected in place; the module was not touched.

**Then seven mutants, because a green contract test proves nothing until it has
been made to fail.** All seven RED, none vacuous (`total` stayed 57 throughout,
so none of them made the test skip rather than fail), module restored to
byte-identical afterwards:

| mutant | what it breaks | result |
|---|---|---|
| M1 | present-intact boundary made exclusive | RED fails=4 |
| M2 | exposure boundary made exclusive | RED fails=7 |
| M3 | present-half boundary made exclusive | RED fails=2 |
| M4 | `present_ratio` loses its high clamp | RED fails=1 |
| M5 | `present_ratio` returns 100 on `authored <= 0` | RED fails=2 |
| M6 | `passes` uses `or` | RED fails=12 |
| M7 | `format_pair` prints two decimals | RED fails=2 |

Driver kept in the session scratchpad; it is a dozen lines and reproduces from
the table above.

---

---

## WHAT LANDED AFTER THIS DIGEST WAS FIRST WRITTEN — FOUR AGENTS, ALL BLIND

The "next fix, named" section below was written before any of these arrived.
Every one of them agrees with it and three of them sharpen it.

**Q137 (Qwen) — the census, 12 rigs, verified here off the branch.** The problem
is not the neck, it is the TRUNK:

| capsule | bands across 12 rigs | median r/L |
|---|---|---|
| `head` | **BALL x10**, NEEDLE x2 | 1.17 (max 1.75) |
| `neck` | NEEDLE x8, **BALL x4** (the four SMALLEST statures) | 0.93 |
| `pelvis` | **NEEDLE x12** — every rig, 0% surviving a two-end inset | 0.83 |
| `thorax` | STOUT x7, NEEDLE x5 — straddling the boundary | 0.49 |
| `foot_l` | NEEDLE x8 | 0.53 |
| everything femur-outward | SEGMENT or STOUT | fine |

**J42 (John) — the anthropometry, blind.** A real male neck is **ANSUR Neck Link
107.8 mm with soft radius 63.3 mm = r/L 0.59**, already a NEEDLE. His line:
*"the double-end inset cannot survive on neck even at correct L."* Head as a
capsule is r/L ~ 1.00 — **use a sphere**. **So the rule is dead, not
mis-parameterised.** Our span is separately short (59-77 mm against ~108 mm
C7-tragion) and that is worth fixing on its own terms, but it does not rescue
the inset.

**D12 (Dola) — classify on load.** `< 0.50` normal, `0.50-1.00` degenerate ->
sphere at the midpoint, `>= 1.00` absorbed -> discard. *"Do not clamp and keep -
promote or remove, never clamp-to-point."* **That is a direct ruling on
`inset_endpoints`, which clamps.** Correct for this measurement, wrong for a
shipping build; it is wired to nothing.

**G70 (Grok) — the replacement, designed.** One neck volume plus four named
anchors with approach cones, which is D11's own second model. Its refusal rule
independently says *"do not shorten neighbours."*

**And C164's contract bands — 0.25 / 0.50 / 1.00 — were written and handed to
Codex before any of the four arrived, and land in the same places.**

**Q138 (Qwen) — the span sweep, and it refuses the span fix too.** The last open
question was whether correcting our short neck span would help on its own terms.
It does not. The neck leaves the NEEDLE band at **111 mm on all twelve rigs**,
**3.2 mm ABOVE** ANSUR's 107.8 mm Neck Link.

| capsule | median L_exit | median ratio | verdict |
|---|---|---|---|
| `neck` | **111 mm** | 1.90x | **above anatomical — the span fix fails** |
| `pelvis` | 349.5 mm | 1.66x | implausible for a structural ring |
| `head` | 257 mm | 2.32x | **3/12 never exit within 3x** |
| `thorax` | 278 mm | 1.00x | already fine on most rigs |
| limbs | — | 1.00x | already STOUT or better |

**Verified here by hand rather than taken from its report:** `RADII_M["neck"]`
is authored at 0.055 for every rig, so `2r = 110 mm` and the first 1 mm step out
of the band is 111 on all twelve — which is why the number is identical across
the population. At 107.8 mm the ratio is **0.5102**; with J42's soft radius of
63.3 mm it is **0.5872**. **You would need a neck longer than a human's.**

It also reported honestly that `CLAUDE_LAND_NOTE_J42.md` was not on disk in its
worktree — its branch was cut before the J42 merge — and that it fell back to
the 107.8 mm figure in its own task file. The value was right, but **that is a
copy rather than a derivation**, and it is only safe because the fallback was
declared. A task that hands an agent a number it is also asked to read from a
file should say which wins.

**So the span correction is housekeeping, not a fix, and it is off the critical
path.** The trunk is not capsule-shaped.

### The one correction to Dola

She recommends matching her `r_neck = 0.035 m`. **Do not.** That is a 0.22 m
girth; `RADII_M`'s own note derives our 0.055 from a 0.35 m male girth, and J42
puts the anatomical soft radius at **63.3 mm — larger than ours**. Our radius is
right. Our length is short. And the rule dies either way.

### Integration note

The suite read **total=344 fails=8** — the same eight known reds S51 left, no
new failures. It ran BEFORE `q137-slenderness-census`, `u130-post-fight-result`
and `u134-wire-result` were merged. Those three were re-verified after merging
with the parse gate plus `--only ui` (17/0) and `--only fight_result` (1/0), but
**the full suite has not run on the merged tree** — S53 runs it.

## REPRODUCE

```
Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tools/s52_present_ratio.gd
python Godot/tools/run_tests.py --only presence
python Godot/tools/run_tests.py --only capsule_extents
```
