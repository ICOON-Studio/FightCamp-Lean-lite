# G58 — HOW YOU GET TO HUNDREDS OF CLIPS WITHOUT AN ANIMATOR

**Agent:** Grok (Expert / research mode). **Submitted 2026-09-11, collected 2026-09-12.**
Grok worked 1m 4s across 178 sources. Every claim below is Grok's, carrying Grok's
own DOCUMENTED / INFERENCE / NOT FOUND label. **Prices move — buy off the live
vendor page, never off this memo.**

---

## THE ONE-LINE ANSWER (Grok's Q6)

> Buy commercially licensed packs first (Mixamo free + paid combat packs). Film
> yourself next on a paid DeepMotion or Rokoko plan and clean in Cascadeur. Use
> runtime layering on that library. **Do not ship academic text-to-motion weights
> trained on AMASS/HumanML3D.**

---

## THE COLUMN THAT DECIDES IT: LICENCE

**Academic text-to-motion is OFF THE TABLE for us.** Not because of the code
licence — because of the training data.

DOCUMENTED, AMASS terms: commercial use prohibited, *including* "production of
other artefacts for commercial purposes" and "train methods… for commercial use
of any kind". HumanML3D cannot be redistributed; you rebuild it from AMASS under
that licence.

**MIT code does not clean the data.** MDM, MotionGPT, T2M-GPT, MoMask and
OmniControl all ship MIT or similar code and all train on HumanML3D (= AMASS +
HumanAct12). Shipping clips from the stock checkpoints is the risk. MotionLCM's
own project licence says explicitly *not allowed for commercial usage*;
MaskControl / ControlMM are CC-BY-NC-ND-4.0; MotionGPT-2's paper is CC BY-NC-SA.

**SMPL/SMPL-X output in a paid game** needs MPI commercial terms
(ps-license@tue.mpg.de) or don't use SMPL at all.

**And the quality is poor for our case anyway.** HumanML3D is walks, sits,
gestures, light exercise; the models average toward that prior. Grok's words:
"Jab/hook/slip at fight timing is the failure mode: mushy contacts, no weight
transfer, no snap."

### The other red lines, as a list
- **DeepMotion / Rokoko paid output** — ship inside the game binary; do not resell clips.
- **Plask** — only the *Commercial* plan carries the grant, on a 2023 ToS. "Any paid plan" is NOT ship-rights.
- **Mixamo** — ship in the game; never put the raw FBX on an asset store.
- **MoCap Online Standard** — fine under $1M revenue / 1M users; **no AI training without a separate permit.**
- **Every vendor's free tier is non-commercial**, and DeepMotion's freemium stays non-commercial *even if you later pay*.

---

## 1. COMMERCIAL SERVICES, PRICED (all DOCUMENTED unless marked)

| Service | Price | Output | Commercial? |
|---|---|---|---|
| **Rokoko Create + Studio** | Basic **$10/mo annual** ($12 monthly): 600 s/mo Vision AI, **unlimited text-to-motion generation**, 100 T2M clips/mo into Studio. Plus $20/mo annual (3000 s). Pro $50/mo annual (15000 s). | FBX or BVH; presets include **UE5 Manny, HIK, Mixamo** | **YES — FAQ states plainly that all generated data from text-to-motion and video-to-motion can be used commercially.** |
| **DeepMotion** (Animate 3D video→motion, SayMotion text→motion) | Starter $15/mo (180 credits), Innovator $48 (480), Professional $117 (1500). **1 credit = 1 second** (+0.5 each for face/hands). | FBX, BVH, GLB, MP4 | Paid plans grant a **perpetual, royalty-free** licence to embed **as binary only** (Terms 30 Mar 2025). Freemium is non-commercial permanently. |
| **Cascadeur** (physics posing + AI inbetweening — *not* a prompt-to-clip factory) | Indie **$19/mo** or $8/mo annual, commercial while revenue/funding **<$100k/yr**. Pro $49/mo or $33 annual, no revenue cap, adds retargeting. Annual converts to a perpetual build. EULA July 2025. | FBX / DAE / USD / GLTF | Yes on Indie and above. Free tier is non-commercial. |
| **Move.ai** | API s1 **$0.012/s**, s2 $0.024/s. Move One: Starter $18/mo +VAT / 60 credits; Standard $48 / 180; Plus $225 / 240; Advanced $490 / 700. Multi-cam m1 $0.024/s/cam, m2 $0.043/s/cam. | FBX, BVH, USD, BLEND, JSON | Free/Personal non-commercial; **Standard and above commercial**. Pro EULA grants IP in the output. |
| **Plask** | Free ~15 s/day. Standard ~$18/mo annual (aggregator figure — confirm at plask.ai/pricing). | FBX / GLB / BVH | **Only the Commercial plan.** ToS last touched 5 Apr 2023 and the default paid language is still non-commercial. |
| **Mixamo** | Free | FBX, `mixamorig` ~65 joints, **2,317 moving clips** | Unlimited commercial use in games/film per Adobe's employee FAQ; no raw-file redistribution. **Library is old and thin on specialist combat.** |
| **Meshy** | Pro $20/mo; 600+ preset clips; rig/animate costs 0 credits | — | Paid = private commercial ownership; **free output is CC BY 4.0 with attribution**. Preset library, not arbitrary combat T2M. |
| **MoCap Online** | Punch pack from ~$2.99 / €2.95; larger packs tens to low hundreds USD. Custom pickup shots **$150–$200/clip**; studio day from **$5,000**. | — | Standard licence: commercial, royalty-free, perpetual, ≤1M users / $1M revenue. |
| **Kinetix** | kinetix.tech is now a 3D-controlled *video* model; kinetix.video sells finished music videos from $39.99. | — | **NOT FOUND** — no current public per-clip FBX price or game-ship licence. Do not buy off aggregator "$49 Creator" pages. |
| **Anything World** → *Everything Universe* (rebrand Nov 2025) | Individual free under a revenue cap (pages disagree $10k vs $100k — verify). Micro $50/mo, Pro $250/mo. | FBX/GLB/GLTF/DAE. Unity + Unreal plugins. | Commercial on paid. **NOT FOUND: a Godot plugin.** |

---

## 2. VIDEO-TO-MOTION FROM FOOTAGE WE SHOOT

**Monocular phone** (DeepMotion, Plask, Rokoko Vision, Move One) is **usable
reference / blockout, not ship-ready without cleanup.**

DOCUMENTED failure modes from the vision literature (not vendor ads): foot slide,
float, **depth flip on crossed limbs**, lost feet (ankle-only keypoints), **motion
blur on fast fists**, jitter. Physics filters and foot-lock reduce slide *and
often kill the step or the pivot*. **Fast boxing is the worst case there is.**

Multi-camera (Move Pro/API, 2-cam baseline) drops the depth ambiguity but is
still markerless and still needs cleanup.

INFERENCE: for fight snaps, a suit plus Cascadeur cleanup beats monocular.
**Monocular is good enough for idle and locomotion variants, not for the twenty
hero punches.**

Practical floor if we do shoot: 60–120 fps, bright light, full body in frame, no
wide-angle warp, one action per take, mark the floor. Then foot-lock plus a
manual contact pass.

---

## 3. THE DERIVATION QUESTION — AND IT NAMES WHAT WE JUST BUILT

We already do mirroring, time-scaling and slicing. Grok's honest distinct-count
for everything else, per source clip:

| Technique | Realistic distinct playbacks | Ceiling |
|---|---|---|
| **Partial-body layering (upper punch + lower footwork)** | **6–15 combinatorial if both halves are real clips** | **"Best multiplier you have"** |
| Blend spaces (aim/strafe/punch angle) | 4–12, if you have 3–5 authored corners | Corners must exist; interpolants are not new clips |
| Additive / layered (recoil, lean, damage over a punch) | 3–8 if the add layer is a real authored/captured offset | Same punch plus a filter after ~8 |
| Pose offsets (shoulder drop, chin tuck, stance width) | 2–4 per axis before the silhouette collapses | Cheap; players notice the loop |
| Style transfer / retarget between body types | 2–3 body reads | Same timing |
| Phase offset (start mid-cycle) | 2–3 for loops | **Useless on attacks** |
| Procedural noise on spine/hands | 2–3 idle-grade | **In combat it looks drunk, not varied** |
| IK reach / look-at / hand-to-target | Makes one clip serve many hit heights | Still one punch |
| Procedural secondary (cloth, hair, jiggle) | 0 new body clips | Helps sell repeats; not a clip budget |

**THE HONEST CEILING (INFERENCE from shipped fighter practice, not a paper):
about 4–8× on attacks and 10–20× on idles/stances, after mirror + speed + slice.
Past that it is the same clip. The AAA "333 idles" are captured or uniquely
keyed, not noised. DO NOT PLAN 13 → 300 FROM FILTERS ALONE.**

This is the finding that matters most to us right now: **`FightBodyLayers` — the
bone-masked upper/lower split proved by render in R125 — is the single highest
multiplier on the list, and it is the one we have already built.** Our own
measured figure was 4 lower × 19 upper = 76 playbacks from 23 clips, which sits
inside Grok's 6–15 per clip band.

---

## 4. WHAT SMALL TEAMS ACTUALLY DID

- **Dauntless** — GDC 2017, Simon Unger, Phoenix Labs. Three animators. Bought an
  in-house OptiTrack volume (16 Prime 13s, ~30×30 ft) for "about the same as a
  couple of external shoots". External stages were too slow to iterate on.
- **Hellblade** — Ninja Theory, via Eurogamer 2018. ~20 people, 3 years. Built a
  mocap stage **in the boardroom**; same spend as 3–4 days at an external stage,
  usable for the whole project. Quality was not cut; the process changed.
- **Deliver Us Mars** — Koen Deetman. AA on a shoestring; first performance-capture
  shoot; outsourced face and body; ordered **only the frames they needed** (the
  partners hated it). Lesson: plan capture like a film call sheet.
- Vendor-side math (MoCap Online — a seller, but the numbers are specific): an
  indie 3D character often carries **80–200 clips**; packs run $1–$10/clip against
  $150–$500 in-house or $2k–$10k for a studio day of 50–200 takes.

**The pattern: they bought or captured motion, then spent their scarce human time
on cleanup and hero clips — never on inventing a library from prompts.**

---

## WHAT THIS CHANGES FOR US

1. **Text-to-motion is not a cheap clip source and never was.** Not on licence,
   not on quality. R121 already ruled motion matching out at our scale; this rules
   out the self-hosted generator route on top of it.
2. **Rokoko Create at $10/mo annual is the cheapest commercially-safe generator
   on the board** — unlimited text-to-motion, explicit commercial grant, FBX out,
   and a Mixamo preset that lands near our 22-bone map. It is the only row where
   the licence question has a plain published YES.
3. **The Unity sale on 2026-09-14 remains the best value per clip** (J23 prices
   the muay thai pack). Bought packs beat everything above on quality-per-euro for
   hero strikes.
4. **Layering is the multiplier to finish, not to start.** It is already built and
   unwired, and it is the top row of the derivation table.
