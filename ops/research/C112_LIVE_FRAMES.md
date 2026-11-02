## DECISIONS

Population: `smoke`, seed 810039, boxing, out-boxer (A) vs pressure puncher (B).

Run the three windowed measurements from the repo root (one variant each):

    Godot_v4.7.2-stable_win64_console.exe --path Godot --script tools/measure_live_frames.gd -- seconds=60 label=default
    Godot_v4.7.2-stable_win64_console.exe --path Godot --script tools/measure_live_frames.gd -- seconds=60 vsync=disabled label=vsync-disabled
    Godot_v4.7.2-stable_win64_console.exe --path Godot --script tools/measure_live_frames.gd -- seconds=60 max_fps=60 label=max-fps-60

Headless smoke: 555 frames. `room_process_ms` p50/p99/max: 0.131 / 0.63392 / 3.427 ms.

The smoke instrument showed per-frame room work is usually small but has a 3.427 ms
maximum; the unbounded catch-up pump and body animation are the work to compare in
the windowed run. Headless timings do not establish live pacing or stutter.
