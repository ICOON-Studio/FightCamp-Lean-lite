# D28_FRESH_EYES_TRAINING (Dola, collected by Claude S84, 2026-09-26)
Raw capture of Dola's reply via Tools/cici/cici.py read (chat 'D28 Fresh Eyes Training'); not curated. Brief: TASK_D28_FRESH_EYES_TRAINING_SCREENS.md.

---
## 1. Visibility of training movement
- **Best**: *Tuesday Home → Yesterday on the floor* – explicit per-fighter per-stat gains (+0.06 Power etc.) are immediately scannable; no digging required.
- **Worst**: *Monday Home → Monday report* – only vague "0.3 sharper" phrasing; no breakdown by stat, no clear direction of change. The fighter profile thin progress bars are far too subtle to register at a glance; arrows are easy to miss entirely. The training planner shows *expected* gains but not *actual* results from prior days, so you can’t confirm what stuck.

## 2. Clarity & sizing issues
- Thin progress bars in the fighter profile vanish against the background; hard to judge how far along you are.
- Arrows are tiny, low-contrast, and ambiguous – they indicate change but not magnitude.
- `+0.05 Power` is cramped and visually small; values get lost beside labels.
- Some training station tags (e.g. "NO BOXING TAG") are clipped or hard to parse at a glance.

## 3. Reading "+0.05"
- Reads as **negligible/insignificant** – players see decimals this small and think "nothing meaningful happened."
- Fix: Use **per-mille or hundredths as whole numbers** → `+5 Power` instead of `+0.05 Power`; scale the underlying values up by 100 internally. Or use percentage points: `+0.5% Power` – still precise but feels substantial.

## 4. First change to make
**Standardise all gain displays to integer values (×100 scale) and put daily *actual* training results front-and-centre on the Home screen.** Replace vague "sharper" language with consistent, familiar `+X Stat` formatting everywhere – Monday/Tuesday reports, fighter cards, and training planner previews – so there’s zero guesswork about what improved and by how much.

---

## Claude's ruling (S84)
Agreed that +0.05 reads as nothing. A day's gain is shown as a share of the next point: POWER +5% (0.05 of a point), the same unit as the S83 progress bars ('62% of the way to 45'). Applied to the 3D floor labels in S84; HOME's day card, the Monday report and the planner follow in S85. Not x100 internal scaling - that would change every stat and the balance.
