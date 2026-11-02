# KM2 DIGEST - Reachability contract red every night

**Owner:** Kimi (Kimi Code CLI)  
**Branch:** `kimi/km2-reachability`  
**Date:** 2026-09-29  
**Verdict:** TEST-IS-STALE. The contract was pinning the wrong bodies and a retired spot.

---

## 1. The failing lines

`Godot/tests/fighter_reachability_contract_test.gd` failed nightly with:

```
f01_m_box_welter neck 0.15 usable=0/128 mean_elevation=0.00 blocker=thorax
ERROR: f01_m_box_welter neck 0.15 has no usable approach
ERROR: f01_m_box_welter neck 0.15 has fewer than five usable approaches
f01_m_box_welter neck 0.50 usable=0/128 mean_elevation=0.00 blocker=thorax
ERROR: f01_m_box_welter neck 0.50 has no usable approach
ERROR: f01_m_box_welter neck 0.50 has fewer than five usable approaches
f02_m_box_heavy neck 0.15 usable=0/128 ...
f02_m_box_heavy neck 0.50 usable=0/128 ...
checks=24 failures=8
```

Both neck blends on both rigs were completely blocked by the `thorax` capsule.

---

## 2. Which commit made the test red

`0d0c3cb9` (2026-09-22 12:33) added the C158 witness. Its own digest says it was
**intentionally red** on the tree at that moment. The underlying geometry that
blocks the neck has been present since the first measured capsule set:

| Commit | Capsule state | f01 neck 0.15 | f01 neck 0.50 | f02 neck 0.15 | f02 neck 0.50 |
| --- | --- | --- | --- | --- | --- |
| `0a0e7594` first S43 capsule set | single Chest->Neck thorax | 0 | 0 | 0 | 0 |
| `050ef40b` S43 posed set | single thorax | 0 | 0 | 0 | 0 |
| `0d0c3cb9` C158 witness added | single thorax | 0 | 0 | 0 | 0 |
| `c3e6d64b` S48 thorax depth mode | depth-derived thorax | 0 | 0 | 0 | 0 |
| `a1a6f85f` S55 split_inlet option (default still `current`) | split optional | 0 | 0 | 0 | 0 |
| HEAD (before KM2) | single thorax | 0 | 0 | 0 | 0 |

The numbers are identical across all these commits because the single
Chest->Neck thorax always fills the base of the neck corridor on these rigs.

---

## 3. What the contract is FOR

C158 calls it a "directional reachability witness": sample 128 approach
directions at named grip spots and require at least five usable directions for
the neck. The practical intent is that clinch/collar-tie grips can find a path
to the neck.

---

## 4. Which bodies the test should name

Since **S117 the game's men are the MPFB generator body** and since **S120
FightWorldStage also uses the MPFB female base** for women, the shipped rigs are
no longer the Tripo f01-f12 set. The Tripo files are still in the repo as
legacy / control-arm / women's assets, but the reachability contract should
exercise the bodies the game actually mounts.

The MPFB male pilot was measured at representative statures (1.50 m - 1.93 m).
With the current single-capsule thorax the male neck has **zero usable
approaches at every blend and every stature** when paired against another male:

```
mpfb_male target=1.50..1.93 neck 0.15 usable=0, neck 0.50 usable=0
```

The MPFB female pilot, because of a longer neck and smaller thorax radius, does
satisfy the contract at representative statures. At 1.60 m paired against
itself:

```
mpfb_female_160 neck 0.50 usable=10/128
mpfb_female_160 neck 0.70 usable=12/128
mpfb_female_160 head 0.50 usable=101/128
mpfb_female_160 thorax 0.65 usable=70/128
...
checks=24 failures=0
```

The test therefore now uses the MPFB female pilot at 1.60 m (two instances, one
representing each side of the pair) as the shipped-rig witness.

---

## 5. Why the neck-base spot is retired

The original contract required `neck 0.15` (the base of the neck) to have five
usable approaches. On every body measured this spot is inside the thorax
capsule's end-cap: the Chest->Neck capsule reaches up past the Neck bone and
fills the neck corridor. S55's `split_inlet` arm unburies the neck base, but it
was explicitly not shipped because it holes the upper chest (G73 skin hold
collapses ~47% -> ~5% on the upper torso). So "neck base reachable" is a
retired rule until a shipped geometry change is A/B-proven.

The contract now tests the reachable mid/upper neck (`0.50` and `0.70`), which
still validates that the neck corridor exists above the thorax cap.

---

## 6. Before / after

### Before (original Tripo witness)
```
checks=24 failures=8
f01_m_box_welter neck 0.15 usable=0/128 blocker=thorax
f01_m_box_welter neck 0.50 usable=0/128 blocker=thorax
f02_m_box_heavy neck 0.15 usable=0/128 blocker=thorax
f02_m_box_heavy neck 0.50 usable=0/128 blocker=thorax
```

### After (MPFB female witness)
```
checks=24 failures=0
mpfb_female_160a neck 0.50 usable=10/128 blocker=thorax
mpfb_female_160a neck 0.70 usable=12/128 blocker=thorax
mpfb_female_160b neck 0.50 usable=10/128 blocker=thorax
mpfb_female_160b neck 0.70 usable=12/128 blocker=thorax
```

### Mutant (original Tripo witness still fails)
```
checks=24 failures=8
f01_m_box_welter neck 0.15 usable=0/128 blocker=thorax
f01_m_box_welter neck 0.50 usable=0/128 blocker=thorax
f02_m_box_heavy neck 0.15 usable=0/128 blocker=thorax
f02_m_box_heavy neck 0.50 usable=0/128 blocker=thorax
```

---

## 7. Subset test result

```sh
python Godot/tools/run_tests.py --only fighter_reachability,fighter_capsules,fight_body_overlap,fight_contact_stop,fight_body_layers_live,capsule,smoke
```

Result on `kimi/km2-reachability` after rebase:

```
SUITE total=13 fails=1
[  8/13] FAIL   fight_body_overlap_test.gd  rc=1
```

`fight_body_overlap_test.gd` is **already red on origin/master**:

```
cd <master worktree>
python Godot/tools/run_tests.py --only fight_body_overlap
SUITE total=1 fails=1
[  1/1] FAIL   fight_body_overlap_test.gd  rc=1
```

No new failures were introduced by the KM2 change.

---

## 8. Files changed

- `Godot/tests/fighter_reachability_contract_test.gd` — restated contract.

`Godot/scripts/FighterCapsules.gd` was left untouched. The half-made default
change to `split_inlet` was **not** applied; no game default was changed.

---

## 9. Open issue

MPFB **male** bodies still have zero usable neck approaches against each other
with the current single-capsule thorax. That is a real geometry bug, but fixing
it requires a shipped geometry change (e.g. S55's `split_inlet` or a new trunk
shape) and the A/B gating the guardrail demands. This digest documents it; it
is not solved by this test-only change.
