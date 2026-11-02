# C75 — Animation sources beyond Ludo

Codex, 2026-09-10. Web terms and catalog pages were read on **2026-09-10**.
This is a sourcing decision, not legal advice. A count below is a count of
clips whose names or descriptions were actually published by the cited source;
`NV` means **not verifiable from the published catalog**, not an assumed zero.

## §1 — Candidates, costed

| Candidate | Cost | Commercial-game licence — quoted clause | Format and distance from `SkeletonProfileHumanoid` | STRIKING coverage, counted | GRAPPLING coverage, counted |
|---|---|---|---|---|---|
| **Adobe Mixamo** | **Free** with an Adobe ID; no Creative Cloud subscription ([Adobe FAQ](https://helpx.adobe.com/creative-cloud/faq/mixamo-faq.html), read 2026-09-10). | **Cleared.** “royalty free for personal, commercial, and non-profit projects” and the examples include video games ([Adobe FAQ](https://helpx.adobe.com/creative-cloud/faq/mixamo-faq.html), read 2026-09-10). | FBX download; Mixamo's biped humanoid/mixamorig skeleton. Adobe confirms the library is bipedal-humanoid only ([Adobe FAQ](https://helpx.adobe.com/creative-cloud/faq/mixamo-faq.html), read 2026-09-10). It needs a Mixamo-to-Godot humanoid bone-name map/rest-pose check, rather than R94's path-only rename. | **Verified minimum 15:** 9 boxing-labelled clips (lead jab, jab-cross, rear cross, lead/rear hook, lead/rear uppercut, illegal knee, body-punch-to-knee), at least 4 named kicks, 1 block and 1 head-hit reaction in a public 2,317-motion index ([index](https://huggingface.co/datasets/Linzhan/Mixamo-Animations-Characters), read 2026-09-10). Elbows, parries, region-complete reactions, knockdowns and KO: **NV**. This index is a third-party catalog aid, not the licence source. | Takedown **0 verified**; throws **0**; guard **0**; half guard **0**; side **0**; mount **0**; back **0**; passes **0**; sweeps **0**; submissions **0**; ground-and-pound **0**. Mixamo may contain loosely tagged stunts, but no cited manifest establishes a paired MMA ground chain. |
| **CMU Graphics Lab Motion Capture Database** | **Free** ([CMU database](https://mocap.cs.cmu.edu/), read 2026-09-10). | **Cleared for an embedded game, not resale:** “You may include this data in commercially-sold products, but you may not resell this data directly” ([CMU database](https://mocap.cs.cmu.edu/), read 2026-09-10). The same page says the ban includes converted form. | Native ASF/AMC and C3D; CMU links third-party BVH/FBX/DAE conversions ([formats](https://mocap.cs.cmu.edu/info.php), [resources](https://mocap.cs.cmu.edu/resources.php), read 2026-09-10). Each subject has a calibrated skeleton, so this is a real retarget/conversion job. CMU also warns that toe/hand joints are noisy and may need smoothing ([CMU database](https://mocap.cs.cmu.edu/), read 2026-09-10). | **7 generic “boxing” trials** across subjects 13, 14, 15 and 17 ([CMU category result](https://mocap.cs.cmu.edu/search.php?maincat=4&subcat=8), read 2026-09-10). Named jab/cross/hook/kick/knee/elbow/block/parry/body-region reaction/knockdown/KO counts: **0 verified**. | Takedown **0 verified**; throws **0**; guard **0**; half guard **0**; side **0**; mount **0**; back **0**; passes **0**; sweeps **0**; submissions **0**; ground-and-pound **0**. The database has 2,605 broad activity trials, but its published combat result does not establish a paired ground sequence ([CMU database](https://mocap.cs.cmu.edu/), read 2026-09-10). |
| **Unity Asset Store — “MMA Fight Actions” as the representative MMA pack** | **US$60 before tax**. The page classifies it as an **Extension Asset**, hence a seat is required for each user who installs it under EULA §2.3.2 ([product](https://assetstore-fallback.unity.com/packages/3d/animations/mma-fight-actions-271650), [EULA](https://unity.com/legal/as-terms), read 2026-09-10). | **Cleared.** EULA §2.2.1 permits the buyer “to reproduce, publicly display, publicly perform, transmit, and distribute” an asset embedded in a Licensed Product ([Unity EULA](https://unity.com/legal/as-terms), read 2026-09-10). The product page expressly says Standard Unity Asset Store EULA ([product](https://assetstore-fallback.unity.com/packages/3d/animations/mma-fight-actions-271650), read 2026-09-10). | 214.1 MB Unity package, original Unity 2021.3.11; the public page does not expose an animation manifest, export format or skeleton ([product](https://assetstore-fallback.unity.com/packages/3d/animations/mma-fight-actions-271650), read 2026-09-10). Godot distance is therefore **NV until purchased/inspected**; likely extraction plus humanoid retarget, not R94's known path rewrite. | **0 usable clips verified.** The page tags MMA, boxing, kickboxing, blocking and punching, but publishes no names or counts ([product](https://assetstore-fallback.unity.com/packages/3d/animations/mma-fight-actions-271650), read 2026-09-10). | All requested classes **NV**. “Grappling” is only a tag; there is no count for takedown, throw, guard, half, side, mount, back, pass, sweep, submission or ground-and-pound ([product](https://assetstore-fallback.unity.com/packages/3d/animations/mma-fight-actions-271650), read 2026-09-10). |
| **Fab — “Grab Animations” as the representative grappling pack** | Price **not exposed** by the public page on the read date ([product](https://www.fab.com/listings/48ba5d38-296b-4622-9440-aef8df8cf1a0?lang=en), read 2026-09-10). | **Terms not verified for this item.** Fab's Standard summary says users may “Commercially distribute your Projects with the Fab assets incorporated into it” ([Fab EULA page](https://www.fab.com/eula?lang=en), read 2026-09-10), but calls that summary non-binding, while this product page renders `License terms — -`. Do not buy until checkout identifies the binding licence. | Unreal Engine format only; 10 animation sequences plus example montages ([product](https://www.fab.com/listings/48ba5d38-296b-4622-9440-aef8df8cf1a0?lang=en), read 2026-09-10). It would require Unreal extraction/export and skeleton retargeting. | **0**; this is not a striking pack ([product](https://www.fab.com/listings/48ba5d38-296b-4622-9440-aef8df8cf1a0?lang=en), read 2026-09-10). | **10 grab/setup sequences total, 0 verified paired ground sequences.** The seller says they are for a grapple attempt **before** a paired animation. Takedown/throw/sweep are tags, not enumerated clips; guard, half, side, mount, back, passes, submissions and ground-and-pound are **0 verified** ([product](https://www.fab.com/listings/48ba5d38-296b-4622-9440-aef8df8cf1a0?lang=en), read 2026-09-10). |
| **itch.io — Motifect Martial Arts Motion Pack** | **Free download** ([product](https://motifect.itch.io/motifect-martial-arts-motion-pack), read 2026-09-10). | **Cleared for this game.** “Free for personal and commercial use in your games” ([product](https://motifect.itch.io/motifect-martial-arts-motion-pack), read 2026-09-10). That is the publisher's product-specific grant; itch.io itself does not supply one uniform asset licence ([itch.io Terms §4](https://itch.io/docs/legal/terms), read 2026-09-10). | 40 mesh-free clips, each as FBX and BVH, 30 fps and 3–8 seconds; seller says to retarget in Godot ([product](https://motifect.itch.io/motifect-martial-arts-motion-pack), read 2026-09-10). Skeleton/bone manifest is unpublished, so expect a full retarget audition. | **40 motions total across the whole pack**, with karate, taekwondo kicks, kung fu, stances, wrestling and grappling named only as categories. Exact punch/kick/knee/elbow/block/parry/reaction/knockdown/KO counts: **NV** ([product](https://motifect.itch.io/motifect-martial-arts-motion-pack), read 2026-09-10). | Exact counts for takedown, throw, guard, half, side, mount, back, pass, sweep, submission and ground-and-pound: **NV**. “Wrestling” and “grappling” do not prove any one of those states ([product](https://motifect.itch.io/motifect-martial-arts-motion-pack), read 2026-09-10). |
| **Open text-to-motion: MDM / MoMask / T2M-GPT class** | Code and published checkpoints can be downloaded for **US$0**; local GPU/CPU time, conversion, selection and cleanup are the actual per-clip cost. MDM reports roughly 0.4 seconds/sample for its accelerated model; MoMask offers a CPU demo ([MDM repo](https://github.com/GuyTevet/motion-diffusion-model), [MoMask repo](https://github.com/icedwater/momask), read 2026-09-10). | **Terms not verified for a commercial game output.** MDM/MoMask code is MIT: “use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies” ([MDM licence](https://raw.githubusercontent.com/GuyTevet/motion-diffusion-model/main/LICENSE), read 2026-09-10). But MoMask expressly says SMPL, SMPL-X, PyTorch3D and each dataset carry separate licences ([MoMask repo](https://github.com/icedwater/momask), read 2026-09-10). A code licence is not a clearance of pretrained weights, training data or generated motion. | HumanML3D-style 263D motion/joint arrays; conversion scripts fit SMPL/SMPL-X-family bodies rather than emitting a Godot animation clip ([MoMask repo](https://github.com/icedwater/momask), [MDM repo](https://github.com/GuyTevet/motion-diffusion-model), read 2026-09-10). Pipeline: decode joint motion, fit/convert SMPL, derive bone rotations/root motion, then retarget to the 22-bone Godot profile and clean contacts. | No fixed catalog: prompt count is unbounded, **production-usable count unknown**. Papers benchmark text/motion similarity and distribution metrics, not boxing timing, impact alignment or paired contact ([MDM paper](https://arxiv.org/abs/2209.14916), [T2M-GPT paper](https://arxiv.org/abs/2301.06052), read 2026-09-10). | No fixed catalog and **0 verified production-ready paired MMA ground clips**. These models primarily generate one human; they do not guarantee two-body hand/limb contact, matched attacker/defender roots, legal transitions or persistent guard/mount contact. |

### What the counts mean

The free candidates clear commercial use but do **not** clear the grappling
coverage gate. Motifect is the cheapest source worth a visual audition because
its licence is explicit, its files are already FBX/BVH, and the download is
free; its published page still does not prove even one requested ground class
([Motifect](https://motifect.itch.io/motifect-martial-arts-motion-pack), read
2026-09-10). Unity is the only representative paid MMA listing here whose item
and binding licence are both explicit, but paying US$60 before seeing a manifest
would buy a label, not evidence ([Unity product](https://assetstore-fallback.unity.com/packages/3d/animations/mma-fight-actions-271650),
read 2026-09-10).

## §2 — The model-API answer, on the record

**Stable Diffusion produces images, not skeletal animation. ElevenLabs produces
audio, not skeletal animation. Neither can supply FightCamp's animation clips.**
The Stable Diffusion repository calls it a “latent text-to-image diffusion
model” ([CompVis](https://github.com/CompVis/stable-diffusion), read 2026-09-10),
and ElevenLabs' endpoint “returns audio” from text-to-speech
([ElevenLabs API](https://elevenlabs.io/docs/api-reference/text-to-speech/convert?explorer=true),
read 2026-09-10).

The applicable category is **text-to-motion**. MDM, MoMask and T2M-GPT accept a
description and emit a temporal human-motion representation, commonly 21/22
SMPL-derived joints or HumanML3D's feature vector; they do not emit a ready
Godot `Animation` on `SkeletonProfileHumanoid` ([T2M-GPT paper](https://arxiv.org/pdf/2301.06052),
[MoMask repo](https://github.com/icedwater/momask), read 2026-09-10). The result
must be converted/fitted to SMPL-family motion, converted to rotations, retargeted,
root-aligned and contact-cleaned. That is materially more work than R94's
ten-line track-path rewrite.

Someone **is shipping generated combat motion as an asset**: Motifect says its
40-motion itch.io pack was generated from text prompts, exported, and reviewed
before release ([Motifect](https://motifect.itch.io/motifect-martial-arts-motion-pack),
read 2026-09-10). That proves a seller can curate text-to-motion into files. It
does not prove a complete MMA set, paired combat, or production ground quality;
the seller publishes no per-move manifest. No cited model project or store page
ships a verified paired chain covering takedown through guard/half/side/mount/back,
passes, sweeps, submissions and ground-and-pound.

## §3 — Grappling verdict

**Only partly: at a price we would pay, FightCamp can show entries, throws and
the existence of a ground exchange, but the ground game must be presented rather
than fully animated.**

There is no verified source here for the minimum paired chain. The best explicit
grappling listing found supplies 10 animations that precede paired motion, while
the free 40-motion pack does not name a single ground state
([Fab grab pack](https://www.fab.com/listings/48ba5d38-296b-4622-9440-aef8df8cf1a0?lang=en),
[Motifect](https://motifect.itch.io/motifect-martial-arts-motion-pack), read
2026-09-10). CMU's commercially usable archive yields seven generic boxing
trials but no verified requested ground class ([CMU combat result](https://mocap.cs.cmu.edu/search.php?maincat=4&subcat=8),
read 2026-09-10).

Therefore do not scope a continuous, literal 3D ground exchange from stock clips.
Use licensed striking clips for stand-up; permit only visually auditioned
entry/throw clips; represent ground state and consequences through a small set
of held paired poses, camera cuts, UI state and the existing simulation until a
purpose-captured paired grappling set exists. A complete animated ground fight
is custom two-performer capture/cleanup work, not a free-library integration.

## §4 — What I would NOT chase

1. **Do not chase open text-to-motion as the production grappling source.** Its
   zero-dollar generation hides prompt iteration, paired-contact repair, root
   alignment, SMPL conversion, retargeting and legal review of weights/data.
   MoMask itself warns that dependencies and datasets have separate licences
   ([MoMask repo](https://github.com/icedwater/momask), read 2026-09-10). It is
   useful for disposable ideation, not a cheaper substitute for paired mocap.

2. **Do not clean the CMU archive clip by clip.** Seven generically labelled
   boxing trials, per-subject skeletons and known noisy toe/hand joints are a
   worse striking path than the already measured 0.2-credit Ludo clips, and its
   catalog does not establish the missing ground chain ([CMU database](https://mocap.cs.cmu.edu/),
   read 2026-09-10).

3. **Do not buy an “MMA” pack whose public page is tags without a manifest.**
   Unity's US$60 example does not publish one; Fab's 10-clip example admits it
   stops before paired motion, and its item licence did not render
   ([Unity](https://assetstore-fallback.unity.com/packages/3d/animations/mma-fight-actions-271650),
   [Fab](https://www.fab.com/listings/48ba5d38-296b-4622-9440-aef8df8cf1a0?lang=en),
   read 2026-09-10). Require the exact move list, paired preview, skeleton and
   binding licence before spending.

**Actionable cheapest check:** download and visually inspect Motifect's free,
commercially-cleared 40 files. Keep only clips that independently pass quality
and contact review. This is a no-cost audition, not a finding that its unnamed
“grappling” category solves the ground game.
