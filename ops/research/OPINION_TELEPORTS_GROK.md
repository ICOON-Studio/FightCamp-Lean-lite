# Opinion: body teleports - Grok (Expert), verbatim

Source: grok.com/c/cf2b3141-e74f-4c4d-a5c0-92370f640073, collected 2026-09-23 (S60). Brief: TASK_OPINION_BODY_TELEPORTS.md.

---

Worked for 17s
Opinion brief: stop body teleports permanently

The room is doing two jobs that cannot share one write: follow the engine and guarantee no mesh pass-through. Instant full-depth separation and pair-clip mount are both one-frame root writes. Blends will never fix that. Rate-limiting the gap after the write also will not, as you measured.

1. Permanent architecture

Split authority.

Layer	Owns	Must not own
Tick engine	Outcome: seats, range class, legal stance distance, who is in the pair	Mesh capsules, clip root poses
Presentation	Visual roots + poses, contact look, clip playback	Fight result

Engine stays truth. Presentation is a bounded tracker of that truth, not a second physics world that can shove 0.5 m in 1/60 s.

Where the no-overlap guarantee lives

Not in a one-frame room push. Three places, in this order:

Engine distance envelope (primary). Every stance and seat already implies a min/max centre-to-centre. Encode it. Engine positions never request a rendered pair closer than min_dist(seat, builds). Your 0.76 → 1.27 m example is the room inventing a constraint the engine did not have. If the engine’s own distance only moved 2.6 cm, the room had no right to move 51 cm.
Limb/contact solver (visual only). Hands, head, torso, feet. Relative IK onto partner bones — EA UFC’s published approach: bake contact as hand relative to opponent head, tightness-ramped, so different heights/reaches do not move roots. Overlap of meshes is an IK/capsule-soft problem. Overlap of roots is an engine problem.⁠YouTube
Root-motion warp toward a target (pair enter/exit only). Unreal Motion Warping / contextual pair scenes: a window inside the clip stretches translation and rotation so you arrive at the authored relative transform, you do not teleport to it at frame 0.⁠Docs.unrealengine

Do not put the guarantee in: full-body physics as the fighter, motion matching as the whole fight, or mid-clip sliding of one man. Physics fights authored pairs. Motion matching needs a library you do not have for every MMA seat. Mid-clip slide breaks the two-person performance.

How a two-person clip is entered and exited

Treat the pair as a short scene, not a pose snap.

Engine announces the seat early (judgment: 200–400 ms before the tick that changes the seat). Presentation starts the warp before the engine flip.
Clip playback begins in current world poses. First warp window (approach, typically first 10–25% of clip, or a dedicated 8–15 frame align) moves both roots toward the pair’s authored relative transform. Residual scale error (height/reach/build) is not closed with roots. It is closed with relative IK on the contact bones for the hold of the clip.
During the hold: one actor is pair-space origin; the other is relative. Roots do not independently chase engine ticks. Engine may keep ticking seats; presentation stays locked until the exit window.
Exit window warps from pair-space back onto current engine positions/facings. Then, and only then, the room resumes tracking. Same rule at clip end as at clip start: no single-frame handoff.

If the residual at window start is huge (> ~0.4 m or > ~25°), do not play that pair clip. Play a one-beat “gather/clinch step” or delay the seat visually. A missed pair is cheaper than a 0.65 m snap.

What shipped games actually do (judgment marked)

Fighting games (Tekken, SF-likes): pushboxes resolve in the sim, a few centimetres per frame, authored so animation and collision agree. Displayed pose is the sim. They do not correct 0.5 m of mesh overlap after the fact. Tekken updates posture and collision every frame; a one-frame discrepancy is treated as a sim bug, not a render fix.⁠X
EA UFC: relative IK between partner bones so two-player mocap survives different body scales. Contact follows the other man; roots stay. That is the right answer for your build variance.⁠YouTube
Unreal pair/finishers: Contextual Anim + Motion Warping. Align over a window; disable pawn-vs-pawn capsule during the scene so the solver does not fight the clip.⁠YouTube
FIFA / Madden interactions: motion-match into the interaction so the paired clip starts near the authored spacing; they explicitly rejected gameplay-stealing root alignment, and accepted slight visual slop when coverage is good. You can be stricter than FIFA because the engine already owns the outcome.⁠YouTube
NBA 2K: moving off scripted mocap collisions toward system-driven contact, because authored pair spacing does not survive live bodies.⁠X
For Honor: motion matching so you arrive in the right pose rather than cut to it. Useful later for walks/turns into range; not your week-one pair fix.
Sifu / soulslike finishers: warp-to-target on the initiator, victim plays the matching take. Same window idea.

Judgment: you are closer to UFC + Unreal pair scenes than to Tekken. Tekken can make the display equal the sim because the sim is the animation. Your sim is a 2D tick engine. So presentation must track, not be, the engine — but the engine must stop requesting illegal distances.

2. Gate

Keep the 60 Hz probe. Change what it fails on.

Metric	Gate
Root translation jump	0 events/round with Δp > 0.10 m in 1/60 s
Root yaw jump	0 events/round with Δyaw > 15° in 1/60 s
Soft cap (debug, not ship fail)	Δp > 0.04 m or Δyaw > 8° flagged; budget < 8 / boxing rd, < 6 / MMA rd
Pair mount/dismount	Max root Δ over the warp window, not over 1 frame. Window ≥ 8 frames. Peak Δp/frame inside window ≤ 0.04 m
Mesh overlap	Capsule/mesh penetration < 2 cm after IK, never closed by a root write > 0.03 m/frame
Engine vs render lag	Render centre may trail engine by ≤ 0.12 m and ≤ 12° during open space; 0 extra lag once a pair scene is locked
Outcome invariance	Same seed → same engine result with presentation on or off

If a clip cannot meet the pair-window cap, it is not shippable on that body pair. That is an asset/gate problem, not a room-push problem.

3. This week / later

This week

Kill the one-frame overlap writer. Replace with a per-frame budgeted separation: max ~0.03 m and ~6° toward the legal gap. If still overlapping, IK the penetrating limb/torso, do not move the other man’s root the rest of the depth.
Stop pair mount/dismount snaps. Add an 8–12 frame warp into and out of pair space. Disable fighter-vs-fighter capsule resolve for the locked scene (same as UE contextual setups).
Engine: publish min_dist / facing for the current seat and the next seat with a lead time. Room follows that, not raw mesh depth.
Keep the 60 Hz probe. Split counters: overlap_push, pair_enter, pair_exit, other. You need to see which writer dies.

That should take you from ~73 / ~50 events toward the soft cap. Not to zero. Zero needs the IK and the early seat announce.

Later

Relative IK on pair contact bones (hands/head/hips) so authored spacing can be wrong by 10–20 cm and still look locked.
Motion matching only for locomotion into range / after exit, so you rarely start a pair 0.65 m off.
Per-clip warp windows authored on the mocap (approach / hold / release), not a global blend length.
Reject or retarget pair clips whose authored spacing is an outlier for the roster’s height/reach band.
4. Against myself

Strongest case this is wrong / too expensive

You are building a second motion system on top of a tick engine and a mocap library that was not authored with warp windows or relative-IK curves. UFC spent years on that contact layer. If engine distances stay “soft” and pair clips stay “snap at t=0 because that is how they were cut,” the room will keep inventing corrections. Motion warping also creates teleports when the window is too short or the target updates late — Unreal users hit this constantly. A pair-space lock can desync from a mid-clip engine seat change (referee break, chain wrestle) and then the exit warp becomes the new snap.

Cost: every pair clip needs windows + contact sockets; every body scale needs IK limits; the probe becomes a ship gate that will fail assets, not just code.

Cheapest 80%

Do only week-one items 1–3. Cap root correction per frame. Warp pair enter/exit over ~10 frames. Put min-distance in the engine so the room is not the first to notice a lean. Leave relative IK and motion matching alone.

Judgment: that 80% kills the two writers you named (full-depth push, pair snap). The remaining events will be locomotion/turn pops and scale mismatch inside holds — visible, not 0.5 m teleports. Zero events is the architecture in §1. Ship-credible is the cap.

34 sources