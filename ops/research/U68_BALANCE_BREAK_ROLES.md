# U68 — Balance-break put-down role adjudication

Surveyed **33** nodes carrying `balance_break`, `sweep`, `counter_throw`,
`throw_damage`, `counter_takedown`, or `strike_to_throw` whose role was not
already `takedown`. Promoted **12** to `takedown`. **Rule 3: yes** (documented
below; not wired into `derive_technique_roles.py` — task forbids script edits).

## Rule 3 — standing/clinch put-downs

A node must carry `role: takedown` when **all** of:

1. `kind` is not `skill` (skills are capabilities, never thrown).
2. `match.phases` includes `standing` and/or `clinch` (ground-only sweeps stay
   `control` — they reverse position, they do not initiate a takedown).
3. The **dominant** effect (single strongest by absolute value, no tie) is one of:
   - `sweep`, `throw_damage`, `counter_takedown`, `counter_throw` — any kind
     except `skill`; or
   - `balance_break` with magnitude **≥ 8** when `clinch` is in phases, or
     **≥ 10** when `standing` is in phases — **`kind: move` only** (excludes
     phase-transition sequences like `silat_offbalance_chain`).

**Deliberately excluded:** `strike_to_throw` (adaptation/chain sequences),
secondary throw keys when another effect dominates (teep, catch-and-strike),
`kind: skill` (`sambo_counter_throw`, `kickboxing_clinch_knee_sweep`).

**Min magnitude promoted:** `balance_break: 8` (`muay_thai_dumps_offbalance`);
lowest throw-family promotion `counter_takedown: 8` (sanda sweep counter, mma
kick catch slam, capoeira negativa sweep).

## Muay thai (4 promoted)

| node | was | now | reasoning |
| --- | --- | --- | --- |
| `muay_thai_clinch_dump` | control | takedown | Clinch turn-and-dump puts opponent on canvas |
| `muay_thai_dumps_offbalance` | control | takedown | Off-balance dump — same physics as master |
| `muay_thai_catch_sweep` | control | takedown | Catch-and-sweep in clinch is a put-down |
| `muay_thai_chapko_head_sweep` | control | takedown | Head sweep; sibling `chapko_sweep_throw` already takedown |

**Left alone:** teep / thip khang / khao ti (balance_break ≤ 6, stagger not
dump); chapko khang (clinch control); catch kick / catch strike (guard or
counter_strike dominant).

## Judo (1 promoted)

| node | was | now | reasoning |
| --- | --- | --- | --- |
| `judo_uranage_counter` | damage | takedown | Ura-nage counter-throw lands opponent on back |

## Sanda (2 promoted)

| node | was | now | reasoning |
| --- | --- | --- | --- |
| `sanda_catch_dump` | counter | takedown | Kick catch and dump — counter_takedown dominant |
| `sanda_sweep_counter` | counter | takedown | Low sweep counter puts opponent down |

## Sambo (1 promoted)

| node | was | now | reasoning |
| --- | --- | --- | --- |
| `sambo_counter_hip_toss` | counter | takedown | Counter hip toss is a throw to ground |

**Left alone:** `sambo_counter_throw` (`kind: skill`); `sambo_strike_bodylock`
(`adaptation` sequence, strike_to_throw dominant).

## Capoeira (1 promoted)

| node | was | now | reasoning |
| --- | --- | --- | --- |
| `capoeira_negativa_sweep` | counter | takedown | Negativa into rasteira sweep — same family as `rasteira` |

## Pencak silat (2 promoted)

| node | was | now | reasoning |
| --- | --- | --- | --- |
| `silat_catch_dump` | counter | takedown | Kick catch and jatuhan (takedown) |
| `pencak_silat_catch_kick_takedown` | counter | takedown | Name and counter_takedown dominant |

**Left alone:** `silat_offbalance_chain` (sequence; balance_break beats takedown
effect — phase-transition chain stays control).

## MMA (1 promoted)

| node | was | now | reasoning |
| --- | --- | --- | --- |
| `mma_kick_catch_slam` | counter | takedown | Kick catch to slam |

## Zero-change trees

**Kickboxing** (2 surveyed): catch-and-return is counter_open-dominant; clinch
knee sweep is a skill.

**BJJ** (8 surveyed): ground-phase sweeps — control role correct.

**Karate** (1 surveyed): ashi-barai gyaku combo is a damage sequence.
