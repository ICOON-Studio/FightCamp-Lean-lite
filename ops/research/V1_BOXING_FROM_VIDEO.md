## DECISIONS
Real boxers on YouTube, tracked frame by frame (Claude, 2026-09-14), measured in TORSO LENGTHS (T = shoulder midpoint to hip midpoint; 0.53 m on our f01).
JAB (31 lead-hand straights at head height, elbow 141-164 deg at the peak): about two thirds are thrown IN PLACE - hips <= 0.13 T, head <= 0.2 T, feet do not move; the arm does the reaching.
JAB, when it needs more reach: PUSHED off the rear foot (rear ankle +0.16-0.21 T, hips +0.10-0.16, head +0.20-0.32) or STEPPED (front ankle +0.14-0.32 T by the peak, hips +0.20-0.28, head +0.25-0.38) - and back where he started within 0.5 s. The stepping front foot stays low (ankle lift 0-0.035 T); the rear heel rises (0.07-0.18 T).
TIMING: extension (onset to peak) 0.07-0.40 s, median ~0.17 s (fast demonstration jabs 0.08-0.12 s); return 0.07-0.43 s.
HEIGHT: at the peak the wrist is 0-0.6 T below the nose (median ~0.23 T) - a jab finishes at nose-to-chin height.
CROSS (3 clean, in place): 0.10 s out, 0.10-0.13 s back, hips +0.02 T, feet still, elbow 139-146 deg, wrist ~0.25 T below the nose.
HOOK (6): the body barely travels (hips -0.05..+0.01 T); the head turns with the shoulders (+0.12-0.29 T); the rear heel pivots (rear ankle -0.09..-0.13 T); elbow 78-109 deg; extension 0.29-0.38 s - slower than a jab.
APPLIED: the strike warp is a STEP capped at 0.28 T with the front foot moving (`FightWorldLiveScreen.WARP_MAX_T`). OPERATOR on the resulting side-by-side, asked what looks most wrong now: "Gloves/arms still pass through".

### Method
- Operator, 2026-09-14: "watch YouTube videos and learn the moves"; "Try to find educational videos too or search by move or discipline"; downloads approved as a named batch, "But delete them after you do your work" - deleted once measured.
- Batch 1 (480p, video only): Tony Jeffries - How to Throw the Perfect Jab (71nmi6nGcrY), How To Throw The Perfect Jab (FSVcmMd9bR4), the Perfect Cross (sK-6Ujp3KYY), Lead Hook (i3G3HsI1GGU), Slip Punches (DOWc7NMSuEQ), Footwork (C4i__4LGtI0); FightCamp - Lead & Rear Hook (1ZZncRfkt0A), Uppercut (KcagWYVfvBg); Precision Striking - Defense & Reaction (6aHhQBMonIE, POV, not measurable); Oracle Boxing - Punches 1-6 (JhkqSCahsNY).
- MediaPipe Pose Landmarker (full, VIDEO mode) on every frame, 36-39 fps on this PC, a person found on 94-100% of frames. A punch = one wrist's reach from its shoulder rising >= 0.35 T to a peak (3-frame smoothing); onset = 20% of the rise, back = under 50%. Travel is along the punch's image direction, so only side-on views count; frames lacking shoulders, wrists, hips or ankles are dropped.
- POPULATION: one coach (Jeffries) for most jabs, plus Oracle Boxing's demonstration jabs; shadow and bag work, NO opponent - so this measures a man's own body, never the distance between two men. Spacing and guard contact need partner or sparring footage (K55's batch 2).
- Validated by eye: skeletons drawn on onset / peak / back frames of 8 events matched the footage (stepping jab visibly stepping, hook pivoting).
- Scripts (session scratchpad, not shipped): track_video.py, punch_events.py, event_strip.py, contact_sheet.py.
