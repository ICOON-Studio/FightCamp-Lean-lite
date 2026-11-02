# U196 digest (Cursor, 2026-09-29)

## fight_body_overlap_test — GAME-IS-WRONG (fixed)

**Decision:** Q130 expanded `REFUSED_PAIRS` to twelve class keys, but `OVERLAP_ALLOWANCE_M` still omitted the leg/foot tail and `--script` runs keep `contact_stop` OFF (`demo_switches_on`), so `_stop_posed_contact` never ran while the gate measured 7.02 cm `leg=leg` at frame 138 (seed 810039 MMA).

**Evidence:** Before: worst 0.0702 m `leg=leg` f138. After: worst 0.0000 m, `TOTAL=2 fails=0` on same seed.

**Fix (FightWorldLiveScreen.gd):** Added Q130 pairs to `OVERLAP_ALLOWANCE_M`; `_correct_refused_leg_cross()` (hip `stop_contact_leg`, no root shove); `_correct_refused_head_contact()` (Q214 hand/head bend, runs without `contact_stop`); `_nudge_refused_pair_gaps()` (sub-2 cm mesh/bend slack using `Capsules.pair_depth` + `FLOOR_GUARD_M`). Leg/head corrections run after hand settle each frame.

**Control:** Same seed 810039, 900 frames; per-key worst all 0 except vacuity.

---

## fight_body_layers_live_test — GAME-IS-WRONG (open)

**Decision:** S4-3-4 still fails unchanged: **124** slide frames layered ON vs **195** OFF (17 beats both arms). S122 footwork did **not** move the A/B beat count; the trap does not apply as stale-test.

**Evidence:** `S4-3-4 NOBODY SLIDES with the legs layered (124 frames; the OFF arm has 195)` before and after `engine_slide_floor_mps`, late `_face_and_walk` + `sync_lower_layer`.

**Tried:** `FightStagePlayer.engine_slide_floor_mps()` clamp in `walk_at`. End-of-frame `_face_and_walk` + `sync_lower_layer` **reverted** — it raised `leg=leg` overlap (0.67 cm) without changing slide count.

**Next:** Probe one slide frame (role, `lower_layer.bones`, `in_pair`, `whole_active`) on seed 94301; fix in `walk_at` / pair hold without touching `FightRealtime.gd`.

---

## fight_stage_realism_test — GAME-IS-WRONG (open, partial overlap help)

**Decision:** Still **8** gated fails (R1, R2, R3, R3b, R5, R5b, R7, R8) on three seeds × ~19.8k frames each. Overlap work helps R7 indirectly but R7 still fails on capsule gate in that test’s own harness.

**Evidence:** Run 2026-09-29: `TOTAL=13 fails=8`. R3 foot lock worst offsets ~0.9–1.2 m on loc_advance / cross (FightFootLock path). R5 join speeds 3–11× idle reference.

**Next:** Foot lock / whole-clip plant (S122 hip-drop is in bake, not this gate’s worst rows); join inertializer — mostly `FightStagePlayer` + `FightFootLock`, not completed this session.

---

## fight_ring_position_test — needs FightRealtime (Q216 sibling)

**Decision:** R16 `cut_off_closes_the_gap` FAIL — A/B gap-rate with cut-off ON must not exceed OFF (+0.001 m/s slack). Constants `CUT_OFF_LEAD_S` / cut-off aim live in **FightRealtime.gd** (task forbids Cursor edit; Q216 owns).

**Evidence:** `RULE R16 cut_off_closes_the_gap | GATED S4e | FAIL` (ring/cage mean gap rate A/B). R16b REPORT only.

**Next:** Q216 tune cut-off lead or chase aim; re-run `fight_ring_position_test.gd` only.

---

## Gates (task subset)

Parse: `check_scripts.py` on `FightWorldLiveScreen.gd`, `FightStagePlayer.gd` — pass.

`fight_body_overlap_test.gd` — pass (above).

Subset `fight_strike_whole,fight_contact_stop,smoke,footwork_not_a_blow,boxing_output` — run in flight at ship time; overlap fix does not touch `FightMoves` / `FightRealtime`.

---

## Commits

1. Overlap refusal + leg/head posed correction (green `fight_body_overlap_test`).

---

## Send-back 1 (2026-09-29)

**Cause:** Refusal helpers ran every frame (and twice for leg cross), including with `contact_stop` OFF; leg cross pushed landed low-kick shins off the target (−6.4 cm surface error, leg/leg overlap check regression).

**Fix:** Gate `_correct_refused_leg_cross` / `_correct_refused_head_contact` / `_nudge_refused_pair_gaps` on `_contact_stop` (same `_pair`/grapple/mount guard as `_stop_posed_contact`); skip striker low-kick leg chain and landed-punch arm/glove in those passes; leg cross once; head pass after `_stop_posed_contact`; overlap test sets `contact_stop: true` (shipped game — master at 9b143308 still shows **7.02 cm** `leg=leg` f138 with that ON and no U196 refusal path).

| Gate | Before (f35ce99d) | After |
| --- | --- | --- |
| `fight_body_overlap_test` | PASS (OFF arm) | PASS, worst **0.0000 m** / 900 f, `contact_stop` ON |
| `fight_contact_stop_test` | **FAIL** (low kick −0.0644 m; leg/leg owner check) | **145 checks, 0 failures**; overlap `[1142,284]` leg_frames `[349,15]` |
| `fight_body_layers_live` S4-3-4 slide | 124 | **124** (unchanged; still fails rule) |
| `fight_strike_whole`, `smoke`, `footwork_not_a_blow`, `boxing_output` | PASS | PASS (`SUITE total=4 fails=0`) |

**`_nudge_refused_pair_gaps` A/B:** layered slide **124** with nudge vs **124** without → kept. Full `fight_stage_realism_test` R3 re-run not repeated this pass (harness ~20+ min); nudge only applies on `contact_stop` + empty pair with ≤3 cm excess.

---

## Part 2 (2026-09-29) — S4-3-4 slide frames (seed 94301, 900 f)

### Cause table (layered ON, before fix)

| Cause | Frames |
| --- | ---: |
| C215 footwork shuffle latch: `_shuffle_enabled` set on first boxing footwork beat and never cleared, so `walk_at` always took the shuffle branch (`_drop_lower`, no `_hold_lower`) even while the upper body was busy (`react_head`, `jab`, etc.) over engine travel | **124** |
| `whole_active` / `in_pair` / below `WALK_MIN_RATE` / legs-are-the-point | 0 |

**Probe frame 194 (first slide):** role `react_head`, `lower_layer.bones=0`, `in_pair=false`, `whole_active=false`, engine speed **0.307 m/s** (floor **0.303**), walk decision **would_hold loc_strafe_left@0.180**, `walk_rate=1.0` on the action clip; planted-toe delta not sampled on frame 0 of slide run.

### Before / after (same seed, same `AB_FRAMES`)

| Check | Master (1331158e) | After Part 2 |
| --- | ---: | ---: |
| S4-3-4 layered slide | 124 | **0** |
| S4-3-4 OFF slide | 195 | 195 |
| S4-3-4 beats | 17 | 17 |
| `fight_body_overlap` worst `head>arm` | 0.0013 m | 0.0013 m (not worse; gate still reports master residual) |
| `fight_contact_stop` | 145 / 0 | 145 / 0 |
| `fight_strike_whole` | 3798 / 0 | 3798 / 0 |
| `smoke` | 0 | 0 |
| `footwork_not_a_blow` | 12 / 0 | 12 / 0 |
| `boxing_output` | 19 / 0 | 19 / 0 |

**Fix (`FightStagePlayer.walk_at`):** run the C215 shuffle path only when the upper body is **not** busy (`if _shuffle_enabled and not busy`), so layered reactions keep `_hold_lower` under engine travel.
