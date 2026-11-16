# Neural4D check (S496)

Owner ask: "check neural4d if it can help with the 3d" + video https://www.youtube.com/watch?v=yQzjKRp9t0o
Checked 2026-11-16. Nothing signed up, downloaded, bought or accepted.

## The video
- "AI Video to Mocap: Generate and Animate a 3D Character with AI", channel CGDive, 2026-07-23, 12 min.
  The creator says on camera it is SPONSORED by Neural4D. Read from the YouTube transcript (auto captions).
- The "video to mocap" part is NOT a Neural4D feature. His steps: (1) make a still of two people on a white
  backdrop in Neural4D's image tool; (2) turn it into a fight video with Seedance (a third-party video model
  that Neural4D resells; about 30 cents per 10 s at 480p, his figure); (3) split the video in an editor so each
  fighter is tracked alone; (4) extract the motion with Unreal Engine 5.8's own markerless motion capture;
  (5) hand-fix bad frames in Unreal. The AI video morphed a body mid-kick and hid one fighter for a moment;
  he deleted and interpolated keys by hand.
- Rest of the video: Neural4D's image, 3D model, texture and "retopo" tools. His verdict: shapes clean,
  multi-view textures stitched badly (single image was better), the retopo tool is "just decimation".

## What Neural4D is (its own site)
- A web platform: text / image / multi-view image to a 3D mesh, AI texturing, remesh, split into parts,
  plus image and video generation (third-party models: GPT Image 2, Nano Banana Pro, Seedance, Grok Imagine).
- Output: watertight meshes; downloads .obj .fbx .glb .usdz .stl .blend (pricing page).
- "Animate": auto-rig a model made on Neural4D, then pick a PRESET motion; download is an animated GLB.
  Its own page says: custom motion upload is not available, local model upload is not available,
  a rig-only download is not documented. Skeleton type, bone names and skin weights: not stated.
  No text-to-motion and no video-to-motion is offered anywhere on the site.

## Price and licence
- Plans: Free (20 models a month, low priority), Go 150, Plus 500, Pro 2,500, Team custom; 30% off yearly.
  Dollar amounts did not render on the official page. G2 lists Pro at $18/month (7,500 "power"); Capterra
  a $6.90 7-day pass. NOT verified on Neural4D's own page.
- Cost per action: generate 10 credits (+10 texture, +10 PBR), remesh 20, split 40, multicolor 30.
- Free tier: outputs "enter the public domain" and Neural4D asks for credit on commercial pages; another
  Neural4D page says free is personal, non-commercial only. The two pages disagree.
- Paid tiers: "commercial use", "private models", you own what you make and may sell it (pricing FAQ).
  A public model being visible does not give a licence (help page, 2026-10-16).
- Training: help page says uploads and outputs are "never used to train our base foundational AI models";
  no opt-in or opt-out described; fine-tuning not addressed.
- Could NOT find or read a full Terms of Use page (/policies/terms is 404). Seedance video licence terms
  when resold through Neural4D, and Unreal's terms for using its mocap output in a Godot game: not checked.

## Against our needs
- Fight MOTION (the real problem, 4/10): Neural4D itself does not help. It has no motion tool beyond preset
  moves on its own auto-rigged meshes, exported as GLB, with no custom or uploaded motion. It cannot drive
  a MetaHuman or our humanoid skeleton. The video's mocap came from Unreal 5.8, not Neural4D.
- The route in the video (AI fight video -> markerless mocap) is a separate idea. Weak spots for boxing:
  AI video invents bodies under fast moves (shown in the video), punches pass through or miss contact,
  occlusion in a clinch breaks tracking, every clip needs hand cleanup, and the result is a guess of a
  guess, not a recorded boxer. Our licensed mocap packs are real captures. Video mocap was looked at before
  (QuickMagic, DECISION_LEDGER; parked).
- Bodies: MetaHuman only. Neural4D's characters, rigs and Animate output cannot be used for our people.
- Props: same job as Tripo (which also rigs and has preset animation) and Ludo, both already paid. The one
  thing the video shows better is clean watertight shapes; its texturing was shown weak and its retopo is a
  plain polygon cut. No clear gain over what we pay for.
- Owner buy rule: no preview of boxing motion exists from Neural4D to judge (stance, guard, distance, head).

## Verdict
SKIP. It is a prop/mesh generator like Tripo and Ludo, with no motion tools that fit a MetaHuman or our
skeleton; the mocap in the video came from Unreal, and the AI-video route is too unreliable for punches.

Sources: the video and its description (YouTube, read 2026-11-16); neural4d.com/pricing;
neural4d.com/features/auto-rigging; neural4d.com/how-tos/can-i-use-the-generated-models-commercially;
neural4d.com/how-tos/are-my-images-and-3d-models-used-to-train-neural4d; g2.com/products/neural4d/pricing;
capterra.com/p/10035362/Neural4D.
