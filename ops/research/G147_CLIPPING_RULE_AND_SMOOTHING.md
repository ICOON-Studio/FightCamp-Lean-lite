# G147 — Clipping Rule and Smoothing

Delivered by Grok (Expert), S119 2026-09-28, chat https://grok.com/c/dbfd613d-3faf-491b-9d57-51bfa0825d29 (118 sources).
Saved by Claude from the chat; tables kept, links kept. Claude's note at the end.

**Tag key:** SOURCED = primary studio/engine/publisher page or talk. PROXY = secondary interview, review, player/dev
reconstruction. UNSOURCED = industry practice with no public number.

## Prefab check — middleware for character-to-character collision

| Name | What shipped fight games used it for | Licence | Runs in Godot 4? |
|---|---|---|---|
| Havok Physics | UFC 2009 Undisputed: ragdoll + constraints + fighter-to-fighter contact; Yuke's goal "characters should never overlap". | Commercial, USD 50,000 per product (budgets <= $20m), Havok pricing page 2025-03-25. | No official Godot 4 runtime. |
| NaturalMotion Euphoria | GTA/RDR active-ragdoll reactions, not a body-vs-body clip solver. | Proprietary (Take-Two). | No. Closest FOSS analog: Kickback (Godot 4.7+, reaction tech, not a contact solver). |
| Unreal Physics Asset + Control Rig | Per-bone capsules + Full Body IK contact. | Unreal licence. | No. Godot equivalent: CollisionShape3D capsules + SkeletonIK3D / custom modifiers. |
| Autodesk HumanIK / MotionBuilder | EA MMA / early UFC "touch tags" pinning a hand to a target on the opponent (DCC authoring). | Autodesk commercial. | No as runtime - bake the constraint, solve IK in-engine. |
| Godot built-in / Jolt | Godot 4 first-party 3D physics. | MIT. | Yes - this is the stack. |
| Godot Rapier Physics | Drop-in physics, determinism. | FOSS. | Yes, not fight-specific. |
| FightEngine / Combat Collider / Framitor | Godot 4 2D hit/hurt/push helpers. | MIT/community. | 2D only. |

**Prefab verdict:** no Havok/Euphoria-class character-to-character contact middleware runs in Godot 4. Shipped 3D combat
games rolled their own: push/separation constraint + relative IK + a physics cleanup pass. Stay on capsules + solver +
`contact_stop` + IK glove stop.

## Q1 — How shipped games handle character-to-character clipping

| Title | Method | Physics posing? | Source | Tag |
|---|---|---|---|---|
| Street Fighter | Hitbox, hurtbox and a **collision (push) box that is body-centred and excludes arms and legs**. Overlap -> characters push; after a no-collision state they are shoved apart, never left overlapped. | No, kinematic push. | https://game.capcom.com/cfn/sfv/column/131422 (Capcom SFV column) | SOURCED |
| Tekken | Separate body collision box (push) and hit-decision volumes (cylinders); attacks as line segments vs cylinders. Mixing the two broke spacing and hittability (Fahkumram). | No. | https://www.eventhubs.com/news/2024/nov/26/tekken-newcomer-what-wrong/ (Harada, 2024-11-26) | SOURCED via press |
| Fight Night Champion / Round 4 | First FN titles to let boxers get that close; physics 120 Hz, game 60, render 30; Push and Clinch are the separation verbs. EA MMA: "we use Fight Night physics to clean up interpenetrations" - cleanup, not pose authority. | Cleanup only. | https://www.youtube.com/watch?v=AAvazz5Jz1o (2011-02-21); https://www.gamedev.net/tutorials/visual-arts/building-brawl-handling-interacting-characters-r2777/ (2010-11-30) | SOURCED |
| EA MMA -> UFC 1-2 | Relative IK + "touch tags" (HumanIK). UFC 2: ray head->hand, intersect opponent collision volumes, pin the contact to the SURFACE so scale changes do not bury the hand. UFC 1 had per-pose "how much penetration is allowed" tags - called unscalable. IK constraints moved into the physics solver. | Physics-informed. | gamedev.net 2010-11-30; https://www.youtube.com/watch?v=Xw47OUed9vE (2015-08-14); https://www.youtube.com/watch?v=1nSshgQ3HM4 (2017-10-13) | SOURCED |
| EA UFC 3-5 | Hard minimum separation / "invisible wall" so walk-in cannot mesh-merge, at a cost to pocket feel. UFC 6 widens the land window to 4 frames (a hit window, not a clip budget). | Separation + authored contact. | https://www.youtube.com/watch?v=Lc8tzZt1Cmc (2024-05-23); https://www.forbes.com/sites/brianmazique/2026/05/18/ea-ufc-6-devs-explain-real-time-contact-flow-state-grappling-and-presentation-leaps/ | PROXY (wall), SOURCED (UFC 6) |
| UFC 2009 Undisputed (Yuke's) | Havok. GDC 2010: "Limit how close fighters can get to each other", adjust anims that stick, temporarily disable collision, IK targeting, connect fighters with constraints. CEDEC 2011: "characters should never overlap". A fighter was cut for hair clipping. | Havok for contact/reactions; closeness limited. | https://media.gdcvault.com/gdc10/slides/Ueno_Hiroki_NextGenFightingGame_PhysicsAnimation_UFC2009Undisputed.pdf ; https://game.watch.impress.co.jp/docs/news/475670.html ; VG247 2009-05-28 | SOURCED |
| Undisputed (2024) | Physics + an invisible wall between fighters; wall tighter in beta (better in-fighting, more clip), widened after 1.0. "Clipping is OK ... happens all the time in Tekken, SF, Fight Night, EA UFC." | Physics + spacer. | https://gamingbolt.com/undisputed-review-managing-the-fight ; https://steamcommunity.com/app/1451190/discussions/0/594019565986465861 | PROXY |
| GDC physics canon | van den Bergen GDC 2011: "Don't try to solve penetration completely" - skin-deep contacts, under-relaxation; deep penetration is an emergency path. | Solver slop. | https://media.gdcvault.com/gdc2011/slides/Gino_VanDenBergen_Programming_PhysicsTutorialContacts.pdf | SOURCED |

**Pattern:** (1) body-only push / min distance that arms and legs may violate, (2) authored strike spacing, (3) IK or
constraint pins at the contact pair, (4) physics as cleanup, (5) some moves intentionally drop collision.

## Q2 — Published interpenetration tolerance

| Claim | Number | Source | Tag |
|---|---|---|---|
| Studio QA budget in cm/frames | **None found** in any FN/UFC/Undisputed/Tekken/SF talk or doc. | search 2026-09-28 | UNSOURCED |
| Physics steady-state slop | penetrate to a prescribed degree, then separate | US9440148B2; van den Bergen 2011 | SOURCED (engine practice) |
| Unreal inertialization | keep blends < 0.4 s; do not inertialize across very different poses | https://docs.unrealengine.com/5.2/en-us/transition-rules-in-unreal-engine/ | SOURCED |
| UFC 1 internal | per-animation penetration tags existed; numbers never published | 2015-08-14 talk | SOURCED existence |

**Public standard is qualitative:** push box must not stay overlapped; glove-through-head is a defect; torso-through-torso
is a defect; arm-through-torso on a hook is tolerated for a few frames. Write the budget yourselves.

## Q3 — Stopping a strike at the target surface

| Technique | What it does | Who | Tag |
|---|---|---|---|
| Touch tags + Relative IK | effector pinned to an authored point on the opponent | EA MMA, UFC 1 | SOURCED |
| Collision-volume ray contact | ray head->hand, hit on opponent volumes = constraint point on the surface | EA UFC 2 | SOURCED |
| Physics-space IK constraints | pins solved inside the physics step | UFC 1 late / UFC 2 | SOURCED |
| Connect fighters with constraints + IK retarget | keeps the pair attached at contact joints after sim error | UFC 2009 | SOURCED |
| Hit-stop / micro-decel | freeze or dump glove velocity 1-4 frames on connect | melee practice (mocaponline guide 2026-03-17) | PROXY |
| Four-frame land window | strike registers across 4 frames | EA UFC 6 | SOURCED |

What does NOT stop a glove in a head: playing the clip to the end, a physics reaction on the receiver, or a push box
(push boxes ignore arms).

## Q4 — Smoothing: blend / inertialization times

| Transition | Time | Source | Tag |
|---|---|---|---|
| Inertialization (Gears of War 4) | t1 = 0.3 s and 0.5 s examples | Bollo GDC 2018 https://media.gdcvault.com/gdc2018/presentations/bollo_david_inertialization_high_performance.pdf | SOURCED |
| Unreal guidance | < 0.4 s | UE 5.2 docs | SOURCED |
| Motion matching (La Forge) | short cross-fade or inertialization; no ms figure | Ubisoft 2020-07-30 | SOURCED |
| Attack blend-in | ~0.25 s | Amber Studio TA 2026-04-16 | PROXY |
| Hit reaction | 0.3-0.5 s, interruptible, additive | mocaponline 2026-03-17 | PROXY |
| Hit-stop | 1-4 frames | same | PROXY |
| Contact transitions | lower cross-fade in contact | gamedev.net 2015-08-20 | PROXY |

**Smooth = continuity of pose and velocity, not a long cross-fade.** Locomotion 150-300 ms, into a strike 80-150 ms,
into a reaction <= 100 ms or additive, 1-4 frame hit-stop on connect. Blends over ~400 ms are the quality cliff; long
blends at close range are how gloves swim through heads.

## Q5 — Recommended rule for this project

| Pair | Rule | Rests on |
|---|---|---|
| Head (glove/fist -> head) | 0 cm sustained; glove stops on the surface the frame of contact (contact_stop + IK pin). >1 cm for >1 frame fails. Hit-stop 1-3 frames. | UFC 2 surface-cast IK; touch tags; hit-stop |
| Torso -> torso | body-only push pair; steady overlap <= 2 cm, resolved in <= 3 frames; root cap stays 3 cm / 10 deg per frame | Capcom collision box; Ueno min distance; van den Bergen slop |
| Arms (arm/glove -> torso, arm -> arm) | allow 3 cm for <= 3 frames on wrapping hooks/crosses; no arm push box | Capcom (limbs excluded); UFC/Undisputed tolerance |
| Legs | hip/thigh push <= 2 cm / <= 3 frames; foot-on-foot <= 4 cm / <= 5 frames; no leg-through-torso | body-only push model |

**One-line ship gate:** a clip fails QA if any head pair shows >1 cm overlap for >1 frame, or any torso pair >2 cm for
>3 frames, on any authored clip or any live minute.

**Smoothing to match:** locomotion/idle 200-300 ms inertialization; into-strike 80-150 ms; strike-to-strike <= 100 ms or
pose-match; reaction additive <= 150 ms; hit-stop 1-3 frames on contact, no long cross-fade.

## Claude's note (S119)
- The gate numbers are Grok's AUTHORED budget built on sourced methods (no studio publishes cm). Adopt as the project's
  rule, measured by capsules per pair, and never pin a single run to it - a ceiling.
- Our pieces already map onto the pattern: FightSeparation = push box, contact_stop = surface stop, capsules = volumes.
  Missing: arms excluded from the push, an IK glove pin at the head surface, hit-stop, and the per-pair gate itself.
