# R106 — PAIRED TWO-BODY ANIMATION SURVIVES THE TRIP TO GODOT

**The question nobody had answered for any paired pack, at any price, is answered,
and the answer is YES.**

`Full Mount Attacks` (RamsterZ, EUR 10.11, bought 2026-09-11) was downloaded
through the Unity Editor's Package Manager, extracted **without importing it**,
and audited from the files by `Godot/tools/audit_ramsterz_paired.gd`.

```
R106_AUDIT bones=69 exact=0/22 map_covers=22/22 paired=8 solo=0
```

## HOW IT WAS OBTAINED, because the route was itself a finding

The Unity storefront offers **only "Open in Unity"** — there has been no web
download for years — and Unity was not installed, which is why U46 correctly found
nothing on disk. Unity Hub + Editor `6000.6.0f1` were installed, the package pulled
from **Package Manager → My Assets** (5.97 MB, 80 files), and then:

**A `.unitypackage` IS A GZIPPED TAR.** `tar -xzf` yields 90 GUID-named folders,
each holding `asset`, `asset.meta` and `pathname`; `pathname`'s first line is the
real path. **Unity was needed only to FETCH the file and never to read it**, and
the Editor can be uninstalled now.

*(Trap for the next person: each `pathname` ends with a literal `00` line. `cat
pathname | sort` puts ninety `00`s at the top and hides every real name. Take
`head -1`.)*

## 1. THE MANIFEST, FROM FILENAMES RATHER THAN A STORE PAGE

**32 animation FBX files, in exact `_Att` / `_Vic` pairs — 16 pairs:**

| pair | what it is | empty hand? |
|---|---|---|
| `Takedown_DoubleLeg_Start` | **a standing double-leg shot** | yes |
| `Takedown_BodyLock_Start` / `_Loop` / `_End` | **a standing body-lock takedown, entry + hold + exit** | yes |
| `H2H_Punches` | **ground and pound** | yes |
| `H2H_ArmBar` | **an armbar** | yes |
| `H2H_Strangle` | **a choke** | yes |
| `H2H_HeadSmash` | ground strike | yes |
| `Reversal` | **the sweep — they swap positions** | yes |
| `VictimAttack` | **the bottom man attacking** | yes |
| `AttackBlock` | **the bottom man blocking** | yes |
| `PushOff` | disengage | yes |
| `1HM_AxeToFace`, `1HM_BluntSmack`, `1HM_KnifeStab`, `1HM_SlashNeck` | weapons | **no — 4 of 16** |

Plus `T_pose.fbx` (the rest reference), `Android_SkeletalMesh.fbx` (the rig) and
three prop meshes.

**THE STORE DESCRIPTION UNDERSELLS IT, and that is the U42 lesson inverted.**
"8 Empty Hand Attacks / 8 Melee Weapon Attacks" reads as half weapons. In the files
**12 of 16 pairs are empty-hand**, because the takedown entries, the reversal, the
push-off, the victim's block and the victim's counter are all unarmed and none of
them is an "attack". **And it is not mount-only**: `Takedown_DoubleLeg_Start` and
`Takedown_BodyLock_Start` are standing entries, which is the rung R91/R92/R93 needed
and C75 said did not exist.

## 2. THE BONE COST — PREDICTED 0/22, MEASURED 0/22, AND THE MAP IS CONFIRMED

The clips are **mesh-free**, so Godot imports a plain `Node3D` hierarchy and **not**
a `Skeleton3D` — **exactly R94's case**, where integration was a track-path rewrite.
(Reading `Skeleton3D.get_bone_count()` therefore returns 0 and means nothing; walk
the node tree.)

69 nodes, and the hierarchy is the UE4 Mannequin verbatim: `root · pelvis ·
spine_01..03 · clavicle_l/r · upperarm_l/r · lowerarm_l/r · hand_l/r · five finger
chains · twist bones · neck_01 · head · thigh_l/r · calf_l/r · foot_l/r · ball_l/r ·
ik_foot_root · ik_hand_root · ik_hand_gun`.

| | value |
|---|---|
| exact name matches against our 22 | **0 of 22** |
| **our 22 reached through the derived map** | **22 of 22** |
| path-only graft, R94 style | drives **0** bones |
| **through the 22-row map** | drives **22 of 22** |

**The map derived in R105 from published bone lists is confirmed against the real
file: all 22 rows present, none missing.** It is written once and serves every
RamsterZ pack.

## 3. THE GATE QUESTION: DOES PAIRED ROOT ALIGNMENT SURVIVE? — YES, 8 OF 8

`root/pelvis` position sampled on both halves of eight pairs. **Z is up** in these
files (FBX Z-up is preserved, so an import rotation is needed — trivial). Units are
metres: a standing pelvis reads 0.913.

```
H2H_Punches        Att pelvis z 0.411   Vic 0.127   (mount: attacker ON TOP)
Takedown_DoubleLeg Att 0.913 -> 0.411   Vic 0.919 -> 0.127   (both START STANDING, end grounded)
Takedown_BodyLock  Att 0.913 -> 0.411   Vic 0.913 -> 0.127
Reversal           Att 0.411 -> 0.127   Vic 0.127 -> 0.411   ** THEY SWAP **
H2H_ArmBar         Att 0.411 -> 0.913   Vic 0.127 -> 0.175   (attacker rises to finish)
```

**`Reversal` is the proof on its own.** The attacker descends 0.411 → 0.127 while
the victim rises 0.127 → 0.411, in the same clip pair. **Two files, authored in one
shared coordinate space, exchanging positions.** That cannot happen by accident and
cannot happen in two independently-authored solo clips.

**And the moving clips carry complementary ROOT motion too.** On
`Takedown_DoubleLeg_Start` the `root` node itself is animated:

```
Att root  (0, 0, 0) -> (-0.090, 0, 2.019)      drives FORWARD
Vic root  (0, 0, 0) -> ( 0.088, 0, -0.903)     driven BACKWARD
```

Opposite directions along one axis, in one shared space. `H2H_Punches` has **no**
root track at all, which is correct — a stationary mount needs none, and the
vertical stacking does the work.

**Pairs with distinct, complementary roots: 8. Pairs collapsed to one origin: 0.**

## WHAT THIS OVERTURNS

**C75 concluded from ARCHITECTURE that paired, contact-matched two-body animation
had zero verified instances at any source at any price**, and that a ground fight
therefore needed purpose-shot two-performer capture. The operator refused that
answer twice — first by rejecting "exactly ONE is grappling", then by paying EUR
10.11 to settle it with a file.

**It is now disproven with measurements, not with a listing.** This is the first
verified instance anywhere in this project of paired two-body animation surviving
extraction and import with its relative transforms intact.

M19's and C75's *presentation* ruling is untouched — the ground game is still
PRESENTED rather than simulated — but the reason given for it ("the data does not
exist") is gone.

## WHAT IT COSTS TO USE, IN ORDER

1. **A 22-row `BoneMap`** against `SkeletonProfileHumanoid`. Written once, reused by
   every RamsterZ pack. Confirmed complete here.
2. **A rest-pose correction.** The UE4 Mannequin is an **A-pose**; our profile rest
   is a **T-pose**. `T_pose.fbx` ships in the pack and is the reference for it.
   Godot's importer has `retarget/rest_fixer` for exactly this. **Still unmeasured —
   this is now the top open question.**
3. **An up-axis rotation**, Z-up to Y-up. Trivial.
4. **Placing the pair.** The engine already knows where both fighters are; mount the
   two clips at one shared transform rather than at each fighter's own mark, or the
   relative alignment that survived all the way here is thrown away at the last step.

## WHAT TO BUY NOW, AND WHERE

The gate that was holding the siblings is cleared. **`Hand to Hand Set`** —
Defense/Block 8, Slip/Fade 3, Dodge 4, 16 punches, 20 kicks, 16 staggers, 3
knockdown/get-up — is now the obvious next purchase, and it answers Q46's receiver
demand directly (`react_head` 56.9% of shown beats, and we own nothing).

**BUY IT ON THE UNITY ASSET STORE (EUR 41.39), NOT DIRECT ($25.99).** R105's
addendum 2: the direct sale binds you to RamsterZ's own EULA with its **explicit
prohibition on AI use**, which collides with R104 (Ludo). The Unity copy is
Standard Unity EULA. **The $16 saved buys a worse licence.**

**STANDING CONSTRAINT: never pass a RamsterZ clip to Ludo or any generator as a
reference, seed or input.** Play it, retarget it, edit it in Blender — all
permitted.

## Reproduce

```
Godot_v4.7.2-stable_win64_console.exe --headless --path Godot \
    --script tools/audit_ramsterz_paired.gd
```

Binaries live in `Godot/assets/anim/audition/ramsterz/` and are gitignored by U46's
rule — the report and the tool ship, the pack never does.
