# JOHN_TWOBOXER_MOCAP_S537 - two boxers' 3D motion from AI or real video: what works NOW (late 2026)

You are Dola, our second research seat (fresh eyes, independent of John). Owner S537: "i believe there are new tools that can do that, maybe need an update research,
which models can do it and how what other tools needed". Search the web hard, newest first (2025-2026 releases count most).
Every claim gets a link and a date; label each DOCUMENTED (the maker or a paper says it) / TESTED BY OTHERS / NOT VERIFIED.

## The goal
Two boxers sparring - range, inside exchanges, clinch, punches landing on the guard and the head - turned into clean 3D
skeletal animation (FBX/BVH/GLB, humanoid skeleton) that we can retarget to our own rig and SHIP in a sold PC game (Godot).
Either from (a) AI-generated video, or (b) real phone video of two people.

## What already failed for us (do not re-suggest without saying what is new)
- AI video (Seedance 2.0) side-by-side "two views" = one image, no true second camera; detectors merged the two bodies in a
  wrapped guard (36-40 % found) and lost them from overhead (4-10 %); identity swaps 4-12 % (our G76).
- Detect -> crop -> single-person 2D -> 3D lift stacks (RTMPose, MediaPipe) cannot handle two bodies in contact.
- SMPL / SMPL-X based solvers and AMASS-trained models: their licences forbid commercial use unless bought (Meshcapade).
  Harmony4D, ViCoS, QuickMagic were blocked on licence. DeepMotion / Plask / Cascadeur / Tripo free tiers are non-commercial;
  Move.ai keeps a perpetual training licence on your video.

## Questions
1. AI VIDEO WITH TRUE MULTI-VIEW: which video models (Veo, Kling, Seedance, Runway, Sora, Hailuo, Wan, open ones, research like
   ReCamMaster / SynCamMaster / camera-controlled or 4D generation) can now render the SAME moment from 2-4 consistent cameras,
   or a 4D/3D-consistent scene? Can two fighters stay physically consistent across views (same punch, same contact)? Show any
   fight/dance/martial-arts example.
2. MULTI-PERSON 3D FROM VIDEO, CONTACT-AWARE: the newest models that recover TWO people in close contact in world space from one
   or a few videos (e.g. Meta SAM 3D Body, PromptHMR, GVHMR, WHAM, Multi-HMR, 4DHumans successors, BUDDI/contact models,
   anything 2026). Which handle occlusion and contact; which output a usable skeleton; licence of code AND weights AND the body
   model each needs.
3. END-TO-END APPS (2026): Move.ai (Move Pro multi-person), DeepMotion multi-person, Rokoko Vision, Autodesk Flow Studio,
   Uthana, Kinetix, any new one - two-person support, contact quality, export, price, commercial licence, training clause.
4. AI TEXT/VIDEO-TO-MOTION FOR TWO PEOPLE: any model that generates two-person interaction motion directly (interaction
   generation research, e.g. InterGen successors) with a commercial licence.
5. THE PIPELINE: for the best 2 routes, the full tool chain step by step (generate or film -> solve -> clean (Cascadeur/Blender)
   -> retarget -> export), hardware needed (our PC: one consumer AMD GPU, so say if CUDA/NVIDIA is required), cost, and the
   one test that would prove it on a 10-second boxing clip.

## Answer format
A table per question; then a TOP 3 ranked for "two boxers in contact, shippable, this year", each with its catch; then what
you could not verify. Plain words. No invented prices.
