# TASK G107 - GROK - A CROWD WE CAN SHIP (sources, licences, cost to render)
Owner: grok. Model: Grok Expert (Research mode, NEVER Build). Assigned S81, 2026-09-26. Pure research, no code.
Save target: `research/G107_CROWD_SOURCES.md` (Grok pastes inline; Claude saves).

## Why
Your G105 found the walkout's real bug: "Fill the first six rows. Empty grey is the actual bug." FightCamp renders fights
and the walkout in its own Godot 4.7 engine (Forward+) on a Ryzen 7 7800X3D + Radeon RX 6800 XT that runs hot. The arena
(Marpa "MMA Arena", owned) has seats and no people. We need 150-1,200 spectators that read as a real small hall at a
walkout camera distance, without melting the PC.

## What would a human do?
A technical artist on a sports game fills stands with LODs: a few hero spectators near camera (animated meshes), a mid
band of low-poly skinned or vertex-animated crowd, and the far rows as camera-facing cards/impostors, all instanced, with a
small set of cheer/idle/stand cycles and colour variation. Answer how shipped sports games actually do it BEFORE listing
assets.

## Questions (tag SOURCED with URL + date / PROXY / JUDGEMENT)
1. How do shipped sports games render crowds (EA UFC, FIFA/FC, NBA 2K, Undisputed, indie sports sims)? LOD bands,
   impostors, vertex animation textures, instancing - with numbers where public.
2. Godot 4 specifically: MultiMesh + vertex-animation-texture crowds, impostor/billboard plugins, known performance
   numbers for 500-2,000 instances. Name the add-ons, their licences and their last update.
3. Assets we could ship commercially: crowd packs (CC0 / CC-BY / royalty-free commercial), animated spectator models,
   cheering animation sets. For each: link, licence text summary, price, poly count, animation list, format (GLB/FBX).
   Mark anything with a non-commercial or "no redistribution in games" clause as UNUSABLE.
4. Recommend ONE route for a 6-row small hall (and how it scales to 1,200) with an estimated frame cost, and one fallback.

## Deliverable
One markdown memo inline, titled G107_CROWD_SOURCES, <= 1,500 words.
