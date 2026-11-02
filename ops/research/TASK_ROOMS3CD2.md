# TASK ROOMS3CD2 - rooms round 2 from the operator's markups: see-through near walls, real doors, facings, spacing (S235)

Seat: CODEX (operator S234: "assign both rooms to codex and nothing else" - this is the same rooms task, round 2). Continue in worktree
E:/FightCamp/wt/ROOMS3CD on branch codex/rooms3cd: first `git fetch origin && git merge origin/master` (round 1 is now ON master, collected
by diff - expect a clean merge). One commit per fix, push after each. Claude collects by diff.
Model: gpt-6-astra, effort high.

## The operator's words (verbatim, S235)
"check my comments on board the rooms from codex put them in , fix doors and how walls render ,in those still the walls should be transparent"
Markups (open each marked.png with your file tool - percentages are of the 1920x1080 still, origin top-left):
- Feedback/2026-10-17-02 (office, your after still 02_office): 1 "wring facing" = the dark-green FILING CABINET (23%,35%) faces the side wall -
  its drawers must face into the room; 2 "what is this ?" = the HUD cue bar (POWER THROUGH / CRISP FORM / PACE YOURSELF) shown over a room
  view; 3 "wrong facing" = the old CRT COMPUTER on the side desk (61%,28%) faces the wall - its screen must face the chair/room;
  4 "add doors ?" = the office doorway (73%,65%) is an open gap - it needs a door.
- Feedback/2026-10-17-03 (physio, 02_physio): 1 "space them up" = the BIN and the STOOL (34%,66%) touch/overlap - give each its own floor
  space (>= 25 cm apart); 2 "textures?" = the big NEAR WALL on the right (63%,11%, 21x65%) fills a third of the still with a blank tiled slab.
- Feedback/2026-10-17-04 (reception still from 2026-10-16 18:19): 1 "what is this>?" = the dark band across the bottom 21% of the still is
  the camera-side wall/slab seen from above; 2 "door?" = the doorway (36%,10%) shows a pale see-through panel that reads as a broken door.
- Feedback/2026-10-17-01 = same office marks 1-2.

## Do
1. SEE-THROUGH NEAR WALLS ("in those stills the walls should be transparent"): when the camera looks into a room (the room views your
   stills use, and the floor's room close-ups), every wall segment BETWEEN the camera and the room's floor centre is cut away: fade it to
   ~15% alpha (or drop it to a 30 cm stub with its top edge drawn - pick the one that reads cleaner and say why), every frame the camera
   moves; walls behind/beside the room stay solid. Do it ONCE in the shared room-wall code so office, physio, reception and every other room
   get it - trace which script builds the room walls and which camera the room view uses (grep, do not guess). Never cut a wall that is not
   between camera and room. No dark slab may cover the bottom of a room still (C97 mark 1).
2. DOORS: every room doorway gets a real door - a framed door leaf (wood for office/reception, white for physio) standing OPEN at ~100
   degrees against the inside wall, frame + handle, so the opening still reads as a passage and walking routes stay clear (your walk-path
   test must stay green). Replace the pale see-through reception panel (C97 mark 2). Prefab check first: Ludo r65 kit / our club models /
   CC0 (Poly Haven, Kenney) - name the licence in PROVENANCE.md; if nothing fits, build it from boxes with the room's wood/paint materials.
3. FACINGS: filing cabinet drawers into the room; CRT screen toward the room. Add a test: for each prop with a front, its forward vector
   points within 60 degrees of the room centre (catches both marks).
4. SPACING: physio bin and stool >= 25 cm apart (bounding boxes); extend your existing overlap check to every prop pair in both rooms.
5. HUD: the floor cue bar (and any training-only HUD) is hidden while a room view is open - grep where FormCueBar is shown; hide it, do not
   delete it. (Another agent is editing GymClub3D.gd lines ~40-60 and ~1540-1620 for the floor cuts - keep your change out of those lines.)

## Gate
- Red first: your new facing / spacing / near-wall tests fail on master (paste the red lines in your digest).
- `rooms_office_physio_test`, `club_rooms_split_test` and your walk-path test green; parse gate on every touched .gd.
- Stills ONLY through the game camera, windowed via `Tools\godot_hidden.ps1` (never a window on the operator's screen), BEFORE and AFTER for
  office, physio AND reception, saved through still_framing where it applies. Open every still yourself: no near wall covering the room,
  doors visible, cabinet + CRT facing in, bin and stool apart, no cue bar. Post them with `python Tools/review_add.py --stage S235 --title
  "<what>" <files>`.
- Visual gate: .claude/skills/visual-gate/SKILL.md. Nothing closes without the operator's OK on the board.

## Rules
Watchdog before every Godot run (`Tools\pc_watchdog.ps1 -Once`; RED = wait). One test job at a time. Never `_console.exe`. Nothing opens on
the operator's monitors. Do not read GameState.gd whole. New behaviour ships ON (GameSwitches.GAME_ON if it needs a switch).

## Prior research
ROOMS3CD_DIGEST.md (round 1), GYM4 club design memory (rooms off the floor), research/LUDO_ROUND65_* (room kit).

## What would a human do?
An architect's cutaway drawing: the wall nearest you is removed so you see into the room; doors hang open against the wall.

## Prefab check
Door: Ludo r65 kit, our club models, Kenney/Poly Haven CC0 - name the licence.

## The one trap
A cutaway that only works for the one camera angle in your stills: test it with the camera on each side of the room.

## VISUAL GATE (.claude/skills/visual-gate/SKILL.md)
1. First run the gate on master's shipped clip/scene: it must read RED on the defect; paste that number in your report.
2. Stills only via record_room.gd / club_room_still.gd -- as_game + still_framing.gd save_if_framed (game camera; never a feet-only or mat shot).
3. For every still report: gap between bodies / where each nose points / wrists in line / feet / the defect / which bodies (room stills: clipping, floating, paths, dark zones, HUD).
4. Do not call it accepted or fixed. Claude opens every still; the operator closes it.
