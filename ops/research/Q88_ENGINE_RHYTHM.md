## DECISIONS

| merge_s | active mean | active SD | inactive mean | inactive SD | long (>4s) mean | long / round | actions/min |
|---------|-------------|-----------|---------------|-------------|-----------------|--------------|-------------|
| 0.3 | 0.25 s | 0.21 s | 1.91 s | 1.98 s | 6.37 s | 14.53 | 90.05 |
| 0.5 | 0.45 s | 0.36 s | 2.50 s | 2.01 s | 6.37 s | 14.53 | 90.05 |
| 1.0 | 0.59 s | 0.52 s | 2.75 s | 2.02 s | 6.37 s | 14.53 | 90.05 |
| **JPES 2016** | **1.2 s** | **0.8 s** | **2.3 s** | **1.8 s** | **5.6 s** | **7.6** | — |

At MERGE_S = 0.3 (the realism test's value):

- Active mean 0.25 s - OUTSIDE the bound [0.8, 1.6].
- Inactive mean 1.91 s - INSIDE the bound [1.4, 3.2].

**Population:** out-boxer (A) (66.0 kg) vs pressure puncher (B) (66.5 kg), boxing, 30 seeds, 8 x 180 s rounds.

**Largest gap vs JPES 2016:** active mean (0.25 s engine vs 1.20 s JPES, delta -0.95 s).

## EXTREME INACTIVE SPELLS (MERGE_S = 0.3)

**Three longest:**

| seed | round | t_s (start) | duration (s) |
|------|-------|-------------|-------------|
| 905 | 2 | 595.70 | 23.40 |
| 924 | 1 | 125.90 | 20.80 |
| 920 | 2 | 471.50 | 19.50 |

**Three shortest (positive gaps):**

| seed | round | t_s (start) | duration (s) |
|------|-------|-------------|-------------|
| 907 | 2 | 366.30 | 0.20 |
| 900 | 2 | 462.90 | 0.20 |
| 900 | 1 | 267.10 | 0.20 |

