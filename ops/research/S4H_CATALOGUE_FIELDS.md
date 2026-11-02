# S4h — THE `usage` FIELD, AND WHAT ELSE A MOVE NEEDS TO BE EXECUTABLE

Claude, 2026-09-17, on the operator's "add the field on catalogue and check if we missing more fields to make the moves
executable at each discipline".

## PART 1 — THE FIELD

`match.usage`: how often a fighter reaches for this technique, relative to a default of **1.0**. Added to **six** nodes
and no others.

**STUDY**: Thomson & Lamb 2016, *Int J Perf Anal Sport* — 92 English amateurs, a bout typified by **183 punches**, six
named types with 95% CIs. Carried by `J21_THE_MOVE_PALETTE.md`, graded **DIRECT**. **LABEL: DOCUMENTED.**

| node | J21 count (95% CI) | share | `usage` |
|---|---:|---:|---:|
| `boxing_jab` | 64 (60–68) | 35% | **2.04** |
| `boxing_lead_hook` | 49 (46–51) | 27% | **1.56** |
| `boxing_cross` | 39 (37–41) | 21% | **1.24** |
| `boxing_rear_hook` | 23 (20–26) | 13% | **0.73** |
| `boxing_rear_uppercut` | 8 (7–9) | 4% | **0.26** |
| `boxing_lead_uppercut` | 5 (5–6) | 3% | **0.16** |

Normalised to **mean 1.0** so the six keep their relative frequencies without swamping the nodes that carry no prior.
**ABSENT MEANS 1.0 AND THAT IS DELIBERATE** — every other node in the catalogue is left alone rather than given a number
nobody measured.

### Wired, not orphaned — behind `usage_prior`, default OFF

`move_from_node` reads it; `select` multiplies it into the same joint walk (`role_w × share × region_w × fit ×
stance_w × usage_w`), one lookup per candidate and exactly 1.0 for every node without a prior. Switched off:
`fight_realtime_test`, `fight_strike_band` and `grapple_adapter` green — 4 tests, 0 failures.

### THE A/B — `tools/probe_usage_prior.gd`, 12 seeded boxing bouts

| punch | OFF | **ON** | J21 | error OFF → ON |
|---|---:|---:|---:|---|
| jab | 15.6% | **27.2%** | 35.0% | −19.4 → **−7.8** |
| cross | 16.6% | 16.8% | 21.0% | −4.4 → −4.2 |
| lead hook | 20.3% | 32.2% | 27.0% | −6.7 → +5.2 |
| rear hook | 19.3% | 17.1% | 13.0% | +6.3 → +4.1 |
| lead uppercut | 14.5% | **2.4%** | 3.0% | +11.5 → **−0.6** |
| rear uppercut | 13.7% | **4.3%** | 4.0% | +9.7 → **+0.3** |

**Total absolute error 57.9 → 22.2 points — 62% closer.** The uppercuts land almost exactly. The jab more than halves
its error but is still 8 points short, and the lead hook overshoots by 5.

**AND THE THROW COUNT MOVED — 4,900 → 5,243 beats.** Changing which technique is thrown changes damage, stamina and
bout length, so this is not an identity-except-the-mix change. The mix above is a share *within* the six and is not
biased by it, but the fight itself is a different fight. That is why the switch is off by default and why turning it on
is a full re-baseline.

## PART 2 — WHAT ELSE IS MISSING

Method: **every place the engine infers a technique's property from its id or name string is a field the catalogue
should carry.** Three such heuristics exist, all in `FightStance.gd`.

### Field coverage across the 304 throwable striking nodes

| field | present | |
|---|---:|---:|
| `role`, `phases`, `effects`, `range_delta`, `kind`, `tier`, `branch`, `requires` | 304 | 100% |
| `range_band` | 300 | 98.7% |
| `grade` | 227 | 74.7% |
| `target_region` | 167 | 54.9% |
| **`usage`** | **6** | **2.0%** |
| **`limb`** | **0** | **0%** |
| **`technique_class`** | **0** | **0%** |
| **`commit_s`** | **0** | **0%** |
| **`clip_role`** | **0** | **0%** |

*(the four nodes without `range_band` are all ground-phase — `bjj_submission_chain`, `bjj_posture_break`,
`mma_guard_gnp`, `mma_elbow_gnp`. Bandless is correct on the floor and the stance filter catches them. Not a defect.)*

### 1. `limb` — MISSING, and guessed for 13.8% of nodes

`FightStance.family` matches `JAB_MARKERS` and `REAR_HAND_MARKERS` against the id and name. **42 of 304 nodes (13.8%)
get a hand named; the other 262 emit none** and `FightStageDirector.hand_for` falls back to **tick parity** — even or
odd. **No kick ever names a leg at all.** Measured in S4e: the engine names the hand on 17–25% of throws.

### 2. `technique_class` — MISSING, and the guess is demonstrably wrong

`FightStance.is_kick` matches `KICK_MARKERS` against the id and name. Checked against the catalogue:

- **`muay_thai_mat_wiang_klap` — "Mat Wiang Klap (Spinning Backfist)" — is classified a KICK**, on the marker `spin`.
  It is a punch.
- **Every one of the 20 muay thai knees is classified a kick**, on the marker `knee`. `is_kick` drives `stance_family`,
  so a knee is handed the open-stance draw bonus U18 D3 measured for a *kick*.
- `karate_kizami_gyaku` — "Kizami-zuki, Gyaku-zuki", a lead punch **then** a rear punch — is classified lead-hand only,
  because `kizami` matches first. Its rear half is invisible.
- `karate_kizami_maegeri` — "Lead Front Snap Combo", a lead punch into a **front kick** — same: the kick half vanishes.

### 3. `commit_s` — MISSING, and a single constant stands in

`FightCommitment.COMMIT_S := 0.267` commits **every** technique for the same time — a jab and a spinning back kick
alike. **A documented source already exists in our own research**: Stanley, Thomson, Smith & Lamb (2018, 3D kinetics of
six maximal punches, via J21) found the six named punches **differ** in delivery time — jab shortest at **405 ± 150
ms**, lead hook the highest peak fist velocity. J21's own line: *"Named techniques are not interchangeable physics."*

### 4. `clip_role` — MISSING, and the presenter binds by ROLE

`FightClipBinding.clip_for(role)` takes a **role**, not a technique id. Every `strike_head` plays the same clip whether
the engine chose a jab, a cross or an uppercut. The engine now names the technique; the room still cannot show it.

## RECOMMENDED ORDER

1. **`usage`** — done here for boxing's six. Every other discipline needs its own study, and **only boxing's exists**
   (S4g established that no per-technique frequency is published for muay thai, kickboxing or MMA in our research).
2. **`technique_class`** — the cheapest real win. It is authorable from the catalogue's own names without inventing a
   measurement, it replaces a heuristic that is provably wrong, and nothing downstream needs a study to consume it.
3. **`limb`** — the same authoring pass, and it is what the room needs to stop tick-parity-ing 75–83% of throws.
4. **`commit_s`** — boxing's six are documented (Stanley 2018); everything else would be invented, so it waits.
5. **`clip_role`** — gated on the clip library having per-technique clips at all, which it does not.

## PART 3 — `technique_class` AND `limb`, AUTHORED (the recommended order, followed)

**293 of 304** throwable striking nodes now carry `match.technique_class`; **64** carry `match.limb`.

Authored by an ORDERED classifier over each art's own vocabulary — Thai *khao* knee / *sok* elbow / *te* kick, Japanese
*-zuki* punch / *-geri* kick / *nukite* spear-hand, Korean *-chagi*, savate *fouetté* kick vs *direct* punch — not by
the substring markers that produced the bug. **The order is the whole point**: elbow before knee before punch before
kick, so a Spinning Backfist is a punch even though it spins.

Two rules come from the node's OWN data rather than its name:
- **`kind == "sequence"` → `combination`.** The catalogue already says which nodes are chains; reading the field beats
  pattern-matching the name for "combo".
- **No effect containing "damage" → `movement`.** `boxing_step_in_out`, `circle_lead`, `angle_step`, `drawing` and
  `rhythm_change` land here, correctly — they are footwork, not strikes.

**ELEVEN NODES ARE LEFT WITHOUT THE FIELD** and that is the point: unnamed counters (`boxing_catch_counter`,
`muay_thai_pull_counter`), generic ground work (`mma_guard_gnp`, `mma_dirty_boxing`) and two weapon chains. **An absent
field is honest; a guessed one is the defect this replaces.**

| classes | punch 86 · kick 95 · combination 47 · knee 20 · elbow 19 · weapon 7 · movement 17 · sweep 2 |
|---|---|

### The four known bugs, fixed

| node | old `is_kick()` | now |
|---|---|---|
| `muay_thai_mat_wiang_klap` (Spinning Backfist) | **KICK** (marker `spin`) | **punch** |
| all 20 muay thai knees | **KICK** (marker `knee`) | **knee** |
| `karate_kizami_gyaku` (lead *then* rear) | **lead hand** only | **combination** |
| `muay_thai_horizontal_elbow` | not a kick | **elbow** |

### What it bought on emitted beats

| ruleset | hand named BEFORE | hand named NOW | limb (incl. legs) | class named |
|---|---:|---:|---:|---:|
| boxing | 24.7% | **61.2%** | 61.2% | **93.0%** |
| muay thai | 20.0% | **28.4%** | 31.5% | 77.4% |
| mma | 17.0% | **27.2%** | 33.7% | 83.4% |

**And the engine can now report its own strike composition by class for the first time** — muay thai over 8 seeded
bouts: kick 850, punch 1,020, knee 498, combination 387, movement 251, elbow 152. That is the shape a real muay thai
corpus could be compared against, and it did not exist before.

### A GATE MOVED, AND IT WAS THE GATE THAT WAS BEHIND

`fight_stance_test` S5 failed with **919 events named a hand its technique does not throw with**, e.g.
*"boxing_lead_uppercut/Lead Uppercut said lead wanted ''"*. The test recomputed the expected hand from the **id and
name marker lists** — the very heuristic this stage replaces — so the engine naming a Lead Uppercut's hand *correctly*
read as a disagreement.

**The test was not relaxed and the engine was not reverted.** Its reference moved to `match.limb` in the catalogue,
which is still INDEPENDENT of the engine's computation (read from the data file, not from the move dict
`move_from_node` builds), and it falls back to the markers for the 240 nodes carrying no `limb`. S1–S7 all PASS.

**Pin-neutral otherwise**: `stance_family` is untouched, so `draw_factor` and the seeded draw are unchanged.
`fight_realtime_test`, `fight_strike_band`, `grapple_adapter`, `fight_beat_adapter`, `fight_stance`, the technique
tests and `fight_moves` — **19 tests, 0 failures**.

## Open

1. The jab is still 8 points short and the lead hook overshoots by 5 with the prior on. **The prior is unconditional on
   band**, while a real jab is a long-range punch and a hook is a pocket punch — so band occupancy skews the delivered
   mix away from the authored frequencies. A band-conditioned prior is the obvious next question and has no study.
2. Turning `usage_prior` on is a full re-baseline: it moved the throw count 4,900 → 5,243 over 12 bouts.
3. `usage` covers 2.0% of throwable nodes. The other 98% are at 1.0 — honest, but it means the flat palette is still
   flat everywhere except six boxing punches.

## Re-running it

```
godot --headless --path Godot --script tools/probe_usage_prior.gd -- seeds=12
```
