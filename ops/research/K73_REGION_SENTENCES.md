# K73_REGION_SENTENCES.md

**Job:** The sentence the corner says the moment a region **crosses** an M23 boundary between rounds.
**Not the job:** Row geometry (G64/G65), state colours/thresholds (M23), post-fight WHY (K71), full corner card (K72).

**M23 thresholds (settled — do not retune):** `fine >55` · `hurt ≤55` · `critical ≤35` · `doctor ≤15`.

**Budget:** corner line ≤**60** chars · alternate chip ≤**14** chars. Counts in `(n)`.

**Engine keys (for labels):** `body_condition.{head_neck|torso_core|left_arm|right_arm|left_leg|right_leg}` (0–100). Crossing = last stool value vs this stool value against M23 cuts. Named M23 events are **not** a separate engine object today; `body_condition_band_transition` uses BodyReadiness green/amber/red, not fine/hurt/critical/doctor — builders map ints → M23. Doctor **fight-end** is wired for **head only** (`DOCTOR_STOPPAGE_HEAD_CONDITION_THRESHOLD` / head ≤15). Legs feed `_mobility_factor`. Stool can raise ints via `Impact.corner_recovery` (~4/min × conditioning scale).

---

## Three lines first

1. **Crossing that changes the fight most:** HEAD `critical→doctor`. That is the towel conversation, not another damage tip.
2. **Sentence I would fight hardest to keep:** `Towel is on the table — his head is doctor-bad.` (47)
3. **Least sure:** Non-HEAD `→doctor` lines. Values can hit ≤15 on torso/arms/legs (**COMPUTED** ints), but only HEAD auto-triggers a doctor stoppage today. Those lines must not sound like the fight already ended.

---

## Labels

| Label | Meaning |
|---|---|
| **COMPUTED** | Asserts something `body_condition` (and/or wired stoppage / mobility / stool recovery) can know today |
| **NOT COMPUTED** | Asserts a behaviour or fight-end the engine does not model for that region |
| **INFERENCE** | Design rule for when to fire the line, not an engine claim |

Every row: **corner line** · **chip** · **label** · char counts.

---

## 1. DOWNWARD — 18 crossings


### HEAD (`head_neck`)

| Crossing | Corner line | (n) | Chip | (n) | Label |
|---|---|---:|---|---:|---|
| fine→hurt | Chin is catching — tuck up, make him miss. | 42 | COVER UP | 8 | **COMPUTED** — body_condition.head_neck crossed ≤55 |
| hurt→critical | Head is in real trouble — stay long, don't trade. | 49 | STAY LONG | 9 | **COMPUTED** — crossed ≤35; head wear is live |
| critical→doctor | Towel is on the table — his head is doctor-bad. | 47 | TOWEL CALL | 10 | **COMPUTED** — ≤15 and head doctor-stop is wired. HEAD ≠ others. |

### TORSO (`torso_core`)

| Crossing | Corner line | (n) | Chip | (n) | Label |
|---|---|---:|---|---:|---|
| fine→hurt | Body is going soft — don't eat free downstairs. | 47 | CLINCH UP | 9 | **COMPUTED** — torso ≤55; torso hits tank |
| hurt→critical | Ribs are cooked — elbows in, stop the digging. | 46 | COVER BODY | 10 | **COMPUTED** — ≤35 |
| critical→doctor | Body is doctor-shot — towel talk is fair here. | 46 | TOWEL TALK | 10 | Value **COMPUTED** (≤15). Auto doctor-stop **NOT COMPUTED** (head-only today). Manager towel still valid. |

### L ARM (`left_arm`)

| Crossing | Corner line | (n) | Chip | (n) | Label |
|---|---|---:|---|---:|---|
| fine→hurt | Left hand is wearing — jab shorter, don't hang it. | 50 | SHORT JAB | 9 | **COMPUTED** — arm ≤55 |
| hurt→critical | Left arm is heavy — guard tight, stop extending. | 48 | GUARD TIGHT | 11 | **COMPUTED** — ≤35 |
| critical→doctor | Left arm is doctor-bad — that hand is nearly done. | 50 | BAG IT | 6 | Value **COMPUTED**. Region doctor-stop **NOT COMPUTED**. |

### R ARM (`right_arm`)

| Crossing | Corner line | (n) | Chip | (n) | Label |
|---|---|---:|---|---:|---|
| fine→hurt | Right hand is wearing — don't wind up the power. | 48 | SHORTEN UP | 10 | **COMPUTED** — arm ≤55 |
| hurt→critical | Right arm is heavy — keep it home, stop reaching. | 49 | KEEP HOME | 9 | **COMPUTED** — ≤35 |
| critical→doctor | Right arm is doctor-bad — power hand is nearly done. | 52 | BAG IT | 6 | Value **COMPUTED**. Region doctor-stop **NOT COMPUTED**. |

### L LEG (`left_leg`)

| Crossing | Corner line | (n) | Chip | (n) | Label |
|---|---|---:|---|---:|---|
| fine→hurt | Left leg is soft — shorten the step, don't plant. | 49 | SHORT STEP | 10 | **COMPUTED** — leg ≤55; legs feed _mobility_factor |
| hurt→critical | Left leg is buckling — stay off that front foot. | 48 | STAY LIGHT | 10 | **COMPUTED** — ≤35 + mobility |
| critical→doctor | Left leg is doctor-shot — mobility is nearly gone. | 50 | HOLD SPACE | 10 | Value **COMPUTED**. Region doctor-stop **NOT COMPUTED**. Mobility effect still live. |

### R LEG (`right_leg`)

| Crossing | Corner line | (n) | Chip | (n) | Label |
|---|---|---:|---|---:|---|
| fine→hurt | Right leg is soft — shorten the step, don't plant. | 50 | SHORT STEP | 10 | **COMPUTED** — same as L LEG |
| hurt→critical | Right leg is buckling — stay off that front foot. | 49 | STAY LIGHT | 10 | **COMPUTED** |
| critical→doctor | Right leg is doctor-shot — mobility is nearly gone. | 51 | HOLD SPACE | 10 | Value **COMPUTED**. Region doctor-stop **NOT COMPUTED**. |

---

## 2. UPWARD — recovering across a boundary

Stool recovery (`Impact.corner_recovery` / `CORNER_RECOVERY_PER_MIN`) **can** raise ints between rounds, so an upward band cross is possible. One line per boundary (not per region), plus one HEAD exception.

| Crossing | Corner line | (n) | Chip | (n) | Label |
|---|---|---:|---|---:|---|

| doctor→critical | He's off doctor on that spot — still treat it soft. | 51 | EASY DOES | 9 | **COMPUTED** if stool lift crosses ≤15→>15. Not a clearance. |
| critical→hurt | That spot cooled a band — don't go hunting with it. | 51 | STAY PATIENT | 12 | **COMPUTED** if ≤35→>35 |
| hurt→fine | That region's quiet again — don't reopen it cheap. | 50 | KEEP CLEAN | 10 | **COMPUTED** if ≤55→>55 |
| HEAD doctor→critical (own) | Head climbed off doctor — still no trading. | 43 | NO TRADE | 8 | **COMPUTED** + HEAD-special: leaving doctor ≠ safe chin |

**INFERENCE:** Fire an upward line only when the int actually crossed the M23 cut on the stool. Do not congratulate a 1-point tick inside the same band.

**NOT COMPUTED:** Promising the region is "healed," "cleared," or fight-safe. Recovery is partial credit, not a medical sign-off.

---

## 3. What these lines must never do

1. Read the HUD number aloud ("left leg at 34").
2. Name a move the manager cannot pick.
3. Promise Layer-A speech changes the sim (K72). Chips map to **wired** G64 paces / plan shouts only when those exist; otherwise they are speech tokens.
4. Treat non-HEAD `doctor` as an automatic stoppage — only HEAD has that wire today.
5. Specify pixels, row heights, or type sizes (G65 owns the box).

---

## 4. Builder wiring note (honesty)

| Need | Today |
|---|---|
| Six region ints | **COMPUTED** — `body_condition` |
| Detect M23 cross between stools | **COMPUTED** — compare ints to ≤55 / ≤35 / ≤15 |
| Named fine/hurt/critical/doctor event object | **NOT COMPUTED** — `body_condition_band_transition` is green/amber/red |
| HEAD ≤15 → doctor stoppage path | **COMPUTED** |
| Non-HEAD ≤15 → doctor stoppage path | **NOT COMPUTED** |
| Legs hurt mobility | **COMPUTED** — `_mobility_factor` |
| Stool raises region ints | **COMPUTED** — corner recovery |
| Corner sentence changes next-round targeting | **NOT COMPUTED** (speech-only unless a wired pace/chip is chosen) |

---

## 5. Acceptance

1. 18 downward rows + upward set present.
2. Every corner line ≤60; every chip ≤14.
3. No HUD numbers in speech.
4. HEAD `critical→doctor` is the towel conversation.
5. Every line labelled COMPUTED / NOT COMPUTED (with the non-HEAD doctor caveat called out).
6. No geometry. No threshold retune.

---

**K73 complete.** The words for the crossing moment; G65's box and M23's states already exist.

## Sources

1. M23_REGION_READOUT.md — fine/hurt/critical/doctor + ≤55/≤35/≤15.
2. G65_BETWEEN_ROUND.md — 60-char recommended line, 14-char alternate chips.
3. FightSimulation.gd — BODY_REGIONS, body_condition, `_mobility_factor`, head doctor-stop threshold.
4. ImpactModel.gd — corner_recovery.
5. K72_CORNER_CARD.md — speech vs wired pace honesty.
