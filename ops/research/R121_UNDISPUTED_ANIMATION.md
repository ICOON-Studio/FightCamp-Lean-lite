# R121 — HOW UNDISPUTED DOES ITS ANIMATION, AND WHAT WE ARE MISSING

Measured 2026-09-12 by Claude, at the operator's request, from the installed
copy at `E:\SteamLibrary\steamapps\common\Undisputed`.

**METHOD, AND ITS LIMITS.** Unity **2022.3.45f1** (read off the exe, not
guessed), IL2CPP, Addressables: **15,220 asset bundles** under
`Undisputed_Data/StreamingAssets/aa/StandaloneWindows64/`. All 15,220 were
opened with `UnityPy 1.25.3` in 191 s with
`UnityPy.config.FALLBACK_UNITY_VERSION = "2022.3.45f1"` — without that pin every
bundle fails to parse, which is the whole trick.

**ONLY METADATA WAS READ: clip names, clip lengths, object type counts. Nothing
was decoded, extracted, exported or written out, and nothing from this game will
ever ship in ours.** The question was how a shipped boxing game is STRUCTURED.

The counts below are for clips whose NAME matched a boxing vocabulary
(`jab|hook|upper|cross|block|slip|weave|stance|idle|step|knock|clinch|react|…`).
**They are therefore a FLOOR, not a total** — a clip named `Anim_047` is real and
invisible to this method. A separate probe over the 150 largest bundles alone
counted **4,774 `AnimationClip` objects and 7,909 `Animator` components**.

---

## 1. THE HEADLINE: 2,699 NAMED FIGHTER CLIPS. WE OWN ABOUT 13.

| family | Undisputed | FightCamp |
|---|---:|---:|
| **stance / idle** | **333** | **1** |
| hit / head / body reaction | 326 | 11 |
| knockdown (`KD_*`) | 200 | **2** |
| block | 176 | 1 |
| jab | 168 | 1 |
| hook | 168 | 1 (+1 mirrored) |
| weave / slip / duck / bob | 156 | 2 |
| cross / straight | 152 | 1 |
| step / walk / footwork | 144 | 37 on disk, **2 bound** |
| uppercut | 104 | 1 |
| ringwalk / entrance | 53 | 0 |
| clinch | 42 | 0 |

**The largest single family is STANCE AND IDLE — 333 clips.** More than any
punch, more than any reaction. That is the number worth staring at: a fighter
spends most of a round not throwing, and they spent their biggest budget on
exactly that. We have one 4.667 s idle loop.

---

## 2. THEY DO NOT BLEND BETWEEN CLIPS. THEY MOTION-MATCH.

**480 clips carry `_MxM_` in the name** — Motion Matching. Examples verbatim:

```
Weave_Forward_Orthodox_MxM_MOD                                   0.230 s
Neutral_Head_Reaction_LH_Southpaw_MxM_MOD                        1.000 s
Low_Block_Trad_New_Left_Reaction_OptimizedForBlock_Reaction_Orthodox_MxM_MOD   0.433 s
```

**THIS IS THE ANSWER TO G57's FIRST QUESTION AND IT IS NOT A NUMBER.** Motion
matching does not hold a state machine with authored transition durations. It
keeps a pose database, and every frame it searches for the pose that best
continues the current motion and the desired trajectory, then blends into that.
There is no "0.1 s crossfade from jab to idle" anywhere in the design, because
there is no fixed pair of clips to cross between.

So the honest comparison is not "their blend time vs ours". It is:

- **They removed the transition problem by making transitions dense.** With 2,699
  clips, whatever pose you are in, something close already exists.
- **We have 13 clips and a 0.10 s crossfade.** The crossfade is the right tool
  for 13 clips. It is not a smaller version of what they built.

`_MOD` appears on **611** clips — derived/modified variants of a base take, which
is how a motion-matching database gets filled out cheaply.

---

## 3. BOTH STANCES ARE AUTHORED. NOTHING IS MIRRORED AT RUNTIME.

**Orthodox 1,225 · Southpaw 1,202 · neither named 275.** An almost exact 1:1
split, with `_dup` on 36 of them.

**We mirror at runtime (U41) and got a free doubling of the library for it.**
Undisputed did not take that shortcut. The reason is almost certainly that a
mirrored boxer is wrong in a way a mirrored walk is not — a southpaw is not a
reflected orthodox fighter, his lead hand and hip mechanics differ — and in a
motion-matching database a subtly wrong pose is selected as readily as a right
one. **Our mirroring is a legitimate saving at our scale and a thing to revisit
if we ever go dense.**

---

## 4. THEIR ACTION CLIPS ARE LONGER THAN OURS

Clips between 0.05 s and 3.0 s, n=2,785:

| | min | p25 | median | p75 | max |
|---|---:|---:|---:|---:|---:|
| **Undisputed** | 0.067 | 0.867 | **1.333** | 1.833 | 2.967 |
| **FightCamp** | ~0.23 | — | ~0.90 | — | 1.20 |

Their median action clip is **1.333 s** against our ~0.9 s, and their p75 is
1.833 s — longer than our longest. Combined with the 0.067 s minimum, that says
they carry both **very short connective fragments** and **long committed
actions**, which is again the motion-matching shape: short pieces exist to be
stitched, long pieces exist to be committed to.

---

## 5. THEY ANIMATE IK WEIGHTS AS CURVES

34 clips carry IK in the name, and the pattern is explicit:

```
RingwalkIK_V0B1_ArmIKWeight                     17.200 s
RingwalkIK_V0B2_LengthenedArmIKWeight           39.783 s
Ringwalk_NPC1_Cleanedup_CrossedArmsWeight       18.708 s
SelectIdle_CrossedArmsWeight                    24.800 s
KD_LB_03_ML_Orthodox_IK                          1.367 s
```

`..._ArmIKWeight` is an animation clip **whose content is the weight of an IK
constraint over time.** They fade IK in and out on a curve rather than switching
it. We have no IK at all, and M18 explicitly ruled **do not buy an IK foot-plant
system** — that ruling stands; this is a different use (arm/glove targeting and
knockdown contact), and it is not urgent.

---

## 6. WHAT WE ARE ACTUALLY MISSING, RANKED BY WHAT IT WOULD BUY

**FIRST, THE CORRECTION THAT CHANGES THE SHAPE OF THIS LIST.** Asked of the live
binding rather than of any report: **NO ROLE IS UNFILMED. `missing_roles()`
returns zero.** Every Director role resolves to a clip that opens.

**The gap is not absence, it is MONOTONY: 14 of our 18 bound roles have exactly
ONE take.** Only `react_body` (7), `react_head` (4), `slip` (3) and `knockdown`
(2) have any variety at all - and those four are the roles somebody already went
and fixed, which is the proof that variety is the thing that was worth fixing.

So "what clips are we missing" has two honest answers and they lead to different
purchases:
 - **By MOVE: almost nothing.** U56 measured only THREE fired technique ids with
   nothing owned - `boxing_slip_counter` (828 pooled, and it was watched
   degrading live on 2026-09-12), `mma_guard_gnp` (224), `mma_dirty_boxing` (139).
 - **By TAKE: nearly everything.** One idle, one block, one jab, one cross, one
   hook, one of each locomotion.

1. **IDLE AND STANCE VARIETY.** 333 → 1 is our worst ratio and it governs the
   majority of screen time. Even 4–6 idles, round-robined the way `react_head`
   already is, would change how alive the fight looks more than any other single
   purchase. **Cheapest real win on this list.**
2. **KNOCKDOWNS: 200 → 2. CORRECTED.** The first version of this file said we
   owned NONE, repeating a stale comment in `FightStagePlayer` ("we own no
   knockdown clip yet"). Asked of the LIVE binding instead
   (`tools/report_missing_clips.gd`), `knockdown` resolves with **two takes**.
   Two is still thin for the one beat a player must not misread (G56), but it is
   not zero and a purchase must not be argued from zero.
3. **REACTIONS: 326 → 11.** We have the round-robin machinery already
   (`_variant_next`); it is starved of takes.
4. **FOOTWORK: 144 → 2 bound.** 37 clips sit on disk unbound. This is a binding
   and driver job, not a purchase — R118 bound the first two.
5. **Motion matching itself: NOT RECOMMENDED, and this is a real ruling.** It
   needs a dense database to work at all. At 13 clips it would select badly and
   look worse than a crossfade. It becomes a question at hundreds of clips, not
   before.

---

## 7. WHAT THIS SAYS ABOUT THE 2026-09-14 PURCHASE DECISION

J23 is pricing muay thai knee/elbow packs. **This study says the family to buy
first is not a strike family at all — it is idles/stances and knockdowns**, and
J23 was not asked about either. Whatever J23 returns, the ranking above should be
read beside it before anything is bought.

**Undisputed is boxing-only, so it says nothing about muay thai vocabulary.** It
is evidence about STRUCTURE and VOLUME, not about which discipline to buy.

---

## Reproducing this

Scripts are in the session scratchpad, not committed — they read an installed
third-party game and belong nowhere near the repo. The method is three lines:

```python
import UnityPy
UnityPy.config.FALLBACK_UNITY_VERSION = "2022.3.45f1"   # without this, every bundle fails
env = UnityPy.load(path_to_bundle)
for obj in env.objects:
    if str(obj.type.name) == "AnimationClip":
        d = obj.read(); name = d.m_Name; stop = d.m_MuscleClip.m_StopTime
```

All 15,220 bundles in 191 s on this machine. **Undisputed was refunded but is
still installed; if it is uninstalled this becomes unreproducible.**
