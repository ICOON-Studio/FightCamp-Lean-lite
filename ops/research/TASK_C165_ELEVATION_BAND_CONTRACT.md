# C165 — THE BLIND CONTRACT TEST FOR ELEVATION-BANDED EXPOSURE

**Owner:** codex (`gpt-5.6-luna`, MEDIUM). Contract test, not animation.
**Tier: parse gate, then your own test, then `--only elevation`. NO SUITE RUN.**

## THIS IS A BLIND TEST AND THAT IS THE WHOLE POINT

**The module does not exist yet. Claude writes it next session, from the same
contract you are reading, without seeing your test.** Do not write the module.

**Your C164 landed clean yesterday and it caught something we got wrong:** the
`--only ball` gate in that task file matched no filename, and you said so
plainly instead of quietly running something else. That is exactly the right
behaviour. **The gate below is `--only elevation` and your test file is named to
match it — check that it actually matches before you trust it.**

## WHERE THE CONTRACT COMES FROM

Read these, in this order. **Nothing else** — not `HANDOFF.md`, not
`CURRENT_STATUS.md`, not any other digest.

- `research/S52_THE_PRESENT_RATIO.md`
- `research/D12_DIFFERENT_HUMANS.md` — especially **HER SELF-OBJECTION**,
  which is the hardest case this contract has to survive.

The short version. We measure whether a body part can be gripped by sweeping
128 approach directions over a whole sphere and counting how many put a hand on
it without entering another capsule. **The neck reads 0.0% on both our rigs, on
Perchance's shipping rig, and on every capsule humanoid we have measured.** An
assertion that is false on every humanoid including one that ships is not
measuring the engine.

The reason is that the sweep counts directions **from below the chest** — and
nobody reaches a neck from underneath. Dola's answer: **band the sweep by
elevation** and measure only over directions that are actually usable.

**And then she attacked her own answer, which is why this contract is shaped the
way it is:**

> *"My elevation-banded answer will fail on the shoulder girdle and clavicle.
> Discarding all directions from below works for the neck because no human
> reaches a neck from underneath the chest. But the clavicle has valid approach
> paths from front, side, AND below — filtering out the lower hemisphere will
> give us 95% exposure on a collarbone that is actually buried under trapezius
> from every usable angle. **The metric will lie, and we will ship it.**"*

**So the band is PER REGION, never global.** A single horizon applied to every
capsule is the failure mode this contract exists to prevent, and the test must
make it impossible to ship one.

## THE CONTRACT — EXACT NAMES, ARGUMENT ORDER AND RETURN SHAPES

The module will be `Godot/scripts/ApproachBand.gd`. Every function `static`.
Pure arithmetic over a direction and a band — no rig, no scene, no autoload.

```gdscript
static func elevation_deg(direction: Vector3) -> float
```
The direction's elevation above horizontal, in degrees, in `-90.0 .. +90.0`.
Godot is Y-up, so this is `rad_to_deg(atan2(dir.y, Vector2(dir.x, dir.z).length()))`.
**`Vector3.UP` is `+90.0`, `Vector3.DOWN` is `-90.0`, any horizontal direction is
`0.0`.** A zero vector returns `0.0` — never `NAN`.

```gdscript
static func in_band(direction: Vector3, min_elev_deg: float, max_elev_deg: float) -> bool
```
`true` when the direction's elevation is within `[min, max]`, **inclusive at both
ends**. **If `min > max` it returns `false` for everything** — an inverted band
admits nothing; it does not silently swap the arguments. A band of
`(-90.0, 90.0)` admits every direction, which is the unbanded control.

```gdscript
static func band_for(region: String) -> Dictionary
```
Returns `{"min_deg": float, "max_deg": float, "source": String}` for a named
region. **`source` is `"measured"` or `"estimate"`** and nothing else — a band
nobody measured must say so, because a number presented as measured when it was
chosen has cost this project four retracted findings.

The regions, and these are the contract:

| region | min_deg | max_deg | source | why |
|---|---|---|---|---|
| `"neck"` | `0.0` | `90.0` | `"estimate"` | reached from above and from the side, never from below |
| `"clavicle"` | `-90.0` | `90.0` | `"estimate"` | **valid approaches from front, side AND below — Dola's own counter-case** |
| `"thorax"` | `-30.0` | `90.0` | `"estimate"` | |
| `"pelvis"` | `-90.0` | `60.0` | `"estimate"` | |
| **anything else** | `-90.0` | `90.0` | `"default"` | the unbanded sweep, unchanged |

**An unknown region MUST return the full sphere with `source == "default"`.**
Not an empty dictionary, not a push_error, not the neck's band. A region nobody
has thought about must behave exactly as the code did before this module
existed — that is the only safe default, and it is the single most important
row in this file.

```gdscript
static func banded_fraction(usable: int, valid: int) -> float
```
`usable / valid * 100.0`, clamped `0.0 .. 100.0`. **`valid <= 0` returns `0.0`**
— never a division by zero, never `INF`. `usable > valid` clamps to `100.0`.

## THE ROWS YOUR TEST MUST CONTAIN

1. **`band_for("clavicle")` is the FULL SPHERE.** If your test lets the clavicle
   be banded to the upper hemisphere, the contract has failed and so has the
   exercise. This is the case Dola named and it is the reason the module is
   per-region.
2. **`band_for("something_nobody_wrote")` is `-90 .. 90` with
   `source == "default"`.**
3. `elevation_deg(Vector3.UP) == 90.0`, `elevation_deg(Vector3.DOWN) == -90.0`,
   `elevation_deg(Vector3(1,0,0)) == 0.0`, `elevation_deg(Vector3.ZERO) == 0.0`.
4. **Both boundaries from both sides** on `in_band` — a direction at exactly
   `min` and exactly `max` is IN.
5. `in_band` with `min > max` is `false` for `Vector3.UP`, `Vector3.DOWN` and a
   horizontal direction alike.
6. **A grid**: sweep elevations from `-90` to `+90` in steps and assert
   `in_band(d, lo, hi)` agrees with `elevation_deg(d) >= lo and <= hi` on every
   sample. A grid is what made your C163 trustworthy; build one here too.
7. `banded_fraction(0, 0) == 0.0`, `banded_fraction(5, 0) == 0.0`,
   `banded_fraction(10, 5) == 100.0`, `banded_fraction(1, 4) == 25.0`.

## Owned files

- `Godot/tests/elevation_band_contract_test.gd`
- `research/C165_DIGEST.md`

**You own NOTHING else. Do not create `ApproachBand.gd`**, not even as a stub.

## What to do when the module is missing

`load("res://scripts/ApproachBand.gd")` returns `null` today. **Skip green and
say so loudly** — print a line naming the module as absent and exit 0 with
`SUITE total=0 fails=0`. You have handled this correctly twice; do it again.

## Gate

```
python Godot/tools/check_scripts.py Godot/tests/elevation_band_contract_test.gd
python Godot/tools/run_tests.py --only elevation
```

`--only` does NOT stack. **Confirm the filter actually matched your file** —
read `total=`. If it reads `total=0`, the filter is wrong, not the test; say so.
**Do not run the full suite.**

## Rules

- **DO NOT fetch and DO NOT rebase** — the checkout is current.
- Never `git stash`, `git reset --hard`, `git checkout .`, `git clean` or
  `git add -A`. Stage explicit paths only.
- Commit, push to master, write the digest, send one line with
  `python Tools/agent_comms.py send`. **Do NOT edit `HANDOFF.md`.**

## THE TRAP SPECIFIC TO THIS TASK

**Godot is Y-UP and `Vector3.FORWARD` is `-Z`.** An elevation written against a
Z-up convention passes every symmetric test and is wrong by 90° on every real
direction. **Assert `Vector3.UP` explicitly** rather than only testing that
opposite directions give opposite elevations — that symmetry holds in the wrong
convention too.

## And then argue against the contract

End the digest with the strongest case this is WRONG. The obvious line of
attack: **four hand-picked regions with `"estimate"` sources is a lookup table
pretending to be geometry**, and the fifth region anybody adds will not be in
it. Grok raised exactly that objection against its own anchor design this
afternoon, unprompted. **Say whether the `"default"` row saves the design or
merely hides the problem.**
