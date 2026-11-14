# SPEEDFLIP1 Result - punch_speed_test noise analysis

## Four totals

| Run | Arm | Failures |
|-----|-----|----------|
| new1 | new rules (no args) | 43 |
| new2 | new rules (no args) | 39 |
| old1 | old rules (`-- noweightbase shortwind=0.08`) | 46 |
| old2 | old rules (`-- noweightbase shortwind=0.08`) | 43 |

## Noise rows

**New arm: 35 of 37 rows differ between run1 and run2**

The values that vary:
- `top` speed: varies by 0.1-3 m/s (e.g., pro_right_hook_ft: 10.03 vs 7.29 m/s)
- `first` time: varies by 0.0-0.3 s (e.g., pro_kidney_shot: 0.100 vs 0.333 s)
- `pop` ratio: varies by 0.01-0.5x (e.g., pro_left_jab body: 1.58 vs 1.46)
- `body` ratio: varies similarly

**Old arm: 33 of 37 rows differ between run1 and run2**

Same pattern of variation.

## Real differences

**Zero.** Among the 2 rows that are stable in both arms (new1==new2 and old1==old2), none show a difference in pass/fail between the new and old rules.

The two arms (new vs old reach rules) produce essentially the same test results when you account for the noise. The 7 extra failures mentioned in the task brief (48 vs 41) were noise, not a real effect of `ReachLimit.carry_base` by reach weight.

## Noise source

**File:** `scripts/fight3d/FighterLife.gd`  
**Function:** `_process_modification()` starting at line 94  
**Lines:** 100, 107, 119, 161, 162

FighterLife is a SkeletonModifier3D attached to each boxer. Its `_process_modification()` is called automatically by Godot's animation system when the skeleton is evaluated (triggered by `ap.seek()` in the test's `_play()` function).

The function uses `get_process_delta_time()` to advance internal state:
- Line 100: `_t += dt` (sway timer)
- Line 107: `calm = move_toward(calm, ..., dt / ...)` (emotional state)
- Line 119: `_bp += dt * ...` (breathing phase)
- Line 161: `_still = move_toward(_still, ..., dt / 0.3)` (head stillness)
- Line 162: `_head = _head.lerp(..., clampf(dt * 4.0, 0.0, 1.0))` (head tracking)

These affect the skeleton pose: breathing moves the chest and shoulders, sway moves the hips, head tracking tilts the head. When the delta time varies between runs (due to frame rate variation), the accumulated state differs, causing the bone positions to differ by 0.1-3 mm per frame. Over a punch's 10-30 frames, this accumulates to 1-30 mm of glove position error, which shows up as 0.1-3 m/s of speed variation.

The test's header comment (line 18) already notes this: "feet and the other hand from the footwork and guard life, run to run, even with the guard seeded". The JOIN check was dropped because of this noise. The POP check still measures all bones (including feet and the other hand), so it inherits the same noise.

## The one-line change that would make the test repeatable

**Option 1:** Disable FighterLife during the test by calling `life.set_process(false)` or removing it from the skeleton modifier stack.

**Option 2:** Use a fixed dt in FighterLife during tests by adding a static var:
```gdscript
static var fixed_dt: float = -1.0
...
var dt: float = fixed_dt if fixed_dt >= 0.0 else get_process_delta_time()
```
Then set `FighterLife.fixed_dt = 1.0 / 60.0` at the start of the test.

**Option 3:** Seed FighterLife's RNG (line 68: `_rng.seed = absi(hash(...)) + 17`) and use a fixed dt, so the breathing and sway are deterministic.

Option 1 is simplest and matches the test's existing approach of disabling stage processing (`st.set_process(false)` at line 113).

## Collected S471
Only this page and tools/speedflip1.gd were taken; the four raw outputs (1.16 million lines) stay on branch qwen/speedflip1. The fix that shipped (S470) is `--fixed-fps 60` in tools/run_tests.sh, not either option above.
