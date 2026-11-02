# G87 - the SAME clips look smooth in the vendor reel and rough in our fight: why (Grok, delivered S65 2026-09-24)

Captured verbatim from Grok (Expert mode, 86 sources, 11,925 chars) by Claude in S65. Asked on the operator's ruling
(verbatim): "We are not buying other clips unless I see the quality that I see on the YouTube preview videos. In our
game, ask other agents why this is happening. Where, why is our pipeline doesn't handle it like in the preview
videos? I want this fixed." Measured on our own tree by Codex C189; kicks fixed by Cursor U158.

---

The vendor reel plays whole clips on the capture skeleton. Our pipeline seeks, speeds, and cuts those same clips to a 20 Hz sim. That is the gap.

**Most likely cause:** Step 2 — enter a strike mid-clip, custom_speed it to a 0.3–1.0 s beat, cut it when the next beat arrives.

**Highest-value fix:** Play every strike from frame 0 at native speed through contact and recovery; let the clip's contact frame be the sim's hit time.

**Reel look + current stats:** Not both at once. Reel look is reachable if the sim keeps selection and outcome and gives timing to the clip. Independent 20 Hz beat timing will keep looking like bullets.

## 1. Rank of the seven steps

Cost to visible smoothness vs the RamsterZ reels (full clip, capture skeleton, often paired, root motion on). YouTube

**1 — Step 2 (beat → clip: seek, custom_speed, cut) — largest**
Vendor reel starts at the chamber and ends at guard. We do three things that delete that shape:
- Seek past wind-up → kick starts already extended. That is "kicks like bullets."
- custom_speed to squeeze a 0.7–1.2 s kick into a 0.3–1.0 s beat. Follow-through and return-to-guard are time-compressed into a snap.
- Cut when the next beat arrives → recovery never plays. "No normal return of limbs to neutral" is this cut, not missing frames in the FBX.
Godot play(clip, crossfade, custom_speed) plus a later seek/cut is a time-warp, not a performance of the clip. Docs.godotengine

**2 — Step 3 (discard root motion + splice walk on pelvis/legs) — very large**
The kick's weight shift, step-in, and hip yaw live in root + legs. We throw that away and layer a walk/strafe at body_speed / clip_native_speed on the same bones. Result: kicking legs that are also walking, hips pinned by the sim. Same failure mode as "gameplay owns position, animation works around a locked pelvis."
Recovery-to-guard is often a lower-body settle. Splicing a walk over it removes the settle. X

**3 — Step 6 (attack and reaction chosen separately) — large for contact, medium for solo smoothness**
RamsterZ finishers/counters were captured as pairs. We pick attacker clip A and victim clip B independently. Contact frames, ranges, and limb paths do not match → clipping, punches that miss the mesh, reactions that start late or early. Solo "abrupt" still comes from step 2; clipping and dead contacts come from here. Ramsterzanimations

**4 — Step 5 (UE4 Mannequin → Tripo auto-rig, 22 bones, silhouette corrections) — constant tax, not the bullet**
Reel is the capture skeleton. Different limb lengths change kick arc and foot plant. 22 mapped bones drop twist/spine/finger detail. Rest-pose / bone-roll errors add pops at every blend. This makes every clip worse. It does not by itself turn a full-speed kick into a bullet.

**5 — Step 4 (inertialization, foot lock, ground snap, arm IK, contact, separation, rope, hand-speed bound) — medium, mostly compensatory**
These run after a chopped, speed-warped, root-stripped pose.
- Arm IK yanking a punch onto a target the clip never reached → pop at contact.
- Hand-speed bound on a sped-up kick → velocity clamp that looks like a teleport then a freeze.
- Contact + separation vs clip pose → feet/hips slide or get shoved mid-kick.
- Inertialization on a mid-clip seek has no good incoming pose.
They cannot restore a recovery the player already cut.

**6 — Step 1 (20 Hz sim owns timing and position) — architectural cause of 2 and 3**
20 Hz = 50 ms quantize. Mocap is 30 fps (~33 ms) with its own contact frame. Beats of 0.3–1.0 s do not match kick envelopes. Because the sim owns position, root motion must be discarded. The sim is not "drawing" the kick badly; it is forbidding the clip from being the kick.

**7 — Step 7 (record 30 fps) — small**
Vendor reels are also ~30. Abruptness is in the source poses fed to the encoder, not the encode rate. Only bites if custom_speed + 30 fps drops the chamber to 1–2 frames.

## 2. How shipped games reconcile sim vs mocap

Label: DOCUMENTED / INFERRED / UNKNOWN.

**EA UFC 3 — Real Player Motion.** DOCUMENTED: left 2–3 s stitched loops. Long capture takes; each frame picks the best pose from a database (motion matching). Producer: "no blending," "1:1." INFERRED: locomotion and idle-to-strike entry are pose-matched. A committed strike then plays as a chosen take, not a 20 Hz cut. Dualshockers

**EA UFC 2/3 — Relative IK.** DOCUMENTED (GDC / "Inside the UFC Animation System"): bake attacker hand path relative to a victim joint; constraint weight ramps on contact, off on release. Exists so Struve vs Roy Nelson proportions do not break a paired clinch. YouTube

**EA UFC 5 — named stack.** DOCUMENTED names: Relative IK, Strike IK, Full Body Animation Blending, Pose-Trajectory-Matching, Pose Driven Ragdoll, Scenario / Rally interaction alignment. Strike IK internals: UNKNOWN in public docs. INFERRED: contact IK on the striking limb (same job as our arm IK, authored with the clip, not as a post-hoc yank). Pose-Trajectory-Matching: INFERRED as EA's motion-matching features vs desired root trajectory (same family as Madden/FIFA Interact + motion match). Who owns hit time: INFERRED mixed. Player/AI requests the strike; animation system chooses clip/pose; contact frame of that take plus Strike IK is the hit. They do not slice a kick to fit the next statistical beat. Eurogamer +1

**Fight Night Champion.** DOCUMENTED: Full Spectrum Punch Control is the input map, not the anim pipeline. Physics tick 120 Hz, game sim 60, render 30. Secondary motion (flex, ripple, bruise) is physics-driven off the punch. INFERRED: authored punch clips play through; physics deforms impact/KO. Not mid-clip seek to a rate table. Wikipedia +2

**Undisputed.** DOCUMENTED: punch timing differs per fighter because the animation differs; combos slightly accelerate successive punches; weight transfer is part of the punch, not a separate walk layer. INFERRED: closer to animation-driven timing than our beat cutter. Still clips in the pocket (known complaint). Exact hit-ownership: UNKNOWN. Sportsgamersonline

**For Honor.** DOCUMENTED: motion matching for locomotion; attacks use designer-authored transitions / game-logic priority. Requested travel is trajectory-warped onto the chosen clip. Pattern: anim owns attack timing; sim/input owns which attack and where the feet should arrive. Cgworld

**Mortal Kombat / Tekken.** DOCUMENTED: frame data is the clip. Startup / active / recovery are animation frames. Hit is the contact frame. Sim waits. Tekken: animation data is treated as game-design core, then tuned to reach/frames/stun. News.nicovideo

**Unreal Motion Warping (the standard combat answer).** DOCUMENTED: play the clip with root motion; a warp window scales root translation/rotation so the contact pose lands on a target. Timing stays the clip's; destination is the sim's. Docs.unrealengine

| Game / tech | Timing owner | Position owner | Method |
|---|---|---|---|
| Tekken / MK | Animation | Animation (+ pushbox) | Frame data = clip |
| UFC RPM + matching | Mixed; clip after commit | Desired trajectory + match | Pick pose, then play take |
| UFC Relative / Strike IK | Clip + constraint curve | Other body + IK | Paired authored contacts |
| Fight Night | Clip | Physics overlay | Reference pose + 120 Hz phys |
| For Honor attacks | Clip | Logic + trajectory warp | Authored transition |
| UE Motion Warp | Clip | Sim target via root warp | Sync windows |
| **FightCamp now** | **Sim beat** | **Sim** | **Seek / speed / cut / strip root** |

Shipped combat games that look like a vendor reel do not let a 20 Hz decision interrupt a kick's recovery. They warp space, not time, or they wait.

## 3. Smallest change set (priority)

**A. Never seek into a strike. Speed = 1.0. Do not cut before recovery.** Sim may only start a new strike after the current clip's recover-to-guard tag (or clip end). Stats cost: raw 20 Hz fire rate dies. Strike rate becomes "starts per minute," not "beats per minute." Protect: keep the sim choosing who / what / hit-or-miss. Queue the next throw until recovery ends. Map "fast" fighters to short clips (jabs), not to custom_speed=2. Re-fit published rates at the selection layer.

**B. During strikes, play full-body. No walk splice on pelvis/legs.** Use the clip's root motion for that window. After the clip, sim takes position again and corrects residual (snap or short locomote). Or warp root so the contact pose meets the sim's slot (UE pattern). Stats cost: none if residual correction is positional only. Drift if warp is unbounded — clamp warp to ~0.3–0.6 m, else the fighter "slides into" the punch.

**C. Tag three frames on every owned clip: start, contact, recover-to-guard.** Hit time = contact tag. Next decision = recover tag. Optional: warp only between start and contact so the fist/foot meets the target without changing duration. Stats cost: hit clock follows clip, not the 20 Hz tick. Protect by picking the clip whose contact time is in the desired class (jab ~0.2–0.35 s, kick ~0.45–0.8 s). UNKNOWN exact native times until we inspect the FBXs — do that first.

**D. Prefer vendor pairs for attack + reaction.** If no pair, still start both at t=0 and align on contact tags, not on independent beats. Stats cost: reaction vocabulary shrinks to pairs we own. Protect: unpaired reactions only when distance/angle is inside a tolerance; otherwise a generic flinch that is also played whole.

**E. Cheap isolation test (do this before buying anything).** Same Godot scene, same AnimationPlayer, speed 1, no seek, no layers, no IK, no contact solver: (1) whole clip on the UE4 Mannequin; (2) whole clip on the Tripo fighter; (3) our current fight playback of that clip. If 1 looks like YouTube and 3 does not, stop blaming the vendor. If 1 is good and 2 is ugly, retarget is the remaining tax. If 1 is already abrupt, import/rest-pose is broken.

Do not buy more clips until A–C are in. New clips through this pipeline will also look like bullets.

## 4. Retarget: how much, how to test, Godot pitfalls

**How much of the loss is retarget?** Secondary. A full, unspeeded clip on a wrong-proportion mesh still has wind-up and return-to-guard. Operator language ("bullets," "no return") is time-domain, not proportion-domain. Expect retarget to add: foot skate, hyperextended knees, kicking through the floor, twisted wrists, guard that doesn't match the idle. Not a 0.3 s kick with no chamber. 22 mapped bones on an auto-rig vs the UE4 Mannequin the FBXs were built for is a real quality drop (missing twist bones, spine, fingers). Silhouette corrections fight the capture rest. That is a floor on fidelity, not the abruptness.

**Cheap test.** Exactly E above. Also import one kick FBX onto the stock Mannequin with Godot humanoid retarget off (same skeleton) vs on (our fighter). One clip, three viewers, ten minutes.

**Known Godot 4 pitfalls (DOCUMENTED).**
- BonePose includes BoneRest. Sharing clips requires matching rests, not only names. Docs.godotengine
- Overwrite Axis is required for humanoid share and destroys authored bone rest / roll. Can look like fractured limbs. Keep original rest → RetargetModifier3D (realtime), not static overwrite. GitHub
- Fix Silhouette for A-pose vs T-pose. UE4 Mannequin is A-pose-ish; Godot SkeletonProfileHumanoid wants T. Wrong pair = raised-arm rest and shoulder pops. Fix Silhouette does not reliably fix bone roll. Docs.godotengine
- Unimportant Positions: strip position tracks except Root/Hips or different body scales explode.
- Scale mismatch on auto-rigged Tripo meshes compounds IK and ground snap.
- Animation FBX first frame is often a posed frame, not the bind pose. Godot will treat it as rest if you let it.

UNKNOWN without opening the files: exact rest pose of the purchased FBXs, whether root motion tracks exist, contact-frame times, and whether our 22-bone map drops the kicking leg's twist bone.

Operator ruling, translated: the YouTube look is the unprocessed clip on its skeleton. Our pipeline is a time-and-root processor that the vendor never ran. Fix playback ownership first. Retarget second. Do not buy a third set of clips for the same processor.

86 sources
