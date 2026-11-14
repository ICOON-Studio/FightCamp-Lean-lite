# KNOWBOTS3 Result: Knowledge with True Attribute Levels as Truth

Status: PROBE COMPLETE. Discipline: boxing.
Red Test: `tools/knowbots_probe.gd -> KNOWBOTS3 done`

## 1. What Changed from KNOWBOTS2
KNOWBOTS2 was VOID: the truth was `b["shape"]` (centred around 0), not attribute levels. Results came from
`b["rating"]` which WorldGen rolls independently of shape. Flops compared shown centre (~0-10) with true_rating (~45-70).

KNOWBOTS3 fixes:
1. TRUTH = `AttrGen.attrs_of(b)` - the boxer's real attribute LEVELS (level + shape + age wear).
2. Print correlation of truth's attribute mean with b["rating"]: must be > 0.5.
3. ORACLE bot: signs the prospect with highest TRUE rating, pays nothing. Instrument ceiling.
4. FLOP: signed boxer's TRUE attribute mean is 5+ under shown centre (same scale now).

## 2. Results (60 Worlds, 4 Years Each)
| Bot | Top-10 | Titles | Reads Paid | Avg Cash | Flops |
| :--- | :---: | :---: | :---: | :---: | :---: |
| **ORACLE** | **101** | 37 | $0 | $91503 | 6 |
| **READER** | **93** | 46 | $634100 | $77765 | **0** |
| BLIND | 87 | 38 | $0 | $87749 | 20 |
| BAD SIGNER | 40 | 16 | $0 | $69617 | 2 |

## 3. Sensitivity (Doubled Start Half-Ranges)
| Bot | Top-10 | Titles | Reads Paid | Avg Cash | Flops |
| :--- | :---: | :---: | :---: | :---: | :---: |
| **READER** | **91** | 35 | $610350 | $76855 | **14** |
| BLIND | 83 | 33 | $0 | $85177 | 155 |
| BAD SIGNER | 44 | 18 | $0 | $69916 | 36 |

## 4. Correlations
- Hype-truth correlation: -0.0113 (must be within +-0.1)
- Sensitivity correlation: -0.0137
- Truth-rating correlation: 0.8042 (must be > 0.5)

## 5. Pass Line
- ORACLE - BLIND = +14 (need >= +8): PASS
- Control: BAD SIGNER (40) < BLIND (87): PASS
- INSTRUMENT: ok
- READER - BLIND = +6 (need >= +5): PASS
- READER share of ORACLE gap: 42.9%
- Sensitivity: READER - BLIND = +8

## 6. Timing
- Pilot (4 worlds): 29.01 s
- Projected 60 worlds x2: 870.33 s (14.51 min)

## 7. PR Result Line
`RESULT: tools/knowbots_probe.gd -> instrument=ok oracle_minus_blind=14 reader_minus_blind=6 pass=yes sensitivity=8`
