# LUDO ROUND 57 VERDICT (S220) - New Career step 3 "NAME THE GYM" redesign

Operator (S220, verbatim, on the step-3 screen): "this screen is wrong ask ludo , it must represent the current gyms preview also
ability to move zones etc". Ask `LUDO_ROUND57_ASK_S220.txt`; reply verbatim `LUDO_ROUND57_REPLY_S220.txt` (27,355 chars).
Ludo: interactive 3D preview of the real club, zone drag/swap, one editor shared with a later build mode; scores itself 9.1/10.

## Claude's verdict (for the operator's OK on the board; nothing below is built)
TAKEN:
1. Layout 1920x1080: top bar 56 px; LEFT sidebar 444 px (gym name, your name, start chips, the 4 money tiles, a ZONE INSPECTOR that
   fills when a zone is clicked, the roster tile, ADVANCED); CENTRE = the LIVE gym (x 476, y 72, 1428 x 864); bottom strip (RESET,
   UNDO, floor used m2, the start's pitch line, OPEN GYM gold #E5B842).
2. The preview IS the game's own 3D club (GymClub3D in a SubViewport, the game's floor camera) built from the chosen start's floor -
   the gym you arrange is the gym you walk into. The 10 equipment cards, the "+ install" card and the abstract blueprint are cut.
3. Zones only (no single props in the demo): click = gold outline + the inspector (size m2, equipment, what it trains, condition,
   upkeep); drag = move on a 1 m snap; drop on another zone = SWAP (cyan outline); a bad drop (aisle, wall, overlap) = red outline +
   "BLOCKED: AISLE" / "BLOCKED: OVERLAP" and it springs back; Ctrl+Z / RESET.
4. FIXED: walls, front door, the two aisles (z 10.4-11.6 and 16.4-18), and the ring (every start, in the demo).
5. Free before OPEN GYM. After opening, the same editor (one system) = build mode later: $150 a zone move + 1 day out of use (later stage).
6. Starts: story = Calder House fully laid out with worn kit; open sandbox = the EMPTY hall + ring, the left sidebar becomes a zone
   palette and cash/upkeep/runway update as zones are placed (operator rule: the sandbox starts empty).
NOT TAKEN:
- 0.5 m snap, moving the ring between bays - scope for after the demo. (Resize + 90-degree rotation: TAKEN by the operator, see below.)
- Ludo's new start money ($45K / $65K, upkeep $185 / $75): the round 53 numbers the operator approved (Q-S212-16) stay.
- "Mara Solano (Lightweight)": she is a welterweight; the game's data wins.
- AStarGrid2D walk grid: the club walks on its own node/edge graph (gym_club.json); a moved zone re-anchors its places on that graph.

## Build (after the operator's OK)
NEWCAREER3A (Cursor, Godot UI): the new layout + the live club preview + click inspector (no moving yet); stills on the game camera.
NEWCAREER3B: drag / swap / blocked / undo / reset on gym_club.json floor_zones, saved into the new career's floor; test = a swap
round-trips, a drop on an aisle is refused, RESET restores the canonical layout, the 3D club after OPEN GYM shows the moved zones.

## Round 57b (S220) - Ludo LOOKED at the rejected screen (picture uploaded through the Ask Ludo upload screen)
Reply verbatim LUDO_ROUND57B_REPLY_S220.txt (27,272 chars). Its 7 problems, most important first: the empty right ~40% of the screen, the equipment treemap with no relation to the hall, no gym preview, no way to move zones, a generic 3-fighter roster, cash/upkeep without the real burn, unreadable 9 px labels. Each maps to an item above; nothing in this verdict changes.

## OPERATOR RULING (board Q-S220-1, 2026-10-13, verbatim): "Approve, and add resize/rotate"
Resize (edge/corner handles, 1 m steps, each zone's min/max footprint = the equipment it holds + clearance) and 90-degree rotation (R key + a rotate handle; a rotation that collides springs back) are IN the demo, in NEWCAREER3B.
