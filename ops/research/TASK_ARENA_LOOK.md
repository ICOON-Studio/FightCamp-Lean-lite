# ART-DIRECT THE ARENA: WHAT SHOULD IT LOOK LIKE AT ALL?

**LONG-RUNNING TASK - it does not finish in one pass.** Operator ruling
2026-09-22: *"agents need to work 24/7 when they are green on opsboard give
long term tasks and keep checking on them on every new session how the
progress and improve the product."* Claude re-cuts this brief each session
from what actually landed - it is never restarted from scratch.

**EVERY PASS ENDS WITH AN ARTEFACT THE OPERATOR CAN JUDGE, and with a line
saying WHAT IS STILL WRONG.** A pass reporting everything fixed is the one
checked hardest.

**Owner:** maria, Art Director. Direction and specification - **no geometry,
no code, no copy.** Stage to `_maria_delivery/`.

## The problem

The 3D room is dimensionally correct and visually nothing. Flat-coloured boxes
and cylinders, one key light and one fill, a grey void beyond the cage. The
operator's verdict on what they can see is *"i dont want to see those grey
artifacts again"*.

Kalli is drawing TEXTURES under `TASK_TEXTURES.md` and Cursor is building the
arena under `TASK_ARENA_ART.md`. **Neither has a look to build toward.** That
is what this is.

## What to decide, and defend

1. **What KIND of venue is this?** A televised arena, a regional show in a
   hall, a gym. They light differently, they are dressed differently, and the
   choice changes every other answer. Pick one and say why it suits a career
   game where the SAME fighter appears at every level.
2. **Does the venue change as a career progresses?** If it does, name the
   two or three rungs and what visibly differs. If it does not, say so - that
   is a cheaper game and a defensible choice.
3. **The light.** One key and one fill is a product shot. Real cage lighting is
   overhead and hard, and it is most of what makes a fighter read as a solid
   body. Specify direction, hardness, colour temperature and what the mat does
   with it.
4. **What is beyond the fence, and how much of it is visible?** The camera
   orbits freely now, so the answer cannot be "nothing" any more.
5. **The palette**, given two fighters must stay legible against it at all
   times. The mat is the biggest surface in frame and currently the brightest.

## Rules

- **Zero purchased assets** without the operator's word. Assume procedural
  materials and Kalli's drawn textures.
- **It must not compete with the fighters.** They are the subject; everything
  here is setting.
- Work to the real dimensions in `Godot/assets/data/arena_specs.json` - a
  UFC 30 ft cage is 9.144 m across, 8 sides, fence 1.8288 m.
- **Name what you would NOT do**, and why. That is usually the useful half.
