# S115 - BytePlus (Seedance) terms, and the two animation videos the operator sent (2026-09-28)

Operator: *"check this should we try it ?"* (youtube I9EvujHJm3o) and *"i am signed in byteplus have a look at their terms"*.
Read by Claude from the live pages (primary sources below), not from the videos' claims.

## The two videos
- **I9EvujHJm3o** - Youri van Hofwegen, "How to Make AI Videos for FREE (Unlimited Technique)", 10:58. Stretches BytePlus's free
  credits on **Seedance 1.5 Pro** (image-first, multi-shot prompts, 480p drafts). The operator's ModelArk console now offers
  **Seedance 2.5** with a 480p "Draft Mode".
- **2fh5RDPs_gA** - InspirationTuts, "Best AI Tools For 3D Animation", 10:46: AI lip-sync, Cascadeur (owned), markerless
  motion capture, full-performance tools. Nothing new against `G58_MOTION_AT_SCALE.md` / `G95_BODY_MODEL_LICENCES.md`, which
  already name the studio route for single-person clips: video -> paid markerless mocap (DeepMotion / Rokoko Vision, output
  may ship in the game) -> Cascadeur cleanup. That route was never executed.

## BytePlus terms (primary)
- **General Terms for AI Services** (docs.byteplus.com/en/docs/legal/AI-Services-terms, updated 2026-08-28):
  - s2.1 "you own the Output generated in response to your Input, and BytePlus does not claim ownership". No commercial-use
    restriction in these terms.
  - s1.4 you must follow AI-content **labelling/disclosure** law when publishing Generated Content (Steam's AI disclosure
    form applies to the game).
  - s2.5 no warranty that Output is original or non-infringing; s2.4 Output may not be unique.
  - s3.3 BytePlus does not train on customer data.
- **Service Specific Terms, ModelArk** s1.1: a proprietary model service (Seedance is ByteDance's) is ALSO subject to "the
  applicable terms provided by the relevant model service provider"; s3.1 the **Playground** trial is subject to the
  "ModelArk AI Playground User Terms" - READ 2026-09-28 (docs.byteplus.com/en/docs/legal/tos_modelark_playground): **"The Services are provided for private and non-commercial use ... the Output shall not be ... made available to ... any third party, except for internal use. You shall not display, distribute, or transmit the Output via any platform ... or otherwise make the Output publicly available."** The licence is "strictly for your own internal business and non-commercial use", and you grant BytePlus a perpetual, royalty-free licence to your Input AND Output.
- The console's agreement dialog ("I am a developer using BytePlus' AI services for professional or business purposes")
  is UNTICKED - accepting it is the operator's action, not Claude's.

## Verdict (CORRECTED same session after the operator: "we prompt it ... with humans wearing whatever the real human motion captures use")
Commercial use of Seedance output is allowed under the AI Terms, pending the Playground terms and the model provider's terms.
The first draft of this verdict said video had "never turned into game motion" - WRONG FRAMING. The agreed route is the
operator's SUIT ROUTE (route_decisions.json C199: RESUMED): generated video of performers in mocap-style suits, tracked.
Primary status: suit video generation WORKS; per-segment tracking PASSED (C180_DIGEST); calibration take, synced views and
point markers NOT DONE (C199 rows 1-3); video -> 3D solve NOT DONE (SAM 3D Body, G95's legal option, never tried); C199's
game clip was authored in Blender with the video as reference.
**Pilot = the suit route on ONE boxer** (the easiest case: one body, no occlusion) for `boxing_lead_uppercut`, whose owned
clip C223 rejected: (1) Seedance draft, one orthodox boxer in the C180 colour suit plus joint markers, two fixed views,
preceded by a T-pose / range-of-motion calibration take; (2) C180 tracker; (3) 3D solve - SAM 3D Body, or two-view
triangulation; (4) retarget (pipeline A) -> C223 gate. Free credits only until it passes. If it passes it sources every
boxing/kickboxing move the owned packs lack.

## FINAL VERDICT (2026-09-28, after reading the Playground terms)
- **Playground (the free route the video uses): NOT for anything that ships.** Its output is private, non-commercial,
  internal only. Allowed use: an internal experiment - e.g. proving the one-boxer suit route works - whose clips are
  thrown away.
- **Paid ModelArk API (AI Terms s2.1): you own the Output; commercial use allowed** (with AI-content disclosure). Any
  generation that ships is made there (or on Higgsfield, whose terms s4.4 already allow commercial use).
- So the tick on the console agreement only unlocks an internal test. Mixamo (signing in now) is the faster source for
  boxing clips; the suit-route pilot stays the fallback for moves Mixamo lacks.
