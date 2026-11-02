# M23_REGION_READOUT.md

Maria Art Director · 2026-09-22 · art only — STATE and treatment; **no positions, widths, or row heights** (layout owns geometry)

Cage Desk + M22 tokens. Six regions (head_neck, torso_core, left_arm, right_arm, left_leg, right_leg) as **letter chips + meter**, not anatomy. Player = manager (towel / continue), not fighter.

**References (what was taken):**
1. **Undisputed corner damage panel** — both corners, many small rows, status-at-a-glance; took **compact row language** and dual-corner presence (not their art style).
2. **Football Manager match-day tiles** — dense, glanceable status without illustration; took **scarce colour = meaning** and no decorative chrome.
3. **Aviation caution/warning strips + bedside monitors** — few discrete levels, shape/fill backup when hue fails; took **named stops + second channel** (fill/hatch), and a **qualitatively different “warning that ends the action”** (master caution ≠ yellow caution).

Where they disagree: games often use smooth red gradients; aviation uses **few named stops**. **Pick named stops** — gradients are noise at speed and break CVD.

---

## DECISIONS

1. **Ramp = 3 stops** — `region_fine` / `region_hurt` / `region_critical`. Five is noise at fight speed; two loses the warning beat. **Defend:** three matches manager decisions (ignore / watch / act).
2. **Doctor-stoppage = own treatment** (`region_doctor`) — **not** the top of the ramp. Qualitatively different: fight-ending medical threshold vs “merely bad.”
3. **Second channel (mandatory):** **fill amount** of the region meter + **hatch on critical/doctor**. Colour-blind viewer reads **how full** and **hatched vs solid**, not hue alone.
4. **On-change:** fill **slides 200 ms** (band 160–240); brief **rim pulse 200 ms** on the changed region only; **never** fade the whole screen.
5. **Corner identity:** **asymmetric owner chrome** — OUR rail gets `color_accent` owner mark + club/fighter short label; THEIR rail gets `color_hairline` owner mark + short label. Mirroring layout alone is forbidden as the only cue.
6. **Glyphs:** letter codes HN / TC / LA / RA / LL / RL (same family as fight HUD glance) — not body outlines.
7. **Never list** below — five mechanical bans.

---

## 1. THE DAMAGE RAMP (named stops)

| State | Token (fill) | Token (track) | Fill amount | Second channel | Meaning for manager |
| --- | --- | --- | --- | --- | --- |
| Fine | `color_positive` | `color_hairline` @ 40% | **20%** of meter | solid fill | Ignore |
| Hurt | `color_warning` | same track | **55%** | solid fill | Watch / consider pace |
| Critical | `color_negative` | same track | **85%** | **45° hatch** over fill | Act — towel / ask stoppage in play |
| Doctor | `color_negative` | `color_negative` @ 100% track | **100%** | **hatch + stop glyph** | Fight-ending medical threshold |

Ramp stops = **3** (`fine` / `hurt` / `critical`).  
`region_doctor` sits **beside** the ramp as a **state class**, not stop 4 of a prettier gradient.

**Why not 5:** at Undisputed-like density and FM glance speed, mid-stops (“slightly worn”, “very hurt”) collapse into the same manager action — noise.

**Ink / label colour per stop** (region letter + optional short word):

| State | Label ink |
| --- | --- |
| Fine | `color_text_secondary` |
| Hurt | `color_text` |
| Critical | `color_text` |
| Doctor | `color_text` on `color_negative` chip (see contrast) |

---

## 2. COLOUR IS NOT ENOUGH (second channel)

| Channel | What it carries | What CVD (~8% men, red–green) sees |
| --- | --- | --- |
| **Fill height/amount** | Severity ladder (20 / 55 / 85 / 100%) | Primary severity — works if red≈green |
| **Hatch** | Critical + doctor only | “This is the dangerous class” without trusting red |
| **Stop glyph** | Doctor only (simple halt/cross mark, 1-bit) | Ends-the-fight class vs critical-but-continuing |
| **Hue** | Positive / warning / negative (M22) | Backup for trichromats only |

**Rule:** if two states share a hue family (`critical` and `doctor` both use `color_negative`), they **must** differ on fill amount **and** glyph (doctor only).

No blood texture, no vein map — hatch is geometric, 1px lines, readable at small meter size.

---

## 3. CONTRAST (computed, M22 surfaces)

Ratios = WCAG 2.x style relative luminance. Status **fills** are not body text; where a label sits on a fill, ratio is listed.

| Pair | Ratio | Role |
| --- | --- | --- |
| `color_positive` on `color_panel` | **4.6:1** | fine fill vs raised — OK as fill, not as tiny text alone |
| `color_positive` on `color_sunken` | **4.9:1** | fine fill vs well |
| `color_warning` on `color_panel` | **6.8:1** | hurt fill |
| `color_warning` on `color_sunken` | **7.3:1** | hurt fill |
| `color_negative` on `color_panel` | **4.5:1** | critical fill (floor) |
| `color_negative` on `color_sunken` | **4.8:1** | critical fill |
| `color_text` on `color_panel` | **12.6:1** | labels (hurt/critical) |
| `color_text_secondary` on `color_panel` | **5.8:1** | fine labels |
| `color_text` on `color_negative` | **4.9:1** | doctor chip label |
| Hatch lines | use `color_text` @ 70% on the fill | must remain visible when hue collapses |

**Critical must not be the only failing pair:** fine/hurt/critical fills all clear **≥4.5:1** against both `color_panel` and `color_sunken` as fills. Doctor chip text on negative fill also ≥4.5:1.

---

## 4. WHAT CHANGES WHEN IT CHANGES

G63 house rule: **slide 160–240 ms; never fade the whole screen.**

| Event | What animates | Amount | Duration |
| --- | --- | --- | --- |
| Region worsens or improves | Meter **fill** slides to new % | to target stop % | **200 ms** |
| Same | **Rim** on that region cell only | `color_link` 1px | **200 ms** then off |
| Enter critical | Hatch **fades in** | 0→100% opacity | **200 ms** (with fill) |
| Enter doctor | Fill→100% + hatch + **stop glyph appears** | glyph opacity 0→100% | **200 ms** |
| Forbidden | Full-screen flash, camera kick, blood overlay, HUD blackout | — | — |

One region at a time draws the rim; no queue of stacked flashes.

---

## 5. TWO CORNERS — NOT CONFUSABLE

Mirroring six rows left/right is **necessary but not sufficient**.

| Cue | OUR corner | THEIR corner |
| --- | --- | --- |
| Owner mark | `color_accent` vertical keyline (treatment, not a width spec) | `color_hairline` keyline |
| Owner label | Short fighter/club tag in `color_text` | Short tag in `color_text_secondary` |
| Meter default fill when fine | `color_positive` | `color_positive` (same ramp — identity is owner chrome, not different ramps) |

**Instant read:** accent keyline + our label = ours. No accent keyline = theirs.  
Do **not** rely on “left vs right” alone (mirror confusion under stress / streamed layouts).

---

## 6. THE ONE THAT ENDS THE FIGHT

**Own treatment: `region_doctor`.**

| | Critical | Doctor |
| --- | --- | --- |
| Manager meaning | Fight can continue; towel is a decision | Medical/stoppage threshold — qualitatively over |
| Fill | 85% + hatch | 100% + hatch |
| Glyph | none | **stop glyph** |
| Track | normal track | track also `color_negative` |
| Copy | optional “CRIT” | optional “DOC” / stop word — never gore |

Doctor is **not** “critical but redder.” It is the aviation master-caution analogue.

---

## 7. NEVER (five mechanical bans)

1. **Never anatomy illustrations or body maps** as the region control — letter + meter only (hobby tell + illegible at small size).
2. **Never blood, cuts-as-texture, or gore** on the readout — trauma pips elsewhere may exist; this ramp is status, not meat.
3. **Never pulsing / throbbing glow** on critical — it steals attention every frame and reads arcade, not FM density.
4. **Never per-region portraits or face insets** — face is dead at fight distance and blows the density hole G63 named.
5. **Never hue-only severity** (red vs green with identical fill) — fails CVD; fill% + hatch are mandatory.

---

## Agent reader note

Layout owns row height and panel width. You own **state → fill% → hatch → glyph → rim timing → owner chrome**. If a builder needs a pixel, they take it from the layout task — not from this file. Claude maps state names to UIKit; do not freestyle hex outside M22 + the fills above.
