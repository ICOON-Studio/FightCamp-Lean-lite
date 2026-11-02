# TASK R76 — CLAUDE — LOOK AT THE TWELVE FIGHTERS

**Owner:** claude
**Model:** Opus, effort **medium**, Fast **off**.
Reason: this is a judgement pass, not a build. The work is rendering, looking
and writing an honest verdict. **Research session — no build work in it.**

## Why this exists

Twelve fighters were generated, rigged and gated on 2026-09-08/09. Every claim
about them is **measured, never seen**:

- 22 Godot-profile bones each, no BoneMap — proven in-engine
- T-pose bind, arms 0.987-1.000 horizontal — measured off the glTF
- stature 1.578-1.930 m by division, girth 0.942-1.184 — computed
- `walk_relaxed` drives the skeleton — compared bone poses at two times

None of that says whether they LOOK right. Numbers cannot tell you whether a
face is acceptable, whether the boxing four read differently from the MMA four,
or whether a 1.18 girth reads as a powerful heavyweight or as a barrel.

A bad fighter costs 5 credits to regenerate now and much more once a scene is
built on it. **Find that out before anyone builds on them.**

## The files

```
Downloads/fighters_tpose/    12 unrigged meshes, f01..f12, ~1 MB each
Downloads/fighters_rigged/   12 rigged, ~1.5-1.7 MB each  <- review THESE
Godot/assets/models/fighters/f01_m_box_welter_rigged.glb   (the one in-repo)
```

Naming is `f<NN>_<sex>_<glove>_<weight>`: `box` boxing gloves, `mma` open-finger,
`bare` bare hands. Two male and two female in each glove group.

## What to produce

1. **A contact sheet.** All twelve rendered the same way — same camera, same
   lighting, same framing, front and 3/4 at minimum. Godot can do this headless:
   load the GLB with `GLTFDocument`, mount it the way
   `Godot/tests/fight_world_mount_test.gd` already does, and save viewport
   captures. Put the images in `previews/fighters/`.
2. **The physique range, seen.** Render ONE fighter at girth 0.94, 1.00 and 1.18
   side by side. This is the single most useful image in the task: it answers
   whether `FighterPhysique.apply_girth` is a shippable effect or a distortion.
   The counter-scaling is verified numerically (head/hands/feet stay 1.0000) but
   nobody has seen what the trunk actually does.
3. **A written verdict per fighter** in `research/R76_FIGHTER_REVIEW.md`:
   keep / regenerate / needs-work, with the reason in one line. Be specific —
   "f07's face is melted" is useful, "looks a bit off" is not.
4. **A regenerate list** with the prompt change each one needs, so the next
   session can run them without re-deriving anything.

## Anchors

- mounting a fighter, scale and the foot offset: `Godot/tests/fight_world_mount_test.gd`
- stature and girth API: `Godot/scripts/FighterPhysique.gd` (`describe`,
  `apply_girth`, `clear_girth`)
- the arena and its camera: `Godot/scenes/FightWorldPreview.tscn`,
  `Godot/scripts/ArenaRig.gd` (`surface_y`, `build`)
- the twelve prompts that produced them: `HANDOFF.md`, 2026-09-08 roster block
- the render bar every surface is held to: R18 profile renders

## What to judge against

The standing rule is that every surface is held to a commercial visual bar and
proposals are enhanced, not built literally. Ask of each fighter:

- would this stand up in a roster screen next to a competitor's product?
- do the four boxing fighters read as boxers and the four MMA as MMA fighters,
  or is the kit generic?
- do the bare-hand four have acceptable hands? They have NO finger bones by
  design (a gloved fighter never needs them) and the prompt asked for fingers
  held together — this is the group most likely to have failed.
- do the six women read as athletes rather than as a body type?

## Owned files

- `Godot/tools/CaptureFighterRoster.gd` - the render tool (the only code this
  task may add to `Godot/`).
- `previews/fighters/` - the renders.
- `research/R76_FIGHTER_REVIEW.md` - the written verdict.

## Gate
No suite run is needed — this task ships images and a document, not code. If
you write a throwaway render script, put it in `Godot/tools/` and parse-gate it:

```
python Godot/tools/check_scripts.py <script>
```

If any code lands in `Godot/` beyond a render tool, that is scope creep: stop,
write it up as a follow-up task instead.

## The trap

Headless Godot renders a black frame if you capture before the render server
has drawn. `--headless` uses a dummy rasterizer that produces NOTHING usable —
you need an actual rendering driver, and on this machine that means running
WITHOUT `--headless` and letting a real window open, or using
`--display-driver headless` with `--rendering-driver opengl3` and accepting it
may not work at all. **Prove you can save one non-black PNG of one fighter
before building the whole contact sheet**, or the task burns a session
producing twelve black squares.
