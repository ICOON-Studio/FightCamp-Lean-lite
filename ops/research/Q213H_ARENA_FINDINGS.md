# Q213H — where a combination's forward travel comes from (Arena, measurement only, no gameplay change)

**In one line:** on the clip gate's own fixture a boxing combination does **not** walk into the receiver. Its forward
travel is one punch's own lunge — the liver combo's body hook (0.61-0.68 m), the 1-2-hook's cross (0.11-0.12 m), the
six-punch's rear uppercut (0.48-0.53 m) — and that punch travels **exactly** as far when it is played alone from the
same guard: 12 rows, 12 exact matches. No step between the parts is involved, because on this fixture **none is
planned**: `FightStagePlayer._plan_sequence_step` returns on its first line while `sequence_receiver` is null, and the
clip gate's clips mode (which this probe mirrors) never sets it. The closest head-to-head approach always happens
**inside a punch**, never at a seam between two parts, and being in a combination changes it by millimetres (§5.4).

Measured on the official Godot 4.7.2-stable build, headless, with
`godot --headless --path Godot --script tools/q213h_combo_probe.gd -- quiet=1` (exit 0).

Files added — **no existing file was edited or deleted**:

| file | what it is |
|------|------------|
| `Godot/tools/q213h_combo_probe.gd` | the instrument: 3 combinations x 4 rigs + every part played alone |
| `Godot/tests/q213h_combo_probe_test.gd` | the gate on the instrument: one pairing, one combination, plus the "it must read worse" control |
| `research/Q213H_ARENA_FINDINGS.md` | this file |

---

## 1. What was measured, and in exactly what fixture

The probe mirrors `tools/q213_clip_gate.gd` **clips mode** (`_run_clips`) — the fixture the certificates are made of:

* the same four rigs and pairings (`CLIPS_RIGS`, `CLIPS_OPPONENTS`, `CLIPS_ATHLETES`);
* the same mounting: `FightWorldStage.mount` + `apply_identity` + `FightStagePlayer.bind(node, "boxing")` +
  `take_animation_clock()`, with `strikes_play_whole = true` on the attacker only;
* the same spacing, taken from the gate's own certificate lookup (`_build_cert_lookup()`, `seqs` table, key
  `<move>|<rig>`) — never a constant. All 12 rows resolve to `s135_chains.json`;
* attacker at `Vector3.ZERO` facing +Z, receiver standing still at `Vector3(0, 0, spacing)` rotated `PI`, in his guard;
* before every clip: both men `play_role("idle")`, `animation_player().seek(0.0, true)`, `_rest_foot_lock()`, then
  30 frames of `advance(1.0 / 60.0)` — the gate's guard lead-in, so nothing is measured from the previous clip's last
  pose;
* then `play_role(<combo>)` and both men advanced for `ceil(length_s * 60) + 30` frames.

No glove pin, no skin, no capsule model. Per frame the probe reads the **world position of four bones** on each
skeleton (`Hips`, `Head`, `Neck`, `UpperChest`) and the attacker's `sequence_part_index()`.

Definitions, so every number can be checked by hand:

* **travel** — the attacker's `Hips` displacement in metres along the line that ran from his hips to the receiver's
  hips on the combination's **first frame**; positive is towards the receiver. The first frame reads 0.0000 by
  construction. It is the hips **bone**, not the root: the root (his stance on the canvas) never moves here (§5.5).
* **travel_max / travel_frame** — the greatest travel over the whole combination, and the 1-based frame it fell on.
* **head_head_min / head_head_frame** — the least distance between the two `Head` bones, bone centre to bone centre,
  and its frame. No radii: a head capsule is ~0.10 m, so a 0.15 m reading is contact, while the 11.5 cm in the S135
  report is the *capsule depth* of the same kind of event.
* **head_chest_min** — the least distance from the attacker's `Head` to the receiver's `Neck` / `UpperChest`.
* **part_at_min** — the attacker's part index at the frame of the closest approach.
* **travel_in_part** — a part's **net** travel: `travel(last frame of the part) - travel(first frame of the part)`.
  A punch that lunges and comes home reads ~0 here while its peak inside the part is large; the peak is `travel_max`.
* **SINGLE** — a part role played **alone** from the same guard lead-in. A SINGLE line carries no combo, so the role
  is measured at the spacing of the **first** combination that contains it (`COMBOS` order): jab, cross and body hook
  at the liver combo's spacing (1.095 m on welter_a), lead hook and rear uppercut at 0.890 m.

Frames are 1-based at 60 Hz: frame 1 is the first frame after the first `advance`.

---

## 2. The probe's full output

`godot --headless --path Godot --script tools/q213h_combo_probe.gd -- quiet=1` — 82 `Q213H_` lines, exit 0.
(`-- quiet=1` only mutes the pre-existing clip-loader errors, §7. The plain invocation prints these same 82 lines and
adds 816 `ERROR:` lines from `FightStagePlayer.bind`.)

```text
Q213H_ROW boxing_liver_combo generator_welter_a spacing=1.0950 travel_max=0.6416 travel_frame=125 head_head_min=0.1457 head_head_frame=115 head_chest_min=0.1120 part_at_min=2
Q213H_ROW boxing_one_two_hook generator_welter_a spacing=0.8900 travel_max=0.1167 travel_frame=59 head_head_min=0.3653 head_head_frame=59 head_chest_min=0.4038 part_at_min=1
Q213H_ROW boxing_six_punch_combo generator_welter_a spacing=0.8900 travel_max=0.4978 travel_frame=168 head_head_min=0.2535 head_head_frame=171 head_chest_min=0.2482 part_at_min=3
Q213H_ROW boxing_liver_combo generator_welter_b spacing=1.0550 travel_max=0.6131 travel_frame=125 head_head_min=0.2585 head_head_frame=116 head_chest_min=0.1849 part_at_min=2
Q213H_ROW boxing_one_two_hook generator_welter_b spacing=0.8650 travel_max=0.1116 travel_frame=59 head_head_min=0.3805 head_head_frame=59 head_chest_min=0.3867 part_at_min=1
Q213H_ROW boxing_six_punch_combo generator_welter_b spacing=0.8650 travel_max=0.4757 travel_frame=168 head_head_min=0.2901 head_head_frame=171 head_chest_min=0.2368 part_at_min=3
Q213H_ROW boxing_liver_combo generator_heavy_c spacing=1.1650 travel_max=0.6773 travel_frame=125 head_head_min=0.1826 head_head_frame=115 head_chest_min=0.1343 part_at_min=2
Q213H_ROW boxing_one_two_hook generator_heavy_c spacing=0.9350 travel_max=0.1232 travel_frame=59 head_head_min=0.3807 head_head_frame=59 head_chest_min=0.4154 part_at_min=1
Q213H_ROW boxing_six_punch_combo generator_heavy_c spacing=0.9350 travel_max=0.5255 travel_frame=168 head_head_min=0.2713 head_head_frame=171 head_chest_min=0.2538 part_at_min=3
Q213H_ROW boxing_liver_combo generator_heavy_d spacing=1.1500 travel_max=0.6594 travel_frame=125 head_head_min=0.2569 head_head_frame=116 head_chest_min=0.1863 part_at_min=2
Q213H_ROW boxing_one_two_hook generator_heavy_d spacing=0.9250 travel_max=0.1200 travel_frame=59 head_head_min=0.3961 head_head_frame=59 head_chest_min=0.4103 part_at_min=1
Q213H_ROW boxing_six_punch_combo generator_heavy_d spacing=0.9250 travel_max=0.5116 travel_frame=168 head_head_min=0.2956 head_head_frame=171 head_chest_min=0.2482 part_at_min=3

Q213H_PART boxing_liver_combo generator_welter_a part=0 role=boxing_jab frames=1-41 travel_in_part=0.0000
Q213H_PART boxing_liver_combo generator_welter_a part=1 role=boxing_cross frames=42-80 travel_in_part=0.0370
Q213H_PART boxing_liver_combo generator_welter_a part=2 role=boxing_body_hook frames=81-230 travel_in_part=-0.0320
Q213H_PART boxing_one_two_hook generator_welter_a part=0 role=boxing_jab frames=1-41 travel_in_part=0.0000
Q213H_PART boxing_one_two_hook generator_welter_a part=1 role=boxing_cross frames=42-80 travel_in_part=0.0370
Q213H_PART boxing_one_two_hook generator_welter_a part=2 role=boxing_lead_hook frames=81-158 travel_in_part=-0.0320
Q213H_PART boxing_six_punch_combo generator_welter_a part=0 role=boxing_jab frames=1-41 travel_in_part=0.0000
Q213H_PART boxing_six_punch_combo generator_welter_a part=1 role=boxing_cross frames=42-80 travel_in_part=0.0370
Q213H_PART boxing_six_punch_combo generator_welter_a part=2 role=boxing_lead_hook frames=81-129 travel_in_part=-0.0320
Q213H_PART boxing_six_punch_combo generator_welter_a part=3 role=boxing_rear_uppercut frames=130-183 travel_in_part=0.4067
Q213H_PART boxing_six_punch_combo generator_welter_a part=4 role=boxing_lead_hook frames=184-232 travel_in_part=-0.3923
Q213H_PART boxing_six_punch_combo generator_welter_a part=5 role=boxing_cross frames=233-312 travel_in_part=0.0000
Q213H_PART boxing_liver_combo generator_welter_b part=0 role=boxing_jab frames=1-41 travel_in_part=0.0000
Q213H_PART boxing_liver_combo generator_welter_b part=1 role=boxing_cross frames=42-80 travel_in_part=0.0353
Q213H_PART boxing_liver_combo generator_welter_b part=2 role=boxing_body_hook frames=81-230 travel_in_part=-0.0306
Q213H_PART boxing_one_two_hook generator_welter_b part=0 role=boxing_jab frames=1-41 travel_in_part=0.0000
Q213H_PART boxing_one_two_hook generator_welter_b part=1 role=boxing_cross frames=42-80 travel_in_part=0.0353
Q213H_PART boxing_one_two_hook generator_welter_b part=2 role=boxing_lead_hook frames=81-158 travel_in_part=-0.0306
Q213H_PART boxing_six_punch_combo generator_welter_b part=0 role=boxing_jab frames=1-41 travel_in_part=0.0000
Q213H_PART boxing_six_punch_combo generator_welter_b part=1 role=boxing_cross frames=42-80 travel_in_part=0.0353
Q213H_PART boxing_six_punch_combo generator_welter_b part=2 role=boxing_lead_hook frames=81-129 travel_in_part=-0.0306
Q213H_PART boxing_six_punch_combo generator_welter_b part=3 role=boxing_rear_uppercut frames=130-183 travel_in_part=0.3887
Q213H_PART boxing_six_punch_combo generator_welter_b part=4 role=boxing_lead_hook frames=184-232 travel_in_part=-0.3749
Q213H_PART boxing_six_punch_combo generator_welter_b part=5 role=boxing_cross frames=233-312 travel_in_part=0.0000
Q213H_PART boxing_liver_combo generator_heavy_c part=0 role=boxing_jab frames=1-41 travel_in_part=0.0000
Q213H_PART boxing_liver_combo generator_heavy_c part=1 role=boxing_cross frames=42-80 travel_in_part=0.0390
Q213H_PART boxing_liver_combo generator_heavy_c part=2 role=boxing_body_hook frames=81-230 travel_in_part=-0.0338
Q213H_PART boxing_one_two_hook generator_heavy_c part=0 role=boxing_jab frames=1-41 travel_in_part=0.0000
Q213H_PART boxing_one_two_hook generator_heavy_c part=1 role=boxing_cross frames=42-80 travel_in_part=0.0390
Q213H_PART boxing_one_two_hook generator_heavy_c part=2 role=boxing_lead_hook frames=81-158 travel_in_part=-0.0338
Q213H_PART boxing_six_punch_combo generator_heavy_c part=0 role=boxing_jab frames=1-41 travel_in_part=0.0000
Q213H_PART boxing_six_punch_combo generator_heavy_c part=1 role=boxing_cross frames=42-80 travel_in_part=0.0390
Q213H_PART boxing_six_punch_combo generator_heavy_c part=2 role=boxing_lead_hook frames=81-129 travel_in_part=-0.0338
Q213H_PART boxing_six_punch_combo generator_heavy_c part=3 role=boxing_rear_uppercut frames=130-183 travel_in_part=0.4293
Q213H_PART boxing_six_punch_combo generator_heavy_c part=4 role=boxing_lead_hook frames=184-232 travel_in_part=-0.4141
Q213H_PART boxing_six_punch_combo generator_heavy_c part=5 role=boxing_cross frames=233-312 travel_in_part=0.0000
Q213H_PART boxing_liver_combo generator_heavy_d part=0 role=boxing_jab frames=1-41 travel_in_part=0.0000
Q213H_PART boxing_liver_combo generator_heavy_d part=1 role=boxing_cross frames=42-80 travel_in_part=0.0380
Q213H_PART boxing_liver_combo generator_heavy_d part=2 role=boxing_body_hook frames=81-230 travel_in_part=-0.0329
Q213H_PART boxing_one_two_hook generator_heavy_d part=0 role=boxing_jab frames=1-41 travel_in_part=0.0000
Q213H_PART boxing_one_two_hook generator_heavy_d part=1 role=boxing_cross frames=42-80 travel_in_part=0.0380
Q213H_PART boxing_one_two_hook generator_heavy_d part=2 role=boxing_lead_hook frames=81-158 travel_in_part=-0.0329
Q213H_PART boxing_six_punch_combo generator_heavy_d part=0 role=boxing_jab frames=1-41 travel_in_part=0.0000
Q213H_PART boxing_six_punch_combo generator_heavy_d part=1 role=boxing_cross frames=42-80 travel_in_part=0.0380
Q213H_PART boxing_six_punch_combo generator_heavy_d part=2 role=boxing_lead_hook frames=81-129 travel_in_part=-0.0329
Q213H_PART boxing_six_punch_combo generator_heavy_d part=3 role=boxing_rear_uppercut frames=130-183 travel_in_part=0.4180
Q213H_PART boxing_six_punch_combo generator_heavy_d part=4 role=boxing_lead_hook frames=184-232 travel_in_part=-0.4032
Q213H_PART boxing_six_punch_combo generator_heavy_d part=5 role=boxing_cross frames=233-312 travel_in_part=0.0000

Q213H_SINGLE boxing_jab generator_welter_a travel_max=0.0000 head_head_min=0.8128
Q213H_SINGLE boxing_cross generator_welter_a travel_max=0.1167 head_head_min=0.5808
Q213H_SINGLE boxing_body_hook generator_welter_a travel_max=0.6416 head_head_min=0.1469
Q213H_SINGLE boxing_lead_hook generator_welter_a travel_max=0.0000 head_head_min=0.7158
Q213H_SINGLE boxing_rear_uppercut generator_welter_a travel_max=0.4978 head_head_min=0.2469
Q213H_SINGLE boxing_jab generator_welter_b travel_max=0.0000 head_head_min=0.7965
Q213H_SINGLE boxing_cross generator_welter_b travel_max=0.1116 head_head_min=0.5718
Q213H_SINGLE boxing_body_hook generator_welter_b travel_max=0.6131 head_head_min=0.2601
Q213H_SINGLE boxing_lead_hook generator_welter_b travel_max=0.0000 head_head_min=0.6902
Q213H_SINGLE boxing_rear_uppercut generator_welter_b travel_max=0.4757 head_head_min=0.2865
Q213H_SINGLE boxing_jab generator_heavy_c travel_max=0.0000 head_head_min=0.8669
Q213H_SINGLE boxing_cross generator_heavy_c travel_max=0.1232 head_head_min=0.6213
Q213H_SINGLE boxing_body_hook generator_heavy_c travel_max=0.6773 head_head_min=0.1838
Q213H_SINGLE boxing_lead_hook generator_heavy_c travel_max=0.0000 head_head_min=0.7473
Q213H_SINGLE boxing_rear_uppercut generator_heavy_c travel_max=0.5255 head_head_min=0.2651
Q213H_SINGLE boxing_jab generator_heavy_d travel_max=0.0000 head_head_min=0.8656
Q213H_SINGLE boxing_cross generator_heavy_d travel_max=0.1200 head_head_min=0.6254
Q213H_SINGLE boxing_body_hook generator_heavy_d travel_max=0.6594 head_head_min=0.2589
Q213H_SINGLE boxing_lead_hook generator_heavy_d travel_max=0.0000 head_head_min=0.7367
Q213H_SINGLE boxing_rear_uppercut generator_heavy_d travel_max=0.5116 head_head_min=0.2912

Q213H_SINGLES rows=20
Q213H_DONE rows=12
```

---

## 3. The table read as rows (3 combinations x 4 rigs)

| combination | rig | spacing (m) | travel_max (m) | frame | head_head_min (m) | frame | head_chest_min (m) | part at min |
|-------------|-----|-------------|----------------|-------|-------------------|-------|--------------------|-------------|
| boxing_liver_combo | welter_a | 1.0950 | 0.6416 | 125 | 0.1457 | 115 | 0.1120 | 2 (body hook) |
| boxing_liver_combo | welter_b | 1.0550 | 0.6131 | 125 | 0.2585 | 116 | 0.1849 | 2 (body hook) |
| boxing_liver_combo | heavy_c | 1.1650 | 0.6773 | 125 | 0.1826 | 115 | 0.1343 | 2 (body hook) |
| boxing_liver_combo | heavy_d | 1.1500 | 0.6594 | 125 | 0.2569 | 116 | 0.1863 | 2 (body hook) |
| boxing_one_two_hook | welter_a | 0.8900 | 0.1167 | 59 | 0.3653 | 59 | 0.4038 | 1 (cross) |
| boxing_one_two_hook | welter_b | 0.8650 | 0.1116 | 59 | 0.3805 | 59 | 0.3867 | 1 (cross) |
| boxing_one_two_hook | heavy_c | 0.9350 | 0.1232 | 59 | 0.3807 | 59 | 0.4154 | 1 (cross) |
| boxing_one_two_hook | heavy_d | 0.9250 | 0.1200 | 59 | 0.3961 | 59 | 0.4103 | 1 (cross) |
| boxing_six_punch_combo | welter_a | 0.8900 | 0.4978 | 168 | 0.2535 | 171 | 0.2482 | 3 (rear uppercut) |
| boxing_six_punch_combo | welter_b | 0.8650 | 0.4757 | 168 | 0.2901 | 171 | 0.2368 | 3 (rear uppercut) |
| boxing_six_punch_combo | heavy_c | 0.9350 | 0.5255 | 168 | 0.2713 | 171 | 0.2538 | 3 (rear uppercut) |
| boxing_six_punch_combo | heavy_d | 0.9250 | 0.5116 | 168 | 0.2956 | 171 | 0.2482 | 3 (rear uppercut) |

Part boundaries are the same on all four rigs and in all three combinations (the splice clock is rig-independent):
part 0 = frames 1-41, part 1 = 42-80, part 2 starts at 81.

| combination | part | role | frames | net travel in part (welter_a / b / c / d, m) |
|-------------|------|------|--------|----------------------------------------------|
| liver | 0 | jab | 1-41 | 0.0000 / 0.0000 / 0.0000 / 0.0000 |
| liver | 1 | cross | 42-80 | +0.0370 / +0.0353 / +0.0390 / +0.0380 |
| liver | 2 | body hook | 81-230 | -0.0320 / -0.0306 / -0.0338 / -0.0329 |
| one_two_hook | 0 | jab | 1-41 | 0.0000 (all) |
| one_two_hook | 1 | cross | 42-80 | +0.0370 / +0.0353 / +0.0390 / +0.0380 |
| one_two_hook | 2 | lead hook | 81-158 | -0.0320 / -0.0306 / -0.0338 / -0.0329 |
| six_punch | 0 | jab | 1-41 | 0.0000 (all) |
| six_punch | 1 | cross | 42-80 | +0.0370 / +0.0353 / +0.0390 / +0.0380 |
| six_punch | 2 | lead hook | 81-129 | -0.0320 / -0.0306 / -0.0338 / -0.0329 |
| six_punch | 3 | rear uppercut | 130-183 | +0.4067 / +0.3887 / +0.4293 / +0.4180 |
| six_punch | 4 | lead hook | 184-232 | -0.3923 / -0.3749 / -0.4141 / -0.4032 |
| six_punch | 5 | cross | 233-312 | 0.0000 (all) |

---

## 4. Every part, alone (20 rows)

| part role | spacing it was measured at | travel_max (welter_a / b / c / d, m) | head_head_min (welter_a / b / c / d, m) |
|-----------|----------------------------|--------------------------------------|-----------------------------------------|
| boxing_jab | liver 1.0950 / 1.0550 / 1.1650 / 1.1500 | 0.0000 / 0.0000 / 0.0000 / 0.0000 | 0.8128 / 0.7965 / 0.8669 / 0.8656 |
| boxing_cross | liver 1.0950 / 1.0550 / 1.1650 / 1.1500 | 0.1167 / 0.1116 / 0.1232 / 0.1200 | 0.5808 / 0.5718 / 0.6213 / 0.6254 |
| boxing_body_hook | liver 1.0950 / 1.0550 / 1.1650 / 1.1500 | 0.6416 / 0.6131 / 0.6773 / 0.6594 | 0.1469 / 0.2601 / 0.1838 / 0.2589 |
| boxing_lead_hook | one_two_hook 0.8900 / 0.8650 / 0.9350 / 0.9250 | 0.0000 / 0.0000 / 0.0000 / 0.0000 | 0.7158 / 0.6902 / 0.7473 / 0.7367 |
| boxing_rear_uppercut | six_punch 0.8900 / 0.8650 / 0.9350 / 0.9250 | 0.4978 / 0.4757 / 0.5255 / 0.5116 | 0.2469 / 0.2865 / 0.2651 / 0.2912 |

---

## 5. Findings, in plain words

### 5.1 Which part transition produces the forward travel — none of them

The whole forward movement of a combination is one part's own lunge, and the part carries it alone. The
combination's `travel_max` against the same punch played by itself from the same guard lead-in:

| combination | rig | combo `travel_max` | the part, ALONE | difference |
|-------------|-----|--------------------|-----------------|------------|
| boxing_liver_combo | welter_a | 0.6416 m | boxing_body_hook 0.6416 m | 0.0000 |
| boxing_liver_combo | welter_b | 0.6131 m | boxing_body_hook 0.6131 m | 0.0000 |
| boxing_liver_combo | heavy_c | 0.6773 m | boxing_body_hook 0.6773 m | 0.0000 |
| boxing_liver_combo | heavy_d | 0.6594 m | boxing_body_hook 0.6594 m | 0.0000 |
| boxing_one_two_hook | welter_a | 0.1167 m | boxing_cross 0.1167 m | 0.0000 |
| boxing_one_two_hook | welter_b | 0.1116 m | boxing_cross 0.1116 m | 0.0000 |
| boxing_one_two_hook | heavy_c | 0.1232 m | boxing_cross 0.1232 m | 0.0000 |
| boxing_one_two_hook | heavy_d | 0.1200 m | boxing_cross 0.1200 m | 0.0000 |
| boxing_six_punch_combo | welter_a | 0.4978 m | boxing_rear_uppercut 0.4978 m | 0.0000 |
| boxing_six_punch_combo | welter_b | 0.4757 m | boxing_rear_uppercut 0.4757 m | 0.0000 |
| boxing_six_punch_combo | heavy_c | 0.5255 m | boxing_rear_uppercut 0.5255 m | 0.0000 |
| boxing_six_punch_combo | heavy_d | 0.5116 m | boxing_rear_uppercut 0.5116 m | 0.0000 |

A combination adds **no** forward travel of its own: it inherits the worst lunge of its parts. The parts sort into
three groups by how far they carry the man:

* **0.0000 m** — the jab and the lead hook. In-place takes (`hold_root_xz`); the hips never move down the line.
* **+3.5 to +3.9 cm net** — the cross (part 1 of every combination).
* **0.61-0.68 m peak** — the body hook (liver), **0.48-0.53 m peak** — the rear uppercut (six-punch). Those two are
  the whole story: they are the clips whose hips travel, and they travel the same distance alone.

### 5.2 …and the step is not the cause, because on this fixture no step is planned

`FightStagePlayer._plan_sequence_step` opens with

```gdscript
if sequence_receiver == null or _root == null or _skel == null or _legs.size() != 2 or sequence_receiver.skeleton() == null:
	return
```

The clip gate's clips mode never assigns `sequence_receiver` (only the live room does), so on the fixture the
certificates come from, `sequence_steps` stays empty and **no root shift is planned between the parts at all** —
read back as 0 on a live run, every frame. So the S135 hypothesis ("the steps between parts carry the attacker
forward into the receiver") cannot be what produces these numbers: there is nothing stepping. What carries the man
forward is the punch clip's own hips.

If the overlap the operator saw really comes from the live room's stepping path, this fixture cannot see it. The next
measurement (not this one) has to set `sequence_receiver` and `sequence_bodies` and run the same probe again.

### 5.3 The closest approach happens during a punch, never between two parts

`part_at_min` is 2 (body hook) for the liver combo, 1 (cross) for the 1-2-hook and 3 (rear uppercut) for the
six-punch, on all four rigs, and the frame is well inside the part:

| combination | frame of closest approach | the part's frames | how far into the part |
|-------------|---------------------------|-------------------|-----------------------|
| liver | 115 / 116 | 81-230 | 34-35 frames in |
| one_two_hook | 59 | 42-80 | 17 frames in |
| six_punch | 171 | 130-183 | 41 frames in |

The travel peaks sit on the same frames (125, 59, 168): the head is closest exactly when the hips are furthest
forward. No seam frame appears anywhere in the table.

### 5.4 Being in a combination changes the closest approach by millimetres

Where the SINGLE is measured at the same spacing as the combination (the body hook at the liver spacing, the
uppercut at the six-punch spacing), the combination and the lone punch agree to within 7 mm:

| rig | liver: combo vs body hook alone | six-punch: combo vs uppercut alone |
|-----|---------------------------------|------------------------------------|
| welter_a | 0.1457 vs 0.1469 (**-1.2 mm**) | 0.2535 vs 0.2469 (**+6.6 mm**) |
| welter_b | 0.2585 vs 0.2601 (**-1.6 mm**) | 0.2901 vs 0.2865 (**+3.6 mm**) |
| heavy_c | 0.1826 vs 0.1838 (**-1.2 mm**) | 0.2713 vs 0.2651 (**+6.2 mm**) |
| heavy_d | 0.2569 vs 0.2589 (**-2.0 mm**) | 0.2956 vs 0.2912 (**+4.4 mm**) |

(+) = the combination is *farther* away. The splice does not push the man deeper into the receiver.

The one large difference in the table is the SINGLE spacing rule, not the splice: the cross's SINGLE line is
measured at the liver combo's 1.095 m (the cross first appears there), 0.205 m farther out than the 1-2-hook's
0.890 m. Take the spacing out and the two agree — 0.5808 - 0.205 = 0.376 against the combination's 0.3653, ~1 cm.

### 5.5 The man never walks: his feet stay put and his hips lunge and come home

Sampled every 20 frames through `boxing_one_two_hook` the attacker's **root** stays exactly at its mounted position
while his hips travel 11.5 cm down the line and back. All of `travel_max` is the take's own hip motion, which is why
each part ends where it began (`travel_in_part` ~ 0 for the in-place clips, and the six-punch's closing cross reads
exactly 0.0000).

---

## 6. What this measurement does NOT say

* **Bone centres, not capsules.** `head_head_min` is `Head` bone to `Head` bone. With ~0.20 m of head capsule radius
  between the two men, a 0.15 m reading is real contact — but the 11.5 cm in the S135 report is a capsule *depth* and
  is not the same number. Turning this table into a gate verdict needs `FightBodyCapsules`; that is the clip gate's
  job, not this probe's.
* **No gloves, no skin.** The gate's `glove=1` arm measures the drawn glove; this probe measures bones only.
* **A still receiver.** He plays his guard and nothing else — no slip, no step, no shell.
* **`sequence_receiver` is null**, exactly as in the gate's clips mode (§5.2).
* **A SINGLE row carries no combo**: a role is measured at the spacing of the first combination containing it (§1).

---

## 7. Reproducing, and the engine noise in a bind

```sh
# the whole table: 12 rows + 48 part lines + 20 singles; ~9 min on 2 cores (4.7.2-stable official)
godot --headless --path Godot --script tools/q213h_combo_probe.gd -- quiet=1

# the gate on the instrument: welter_a vs welter_b, boxing_one_two_hook, plus the 0.20 m control
godot --headless --path Godot --script tests/q213h_combo_probe_test.gd

python Godot/tools/check_scripts.py tools/q213h_combo_probe.gd tests/q213h_combo_probe_test.gd
```

The test's control is what makes these numbers worth anything: with the receiver standing 0.20 m closer and nothing
else changed, the probe must report a **smaller** `head_head_min` — it does, 0.1659 m against 0.3653 m on welter_a.
An instrument that could not read worse would be decoration.

### The noise, said out loud

`FightStagePlayer.bind` on a generator body prints **102 `ERROR:` lines per body** that belong to the clip loader, not
to anything measured here: every role whose binding has no `retarget` flag is first handed to `GLTFDocument`
(`_load_clip_animation` -> `_load_glb`, `FightStagePlayer.gd:2578`), the .FBX bytes fail the glTF JSON parse, and the
engine prints `glTF: Error parsing .gltf JSON data` plus `Condition "err != OK" is true`. It is the same on the
official 4.7.2 build and it is in the project's own code, which this task may not edit. `tools/run_tests.py` calls a
test **FAILED** on any `ERROR:` line, so a test that binds a body cannot be green otherwise. The test therefore mutes
error printing **around the two `bind` calls only** (`Probe.mount_pair(..., quiet_bind)`; `Engine.set_print_error_messages`
is restored immediately after each bind) — the mount, the skin, the guard lead-in, the combination, the control and
every check run with error printing on, and every check in the test is a number it measured, never a log line. The
probe takes the same switch as `-- quiet=1`; off by default, so the plain run still shows everything.

Two smaller noises, both pre-existing and both harmless here: `_build_cert_lookup` prints 64 `WARNING: Exponent too
high` lines while parsing the c223 certificate JSONs (the gate's own function, on its own files), and Godot reports
`ObjectDB instances were leaked at exit` for the freed mount (a `WARNING`, in `run_tests.py`'s noise list).
