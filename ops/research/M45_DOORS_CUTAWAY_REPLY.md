# M45_DOORS_CUTAWAY_REPLY - Grok bot maria reply, verbatim (S236 collect)

**1. Cutaway: cut the near walls down to a stub with a dark cap line, not fade them**

Cut every wall between the camera and the room down to a stub. Don't fade it or dither it. Here's why:
- A faded wall at any alpha still puts a coloured veil over the room, and the brick or tile texture ghosts over the floor. At a 55 to 65° view that veil covers most of the frame, which is exactly the operator's complaint.
- Dithering shimmers when the camera orbits and at phone scale, and it looks like a rendering bug in a bright, clean art style.
- A stub keeps the room's footprint readable (you can see where the wall was and where the doorway is) while hiding nothing inside.

**Spec**
- **Stub height:** 0.40 m above the finished floor. That's just above the skirting and below a seated person's knee, so furniture against the wall still reads. Every room uses the same height, so the building reads as one cut.
- **The cut top edge:** a flat cap the full thickness of the wall, filled with a dark, desaturated colour: #2B2522 (warm charcoal, so it sits with the brick and wood). Add a thin 0.01 m lip line on the room side in the wall's own colour, so the cap belongs to that wall.
  - That's the read used by The Sims 4 and Two Point Hospital: the cut is clearly a cut, not a short wall.
  - Don't show brick or plaster texture on the cap. A flat fill reads cleanly from above.
- **Which walls cut:** any wall whose outward normal faces the camera within about 100° (the walls between the camera and the room's centre). Side walls that run away from the camera stay full height, so you keep two full walls framing the room, like a stage set.
- **Transition while orbiting:** a 0.2 s ease (smoothstep) between full height and the stub, driven by height, not alpha. Animate the top down, or swap at the midpoint with a vertical clip that slides. Don't make it instant: an instant pop on every orbit tick reads as flicker. No continuous motion once settled.
  - Add hysteresis: cut at 100° and restore only at 110°, so a wall at the boundary doesn't flip back and forth.
- **Floor and skirting under a cut wall:** the floor runs right up to the wall line. The skirting stays on the room side at its real height (0.10 m), so it sits inside the 0.40 m stub and reads intact. The parquet, checker or tile ends cleanly at the wall line; it never pokes through.
- **Wall-mounted items on a cut wall** (frames, shelves, whiteboards, a clock): hide anything above the stub height during the cut. Don't leave it floating in the air.

**Mode switch (optional, recommended):** give the player a cutaway toggle with three states: walls up, walls cut (the default), and walls down (floor-level stubs, 0.10 m). This is the Sims convention and players expect it.

**References and what to copy**
- **The Sims 4:** copy the walls-cutaway mode with its short stubs and dark caps, plus the three-state toggle. This is our main model.
- **Two Point Hospital:** copy the clean, bright, stylised look of the cut and how rooms read as boxes with clear doorways from above. The exact way it cuts walls is NOT VERIFIED from here; I'm citing it for the overall read.
- **Prison Architect:** copy the clarity of a pure top-down floor plan as the extreme. It confirms floor and door legibility matter more than walls. It's 2D, so copy only the readability goal, not the technique.
- **Jagged Alliance 3:** copy the roof and wall hiding around the area in focus, keeping far walls standing for context. I haven't checked its exact cut height or fade, so treat that as NOT VERIFIED.

**2. Doors: open at about 100° against the inside wall, with the frame always kept**

General rules:
- Standard leaf size is 0.90 m wide and 2.10 m high, with a 0.04 m thick leaf.
- The frame (casing) is 0.07 m wide on each face, and the threshold strip is 0.02 m high.
- Each door stands open at 100°, swung into the room and resting against the inside wall, so the walking path through the doorway stays a clear 0.90 m.
- Hinges go on the side that puts the open leaf flat against the nearest wall, never into the path.
- When a door's wall is cut, the frame cuts at the stub height (0.40 m) like the wall, with the same cap colour. The open leaf, standing inside the room, stays full height if its wall isn't cut, so the door still reads as a door.
  - If the leaf sits against a wall that's being cut, cut the leaf to the stub height too, with a cap in the leaf's own colour, not the wall cap colour. That way you can still see which object it is.
- Never use a pale see-through panel as a stand-in: every doorway has a real frame and leaf.

**Office: panelled wooden door**
- Leaf: a 4-panel wooden door in a stained medium oak, #7A5230, with a satin finish. The raised panels are 0.01 m proud, with a highlight edge one shade lighter, #9A6B42.
- Frame: dark walnut #4A3220, 0.07 m. This is darker than the leaf so it reads against the wood panelling, which should sit between the two (about #6B4A2E).
- Handle: a brass lever, #B8892E, at 1.05 m. Use a slightly brighter brass so it catches the light.
- Sign: a small brass plate 0.20 × 0.06 m at 1.55 m height, reading "OFFICE" (EXAMPLE string; Kalli owns the words).

**Physio: white clinical door with a push plate**
- Leaf: flush (flat), white with a slight warm tint, #F2F1EC, so it doesn't clip to pure white under bright light.
  - A narrow vision panel 0.15 × 0.70 m, set off-centre at eye height, frosted glass at #CFE3E8 with 60% opacity.
  - A kick plate 0.25 m high at the bottom, in brushed steel #A9AEB3.
- Frame: pale grey steel, #C9CDD1, 0.05 m. It's slimmer and clinical, with a crisp edge against the white tiles.
- Hardware:
  - A push plate 0.10 × 0.30 m in brushed steel at 1.10 m on the push side.
  - A D-shaped pull handle 0.30 m long on the pull side.
- Sign: a white plate with a simple dark-grey pictogram and "PHYSIO" (EXAMPLE), 0.20 × 0.20 m, at 1.55 m.
  - Don't use a red cross. It's a protected symbol, and red reads as an alert in our UI language.

**Reception: the gym's front door, glazed**
- Leaf: a full-glazed door in a slim black aluminium frame. Glass at #DDE7EA, about 30% opacity, with a soft highlight streak. The frame is #1F1F1F, with 0.06 m stiles and a 0.18 m bottom rail.
- Size: a pair of leaves, 0.90 m each, for 1.80 m in total. It's the main entrance and should feel like one.
  - The doors stand open at 100°, pinned back against the outer wall. If the inside wall gets in the way, open them out onto the street side.
- Hardware: long vertical bar handles, 0.60 m, in brushed steel #A9AEB3.
- Sign: the gym name as vinyl lettering on the glass at 1.40 m, white #F4F4F2 (the name is EXAMPLE), plus a small opening-hours decal below it. A hanging "OPEN" sign is optional.
- The checker floor runs right out to the threshold, where a 1.20 × 0.80 m coir doormat sits, #8A6A45. This marks the gym's front door from above in one glance.

**Inner doors between rooms and the training floor (if any)**
- Use a simple flush door in a mid grey-blue, #5E6B78, with a steel frame, so it's clearly a service door and the three hero doors stand out.

**3. The near-floor edge: show the corridor floor, not a dark slab**

The bottom of the frame should show a strip of whatever floor is outside the room. Usually that's the corridor or the training floor, with the cut wall's stub and cap running across it. That puts the room in its building, the way The Sims and Two Point Hospital frame rooms.
- **Strip depth:** at least 1.5 m of corridor floor in front of the near wall, visible in the camera's default framing. Raise or tilt the default camera if needed to get this.
- **The corridor floor:** a neutral surface that doesn't compete with the room floors. Use polished concrete at #8C8780, or the training floor's rubber matting if the room opens onto it (match the S206 zone mat colours).
- **Lighting:** the corridor is about 20% darker than the room's interior, never black. The eye should go into the room, but the corridor still reads as a real place.
- **Edge of the building:** if the room sits on the outer wall, the bottom of the frame shows the outside. For the office, that's the pavement at #9A958C with a kerb, plus the red-brick outer wall as a stub with a cap. Never leave a void.
- **The dark slab is most likely the underside or side of the floor geometry, or an uncut outer wall seen from above.** Kill the slab: give the level edge a clean face in the floor colour, or simply extend the corridor geometry past the frame edge so the camera never sees the end of the world.

**What to avoid**
- **Alpha-faded walls:** a veil of brick or tile over the room.
- **Dithered or stippled walls:** they shimmer when the camera orbits and at small sizes.
- **Instant pops on cut and restore:** use the 0.2 s ease with hysteresis.
- **Continuous motion on walls or doors:** no pulsing outlines or bobbing.
- **Floating objects:** wall-mounted items left in the air above a cut wall.
- **Bare doorways or pale see-through panels** pretending to be doors.
- **Doors swinging into the walking path,** or into the camera's line of sight.
- **Pure white (#FFFFFF) or pure black (#000000) surfaces:** they clip under bright light and lose detail.
- **A red cross on the physio door.**
- **Teal anywhere in the set:** it's reserved for the UI.
- **Black voids at the edge of the frame:** always show a floor.

All hex values are starting points to check under our warm key light in-engine. All signage text is EXAMPLE pending Kalli. I can mock the three rooms with the cutaway, doors and corridor strip as stills if you want to see it before it's built.
