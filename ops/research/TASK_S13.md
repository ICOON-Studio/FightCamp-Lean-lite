# TASK_S13 — THE CLIP ROW: BIND THE VOCABULARY WE ALREADY OWN

Owner: Claude. Model: Opus, HIGH effort, Fast OFF.
Greenlit by the operator 2026-09-18 ("Go 2") off `now`'s OPTION 2.

## THE STAGE IN ONE SENTENCE

S9's **CLIP** row is 101,277 degraded beats — 73.2% of all degrades, 30.2% of
all action beats — and a large part of it is **the Thai name for a move we
already own a film of**, so it costs a table entry rather than a purchase.

## WHAT IS ALREADY SETTLED AND MUST NOT BE RE-OPENED

- **The teep family is a PURCHASE, on evidence.** S6b rendered
  `H2H_HighSideKick_InPlace` and it is a textbook side kick; the pack contains
  no push or front kick at all. `muay_thai_teep`, `kickboxing_teep`,
  `kickboxing_front_kick`, `muay_thai_jab_teep_switch` stay unbound.
- **Both uppercuts and the horizontal elbow stay unbound (R127).** The only
  uppercut film renders as a knee lift; the only elbow film is a SPINNING
  elbow that arrives behind the fighter. `muay_thai_mat_soei` (Uppercut) and
  `muay_thai_sok_phung` inherit those refusals.
- **A clip whose own name is a DIFFERENT move is the M19 lie** — but one clip
  serving several ids is not, when the id and the film are the same move
  (`FightClipBinding.gd:434-438`).

## THE MECHANISM, AND WHY IT IS AN ALIAS AND NOT A BINDING

`FightBeatAdapter._clip_role_for` (`:862`) asks `FightClipBinding.has_clip`
under the RAW id first, then `TECHNIQUE_CLIP_ALIASES`. Either path sets
`beat.has_clip`, so either counts as **EXACT** in S9's split — this is NOT
`FightStagePlayer.NEAREST_CLIP`, which shows a DIFFERENT move and is the
substitute row.

An alias is the right instrument here because every id in scope resolves to a
role that is **already grafted**. A second BINDINGS key holding the same path
would duplicate metadata that can drift, and would also have to be added by
hand to `FightClipBinding.technique_roles()` (`:1124`) — a hardcoded ORDER
list. **A BINDINGS key outside `bound_roles()` + `punch_roles()` +
`technique_roles()` makes `has_clip` true and NEVER PLAYS** (the R103 defect,
named at `FightClipBinding.gd:423-431`). That trap is this task's one blind
spot and the new test exists to close it.

## OWNED FILES

- `Godot/scripts/FightBeatAdapter.gd` — `TECHNIQUE_CLIP_ALIASES` (`:159`)
- `Godot/scripts/FightClipBinding.gd` — `BINDINGS` (`:25`), `technique_roles`
  (`:1124`), only if a newly watched film is accepted
- `Godot/tools/audit_unbound_contact_sheets.gd` — `SOLOS` (`:85`), solo stitch
  (`:501`) writes to `OUT_DIR` and must honour `spec.out` as the pair path does
- `Godot/tools/measure_technique_demand.gd` — `:20` keeps its own copy of the
  three aliases; it must read the real table or it under-counts from now on
- `Godot/tests/fight_clip_alias_test.gd` — NEW
- `research/S13_CLIP_ROW.md`, `research/S13_SHEETS/` — NEW

## WATCH THE FILM, THEN BIND IT

Three films have never been rendered and one has. Nothing below is bound
before its sheet is looked at.

| film | for | length |
|---|---|---|
| `H2H_KneeStrike_Forward.FBX` | CONTROL — already serves `muay_thai_straight_knee`; decides the four `khao_*` ids | 0.90 |
| `H2H_AxeKick_InPlace.FBX` | `muay_thai_te_khao` (Axe Heel Kick), 4,782 beats | 1.00 |
| `H2H_SpinningHookKick_InPlace.FBX` | `kickboxing_hook_kick`, 2,805 beats — expect the R127 spin refusal | 0.80 |
| `H2H_LowSideKick_InPlace.FBX` | `muay_thai_thip_khang` (Sideways Foot-Thrust), 3,072 beats — S6b's sheet already exists, re-read it | 1.17 |

```
xvfb-run -a -s "-screen 0 480x620x24" godot --path Godot \
  --script tools/audit_unbound_contact_sheets.gd \
  --resolution 480x620 --rendering-driver opengl3 -- KneeStrike AxeKick SpinningHookKick
```

## THE CANDIDATE TABLE — catalogue name is the evidence, not the id

Every row is `technique_catalog.json`'s own `name` for the id.

| id | catalogue name | beats | target |
|---|---|---:|---|
| `muay_thai_mat_yaep` | Mat Yaep (Jab) | 3,027 | `jab` |
| `muay_thai_mat_trong` | Mat Trong (Cross) | 4,668 | `cross` |
| `muay_thai_mat_wiang_san` | Mat Wiang San (Hook) | 3,559 | `hook_lead` |
| `muay_thai_mat_wiang_yao` | Mat Wiang Yao (Overhand) | 4,747 | `boxing_overhand` |
| `muay_thai_switch_kick` | Switch Kick | 3,139 | `muay_thai_switch_kick_body` |
| `muay_thai_body_kick` | Body Kick | 3,028 | `kickboxing_body_kick` |
| `muay_thai_te_chiang` | Te Chiang (Diagonal Kick) | 3,126 | round kick |
| `muay_thai_low_kick` | Low Kick | 3,053 | `kickboxing_low_kick` |
| `muay_thai_te_kot` | Te Kot (Down Roundhouse) | 3,020 | `kickboxing_low_kick` |
| `muay_thai_khao_chiang` | Khao Chiang (Diagonal Knee) | 4,800 | knee, PENDING THE SHEET |
| `muay_thai_khao_khong` | Khao Khong (Curving Knee) | 4,762 | knee, PENDING THE SHEET |
| `muay_thai_khao_ti` | Khao Ti (Knee Slap) | 4,763 | knee, PENDING THE SHEET |
| `muay_thai_khao_tat` | Khao Tat (Horizontal Knee) | 4,743 | knee, PENDING THE SHEET |

A row that the sheet does not support is REFUSED and the refusal is written
into the table with its cost in beats, R127-style.

## GATE (tier: a script edited)

```
python Godot/tools/check_scripts.py Godot/scripts/FightBeatAdapter.gd \
  Godot/scripts/FightClipBinding.gd Godot/tools/measure_technique_demand.gd \
  Godot/tools/audit_unbound_contact_sheets.gd Godot/tests/fight_clip_alias_test.gd
godot --headless --path Godot --script tests/fight_clip_alias_test.gd
python Godot/tools/run_tests.py --only clip
python Godot/tools/run_tests.py --only beat
```
Then the FULL SUITE ONCE: `python Godot/tools/run_tests.py --timeout 2400 --jobs 3`,
**fails=6 or better as a CEILING**, and the failing FILENAMES must match
`AgentComms/last_suite.json` name for name. THREE jobs, not four (`nproc` is 4).

## THE NUMBER THIS STAGE IS JUDGED ON

Re-run `Godot/tools/measure_presentation_split.gd` and report the CLIP row
before and after. Report `measure_technique_demand.gd`'s coverage beside its
unchanged 59.0% ceiling. **Report the beats that are still a purchase**, or the
stage reads as finished when it is not.
