"""C112 gate (written by Claude before launch). Run from the repo root:
    python research/C112_check.py [label ...]        (default label: smoke)

C112 builds the instrument for S4a step (1): is the LIVE room's frame pacing smooth? C110 listed the suspects from
the code and measured none. Nothing here trusts the tool's own summary:
- the summary is recomputed from the per-frame rows;
- the clock is pinned to physics: the frames' deltas must add up to the wall time the tool measured, and the room's
  presented clock must advance by exactly the deltas it was given once the fight is presenting (speed 1);
- the tool must time the room's own _process call and read render times from the RenderingServer, never estimate;
- the tool may not read any other research JSON.
"""
import json
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
GODOT = ROOT / "Godot"
TOOL = GODOT / "tools" / "measure_live_frames.gd"
COLUMNS = ["frame", "wall_ms", "delta_ms", "room_process_ms", "render_cpu_ms", "render_gpu_ms", "presented_s",
           "clip_changes"]

failures = []


def fail(msg):
    failures.append(msg)
    print("FAIL:", msg)


def pct(values, p):
    ordered = sorted(values)
    if not ordered:
        return 0.0
    k = (len(ordered) - 1) * p / 100.0
    lo = int(k)
    hi = min(lo + 1, len(ordered) - 1)
    return ordered[lo] + (ordered[hi] - ordered[lo]) * (k - lo)


def near(a, b, rel=0.01, absolute=0.05):
    return abs(float(a) - float(b)) <= max(absolute, rel * max(abs(float(a)), abs(float(b))))


def check_stats(label, stats, values):
    for key, p in (("p50", 50), ("p90", 90), ("p99", 99)):
        if key not in stats:
            fail("%s lacks %s" % (label, key))
            return
        if not near(stats[key], pct(values, p), rel=0.02, absolute=0.06):
            fail("%s.%s %.3f != %.3f recomputed from the rows" % (label, key, float(stats[key]), pct(values, p)))
    if not near(stats.get("max", -1), max(values) if values else 0.0, rel=0.0, absolute=0.001):
        fail("%s.max != the rows' max" % label)
    if not float(stats["p50"]) <= float(stats["p90"]) <= float(stats["p99"]) <= float(stats["max"]) + 1e-9:
        fail("%s is not ordered: %s" % (label, stats))


def check_run(label):
    path = GODOT / "research" / ("C112_live_frames_%s.json" % label)
    if not path.is_file():
        fail("missing %s" % path.relative_to(ROOT))
        return
    data = json.loads(path.read_text(encoding="utf-8"))
    pop = data.get("population", {})
    for key in ("seed", "seconds_requested", "ruleset", "fighters", "headless", "vsync_mode", "max_fps",
                "physics_ticks_per_second", "rendering_method", "label"):
        if key not in pop:
            fail("%s: population lacks %s" % (label, key))
    if str(pop.get("label", "")) != label:
        fail("%s: population.label is %r" % (label, pop.get("label")))
    fighters = pop.get("fighters", [])
    if len(fighters) != 2 or fighters[0] == fighters[1]:
        fail("%s: population.fighters must name two different men: %s" % (label, fighters))
    if data.get("columns") != COLUMNS:
        fail("%s: columns must be exactly %s" % (label, COLUMNS))
        return
    rows = data.get("frames", [])
    if len(rows) < 30:
        fail("%s: only %d frames" % (label, len(rows)))
        return
    for i, row in enumerate(rows):
        if len(row) != len(COLUMNS) or int(row[0]) != i:
            fail("%s: frame row %d is malformed: %s" % (label, i, row))
            return
    pipelines = data.get("pipeline_compilations")
    if not isinstance(pipelines, list) or len(pipelines) != len(rows):
        fail("%s: pipeline_compilations must have one entry per frame" % label)
        return
    if any(not isinstance(value, int) or isinstance(value, bool) or value < 0 for value in pipelines):
        fail("%s: pipeline_compilations must be non-negative ints" % label)
    monitors = pop.get("pipeline_monitors")
    if not isinstance(monitors, list) or not monitors or any(not isinstance(value, str) for value in monitors):
        fail("%s: population.pipeline_monitors must be a non-empty list of strings" % label)
    wall = [float(r[1]) for r in rows]
    if any(b < a for a, b in zip(wall, wall[1:])):
        fail("%s: wall_ms goes backwards" % label)
    deltas = [float(r[2]) for r in rows]
    process = [float(r[3]) for r in rows]
    cpu = [float(r[4]) for r in rows]
    gpu = [float(r[5]) for r in rows]
    presented = [float(r[6]) for r in rows]
    s = data.get("summary", {})
    if int(s.get("frames", -1)) != len(rows):
        fail("%s: summary.frames != rows" % label)
    wall_s = (wall[-1] - wall[0]) / 1000.0
    if not near(s.get("wall_s", -1), wall_s, rel=0.001, absolute=0.01):
        fail("%s: summary.wall_s %.3f != last - first wall_ms %.3f" % (label, float(s.get("wall_s", -1)), wall_s))
    delta_sum = sum(deltas[1:]) / 1000.0
    if not near(delta_sum, wall_s, rel=0.03, absolute=0.1):
        fail("%s: PHYSICS - the frames' deltas add to %.3f s but the wall clock moved %.3f s" % (label, delta_sum, wall_s))
    if not near(s.get("delta_sum_s", -1), delta_sum, rel=0.001, absolute=0.01):
        fail("%s: summary.delta_sum_s != the rows' deltas after frame 0" % label)
    first = int(s.get("first_presented_frame", -1))
    if not 0 <= first < len(rows) - 1:
        fail("%s: summary.first_presented_frame %d is not a frame before the last" % (label, first))
    else:
        advance = presented[-1] - presented[first]
        given = sum(deltas[first + 1:]) / 1000.0
        if not near(advance, given, rel=0.01, absolute=0.05):
            fail("%s: PHYSICS - the room's presented clock advanced %.3f s over deltas of %.3f s (speed 1)"
                 % (label, advance, given))
        if not near(s.get("presented_advance_s", -1), advance, rel=0.001, absolute=0.01):
            fail("%s: summary.presented_advance_s != the rows' presented advance" % label)
    check_stats("%s: summary.delta_ms" % label, s.get("delta_ms", {}), deltas[1:])
    check_stats("%s: summary.room_process_ms" % label, s.get("room_process_ms", {}), process)
    check_stats("%s: summary.render_cpu_ms" % label, s.get("render_cpu_ms", {}), cpu)
    check_stats("%s: summary.render_gpu_ms" % label, s.get("render_gpu_ms", {}), gpu)
    if max(process) <= 0.0:
        fail("%s: room_process_ms is zero on every frame - the room's _process was not timed" % label)
    hitches = s.get("hitches", {})
    threshold = 2.0 * pct(deltas[1:], 50)
    if not near(hitches.get("threshold_ms", -1), threshold, rel=0.02, absolute=0.06):
        fail("%s: hitches.threshold_ms must be twice the delta p50 (%.3f)" % (label, threshold))
    hitch_frames = [i for i in range(1, len(rows)) if deltas[i] > threshold]
    if int(hitches.get("count", -1)) != len(hitch_frames):
        fail("%s: hitches.count %s != %d frames over the threshold" % (label, hitches.get("count"), len(hitch_frames)))
    early = [i for i in hitch_frames if (wall[i] - wall[0]) < 3000.0]
    if int(hitches.get("first_3s_count", -1)) != len(early):
        fail("%s: hitches.first_3s_count != hitches in the first 3 s of wall time" % label)
    changes = [i for i in range(len(rows)) if int(rows[i][7]) > 0]
    if int(s.get("clip_change_frames", -1)) != len(changes):
        fail("%s: summary.clip_change_frames != frames with clip_changes > 0" % label)
    near_change = [i for i in hitch_frames if any(abs(i - c) <= 1 for c in changes)]
    if int(hitches.get("on_clip_change", -1)) != len(near_change):
        fail("%s: hitches.on_clip_change != hitches within one frame of a clip change" % label)
    pipeline_total = sum(pipelines)
    pipeline_frames = sum(value > 0 for value in pipelines)
    on_pipeline = sum(pipelines[i] > 0 for i in hitch_frames)
    if int(s.get("pipeline_compilations_total", -1)) != pipeline_total:
        fail("%s: summary.pipeline_compilations_total != pipeline rows" % label)
    if int(s.get("pipeline_frames", -1)) != pipeline_frames:
        fail("%s: summary.pipeline_frames != pipeline rows" % label)
    if int(hitches.get("on_pipeline", -1)) != on_pipeline:
        fail("%s: hitches.on_pipeline != pipeline hitches" % label)
    if len(changes) == 0 and wall_s > 20.0:
        fail("%s: no clip ever changed in %.0f s - the players' AnimationPlayers were not read" % (label, wall_s))


def main():
    labels = sys.argv[1:] or ["smoke"]
    if not TOOL.is_file():
        fail("missing %s" % TOOL.relative_to(ROOT))
        return finish()
    tool = TOOL.read_text(encoding="utf-8")
    for needed in ("FightWorldLive.tscn", "Time.get_ticks_usec", "viewport_set_measure_render_time",
                   "viewport_get_measured_render_time_cpu", "viewport_get_measured_render_time_gpu",
                   "presented_seconds", "stage_players", "C112_live_frames_"):
        if needed not in tool:
            fail("the tool does not contain %r" % needed)
    for banned in ("C110_live_room_frames", "Q94_engine_pace", "BAKEOFF_"):
        if banned in tool:
            fail("the tool names %s - it must measure, not read" % banned)
    for label in labels:
        check_run(label)
    return finish()


def finish():
    if failures:
        print("C112_check: %d failure(s)" % len(failures))
        sys.exit(1)
    print("C112_check: PASS")
    sys.exit(0)


if __name__ == "__main__":
    main()
