# R141 — S4a: WHY THE BOUGHT CLIPS LOOK BAD

Owner: claude. Stage B. **Moved ahead of S1f (3) and S2b by the operator on 2026-09-13**, so
the four held animation packs (R142's H1–H4, EUR 114.05 at list) can be judged while the
Unity sale that opens 2026-09-14 is still on.

## The question

The operator watched the retargeted RamsterZ clips in the Animation Lab
(`res://scenes/FightAnimLab.tscn`) and said they look "pretty bad". `FightClipRetarget`
reports itself as working — R108 measured **FIXED mean 7.21° / max 19.64°** over nine joints
against 31.77° / 136.99° uncorrected — but that was ONE clip (`H2H_HitReaction01`), ONE body
(f01) and NINE samples. Nobody has measured the rest, and nobody has put the source next to
the result and looked.

**The decision it feeds:** is the ugliness in the RETARGET (fixable in code, so more clips
from the same UE4-Mannequin source are worth buying) or in the BODY (Tripo auto-rig
skinning — no clip purchase fixes it)?

## Four causes, four different fixes

| # | Cause | What it looks like | Fix | What already bears on it |
| --- | --- | --- | --- | --- |
| 1 | Residual per-bone axis correction | joints bend the wrong way, a limb twisted | cheap, in `BoneRestFixer` | R108: largest correction 177.6° (RightToes); hip_l 19.64° against a 7.40° floor, asymmetric with hip_r 1.31° |
| 2 | Proportion mismatch — rotations only, no IK | punches short or through the head, hands in the torso, feet through the floor | IK, not calibration | C99: source arm/height .352 vs fighters ~.32 (reach 2–5 cm short); forearm/upper-arm .84–1.24 against the source's .89 |
| 3 | Root motion and position tracks | feet slide, no weight, the body floats or sinks | locomotion wiring | C94: in-place clips carry bob only; `*_RootMotion` variants carry the travel; f06 and f08 are 1.00 m meshes (C98) |
| 4 | Tripo auto-rig skinning weights | shoulders and hips collapse, the mesh pinches | the MODEL — nothing else fixes it | C98: elbows/knees 23–38% rigidly bound, shoulders bleed 6–11% |

And one thing that is NOT the cause any more: the hard cut. R120 (`64210cd`) added a uniform
0.10 s crossfade from G57 (`G57_THE_BLEND_LENGTH.md`); judge one clip in isolation before a
sequence, so the retarget and the cut are never blamed for each other.

## How S4a separates them

1. **Pictures (U81, Cursor).** One sheet per clip and body, three panels per frame: the
   SOURCE skeleton, the RETARGETED skeleton, the RETARGETED MESH. Panel 1 vs 2 is the
   retarget (causes 1–3). Panel 2 vs 3 is the skin (cause 4). Six clips across f01, f02 and
   f06.
2. **Numbers (C100, Codex).** R108's own joint-angle metric on every frame of every bound
   RamsterZ clip on all twelve bodies, plus reach and floor contact — after the instrument
   reproduces R108's 7.21° / 19.64° on R108's own sampling.
3. **The engine's own retargeter (Q82, Qwen).** Godot 4.7 imports a humanoid clip through a
   `BoneMap` onto `SkeletonProfileHumanoid` with a rest fixer and a silhouette fixer. Is
   `FightClipRetarget` a re-implementation of that, what does the engine do that ours does
   not, and the exact recipe to A/B the two on one clip.
4. **Outside practice (K28, Kalli).** What shipped games do about one clip on bodies of
   different size, and whether weight classes make most of it moot. (Sending it failed on
   2026-09-13; see the handover.)

## Then, in the S4a session

Look at U81's sheets first — the operator's judgement was visual and the diagnosis must be
too. Take C100's worst rows to the Lab. If panel 2 already looks wrong, run Q82's A/B on the
worst clip. If panel 2 looks right and panel 3 does not, it is the skin: say so plainly, and
the held packs are NOT the fix. Send the operator the before/after sheets
(`SendUserFile`) — the verdict on "looks bad" is theirs.

**And the control the store gives us for free, if the operator buys it:** the Mixall bundle's
20 Fighters are hand-rigged, hand-skinned bodies. The same RamsterZ clip on one of them
isolates cause 4 against a body that is not Tripo's (R142).
