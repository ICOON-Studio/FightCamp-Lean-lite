# TASK J31 — JOHN — AI GENERATORS + SCRIPTS + BLENDER: HOW THE INDUSTRY MAKES COMBAT ANIMATION, AND WILL THIS PIPELINE WORK FOR US?

**Research only.** No engine, no code. Deliver `research/J31_AI_ANIMATION_PIPELINE.md` and mail RESEARCH READY.
Every substantive claim tagged **DOCUMENTED** (with a URL you opened) / **INFERENCE** / **NOT FOUND**. Operator, 2026-09-14,
verbatim: *"Do study how the combination higgsfield,scripts,blender works on the industry and optimize the production of
realistic clips for all disciplines in our game . Check this workflow if it will achieve the result we want"*.

---

## THE WORKFLOW THE OPERATOR WANTS CHECKED (verbatim summary of what they sent)

1. **Character creation**: generate 2D concept art of the fighters in Higgsfield, convert with its Meshy 5 tool to textured
   3D models, export .FBX/.GLB into the engine.
2. **Animation and rigging**: the Higgsfield Blender plugin's **Character Animation** tool - describe a move (e.g.
   *"Generate a double-leg takedown animation"*) and it generates *"a fitted, weighted rig with physical keyframes on the
   timeline"*. Do not render video; export the raw skeletal animation into the engine for live gameplay.
3. **Trailer / hype intro**: script -> Blender blockout -> Higgsfield Seedance video (photorealistic).
4. **Playable game**: script -> Higgsfield Blender plugin for 3D models and raw bone animation -> engine (they wrote Unreal
   Engine 5; OUR engine is Godot 4.7 - that is decided, answer for Godot, note where Unreal would differ).
Links they gave: https://higgsfield.ai/plugins/blender and https://www.youtube.com/watch?v=QkLKpUDDdgo

## OUR FACTS (do not re-research these; build on them)

- A management game with a real-time 3D fight for **boxing, kickboxing / muay thai, MMA, wrestling, judo, BJJ**. A simulation
  engine decides every action; the 3D room shows it. Fighters are Tripo-generated meshes on one humanoid skeleton.
- Our current method (it works, the operator judged the first result "clearly better"): single-character clips (bought
  RamsterZ mocap) are the INPUT; a written **move script** puts BOTH fighters of one exchange on ONE clock in Blender
  (distance, contact frame, the receiver's reaction), corrected against **two-man footage tracked with MediaPipe**, and the
  pair is exported as bone data the Godot room plays. Today we fixed the bought jab's one-frame arm snap and body fold at
  the source.
- The operator bought **Higgsfield Plus (1,000 credits)** today. Claude checked, through Higgsfield's API: rigging one of
  our meshes plus ONE clip from its 3D animation library costs **8 credits**; that library is **Meshy's** (678 clips,
  preview GIFs on cdn.meshy.ai): striking is covered (Left/Right_Jab_from_Guard, hooks, uppercuts, Punch_Combo 1-5,
  roundhouse/high/straight kicks, knee and elbow strikes, Face_Punch_Reaction x3, Block1-10, dodges); **grappling is not**
  (no takedown, clinch, throw or ground work - only a stunt "Jumping_Head_Scissor_Takedown"). A test clip
  (`Left_Jab_from_Guard` on our f01 mesh) came back as a 24-bone Mixamo-style rig at 24 fps: a smooth 0.17 s extension
  (no snap), but a cock-back before it, a 0.33 s hold at full reach and a 9 cm hip dip.
- The plugin page (opened by Claude): Character Animation input = **text prompt**; output = *"a fitted, weighted rig plus
  keyframes on the timeline - standard Blender bones and actions"*; the model behind it is **not named**; nothing about
  animating an EXISTING rig or two characters; *"Generations made through the Blender add-on carry the same usage rights
  as the web platform, including commercial use on paid plans."* Requires Blender 5.1+ and sign-in.
- Already ruled on record: text-to-motion was dropped earlier **on licence AND quality** (our G58, 2026-09-13). The
  licence half may now be answered by the paid plan's terms - check the Terms of Service text itself. Motion CAPTURE is
  ruled out by the operator; motion MATCHING is not.

## WHAT TO FIND

1. **What Higgsfield's Character Animation really is.** Is it a generative text-to-motion model (whose? Hunyuan Motion,
   Kling, MotionGPT-style, Uthana, other) or a text search over the Meshy animation library? Evidence: Higgsfield docs,
   changelogs, the YouTube video's description and chapters, independent reviews, forum or Reddit tests. Can it retarget to
   or animate an existing rig? What do real users show it producing for **combat** moves - strikes, kicks, and especially
   **two-person grappling** (double-leg, single-leg, clinch, judo throws, BJJ positions)?
2. **How the industry combines AI generators, scripts and Blender/DCCs for combat animation (2025-2026).** Shipped games,
   GDC/Siggraph talks, postmortems, studio blogs, credible YouTube breakdowns: which tools (Meshy, Higgsfield, Cascadeur and
   its AI features, Move.ai, Rokoko Vision, DeepMotion, Kinetix, Plask, Uthana, Hunyuan Motion, Tencent/NVIDIA research
   models) are used for what - previs, placeholder, or shipped animation - and at what quality. Name the fighting and
   sports games where AI-generated motion shipped, if any.
3. **Two-character interaction generation.** Any tool or model that generates PAIRED motion (two bodies with contact:
   InterGen, InterControl, Duolando, ReMoS, and newer) that is available and commercially usable; its demonstrated quality
   on wrestling / judo / BJJ-like contact. How AAA combat games (EA UFC, Undisputed, WWE 2K) produce grappling today.
4. **Licences.** Higgsfield and Meshy terms for commercial game use of 3D models and animations made on a paid plan; any
   restriction on training, redistribution, or keeping assets after cancelling; quote the clauses.
5. **The verdict, step by step, for OUR six disciplines**: will the operator's workflow deliver realistic, controllable
   animation that two fighters can share on one clock in a real-time Godot game? What breaks (contact and sync between two
   bodies, ground work, retargeting to our existing skeleton, style consistency across clips, frame-accurate contact,
   exported bone data quality at 24 fps)? Then the **optimized production pipeline we should run**, per discipline
   (striking v grappling), naming the job of each tool - Higgsfield/Meshy, our move script, Blender, Cascadeur, footage.

## WHAT TO DELIVER

`J31_AI_ANIMATION_PIPELINE.md`, 250 lines at most:
- **## DECISIONS** first (at most 15 lines): what Higgsfield's Character Animation is; whether the workflow achieves the
  goal per discipline (a table: discipline | the workflow as sent | what works | what breaks | our recommended pipeline);
  the licence answer; the three highest-value uses of the 1,000 credits.
- **## SOURCES**: a table (URL | who | year | what it says | grade).
- **## HIGGSFIELD CHARACTER ANIMATION**, **## INDUSTRY PRACTICE**, **## PAIRED MOTION**, **## LICENCES**, **## THE PIPELINE**.
- A short **## WHAT TO TEST FIRST** list: the exact prompts or library clips Claude should spend credits on to settle the
  open questions empirically (for example one double-leg takedown prompt in the Blender plugin), and what result would
  confirm or refute each.

## RULES

No invented numbers. No marketing copy passed off as evidence - a vendor's own claim is DOCUMENTED only as "the vendor
says". Every URL opened. Download nothing. Do not spend Higgsfield credits.
