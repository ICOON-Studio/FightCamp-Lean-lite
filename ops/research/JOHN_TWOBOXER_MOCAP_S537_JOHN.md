# JOHN_TWOBOXER_MOCAP_S537_JOHN - John answer (seat queue SQ286)

Brief: research/JOHN_TWOBOXER_MOCAP_S537.md
Sent: 2026-11-22 01:40 | collected: 2026-11-22 02:10 by Tools/seat_queue.py (the 30-min reconcile)
Verify the sources before using it.

---

On it. I'm starting with the newest multi-view video and contact-aware two-person 3D releases, and I'll check the licence and AMD support for each one.

The S537 search is running now, newest releases first, with a link, date and evidence label on every claim. When it's done you'll get the full memo here: the five tables, the top 3 for two boxers in contact, and what I couldn't verify.

**J_TWOBOXER_MOCAP_S537 is done.** Nothing yet renders two fighters in contact from 2 to 4 truly synced AI cameras. Three things are new since our G76 test:
- **Cartwheel**: cloud capture of up to 4 people at once, with FBX, glTF or BVH out, commercial use allowed, and no training on your uploads.
- **Meta's SAM 3D Body with MHR**: a body model and solver we can ship commercially, with no SMPL involved.
- **Cartwheel Swing Choreo**: two-person motion straight from text.

Also, Epic bought Meshcapade on 18 Feb 2026, so commercial SMPL licences now come from Max Planck Innovation. I found no published two-person contact or clinch test for any tool, so the contact rows are the makers' claims or not verified. Full memo below; it's also in `/workspace/twoboxer/J_TWOBOXER_MOCAP_S537.md`.

Labels: **DOC** means documented by the maker or a paper, **TBO** tested by others, **NV** not verified, and **DER** my own sum from documented facts. "NOT FOUND" means no maker price.

## Q1. AI video with true multi-view or 4D consistency

| Tool / paper (date) | What it really does | Same moment from 2–4 cams? | Two fighters in contact? | Licence / AMD | Label + link |
|---|---|---|---|---|---|
| Kling 3.0 multi-shot | Up to 6 shots in one request, each with its own prompt | **No.** The shots are cuts that follow each other | No example found | Paid API | DOC [Kling 3.0 API](https://dev.runway.com/learn/kling-3-0-api) (2026) |
| Runway multi-shot; Veo 3.1 timed prompts | 3–5 shots in one video | **No** (one after another) | No example found | Paid | DOC via [prompt-architects](https://prompt-architects.com/blog/464-prompting-multi-shot-sequences-scene-by-scene) (2026); NV on the maker's page |
| Runway Aleph "new angle" | Re-renders an uploaded clip from a new angle | One extra **made-up** view per run | No fight example | Paid | DOC [Runway Academy](https://academy.runwayml.com/tutorial/generate-new-angles-with-aleph) (2025–26) |
| Seedance 2.0, Sora, Hailuo, Veo | One camera only | No multi-view feature found | Already failed for us (G76) | Paid | NV |
| ReCamMaster (ICCV 2025) | Re-shoots one video along a new camera path | Many views, all guessed from one source | No fight example | Code MIT. The authors say the open Wan2.1 port "may not achieve" paper quality | DOC [ReCamMaster](https://github.com/KlingAIResearch/ReCamMaster) (Apr 2025) |
| SynCamMaster (ICLR 2025) | Text to several synced cameras | Yes in the paper's model; the open port is weaker | No fight example | Licence NV | DOC [SynCamMaster](https://github.com/KlingAIResearch/SynCamMaster) (Apr 2025) |
| Reshoot-Anything (Morphic) | Wan2.2 add-ons that re-shoot a video along a new path | One re-shoot per run | No fight example | Apache 2.0. Example uses 8 NVIDIA GPUs | DOC [Hugging Face](https://huggingface.co/morphic/reshoot-anything) (Apr 2026) |
| SyncVid | One clip to several synced views | Yes (research) | No people-in-contact example | Code not released | DOC [arXiv 2610.31765](https://arxiv.org/abs/2610.31765) (Oct 2026) |
| Flex4DHuman (World Labs) | One video to synced views to a 4D scene | Yes | **One person only** | Wan2.1 base | DOC [arXiv 2606.13655](https://arxiv.org/abs/2606.13655) (Jun 2026) |
| MV-Performer; 4DAnyone | Multi-view video of one performer | Yes | One person only | MV-Performer has no licence file | DOC [arXiv 2510.07190](https://arxiv.org/abs/2510.07190) (Oct 2025); [4DAnyone](https://www.emergentmind.com/papers/2608.20335) (Aug 2026) |
| MagicFight | Two-person martial-arts video from 2 photos plus poses | One view only | Yes, but it needs the poses as input | Research | DOC [arXiv 2601.02107](https://arxiv.org/html/2601.02107v1) (Jan 2026) |
| Wan 2.2 14B on AMD | Runs on an RX 9070 XT 16 GB, about 6.5 min per 81 frames | — | — | Apache 2.0 | TBO [AMD Pro Bench](https://amd-pro-bench.com/video-benchmarks/models/wan) (2026) |

**Answer.** No tool shows two fighters staying physically consistent across views, and I found no multi-view fight, dance or martial-arts example. Every human multi-view paper shows one person.
- **DER:** every "new camera" method starts from one video. A glove hidden in a wrapped guard is therefore guessed in the new view, not seen. That's the G76 trap again, only prettier.
- If we use AI video at all, it should be one clean, wide, static clip shot side-on.

## Q2. Two people in 3D from video, contact-aware (✗ means we can't ship it)

| Model (date) | Occlusion / contact | Skeleton out | Licence: code / weights / body model | AMD | Label + link |
|---|---|---|---|---|---|
| **Meta SAM 3D Body** (Nov 2025; CVPR 2026) | You give it a mask per person. In close contact, error drops from 91.4 to 58.3 mm. **It doesn't model contact:** each person is solved separately, and tangled limbs are a weak spot | MHR body, hands and feet | Code and weights under the SAM License (commercial OK; bans military uses). MHR under **Apache 2.0** ✓ | PyTorch. AMD's ROCm 7.2.1 supports RX 7900 XTX / 9070 on Windows; SAM 3D Body on it is NV | DOC [licence](https://github.com/facebookresearch/sam-3d-body/blob/main/LICENSE), [MHR](https://github.com/facebookresearch/MHR), [AMD notes](https://www.amd.com/en/resources/support-articles/release-notes/RN-AMDGPU-WINDOWS-PYTORCH-7-2-1.html) |
| **SAM-Body4D** (Dec 2025, updated May 2026) | Video version: tracks each person, fills in hidden body parts, then runs SAM 3D Body. Claims "robust multi-human recovery under heavy occlusions" | MHR per person per frame | Wrapper MIT. Infill weights licence NV | Installs NVIDIA builds; AMD NV | DOC [SAM-Body4D](https://github.com/gaomingqi/sam-body4d), [arXiv 2512.08406](http://arxiv.org/abs/2512.08406) |
| SAM3DBody-cpp (2026) | Holds the last pose through short occlusions | **One BVH per person**, bones sized to each fighter | MIT. Bundles a detector that may be AGPL (NV); it's a tool, not shipped | **NVIDIA only**; slow on CPU | DOC [SAM3DBody-cpp](https://github.com/AmmarkoV/SAM3DBody-cpp) |
| Pose2Sim (multi-camera) | **Real multi-view:** matches people across 2+ calibrated phones and triangulates. What's new against our fail: each joint is seen from several cameras, not guessed from one | BVH | BSD-3, no SMPL ✓ | Runs on CPU | DOC [Pose2Sim](https://github.com/perfanalytics/pose2sim) (Nov 2026) |
| PromptHMR, GVHMR, WHAM, Multi-HMR, BUDDI | Various | SMPL or SMPL-X | ✗ code, weights or body model non-commercial | — | DOC [PromptHMR](https://github.com/yufu-wang/PromptHMR/blob/main/LICENSE), [GVHMR](https://raw.githubusercontent.com/zju3dv/GVHMR/main/LICENSE), [WHAM](https://github.com/yohanshin/WHAM/blob/main/LICENSE), [Multi-HMR](https://huggingface.co/spaces/naver/multi-hmr/blob/main/Checkpoint_License.txt), [BUDDI](https://github.com/muelea/buddi) |
| SocialMirror, InterMesh, CISyn, Human3R (2025–26) | The newest close-contact research | SMPL / SMPL-X | ✗ | — | DOC [2604.13581](https://arxiv.org/abs/2604.13581), [2605.04554](https://arxiv.org/abs/2605.04554), [2611.18894](https://arxiv.org/abs/2611.18894) |
| Anny (Naver) | A body model only, not a solver | — | Apache-2.0 + CC0 ✓ | — | DOC [Anny](https://github.com/naver/anny) |

Max Planck Innovation now licenses SMPL directly; price NOT FOUND ([MPG](https://www.mpg.de/26082348/max-planck-spin-off-draws-epic-games-to-tubingen), Feb 2026).

## Q3. End-to-end apps (2026)

| App | Two people? | Contact | Export | Price as found | Commercial / training clause | Link |
|---|---|---|---|---|---|---|
| **Cartwheel Performance Capture (Comic 4)**, new | **Up to 4 per pass**, sharing one world space and scale; hands, face and ground contact | No contact test published (NV) | FBX, glTF, USD, BVH; free retarget tool | 1 credit per person per second. Plan prices aren't on the maker page; a reseller says $19 for 200 credits (NV). 7-day trial | Commercial OK; **"does not use any User Content … to train"** ✓ | DOC [product](https://getcartwheel.com/product/performance-capture), [pricing](https://getcartwheel.com/pricing), [terms](https://getcartwheel.com/terms-of-use) |
| Autodesk Flow Studio | 2–4 performers depending on the plan | **The maker says character-to-character interaction is "not supported"** | Maya, Blender, USD | $7 to $64 a month | Commercial OK, but content may be used for "improving Offerings"; the opt-out is default only on Enterprise | DOC [pricing](https://blogs.autodesk.com/media-and-entertainment/2026/09/28/autodesk-flow-studio-pricing-and-subscription-guide/), [limits](https://help.wonderdynamics.com/working-with-wonder-studio-getting-started/platform-limitations/), [terms](https://www.autodesk.com/company/terms-of-use/en/general-terms) |
| DeepMotion | Up to 8 (beta) | No contact claim | FBX, BVH, GLB | $9 to $83 a month (third-party copy, NV) | Paid plans only; irrevocable licence to use uploads to "improve" its service | DOC [guide](https://www.deepmotion.com/post/multi-person-tracking-guide), [terms](https://www.deepmotion.com/terms-of-use) |
| Move.ai Move Pro | 1–8 people, multi-camera | NV | FBX | Enterprise, custom quote | **Still a perpetual training licence** on your video | DOC [products](https://move.ai/products), [EULA](https://move.ai/move-pro-eula) |
| MetaHuman Animator Markerless (UE 5.8), new | **One performer only.** In a two-person dance test the tracker got confused | FBX via Unreal; MetaHuman animations may ship in Godot | **Free, commercial OK**, runs locally | — | DOC [Digital Production](https://digitalproduction.com/2026/06/23/metahuman-gets-markerless-mocap/); TBO [Arcnel](https://note.com/arcnel/n/n172a2b162ee0); [licence](https://www.cgchannel.com/2025/06/you-can-now-sell-metahumans-or-use-them-in-unity-or-godot/) |
| Rokoko Vision | No; dual-camera retired 16 Aug 2026 | — | FBX, BVH | $10 to $50 a month | NV | DOC [support](https://support.rokoko.com/hc/en-us/articles/48823033216017-Rokoko-Vision-and-Rokoko-Create-What-you-need-to-know) |
| Uthana | No, one person | — | FBX, GLB | $0.06 a second | You own paid outputs | DOC [Uthana](https://uthana.com/models/video-to-motion) |
| Kinetix | No public app; its tech is licensed to other companies | — | — | NOT FOUND | — | DOC [Kinetix](https://kinetix.tech/) |
| Meshcapade MoCapade | Platform shut after the Epic deal | — | — | — | — | NV ([mimem.ai](https://www.mimem.ai/alternatives/meshcapade)) |

The cloud apps run in a browser, so our AMD card doesn't matter for them.

## Q4. Text- or video-to-motion for two people

| Model (date) | Two people? | Commercial? | Notes | Link |
|---|---|---|---|---|
| **Cartwheel Swing Choreo** (13 Oct 2026) | **Yes, 1–4**, directed beat by beat | **Yes**; no training on our prompts or outputs | 3 credits a second for 1–2 people. Training data and boxing quality NV | DOC [Swing](https://getcartwheel.com/model/swing) |
| InterGen and models trained on its data | Yes | ✗ data is CC BY-NC-SA | — | DOC [InterGen](https://github.com/tr3e/InterGen) |
| PhysiGen, Text2Interact, Interact2Ar, InterCMDM (2026) | Yes | ✗ non-commercial data or no licence | PhysiGen halves body overlap | DOC [PhysiGen](https://github.com/iSEE-Laboratory/PhysiGen), [Text2Interact](https://github.com/Qingxuan-Wu/Text2Interact), [Interact2Ar](https://github.com/pabloruizponce/Interact2Ar), [InterCMDM](https://arxiv.org/html/2607.01743) |
| NVIDIA Kimodo v1.2 (Oct 2026) | **One person**, with hand and foot targets | Commercial-licensed data ✓; NVIDIA only | Whether it can pin a glove to a moving opponent is NV | NV via [Littlewolf](https://news.littlewolflabs.com/posts/2026-10-18-ai-mocap-compared) |
| Tencent HY-Motion 1.0 | One person | ✗ **licence excludes the UK** | — | DOC [licence](https://huggingface.co/tencent/HY-Motion-1.0/blob/main/LICENSE.txt) |

## Q5. The two best routes

**Route A: phone video (or one AI clip) through Cartwheel, in the cloud, so AMD is fine**
1. **Film:** one phone on a tripod at chest height, side-on, 3–4 m away, 60 fps, both full bodies in frame. A second phone at 90° is optional and only for checking. The AI version is one static, wide, side-on clip with no cuts.
2. **Solve:** Comic 4 with people set to 2 and world placement kept on. Export FBX or glTF, one rig per fighter.
3. **Clean:** in Blender, pin the gloves to the guard and head on the contact frames with constraints. Cascadeur Indie is optional (about $8 a month, NV).
4. **Retarget:** Cartwheel's free tool or Blender.
5. **Into Godot:** GLB with a BoneMap and the humanoid skeleton profile ([Godot docs](https://docs.godotengine.org/en/stable/tutorials/assets_pipeline/retargeting_3d_skeletons.html)).

The cost of a 10 s clip with two people is 20 credits (DER).

**Route B: SAM 3D Body run ourselves, nothing uploaded, every licence commercial**
1. Film as in Route A, ideally with 2–3 phones for a Pose2Sim cross-check.
2. Solve with SAM-Body4D, then lock each fighter's body shape across frames.
3. Convert MHR to BVH, then clean, retarget and export as in Route A.

Hardware: built for NVIDIA. Try AMD's ROCm 7.2.1; if it fails, rent a cloud NVIDIA GPU (price NOT FOUND). The software costs nothing; setup time is the catch.

**The one test:** a scripted 10 s clip through both routes. It runs 2 s at range, 3 jabs on the guard, 1 hook to the head, 2 s of wrapped-guard clinch, then the break. It passes only if every line holds (thresholds are ESTIMATES):
- both bodies found in 100 % of frames (G76 found 36–40 %);
- 0 identity swaps;
- the glove lands within 5 cm of its target on all 4 contact frames;
- no arm goes through a body for more than 3 frames;
- a planted foot slides 2 cm or less;
- an animator needs an hour or less to make it shippable.

Check the result against the 90° phone.

## Top 3 for two boxers in contact, shippable this year
1. **Cartwheel Comic 4 on real phone video.** It takes 2–4 people in one shared space, exports FBX, glTF or BVH, allows commercial use and doesn't train on uploads. *Catch:* nobody has published a contact or clinch test, the solver is closed, the plan prices sit behind a login, and our footage leaves the building.
2. **Cartwheel Swing Choreo, text to two-person motion.** It skips video entirely. *Catch:* it's new, there are no boxing examples, its training data is undisclosed, and the gloves will need touching up in Blender.
3. **SAM 3D Body / SAM-Body4D, run ourselves.** It's the only open stack where the code, weights and body model all allow commercial use. *Catch:* it solves each person separately with no contact model, tangled limbs are its weak spot, it's built for NVIDIA and untested on AMD, and it's more engineering.

**Not recommended:**
- **Flow Studio:** the maker says interactions aren't supported.
- **Move Pro:** it keeps a training licence on your video and is priced for enterprises.
- **MetaHuman Markerless, Rokoko and Uthana:** one person only.
- **AI "multi-view" video:** the extra views are guessed, not filmed.
- **SMPL-based models:** only if we buy SMPL from Max Planck.

## What I couldn't verify
- Two-person contact or clinch accuracy for any tool: there's no benchmark or independent test.
- Cartwheel's plan prices and Swing Choreo's training data.
- Prices on the maker pages: Move Pro's Enterprise price, and DeepMotion's and Cascadeur's (I only found third-party copies).
- Whether SAM 3D Body, SAM-Body4D or Pose2Sim run on AMD; cloud GPU prices.
- These licences: the infill weights, SynCamMaster, and the detector inside SAM3DBody-cpp.
- Whether MetaHuman Markerless is built on PromptHMR.
- Any commercial video model with truly synced multi-camera output: none found.
- Whether Kimodo can pin a glove to an opponent.
- When Meshcapade shut down.

Beast is still offline, so I haven't filed this in the research folder or told Claude yet. It's next in line once Beast is back, after the other memos waiting for it.
