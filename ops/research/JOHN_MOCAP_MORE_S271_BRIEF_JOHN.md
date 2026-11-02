# JOHN_MOCAP_MORE_S271_BRIEF_JOHN - John answer (seat queue SQ6)

Brief: research/JOHN_MOCAP_MORE_S271_BRIEF.md
Sent: 2026-10-20 05:40 | collected: 2026-10-20 06:10 by Tools/seat_queue.py (the 30-min reconcile)
Attachments on the bot's box (not downloaded): JOHN_MOCAP_MORE_S271.md
Verify the sources before using it.

---

On it. I'm starting the S271 mocap research now: free captured boxing sources, free video-to-mocap tools, a capture recipe for filming your own boxer, and a top 5 ranking. Every claim will have its URL and the licence text quoted.

The S271 mocap research has started. I'll paste the full answer here when it's done, with every source's URL and licence quote and the top 5 ranking.

**JOHN_MOCAP_MORE_S271, first pass (part 1 of 2).** Some sources are still NOT VERIFIED, and I've started a second pass to open them. That covers the Unity Asset Store, itch.io, OpenGameArt, Sketchfab, Quaternius, Kenney, Truebones, ActorCore, Reallusion, Mocap Online, most of the datasets, Plask, RADiCAL, Cascadeur, 4DHumans, the Move One licence, and user reviews of fast-punch tracking.

**1a. Rokoko free packs: commercial use OK**
- [13 free fight animations](https://www.rokoko.com/resources/rokoko-mocap-13-free-fight-animations), VERIFIED: "you can use them in any animation, VFX, game, 3D art etc project you want, from passion project to commercial use." The pack is FBX on a Mixamo skeleton at 30 fps.
- [6 free martial arts animations](https://www.rokoko.com/resources/rokoko-mocap-6-free-martial-arts-animations): the same wording appears in a search snippet only (SEARCH-ONLY).
- [Motion Library 10 free fight and weapon animations](https://www.rokoko.com/resources/motion-library-10-free-fight-and-weapon-animations): the licence on that page isn't verified yet. The pricing page snippet says Motion Library clips can be used "in any of your projects, including commercial ones".
- **Clip names** come from an unofficial archive.org mirror, so download the real files from rokoko.com.
  - **FIGHT-MOTIONS pack:** Idle_FightStance, StepForwardandPunch (step-in), FightScene_PersonA/B (a two-person exchange, probably with hits, reactions and blocks: GUESS), WoundedChestFight (probably a body-hit reaction: GUESS), PunchingtheGround, KingKongFight, WrestlingIntro, AngryArgument and sword clips.
  - **MARTIAL-ARTS pack:** **GetUp_WipeBloodfromMouth** (a knockdown get-up candidate), plus MartialArtsKata and sword clips.
  - **SPORTS pack:** JogginginPlace could work as a bounce idle (GUESS).
  - The weapons pack has no boxing.
- The [free resources hub](https://www.rokoko.com/free-resources) lists a "263 free assets" pack, "including for commercial use" (search snippet).

**1b. CMU Graphics Lab database: VERIFIED, the most permissive licence**
- Licence, verbatim from the [CMU FAQ](http://mocap.cs.cmu.edu/faqs.php): "The motion capture data may be copied, modified, or redistributed without permission."
- It was captured with Vicon at 120 Hz.
- Boxing trials from the [CMU boxing search](http://mocap.cs.cmu.edu/search.php?subjectnumber=%&motion=boxing):
  - Subject 13, trial 17.
  - Subject 14, trial 1, plus two more rows whose numbers didn't render (probably 14_02 and 14_03: GUESS).
  - Subject 15, trials 4, 5 and 13.
  - Subject 17, trial 10.
  - Subject 79, trial 8.
  - Subject 80, trial 10.
- Subject 144 wasn't in the boxing search (NOT FOUND).
- These are amateur shadowboxing takes, good for filler punches and footwork but not polished hooks (GUESS).

**1c. Mixamo:** I couldn't verify which boxing clips are mocap-origin, because Adobe doesn't label them.

**1d. Research datasets**
- [LaFAN1](https://github.com/ubisoft/ubisoft-laforge-animation-dataset) is **not shippable**: "Creative Commons Attribution-NonCommercial-NoDerivatives 4.0". It also has no boxing.
- [AMASS](https://amass.is.tue.mpg.de/license.html), and BABEL built on it, are **not shippable**: "any use for commercial purposes, is prohibited … incorporation in a commercial product".
- The rest aren't opened yet.

**1e. Fab:** the [Fab EULA](https://www.fab.com/eula) says "usage is not limited to Unreal Engine" and allows you to "Commercially distribute your Projects with the Fab assets incorporated". So Fab free packs are fine in Godot. I haven't searched for specific boxing packs yet.

**S271, first pass (part 2 of 2)**

**2. Video-to-mocap tools with a free tier**
- **Rokoko Vision 3.0**, in [Rokoko Create](https://create.rokoko.com/):
  - **Free tier:** 30 s of video a month, FBX export, on a Mixamo, HIK or UE5 Manny skeleton. BVH needs the $10/month plan. There's no finger tracking, and it's single camera only, because dual-camera has been removed.
  - **Output licence, verbatim:** "Yes, all generated data with text-to-motion and with video-to-motion can be used commercially."
  - **Caveat:** [a third-party summary](https://assetforgeindex.com/commercial-use/rokoko) says Rokoko's service terms let it sublicense your uploads in anonymised form.
- **Move.ai Move One:**
  - **Free tier:** iPhone only, 30 lifetime credits (about 30 s total), with free videos capped at 30 s ([pricing doc](https://docs.move.ai/knowledge/move-one-pricing), search snippet).
  - **Licence:** a search summary says Move AI owns the output and gives you a royalty-free licence to use it. The EULA page returned 404, so that's NOT VERIFIED verbatim.
- **DeepMotion Animate 3D** is **not shippable on the free tier**. Its [terms](https://www.animate-3d.com/terms-of-use) say "Non-Commercial License … Commercial use is granted with a Paid Plan" (seen in a search snippet), and the [portal](https://portal.deepmotion.com/) shows "Commercial License: Unavailable" for Freemium.
- **[FreeMoCap](https://github.com/freemocap/freemocap)** is open source with AGPL-3.0 code and needs 2+ cameras. Who owns the captured output isn't verified (GUESS: the data is yours).
- **[WHAM](https://github.com/yohanshin/WHAM)** has MIT code but needs SMPL body-model weights, which are non-commercial. That's a FLAG: it isn't shippable without a licence for those weights.
- **[GVHMR](https://github.com/zju3dv/GVHMR)** is **not shippable**: "educational, research and non-profit purposes only … prohibited for commercial use".
- **Fast boxing footage, what to expect** (GUESS, plus vendor statements):
  - Punches blur and lose their extension.
  - The rear arm gets hidden when a boxer stands side-on. Rokoko itself says "occluded limbs will translate in less good tracking capabilities".
  - Expect foot sliding and no finger data, so plan cleanup in Blender.
  - I couldn't get any user-review quotes yet because Reddit was blocked.

**3. Recipe for filming your own boxer (Rokoko Vision, one phone)**
- **Camera:** a tripod at chest height ("between your hips and head"), with head to feet in frame for the whole take. The vendor's "at least 2 m" comes from its old dual-camera guide. I'd guess 3–4 m in landscape.
- **Resolution:** 1080p or higher, per the vendor.
- **Clothing:** tight sportswear that contrasts with the background, not black or baggy.
- **Room:** even, diffuse light, no mirrors, one person in frame.
- **Frame rate:** 60 fps with a fast shutter (1/500 or faster) to cut punch blur, which needs bright light. That's a GUESS, not in the vendor docs.
- **Takes:** one move per take, 3–8 s long, starting and ending in guard, to stretch the 30 s/month quota (GUESS). No T-pose is required.
- **Angle:** about 45° off the front so neither arm is hidden, and repeat each move mirrored (GUESS).
- **Sources:** [Rokoko support guide](https://support.rokoko.com/hc/en-us/articles/29064372040977), [how Rokoko Vision works](https://www.rokoko.com/insights/is-rokoko-vision-generative-ai-how-markerless-motion-capture-actually-works), [Rokoko recording tips](https://support.rokoko.com/hc/en-us/articles/28312013117841).

**4. Top 5 routes (quality × zero cost × licence safety)**
1. **Rokoko free packs.** First step: download the 263-asset pack from the free resources hub, search the clip names for hook, uppercut, hit, fall and get-up, and pull GetUp_WipeBloodfromMouth, WoundedChestFight and FightScene_PersonA/B.
2. **CMU mocap.** First step: get BVH conversions of 13_17, 14_01–03, 15_13, 17_10, 79_08 and 80_10, then cut out the hooks, uppercuts and footwork.
3. **Rokoko Vision on your own boxer** (free 30 s/month). First step: shoot one 5 s test each of a lead hook, a slip and a head-hit reaction using the recipe above, and judge the result.
4. **Move One** (free 30 credits, iPhone). First step: open its EULA and confirm the output licence before filming.
5. **Fab free animation packs.** First step: search Fab for free boxing or martial-arts packs that say they're mocap and use the Standard License.

Ruled out: the DeepMotion free tier, LaFAN1, AMASS/BABEL, GVHMR, and anything that relies on SMPL weights.

I'll post the second-pass findings and a revised top 5 here as soon as it's done.

**S271, second pass.** The best new lead is a **Fab "Boxing Animation Pack" by Ailive**. It has the lead and rear hooks and uppercuts, plus a duck, a sway and footwork. Its $0 price and its licence still need checking in a browser.

**New boxing pack**
- [Ailive Boxing Animation Pack on Fab](https://www.fab.com/listings/02943b05-f6cb-44d6-b73c-bad3d94dc585)
  - The page says: "10 full-body Variable Boxing animations, including finger movement, captured via motion capture and lightly cleaned for usability. Use them freely in your games, cinematic sequences, and various other projects. Animations are based on UE5's Manny character."
  - Clips: Boxing_Footwork, Dudging_with_a_Ducking, Dudging_with_a_Sway, Shadow_Boxing_Quickly, Left/Right_Uppercut, Left/Right_Hook, Punch_with_Left/Right_Hand.
  - **Still open:** "free" appeared only in a search snippet. The page I fetched showed no price and a blank licence field. Ailive also makes an AI animation generator, so some clips might be AI-assisted (GUESS), even though the page says "captured via motion capture".

**Rokoko**
- The licences for the 6-pack and the 263-asset pack are now **verified** from the pages:
  - 6-pack: "you can use them in any animation, VFX, game, 3D art etc project you want, from passion project to commercial use."
  - 263-asset pack: "you can use in any animation, VFX, game, 3D project you want, including for commercial use."
- I couldn't get the 263 pack's clip names because the download sits behind an email form.
- The Motion Library 10-pack's licence still isn't on its page, and the pack turns out to be weapon clips (knife, grenade, guns, bow). It's of little use for boxing.

**Stores and libraries**
- **Out on budget:** the Unity "Boxing animation package" (67 mocap clips) costs $14.99.
- **Free Unity packs, search snippet only:** "Free Those Who Fighter Animations" and Magicpot's "Fighting Motions Vol.1" (25 karate and kickboxing moves). I didn't check whether either is mocap.
- **Unity assets in Godot:** Unity's support article says (snippet) "Unity Asset Store assets are not restricted to Unity projects. You can use them with other engines provided you follow the EULA guidelines". Two limits: it doesn't apply to Restricted Assets, and the EULA (section 2.2.1(a)) allows use only "as an embedded component" of the game.
- **MoCap Online free Sampler Pack:** "Standard License, which permits use in commercial projects - including games" (snippet). It isn't boxing-specific.
- **Quaternius Universal Animation Library:** "Free to use in personal, educational and commercial projects. (CC0 License)". It has Punch Jab and Hit Head, but I didn't confirm whether those are mocap or keyframed.
- **Kenney** is CC0 but has no boxing mocap.
- **MocapFlow (GitHub)** is low trust: its readme says CC BY 4.0 while its licence file says CC0, and where the capture came from is unknown.
- **Nothing usable:**
  - Sketchfab: the boxing items were non-commercial or made from Mixamo clips.
  - ActorCore: its "Free Fight" pack is listed at $99 (snippet).
  - Truebones, itch.io, OpenGameArt and Reallusion had nothing.

**Datasets: none has boxing mocap you could ship**
- **Not shippable:**
  - Motorica: "Use for commercial purposes is not permitted without prior written consent."
  - Human3.6M: academic use only.
- **CC BY 4.0 but no boxing:** 100STYLE (Zenodo 8127870) is stylised walking only. Emokine (Zenodo 7821844) and AIST++ (snippet) are dance.
- **Unverified:**
  - HDM05: CC BY-SA 3.0, per a snippet.
  - Berkeley MHAD: BSD-2 per a snippet, and it might include punching (GUESS).
  - KIT: "freely available to the scientific community", per a snippet.
  - SFU: the site returned nothing.
- **Zenodo search for "boxing":** no dataset.

**Video tools**
- **Move One:** its licence is now verified at [Move One app EULA](https://www.move.ai/move-one-app-eula).
  - Ownership (7.1.2): "Move AI owns and shall retain ownership of all Intellectual Property Rights in and to ... the Motion Data, Output".
  - Grant (7.3): "Move AI hereby grants to you a worldwide, royalty-free, fully paid-up, non-exclusive transferable, sublicensable licence of all Intellectual Property Rights it owns in the Output".
  - It bans using the output "to train any AI System" or "as an input for any AI System".
  - My reading is that shipping the output in the game is allowed, including on the free tier. That's an interpretation, not legal advice.
- **Not usable on free tiers:**
  - Plask: "personal non-commercial use".
  - Cascadeur: "Free and Educational plans don't allow any commercial use", and its free plan exports only its own CASC format.
- **RADiCAL** now redirects to Autodesk Flow Studio, which denied access, so I'm treating it as unavailable.
- **4D-Humans** has MIT code but relies on non-commercial SMPL body-model weights, so it isn't shippable.

**Evidence on tracking fast punches**
- Lahkar et al. 2022 (Frontiers) tested a 10-camera markerless system against marker-based capture on elite boxers.
  - It found "higher differences ... at the elbow (more than 3 cm)" and wrist and elbow errors "more than or equal to 20° in some DoFs".
  - The front arm was worse, which the authors put down to its "relatively higher and faster movement".
  - A single phone will likely do worse (GUESS).
- Reddit was blocked again, so there are still no user reviews.

**Revised top 5 (quality × zero cost × licence safety)**
1. **Fab Ailive Boxing Animation Pack.** It's the only free source found for hooks, uppercuts, a duck, a sway and footwork. First step: open the listing and confirm the $0 price, the Standard License and how it was made, then export the FBX files (UE5 Manny skeleton).
2. **Rokoko free packs** (13 + 6 + 263, licences verified). First step: fill in the email form, download the 263 pack, and search the clip names for hit, fall, getup, block and sit.
3. **CMU mocap.** It has the most permissive licence and suits filler punches and footwork. First step: get BVH versions of 13_17, 14_01–03, 15_13, 17_10, 79_08 and 80_10.
4. **Rokoko Vision free tier (30 s a month) on your own boxer.** It's the only free way to cover slips, rolls, parries, the clinch, hit reactions, knockdowns and corner sitting. First step: film one 5-second test per move using the recipe in my previous message.
5. **Move One free credits (30, iPhone).** First step: film the same test moves and compare them with the Rokoko Vision results.

Ruled out: the Plask, Cascadeur and DeepMotion free tiers (all non-commercial), RADiCAL (unavailable), and 4D-Humans, WHAM and GVHMR (non-commercial SMPL weights or code). The full report is attached.
