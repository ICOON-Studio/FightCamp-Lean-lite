# Q138 DIGEST — span sensitivity sweep

## What was built

`Godot/tools/q138_span_sensitivity.gd` — headless SceneTree script. For every
capsule on every rig, sweeps L from measured to 3x in 1 mm steps, holding r
fixed, and finds the smallest L where r/L < 0.50 (band exits NEEDLE → STOUT).

## Key findings

### Neck: span fix alone does NOT save it

- All 12 rigs exit at exactly **111 mm** (the neck r is nearly constant across
  rigs at ~27.75 mm, from ANSUR neck circumference 397.65 mm / 2π / height
  scale).
- J42 ANSUR Neck Link = **107.8 mm**. The exit is **3.2 mm ABOVE** the real
  neck on every rig.
- **A correct span leaves the neck a NEEDLE.** You would need a neck longer
  than a human's to clear it.
- Median ratio L_exit/L_measured = **1.90x** (range 1.32x–2.47x depending on
  how short the measured span is).

### Pelvis: anatomically implausible

- Median exit at **349.5 mm**, **1.66x** the measured 214.5 mm.
- The pelvis is a structural ring, not a link. Adding 135 mm of span to a
  215 mm pelvis is not anatomically defensible.

### Head: 3 of 12 never exit within 3x

- Median exit at **257 mm**, **2.32x** the measured 110.5 mm.
- f04, f07, f08 (small female heads) have r > L so badly that even 3x L does
  not reach the exit. Head as capsule is BALL — the exit is at L = 2r, which
  is a sphere-on-a-stick, not a head.

### Thorax: mostly already fine

- Median exit at **278 mm** = **1.00x** measured. Most rigs are already STOUT
  at their measured span. A few (f06, f07, f08, f10) need a small bump
  (1.10x–1.20x) to clear.

### Limbs: all 1.00x — already STOUT or better

- Every limb from upper_arm outward exits at measured L. No span issue.

## Verdict

**A span correction is NOT worth doing on its own terms.** The neck — the
capsule that matters most for grapple contact — cannot be saved by span alone:
the exit (111 mm) exceeds the real ANSUR neck (107.8 mm). The pelvis needs
1.66x its span, which is implausible. The trunk is not capsule-shaped, and no
span correction fixes that.

## Note

`research/CLAUDE_LAND_NOTE_J42.md` was not found on disk. The 107.8 mm
Neck Link value was taken from the task file as fallback.

## Owned files

- `Godot/tools/q138_span_sensitivity.gd`
- `research/Q138_SPAN_SENSITIVITY.md`
- `research/Q138_DIGEST.md`

## Suite

SUITE total=1 fails=0
