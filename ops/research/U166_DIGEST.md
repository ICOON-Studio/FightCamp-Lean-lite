# U166 digest — kick/knee effector = peak hips-relative speed (not plant-foot displacement)

## Tagger (`q167_tag_clip_phases.gd`)

Kick/knee clips: effector = candidate with highest **hips-relative** peak speed in that limb’s **load→contact** window (same start/contact walk as phase tagging). Per clip: prints both feet/knees peaks and choice.

**28 effectors changed** (mostly `LeftFoot`→`RightFoot` on roundhouse-family vendor takes; a few reversals on side/spinning clips). Example:

| clip | was | now | peaks (m/s) |
| --- | --- | --- | --- |
| `kickboxing_body_kick` | LeftFoot | **RightFoot** | L=10.95 R=23.87 |

Regenerated `assets/data/clip_phases.json`.

## Censuses (OLD = U164/U165 digests on pre-U166 tags; NEW = re-run on new JSON)

| Metric | U164 OLD | U164 NEW | U165 OFF OLD | U165 OFF NEW | U165 ON OLD | U165 ON NEW |
| --- | ---: | ---: | ---: | ---: | ---: | ---: |
| Clips under / flagged | 46 flagged | **56** flagged | **17** under floor | **28** | **10** | **23** |
| Worst shortfall | jab_lowkick **9** f | kickboxing_spinning_hook **8** f | (same) | (same) | | |
| `kickboxing_body_kick` | unflagged (plant foot) | **FLAG** RightFoot **24.30** m/s, tempo **0.700** | (plant onset) | onset **0.028** s, **4.2** f played, short **5** | | |

U165 **warp contact wall** changes for U166-retagged roles when `readable_onset` ON (e.g. `kickboxing_jab_lowkick` OFF **1.33** s vs ON **0.67** s); `contact_s` anchor checks still pass.

## Overhand fist speed (`boxing_overhand`, catalog `RightHand`)

| frame | peak m/s |
| --- | ---: |
| vendor **world** | **38.90** |
| vendor **hips-relative** | **28.19** |

World peak still >> literature; hips-relative removes much root travel but remains implausible as a hand speed — report only (S65).

## Tempo floor

`HUMAN_SPEED_TEMPO_MIN` was **0.25** (clips could play at quarter speed). **Clamped to 0.5** in `FightStagePlayer.gd`; flagged rows now show `tempo=0.500` when `lit_max/vendor_peak` would go lower (e.g. overhand).

## Gate

- `check_scripts.py` on touched `.gd`
- `run_tests.py --only fight_strike` → **total=3 fails=0**
- `run_tests.py --only fight_readable_onset` → **total=1 fails=0**
- `run_tests.py --only fight_human_speed` → **total=1 fails=0**
- `run_tests.py --only fight_stage` → **total=10 fails=1** (known `fight_stage_realism_test` ceiling)
