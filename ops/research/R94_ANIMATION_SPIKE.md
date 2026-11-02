# R94 — THE ANIMATION SPIKE: CAN WE GET A FIGHT'S WORTH OF CLIPS, AND AT WHAT COST

Claude, 2026-09-10. Commissioned as a NUMBER, not a plan: the 3D estimate swings
from days to months on this answer, and nothing about the 3D stage was to be
designed before it came back.

## The answer

**Days, not months — for striking. Not at all, yet, for grappling.**

| Question | Answer |
|---|---|
| Cost of one fight clip | **0.2 Ludo credits** |
| Clips in the preset library | **641**, of which **Combat is 97** |
| Whole library, if we ever wanted it | **128.2 credits** |
| A striking fight's worth (~85 clips) | **~17 credits** |
| What our 4 remaining credits buy | **20 clips** — already a watchable exchange |
| Cost per FIGHTER | **zero.** One clip serves all twelve. |
| Retargeting work in Godot | a **path rewrite, ~10 lines, done once** |
| BoneMap needed | **none** |
| Grappling clips available | **one** ("Grab & Throw"), and it is not enough |

## What was actually done

One clip, `Combo (Jab-Cross-Hook)`, was applied through Ludo's **Rig & Animate →
Animate → From Preset** panel and pulled down, then played on our own fighters in
our own scene. Every number below is measured, not quoted.

### 1. The library

641 presets: Movement 170, Weapons 188, Movement-adjacent Poses 76, **Combat 97**,
Social 52, Interaction 37, Creatures 21. The Combat 97 splits as Unarmed Strikes
30, Hit Reactions 20, Status Effects & Death 17, Special & Power Attacks 15,
Aerial 9, Blocking & Parrying 6.

The Unarmed Strikes 30 is a striking game's shopping list almost verbatim — Punch
(Jab), (Cross), (Left Hook), (Right Hook), Uppercut, Kick (Front Snap /
Roundhouse / Side / Axe / Spinning / Flying / Leg Sweep), Elbow Strike, Knee
Strike, Headbutt, Combo (Jab-Cross-Hook), Grab & Throw. Blocking & Parrying adds
Block (Start & Hold), Block (Hold Loop), Parry, Guard Break, Riposte, Counter
Stance. Hit Reactions 20 covers head, chest, stomach, both shoulders, from four
directions, plus Flinch, Stagger, Knockdown and Knockback.

**This is not AI generation.** These are ready-made motion clips retargeted onto
a rig, which is why they cost 0.2 rather than a model call, and why the result is
deterministic.

**One caveat on the price, stated rather than smoothed over.** `0.2` is what the
panel itself declares (`This action will consume 0.2 credits`) and the counter
briefly rendered `-0.2` on submit. The account badge, however, still read **4**
after the generation and after a full reload — it displays whole credits, so a
3.8 balance and an uncharged first application look identical from outside.
**The estimate below is built on the stated price**, which is the number a
purchase decision should use; if the badge still reads 4 after the next few
clips, the real price is lower than this document assumes, not higher.

### 2. The price, and a false economy corrected

The panel states `This action will consume 0.2 credits` and the generation
returned **three** result entries. They are **byte-identical** — one file,
`md5 52f701939db5be19c12e6977553308b2`, shown three times. So 0.2 credits buys
**one** clip, not three, and anybody costing this at "3 for 0.2" would be out by
a factor of three.

### 3. What comes back

Gzipped glTF, `27,893` bytes on the wire, `58,676` raw. R77's note holds: gunzip
it and it is a plain `.glb`.

    meshes 0   images 0   materials 0   skins 0
    nodes  23
    animation combo_jab_cross_hook   channels 44   duration 2.47 s

**Mesh-free and texture-free.** That single fact is what makes the cost per
fighter zero: the clip is a pure skeletal animation on the 23-node hierarchy
that every one of our twelve fighters already carries, so it is bought once and
played on all of them. A clip that shipped a mesh would have cost 0.2 × clips ×
12.

### 4. The bone names already agree

The clip's 22 animated bones are exactly Godot's `SkeletonProfileHumanoid`:

    Hips Spine Chest UpperChest Neck Head
    Left/RightShoulder  Left/RightUpperArm  Left/RightLowerArm  Left/RightHand
    Left/RightUpperLeg  Left/RightLowerLeg  Left/RightFoot      Left/RightToes

They agree because both the fighters (R77/R78) and the clip were produced with
Ludo's **Joint naming: Godot (humanoid profile)**. The only node that differs is
the mesh root, which the clip does not have. **No BoneMap, no reorientation, no
rest-pose correction.**

### 5. The one real integration cost

The clip has **no skin**, so Godot imports its bone hierarchy as plain `Node3D`s
and its tracks address them by node path — `Hips/RightUpperLeg`. The fighter HAS
a skin, so its bones live in a `Skeleton3D` and a track must read
`Skeleton3D:RightUpperLeg`. First attempt played and moved **0 of 22 bones**,
with Godot logging `couldn't resolve track` for every one.

The fix is a **rename, not a retarget**: rewrite each track path to
`<skeleton>:<last path segment>`. Ten lines. Done once, in the loader, for every
clip we ever buy. It is in `Godot/tools/probe_anim.gd` and again in the test.

### 6. It plays, on all twelve

`Godot/tools/probe_anim.gd` grafts the clip onto a fighter and measures the
skeleton. Run across the whole roster:

    f01 .. f12   tracks matched 23/23,  unmatched 0,  bones moved 22/22,  PASS

The loudest bones on f01 are the ones a combination should move:

    RightLowerArm 107.9 deg    LeftUpperArm 104.9 deg
    LeftLowerArm  104.7 deg    RightUpperArm 100.0 deg    RightUpperLeg 71.7 deg

and the rear hand travels **0.747 m** of forward reach. That is a cross, not a
sway.

### 7. And it plays in `FightWorldPreview.tscn`

`Godot/tests/fight_world_anim_test.gd` — **TOTAL=23 fails=0** — takes the same
sanctioned chain the mount test uses (`ArenaSurface.for_discipline` →
`arena_specs.json` → `ArenaRig.build`/`surface_y`), stands f01 on the boxing
canvas at **1.27 m** at his own division's stature, grafts the clip and throws
it. Two assertions there earn their place beyond the obvious:

- **`walk_relaxed` survives the graft.** Both clips are on the fighter
  afterwards; adding to the shared default library does not cost us what was
  already there.
- **He is still on the canvas at the end** (feet 1.2700, canvas 1.2700). Ludo's
  `In place: Auto` did the right thing on this clip and did not walk him off his
  mark — which matters because the engine positions the fighters, not root
  motion.

## Findings, reported and NOT designed away

**1. THE LIBRARY CANNOT SHOW OUR GRAPPLE MODEL. This is the big one.** R91, R92
and R93 gave the engine takedowns, seats (guard, half, side, mount, back), the
clinch, control, submissions, osaekomi and a judo board. The Combat category
offers exactly **one** grappling clip, `Grab & Throw`, and nothing else — no
takedown entry, no guard, no pass, no mount, no sweep, no submission, no ground
position at all. `Movement: Crouching & Crawling` has prone and crawl loops and
they are not a guard. So a striking bout is one purchase away from watchable and
a grappling bout is not purchasable here at any price. **Do not plan a 3D stage
that shows the ground game off this library.**

**2. Clip timing has not been reconciled with engine timing.** 2.47 s for three
punches is ~0.82 s each. The real-time core runs at 20 Hz and emits impacts far
faster than that. Whether clips get played, cut, or blended against the impact
stream is an open question and it is the next thing to settle — it decides
whether we buy whole combinations or individual strikes.

**3. Nobody has LOOKED at the clip.** Everything above is arithmetic off a
skeleton: 107.9 degrees of forearm swing proves motion, not quality. The `.mp4`
previews Ludo generates alongside each result are the cheap way to judge that and
were not reviewed here.

**4. `In place: Auto` is proven for ONE clip.** It held for a stationary
combination. It is not proven for anything with intended travel, and the
locomotion clips are where it will be tested.

## The zero-cost question, which is now assigned rather than guessed

The operator asked mid-spike whether this can be done without paying Ludo, and
whether general-purpose ML APIs could stand in. The honest partial answer:

- **Image and audio APIs are the wrong tool.** Stable Diffusion makes pictures
  and ElevenLabs makes speech; neither produces skeletal animation. The category
  that does is text-to-motion research (MDM, MoMask, T2M-GPT and successors),
  which emits SMPL-format motion needing its own retarget, and whose combat
  motion quality is not close to curated clips.
- **The fighters are NOT locked to Ludo.** Section 4 is the reason: our rigs are
  plain `SkeletonProfileHumanoid`, so ANY humanoid clip source can drive them.
  The lock-in cost of switching sources is the same ten-line path rewrite.
- **The obvious free candidate is a curated humanoid mocap library** rather than
  a model API — that is what Ludo's presets are, and free equivalents exist. It
  has NOT been verified here and must not be assumed: licence terms for
  commercial game use, whether a boxing/MMA set of comparable coverage exists,
  and whether the grappling gap in finding 1 is also present there.

**C75 (Codex) is assigned to answer it with sources.** At 0.2 credits a clip the
paid path is cheap enough that this is an optimisation, not a blocker — but the
grappling gap means we may have to source elsewhere regardless, which makes the
study worth doing now rather than after we have spent.

## Reproduce it

```
Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tests/fight_world_anim_test.gd
```

and, for any fighter/clip pair on disk:

```
Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tools/probe_anim.gd -- <fighter.glb> <clip.glb>
```
