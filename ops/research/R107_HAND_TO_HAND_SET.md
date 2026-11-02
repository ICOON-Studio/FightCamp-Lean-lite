# R107 — `HAND TO HAND SET`, AND THE RECEIVER GAP IS CLOSED

Bought 2026-09-11 on the **Unity Asset Store** (correct store — see R105 addendum 2),
downloaded through Package Manager, extracted **without importing** and audited
from the files.

| | |
|---|---|
| package | 14,843,754 bytes, 253 files |
| **animation FBX** | **124** |
| rig | **UE4 Mannequin, 69 nodes — identical to `Full Mount Attacks`** |
| **our 22 reached through the R105 map** | **22 of 22** |
| price | **EUR 36.79** on the publisher page — the purchase table had been carrying EUR 41.39 since C75 |

**One `BoneMap` serves both packs, and every other RamsterZ pack.** Confirmed on
four clips spanning reaction, block, punch and idle: all 69 nodes, all 22/22.

## THE REASON IT WAS BOUGHT: Q46's RECEIVER GAP, AND IT IS COVERED

Q46 measured that the receiver's reaction is asked for **143 times across 148
action beats** and we owned **zero** reaction clips; `react_head` + `react_body`
are **94.0% of all receiver demand**. R103 shipped M19's degrade as a literal rest
pose because **nothing owned an `idle`**.

| Q46 / R102 role | clips in this pack |
|---|---|
| `react_head` / `react_body` | **`HitReaction01`–`04`** (4) |
| `block` | **`BlockStart` / `BlockLoop` / `BlockEnd` / `BlockIdle`** + leg-block variants (8) |
| `slip` | **`SlipLeft`, `SlipRight`, `FadeBack`** (3) |
| evade / dodge | **`Dodge_Back` / `_Forward` / `_Left` / `_Right`** (4) |
| `knockdown` | **`KnockDown01`, `KnockDown02`**, and **`GetUp01`** (3) |
| **`idle`** | **`H2H_Idle` (4.67 s)**, plus `BlockIdle` |
| stagger (extra) | **16** |

**`BlockStart` / `Loop` / `End` is the shape R102's guard actually wants** — a
guard is held, not flashed, and the three-part split matches how `guard_select`
chooses a guard that persists.

**And the defensive clips are IDIOM-NEUTRAL, which is the point.** A block is a
block and a hit reaction is a hit reaction; there is no stylistic claim in them to
be wrong about.

## THE IDIOM PROBLEM IS REAL — AND IT LIVES IN THE ATTACKS

U46 warned that RamsterZ is an action-game publisher. In the filenames:
`BackflipKick`, `BarrelRollKick`, `FrontflipKick`, `JumpSpinHookKick`,
`TrippleSpinningHookKick`, `FlipAxeKick`, `JumpingUppercut`, `GroinPunch`. **Those
are martial-arts-movie moves, not MMA**, and 18 of the clips are kicks of that
family.

**Buy it for the defence. The attacks are a bonus with a filter on them.**

What DOES map onto Q45's named techniques:

| our technique | clip | note |
|---|---|---|
| `boxing_jab` | **`JabInPlace` (0.83 s)**, `JabForward` | a real single jab |
| `boxing_cross` | `StraightPunchInPlace`, `StraightPunchForward` | a straight IS the cross — a naming judgement, not a substitution |
| `boxing_lead_hook` / `boxing_body_hook` | `HookPunch_InPlace` | |
| `boxing_lead_uppercut` | `LeadingUppercut_InPlace` | |
| `boxing_overhand` | `Haymaker_InPlace` / `_Forward` | plausible; needs an eye |

**`JabInPlace` is 0.83 s.** Our only owned punch is a **2.47 s combination** that
U40 had to slice into windows by hand and U42 then found was three RIGHT hands that
never alternate (`kind=single_hand_drill`). **This pack ships the unit G42 asked for
as authored clips**, and the `_InPlace` / `_Forward` split is exactly the
distinction the engine needs — the fight positions the fighters, so `_InPlace` is
the variant a beat should play.

## THE PAIRED FAMILY IS DELIBERATE

The pack's own description names it:

> "Looking for paired animations/finishers that work with this set? Check out our
> Hand to Hand Finishers Volumes 1 and 2, Hand to Hand Non-Lethal Counters, Brutal
> Finishers - Hand and Knife, and **Full Mount Attacks** animation packs."

So `Full Mount Attacks` — which R106 proved keeps its paired root alignment through
extraction and import — is **authored to interoperate with this set on the same
rig**. The standing vocabulary and the paired ground vocabulary are one family, not
two purchases that happen to share a publisher.

## WHAT IS STILL UNMEASURED

1. **THE REST POSE. Still the top open question.** UE4 Mannequin is an **A-pose**;
   `SkeletonProfileHumanoid` rest is a **T-pose**. `Full Mount Attacks` ships
   `T_pose.fbx` as the reference; Godot has `retarget/rest_fixer`. **Nothing has
   been retargeted onto f01 yet — only the name coverage is proven.**
2. **Whether the clips read as MMA once retargeted.** The defensive set should; the
   flip-kicks will not.
3. **`_Forward` variants carry root motion.** The engine owns translation
   (R82/G42), so `_InPlace` is almost certainly the right variant for a beat, and
   `_Forward` would fight the engine for control of position. Decide it explicitly
   rather than by accident.

## THE PURCHASE POSITION NOW

| source | cost | verdict |
|---|---|---|
| **RamsterZ `Full Mount Attacks`** | EUR 10.11 **owned** | **paired ground, PROVEN (R106)** |
| **RamsterZ `Hand to Hand Set`** | EUR 36.79 **owned** | **the receiver vocabulary, and the punch unit** |
| RamsterZ `Dodge and Evade Anims` | **EUR 7.35** | cheapest unexamined thing aimed at R102's evade; read its manifest first |
| RamsterZ `Martial Arts Master` | EUR 45.99 | R105 — hold; lane counts, not clip names. 50% sale from 09-14 |
| Mixamo | free | **still unaudited — Adobe 403, needs an operator session** |
| Motifect | free | audited: 9/22, 13-row map, **zero punches, zero paired** |

**STANDING: buy RamsterZ on the Unity Asset Store, never direct** — the direct sale
carries their own EULA with an explicit AI-use prohibition (R105 addendum 2).
**Never pass a RamsterZ clip to Ludo or any generator as reference, seed or input.**

## Reproduce

Binaries in `Godot/assets/anim/audition/ramsterz_h2h/`, gitignored by U46's rule.
Extraction: a `.unitypackage` is a gzipped tar; `head -1` each GUID folder's
`pathname` (it ends with a literal `00` line that will swamp a naive sort).
