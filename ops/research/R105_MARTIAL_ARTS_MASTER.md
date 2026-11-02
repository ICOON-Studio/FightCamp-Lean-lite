# R105 — `MARTIAL ARTS MASTER`, READ FROM ITS OWN MANIFEST

Operator handed over the listing 2026-09-11:
`assetstore.unity.com/packages/3d/animations/martial-arts-master-311647`

**Publisher: RamsterZ — the same publisher as `Full Mount Attacks`, which we
already BOUGHT and still cannot audit.** That fact governs the recommendation at
the bottom.

## What it is, from the vendor's own figures

| | |
|---|---|
| price | **EUR 45.99** on the Unity Asset Store; **$49.99** direct from `ramsterzanimations.com` |
| size | 19.9 MB |
| clips | **212** |
| format | **raw `.fbx`** — *not* a `.unitypackage` when bought direct |
| rig | **"Compatible with the UE4 Mannequin Skeleton"**, "works in Unity as Humanoid rig configuration", root motion ready |
| licence | Unity: Extension Asset, Standard Unity Asset Store EULA — clean for a shipped game |

**The store page publishes NO manifest.** The 212-clip breakdown below comes from
the vendor's own site, which does — the same split R103's purchase work found with
`Full Mount Attacks`: the storefront is silent and the vendor is not.

## THE MANIFEST, and it is LANE COUNTS — NOT CLIP NAMES

```
Fighter        Attack 46  Counter 25  Movement 13  Stagger 5  Block 4  Redirect 4  Parry 3
Master Stance  Attack 26  Movement 17  Evade 8  Parry 3  Misc 2
Hyper Focus    Movement 17  Attack 15  Block 7  Fade 3  Parry 3  Misc 2
Other          Jumps 3  Runs 3  Idles 3  Knocked Out 1
```

## WHY THIS IS THE STRONGEST CANDIDATE WE HAVE SEEN — a column the table lacked

Every previous source was judged on its PUNCHES. Q46 has just moved the question:
the receiver's reaction is asked for **143 times across 148 action beats** and we
own **zero** reaction clips, and R103's digest recorded that **nothing owns an
`idle`** either, so M19's "he holds his guard" is literally the rest pose.

**This pack is the only source found anywhere with a real DEFENSIVE vocabulary,
and it maps onto R102's own guard kinds rather than onto a marketing word:**

| what we need | R102/M19 name | this pack |
|---|---|---|
| block | `block` | **11** (Fighter 4 + Hyper Focus 7) |
| evade / slip | `slip` | **8** (Master Stance Evade) |
| parry | — (new kind) | **9** |
| receiver reaction | `react_*` | **5** (Fighter Stagger) |
| knockdown | `knockdown` | **1** (Knocked Out) |
| **idle / guard hold** | `idle` | **3** |

Compare Motifect, audited by U46 two commits ago: **block 0, parry 0, region
reactions 0, knockdown 0.** This pack has all five.

## THE FOUR REASONS NOT TO BUY IT TODAY

1. **LANE COUNTS ARE NOT CLIP NAMES, AND M19 FORBIDS SUBSTITUTION.** "Fighter
   Attack (46)" is a lane. Q45 measured that the engine reaches **21 distinct
   named techniques**, and R103 just deleted the code that played a jab for an
   overhand. 87 attack clips are worth nothing to the thrower side unless
   individual clips can be mapped to `boxing_cross`, `boxing_overhand` and the
   rest — and **no per-clip list is published on the store page, the vendor page,
   or Fab** (Fab returns 403). The DEFENSIVE lanes do not have this problem: a
   block is a block, which is exactly why the defensive half is the value here.

2. **THE RIG IS THE UE4 MANNEQUIN, AND THAT COST IS UNMEASURED.** R94's whole
   finding was that Ludo's output bone names ARE `SkeletonProfileHumanoid`, so
   integration was a ten-line track-path rename — `moves_bones=22/22`. U46 then
   measured Motifect at **9/22, needing a 13-row map**. The UE4 Mannequin is a
   third naming scheme again (`pelvis`, `spine_01`, `clavicle_l`, `upperarm_l`)
   **with a different rest pose**, so it needs a name map AND a rest-pose
   correction. Nobody has measured a RamsterZ clip on f01.

3. **"HYPER FOCUS" AND "MASTER STANCE" ARE AN ACTION-GAME IDIOM, NOT MMA.** This
   is U46's idiom risk, and here it is visible in the manifest rather than only in
   the previews. `Hyper Focus Fade` is not a thing in boxing. **47 of 212 clips are
   the Hyper Focus mode and 56 more are a third stance vocabulary**; the lane that
   plausibly survives contact with our engine is the 100-clip `Fighter` set.
   RamsterZ's catalogue — Deadly Siren, Crawling Ghoul, Asylum NPC, Battle Witch —
   is a horror/action publisher, exactly as U46 warned.

4. **NO PAIRED ANIMATION AND NO GRAPPLING.** A search blurb says "grapples"; the
   **manifest has no grapple lane and the vendor page does not mention grappling
   at all.** That is the U42 lesson a third time — the blurb is not the content.
   The paired ground work lives in `Full Mount Attacks`, a separate pack.

## THE ONE NUMBER THAT DECIDES THIS, AND WE HAVE ALREADY PAID FOR IT

**`Full Mount Attacks` (EUR 10.11) is bought, and U46 could not audit it because
the `.unitypackage` is not on disk.** So we hold zero verified evidence that ANY
RamsterZ clip drives a single bone on one of our twelve fighters.

`moves_bones=N/22` on one RamsterZ clip **settles `Martial Arts Master` (EUR 46)
and `Hand to Hand Set` (EUR 41) at the same time, and it costs nothing** — the
asset is already paid for. Buying a second pack from this publisher before the
first one is extracted is buying a label, which is precisely the error C75 made
and the operator corrected.

**And a `.unitypackage` IS A GZIPPED TAR — untar it, read each GUID folder's
`pathname` file for the real filenames. Unity is NOT needed to extract it**, only
possibly to download it.

## RECOMMENDATION

**Do not buy today. Buy it if, and only if, two things land — and one of them is
free and already owned.**

1. **Extract `Full Mount Attacks` and measure `moves_bones=N/22`.** Free, already
   paid for, and it answers the RamsterZ rig question for every pack they sell. If
   a RamsterZ clip moves 9 of 22 like Motifect, both EUR 46 and EUR 41 are refused
   on one measurement.
2. **Wait for the sale.** A Unity sale starts **2026-09-14, 50% off 300+ best
   sellers** — three days out. EUR 45.99 at half price is EUR 23, which changes the
   arithmetic on a pack whose thrower half we may never name.

**If the rig check passes, this is the pack to buy, and the reason is the defensive
vocabulary, not the 212.** It is the only source found that can close the gap Q46
measured — and the 3 idles alone fix the thing R103 had to ship as a rest pose.

## SEPARATE PRODUCT, DO NOT CONFUSE THEM

`Martial Arts Mastery - Animation Pack` (Unity `338850`) is a **different listing**
and was not assessed here. If it comes up, read its own manifest.

## Sources

- https://assetstore.unity.com/packages/3d/animations/martial-arts-master-311647
- https://www.ramsterzanimations.com/store-buy/p/martial-arts-master-fbx-only-c3p2k
- https://www.ramsterzanimations.com/store-buy

---

# ADDENDUM 2026-09-11 — THE RIG QUESTION IS SETTLED, FOR FREE, AND THE DOWNLOAD IS BLOCKED

The operator offered a logged-in browser session to fetch `Full Mount Attacks`.
Two things came out of that, and the second one answers the question the download
was supposed to answer.

## 1. THE DOWNLOAD GENUINELY CANNOT BE DONE FROM A BROWSER

Read from the live page while logged in: **"You purchased this item on Sep 11,
2026"**, file size **6.0 MB**, licence **Single Entity / Standard Unity EULA**,
and the ONLY action offered is **"Open in Unity"**. There is no web download
button — Unity removed direct `.unitypackage` downloads from the storefront years
ago; the route is the Editor's Package Manager, which caches to
`%APPDATA%\Unity\Asset Store-5.x\<Publisher>\...`.

**And Unity is not installed on this machine.** Checked: no `Program Files\Unity`,
no `Unity Hub`, no `%APPDATA%\UnityHub`, no `%APPDATA%\Unity`, no
`%LOCALAPPDATA%\Unity`. So there is no Editor to "Open in Unity" with and no asset
cache for U46 to have found. **U46 was not careless; the file has never existed on
this disk.**

The store's own JSON download endpoint is gone (`/api/en-US/content/download/
content/227372.json` → 404, SPA shell).

## 2. THE RIG COST NO LONGER NEEDS THAT FILE — IT IS COMPUTABLE AND IT IS DONE

RamsterZ publish the rig: **"Compatible with the UE4 Mannequin Skeleton", "works
in Unity as Humanoid rig configuration"**. Both bone sets are published, fixed and
public, so the name map can be derived without downloading anything.

**Our rig, read off `f01_m_box_welter_rigged.glb` (22 bones) — and it is exactly
`SkeletonProfileHumanoid` minus the fingers, eyes and jaw:**

```
Hips Spine Chest UpperChest Neck Head
LeftShoulder LeftUpperArm LeftLowerArm LeftHand
RightShoulder RightUpperArm RightLowerArm RightHand
LeftUpperLeg LeftLowerLeg LeftFoot LeftToes
RightUpperLeg RightLowerLeg RightFoot RightToes
```

**UE4 Mannequin:** `pelvis · spine_01 spine_02 spine_03 · neck_01 head ·
clavicle_l/r · upperarm_l/r · lowerarm_l/r · hand_l/r · thigh_l/r · calf_l/r ·
foot_l/r · ball_l/r`.

### EXACT NAME OVERLAP: **ZERO OF 22**

Not one name matches. `pelvis` is not `Hips`, `clavicle_l` is not `LeftShoulder`,
`ball_l` is not `LeftToes` — and even `head` is not `Head`, because
`Skeleton3D.find_bone` is case-sensitive. **A path-only `BoneTrackGraft` of a
RamsterZ clip would drive 0 of 22 bones**, against R94's Ludo clip at 22/22 and
U46's Motifect at 9/22.

### BUT THE MAP IS COMPLETE, UNAMBIGUOUS, AND WRITTEN ONCE

| ours | UE4 Mannequin | | ours | UE4 Mannequin |
|---|---|---|---|---|
| Hips | pelvis | | LeftUpperLeg | thigh_l |
| Spine | spine_01 | | LeftLowerLeg | calf_l |
| Chest | spine_02 | | LeftFoot | foot_l |
| UpperChest | spine_03 | | LeftToes | ball_l |
| Neck | neck_01 | | RightUpperLeg | thigh_r |
| Head | head | | RightLowerLeg | calf_r |
| LeftShoulder | clavicle_l | | RightFoot | foot_r |
| LeftUpperArm | upperarm_l | | RightToes | ball_r |
| LeftLowerArm | lowerarm_l | | RightShoulder | clavicle_r |
| LeftHand | hand_l | | RightUpperArm | upperarm_r |
| | | | RightLowerArm | lowerarm_r |
| | | | RightHand | hand_r |

**All 22 have exactly one counterpart. There is no gap and no judgement call.**
This is materially BETTER than Motifect's situation: Motifect matched 9 by luck and
left 13 to be reasoned about, while this is a total 1:1 correspondence.

**And it is a ONE-TIME cost that serves EVERY RamsterZ pack** — `Full Mount
Attacks`, `Martial Arts Master`, `Hand to Hand Set`, the Wrestler Finishers — not a
per-pack tax. Godot supports exactly this first-class: a `BoneMap` resource against
`SkeletonProfileHumanoid`, plus the importer's `retarget/rest_fixer`.

### THE TWO REAL UNKNOWNS THAT REMAIN, AND NEITHER IS THE NAME MAP

1. **REST POSE. The UE4 Mannequin is an A-POSE; `SkeletonProfileHumanoid` rest is
   a T-POSE.** A name map alone will put the arms in the wrong place. `rest_fixer`
   exists for this and U46 flagged the same risk for Mixamo. **Unmeasured.**
2. **WHETHER PAIRED ROOT ALIGNMENT SURVIVES.** Still the actual gate on the ground
   plan, still verified nowhere, and still needs a file in hand. Two synchronised
   clips are only a PAIR if attacker and victim keep their relative root transforms
   through extraction and retarget.

## 3. THE CHEAP WAY OUT: RAMSTERZ SELL DIRECT, FBX ONLY, AND IT IS CHEAPER

`ramsterzanimations.com/store-buy/hand-to-hand` sells the same packs as **raw
`.fbx`, which Godot imports directly — no `.unitypackage`, no Unity, no 6 GB
Editor install.**

| pack | Unity Asset Store | RamsterZ direct (FBX) | cheaper |
|---|---|---|---|
| **Full Mount Attacks** | EUR 10.11 **(already bought)** | **$7.99** | direct |
| Hand to Hand Set | EUR 41.39 | **$25.99** | **direct, by a wide margin** |
| Hand to Hand Finishers Vol 1 / 2 | — | $34.99 each | — |
| Non-Lethal Counters | EUR 22.99 | **$19.99** | direct |
| Wrestler Finishers Vol 1 / 2 | EUR 36.79 / 41.39 | $34.99 / $39.99 | direct |
| **Martial Arts Master** | **EUR 45.99** | $49.99 | **Unity** (and the 09-14 sale may halve it) |

**The cheaper source differs per pack — check both every time.**

## REVISED RECOMMENDATION

1. **Do not install Unity to recover a 6 MB file.** Either re-buy `Full Mount
   Attacks` direct for **$7.99** as FBX — paying ~$8 twice, which is cheaper than
   the disk and time cost of a Unity Editor — or leave it unaudited. **The operator
   decides; this is a spend, not a build step.**
2. **The name-map objection against `Martial Arts Master` is withdrawn.** It is a
   complete 22-row 1:1 map, written once, shared by every RamsterZ pack. Reasons
   (1) lane-counts-are-not-clip-names, (3) the Hyper Focus idiom and (4) no
   grappling all still stand, and reason (2) is now **A-pose correction, not name
   mapping.**
3. **If any RamsterZ pack is bought, buy the $7.99 one FIRST** — it is the cheapest
   possible answer to both remaining unknowns, the rest pose and the paired roots,
   and the paired-root answer is what the whole ground plan rests on.

---

# ADDENDUM 2 — THE DIRECT PURCHASE CARRIES A WORSE LICENCE THAN THE ONE WE ALREADY OWN

Operator said "buy the 7.99 fbx version". Taken to the cart; **stopped at the
EULA checkbox, which is a binding agreement in the operator's name and not
Claude's to accept.** Reading it first was the right order, because it changes
the recommendation.

## RamsterZ's OWN EULA, read in full from the checkout modal

**Clean for us:**
- **Grant** — "non-exclusive, non-transferable, worldwide license to use the
  Animations and Models for any video game projects, movies, or online videos."
- **"You are permitted to modify or alter the Animations and Models using any 3D
  software"** — retargeting onto our rig is explicitly allowed.
- **No royalties** — "RamsterZ LLC will not require any royalty payments from the
  revenues generated by your projects".
- **Restriction we already comply with** — must be "an integrated, inseparable
  part of a video game", never distributed or sublicensed "as standalone assets".

**THE CLAUSE THAT MATTERS, QUOTED IN FULL:**

> "**Prohibition on AI Use:** You may not use the Animations or Models for any
> artificial intelligence (AI) training, machine learning, neural networks, or any
> AI-specific projects. This includes, but is not limited to, using the Animations
> or Models as training data for AI models, generating derivative AI-powered
> content, or incorporating the Animations or Models into any AI-generated
> systems."

Also: limitation of liability with an indemnity, and termination automatically on
any breach.

## WHY THIS MATTERS HERE SPECIFICALLY, AND IT IS NOT A THEORETICAL WORRY

**R104 is "ask Ludo for two performers".** Ludo is a text-to-motion AI generator.
**Feeding a RamsterZ clip into Ludo as a reference or input would breach this
clause squarely** — that is "using the Animations ... as training data" or
"incorporating the Animations ... into any AI-generated systems". It is exactly
the thing someone would naturally try when trying to produce a matched pair.

**STANDING CONSTRAINT, whichever copy we end up using: NEVER pass a RamsterZ clip
to Ludo, or to any generator, as a reference, seed or input.** Play it back,
retarget it, modify it in Blender or Godot — all permitted. Do not feed it to a
model.

(The broader phrase "any AI-specific projects" is vague enough to be worth the
operator's eye, though the natural reading is about assets used as AI inputs, not
about who wrote the game's code. Playing a clip in a game engine is not AI use.)

## THE DECISIVE POINT: WE ALREADY OWN A CLEANER LICENCE

**The Unity Asset Store copy — already bought, EUR 10.11 — is governed by the
Standard Unity Asset Store EULA (Single Entity), NOT by this document.** That
licence carries no AI-use prohibition of this kind.

**So paying $7.99 again would buy the SAME 32 CLIPS under a STRICTLY MORE
RESTRICTIVE LICENCE than the copy already owned.** That is money spent to make our
position worse.

| | Unity copy (owned) | direct FBX ($7.99) |
|---|---|---|
| clips | 32 | 32 (24 + 8 from update) |
| licence | Standard Unity EULA, Single Entity | RamsterZ EULA |
| AI-use prohibition | **no** | **yes, explicit** |
| format | `.unitypackage` (gzipped tar) | raw `.fbx` |
| obtainable today | **no — needs a Unity Editor** | yes |

## REVISED RECOMMENDATION — AND IT REVERSES THE ADDENDUM ABOVE

**Do not buy the direct FBX.** Install **Unity Hub plus any free Editor**, open
`Full Mount Attacks` from My Assets once, and take the `.unitypackage` out of
`%APPDATA%\Unity\Asset Store-5.x\RamsterZ\...`. It is a **gzipped tar** — untar
it, read each GUID folder's `pathname` for the real filenames. Unity is needed
ONLY to fetch the file, never to read it, and the Editor can be uninstalled after.

That costs disk and one sitting, and it keeps the better licence. **$7.99 is not
the cheap option once the licence is read — it is the expensive one.**

**The same caution now applies to `Hand to Hand Set` ($25.99 direct vs EUR 41.39
on Unity) and to `Martial Arts Master`.** The direct route is cheaper in money and
dearer in rights. **Buy RamsterZ packs on the Unity Asset Store**, where the
Standard EULA governs — and for `Martial Arts Master` Unity is the cheaper source
anyway (EUR 45.99 vs $49.99), with a 50%-off sale starting 2026-09-14.
