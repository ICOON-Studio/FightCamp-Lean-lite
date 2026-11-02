---
name: reference_quickmagic
description: QuickMagic Basic subscribed 2026-09-29 (koxar13, $14.9/mo, 200 credits, 60 s, 2 people, FBX/Mixamo); the OPERATOR uploads (session upload refused), Claude reviews/fetches
metadata:
  type: reference
---

QuickMagic (quickmagic.ai) video -> 3D mocap. Operator subscribed Basic MONTHLY on 2026-09-29 (account koxar13): $14.9/mo,
200 credits/month, max 60 s per video, up to 2 people, exports FBX/BVH/Mixamo/Unreal/Unity, "Basic, Pro, Max, and Studio
plans support commercial use" (pricing page). Credits per second NOT published. G95_BODY_MODEL_LICENCES.md named it the
cheapest legal two-person route (contacts cleaned by hand).

**How it runs:** Claude in Chrome (operator's signed-in Chrome), page /3d-character-animation-videos/index/video-to-motion.
Uploading a LOCAL file from the session is refused by the harness's exfiltration check - the operator uploads (he did not know
where research files live: copy the clip to his Downloads and open Explorer on it). Downloads need his OK each time.
Pipeline: FBX on the Mixamo skeleton -> the existing Mixamo retarget path -> Blender contact cleanup -> C223 / C222 gates.
First test clip: _captures/ground_video/mount_gnp_2human_locked.mp4 (two-person mount). Related: [[project_two_body_motion_workflow]].

**First run (S127, 2026-09-29):** mount_gnp_2human_locked.mp4 -> 9 credits, ~8 min, ONE body (the top man); the pinned bottom
man was never detected. QuickMagic's own doc says avoid prolonged overlap. Use it for SINGLE performers in clear view (boxing
moves, standing entries), not tangled ground positions. Mesh Penetration Prevention (beta) triples the cost.

**Text to Motion (S128):** no upload needed - Claude runs it in the operator's Chrome; Mixamo format; Foot Sliding Fix doubles the
cost (4 -> 8 credits for 4 s). Check hook: too slow raw (2.9-3.8 m/s) - the C223 strike warp fixes it (8.46 m/s, 383 ms);
the "float" was NOT QuickMagic: its FBX is grounded; our adapter read the hierarchy (= frame 0) as the rest - fixed S129 (bind pose). Downloads land in Downloads as "<title>.zip". Text-to-motion pads ~2.3 s of guard drift after the move -> trim with adapter end_s=. Motion Editor = an AI prompt box ("fix the jitter from frames X-Y"), imports T2M/V2M takes.

**S130:** T2M in-place + foot-sliding fix = 12 cr per take (2 takes 24). V2M two people, 8 s = 16 cr (V2.1 model, hands off costs the same). Person detection runs on the FIRST frame only: bodies apart -> 2 people (guard pass), wrapped -> ONE merged box (side control); the refresh button clears detection. Uploads = operator; Claude sets Mixamo per detected person (click box, then Mixamo) and generates.

**S131 two-person result (guard pass, downloaded with the operator's OK):** zip = 2 Mixamo FBX (`..._001/_002_Mixamo.fbx`,
52 bones, 8 s) in `D:/FightCamp/sources/quickmagic/qm2p_guard_pass/`. `Godot/tools/qm2p_pair_check.gd dir=...`: BOTH in one
shared metric space (hips 0.46-0.56 m kneeling passer, 0.17-0.22 m seated guard, hips 0.76-1.09 m apart); approx-capsule
overlap >2 cm on 17% of frames, max 9.9 cm, passer thigh x guard shin (real leg contact -> cleanup). Mutant (B on A) 26 cm.
Download trap: the project viewer is Unity WebGL - it only loads in a VISIBLE tab (document.visibilityState 'hidden' = the
loader crawls forever); bring the Chrome window forward (UIA TabItem search -> NativeWindowHandle -> SetForegroundWindow).
