# G95 - body-model licences and legal two-person mocap routes (Grok, 2026-09-25)

VERBATIM reply captured from https://grok.com/c/8cdcfc27-6bd9-4bc0-9e7e-a58d536c358e (Expert mode, "Worked for 3m 7s",
291 sources) through the in-app browser. Raw capture; tabs were flattened to tab-separated rows by the page text.

---

What a human would do: small commercial studios do not run research SMPL-X fitters. They buy a video-to-mocap service that grants commercial rights, export FBX/BVH, retarget to their own rig, and hand-fix contacts. Suits (Rokoko/Xsens) if contact must be clean. They do not download MPI models.

1. SMPL / SMPL-X / MANO
Item	Answer	Tag	Source
Research licence	"Software Copyright License for non-commercial scientific research purposes." Single-user. Research / education / non-commercial art only.	SOURCED	smpl-x modellicense
Does fitting video -> shipped game anim count?	Yes. Shipping the .pkl is not required.	SOURCED	Quote below
Quote	"Any other use, in particular any use for commercial, pornographic, military, or surveillance, purposes is prohibited. This includes, without limitation, incorporation in a commercial product, use in a commercial service, or production of other artifacts for commercial purposes." Also bans using the software to train methods for commercial use.	SOURCED	smpl-x modellicense; smplx LICENSE
SMPL same rule	Same "production of other artefacts for commercial purposes" ban. Commercial via Meshcapade / smpl@max-planck-innovation.de.	SOURCED	smpl modellicense
MANO	Same commercial ban. Contact ps-license@tue.mpg.de.	SOURCED	mano license
SMPL-X Body (not Model)	CC-BY 4.0: mesh + rig + pose/dynamic blendshapes, no shape blendshapes. Commercial OK with attribution. Does not license the fitter/shape tools.	SOURCED	bodylicense
Patents	SMPL spec in US10395411B2 / WO2016207311A1 (MPG). Separate from copyright.	SOURCED	bodylicense / meshcapade/smpl

JUDGEMENT: using BUDDI/CloseInt/etc. + research SMPL-X to bake anim that ships in a sold game is commercial use of the Model. Retargeting away from SMPL does not dodge the "production of artifacts" clause.

2. Meshcapade commercial licence
Item	Answer	Tag	Source
What it covers	Exclusive commercial sublicence of SMPL to customers.	SOURCED	meshcapade.com/smpl
Status 2026	Meshcapade acquired by Epic; online platforms shut 18 Apr. SMPL IP stays with Max Planck.	SOURCED	meshcapade.com
How to buy	Email smpl@max-planck-innovation.de or ps-license@tue.mpg.de.	SOURCED	MPI licence pages
Published small-studio price	None official.	NOT FOUND	-
Unofficial figures	Reddit: ~EUR 150k/yr (rumour). Blog: old avatar-API credits ~EUR 1-5/avatar. Not a game-anim licence quote.	NOT FOUND as official	reddit / clad.you blog

3. Fitter code licences (not SMPL)
Project	Code licence	Needs SMPL/SMPL-X?	Commercial code use	Tag	Source
BUDDI	MIT	Yes (downloads SMPL-X)	Code yes; model no	SOURCED	muelea/buddi LICENSE
CloseInt (HumanInteraction)	MIT	Yes (data/smpl)	Code yes; model no	SOURCED	boycehbz/HumanInteraction
MultiPhys	No LICENSE file	Yes (SMPL v1.1.0)	Unknown	NOT FOUND	nicolasugrinovic/multiphys
Reaction Priors (Dual-Human)	Project page exists; licence file not retrieved	Paper fits SMPL-X	Unknown	NOT FOUND	Dual-Human

MIT on the Python does not free the MPI model.

4. Commercially usable alternatives (two-person / contact)
Option	Licence	Two-person close contact	Hi4D / CHI3D numbers	Tag
Meta MHR	Apache-2.0	Single-body parametric; not a contact fitter	NOT FOUND	SOURCED facebookresearch/MHR
SAM 3D Body + MHR	SAM License (commercial outputs allowed)	Per-person; Meta says no multi-person / contact reasoning	NOT FOUND	SOURCED sam-3d-body, Meta blog
4D-Humans / HMR2	MIT code	Multi-human track; still needs SMPL	NOT FOUND for commercial use	SOURCED 4D-Humans LICENSE
2D/3D keypoints (RTMPose etc.) + own IK	Often Apache/MIT	Two people yes; no contact-aware body model	NOT FOUND vs Hi4D/CHI3D	JUDGEMENT
STAR / SUPR / GHUM	MPI / research-style	Same family problem	-	JUDGEMENT
Academic contact fitters without SMPL	-	-	NOT FOUND	NOT FOUND

No permissive published two-person contact body-model fitter with Hi4D/CHI3D scores was found.

5. Commercial video-to-mocap (two people / contact)
Service	2-person	Price (published)	Format	Commercial / own the output	Tag
QuickMagic	Basic: 2 people; Pro 3; Max 4; Studio 6	Basic $11.9/mo yearly ($14.9 mo); Pro $39.9/mo yearly	FBX, BVH, Mixamo, UE, Unity, ...	Paid plans: commercial use. Ownership wording not a full "you own copyright" clause.	SOURCED pricing
Plask	"Multi-person MoCap" on free tier	Free shown; paid tiers exist (~$18/mo in older pages)	FBX, GLB, BVH	Commercial clause not on pricing page	SOURCED formats; NOT FOUND rights
DeepMotion Animate 3D	Up to 8 in one video	Secondary: Starter ~$9/mo, Pro ~$39/mo, 1 credit = 1s body	FBX, BVH, GLB, MP4	Official ToS commercial grant not retrieved	SOURCED 8-person/formats; price/ToS mixed
Move One	1 person	Docs: $18 / $48 / $225 / $490 /mo + VAT; 1-2 credits/person-second. 3rd-party: Standard ~$50/mo commercial; Personal non-commercial	FBX, BVH, USD, BLEND, JSON	Commercial starts at paid Standard (3rd-party writeup)	SOURCED Move One pricing; commercial split 3rd-party
Move Pro	Multi-person, multi-cam (up to 8 in volume)	Trial $995 / 30 days; enterprise custom	FBX/BVH etc.	Commercial (trial/enterprise)	SOURCED 3rd-party pricing page
Rokoko Vision	1 person (site says no convincing multi-performer AI mocap)	Basic $10/mo yearly or $12/mo; 600s/mo	FBX, BVH	Game-engine export yes; full ToS grant not extracted	SOURCED rokoko.com/products/vision
Flow Studio (Wonder)	Multi-shot / AI mocap; grappling-contact spec not stated	Free; Lite from $10; Standard from $45; Pro from $95	USD + DCC	Sold as pro tool	SOURCED Autodesk Flow
Radical	Historic multiplayer claim	Current 2-person public price	-	-	NOT FOUND
Contact quality on Hi4D/CHI3D	-	-	-	-	NOT FOUND for all vendors

Verdict - cheapest legal route
Do not use research SMPL / SMPL-X / MANO (or BUDDI / CloseInt / MultiPhys / Reaction Priors + those models) to produce animation that ships in a commercial game. The licence bans producing commercial artefacts, not only redistributing the model files.
Cheapest documented legal path: QuickMagic Basic (~$12/mo billed yearly) - 2-person video mocap, FBX/BVH, paid-plan commercial use. Clean up contacts by hand. Confirm current User Agreement before ship.
If contact must be good: Move Pro (custom / $995 trial) or inertial suits + two performers. No public "per minute grappling" price.
Meshcapade/MPG quote: email only. No published small-studio price - do not invent one.
Long-shot in-house (still legal): SAM 3D Body / MHR (permissive) per person -> own rig -> manual contact. Not a Hi4D-grade two-person fitter.

NOT FOUND is a result: Meshcapade dollar figure; MultiPhys and Reaction Priors code licences; Hi4D/CHI3D scores for any vendor; Plask/DeepMotion full ownership clauses on the pages retrieved.
