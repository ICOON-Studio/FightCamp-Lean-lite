# R103 DIGEST — THE BEAT PLAYS A CLIP, AND IT PLAYS THE RIGHT ONE

**The stage's finding is a defect that was live in the tree, invisible to a green
suite, and worth more than the seam it was found building.**

## THE HEADLINE

Over three seeded boxing bouts — **148 action beats** — the presenter played
**a clip the fight never threw 85 times, 57.4% of action beats.** Every one of
those 85 was the jab.

```
boxing_double_jab    -> jab   24
boxing_lead_hook     -> jab   18   (and hook_lead, its OWN clip, was grafted)
boxing_lead_uppercut -> jab   14
boxing_overhand      -> jab    9
boxing_rear_uppercut -> jab    9
boxing_cross         -> jab    6   (and cross, its OWN clip, was grafted)
boxing_slip_counter  -> jab    5
```

**After R103: substitutions = 0 of 148.** 53 beats (35.8%) play the clip the
engine actually named, over three distinct clips — `jab`, `cross`, `hook_lead` —
and the other 95 (64.2%) take M19's honest degrade.

## WHY A GREEN SUITE NEVER SAW IT

U43 did the hard half correctly. It put the honest decision **on the beat**:
`clip_role`, `has_clip`, `clip_missing`, `fallback_thrower`, `fallback_receiver`,
with an alias table that deliberately refuses to alias an overhand onto a jab.
Its digest says, correctly, *"Never substitutes a neighbour's clip."*

**Nothing read any of it.** `FightStagePlayer.present_beat` derived the thrower's
role from the REGION — so every head strike became the category `strike_head` —
and then `_prefer_typed_strike` resolved that category to **the first grafted
typed punch**, which is `jab`.

And here is the part to carry forward: **the report said `strike_head` while the
AnimationPlayer held `jab`.** `played` carried the category, so
`fight_stage_playback_test`'s `strike_head_played >= 1` was true, `skipped` was
non-zero, determinism held, and six assertions agreed with each other about a
vocabulary while the actual animation was wrong. **Two parallel vocabularies — a
category and a clip — and only one of them was ever asserted.**

## THE FIX

`FightStagePlayer._thrower_clip(beat, director_role)`:

- `has_clip` → play **exactly** `beat["clip_role"]`.
- `clip_missing` → play **nothing**, and say so (`thrower_idle = true`).
- no `technique` at all → the category role is permitted. Nothing was named, so
  nothing is contradicted. This is the one honest use of `strike_head`.

`_prefer_typed_strike` is **deleted**. `present_beat` now also returns
`actor_clip` / `target_clip` — *what actually started on the AnimationPlayer* —
which is the quantity a test can pin. `actor_role` / `target_role` still carry the
categories for the tally and the camera, unchanged.

**The RECEIVER was left alone, deliberately.** A region-matched reaction is M19's
own sanctioned answer and claims nothing about a technique, so
`FightStageDirector.role_for_react` keeps deciding it — contact word first,
region second, which is the G42 guarantee that an unrecognised contact can never
reach the region table.

`FightStageDirector` was NOT changed. Its `strike_head` is a purchase-list
CATEGORY, and "he threw a head strike" was always true. The lie was only ever in
resolving that category to a concrete clip.

## THE FOUR GAPS — AND TWO OF THEM WERE ALREADY SHUT

The task file listed four. **U38 had already closed gaps 1 and 4** and the task
file was written from M19/R94 state, before it landed:

- **GAP 1, nobody stands at SpawnB — ALREADY DONE.** `FightWorldStage.mount` /
  `face_each_other` + `fight_world_pair_test.gd`. There has been a receiver since
  U38. (Its `face_each_other` carries a good scar: a headless tree never draws a
  frame, so `global_position` stays at the origin, `atan2(0,0)` returned 0 and the
  yaw silently never applied. It uses LOCAL positions for that reason.)
- **GAP 4, no route — ALREADY DONE.** `SceneRouter` `fight_world_preview`, dev
  tier, no rail.
- **GAP 2, the wrong unit — SOLVED, AND NOW ACTUALLY REACHED.** U40 sliced three
  windows off the 2.47 s combo on measured retractions, U41 mirrored them to six,
  and `FightStagePlayer.bind` already slices and mirrors at graft time. But the
  only path that *used* a typed punch was `_prefer_typed_strike`, i.e. the defect.
  **The sliced windows are now reached by NAME**, which is what U40 and U41 were
  for. U42's audit stands: the source is `kind=single_hand_drill`, three RIGHT
  hands that never alternate, so **we still do not own a real jab-cross** and the
  six are one hand's three punches plus mirrors.
- **GAP 3 was the stage**, and it is done.

## THE ROOM YOU CAN LOOK AT

`FightWorldLive.tscn` + `FightWorldLiveScreen.gd`, route `fight_world_live` (dev
tier, no rail). It mounts two fighters on the real 1.27 m canvas, drives a seeded
bout through `FightBeatAdapter`, and its readout names the technique and the clip
— or says `NO CLIP for 'boxing_overhand' - guard held, receiver reacts`, which is
the M19 answer made visible instead of buried in a digest.

Measured on seed 94301: **73 beats, 22 named clips played, 43 honest degrades,
DECISION.**

**It INSTANCES `FightWorldPreview.tscn` rather than carrying a script on it.**
That shell is script-free on purpose — four tests instantiate it to mount their
own bodies, and a `_ready` that mounted fighters would fire inside every one of
them.

**THE SCREEN READS THE FIGHT AND NEVER DRIVES IT.** One beat per 1.1 s of wall
clock is a presentation cadence; `advance_beat` consumes the same 280-tick window
it always did and the RNG stream is untouched.

## A GODOT TRAP WORTH THE NOTE

**`_ready` does not fire in a `SceneTree --script` run until the first frame, and
there is no frame.** The first version of `fight_world_live_test` added the scene
and stepped `_process`, and stepped an empty room: `TWO skeletons` came back `0`
while `_ready`'s own print appeared *after* the test report. The fix is an
explicit idempotent `setup()` that `_ready` calls and a test may call itself.
Same family as `face_each_other`'s missing frame and as
`Skeleton3D.get_bone_global_pose()` reporting a motionless hand in
`fight_world_anim_test`.

## WHAT MUST NOT HAVE MOVED, AND DID NOT

- `judge_panel_test` — **0 failures.**
- `fight_realtime_test` — **PASS, 391 checks**, the exact number R102 left.
- `--only stage` 6/0 · `--only clip` 4/0 · `--only beat` 4/0.

No seeded fight moved. The presenter reads.

## GATES ADDED

- **`tests/fight_stage_technique_fidelity_test.gd`** — 25 checks, the policy gate.
  Asserts the invariant a substitution cannot satisfy: **the animation that
  actually started is the one the beat named.** Occurrence floors on all three
  paths (named clip plays ≥ 12, distinct clips ≥ 2, degrade taken ≥ 12), plus the
  synthetic shapes, plus byte-identical replay on the same seeds.
- **`tests/fight_world_live_test.gd`** — 18 checks, the room gate. Route, two
  skeletons, and it steps the screen until a named clip plays AND the degrade
  fires, rather than asserting either could.
- **`tools/measure_r103_substitution.gd`** — the probe that found it. It still
  measures the OLD rule on purpose, labelled as historical, because it is the
  before-picture the fix is judged against.

## FINDINGS LEFT OPEN — AND ONE IS NOW THE BIGGEST IN THE AREA

1. **THE RECEIVER IS THE UNMEASURED HALF OF THE PURCHASE LIST.** The fidelity
   gate printed it: the receiver's region reaction was asked for **143 times**
   across those 148 action beats and **we own zero reaction clips**, so it was
   refused 143 times. M19's whole no-clip answer is *a reaction on the receiver*,
   and Q45 measured only the thrower. **Q46 is assigned for exactly this.**
2. **64.2% of action beats still show a man holding his guard.** That is the
   honest answer, not a placeholder — but it is also the size of the coverage gap,
   and Q45 now says what closes it: **the engine reaches 21 distinct named
   techniques, not M19's 272, and 14 clips cover 90.3% of shown throws pooled.**
   We own three (`jab`, `cross`, `hook_lead`, plus three mirrors).
3. **`boxing_double_jab` is the single biggest uncovered thrower slot** — 24 of
   148 beats, more than any other. It is deliberately NOT aliased onto `jab`: a
   double jab is not a jab, and the alias table refuses same-name-only
   substitutions by design. Whether two jabs is an honest presentation of a
   double jab is a DATA question for the alias table, not an engine one.
4. **Nothing owns an `idle` clip.** `FightClipBinding` binds no idle, so M19's
   "thrower holds his guard" is literally the rest pose today. **Idle is stillness,
   not a T-pose** — the bodies are at rest, not T-posed, so this reads as still
   rather than broken, but an idle/guard loop is the cheapest thing that would
   make the degrade look deliberate rather than frozen.
5. **`uppercut` is listed in the typed-punch order and has no clip**, so both
   boxing uppercuts take the degrade. Nine + fourteen = 23 beats on this fixture.

## THE LESSON TO CARRY

**PERMITTED IS NOT OCCURRED — and this stage adds its sharper form: ASSERTED IS
NOT THE SAME QUANTITY.** R102's three defects were unreachable paths. This one was
a *reached* path, fully covered by six passing assertions, every one of which
tested the category vocabulary while the defect lived in the clip vocabulary. When
a module reports in one vocabulary and acts in another, **assert the one the user
sees.** For an animation, that is the string in `AnimationPlayer.current_animation`
— and `fight_stage_technique_fidelity_test` asserts exactly that.
