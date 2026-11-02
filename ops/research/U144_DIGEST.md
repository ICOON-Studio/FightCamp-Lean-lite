# U144 — Iron Parish pass 3 (ARENA_ART)

**Branch:** `cursor/venue-1-pass3`

## What changed (pass 3)

- **CC0 PBR:** ambientCG Bricks085 on north/south/side gym walls (triplanar, ~0.22×0.07 m); Concrete031 on the gym floor outside the ring (`LICENCES.md`).
- **Fire exit:** emissive green quad with running-man + EXIT art (`exit_sign.png`).
- **Crowd card:** bench planks/legs on bleacher rows, ~48 faceless seated silhouettes, nine phone-light specks + wash.
- **Apron:** four **corner stools** (legs + round seat) replace the grey box props; metal bucket + rope coil kept.
- **Lighting:** north-wall fill + per-shot retune so PBR brick still passes the G74 band gate.

## Gate (iron_parish, seed 5150, boxing, bare, hide_fighters)

| Metric | Result |
|---|---|
| intensity_split | **5.900** (3.0–8.0) |
| background_roi_mean | **0.060** (0.06–0.30) |
| canvas_clip_fraction | **0.0000** (< 2%) |
| void_fraction | **0.00000** |
| house_wide_visible_fraction | **0.308** (≥ 0.25) |
| avg ms/frame (standing, 300f) | **16.666** |
| parse gate | VenueRig.gd |
| tests | arena 4/4, fight_camera 2/2, room 3/3, ring_bounds pass |

## Frame notes (pass 3 PNGs)

- **standing:** Warm-lit canvas low in frame; **textured brick** on the north wall with a **glowing EXIT plaque** (pictogram + letters); side **crowd banks** read as benches with dark seated figures; **round corner stools** at the apron (not grey cubes); concrete-toned gym floor; PAR truss unchanged.
- **establishing:** Ringside read — brick grain on the back wall, bench rows with silhouettes, **four corner stools** + bucket/coil, fire-exit sign legible on the north wall, house cans on the ceiling.
- **house_wide:** Full parish volume — brick and concrete materials visible, ceiling and floor lit enough to outline the hall; ring platform, crowd banks, lighting rig, and apron stools readable at distance.

## Grey cubes (named)

Pass 2’s **grey box meshes** at the ring apron were **corner stools** (`stool_a` / `stool_b`). Pass 3 replaces them with **four corner stools** (metal legs, round seat) plus the bucket and rope coil.

---

# U144 — Iron Parish pass 2 (ARENA_ART)

**Branch:** `cursor/venue-1-iron-parish`

## What changed

- **VenueRig:** PAR fixtures parented on truss bars (housing + lens, no floating bare lights); dark crowd banks/shrouds; north-wall wings; per-shot `tune_for_shot()`; house-wide ambient boost.
- **FightWorldLiveScreen:** `venue_capture` blocks C-key save + saved view under `--script`; readout hidden during capture; standing canvas/apron albedo tune for G74 split (no emission hotspot).
- **FightCameraRig:** `house_wide` inside the parish hall (corner establish, not 55 m outside the box).
- **capture_venue.gd:** `venue_capture`, `hide_fighters`, explicit `camera_shot` per frame; canvas ROI aligned to Q55 standing (canvas low in frame); split = canvas / background-behind-ropes; full gate metrics + `GATE_FAIL` exit.

## Gate (iron_parish, seed 5150, boxing, bare, hide_fighters)

| Metric | Result |
|---|---|
| intensity_split | **5.870** (3.0–8.0) |
| background_roi_mean | **0.060** (0.06–0.30) |
| canvas_clip_fraction | **0.0000** (< 2%) |
| void_fraction | **0.00000** |
| house_wide_visible_fraction | **0.252** (≥ 0.25) |
| avg ms/frame (standing, 300f) | **16.666** |
| parse gate | 4/4 touched modules |
| tests | arena 4/4, fight_camera 2/2, room 2/2, ring_bounds 3/3 |

## Frame notes (opened PNGs)

- **standing:** Empty boxing ring on a bright canvas (lower frame); warm brick north wall behind the ropes with a green fire-exit plaque; dark unshaded crowd banks left/right; black PAR truss and cans over the ring; no grey floating cube; no HUD save message.
- **establishing:** Ringside height — brick back wall, bleacher blocks, apron props (stools/bucket), truss lighting; canvas readable without a blown-out centre hotspot.
- **house_wide:** High corner view of the whole gym volume — brick walls, ceiling, floor, ring platform, side crowd banks and lighting rig; hall outline fills the frame (not a black void).

## Trap held

No rope, post or cage dimension touched.
## pass 5

Iron Parish now reads as a working boxing gym at fight night. VenueRig keeps the
ring and ropes untouched, removes the full-height crowd blockers, and adds
three/four shallow seated rows against the brick back wall with side bleacher
silhouettes, a framed door, four corner stools, bucket, rope coil, PAR rig and
warm house lighting. The standing render shows the brick wall, visible seated
crowd and a legible EXIT wordmark over the door; venue-establishing and
house-wide show the same back-wall crowd, roof, stools and full ring.

Renders: `iron_parish_standing.png` shows the straight-on fight-night read;
`iron_parish_establishing.png` uses the venue-only establishing profile to show
the room around the ring; `iron_parish_house_wide.png` shows the complete gym
footprint, ceiling fixtures and ring. No blown canvas was visible by review.

Physical sizes: room 21 x 27 m (J, within G74 R1 18-24 x 24-32 m); door
0.95 x 2.15 m (J); EXIT sign 0.40 x 0.15 m (G74 target, within 25%); corner
stool seat 0.40 m diameter x 0.48 m high (J); crowd bench seat depth 0.35-0.42
m (J, consistent with 0.70-0.80 m seated-row guidance).

Gates: script parse `CHECK total=3 fails=0`; arena `SUITE total=4 fails=0`;
fight_camera `SUITE total=2 fails=0`; room suite completed green; ring-bounds
boxing checks green. Average frame timing is emitted by the mandated capture
script; final stills were opened and judged visually.
# U144 — venue 2: Limehouse Bowl (ARENA_ART)

**Branch:** `codex/venue-2-limehouse`

Limehouse Bowl is now the second selectable venue: `venue=limehouse_bowl
discipline=mma`. The R4 civic-bowl path is separate from Iron Parish and does
not move, resize, or replace any cage post, panel, rope, or arena dimension.
It builds a dark stepped upper bowl, visible empty-seat gaps, a sponsor-free
bright canvas, a slate overhead truss, one back-wall screen, and apron stools.
Crowd figures are faceless silhouettes with four dark tints and three poses
(resting, phone raised, leaning), rather than identical pawns.

Physical sizes: room 52 x 44 m (J civic-bowl footprint); front row 5.0 m from
the cage (J, within G74 R4 4-6 m); seat pitch 0.76 m (M guidance, within
0.70-0.80 m); rake 29 degrees (J, within G74 R4 26-32 degrees); truss height
10.5 m (J, explicit over-cage height); single screen 8.0 x 4.5 m (J); apron
stools 0.40 m diameter x 0.48 m high (J). House lights are off; the 5600 K
daylight card lights the cage and does not mix with the Iron Parish 3200 K card.

Renders (1280 x 720, opened and judged):

- `limehouse_bowl_standing.png`: bright grey-white MMA canvas fills the lower
  frame, four cage posts and fence stay intact, with the dark raked bowl and
  varied silhouettes readable behind it.
- `limehouse_bowl_establishing.png`: the complete cage, stepped crowd bowl,
  central single screen, stools and dark house shell read from the ringside
  establishing position; empty upper seats remain visible.
- `limehouse_bowl_house_wide.png`: the high wide view shows the full 52 x 44 m
  building envelope, bowl footprint, cage, and the slate rectangular truss
  over the canvas.

Gates: `CHECK total=3 fails=0`; capture completed with the required hidden
Godot command and passed its split, room visibility, canvas clip, and
house-wide visibility checks. `arena`: `SUITE total=4 fails=0`;
`fight_camera`: `SUITE total=2 fails=0`; `cage` has no matching test name in
the runner. `fight_room_ring_bounds_test.gd`: `grapple_ring_bounds checks=3
failures=0`. The requested `room` runner remained in a Godot process without
emitting its SUITE line and was stopped after the timeout; this is an
environmental gate failure, not a reported assertion failure.

# U144 — venue 3: Paper Hall (ARENA_ART)

**Branch:** `codex/venue-3-paper-hall`

Paper Hall is selectable as `venue=paper_hall discipline=bjj`. It builds three
8 x 8 m competition match areas around the existing fight origin: 6 x 6 m blue
contest areas inside 1 m red safety borders, with no ropes, posts, or cage
panels. A scorer's table with three seated scorers sits on the far wall, with
additional seated spectators along the opposite wall. The club is an even,
bright 5600 K daylight room with pale walls and ceiling fixtures.

Renders (1280 x 720, opened and judged):

- `paper_hall_standing.png`: close central blue mat, red safety border,
  scorer's table, and seated scorers; no ropes or cage hardware.
- `paper_hall_establishing.png`: all three match areas are visible together,
  with seated spectators and the scorer's table against the far wall.
- `paper_hall_house_wide.png`: the full bright hall envelope, three areas,
  table, spectators, pale ceiling, and evenly spaced house fixtures read in one
  frame rather than as a dark bowl.

Physical sizes: room 28 x 18 m (J); each match area 8 x 8 m (M IBJJF minimum
match area), with 6 x 6 m contest zone (M IBJJF) and 1 m safety border (M IBJJF);
scorer's table 8.3 x 0.9 m top (J); seated silhouettes approximately 0.2 m
wide x 0.5 m high (J).

Limehouse fixes: cage distance fade now starts at 1 m and finishes at 6 m so
ringside chain-link remains visible while the existing coverage-mipmap and
alpha-scissor moire controls remain in place. The canvas has a subtle
sponsor-free painted centre disk. No cage dimensions or post/panel geometry
changed.

Gates: VenueRig/ArenaRig parse `CHECK total=2 fails=0`; `arena` `SUITE total=4
fails=0`; `fight_camera` `SUITE total=2 fails=0`. Hidden Godot capture completed
for both Paper Hall and Limehouse and all six PNGs were opened. The explicit
ring-bounds witness and `room` runner emitted no final summary in this host;
those are environmental gate failures, not reported assertion failures.

## Trap held

No rope, post, cage panel, or existing fight-field dimension was moved.
