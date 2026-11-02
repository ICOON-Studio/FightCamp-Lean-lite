# C91 - What the thirty-two paired clips actually contain

## Finding

The directory contains **32 FBX files forming 16 complete `_Att` / `_Vic`
pairs**. Their Animation resources report **78.267 s of total file length** but
contain **73.600 s of keyed content**, leaving **4.667 s of total dead air**.
All of that dead air belongs to the two
`Paired_FullMount_Takedown_BodyLock_End` halves. They tie for worst offender:
`Paired_FullMount_Takedown_BodyLock_End_Att.fbx` and
`Paired_FullMount_Takedown_BodyLock_End_Vic.fbx` each report 4.833 s of file for
2.500 s of content, with **2.333 s dead air**.

All 16 pairs agree on content length within 0.001 s. No clip has zero keys or is
unreadable.

## Method

Run from the repository root:

```text
Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tools/audit_paired_content.gd
```

The audit loads each FBX directly with `FBXDocument`, finds its first Animation,
then visits every track and reads every key time with
`Animation.track_get_key_time()`. `FIRST key t` and `LAST key t` are the minimum
and maximum key times across all keyed tracks. **CONTENT length is `LAST - FIRST`,
not `Animation.length`.** Dead air is file length minus content length.

`travelling?` is yes when the axis-aligned span of all keyed `root/pelvis`
position values exceeds 0.1 m, matching the earlier audit threshold. `bones
moved` counts the distinct UE4 Mannequin bone rows, from the project's 22
humanoid-row mapping, that have at least one key. No animated skeleton pose is
queried.

## Per-clip measurements

| clip | role | file length (s) | FIRST key t (s) | LAST key t (s) | CONTENT length (s) | dead air (s) | travelling? | bones moved |
|---|---:|---:|---:|---:|---:|---:|:---:|---:|
| Paired_FullMount_1HM_AxeToFace_Att.fbx | Att | 2.667 | 0.000 | 2.667 | 2.667 | 0.000 | yes | 21 |
| Paired_FullMount_1HM_AxeToFace_Vic.fbx | Vic | 2.667 | 0.000 | 2.667 | 2.667 | 0.000 | no | 21 |
| Paired_FullMount_1HM_BluntSmack_Att.fbx | Att | 1.333 | 0.000 | 1.333 | 1.333 | 0.000 | yes | 21 |
| Paired_FullMount_1HM_BluntSmack_Vic.fbx | Vic | 1.333 | 0.000 | 1.333 | 1.333 | 0.000 | no | 21 |
| Paired_FullMount_1HM_KnifeStab_Att.fbx | Att | 2.667 | 0.000 | 2.667 | 2.667 | 0.000 | yes | 21 |
| Paired_FullMount_1HM_KnifeStab_Vic.fbx | Vic | 2.667 | 0.000 | 2.667 | 2.667 | 0.000 | no | 21 |
| Paired_FullMount_1HM_SlashNeck_Att.fbx | Att | 1.333 | 0.000 | 1.333 | 1.333 | 0.000 | no | 20 |
| Paired_FullMount_1HM_SlashNeck_Vic.fbx | Vic | 1.333 | 0.000 | 1.333 | 1.333 | 0.000 | no | 21 |
| Paired_FullMount_AttackBlock_Att.fbx | Att | 1.333 | 0.000 | 1.333 | 1.333 | 0.000 | yes | 21 |
| Paired_FullMount_AttackBlock_Vic.fbx | Vic | 1.333 | 0.000 | 1.333 | 1.333 | 0.000 | no | 21 |
| Paired_FullMount_H2H_ArmBar_Att.fbx | Att | 4.467 | 0.000 | 4.467 | 4.467 | 0.000 | yes | 21 |
| Paired_FullMount_H2H_ArmBar_Vic.fbx | Vic | 4.467 | 0.000 | 4.467 | 4.467 | 0.000 | yes | 21 |
| Paired_FullMount_H2H_HeadSmash_Att.fbx | Att | 1.500 | 0.000 | 1.500 | 1.500 | 0.000 | yes | 21 |
| Paired_FullMount_H2H_HeadSmash_Vic.fbx | Vic | 1.500 | 0.000 | 1.500 | 1.500 | 0.000 | no | 21 |
| Paired_FullMount_H2H_Punches_Att.fbx | Att | 1.167 | 0.000 | 1.167 | 1.167 | 0.000 | yes | 21 |
| Paired_FullMount_H2H_Punches_Vic.fbx | Vic | 1.167 | 0.000 | 1.167 | 1.167 | 0.000 | yes | 21 |
| Paired_FullMount_H2H_Strangle_Att.fbx | Att | 6.000 | 0.000 | 6.000 | 6.000 | 0.000 | yes | 21 |
| Paired_FullMount_H2H_Strangle_Vic.fbx | Vic | 6.000 | 0.000 | 6.000 | 6.000 | 0.000 | yes | 20 |
| Paired_FullMount_PushOff_Att.fbx | Att | 2.667 | 0.000 | 2.667 | 2.667 | 0.000 | yes | 21 |
| Paired_FullMount_PushOff_Vic.fbx | Vic | 2.667 | 0.000 | 2.667 | 2.667 | 0.000 | yes | 21 |
| Paired_FullMount_Reversal_Att.fbx | Att | 1.833 | 0.000 | 1.833 | 1.833 | 0.000 | yes | 21 |
| Paired_FullMount_Reversal_Vic.fbx | Vic | 1.833 | 0.000 | 1.833 | 1.833 | 0.000 | yes | 21 |
| Paired_FullMount_Takedown_BodyLock_End_Att.fbx | Att | 4.833 | 2.333 | 4.833 | 2.500 | 2.333 | yes | 21 |
| Paired_FullMount_Takedown_BodyLock_End_Vic.fbx | Vic | 4.833 | 2.333 | 4.833 | 2.500 | 2.333 | yes | 21 |
| Paired_FullMount_Takedown_BodyLock_Loop_Att.fbx | Att | 1.667 | 0.000 | 1.667 | 1.667 | 0.000 | no | 17 |
| Paired_FullMount_Takedown_BodyLock_Loop_Vic.fbx | Vic | 1.667 | 0.000 | 1.667 | 1.667 | 0.000 | no | 16 |
| Paired_FullMount_Takedown_BodyLock_Start_Att.fbx | Att | 2.333 | 0.000 | 2.333 | 2.333 | 0.000 | yes | 21 |
| Paired_FullMount_Takedown_BodyLock_Start_Vic.fbx | Vic | 2.333 | 0.000 | 2.333 | 2.333 | 0.000 | yes | 21 |
| Paired_FullMount_Takedown_DoubleLeg_Start_Att.fbx | Att | 1.667 | 0.000 | 1.667 | 1.667 | 0.000 | yes | 21 |
| Paired_FullMount_Takedown_DoubleLeg_Start_Vic.fbx | Vic | 1.667 | 0.000 | 1.667 | 1.667 | 0.000 | yes | 21 |
| Paired_FullMount_VictimAttack_Att.fbx | Att | 1.667 | 0.000 | 1.667 | 1.667 | 0.000 | no | 21 |
| Paired_FullMount_VictimAttack_Vic.fbx | Vic | 1.667 | 0.000 | 1.667 | 1.667 | 0.000 | no | 21 |

## Pair agreement

| pair | Att content (s) | Vic content (s) | agree? |
|---|---:|---:|:---:|
| Paired_FullMount_1HM_AxeToFace | 2.667 | 2.667 | yes |
| Paired_FullMount_1HM_BluntSmack | 1.333 | 1.333 | yes |
| Paired_FullMount_1HM_KnifeStab | 2.667 | 2.667 | yes |
| Paired_FullMount_1HM_SlashNeck | 1.333 | 1.333 | yes |
| Paired_FullMount_AttackBlock | 1.333 | 1.333 | yes |
| Paired_FullMount_H2H_ArmBar | 4.467 | 4.467 | yes |
| Paired_FullMount_H2H_HeadSmash | 1.500 | 1.500 | yes |
| Paired_FullMount_H2H_Punches | 1.167 | 1.167 | yes |
| Paired_FullMount_H2H_Strangle | 6.000 | 6.000 | yes |
| Paired_FullMount_PushOff | 2.667 | 2.667 | yes |
| Paired_FullMount_Reversal | 1.833 | 1.833 | yes |
| Paired_FullMount_Takedown_BodyLock_End | 2.500 | 2.500 | yes |
| Paired_FullMount_Takedown_BodyLock_Loop | 1.667 | 1.667 | yes |
| Paired_FullMount_Takedown_BodyLock_Start | 2.333 | 2.333 | yes |
| Paired_FullMount_Takedown_DoubleLeg_Start | 1.667 | 1.667 | yes |
| Paired_FullMount_VictimAttack | 1.667 | 1.667 | yes |

## Totals

- Total file seconds: **78.267 s**
- Total content seconds: **73.600 s**
- Total dead-air seconds: **4.667 s**
- Worst single dead-air offender: **Paired_FullMount_Takedown_BodyLock_End_Att.fbx**, tied with its `_Vic` half at **2.333 s** each
- Pair duration disagreements: **0 of 16**
