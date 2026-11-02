# U124 — Declared-only gates census

**Summary (3 lines).** Yes: the worst live defect is `fight_body_overlap_test.gd`, which claims “no refused head/hand penetration” but scores only three class-pair keys—one of them (`arm>head`) is never emitted by `class_pair_key`, so the test can stay green while `head>arm` and most of the room’s allowance table overlap freely. **Fix first:** replace that test’s search space with the same keys as `FightWorldLiveScreen.OVERLAP_ALLOWANCE_M` (or all capsule pairs above allowance), and delete the dead `arm>head` key. **Direction:** `FightPoseSolver` already does the right thing for penetration (`pen_max` over every A×B capsule); the pattern to kill is global pass/fail wording over a partial pair list—hip-only `PAIRGAP` controls are the documented tautology, not a new surprise.

---

## Defect class (from TASK_U124)

A gate whose **search space is supplied by what it grades**—worst-case or pass/fail from a declared list while the prose sounds complete. Narrow-by-design checks that name their slice in output are fine. This census hunts the blind global verdict.

---

## Ranked findings

### 1 (worst) — `Godot/tests/fight_body_overlap_test.gd` — automated suite gate

| | |
|---|---|
| **Global claim** | `_check(..., "no refused head/hand penetration in %d frames (worst %.4f m …)"` at `:32-34`. |
| **What it iterates** | `REFUSED_PAIRS := ["hand>head", "arm>head", "head=head"]` at `:14`; inner loop skips any class pair not in that list at `:71-72`. |
| **What it cannot see** | Every other class pair the room cares about: `head>arm`, `head>torso`, `torso=torso`, `arm>torso`, guard pairs, etc.—all present in `FightWorldLiveScreen.OVERLAP_ALLOWANCE_M` (`FightWorldLiveScreen.gd:416-428`) after the S36 census. |
| **Concrete fool** | On seed `810039` MMA, `probe_overlap_census.gd` documents **82 frames (9.1%)** of `head>arm` overlap (comment at `FightWorldLiveScreen.gd:410-414`). The test never queries `head>arm`. Worse: **`arm>head` is not a key `FightBodyCapsules.class_pair_key` can produce** (head rank 1, arm rank 2 → always `head>arm`; see `FightBodyCapsules.gd:190-196`). The middle entry in `REFUSED_PAIRS` matches **zero** part pairs, so that slice of the “worst” is permanently zero. A bout can show skull-in-shoulder (`head>arm` depth > 0) and the test still prints `ok` with `worst 0.0000 m` if the three listed keys happen to be clean. |
| **Why it bit before** | U119 scoped refusal off `probe_body_overlap.gd`’s single **deepest** pair per frame; census at `probe_overlap_census.gd:7-13` records that this drove three keys to zero while **`frames_penetrating` stayed 341/900**. The test frozen at U119’s list never caught up to the expanded allowance table. |

**Not a fix in U124** — census only. First change would align the test with `OVERLAP_ALLOWANCE_M` or with `Capsules.frame_overlap` + per-key allowances like R7 in `fight_stage_realism_test.gd:1379-1418`.

---

### 2 — `FightWorldLiveScreen.gd` — runtime overlap “gate” (correction driver)

| | |
|---|---|
| **Claim shape** | Not a test, but the live room **acts** on `_refused_overlap_depth` / `_correct_refused_overlap` as if overlap were solved when excess hits zero. |
| **What it iterates** | `_refused_overlap_from_parts` at `:2010-2023`: nested loops over all parts, but **only pairs with** `OVERLAP_ALLOWANCE_M.has(key)` contribute to `max_excess`; comment at `:2008-2009`: *“A pair with no entry is not refused at all.”* |
| **Blind spot** | `leg=leg`, `foot=foot`, kick tails, etc.—deliberately absent from the table (`:388-407`)—can interpenetrate without triggering correction. That is product policy, not a bug, **unless** someone reads “refused overlap depth” as total penetration. |
| **Fool** | Same as #1 for in-table vs out-of-table: torsos can be separated for `arm>torso` while `leg=leg` depth stays high; correction stops when **declared** excess is zero. |
| **Rank** | Below the test because the table is documented and census-driven; the **test** still claims a global head/hand verdict on a stale subset. |

---

### 3 — Hip-only `PAIRGAP` used as regression “controls”

| | |
|---|---|
| **Files** | `Godot/tools/pair_gap_report.gd` (`:2-3` labels S31 gate instrument; `:103-104` prints `PAIRGAP … min/max/mean` **hips-to-hips only**); `Tools/s41_pairgap_diff.py`; `research/U115_check.py` (`:124-142` pins `grapple_control` min/max gap); `research/U117_check.py` (`:114-123`). |
| **Global implication** | S41 handover and `s41_pair_contact.gd:7-13` state the failure mode: **nine byte-identical PAIRGAP rows prove nothing** when retarget moves bones below `Hips`. Using “PAIRGAP unchanged” as a **pass** for silhouette or girdle work is a declared-only control. |
| **Concrete fool** | Shoulder rotation +26° (`s41_correction_delta.gd`) with unchanged hip gap → `s41_pairgap_diff` reports `SAME` for all keys while hand-to-torso distances move (`s41_pair_contact.gd` purpose). |
| **Rank** | High process risk, but **documented** (TASK example: `pair_gap_report` hips-only). Not equivalent to “worst penetration” wording; fail if a stage treats identical PAIRGAP as global pair health. |

---

### 4 — `Godot/tools/s31_contact_probe.gd` + `U117_check.py` — declared contact distances

| | |
|---|---|
| **Iterates** | `PAIRS` / `AUTHORED` five Cascadeur distances (`:32-46`, loop `:120-137`); `U117_check.py` gates drift on four of those rows (`:92-112`). |
| **Blind spot** | Any contact not in the five (e.g. chest push, wrist tie) is unmeasured. |
| **Fool** | Retarget could destroy an unlisted limb relation while listed drifts stay under loose ceilings (hand drift allowed to **390%** in `U117_check.py:19-20`). |
| **Verdict** | **Borderline / narrow on purpose.** Output is per-row `S31CONTACT`; gates are **named drift ceilings**, not “worst body penetration.” Treat as instrument scope, not DolA-class penetration blind spot—unless someone promotes `S31CONTACT worst=` (`:138`) to a global clinch verdict without adding pairs. |

---

### 5 — `probe_body_overlap.gd` — meta-instrument (not a pass gate)

| | |
|---|---|
| **Behavior** | `Capsules.frame_overlap` scans **all** part pairs; each frame’s printed `worst` is the max depth across them (`probe_body_overlap.gd:63-70`). |
| **Defect** | Using that **one number per frame** to **choose which class pairs to refuse** (U119) without `probe_overlap_census.gd` is choosing the search space from a single argmax—documented at `probe_overlap_census.gd:7-13`. The probe itself is not declared-only; **policy derived from it was.** |

---

## Checked hard — **not** findings

### `FightPoseSolver.gd` — `evaluate()` `:161-280`, `refine()` `:376-382`

- **`pen_max` / `pen_pair`:** computed over **every** capsule A×B (`:174-186`). Declared `contacts` only feed **touch** / cost terms (`:203-224`), not worst penetration.
- **`refine() pass`:** requires `pen_max`, `touch_max`, `mat_max`, `grip_max` (`:378-382`). Undeclared overlap cannot hide behind a contact-only pen metric.
- **`fight_pose_solver_test.gd`:** explicitly asserts `pairs == 4` and penetration-with-no-contacts fixture (`:130-214`). Mutant-hardened.

### `fight_stage_realism_test.gd` — R7 `:1379-1633`

- Overlap violation uses **full** `overlap["pairs"]` from `Capsules.frame_overlap`, not strike `_contact_s` lists. Gated rule text: *“no pair deeper than 0.02 m except …”* with allowance logic per pair class—aligned with full scan.

### `fight_pair_live_test.gd`

- Checks clock, gap at window entry, **LeftHand→Head** reach in a named window (`:252-254`), toe canvas bound—not a global worst-penetration claim over declared solver contacts.

### `pair_gap_report.gd`

- Worked example of **narrow instrument** (TASK_U124): header says hip-to-hip; not counted as a new finding.

### `validate_technique_nodes.py`

- **Historical** declared-only vocabulary (file header `:39-44`). **Fixed:** vocab from `technique_vocabulary.json` (`:28-50`), independent of the catalogue under merge.

### `Godot/tools/run_tests.py` / `check_scripts.py`

- No geometry scoring; not in scope.

---

## Task-file anchors (requested)

| Location | Result |
|----------|--------|
| `FightPoseSolver.gd:161`, `:286` | Worst penetration is **not** from `contacts`; `resolvable_contacts` is a **count** for callers, not a pen metric. |
| `fight_pose_solver_test.gd` | Loads bearing; does not introduce declared-only pen gate. |
| `s41_pair_contact.gd` | Hand-to-torso instrument; labels itself vs hips-only PAIRGAP. |
| `s41_pairgap_diff.py` | Diff hips baseline; non-vacuity on key sets (`:59-65`), not a body overlap gate. |

---

## If fixing (out of scope for U124)

1. **`fight_body_overlap_test.gd`** — Match `OVERLAP_ALLOWANCE_M` keys (and fix `arm>head` → remove); or assert `violating_frames == 0` using the same loop as R7 realism sampling.
2. **Stage controls** — Never treat unchanged `PAIRGAP` as proof that retarget below `Hips` did nothing; require `s41_pair_contact.gd` or full overlap census for those stages.
3. **Keep** `FightPoseSolver`’s all-pairs `pen_max` as the reference pattern for any future two-body solver in-repo.

---

## Files read (census)

`FightPoseSolver.gd`, `fight_pose_solver_test.gd`, `FightBodyCapsules.gd`, `FightWorldLiveScreen.gd` (overlap table + `_refused_overlap_from_parts`), `fight_body_overlap_test.gd`, `fight_stage_realism_test.gd` (R7/R8/R5 windows), `fight_pair_live_test.gd`, `pair_gap_report.gd`, `s31_contact_probe.gd`, `s41_pair_contact.gd`, `probe_overlap_census.gd`, `probe_body_overlap.gd`, `validate_technique_nodes.py` (header), `U115_check.py`, `U117_check.py`, `s41_pairgap_diff.py`, `TASK_U124.md`.

**Set aside:** AGENTS.md says Codex runs `brief --agent codex`; this session executed TASK_U124 from the user message directly (same file content). No `.gd` edits; no suite run per task tier.
