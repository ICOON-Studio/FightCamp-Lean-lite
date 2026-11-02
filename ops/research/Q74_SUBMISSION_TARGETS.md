# Q74 — Submission Target-Region Census

## Summary

The engine's region resolver (`FightSimulation._technique_target_region`, lines 2156-2186)
sums absolute effect-key weights by substring: a key containing `head` maps to `head_neck`,
`leg` to `leg`, `body`/`liver`/`torso` to `torso_core`, `arm`/`shoulder` to `arm`. When no
key matches, `_pick_target_region` (line 2226) falls back to a pure random roll for
submissions: 40%% left arm, 40%% right arm, 10%% left leg, 10%% right leg. The region is
written onto the event as `target_body_region`, and `RingStagePanel.gd:465` prints it
upper-cased to the player.

**submissions=56  neck=27  arm=16  leg=11  body=1  unspecified=1  mismatches=34**

That is, 34 of 56 submissions (61%%) are announced to the player as attacking the wrong
body region — most commonly a choke shown as "LEFT ARM" or "RIGHT ARM".

## Counts per discipline

| Discipline            | Total | Neck | Arm | Leg | Body | Unspecified |
|-----------------------|------:|-----:|----:|----:|-----:|------------:|
| brazilian_jiu_jitsu   |    27 |   15 |   6 |   5 |    0 |           0 |
| judo                  |    22 |   11 |  10 |   0 |    1 |           0 |
| sambo                 |     5 |    0 |   0 |   5 |    0 |           0 |
| mma                   |     2 |    0 |   1 |   0 |    0 |           1 |

## Counts per family

| Family        | Count | Mechanisms                               |
|---------------|------:|------------------------------------------|
| neck (choke)  |    27 | choke (27)                               |
| arm (armlock) |    16 | joint_lock (15), compression (1)         |
| leg (leglock) |    11 | joint_lock (10), compression (1)         |
| body (trunk)  |     1 | compression (1)                          |
| unspecified   |     1 | generic (1)                              |

## Mismatches (34)

33 of the 34 mismatches produce `random_role_roll` — the resolver finds no locational
effect key and falls through to the random roll (40%% left arm, 40%% right arm, 10%% left
leg, 10%% right leg). The player sees "LEFT ARM" or "RIGHT ARM" 80%% of the time for
every one of these.

### Chokes shown as arm attacks (the headline bug — 26 rows)

26 chokes whose effect keys carry no `head`/`arm`/`leg`/`body` substring fall through to
the random roll. The player sees "LEFT ARM" or "RIGHT ARM" for a choke 80%% of the time.
Worst cases:

- **Rear Naked Choke** (`bjj_rnc`) — the most iconic submission in grappling, shown as
  an arm attack 4-in-5 times.
- **Triangle Choke** (`bjj_triangle`) — same bug.
- **Arm Triangle / Kata-gatame** (`bjj_arm_triangle`) — the id trap: the id contains "arm"
  but the technique is a choke. The resolver does not match on id, so this falls through
  like every other choke, but a future fix that naively reads the id would misclassify it.
- **Guillotine Choke** (`bjj_guillotine`) — the ONE choke that DOES match, because its
  `front_headlock_open` key contains "head", giving `head_neck`. This is the only choke
  the resolver places correctly (matches=true).
- All 11 Kodokan `-jime` chokes (hadaka-jime, okuri-eri-jime, sankaku-jime, cross-collar
  variants, etc.) fall through identically.

### Armlocks with no locational key (3 rows)

- **Omoplata** (`bjj_omoplata`) — a shoulder lock; effects are `submission` + `sweep_threat`,
  neither contains `arm` or `shoulder`. Random roll.
- **Wrist Lock** (`bjj_wrist_lock`) — effects are `submission` + `submission_setup`. Random roll.
- **Mount Strikes to Armbar** (`mma_mount_finish`) — effects are `damage_to_submission` +
  `finish_chance`. Random roll.

### Leg locks with no locational key (2 rows)

- **Kneebar** (`sambo_kneebar`) — effects are `submission` + `scramble_attack`. Random roll.
- **Rolling Kneebar Entry** (`sambo_rolling_kneebar`) — effects are `submission` + `surprise`.
  Random roll.

### Body compression with no locational key (1 row)

- **Do-jime** (`judo_dojime`) — a torso compression; effects are `submission` +
  `submission_setup`. Random roll.

### Generic (1 row)

- **Submission-Strike Threat** (`mma_submission_threat_gnp`) — unspecified target; random
  roll. No correct region exists.

### Wrong engine region (1 row, not random)

- **Ashi-garami** (`judo_ashigarami`) — a leg entanglement, but the catalogue carries an
  `arm_isolation` effect key. The resolver reads "arm" and returns `arm`. The engine is
  wrong because the catalogue data is wrong: ashi-garami attacks the legs, not the arms.

## Catalogue errors flagged (not fixed here)

1. **`judo_ashigarami`** — effect key `arm_isolation` is incorrect. Ashi-garami (Kodokan:
   leg entanglement) attacks the legs. The key should be `leg_attack` or removed.
2. **`bjj_arm_triangle`** — id contains "arm" but the technique is a choke (kata-gatame).
   The id is misleading; the name correctly says "Choke". No effect-key error, but the id
   is a future trap for any substring-based classifier (cf. Q70's 72 missed kicks).

## Recommended fix — smallest authored data change

Add a `target_region` field to each submission node in `technique_catalog.json`, valued
`head_neck`, `torso_core`, `arm`, or `leg`. Then modify
`FightSimulation._technique_target_region` (line 2156) to check for this field first:

```gdscript
var explicit = technique.get("target_region", "")
if not explicit.is_empty():
    return explicit
```

This touches two things:

1. **`technique_catalog.json`** — add `"target_region": "..."` to all 56 submission nodes
   (27 → `head_neck`, 16 → `arm`, 11 → `leg`, 1 → `torso_core`, 1 omitted as unspecified).
2. **`FightSimulation._technique_target_region`** — 3 lines at the top of the function
   (read the explicit field, return it if present, fall through to existing logic).

This is smaller than adding locational effect keys to every node (which would require
inventing weights and would interact with the plan-bias multiplier in unpredictable ways),
and it does not require renaming any ids. The `target_region` field is authoritative for
submissions while leaving the existing effect-key resolver untouched for strikes, takedowns
and damage actions.

## Anchor verification

The following unambiguous anchors were checked against Kodokan / IBJJF / FIAS nomenclature:

| ID                              | Expected family | Result |
|---------------------------------|-----------------|--------|
| `bjj_rnc`                       | neck            | PASS   |
| `bjj_triangle`                  | neck            | PASS   |
| `bjj_guillotine`                | neck            | PASS   |
| `bjj_arm_triangle`              | neck            | PASS   |
| `bjj_armbar`                    | arm             | PASS   |
| `bjj_kimura`                    | arm             | PASS   |
| `bjj_americana`                 | arm             | PASS   |
| `brazilian_jiu_jitsu_heel_hook` | leg             | PASS   |
| `bjj_kneebar`                   | leg             | PASS   |
| `sambo_straight_ankle`          | leg             | PASS   |
| `judo_hadakajime`               | neck            | PASS   |
| `judo_okurierijime`             | neck            | PASS   |
| `judo_jujigatame`               | arm             | PASS   |
| `judo_udegarami`                | arm             | PASS   |
| `judo_udehishigisankakugatame`  | arm             | PASS   |
| `judo_dojime`                   | body            | PASS   |
| `mma_mount_finish`              | arm             | PASS   |

The two substring traps both pass: `bjj_arm_triangle` is classified as `neck` (choke,
despite "arm" in the id) and `judo_udehishigisankakugatame` is classified as `arm`
(armlock, despite "sankaku" in the id).
