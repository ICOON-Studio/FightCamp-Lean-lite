# TASK Q2 — QWEN — THE NAMED INJURY (PURE MODULE)

Model: Qwen3.8-Max, effort **high**. One session.

**You have no repository and you do not need one.** This file is complete: every
rule, every list and every number you need is written below. Do not ask for a
file, do not guess at one, and do not reference any path except the two you
write. Build and test in a throwaway Godot 4.7 project holding only your two
files. Claude splices them into the real repo, runs the real suite and writes
your `HANDOFF.md` block.

Deliver exactly two files and nothing else:

- `Injury.gd`
- `injury_test.gd`

## Why this exists

FightCamp tracks a fighter's body as **six regions**, each carrying a 0-100
readiness number:

```
head_neck, torso_core, left_arm, right_arm, left_leg, right_leg
```

That number is the *training-load* object — soreness from sparring, camp and
rest. It is the only object the game has. So a torn knee ligament, a broken
hand and a bruised thigh are all "a lower number", and the game cannot tell
them apart.

A research pass (J13, landed 2026-09-08) ruled that this is the bug, and that a
region must carry **a number and, when tissue is actually injured, a named
injury that owns the timeline**. You are building that named injury as a pure
module. The integration into the save is not yours.

## The shape (J13 DA1 / A7) — the hierarchy you must encode

1. A region **always** has a 0-100 readiness number. A fighter can be sore
   with **no named injury**.
2. When a named injury exists on a region, **the injury owns the timeline**.
   It carries `train_week`, `compete_week`, and whether it sets a medical hold.
3. The number never substitutes for the name. A 35 that is a fracture and a 35
   that is a bruise are different objects.
4. **At most one primary named injury per region at a time.** A second hit on
   an already-injured region is a **severity / re-injury** event, never a stack.
5. **Head is special.** `concussion_rhi`, `laceration` and `ocular_orbital` can
   co-exist in reality. If only one can be held, **`concussion_rhi` outranks**
   for the hold clock; the other is a modifier taking the **max** of the two
   ladders. Never drop the concussion because the cut displays better.

## The eight types — this list is closed

| `type_id` | what it is | regions it lives on | families that present it |
|---|---|---|---|
| `contusion` | bruise / haematoma | any | all; dominant in kick-sports |
| `laceration` | cut, usually periocular or scalp | `head_neck` | striking, mma |
| `concussion_rhi` | SRC / KO / TKO-from-head | `head_neck` only | striking, mma; grappling via throws |
| `fracture` | metacarpal, nasal, orbital, rib, tibia | arms, `head_neck`, legs, `torso_core` | striking (hands, face), kick (lower leg) |
| `muscle_strain` | grade 1-3 muscle or tendon | legs, `torso_core`, arms | all |
| `ligament_joint` | sprain, MCL/ACL/LCL, AC, scapholunate | legs, arms | grappling, kick |
| `dislocation` | glenohumeral, elbow, finger, patella | arms, legs | grappling |
| `ocular_orbital` | hyphema, retinal injury, orbital blowout | `head_neck` | striking, mma |

Do **not** add types. Cauliflower ear, dental, skin infection, "stinger" and
CTE are explicitly **not** first-class injuries.

## Discipline families (J13 DA12) — the draw is keyed, never global

Four families: `striking`, `grappling`, `kick`, `mma`.

```
boxing        -> striking      judo      -> grappling
kickboxing    -> kick          bjj       -> grappling
muay_thai     -> kick          wrestling -> grappling
karate        -> striking      mma       -> mma
taekwondo     -> kick
```

Disciplines with **no research table of their own** inherit a nearest parent
and must be reported as inherited, never as sourced:

```
sambo -> grappling      sanda -> kick       savate -> kick
silat -> kick           arnis -> kick       capoeira -> kick
```

An unknown discipline returns `""` and no draw — never a default table.

## Every number carries a grade

This is the part that matters most, and the part most likely to be got wrong.
J13 found that **almost none** of the weeks are sourced for combat athletes.
So every numeric answer your module returns is a dictionary carrying its own
provenance:

```gdscript
{"weeks": 4, "grade": "AUTHORED", "source": ""}
```

`grade` is exactly one of:

- `"DIRECT"` — a real published rule. You may use only these three, verbatim:
  - `fracture` of the face: **28 days minimum licence** (BBBoC facial rule).
  - `concussion_rhi`: train-date and compete-date **match** (ARP no-sparring
    window equals the hold).
  - `laceration`: hold typically **14-60 days**.
- `"AUTHORED"` — you invented a plausible game number. Most of them.
- `"UNKNOWN"` — no defensible number exists. Return `weeks: 0` with this grade
  rather than a guess.

A number labelled `DIRECT` that is not one of the three above is a failed task.
Inventing a citation is worse than returning `UNKNOWN`.

## The API

Statics only. No `class_name`. No `preload`. No node access, no RNG, no file
access, no `GameState`, no `BodyReadiness`.

```gdscript
extends RefCounted

const TYPE_IDS: Array          # the eight, in the table's order
const REGIONS: Array           # the six
const FAMILIES: Array          # striking, grappling, kick, mma

static func family_for(discipline: String) -> String
static func inherited_family(discipline: String) -> bool
static func types_for_region(region: String) -> Array
static func types_for_family(family: String) -> Array
static func type_info(type_id: String) -> Dictionary

## The named injury itself. severity is 1..3 (1 minor, 3 severe).
## Returns {} for an unknown type_id or a type that cannot live on that region.
static func build(type_id: String, region: String, severity: int, onset_week: int) -> Dictionary

## Timelines. Each returns {"weeks": int, "grade": String, "source": String}.
static func train_weeks(type_id: String, severity: int) -> Dictionary
static func compete_weeks(type_id: String, severity: int) -> Dictionary

## True when this type sets the ONE medical hold. contusion and muscle_strain
## never do. Returns the hold in weeks, graded, or weeks 0 when it sets none.
static func hold_weeks(type_id: String, severity: int) -> Dictionary

## The head rule. True when `a` outranks `b` for the hold clock.
static func outranks(a_type: String, b_type: String) -> bool

## At most one primary per region. Given the injury already on the region and
## a new one, return the injury the region should now carry: the higher-ranked
## type, with the MAX of the two hold ladders, and a re_injury flag when the
## incoming type equals the existing one.
static func resolve_on_region(existing: Dictionary, incoming: Dictionary) -> Dictionary
```

`build()` returns, at minimum:

```gdscript
{
  "type_id": "fracture", "region": "left_arm", "severity": 2,
  "onset_week": 41,
  "train_week": 45, "compete_week": 49,       # onset + the graded weeks
  "hold_until_week": 49,                       # 0 when this type sets no hold
  "sets_hold": true,
  "treatment_path": "conservative",            # or "surgical" where the type allows a choice
  "clearance_flags": ["physician"],            # see below
  "re_injury": false,
  "grades": {"train": "AUTHORED", "compete": "DIRECT", "hold": "DIRECT"},
}
```

`clearance_flags` is a subset of `["physician", "specialist", "ophthalmologist"]`.
`ocular_orbital` always includes `ophthalmologist`. `concussion_rhi` and
`fracture` include `specialist`. `contusion` needs none.

`compete_week` is **never earlier** than `train_week`. Return-to-training and
return-to-competition are different dates; only `concussion_rhi` may set them
equal, and only because the source says so.

## Refusals — each of these is a failed task

- **No age anywhere.** No age parameter, no age multiplier, no age-lengthened
  hold, no 30/33 kink. Healing is age-blind. If you find yourself wanting the
  fighter's age, you have misread the spec.
- **No second clock.** There is exactly one medical hold. You return weeks for
  it; you never invent a parallel "tissue clock".
- **No invented citations.** Three `DIRECT` numbers exist and they are listed
  above. Everything else is `AUTHORED` or `UNKNOWN`.
- **No draw weights.** The probability of each injury type is explicitly
  UNKNOWN in the research. Do not add a random draw, a percentage table or an
  RNG. `types_for_family()` returns *which types are possible*, never odds.
- **No gruesome detail.** No ICD-10 codes, no anatomy beyond the type name, no
  surgical description. This is a management game.
- **No `chin` stat, no durability stat.** Ruled out twice.
- **No `preload`, no autoload, no `class_name`.** The module must load and run
  in an empty project containing only your two files.

## The test

`injury_test.gd` follows the house pattern exactly — `extends SceneTree`, a
`load()` of the module by path, `_check(condition, message)` printing `OK:` or
`FAIL:`, and a final line plus `quit()`:

```gdscript
extends SceneTree
## Q2: Injury, pure. No career, save, GameState or BodyReadiness.

var failures := 0


func _initialize() -> void:
	var Inj = load("res://scripts/Injury.gd")
	_check(Inj.family_for("bjj") == "grappling", "bjj is grappling")
	# ... your cases ...
	print("Q2 injury: %d failure(s)" % failures)
	quit(1 if failures > 0 else 0)


func _check(condition: bool, message: String) -> void:
	if condition:
		print("OK: ", message)
	else:
		print("FAIL: ", message)
		failures += 1
```

Cover at least: every discipline maps to a family and the inherited ones are
flagged; an unknown discipline returns `""`; `build()` refuses a type on a
region it cannot live on (`concussion_rhi` on `left_leg` returns `{}`);
`compete_week >= train_week` for all eight types at all three severities;
`contusion` and `muscle_strain` set no hold; `concussion_rhi` outranks
`laceration`; `resolve_on_region` takes the max hold and flags a re-injury when
the types match; and every returned number carries a `grade` from the three
allowed values, with `DIRECT` used only where this file permits it.

## GDScript, as this project's parser actually behaves

Godot **4.7**, tabs for indentation. These three cost a fix cycle every stage
here, and two of them will bite this task specifically:

- **`:=` fails on a Variant.** `var n := some_dict.get("weeks", 0)` is a parse
  error, because `.get()` on an untyped value returns Variant — and so does
  every static you call through a `load()`ed script, which is exactly how the
  test reaches your module. Write the type: `var n: int = ...`,
  `var info: Dictionary = Inj.type_info(...)`. This will hit your test on the
  first line that reads a returned dictionary.
- **A name may be declared once per function.** Reusing `var weeks` in two
  separate `if` or `for` blocks inside the same function is a parse error, not
  a shadow. Your `_initialize()` will hold many cases in one function — give
  each its own name (`hold_fracture`, `hold_cut`) or the file will not parse.
- **`%` in a format string must be `%%`.** `"%d%% clear"`, never `"%d% clear"`.

Nothing here needs a `class_name`, and a `class_name` would collide on splice.
`extends RefCounted` at the top of the module, `extends SceneTree` in the test.

## The one trap

The temptation is to make this module *decide* things — to roll a random
injury, to scale healing by age, to publish a weeks table that looks
authoritative. All three are explicitly forbidden by the research it comes
from, and the third is the subtle one: a number labelled `DIRECT` that nobody
published is worse than no number at all, because a later screen will print it
as a fact. When you are unsure, `UNKNOWN` with `weeks: 0` is the correct,
expected answer, and the test should assert exactly that for the cases where no
source exists.

## Owned files

<!-- Backfilled 2026-09-08. This file predates the owned-files gate, so `done --task` found nothing to check and passed vacuously. Every path below comes from this task file's own parse-gate command, test command, build sections and shipped deliverables - none was invented. -->

```
Godot/scripts/Injury.gd
Godot/tests/injury_test.gd
```
