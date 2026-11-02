# K43 — WHY A GODOT 4 3D SCENE STUTTERS ON WINDOWS, AND WHICH SETTINGS MAKE IT SMOOTH

**Desk:** Kalli (Grok Bot), research. **Delivered:** 2026-09-14 01:53. **Captured by Claude from the chat transcript** (`grokbots.py read --to Kalli --out`), not reworded; tab-separated tables kept as delivered.

## DECISIONS
V-Sync / max FPS first: Keep VSYNC_ENABLED, set max_fps to refresh−3 if the monitor has VRR (e.g. 141 on 144 Hz); else leave 0. Why: matches your defaults, enables delta smoothing, and is the official low-lag VRR recipe — not Mailbox yet.
Delta smoothing: Leave true (only works with VSYNC_ENABLED).
Physics interpolation: Not needed for a scene that moves + AnimationPlayer.advance(delta) in _process — it fixes physics-tick vs render mismatch, which you are not using.
Pipeline warm-up: Fighters already at scene start help; still instantiate every material/anim once (can be hidden) before the timed run, then watch Debugger pipeline compilation monitors. Enable Shader Baker on export later (4.5+).
Look for first in frame-time numbers: A one-shot spike on first draw of skinned meshes (Surface/Draw pipeline compilations) vs a steady irregular delta with flat GPU time (Windows present / windowed compositor) — Movie Maker hides both.
1. Delta smoothing
Finding	Label	Source
Setting	application/run/delta_smoothing default true. Filters OS frame-delta noise under V-Sync.	DOCUMENTED
V-Sync gate	“only attempted when … vsync_mode is set to enabled”; needs several seconds at stable refresh; only if machine can sustain refresh rate.	DOCUMENTED
Runtime / CLI	OS.delta_smoothing; --delta-smoothing enable|disable.	DOCUMENTED
Origin	Added via GH-48390 (ported to 4.x as lawnjelly’s four_delta_smooth / related merge); overflow fix PR #51495 (2021-08-11). Present in Godot 4.x line you ship.	DOCUMENTED
2. V-Sync modes (Windows + Vulkan)
Mode	Behaviour (docs)	Typical Vulkan present	Pacing notes	Label	Source
Disabled (0)	Frames ASAP; tearing; unlimited FPS	IMMEDIATE	Less “wait stutter”, more tear	DOCUMENTED (behaviour); SECONDARY (Vk name)	DisplayServer VSyncMode
Enabled (1, default)	Show on VBlank; FPS capped to refresh	FIFO	Delta smoothing works; input latency can be high with deep queue	DOCUMENTED	Same; jitter_stutter
Adaptive (2)	Like Enabled until FPS drops below refresh, then behaves like Disabled	FIFO_RELAXED	Forward+/Mobile only	DOCUMENTED	DisplayServer
Mailbox (3)	Newest frame on VBlank; render as fast as possible (“Fast” V-Sync); best at ≥2× refresh	MAILBOX	Fixes some FIFO “old frame” judder by brute force; 100% GPU expected; severe judder if capped at refresh	DOCUMENTED + SECONDARY	DisplayServer; #89856 (2024-03, open — expected behaviour); #75830 latency numbers; related FIFO issue #84137
Queue depth	Defaults swapchain_image_count=3, frame_queue_size=2. Cut swapchain to 2 (4.3+) for lower latency if you always hit refresh.	—	DOCUMENTED	ProjectSettings + jitter_stutter	
Windows	Windowed games often stutter (compositor/drivers); Exclusive Fullscreen preferred; Godot raises process priority.	—	DOCUMENTED	jitter_stutter · Windows	
3. Physics interpolation (3D)
Finding	Label	Source
When added	Godot 4.4 — 3D physics interpolation (2D was 4.3).	DOCUMENTED
What it fixes	Visual jitter when physics TPS ≠ display refresh / objects update only on physics ticks.	DOCUMENTED
What it does not fix	Shader/pipeline hitches, V-Sync present judder, CPU/GPU frame overruns. Requires moving logic in _physics_process.	DOCUMENTED
Your _process + MANUAL advance scene	Interpolation expects physics-tick transforms. Driving AnimationPlayers every render frame already is frame-rate motion — turning interpolation on without migrating to physics ticks can warn / fight you.	DOCUMENTED
4. Shader / pipeline compilation (Forward+)
Finding	Label	Source
Pre-4.4	Pipelines compiled when object first enters view → classic first-play hitch.	DOCUMENTED
4.4+	Ubershaders + load-time pipeline precompilation (Mesh / Surface steps). Still need evidence of features at load (MSAA, VoxelGI, etc.).	DOCUMENTED
4.5+ Shader Baker	Export option packs SPIR-V/etc. into PCK — speeds shader compile, not a full PSO warm-up replacement.	DOCUMENTED
Warm-up for fighters at scene start	Adding skinned meshes to the tree at load triggers Surface compile on first frames (OK if right after load). Dynamically spawned FX need a hidden instance once. Off-screen / ColorRect-covered draw still recommended for features you toggle later.	DOCUMENTED
Cache	Driver cache + Godot pipeline cache (rendering/rendering_device/pipeline_cache/enable); Vulkan pipeline cache PR lineage #76348.	DOCUMENTED
5. AnimationPlayer / AnimationMixer
Finding	Label	Source
MANUAL + advance(delta)	Documented: ANIMATION_CALLBACK_MODE_PROCESS_MANUAL = “Do not process animation. Use advance() …”	DOCUMENTED
play() lag	“animation will be updated the next time … is processed … To perform the update immediately, call advance(0).”	DOCUMENTED
First-time play() hitch	No engine doc of a special compile hitch inside AnimationPlayer; first visible skinned draw is usually pipeline, not the mixer.	NOT FOUND (AP-specific hitch); DOCUMENTED (pipeline)
6. Measuring
Tool	Sees	Misses	Label	Source
Profiler (Debugger)	Script/physics CPU functions	GPU detail	DOCUMENTED	Debugger panel
Visual Profiler	Render CPU + GPU categories	Scripting / physics CPU	DOCUMENTED	Same
Monitors	FPS, memory, pipeline compilation counters (Canvas/Mesh/Surface/Draw/Specialization)	Per-draw names	DOCUMENTED	pipeline_compilations
Performance.get_monitor(...)	Engine counters incl. TIME_FPS / TIME_PROCESS	Present-queue wait not isolated	DOCUMENTED	Performance class
viewport_set_measure_render_time + viewport_get_measured_render_time_cpu/gpu	Last-frame render CPU/GPU ms (enable first; read in _process)	Not compositor wait; Metal GPU often 0 (you’re on Windows Vulkan — OK)	DOCUMENTED	#75346; RenderingServer
debug/settings/stdout/print_gpu_profile	Per-second GPU stage print	—	DOCUMENTED	ProjectSettings
7. What shipped / official demos do
Example	Practice	Label	Source
Official jitter/stutter guidance	Exclusive Fullscreen; V-Sync + VRR + max_fps slightly under refresh; pipeline/ubershader care since 4.4	DOCUMENTED	jitter_stutter
Pipeline docs / demos	Hide unused FX under player so pipelines precompile; watch compilation monitors (screenshots from demo projects)	DOCUMENTED	pipeline_compilations
3D Graphics Settings demo	Exposes V-Sync mode options for players	SECONDARY	Forum / demo references
Named commercial Godot 4.7 Forward+ fight-game pacing write-up	—	NOT FOUND	—
GAPS
Exact VkPresentModeKHR mapping is inferred from DisplayServer wording + Vulkan enums (engine source line not fetched this pass).
No public bake-off of Mailbox vs Enabled on Win11 Forward+ with your exact GPU.

