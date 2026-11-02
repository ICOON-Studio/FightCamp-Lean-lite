# Q44 — THE PUBLISHED UNITS

Agent: Qwen. Model: medium. measured-at=18585d6

Harness: `Godot/tools/measure_r102.gd`. 40 bouts per ruleset, Q34's fighter
pair (R101 A: reach 183 / tech 62 / def 55; R101 B: reach 176 / tech 48 /
def 58). Real rulesets loaded from `combat_rulesets.json`.

---

## PART 1 — THE PUBLISHED NUMBERS

### Str. Def. (MMA-style: 1 − sig_landed / sig_attempts)

| ruleset    | Str. Def. | sig_landed | sig_attempts | note                          |
|------------|-----------|------------|--------------|-------------------------------|
| boxing     | 53.0%     | 21,989     | 46,799       | all impacts are significant   |
| mma        | 52.9%     | 15,936     | 33,828       | all impacts are significant   |
| kickboxing | 53.0%     | 9,800      | 20,848       | all impacts are significant   |
| muay_thai  | 53.2%     | 14,077     | 30,073       | 5,839 non-sig (clinch/ground) |

G54 §7 typical roster band: 50–62%. All four rulesets land inside it.

### Connect % (boxing-style: landed / total impacts)

| ruleset    | connect% | landed  | impacts |
|------------|----------|---------|---------|
| boxing     | 47.0%    | 21,989  | 46,799  |
| mma        | 47.1%    | 15,936  | 33,828  |
| kickboxing | 47.0%    | 9,800   | 20,848  |
| muay_thai  | 46.6%    | 16,747  | 35,912  |

G54 §7 CompuBox league band: ~30–35%. Engine is 12–17pp above it.

### Why boxing/mma/kickboxing have sig_attempts == impacts

`FightMoves.is_significant` returns true when `position == "distance"` (all
standing strikes) or when role is "damage"/"counter". Boxing, kickboxing and
the standing portion of MMA produce zero CLINCH/GROUND impacts, so every
strike is at distance position and therefore significant. Muay thai has 1,778
CLINCH + 4,061 GROUND impacts whose roles are not damage/counter, producing
5,839 non-significant strikes.

### SApM (significant attempts absorbed per minute)

| ruleset    | SApM A  | SApM B  | absorbed_a | absorbed_b | total_min |
|------------|---------|---------|------------|------------|-----------|
| boxing     | 22.35   | 20.88   | 24,191     | 22,608     | 1,082.6   |
| mma        | 28.71   | 26.72   | 17,521     | 16,307     | 610.3     |
| kickboxing | 24.98   | 23.73   | 10,692     | 10,156     | 428.0     |
| muay_thai  | 19.32   | 18.04   | 15,553     | 14,520     | 805.0     |

G54 §7: elite SApM is often < 2.5; 4+ is a beating. Every fighter in every
ruleset is well above 4.

### Six-word contact mix

| ruleset    | clean  | glancing | absorbed | blocked | slipped | missed |
|------------|--------|----------|----------|---------|---------|--------|
| boxing     | 25.7%  | 21.3%    | 10.1%    | 9.4%    | 8.6%    | 24.9%  |
| mma        | 25.5%  | 21.6%    | 10.0%    | 9.5%    | 8.2%    | 25.2%  |
| kickboxing | 25.8%  | 21.2%    | 10.1%    | 9.3%    | 8.4%    | 25.1%  |
| muay_thai  | 25.6%  | 21.1%    | 10.5%    | 9.2%    | 8.6%    | 25.0%  |

LANDED = clean + glancing. NOT-LANDED = absorbed + blocked + slipped + missed.
The mix is remarkably stable across rulesets (±0.7pp on every word).

### Band distribution

| ruleset    | LONG  | MID   | POCKET | CLINCH | GROUND |
|------------|-------|-------|--------|--------|--------|
| boxing     | 16,821| 14,935| 15,043 | 0      | 0      |
| mma        | 9,783 | 8,660 | 8,509  | 2,234  | 4,642  |
| kickboxing | 7,344 | 6,706 | 6,798  | 0      | 0      |
| muay_thai  | 10,424| 9,595 | 10,054 | 1,778  | 4,061  |

---

## PART 2 — THE TWO SWEEPS (MMA, 10 bouts/level)

### SWEEP A — attacker technique (A defense held at 50)

| tech | n    | clean  | glancing | absorbed | blocked | slipped | missed |
|------|------|--------|----------|----------|---------|---------|--------|
| 20   | 4,394| 17.6%  | 23.4%    | 7.7%     | 16.2%   | 9.3%    | 25.8%  |
| 30   | 4,631| 20.6%  | 24.0%    | 8.0%     | 14.0%   | 9.1%    | 24.2%  |
| 40   | 4,593| 21.8%  | 22.4%    | 9.4%     | 12.6%   | 8.7%    | 25.1%  |
| 50   | 3,743| 22.8%  | 22.7%    | 9.9%     | 10.8%   | 9.0%    | 24.8%  |
| 60   | 3,989| 27.0%  | 21.6%    | 10.0%    | 8.2%    | 8.6%    | 24.6%  |
| 70   | 3,740| 28.9%  | 20.7%    | 10.9%    | 6.6%    | 8.2%    | 24.7%  |
| 80   | 4,069| 30.2%  | 20.3%    | 11.7%    | 5.1%    | 8.0%    | 24.7%  |
| 90   | 3,930| 33.2%  | 18.7%    | 13.5%    | 2.8%    | 7.5%    | 24.4%  |

**Delta (90 − 20):** clean=+15.6pp, glancing=−4.7pp, absorbed=+5.8pp,
blocked=−13.3pp, slipped=−1.9pp, missed=−1.5pp.

### SWEEP B — defender defense (A technique held at 50)

| def | n    | clean  | glancing | absorbed | blocked | slipped | missed |
|-----|------|--------|----------|----------|---------|---------|--------|
| 20  | 4,235| 28.2%  | 25.3%    | 5.2%     | 11.1%   | 5.2%    | 25.1%  |
| 30  | 4,734| 27.2%  | 24.7%    | 6.7%     | 10.4%   | 6.6%    | 24.4%  |
| 40  | 3,319| 26.3%  | 22.4%    | 7.4%     | 10.8%   | 7.1%    | 26.0%  |
| 50  | 3,706| 24.9%  | 22.3%    | 9.3%     | 9.1%    | 9.0%    | 25.5%  |
| 60  | 4,231| 24.7%  | 21.6%    | 10.4%    | 10.7%   | 8.6%    | 24.0%  |
| 70  | 3,903| 23.1%  | 20.7%    | 11.4%    | 10.5%   | 9.2%    | 25.2%  |
| 80  | 4,036| 21.9%  | 19.3%    | 11.7%    | 10.2%   | 10.7%   | 26.2%  |
| 90  | 4,238| 20.3%  | 18.0%    | 13.5%    | 10.9%   | 12.4%   | 24.9%  |

**Delta (90 − 20):** clean=−8.0pp, glancing=−7.3pp, absorbed=+8.3pp,
blocked=−0.1pp, slipped=+7.2pp, missed=−0.2pp.

### The two sweeps move different words

- **Technique** (Sweep A) primarily moves **blocked ↔ clean** (−13.3pp /
  +15.6pp). The attacker's skill converts blocks into clean landings, with a
  secondary glancing → clean → absorbed cascade.
- **Defense** (Sweep B) primarily moves **clean/glancing → absorbed/slipped**
  (−8.0pp / −7.3pp / +8.3pp / +7.2pp). The defender's skill degrades clean
  blows to absorbed and glancing blows to slipped. Blocked barely moves
  (−0.1pp).
- **missed** barely moves in either sweep (−1.5pp / −0.2pp). The miss rate is
  set by the contact ladder's base threshold, not by technique or defense.

The two channels read different inputs and produce different effects on the
contact word distribution.

---

## PART 3 — THE RANGE-FIT BEFORE-PICTURE

### Scaled distance distribution (D = separation / arm_length)

| ruleset    | n     | median | P10  | P25  | P75  | P90  |
|------------|-------|--------|------|------|------|------|
| boxing     | 46,799| 1.06   | 0.50 | 0.78 | 1.25 | 1.34 |
| mma        | 33,828| 1.06   | 0.52 | 0.76 | 1.24 | 1.34 |
| kickboxing | 20,848| 1.06   | 0.49 | 0.77 | 1.24 | 1.34 |
| muay_thai  | 35,912| 1.06   | 0.50 | 0.76 | 1.24 | 1.34 |

### Standing band shares (of total impacts, stance-aware)

| ruleset    | LONG   | MID    | POCKET | CLINCH+GROUND |
|------------|--------|--------|--------|---------------|
| boxing     | 35.9%  | 31.9%  | 32.1%  | 0%            |
| mma        | 28.9%  | 25.6%  | 25.2%  | 20.3%         |
| kickboxing | 35.2%  | 32.2%  | 32.6%  | 0%            |
| muay_thai  | 29.0%  | 26.7%  | 28.0%  | 16.3%         |

Median D = 1.06 across all four rulesets. J21 §1.1 (Hristovski 2006) says
boxers spend time at D ≈ 1.2 (jab-reach edge). Our median is inside that by
0.14 arm lengths.

Band thresholds: LONG ≥ 1.17, MID ≥ 0.88, POCKET < 0.88 (FightMoves.gd).
