# R59 — THE INJURY IN THE SAVE (Claude, 2026-09-08)

`body_state` version 2. A region still carries its 0-100 number; when a bout's
own facts support one, it now also carries a NAMED injury that owns the
timeline. `research/TASK_R59.md`.

## What landed

**`Godot/scripts/BodyReadiness.gd`** — `CURRENT_VERSION` 1 → 2, Q2's
`Injury.gd` pulled in as a const preload, and one new section:

- `migrate_athlete()` adds `injuries: {}` and `injury_log: []`, both **empty**,
  and canonicalises the week/severity fields of any stored row back to `int`
  (JSON restores every number as a float, and two identical bodies must still
  compare equal across a save/load). An existing hold keeps its week and its
  synthesized reason and is never given an injury to explain it.
- `get_injuries` / `get_injury` / `get_injury_log` / `hold_injury_region` —
  reads, all of which treat an absent key exactly like an empty one.
- `store_injury()` puts one primary on its region through Q2's
  `resolve_on_region()` rather than stacking, and folds the injury's ladder
  into `medical_hold_until_week` with `maxi`. One clock, as J13 DA3/DA4 require.
  `medical_hold_reason` keeps being written and is now sourced from the
  diagnosis's `type_id`.
- `name_bout_injury()` — the derivation, no RNG and no draw table:
  1. a stoppage the fighter did **not** win, with `head_neck` among the
     hotspots → `concussion_rhi` on the head;
  2. a stoppage **win** by a striking/kick/mma fighter whose own arm is a
     hotspot that ended red → `fracture` on that arm;
  3. otherwise the worst hotspot that ended below the amber threshold →
     `contusion` (which sets no hold);
  4. otherwise **nothing** — the region is sore and undiagnosed, which is the
     common case and the correct one.
  Severity is read off the number the bout left behind (<20 → 3, <40 → 2, else
  1): authored, deterministic, and not claimed as a citation.
- `_apply_bout_injury()` is the single naming path, called from **both**
  `apply_fight_damage` and `apply_real_fight_damage`, so a simmed bout and a
  played bout cannot produce two different fighters. Both now also return
  `injury` in their result dict.
- `resolve_due_injuries(athlete, week)` clears every injury whose compete week
  has arrived and pushes it onto `injury_log`, newest-first. It never touches
  the hold.

**`Godot/scripts/GameState.gd`** — four seams:

- `_body_read()` region rows gain `"injury"` and nothing else changes shape.
- `_body_hold_read()` prefers the stored injury's region and reports
  `region_known: true` because now it genuinely is; `_body_hold_region()`'s
  derivation from `fight_history` stays as the fallback for a hold nothing
  named, and C37's "not known" answer is untouched. The read also carries
  `"injury"`, `{}` when there is none.
- `_advance_injuries(career_week, overrides)` next to the other weekly helpers;
  called from `advance_week()` **after** the clock turns, so a compete week of
  14 clears as week 14 begins — the convention the hold has always used.
  `advance_day()` delegates to `advance_week()` on Sunday, so it fires exactly
  once per week either way. Its rows return as `injury_results`.

**Tests** — `body_readiness_test.gd` (+5 cases), `body_read_test.gd` (+11
checks, Q30-Q40), `body_readiness_integration_test.gd` (+2, including the
save/load round trip on a filed injury).

## Decisions worth carrying

- **Rule 3 picks the worst hotspot by its NUMBER, not by list position.** The
  simmed path orders hotspots by draw, the played path by damage; walking
  `region_ids()` order makes the two agree even on a tie. This was the one real
  way the two paths could have diverged.
- **No laceration branch.** `FightSimulation.gd` produces `KO`, `TKO`,
  `KO/TKO`, `SUBMISSION` and `DECISION` — nothing names a cut, so a laceration
  rule would have been a dead branch with no producer. Q2's laceration ladder
  (the one carrying a DIRECT source) waits for a method that can name it.
- **No submission rule.** A submission loss is a choke as often as a joint
  lock; naming a ligament injury off it would be invention, and J13 leaves the
  odds UNKNOWN.
- **`Injury.gd` was not touched.** Q2's family table still omits `kick` from
  `concussion_rhi` and `laceration`, exactly as Qwen's block records — the
  naming here reads the BOUT's facts and never calls `types_for_family()`, so
  the gap costs nothing and is not papered over.
- **The hold words are still mangled.** `get_fighter_flags()` at
  `GameState.gd:11826` turns the reason into `CONCUSSION RHI` now instead of
  `STOPPAGE LOSS AFTER TKO`. Better, but it is still string-mangling, and the
  words belong to Q3's `InjuryWords.gd` and to U9. Deliberately left alone.

## Gate

```
python Godot/tools/check_scripts.py Godot/scripts/Injury.gd Godot/scripts/BodyReadiness.gd Godot/scripts/GameState.gd
```

```
Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tests/body_read_test.gd
```
