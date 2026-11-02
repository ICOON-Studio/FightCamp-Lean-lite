# TASK GYMCLIPS2 (John, research) - a source for two gym workout clips: stationary bike and agility ladder

Model: John (deep research). Discipline: BOXING gym floor (demo). Research only, no code.

## Why
In FightCamp (a boxing-gym management game, Godot 4, isometric camera), gym members walk to the equipment the player built and work it
on a looping workout animation. Two pieces have NO clip, so nobody uses them: the **stationary exercise bike** (seated pedalling) and
the **agility ladder** (quick footwork drills along a floor ladder: in-in-out-out, lateral shuffles, high knees). The other pieces
use Mixamo clips retargeted to our humanoid rig. Mixamo has no bike-pedalling or ladder clip (checked S233: "Bicycle_Crunch" is floor work).

## What would a human do?
A game animator would look for an existing loop first (a marketplace pack, a free mocap library, a text-to-motion tool), check the
licence for a commercial Steam game, and only then plan a capture or a hand-keyed loop.

## Prior research
research/GYMLIFE_CLIPS_S233.md (missing-clip list), research/topics/clips_sources.md (owned packs, Mixamo, CMU, Rokoko
free library approved S270, ActionForge in use, Cascadeur until 2026-10-27; Meshy REJECTED S272, MPFB/generator bodies banned).

## Prefab check (this IS the task)
For EACH of the two motions, list up to 6 concrete sources, best first:
- name + direct URL of the clip/pack page
- format (FBX/BVH/GLB), skeleton (Mixamo / UE Manny / custom), frame rate, loop yes/no, length in seconds
- price and the exact licence words on commercial game use (quote under 15 words + link); flag anything unclear
- for the bike: does the clip include a seated pelvis height / hands on handlebars we can align to a bike seat at ~0.75 m?
- for the ladder: does the motion travel forward (root motion) or stay in place, and how many metres per loop?
Include free mocap libraries (CMU, Rokoko free motion library, Bandai Namco research set, Mixamo-alikes), Unity/Unreal/Fab
marketplace packs (fitness / gym / sports packs), and text-to-motion tools with commercial terms. Rank the top pick for each motion
and say why. Plain text answer, as long and complete as you can.
