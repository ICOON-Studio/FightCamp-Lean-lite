# Higgsfield + scripts + Blender for realistic real-time MMA animation (study, COMPLETE)

Owner: Claude. Started 2026-09-14 night, finished the same night. Every number below was measured on generated clips;
scripts in `Tools/higgsfield/`, clips and videos off-repo in `C:/Users/user/AppData/Local/Temp/FightCamp-higgs`.

Operator, verbatim: "Do your own research : how can achieve realistic mma 3d representation for a video game
using higgsfield, text to 3d scripts , blender to produce smooth animations for the game no cutscenes no videos".
Follow-ups: "Have you mastered the whole workflow yet ?" and "Using different variations of jab can reflect on the
quality of the fighter and make it more realistic while adding more options for mechanics and variety in the fight ?"
Then, during the finish (all verbatim): a pasted four-step workflow ("Spawn two identical, weighted humanoid skeletal
meshes facing each other inside an MMA cage", "Character A shoots for a double-leg takedown. Character B sprawls...",
fix AI clipping by hand, export each move as .glb into a Godot AnimationTree StateMachine, re-inject into Cinema Studio
with Kling 3.0 / Seedance 2.5), "Check the YouTube video you must watch it", "“Bad” clips from higgsfield maybe can
be used to portray I bad execution or fighter low skill, just a thought" and "A sloppy jab can be thrown just to measure
distant the animations need to portray fakes and when a fighter commits to a jab opening".

## Answer in five lines

1. No shipped fighting game gets gameplay motion from prompts: a captured library selected at runtime, two-man moves
   as PAIRED data (EA UFC 2/3). Generation fits as a SOURCE of single-man clips, cleaned and measured.
2. Higgsfield Character Animation animates ONE body per job. The operator's own two-fighter prompts: 8 of 8 one body.
3. Two separate generations composed on one clock by code: 0 of 36 pairings hold a takedown.
4. Prompt words for fighter quality do not carry through (elite v novice not separable; 4 of 12 left-jab prompts threw
   the RIGHT hand). Gross actions do (a body jab dips 14 cm 2/2). Build quality and intent on OUR side.
5. Striking: keep the v1 pair method, with Meshy library and best-of-N text clips as extra sources. Grappling needs paired
   data: generation cannot make it.

## What the industry does (sources read)

- EA UFC 3 "Real Player Motion": a large mocap motion database selected at runtime (motion matching) with
  event/timing constraints for strikes - GDC Vault 1025228 (https://gdcvault.com/play/1025228/Real-Player-Motion-Tech-in);
  PlayStation Blog 2018-01-30.
- EA UFC 2 grappling is PAIRED two-person animation, mostly motion-captured, plus procedural fixes - GDC Vault 1023474;
  Game Anim write-up (https://www.gameanim.com/2017/11/19/ufc-2-procedural-techniques/); GDC Vault 1021794.
  Reported: 3153 two-player animations, 1317 of them mocapped.
- Physics reactions on top of animation (UFC 2009 GDC Vault 1012304; UFC 3 blog).
- Research: physics-simulated two-player boxing/fencing via RL (Won, Gopinath, Hodgins, SIGGRAPH 2021,
  https://dl.acm.org/doi/10.1145/3450626.3459761). Two-person text-to-interaction models are research-grade and trained
  on everyday interactions, not combat: Inter-X (arXiv 2312.16051), InterMamba (2506.03084), Text2Interact (2510.06504),
  InterEdit (2603.13082). Close-contact capture data: Harmony4D (2410.20294, includes MMA/wrestling). Video-to-3D
  motion: GVHMR (https://dl.acm.org/doi/10.1145/3680528.3687565).
- Tooling: Cascadeur AI inbetweening + AutoPhysics; Godot 4 motion-matching plugins (GuilhermeGSousa/godot-motion-matching,
  V-Sekai/motion_matching, Remi123/MotionMatching; proposal godotengine/godot-proposals#6122).

## What Higgsfield gives us (tested on the Plus plan)

1. **Meshy animation library via MCP `generate_3d`** (3d_rigging on our uploaded f01 mesh, ~678 clips, 8 credits a clip).
   U106: a Meshy jab lands inside footage on 29/34 keys v the RamsterZ jab 28/34 - as good a SOURCE, not better.
   Boxing, kicks, dodge/counter, hit reactions; NO paired grappling.
2. **Character Animation = text-to-motion** (job `kimodo` = NVIDIA ARDY `ardy-core`, 20 fps, 27-joint cskel27, shots
   <= 6 s, 0.1 credit). Add-on source `higgsfield_blender-1.5.52/features/motion.py`: "Import one `kimodo` .npz as an
   animated, skinned character", prompt help "Start with 'A person…'", shape check against ONE skeleton. Scriptable
   headless (`Tools/higgsfield/t2m_batch.py`). Best-of-6: jab 4/6 clean, roundhouse 1/6.
3. **Text-to-3D fighter** (`meshy_v6_text_to_3d` + rigging, 25 credits): 25,098 verts, 24 bones, NO fingers, feet are
   untextured blobs. A prototype body, below our Tripo fighters.
4. **Scene Builder** (same add-on, `features/bridge_gate.py`): an LLM agent that edits the Blender scene through the
   Blender MCP bridge. It lays out a scene; it does not generate motion.

## The operator's workflow, tested

**The video.** "Blender + Claude + Higgsfield: Next Level AI Workflow" (Code And Create, 14:15, 2026-09-10,
f6Tp1jQq-EE), watched as frames every 15 s plus the full captions, then deleted. It builds a red car on a mountain road
as a previs with Claude through Scene Builder, renders a playblast, and uses it as the motion reference for a Seedance 2.5
AI VIDEO. No person is animated. The Character Animation tab appears for about five seconds of a feature tour; its box
reads "Describe how you want your character to move and act". The second citation (AI BORDER, 4wzQ-yYYom8, captions) is
the same previs-to-AI-video idea for a robot shot. Neither shows two characters, a cage, physics rigs, root motion or a
Godot export - those steps are not in either source.

**The prompts** (`t2m_two_fighter.py`, 0.8 credits): the takedown and mount-to-armbar prompts verbatim, as one prompt
(the panel's default; the backend enhancer rewrote them longer, still about Character A and B) and as three phases,
seeds 11 and 37. All 8 came back as one body. Takedown: one crouched and curled up on the floor alone, one bent to the
floor, two stood and moved their arms. Armbar: three stood, one "sat" in the air; none reached the ground.
Video `higgs_your_two_fighter_prompts.mp4`.

**Composing two generations** (`compose_takedown.py`): 6 double-leg attackers x 6 "grabbed and dropped" defenders, the
defender turned to face, his fall onset placed on the attacker's reach frame, his mid-thigh on the attacker's hands.
Usable = hands within 10 cm of a thigh, the fall along the drive, the attacker following, torsos apart in 90% of frames.
**0 of 36.** Every attacker stops at the grab (follow-through 0.00-0.06 m). Where the torsos stay apart (attacker 23) his
hands are at 0.40 m against thighs at 0.63-0.69 m; everywhere else the torsos pass through each other in 16-81% of frames.
Every defender does fall backward, face up, 0.56-0.87 m along the drive - on his own clock, while the attacker squats
holding air. Video `higgs_two_generations_composed.mp4`.

**Godot side of the proposal.** One .glb per move and an AnimationTree state machine that cross-fades between them is
where the room was before the move script: the operator's "each part of body have each own sped" came from blending and
patching parts, and the first "Right is clearly better" came from one exchange authored for both men on one clock.

## Jab variations by fighter quality (`score_t2m.py`)

Population: one ARDY body a clip, orthodox stance, a plain "left jab" prompt x 6 seeds v six quality/intent prompts x 2
seeds (prompts in `t2m_variations.py`). A full extension = hand-to-shoulder >= 0.45 m (clean jabs reach 0.51-0.53 m).

| prompt | seed A | seed B |
|---|---|---|
| plain (x6) | 5 left jabs | seed 23: RIGHT hand instead |
| elite, relaxed, right hand glued to chin | left jab | RIGHT hand instead |
| tired beginner, slow, wide, drops right hand | cocks back 8 cm, left jab | RIGHT hand instead |
| power jab stepping in | lunges 72 cm, the jab is cut off at 0.39 m | steps 55 cm, then a RIGHT |
| two jabs in a row | jab then RIGHT (a one-two) | jab then RIGHT (a one-two) |
| body jab, lower the level | hips dip 14 cm, jab 19 cm below the head | dips 14 cm, 27 cm below |
| jab stepping backward | steps back ~60 cm, half jab 0.36 m | steps back ~57 cm, no punch |

- Elite v novice on the one seed where both threw a left jab: the "slow, tired" novice's hand was FASTER (3.4 v 2.3 m/s),
  cocked back 8 cm (elite 1), leaned 7 deg (elite 0), held the rear hand at the same height (18 v 17 cm below the head
  joint) and came back as fast (0.4 s). Quality words did not become quality mechanics.
- The only prompt that moved every seed's mechanics outside the plain jab's range was the body jab (hip drop, lean,
  lower target, a cock-back, a shorter return). Gross actions follow words; skill does not.
- **Answer to the operator's idea: yes to variations by fighter quality, no to getting them from prompts.** Build them on
  our side from parameters `author_pair.py` already has (extension time, aim, step scale) plus a guard-hand hold, a
  cock-back and a return time, keyed to stats and bounded by footage.

## The operator's follow-ups: bad clips, the range-finder, the feint, the committed jab

- **The engine already makes the decision.** `boxing_distance_read` ("Finding the Range", setup: distance_read 7,
  range_control 5) and `boxing_feint` ("Feint", setup: entry_open 8, distance_read 6) are their own techniques, and the
  room shows BOTH with the same full `jab` clip (`Godot/scripts/FightStagePlayer.gd:836-837`). A range-finder, a feint
  and a committed jab are three decisions today and one picture on screen.
- **Candidate shapes from this batch** (single bodies, no opponent; each still goes through the v1 pair method and the
  footage instrument): `jab_retreat_11` (a half jab stepping back) for the range-finder; `jab_power_step_11` (a 72 cm
  lunge) for the committed jab that opens him up. No clip here is a feint - a feint needs its own prompt batch.
- A "bad" clip is usable where it is still the intended technique done badly (a half jab, a lunge, a cock-back). It is
  not usable where it is a different move (4 of 12 threw the other hand).
- Not measured yet: how a range-finder, a feint and a committed jab differ in real footage (extension share, hip travel,
  rear-hand height, return). That is a footage question, not a studies one.

## Pipeline recommendation (final)

- **Striking** (box/kick/knee/elbow): a source take -> Blender (`glb_clip_to_bridge.py` for a library clip) ->
  `author_pair.py` v1 (retime, aim swing, contact on the opponent) -> the footage instrument (`pair_to_track.py`,
  `compare_to_footage.py`) -> pair JSON -> the live schedule. Sources in order: bought takes, Meshy library clips
  (8 credits), best-of-N text-to-motion (0.1 credit) for single-man shapes nobody sells (range-finder, feint, lunge).
- **Grappling** (takedowns, clinch, ground): generation fails - one body, and composition 0/36. Real options: buy paired
  grappling mocap; author two-man exchanges by script in Blender with contact keys (slow per move); or 3D motion
  recovered from real fight video (research-grade tools, GVHMR / Harmony4D).
- **Runtime realism in Godot** comes from exchanges authored on one clock plus selection, not from cross-fading clips.
- **Cinematics** (Seedance 2.5 from a playblast, what both videos do): trailers only - the operator ruled out videos in
  the game.

## Files

- `Tools/higgsfield/`: `t2m_batch.py`, `t2m_variations.py`, `t2m_two_fighter.py` (generation, headless Blender),
  `score_t2m.py` (jabs and falls from posed_joints), `compose_takedown.py` (36 compositions), `render_t2m_panels.py` +
  `tile_panels.py` (videos), earlier render/turntable helpers.
- Off-repo `FightCamp-higgs/`: `motion/batch/*.npz` (48 clips), `motion/two/*.npz` (8), `scores.json`,
  `compose_scores.json`, videos `higgs_your_two_fighter_prompts.mp4`, `higgs_two_generations_composed.mp4`,
  `higgs_jab_variants.mp4` (+ `_loop` phone copies), `higgsfield_library_mma_strikes_on_f01.mp4`,
  `higgsfield_text_to_motion_best_of_6.mp4`. Credits: 929.1 left.
