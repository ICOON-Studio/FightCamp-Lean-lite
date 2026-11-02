# M24_GAS_INSTRUMENT.md

Maria Art Director · 2026-09-22 · art only — STATE and treatment; **no width/height/position** (G64 owns the box, 18 px numeral, 20 px ring)

Cage Desk + M22 tokens + M13 (HR ring, no stamina bar) + M23 (few stops, never hue-only, doctor ≠ redder red).

## Three lines

1. **Named stops: 3** on the ramp (`gas_fine` / `gas_working` / `gas_gassed`) plus **`gas_danger` as its own treatment** (towel-consideration class — not a fourth gradient stop).
2. **Fight hardest to keep:** the ring **fills toward danger** (tachometer), **never depletes like a reserve tank** — a depleting ring is a stamina bar bent round (G64/M13 refuse).
3. **Least sure:** exact BPM cut numbers — **INHERITED illustrative bands from M13** (`~<140` / `~<170` / `≥170`); engine / J20 / `FightHudRead` bind the live cuts. Swap numbers without changing treatments.

---

## DECISIONS

1. Ring = **fraction of the path to the danger ceiling** (fill rises as BPM rises), clockwise from 12 o’clock.
2. Numeral = primary read at 20 px; ring = zone backup + CVD second channel via **fill amount + hatch**.
3. **No continuous pulse** under a live clock — one-shot rim only when **crossing a stop upward**.
4. `gas_danger` = own class (hatch + weight + steady danger rim), not “gassed but redder.”
5. Never list at bottom.

---

## References (taken / refused)

| Source | Taken | Refused |
| --- | --- | --- |
| **Undisputed** (R85R / G64 cite) | BPM as **integer instrument**, not a second tank | Twin resource bars |
| **M13 fight screen** | GOOD/AMBER/BAD HR bands; ring + numeral; **no stamina bar** | Stamina/tank metaphor |
| **Cycling head-unit zone ring** (Garmin-class) | Small arc/ring as **zone toward red**, glanceable at tiny size | Full dashboard chrome |
| **Bedside HR monitor** | **Numeral is the truth**; ornament is secondary | Decorative waveform at 20 px (illegible) |

At **20 px**, bedside wins for the number; cycling-zone wins for the ring metaphor. Combined: big BPM + zone ring, not a bent bar.

---

## 1. THE STATES

Ramp = **3**. Danger = **own treatment**.

BPM bands below are **M13 illustrative** — engine binds exact cuts.

| State | BPM band (illus.) | Ring fill | Ring treatment | Numeral treatment | Manager read |
| --- | --- | --- | --- | --- | --- |
| `gas_fine` | below working cut (~&lt;140) | **25%** | solid `color_positive` | `color_text_secondary`, weight 500 | Fresh / ignore |
| `gas_working` | working band (~140–169) | **55%** | solid `color_warning` | `color_text`, weight 600 | Working — expected mid-fight |
| `gas_gassed` | redzone (~≥170, below danger) | **85%** | `color_negative` + **45° hatch** | `color_text`, weight 600 | Gassed — watch / pace |
| `gas_danger` | danger cut / exhaustion flag (engine) | **100%** | `color_negative` + hatch + **steady danger rim** (`color_negative`) | `color_text`, weight **700** | **Consider the towel** |

Ours and theirs: **same ramp** (identity is owner chrome elsewhere, not different gas metaphors).

---

## 2. THE RING

| Rule | Choice | Why the other misreads |
| --- | --- | --- |
| Direction | **Clockwise from 12** | Matches every small gauge; counter-clockwise is novelty with no gain at 20 px |
| Meaning | **Fill ↑ as BPM ↑** toward danger ceiling | **Deplete-as-reserve** = stamina bar bent round — G64 removed the bar on purpose; same lie, round shape |
| At fine | 25% positive solid | Empty ring looks “broken instrument” |
| At working | 55% warning solid | Mid fill = mid work |
| At gassed | 85% negative + hatch | Full-ish + hatch = severity without trusting hue |
| At danger | 100% + hatch + steady negative rim | Ceiling reached — qualitatively over |

Ring is **not** “remaining gas.” It is **how hot the engine is.**

---

## 3. THE SECOND CHANNEL (never hue-only)

| Channel | Carries | CVD read |
| --- | --- | --- |
| **Fill %** | Severity ladder 25/55/85/100 | Primary |
| **Hatch** | `gas_gassed` + `gas_danger` only | Dangerous class without red≠green |
| **Numeral weight** | 500 → 600 → 700 at danger | Weight reads when hue collapses |
| **Hue** | M22 positive / warning / negative | Trichromat backup only |

**Rule:** if hue fails, fill% + hatch + weight still order fine &lt; working &lt; gassed &lt; danger.

---

## 4. THE DANGER STATE

**`gas_danger` — own treatment, not a redder `gas_gassed`.**

| | Gassed | Danger |
| --- | --- | --- |
| Meaning | Bad cardio load; fight continues | Corner should **consider the towel** |
| Fill | 85% + hatch | 100% + hatch |
| Rim | none steady | **steady** `color_negative` rim (not pulsing) |
| Numeral | weight 600 | weight **700** |
| Trigger | BPM in redzone band | Engine danger/exhaustion cut (or BPM ≥ danger bind) |

Aviation analogue: yellow caution ≠ master caution. Same discipline as M23 `region_doctor`.

---

## 5. RIM TIMING

| Behaviour | Spec |
| --- | --- |
| Continuous pulse | **No** — under a live round clock a forever-pulse is noise and reads arcade |
| On **upward stop cross** (fine→working, working→gassed, gassed→danger) | One-shot rim `color_link` **200 ms** then off (M23 family) |
| While in `gas_danger` | **Steady** negative rim (treatment of the state, not a pulse rate) |
| Downward cross (recovery) | Fill slides **200 ms**; **no** celebration pulse |

---

## 6. NEVER

1. **Never a depleting “reserve” ring** — stamina bar in a circle.
2. **Never hue-only** stops with identical fill.
3. **Never continuous throbbing** on gassed/danger.
4. **Never** a second horizontal bar beside the ring for the same quantity.
5. **Never** fade the whole HUD when BPM climbs.

---

## Agent reader note

G64 owns geometry. You own **state → BPM band (engine) → fill% → hatch → numeral weight → rim rules**. Do not freestyle hex outside M22. Claude lands; Maria does not edit HANDOFF.
