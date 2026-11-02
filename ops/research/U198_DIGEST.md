# U198 digest — room root write order (Cursor)

## Send-back 1 (S125)

**Claude reject on 74dd2d48:** fixed 3 cm/frame cap ran *after* `_stop_posed_contact` and pulled roots back toward frame start (contact_stop FAIL; overlap hand>head **151 mm** @827 vs master **~1–3 mm**).

**Choice (a):** cap limits placement/engine root motion; **`_stop_posed_contact` runs after the late cap** so separation is not undone; final `_rope_clamp_pair` after contact_stop. Option (b) (extra cap allowance only) kept as a small `extra_budget_m` on the late cap from live refused depth (≤ `OVERLAP_SEP_MAX_STEP_M`).

**Budget:** `ROOT_CAP_MPS = 2.5` m/s × `max(delta, 1/120)` × `_speed` → **41.7 mm/frame @ 60 Hz, speed 1.0**. Yaw: `ROOT_CAP_YAW_DEG_PER_S = 600` (10°/frame @ 60 Hz). Early placement pass uses `ROOT_CAP_PLACEMENT_MPS = 4.0`.

| Test | Wanted (merge bar) | Before send-back (74dd2d48) | After send-back 1 |
|------|-------------------|-----------------------------|-------------------|
| `fight_room_no_teleport` | PASS | PASS (0 jumps) | **PASS** (0 jumps) |
| `fight_room_ring_bounds` | PASS | PASS | **PASS** |
| `fight_contact_stop` | 145/0 | FAIL | **145/0** |
| `fight_body_overlap` | no worse than master control | worst **151 mm** hand>head @827 | worst **4.3 mm** head>arm @827 (merged master control: **2.7 mm** hand>head @739, head>arm **0**) |
| `footwork_beats_reach_room` | unchanged | — | **34/0** |
| `fight_body_layers_live` | unchanged | — | **25/0** |
| `boxing_output` | unchanged | — | **19/0** |
| `fight_room_positions` | — | not run | **not run** (~100 min) |

## Send-back 2 (S126 merge + overlap order)

**Merged** `origin/master` (S126 `PUSH_SKIN_M` / `HEAD_CLEAR_M` contact pass). **Control** measured on master worktree `C:/Users/user/OneDrive/Documents/ChatGPT/Game` @ `origin/master`: overlap **TOTAL=2 fails=1**, worst **2.7 mm hand>head @739**, **head>arm 0**.

**Root cause (4.3 mm head>arm @827 on send-back 1):** `_finish_root_frame` (late cap) ran after `_correct_refused_head_contact`, pulling roots toward frame start and leaving arm-in-head pose until contact_stop; S126 head pass only clears **> 3 mm** (`HEAD_CLEAR_M`), so **2–4 mm** head>arm survived.

**Fix (d10fe59c):** `_correct_refused_head_contact` runs **after** the late cap (leg cross + nudge still before cap; `_stop_posed_contact` + final rope unchanged).

| Test | Merge bar | Master control | Merged branch (d10fe59c) |
|------|-----------|----------------|--------------------------|
| `fight_room_no_teleport` | PASS | — | **PASS** |
| `fight_room_ring_bounds` | PASS | — | **PASS** |
| `fight_contact_stop` | 145/0 | 145/0 | **145/0** |
| `fight_body_overlap` | no worse than master worst | **2.7 mm** hand>head @739, head>arm **0** | **1.8 mm** hand>head @897, head>arm **0** (TOTAL=2 fails=1) |
| `fight_room_positions` | run once | — | **in flight** |

**Worst-frame diagnosis @827 (pre-fix):** late cap between overlap head pass and contact_stop left head>arm excess; not a rope-after-contact_stop regression (rope still last on frame).

## Probe (seed 94301 boxing)

`tools/u198_root_writes.gd`: residual >3 cm after full frame attributed to placement cap / rope, not contact_stop undo.

## `fight_pair_live`

Still **FAIL** (seed 810039: 0 head jabs → 0 qualifying); not in scope.

## Code

- `FightWorldLiveScreen.gd`: dual `_finish_root_frame`, `_correct_refused_head_contact` after late cap, `_stop_posed_contact(delta)` after cap, rope last.
