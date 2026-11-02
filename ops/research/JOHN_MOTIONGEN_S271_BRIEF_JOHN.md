# JOHN_MOTIONGEN_S271_BRIEF_JOHN - John answer (seat queue SQ7)

Brief: research/JOHN_MOTIONGEN_S271_BRIEF.md
Sent: 2026-10-20 06:40 | collected: 2026-10-20 07:10 by Tools/seat_queue.py (the 30-min reconcile)
Attachments on the bot's box (not downloaded): JOHN_MOTIONGEN_S271.md
Verify the sources before using it.

---

On it. I'm starting the S271 motion-generator research now. It covers every text-to-motion and video-to-motion tool active in 2026, which ones have shown a real boxing punch, how they handle fast hands, and a top 5 with the first test to run on each.

The S271 motion-generator research has started. I'll paste the full answer here when it's done, with a dated URL and quoted licence for every claim and the top 5 tests.

The first pass on motion generators came back thin. I opened only four sources, so I've started a deeper second pass. Three findings are already solid, all checked today (2026-10-20):

- **Tencent HY-Motion 1.0 is out for us.** Its licence defines the territory as "worldwide … excluding the territory of the European Union, United Kingdom and South Korea", and Cyprus is in the EU. Sources: [HY-Motion on GitHub](https://github.com/Tencent-Hunyuan/HY-Motion-1.0), released 2025-12-30 per [Hugging Face](https://huggingface.co/tencent/HY-Motion-1.0).
- **Uthana has no free tier any more.** "Uthana stopped offering new subscriptions in August 2026", and it's now pay-as-you-go only: text-to-motion 3.0 is $0.10/s and video-to-motion 2.1 is $0.05 per input second. Its licence says "Paid usage includes commercial use of generated outputs" ([Uthana pricing](https://uthana.com/pricing), undated).
- **No generator has shown a real skeletal boxing punch so far.** The boxing results I found are all 2D video templates with no skeleton, such as [Higgsfield's Boxing preset](https://higgsfield.ai/motion/17a55db6-8775-4a9f-a2c9-d0d373bee590).

The second pass covers Meshy, Kinetix, Krikey, Tripo, NVIDIA's models, Autodesk Flow Studio, Move Gen2, the open models' training-data licences, X and YouTube demos, and the fast-punch comparison papers. I'll post the full answer and top 5 when it's done.

**JOHN_MOTIONGEN_S271 is done (part 1 of 2).** No generator has shown a verified skeletal jab driven from the legs or a hook with a pivot. The X search came back empty. Two free leads that allow commercial use are worth testing: **NVIDIA Kimodo** and **Meshy's animation library**. I opened every page today (2026-10-20); the source's own date is in brackets.

**1. Tools, free tiers and licences**
- **NVIDIA Kimodo-SOMA-RP v1.2** [released 2026-10-15]
  - **Licence:** the code is Apache-2.0. The model is under the NVIDIA Open Model License: "This model is ready for commercial use", and "NVIDIA claims no ownership rights in outputs" [undated].
  - **Training data:** licensed studio mocap, not AMASS: "Bones Rigplay … over 700 hours of production-quality human motion … covers … videogame combat".
  - **Running it:** free locally. It needs about 17 GB of GPU memory, or under 3 GB with `TEXT_ENCODER_DEVICE=cpu`, and makes at most 10 s per prompt.
  - **Output:** NPZ, or BVH with `--bvh`, on its own SOMA skeleton. Retargeting to Mixamo and the frame rate are NOT VERIFIED.
  - **Avoid:** the SMPL-X variant, which is under an R&D licence.
- **Meshy animation library** (ready-made clips, not generated)
  - **Free plan:** 100 credits a month.
  - **Licence** [terms updated 2026-09-19]: free-plan output is licensed "under the Creative Commons Attribution 4.0 International License … as long as the free plan customer provides appropriate credit to Meshy". So commercial use is fine with a credit line.
  - **Clips listed:** Right_Jab_from_Guard (192), Right/Left_Uppercut_from_Guard (194/196), Punch_Combo ×4, Boxing_Practice, Dodge_and_Counter, Block ×5, Stand_Dodge ×3, Face_Punch_Reaction_1, Hit_Reaction_to_Waist, Knock_Down ×2, and Walk_Fight forward and back. Left Hook and Left Jab appear only in search snippets.
  - **Still unknown:** whether CC BY also covers the bundled library clips, the credits each clip costs, and the exact skeleton.
- **Rokoko** [undated]
  - **Free Starter plan:** "30 seconds of Vision AI video processing per month, unlimited Text-to-Motion clips, and .FBX export" on "UE5 Manny, HIK, Mixamo skeletons".
  - **Licence:** "Yes, all generated data with text-to-motion and with video-to-motion can be used commercially."
  - Vision 3.0 has a rebuilt solver, and [Rokoko Create](https://create.rokoko.com/) shows a "Sparring / Fast-paced motions" example that I didn't inspect.
- **Move One** ([Move One EULA](https://move.ai/move-one-app-eula), undated)
  - **Free plan:** "a one-time amount of 30 credits", with videos up to 30 s. Gen 2 costs 2 credits per second, so about 15 s total, if free accounts can use Gen 2 (NOT VERIFIED).
  - **Licence (7.3):** "worldwide, royalty-free, fully paid-up, non-exclusive transferable, sublicensable licence … in the Output".
  - **Catch (7.2):** you give Move AI a "perpetual, irrevocable" licence to your video, which it uses for "training and improvement of our products".
- **[Uthana](https://uthana.com/pricing)** [undated, mentions August 2026]: no free tier, because it "stopped offering new subscriptions in August 2026". Text-to-motion 3.0 costs $0.10/s and video-to-motion 2.1 costs $0.05 per input second. "Paid usage includes commercial use of generated outputs."
- **Kinetix:** "the User may use the Outputs for commercial purposes", but Kinetix may train AI on your inputs and outputs. It now looks focused on video, and its free tier and skeleton export are NOT VERIFIED.
- **Krikey:** 20 free credits, once. Its 2024 terms allow commercial use. A reported $100k revenue cap and FBX being Pro-only are NOT VERIFIED.
- **Anything World:** free under $100K revenue, with the credit "Animated by Anything World" required. It has no boxing content.
- **Autodesk Flow Studio** (formerly RADiCAL): it has a free tier with USD export. Whether the free tier allows commercial use is NOT VERIFIED.
- **Ruled out:**
  - **Tencent HY-Motion 1.0:** the territory is "worldwide … excluding the territory of the European Union, United Kingdom and South Korea", and Cyprus is in the EU ([HY-Motion on GitHub](https://github.com/Tencent-Hunyuan/HY-Motion-1.0), released 2025-12-30).
  - **DeepMotion:** "Freemium accounts are available for personal, non-commercial use."
  - **Cascadeur:** "Free and Educational plans don't allow any commercial use", and the free plan exports only CASC files.
  - **Tripo:** its free tier is "Non-Commercial Use".
  - **Plask:** its free tier is personal, non-commercial.
  - **Sloyd:** commercial use needs a paid plan.
  - **Mootion:** "now a paid product", and it makes videos.
  - **Open models MoMask, MDM, MotionGPT, T2M-GPT:** the code is MIT or Apache-2.0, but the weights are trained on AMASS data. The AMASS licence says "any use for commercial purposes, is prohibited … production of other artefacts for commercial purposes". That's my reading, not legal advice.
  - **Higgsfield:** its [Boxing preset](https://higgsfield.ai/motion/17a55db6-8775-4a9f-a2c9-d0d373bee590) is 2D video, not a skeleton.

**S271 motion generators (part 2 of 2)**

**2. Real boxing punch demos:** none verified. The closest leads are Meshy's jab, uppercut and combo previews, Rokoko's "Sparring" example and Kimodo's "videogame combat" training data, and I haven't watched any of them.

**3. Video-to-motion on fast hands**
- **Lahkar et al., Frontiers** [2022-07-25]: a 10-camera markerless system (Theia3D) tested against marker-based capture on elite boxers.
  - Elbow error was over 3 cm, while shoulder and wrist were under 2.5 cm.
  - Joint twist was poorly captured, but hand speed matched well (front hand peaked at 7.5 vs 7.0 m/s).
  - That's a best case; a single phone will do worse.
- **Jie & Chung** [accepted 2026-01-02]: one camera at 60 fps, with no punches tested.
  - Scores out of 5: Rokoko Vision 3.4, DeepMotion 4.2, Meshcapade 4.1.
  - All three failed when limbs touched or blocked the body, and "Rokoko Vision failed to capture individual fingers".
  - The test may predate Vision 3.0.
- **Sinfull Studios** [2026-06-18]: "single-cam blocks, multi-cam ships". Every tool leaves jitter, foot sliding and popping limbs. Note that this studio sells cleanup work.

**4. Top 5** (quality untested, so the order is a GUESS)
1. **Meshy library** (free, CC BY 4.0).
   - **Test:** auto-rig a humanoid, apply clips 192, 194, 198, 175 and 187, export FBX, and retarget in Godot with a SkeletonProfileHumanoid BoneMap.
   - **Check:** the hip turns, the rear heel lifts, and the punch returns to guard. Judge whether it looks like mocap or hand-keyed, and confirm the credit cost and the attribution text.
2. **Kimodo v1.2** (free locally, commercial use OK).
   - **Test:** `kimodo_gen "A person in a boxing stance throws a left hook, pivoting on the front foot and rotating the hips, then returns to guard." --duration 3 --num_samples 4 --bvh --output hook`. Repeat for a jab, an uppercut, a slip, a roll and "knocked down then stands up".
   - **Check:** the BVH opens in Blender, the pivot is real, and the SOMA bones map to Mixamo names.
3. **Rokoko** (unlimited free text-to-motion plus 30 s a month of Vision).
   - **Text test:** "A boxer throws a jab-cross-left hook combination, pivoting the lead foot on the hook."
   - **Vision test:** 10 s at 60 fps from a 3/4 front view on a plain background, with a real boxer throwing a jab, cross, lead hook and rear uppercut, then a slip and a roll.
   - **Check:** the fists reach full extension, the elbows don't pop, and the feet don't slide.
4. **Move One** (30 free credits, once).
   - **Test:** the same clip as the Rokoko Vision test, compared side by side at full extension and foot planting.
5. **Uthana** (paid). This is the first fallback if the free routes fail.
   - **Test:** video-to-motion 2.1 on the same clip, about $0.50.

**Not covered yet:** Higgsfield's 3D tools, whether free Move accounts can use Gen 2, the Flow Studio and SayMotion terms, and Meshy's full list of export formats. The full report is attached.
