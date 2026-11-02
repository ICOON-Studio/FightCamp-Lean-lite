# K14 DIGEST — THE BOOT (title / slots / settings)

Study only. No `.gd` / `.tscn`. Deliverables in `research/`.
Do not treat this as shipping UI. HANDOFF owned by parent.

## A) Shape

**PICK: TWO BOARDS — TITLE THEN SLOTS.** First frame is brand + Continue affordance; slots open when the player must choose a life (LOAD / NEW into a taken slot). Splash does **not** survive as a title — discarded with pre-kit scenes; any load wait is the shutter, not a branded splash.

- Rejected **one combined board**: brand + three dossiers on first paint forces save comparison before the player has decided to load.
- Rejected **splash-as-title**: Splash.gd is a load screen pretending to be a title; rebuild from the kit, never migrate.

## B) Chrome

**BootChrome (fourth)** — brand bar + body + foot. No rail, no Continue strip, no step strip, no committed trail.

Reason stronger than “different”: CreationChrome’s identity is steps + trail (K13) — mounting it with empty steps would lie about mid-creation. ShellChrome is career-only. K7 is fight gear. Boot is the gate **before** any step or career exists. Shares brand DNA with CreationChrome so NEW→step1 feels continuous; separate mount so CreationChrome stays honest.

## C) Slot row

**Carry:** gym name, city/country, career week, cash, roster count, discipline label, last played (`updated_at`), newest mark.

**Leave off:** alerts list, payroll/upkeep projection, injured/recovery/training minutiae, staff/coach counts, leading athlete portrait path, gym tier deep stats, W–L (no API), fame meters.

**`get_save_summary` gaps (Codex need):**
- **Incompatible ≠ empty** — unsupported saves collapse to `exists: false`. STATES needs `incompatible: true` + `save_version` exposed before build.
- Ruleset id optional later (discipline label covers glance identity).
- W–L / career fame not returned — leave off row (do not invent).

## D) Seams (ms-labeled, related feel)

| Seam | Contract | Σ |
|---|---|---|
| NEW → CreationChrome step 1 | fold 180 → shutter 220 → CreationChrome lock 240 → settle 140 | **780 ms** |
| LOAD / CONTINUE → THE DAY | fold 180 → shutter 220 → ShellChrome lock 240 → settle 140 | **780 ms** |

Same shutter language as K13 handoff / K7 enter. Green CONTINUE legal only after ShellChrome arrives.

## E) Settings

**Boot owns:** master / music / SFX, resolution + window mode, ruleset (career-binding before NEW).

**In-career:** audio (+ resolution) via same board; ruleset read-only.

**No form family** — compose `settings_row` from `pair` + track fill + `chip` segments. Gold ×1 = APPLY.

## F) First run

Empty slot board is deliberate invitation — three dashed empties + gold NEW CAREER. Not BAD / not “missing save.”

## G) Kit gaps

Reuse: `pair`, `chip`, `badge`, `alert_strip`, silhouettes, CreationChrome brand DNA, K7 shutter.

| Instrument | Need |
|---|---|
| `boot_chrome` | Pre-career gate: brand + body + foot — no rail / steps / trail / Continue |
| `slot_row` | Identity + week/cash/roster/discipline + newest mark |
| `confirm_sheet` | Delete / overwrite / leave-creation |
| `settings_row` | Audio track + chips from pair/chip — not a new form family |
| `boot_seam` | BootChrome → CreationChrome **or** ShellChrome (780 ms twin) |

**No drag primitive.**

## Boards (1920×1080, BootChrome — not ShellChrome)

1. **THE TITLE** — CONTINUE (green) + gold NEW CAREER
2. **THE SLOTS** — three saves, newest clear
3. **SETTINGS** — audio / resolution / ruleset
4. **THE SEAMS** — twin 780 ms handoffs
5. **STATES** — empty / incompatible / delete / overwrite / back from creation

## Kit rulings obeyed

Bebas / Plex; SIZE_MIN 12; gold ×1 per board; green = Continue only; pair = slate; facility is GYM; silhouettes; invent nothing beyond listed summary fields + Codex gap callout.

## Files

- `BOOT_K14.html`
- `BOOT_K14_title.png` / `_slots.png` / `_settings.png` / `_seams.png` / `_states.png`
- `K14_DIGEST.md` (this file)

## Blockers

**Codex before build:** extend `get_save_summary` (or sibling) so incompatible saves are distinguishable from empty (`incompatible` + `save_version`). Study itself is unblocked.
