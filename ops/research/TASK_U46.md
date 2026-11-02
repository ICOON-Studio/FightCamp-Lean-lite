# TASK U46 — CURSOR — AUDITION THE FREE PACK BEFORE WE BUY ANYTHING

Model: cursor-agent, **medium** effort. Owner: cursor.

**Tier: A NEW TOOL AND A REPORT. No `.gd` in `scripts/`, no test edited.**
Parse gate on the one new tool. **DO NOT RUN THE SUITE.**

## Why this exists

The operator's instruction is *"exactly ONE is grappling — we have to find a ton
more"*, and they are right that the search is not finished. But it is now an
**audition** job, not a search job, and C75 is why.

Read `research/C75_ANIMATION_SOURCES.md` **§1 and §3 only**. Codex read
the actual licence clauses on six source classes. The verified paired-ground
count is **zero at every one of them**, for a structural reason: these are
single-actor mocap libraries, and a ground exchange needs two bodies in matched
contact — matched roots, persistent limb contact, legal transitions.

**But three of C75's cells say `NV` — "not verifiable from the published
catalogue" — which is NOT the same as zero.** C75 names the cheapest of them
explicitly:

> "Motifect is the cheapest source worth a visual audition because its licence
> is explicit, its files are already FBX/BVH, and the download is free."

**Nobody has auditioned it.** That is this task.

## THE MANIFEST IS ALREADY KNOWN — DO NOT RE-DERIVE IT

Claude read the vendor's own preview page in the in-app browser on 2026-09-11:
**https://motifect.io/en/packs/martial_arts** lists **every clip by name**. C75
wrote `NV` because the *itch.io* page publishes no per-move manifest; the
vendor's site does, and the itch page links to it.

**40 clips, and the split is the finding:**

| class | count | detail |
|---|---|---|
| WEAPONS | **17** | 10 sword, 6 staff, 1 spear — **dead weight for FightCamp** |
| STRIKING | **16** | 8 muay thai (body kick, combination, elbow cut, guard stance, knee clinch, push kick defense, roundhouse, teep) + 8 TKD kicks (axe, back, front high, jump front, jump spinning, roundhouse high, side, spinning heel) |
| GRAPPLING | **7** | Judo Hip Throw, Judo Ankle Sweep, Wrestling Body Slam, Wrestling Double Leg Takedown, Wrestling Single Leg Takedown, **Wrestling Guard Position**, Wrestling Stand Up Defense |

**THERE ARE NO PUNCHES.** Every one of the 16 striking clips is a kick, knee or
elbow. **Boxing gets nothing from this pack.**

**C75's grappling zero was a limit of the itch page, not of the pack** — but its
STRUCTURAL point survives: these are single-actor generated clips, so "Double
Leg Takedown" is one body shooting at nobody and "Guard Position" is one body in
a guard shape with nobody in it. **Still zero paired, contact-matched two-body
sequences.**

The pack also ships **GLB** alongside FBX/BVH, which is what R94's pipeline
already consumes. Licence re-read on the page 2026-09-11, unchanged: *"Free for
personal and commercial use in your games."*

**Direct download, no auth needed:**
`https://d3is8g3qbv0vuy.cloudfront.net/asset-packs/martial_arts/martial_arts.zip`
(8.4 MB). `curl -L -o` it; you do not need the itch page or a session.

**So steps 1-3 below are mostly DONE. Your value is step 4 — the retarget
audition — and the per-clip duration/frame/bone truth that only the files
carry.** Confirm the manifest against the actual filenames (a store page is not
a file listing) and report any discrepancy.

## What to do

**1. DOWNLOAD THE FREE PACK.** Motifect Martial Arts Motion Pack,
`https://motifect.itch.io/motifect-martial-arts-motion-pack`. Its licence is
explicit and product-specific: *"Free for personal and commercial use in your
games"* (C75, read 2026-09-10). **Re-read that line on the page yourself before
downloading and quote what it says today** — if it has changed, STOP and report
rather than downloading.

Put the files in `Godot/assets/anim/audition/motifect/` and **do NOT commit the
clip binaries** — add them to `.gitignore` if they are not already covered.
Commit the MANIFEST and the report, never the pack.

**2. ENUMERATE IT HONESTLY.** 40 mesh-free clips, FBX and BVH, 30 fps, 3–8 s.
For every clip report: filename, duration, frame count, bone count, and the bone
NAMES. C75 could not get a per-move manifest from the page; you can get one from
the files.

**3. COUNT THE CLASSES THAT ACTUALLY MATTER**, and count them the way C75 did so
the two documents are one column of the same quantity. Per class, a real count,
and `0` where there is nothing — never a tag, never an assumption:

- STRIKING: jab, cross, hook, uppercut, elbow, knee, kick (by target), block,
  parry, region reactions, knockdown, KO.
- GRAPPLING: takedown, throw, guard, half guard, side, mount, back, pass, sweep,
  submission, ground-and-pound.

**A category name on the store page is not a clip.** "Wrestling" and "grappling"
were tags on that page and C75 refused to count them; so do you.

**4. THE RETARGET AUDITION — the question R94 already knows how to ask.**
R94's whole finding was that the Ludo output's 22 bone names ARE
`SkeletonProfileHumanoid`, so integration was a ten-line track-path rename and
there was no BoneMap and no per-fighter cost. **Motifect's skeleton is
unpublished.** So measure the distance:

- How many of its bones map onto `SkeletonProfileHumanoid` by name, exactly?
- How many need a mapping table?
- **Does a clip actually move the bones on one of our twelve?** `U42` already
  built exactly this check — `moves_bones=22/22 unmatched=0`. Reuse its method
  rather than inventing a second one, and report the same numbers in the same
  shape.

**Pick ONE striking clip and ONE grappling-labelled clip** (if any exists) and
report `moves_bones=N/22` for each on fighter f01. **A clip that moves 0 of 22
bones is worthless at any price**, and that is a fact you can establish for free
today.

**5. SAY WHETHER THE $60 IS WORTH IT.** Unity's "MMA Fight Actions" is US$60 and
publishes no manifest; C75's line is that paying before seeing one *"would buy a
label, not evidence"*. After auditioning Motifect you will know how much a
40-clip generated pack actually yields. **Give the operator a recommendation
with a reason, not a preference.** You are not authorised to buy anything.

## PART TWO — MIXAMO, BECAUSE MOTIFECT HAS NO PUNCHES

**The two free sources are complementary and that is the whole point of doing
both in one task.** Motifect's 16 striking clips are every one a kick, knee or
elbow — **boxing gets nothing from it.** C75 verified that **Mixamo** has the
other half:

> **Free** with an Adobe ID, no Creative Cloud subscription. **"Royalty free for
> personal, commercial, and non-profit projects"**, and the examples include
> video games (Adobe FAQ, read 2026-09-10).
>
> **Verified minimum 15 striking clips: 9 boxing-labelled** — lead jab,
> jab-cross, rear cross, lead hook, rear hook, lead uppercut, rear uppercut,
> illegal knee, body-punch-to-knee — plus at least 4 named kicks, 1 block and 1
> head-hit reaction.

**That is the punch set, free and commercially cleared.** Between the two packs a
striking round is covered without authoring or paying for anything.

**THE CATCH C75 ALREADY NAMED, and it is the thing to measure:** Mixamo ships
the `mixamorig` skeleton, NOT `SkeletonProfileHumanoid`. So unlike R94's Ludo
output — whose 22 bone names WERE the Godot profile, making integration a
ten-line track-path rename — **Mixamo needs a real bone-name map and a rest-pose
check.** Report:

- the exact `mixamorig` bone names and how many map to
  `SkeletonProfileHumanoid` by name;
- whether a rest-pose/orientation correction is needed on top of the name map;
- `moves_bones=N/22` for one boxing clip on f01, the U42 way.

**Download ONE clip to measure this — a jab — not the library.** The question is
the cost of the mapping, and one clip answers it. If the answer is "a 22-row
name table, written once", then the punches are effectively free and that is the
headline of this task.

**The operator is signed in to a browser on this machine** and Mixamo requires
an Adobe ID, so if the download needs a session, say so and stop rather than
trying to work around it.

## THE PAID PACKS, CHECKED 2026-09-11 — AND THE ANSWER IS BUY NOTHING

The operator asked about **Unity "ULTIMATE ANIMATION COLLECTION"**
(Protofactor, `assetstore.unity.com/packages/3d/animations/ultimate-animation-collection-195459`).
Claude read the product page in the in-app browser. **€239.20, 1.1 GB,
2,400+ animations across 24 animsets** — and the description names all 24:

> Basic Locomotion · Female Basic Locomotion · Climbing · **Combat Bare Fists** ·
> 1 Handed Melee Weapon · Fencing · 2 Handed Melee Weapon · Sword & Shield ·
> Wizard · Bow & Arrow · Assault Rifle · Bazooka · Dual Guns · Minigun ·
> Shotgun · Two handed gun · Hostage · Zombie · Creature · Push Cube · Crowd ·
> Dual Swords · **Injured** · Campfire

**EXACTLY ONE of 24 animsets is unarmed combat.** Ten are weapons, three are
fantasy/creature, the rest is locomotion and scene filler. **Zero grappling** —
no takedown, no guard, no mount. The same structural wall C75 found everywhere.

**AND PROTOFACTOR SELLS THE ANIMSETS INDIVIDUALLY**, on that very page:
`ANIMSET: 1 HANDED MELEE WEAPON €18.39`, `ANIMSET: BASIC LOCOMOTION €13.79`,
`ANIMSET: CREATURE €13.79`. So the €239 bundle would be a **~17x overpay to
reach one animset.** If the bare-fists set is ever wanted, find the standalone
at ~EUR 15 and read ITS page first.

Two cautions even on the standalone: "Combat Bare Fists" is an RPG brawler set,
not a boxing vocabulary — **Mixamo's 9 boxing-labelled clips are more on-target
AND free** — and it is a Unity package on "Mecanim Humanoid", so it still needs
extracting from Unity before Godot sees it.

**STANDING PURCHASE POSITION, and do not reopen it without new evidence:**

| source | cost | verdict |
|---|---|---|
| Mixamo | FREE, Adobe-cleared for commercial games | **the punches** |
| Motifect | FREE, explicit commercial grant | **the kicks + takedown entries** |
| CMU | FREE, commercial embed OK, no resale | fallback |
| Unity "MMA Fight Actions" | US$60, **no manifest published** | hold until this task reports |
| Unity "Ultimate Animation Collection" | EUR 239.20 | **NO** — 1 of 24 animsets, sold separately for ~EUR 15 |
| Fab "Grab Animations" | price not shown | **NEVER** — product page does not identify the binding licence |

## C75'S STRUCTURAL VERDICT IS OVERTURNED — PAIRED GROUND ANIMATION EXISTS

**Found 2026-09-11 in the in-app browser, after the operator pushed back on
"we have to find a ton more". They were right and C75 was wrong.**

C75 concluded that the minimum paired chain has **zero verified instances at any
source, at any price**, because single-actor mocap cannot supply two bodies in
matched contact — and therefore "a complete animated ground fight is custom
two-performer capture/cleanup work, not a free-library integration."

**RamsterZ publishes exactly that data, with a manifest, for EUR 10.11.**

### Full Mount Attacks — RamsterZ — **EUR 10.11** — 6.0 MB
`assetstore.unity.com/packages/3d/animations/full-mount-attacks-227372`

```
Total Animations: 32
10  Start/Loop/End          (5 Attacker, 5 Victim)
 8  Empty Hand Attacks      (4 Attacker, 4 Victim)
 8  Melee Weapon Attacks    (4 Attacker, 4 Victim)   <- dead weight for us
 4  Victim Block/Fight Back (2 Attacker, 2 Victim)
 2  Reversal                (1 Attacker, 1 Victim)
```

Listing keywords: **PAIRED ANIMATION, SYNC ANIMATION, Grapple, jiu jitsu,
wrestling.** A review: *"If you're looking for high-quality pair animations,
this is the pack you need."*

**The structure IS a ground exchange**: Start/Loop/End is entry -> held position
-> exit, `Victim Block/Fight Back` gives the bottom man agency, and `Reversal`
is the sweep. Standard Unity Asset Store EULA, whose SS2.2.1 C75 already verified
permits embedding in a Licensed Product.

**Honest limits:** MOUNT ONLY - not guard, side control, back or submissions, so
it is ONE rung of the ladder R91/R92/R93 built. 8 of 32 clips are melee-weapon.
Unity package, so extraction plus retarget applies. One rating.

### Hand to Hand Set — RamsterZ — **EUR 41.39** — and it publishes a manifest too
```
Total Animations: 122
Idles 2 · Turning 3 · Walks/Runs 32 · Sprint 1 · Charging 3 · Equip 2
Defense/Block 8 · Slip/Fade 3 · Dodge 4        <- maps onto R102's guard kinds
Hit Reactions 4 · Staggers 16 · KnockDown/Get Up 3
Kicks 20 · Punches 16 · Jump/Land 4
```
**`Defense/Block 8` and `Slip/Fade 3` + `Dodge 4` map directly onto the `block`
and `evade` guard kinds R102 shipped**, and the 16 staggers + 4 hit reactions
are M19's receiver-reaction requirement.

Also from RamsterZ: Hand to Hand Finishers vol 1 (EUR 32.19), Hand to Hand
Non-Lethal Counters (EUR 22.99), Martial Arts Master (EUR 45.99).

### REVISED PURCHASE POSITION

| source | cost | verdict |
|---|---|---|
| Mixamo | FREE | **the punches** - audition first |
| Motifect | FREE | **the kicks + takedown entries** - audition first |
| **RamsterZ Full Mount Attacks** | **EUR 10.11** | **BUY. The only verified PAIRED ground data found anywhere, and it is the exact blocker.** |
| RamsterZ Hand to Hand Set | EUR 41.39 | **HOLD** until the free packs are auditioned; its real value is the DEFENSIVE vocabulary |
| Unity "MMA Fight Actions" | US$60 | hold - still publishes no manifest |
| Unity "Ultimate Animation Collection" | EUR 239.20 | **NO** - 1 of 24 animsets, sold separately ~EUR 15 |
| Fab "Grab Animations" | not shown | **NEVER** - page does not identify the binding licence |

**A Unity sale starts 2026-09-14, "50% off 300+ best sellers" — check whether
either RamsterZ pack is in it before paying full price.**

**THE LESSON, and it is the operator's:** C75 read six SOURCE CLASSES and
concluded from architecture that paired data does not exist. It never searched
the Unity store for the WORD "paired". The refusal was reasoned, thorough, and
wrong, and a ten-euro listing with a published manifest disproves it. **Search
for the thing, not for the category.**

## Owned files

- `Godot/tools/audit_anim_pack.gd` — NEW. The enumerator and the bone audit.
- `research/U46_MOTIFECT_AUDITION.md` — the manifest, the counts, the
  recommendation.
- `.gitignore` — only if the pack needs excluding.

**DO NOT EDIT** anything in `Godot/scripts/`, anything in `Godot/tests/`, or
`HANDOFF.md`.

## Anchors

- `research/C75_ANIMATION_SOURCES.md` — **§1 and §3 only.** It is long.
- `research/U42_DIGEST.md` — your own clip audit. Its method is the one to
  reuse: windows off the curve, `moves_bones=N/22`, `unmatched`, a name
  vocabulary, and `kind=` when the clip is not what it claims. **U42 is why we
  know our one clip is a `single_hand_drill` and not a real combination.**
- `research/R94_ANIMATION_SPIKE.md` — the bone-name finding and the
  track-path rename. **This is the bar Motifect has to clear.**
- `Godot/tests/fight_world_anim_test.gd` — the existing graft-and-play harness.

## Gate

```
python Godot/tools/check_scripts.py Godot/tools/audit_anim_pack.gd
```

then run your tool. **NO SUITE RUN** — you are adding a tool in `tools/`, which
costs the suite nothing.

## Report

Commit the tool and the report — **not the clips**. Push **`master`** (run
`git rev-parse --abbrev-ref HEAD` first; you left this checkout on a branch
once). Then one line:

```
python Tools/agent_comms.py send --from cursor --to claude --subject U46-done
```

## The trap specific to this task

**Do not let a tag become a count.** The entire value of C75 is that it counted
only what a source actually published and wrote `NV` everywhere else, and the
entire value of U42 was finding that a clip labelled as a combination is three
right hands that never alternate. **The most likely outcome of this task is that
Motifect's grappling is also a label.** If so, say so in a sentence and the task
has succeeded — it will have turned three `NV` cells into a real number for the
price of a free download, and that decides the $60.
