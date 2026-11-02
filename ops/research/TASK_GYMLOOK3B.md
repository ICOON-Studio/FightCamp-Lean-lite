# TASK GYMLOOK3B (S226) - the training floor to the locker-room standard (Ludo round 54's 10 items, the ROOMS3 recipe)

Model: Codex gpt-6-astra, reasoning high. PC seat (GPU stills). Worktree: the first free Codex worktree (seed it), NEW branch
codex/gymlook3b from master. Never master. Operator S226: "should codex also refine the gym floor since it is making all rooms ?" ->
Claude: yes. GYMLOOK3A merged S221 (ebf5485e, operator Q-S220-2). New features ship ON; no new switch.

## The spec
`research/LUDO_ROUND54_VERDICT_S219.md` TAKEN 1-10 + NOT TAKEN (the club-name sign stays; fan/boombox/cat = backlog) - binding.
Floor rule (memory feedback_gym_floor_is_a_training_floor): the floor is a TRAINING floor - no bath, board, chairs or office furniture on it.

## Props: Ludo models, not kit blocks (changed from r54's "Kenney/Quaternius")
The rooms now set the bar (locker room, ROOMS3). Small props come from Ludo image-to-3D in the same style, APPROVED (operator S226 verbatim:
"Yes, spend about 24 Ludo credits on the 6 gym floor props."; LUDO_MAX_CREDITS=28 for this run): ring corner stool (x2 reuse), galvanised spit bucket,
round timer case, gear bench (reuse the locker bench + bottle/glove set), chalk stand, ball/rope rack. Prompts: write them from
LUDO_ROUND65_REPLY_S226.txt section 0 rules (palette, chamfers, 1.2x, +25% feature) - same picture style as the rooms. Until the OK,
do every item that needs no new model (2 steps geometry, 3 trims, 4 markings/ladder/posts, 5 beams, 6 lights, 7 materials, 8 SSAO/
contact shadows, 9 timer digits + bag sway, posters).

## Where (read before editing)
`Godot/scripts/club_look/GymLook2.gd` (look pass, effects), `Godot/scripts/club_zones/ClubZoneFloor.gd` (floor zones/labels),
`Godot/scripts/GymClub3D.gd` (club build), `Godot/assets/data/gym_club.json` (hall rows). ROOMS3A edits GymClub3D.gd and
ClubRoomBase.gd on codex/rooms3a - fetch master first and keep both sides; touch room code only where a hall item requires it.
ALSO FIX (seen S226 in the reception room view): the hall's floor-zone labels (STRETCH / FOOTWORK / BAGS) read upside-down and
mirrored from the room camera - hide or flip them while a room view is open.

## Gate
- Parse: `python Godot/tools/check_scripts.py <touched .gd>`.
- RED first on master: a test per measurable item (ring stair width <= 0.85 m and 2 steps, ladder rungs 0.45 x 0.40 m, beam
  cast_shadow OFF, SSAO radius 1.2 / intensity 2.0, rubber roughness 0.88-0.90, canvas 0.94, strip lights not spots, bag sway amplitude
  0.75 deg, labels hidden/flipped in a room view). Paste the red lines.
- `python Godot/tools/run_tests.py --jobs 2 --only gym,club,look,zone,room` (`--jobs 1` unless GREEN).
- Stills: `tools/gymlook3a_stills.gd -- as_game` (overview, ring zone, training fighter) before/after + one room view; Ludo's
  10-item checklist written per still; post with review_add.py --stage S226. Claude opens every still and shows them back to Ludo.

## VISUAL GATE (.claude/skills/visual-gate/SKILL.md)
Red first on master; stills only on the game's own cameras; per still: what is in frame, dark zones, clipping/floating props,
the fighter readable; not "accepted" - Claude opens every still, the operator closes it.

## Rules
godot_hidden.ps1 only, watchdog before every Godot run, explicit git add, no *.import churn, never open images or windows on screen.
End: research/GYMLOOK3B_DIGEST.md + AgentComms note to Claude.

## Prior research
LUDO_ROUND54_*, GYMLOOK3A_DIGEST.md, LUDO_ROUND65_* (prop style), M_STYLE_SHEET_S206.md, LOCKER1B_DIGEST.md (translucent occluders).

## What would a human do?
Walk the floor on the game's camera with the art lead's checklist, fix the light and the scale first, then dress it.

## Prefab check
Ludo models (approved style) for props; poster textures already exist (look3a_posters); SSAO/contact shadows are Godot built-ins.

## The one trap
Lighting tuned on one still: judge every change on all three game cameras (overview, zone, fighter) or a fix for one goes dark on another.
