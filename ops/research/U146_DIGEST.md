# U146 digest — no body teleports

Population: seed 94301, 1 round, arm A, `u145_transition_probe.gd` (`stills=off`), same as U145.

## Body jumps (>0.10 m or >15° yaw per 1/60 s frame)

| Discipline | Before (master) | After (U146) | Ceiling |
|---|---:|---:|---:|
| Boxing | 73 | 2 | ≤10 |
| MMA | 48 | 4 | ≤15 |

Writers before: `_place_bodies` / `_floor_clamped` overlap refusal (instant gap), paired grapple mount snap.  
After: eased `_overlap_sep_m` on the rendered gap (2.5 m/s, 0.05 m/s max sep step, 0.07 m/s max rendered-gap step), partial `_correct_refused_overlap`, grapple mount yaw blend 0.25 s (position snaps to mount; release blends position+yaw out).

## Refused overlap depth (rendered, boxing round)

| | Max excess depth (m) |
|---|---:|
| Before (instant refusal, `overlap_sep_ease: false`) | 0.053 |
| After (eased, production defaults) | 0.070 |

After ≤ before + 0.01 m.

## Engine

Beat list unchanged: `fight_room_no_teleport_test.gd` — 57 beats with easing on/off.

## Gates

- `fight_room_no_teleport_test.gd` — pass  
- `run_tests.py --only room` — 4/4  
- `run_tests.py --only world` — 6/6  
- `run_tests.py --only grapple` — 10/10  
- `fight_room_ring_bounds_test.gd`, `fight_room_walkout_test.gd` — pass  
