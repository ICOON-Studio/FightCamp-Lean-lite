# G76 - TWO FAILURES AND WHAT ELSE (Grok, Expert) - RAW CAPTURE OF THE CHAT ANSWER

Collected by Claude, S59, 2026-09-23, from grok.com/c/5e70ef35-1c6c-4848-aae1-e66746c80426 ("Multi-Person Video
Mocap Fails for Grappling"). 151 sources. Message text verbatim below (tables flattened to tab-separated lines by the
page). Task: `TASK_G76_TWO_FAILURES_AND_WHAT_ELSE.md`. Claude's verification note is at the END.

---

Split-screen does not give two cameras. It is one generated image. Detectors still see overlapping silhouettes. Southpaw fails because T2M priors are orthodox-mode, not because the word is missing. Mirror the clip.

1. Failure 1 — why bodies merge

Cause (judgement, matching your numbers).

RTMDet + RTMPose + per-crop MediaPipe is a detect → crop → single-body 2D → independent 3D lift stack. Wrapped guard is one blob.

Person detectors (COCO / CrowdPose lineage) expect separable upright people. Closed-guard wrap + similar shorts = one instance or a chopped crop. That matches 36–40% found on 1×2 guard vs 93–100% on side-view mount (your N per condition; side mount is two torso blobs).
Overhead / end-on: 9.8% / 3.6%. Extreme foreshortening + stacked bodies. Classic monocular failure.
Identity swaps 3.6–11.8%: no ReID memory across frames; two similar athletes, same pose family. ByteTrack-style IoU association flips when boxes merge.
MediaPipe on a crop that still contains both people assigns the other limbs. Holistic/Pose is single-person.
Seedance keeps the 1×2 layout; it does not create calibrated extrinsics. Two panels ≠ stereo. 3D in metres from two independent lifts has no shared world frame and no contact constraint.

Split-screen "same instant, opposite sides" only helps if you already have two detections. Guard is where detection dies.

Methods that model interaction (not just two detections).

Method	What	Licence	Local Win + 1×NVIDIA	Close-contact numbers / datasets
AvatarPose	Multi-view; Instant-NGP avatars + SMPL deform; collision on overlapping shape; skips noisy 2D	Research paper; deps mixed	Yes in principle (heavy)	Beats Faster VoxelPose / MvP on Hi4D, CHI3D (close hug/dance/fight) arXiv
CloseInt / appearance+proxemics (2025)	Monocular two-person SMPL; appearance + proxemics + physics	Research	Yes	Hi4D MPJPE 59.1 / PA 44.3; vs BEV 91.8 / 52.2. Datasets: Hi4D, CHI3D, 3DPW, InterHuman arXiv
Reaction Priors (CVPR 2024, NetEase)	Monocular; pose of A conditions B	Research	Yes	Hi4D MPJPE 75.0; CHI3D 71.9. New Dual-Human (~2k close sequences) Openaccess.thecvf
MultiPhys	Physics + penetration on two SMPLs	Research	Yes	Inter-body penetration ×7 better than SLAHMR on CHI3D / Hi4D / ExPI arXiv
Combat-sports multi-view (2025)	Sparse cams + ViTPose + epipolar ID + physics collision	Research	Yes	Built for combat; no public grappling MPJPE table found
ProsePose	LMM contact constraints on two-person SMPL	Research	Yes	FlickrCI3D; PCC / joint PA-MPJPE; hugs, tango, tackle — not wrap-guard
BUDDI / CloseInt family	Joint two-SMPL fit	Research	Yes	Same Hi4D/CHI3D tables; still ~4–8 cm PA-MPJPE
SAM3 + SAM-3D-Body	Segment-first, then mesh; video ID via memory / DINOv2 stitch	SAM weights: Meta research licence (check current); not a game ship asset	Yes (ONNX ports exist)	Tracking papers, not grappling MPJPE. Segmentation-first is the right order for wrap poses
EasyMocap	Calibrated multi-view → SMPL / SMPL-X	Code open; SMPL-X academic-only unless Meshcapade commercial	Yes (Windows installs exist, painful)	ZJU multi-person ballet etc. Needs synced calibrated cams, not a generated split
SMPL / SMPL-X itself	Mesh prior + contact loss	Academic free; commercial = Meshcapade	Yes	Contact methods (TUCH, SMPLify-XMC, RICH) measured on self-contact / scene-contact, not BJJ wrap

Datasets those papers use: Hi4D (20 pairs, 100 seq, 11k frames, vertex contact, includes fight + hug + dance), CHI3D (mild–close daily + some contact, Vicon + 4 RGB), ExPI (extreme partner acro), InterHuman / Inter-X (large two-person SMPL, weaker contact GT), Dual-Human, FlickrCI3D, MultiHuman, MuPoTS-3D (not close-wrap).

Judgement: SOTA close-interaction PA-MPJPE on Hi4D is still ~4.5–6 cm. That is usable for reference, not drop-in game clips. Hi4D "fight" is not closed guard + ankle lock. No paper reports closed-guard / mount wrap numbers. Expect worse than hug.

Do not ship SMPL meshes without a Meshcapade licence. Joints/FBX you author yourself are fine.

2. Failure 2 — why no southpaw

Not a missing word. Mode collapse + weak text geometry.

Data mode. ~90% of humans are right-handed. Boxing/MMA "fighting stance" in video/mocap is overwhelmingly left-foot-forward. Your +44 to +70 cm metric is that mode. Orthodox jab check (+61.5 cm) confirms the meter works.
HumanML3D explicitly mirrors all motions and swaps "left/right" in captions to double the set. A model trained on that learns both geometries under both wordings. "Southpaw" is then a rare token, not a foot constraint. HumanML3D: 14,616 motions, 44,970 texts; mirror is the official augment. GitHub
Canonicalisation in T2M (HumanML3D / MDM lineage): face +Z, root heading aligned. It does not force lead-foot identity. The prior's peak is still orthodox.
Higgsfield ARDY "kimodo" / cskel27 — training set not published. Judgement: same AMASS→HumanML3D family as every other T2M. 16 jobs × 4 seeds = 64, all +LFF, including "start southpaw" and unnamed swap. That is prior dominance, not seed unlucky.
Same class of failure as image models that cannot draw left-handed writing: minority class is absorbed into the majority template.

Pose / keyframe conditioned T2M (exists, research):

MDM — in-between / inpaint: lock first/last frames, generate middle. MIT licence. Local GPU.
MotionGPT — text + init/last/key pose tokens.
OmniControl / IKMo — joint or keyframe constraints.

None of these are Higgsfield's API. Higgsfield text-to-motion as you used it has no pose constraint.

Mirroring generated output: standard and safe for stance. HumanML3D does it as official augment. You already authored the switch in Cascadeur by exact mirror. Do that to every orthodox clip that needs a southpaw twin. Watch: logos, wrapped gi grips, text on shorts, and asymmetric injuries (do not mirror those). Hands/feet swap is geometrically valid.

3. Tools not tried

Reallusion Video Mocap / AccuPOSE

Video Mocap: one actor per task. Multi-person = duplicate task, pick the other box. Not a two-body contact solve. 250 DA points / ≤60 s / person. Output into iClone; FBX from there. Paid generation; iClone/CC licence for commercial export — verify current Reallusion content licence before ship.
AccuPOSE: AI poser, not capture. Useful to clean Cascadeur holds, not to un-merge video.

Video → mocap (single + multi)

Tool	People	Price (observed 2026)	Out	Commercial
Move One	1 (phone)	~$18–50/mo + credits	FBX	Paid tiers yes; free no
Move Pro	Multi-cam, multi-person (enterprise)	Trial ~$995/30d; Pro custom	FBX/BVH	Yes
DeepMotion Animate 3D	4 / 6 / 8 by plan	~$17 / $39 / $83/mo	FBX, BVH, GLB	Paid yes
Plask	up to 5, one clip	Free 15 s/day non-comm; paid ~$18/mo	FBX, BVH, GLB	Paid yes
Rokoko Vision (you have Studio)	1 cam typical	Free 30 s/mo; Plus ~$20/mo 3000 s	FBX; BVH on paid	Yes
mimem	3–12 phones	Free commercial (tight caps); €25–199/mo	FBX	Free tier claims commercial
QuickMagic / Uthana / RADiCAL / Flow Studio	mostly 1	$10–40/mo or per-second	FBX/BVH	check plan
Meshcapade	1, high quality	~€99/mo	FBX	Yes (they own SMPL commercial)

Local multi-view from 2–4 phones (film the gym)

Move Pro or mimem: designed for this.
EasyMocap: calibrated multi-view SMPL. Local. Calibration is the work.
OpenCap (Stanford): 2+ iPhones, RMSE 2.0–10.2° vs marker on gait-like tasks. Hosted service: academic/non-profit only. Commercial entities must contact authors. Code Apache 2.0; pose backends have their own licences. Not validated on wrapped grappling. Journals.plos
Theia / official markerless studios: hire, not DIY.

Judgement: 2–4 locked phones around a mat, same-sex pair, contrasting shorts, Move Pro or EasyMocap, then Cascadeur cleanup — will beat generated split-screen on identity and contact. Still expect limb swaps in closed guard; you will hand-fix.

4. Prefabs (search was for the thing)

Paired, actually two bodies from one capture or authored as a pair

RamsterZ — Full Mount Attacks (Fab). Paired mount grappling + GnP + victim fight-back. 32 clips (24+8). Epic skeleton, root motion. Hand-keyed, not optical mocap. Price not consistently listed in index pages (RamsterZ pack band typically ~$20–40). Licence: Fab/UE marketplace standard — ship in a commercial game. This is the only SKU that is literally "full mount paired."
RamsterZ — Wrestler Finishers Vol.1. 30 paired finishers (15+15) + extras. $34.99 FBX. UE4 mannequin / Unity humanoid. Pro wrestling slams, not BJJ positions.
RamsterZ — Hand to Hand Finishers Vol.2. Paired standing finishers (powerbomb etc.), not ground positions.
MoCap Combat Animations – Dual Character (Fab). 26 Vicon clips, UE4 skeleton, 60 fps. List: wire strangle, rifle melee, drag, kick grounded person, stealth/knife kill, unarmed stand-up. Not BJJ.
Maxdesign-3D — Paired Takedowns (Fab). 35 paired takedowns. Standing entries, not positional ground.
ViperHill — Takedown Animations Pack. 40 paired weapon/hand takedowns (front/back). Not guard/mount cycles.
MoCap Central Greet & Talk. True two-actor capture. Conversations, not fights. $93 CAD. Proof that paired SKUs exist — just not for BJJ.

Single-body combat (not paired ground)

ActorCore Studio Mocap Hand-to-Hand: 68 motions, $149, FBX/BVH, royalty-free. Punches, kicks, some takedowns, knockdowns. One body.
Reallusion Martial Arts Vol.1/3, JKD, etc. $45–195. Single performer.
Mixamo: no paired grappling.
Punch Perfect / MoCap Online Punch & Ninja: striking + acro, one body.
You already own some RamsterZ.

Still not a SKU: closed-guard exchange, mount escape, side-control cycle, rubber guard, knee-on-belly, wrestling ride series as a paired positional library. Confirmed by searching the phrases, not the category.

Argue against myself — "stop generating, film it"

Strongest case for filming

Generated video + 2D pose will keep failing on wrap. Hi4D SOTA is still centimetres and not BJJ. Split-screen does not create geometry. T2M will not emit southpaw. Cascadeur static holds already work (~9 min). Two people on a gym mat, contrasting shorts, 3 locked phones + Move Pro or EasyMocap, same-sex pairs only, then Cascadeur contact pass — that is how every usable two-person combat library that exists was made (Vicon dual packs, RamsterZ pairs). 534 techniques: you do not film 534. You film holds + a few transitions, mirror for southpaw, author the rest as you already do.

Weakest case for filming

You still clean occlusion by hand. Phone mocap is not Vicon. Ground friction and wrapped ankles will be wrong. Cost is people-time, not credits. Generated video remains useful as timing reference, not as a tracker source.

WHAT I COULD NOT FIND
Any published MPJPE / ID-switch number on closed guard, mount wrap, or BJJ (Hi4D "fight" is not that).
Higgsfield / Seedance / ARDY training data, licence for extracted skeletons in a shipped game, or a pose-constraint API.
A commercial paired BJJ positional pack (mount escape, guard pass cycle, etc.).
Measured two-person accuracy for Reallusion Video Mocap on contact poses.
A text-to-motion model with a public "force right-foot-forward at t=0" control that is a product, not a paper.
OpenCap or Move.ai published grappling trials.

Practical next (research conclusion only): treat Seedance+RTMPose as dead for wrapped ground. Buy RamsterZ Full Mount if the skeleton retargets. Mirror every orthodox T2M clip. Film a short same-sex gym session with 3 phones for the holds Cascadeur cannot invent fast enough.

151 sources

---

## CLAUDE'S VERIFICATION NOTE (S59)

- **"Buy RamsterZ Full Mount" - WE ALREADY OWN IT.** `Godot/assets/anim/audition/ramsterz/` holds
  `Paired_FullMount_*_Att/_Vic.fbx` (AxeToFace, BluntSmack, KnifeStab, SlashNeck, AttackBlock, H2H_ArmBar, ...), and the
  RamsterZ retarget is a hard control in every Codex gate (`0.302639 / 0.304671`). Several clips are WEAPON attacks and
  do not fit an unarmed sim; the H2H ones and "victim fight-back" do. Audit the owned pack before buying anything.
- **Reallusion Video Mocap is one actor per task** - it cannot un-merge a wrapped pair. That answers the operator's
  iClone question: iClone's Video Mocap does NOT close the grappling gap, so iClone is not worth buying for it.
- Grok's split-screen objection is right about GEOMETRY (one generated image, no calibrated extrinsics) and does not
  contradict the measurement: the side panels DID find both men 92.7/100% on mount - where the bodies are separable.
