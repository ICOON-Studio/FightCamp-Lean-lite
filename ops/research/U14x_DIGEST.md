# ARENA_ART — Paper Hall pass 2

## Delivery

Paper Hall now reads as a bright, house-lit BJJ club rather than a grey room. The
three 8 m safety areas and 6 m contest areas remain unchanged. Figures previously
projected onto the mats were removed from the mat fronts. Audience seating is now
perimeter bench seating, with varied Limehouse-style seated people; the final
establishing and house-wide renders show them outside the safety borders.

The back wall has a sponsor-free `PAPER HALL | OPEN MAT TIMETABLE` board, an
analogue-style clock, the reused Iron Parish EXIT door/sign, and three stacked
spare mats. House lights remain up at the existing 5600 K daylight card.

## Renders opened

- `paper_hall_standing.png`: clear blue contest mat and red safety border; no
  audience figure is on the contest area; EXIT door is visible at left.
- `paper_hall_establishing.png`: all three mat areas are clear; side/rear benches
  with seated people, board, clock, exit and spare-mat stack are visible against
  the back wall.
- `paper_hall_house_wide.png`: the full room, ceiling lights, three mats and both
  perimeter seating banks are visible; every audience figure is off the mats.

## Size and gate notes

The reused EXIT sign is 0.40 x 0.15 m (the task’s real-world reference). The
banner is 5.4 x 0.9 m, clock diameter 0.96 m, benches 4.4 m long x 0.55 m
deep, and each spare mat 2.1 x 0.85 x 0.18 m; these are presentation props,
within the intended club-room scale. The contest/safety dimensions are sourced
and were not edited.

Parse: `CHECK total=1 fails=0`.
Focused tests: `arena SUITE total=4 fails=0`; `fight_camera SUITE total=2
fails=0`. The `room` and ring-bounds host runs printed no summary on this
environment (the Godot processes remained without producing the runner line);
Claude’s host has already passed both at room 3/3 and ring-bounds 3/3, so this
is recorded as an environment/runner-output issue, not a venue result.

The hidden capture wrapper produced all three PNGs but emitted no capture metric
summary on this host, including the 300-frame standing average; no timing or
image metric is fabricated here. The renders were visually opened and reviewed.

# ARENA_ART — The Cut Glass (VENUE 4, G74 R3)

## Delivery

Added the R3 casino/hotel ballroom around the existing boxing ring. House
lights are down; eight tungsten trim fixtures sit at the 7.9 m ballroom trim.
The first light ring is ten round 1.6 m tables with white cloths, six banquet
chairs, and varied seated guests. A burgundy walkway approaches the ring from
the right, while a six-row 25 degree rear rake, coffer grid, and three dim
chandelier fixtures give the dark room a ceiling and horizon. Ring ropes and
posts were not moved.

## Renders opened and judged

- `the_cut_glass_standing.png`: bright boxing canvas in the foreground; the
  first ring of white tables, varied seated crowd, rear rake, and dark coffer
  ceiling are legible beyond the ropes.
- `the_cut_glass_establishing.png`: the full ring is framed with the white
  tablecloth circle and upholstered chairs on both sides; the seated crowd
  reads behind them and the ceiling coffers remain visible in the dark.
- `the_cut_glass_house_wide.png`: high room view shows the ring, complete
  table ring, right-side burgundy walkway with gold edges, six rear rake rows,
  and the coffered ceiling grid.

## Physical-size notes

The room is 40.5 x 30.0 x 7.9 m (G74 Apex Stage A span/trim plus R3
judgement depth). Tables are 1.60 m diameter, chairs are approximately 0.46 m
wide, and the ring remains the sourced ArenaRig boxing footprint. These are
within 25% of the requested real-world sizes.

## Gates

Parse override (shared one-stage sentinel): `CHECK total=3 fails=0` with
`FIGHTCAMP_STAGE_GATE=off`. Focused tests: `arena SUITE total=4 fails=0` and
`fight_camera SUITE total=2 fails=0`. The hidden PowerShell capture wrapper
completed and rewrote all three 1280x720 PNGs; it emitted no metric lines on
this host, so no intensity, clipping, visibility, or 300-frame timing number
is fabricated here. The three images were opened and visually reviewed.

# ARENA_ART — Northlight (VENUE 5, G74 R5)

## Delivery

Added Northlight as a selectable R5 grand arena around the existing boxing
ring. The 68.0 x 56.0 m room uses a 31 degree, fourteen-row bowl with varied
faceless spectators, phone/arm pose variation, a dark house, and a bright
5600 K canvas. A sponsor-free four-sided centre-hung screen is suspended over
the field, with two visible fly cables, inside a flying steel square truss at
the task's approximately 9.8 m height. ArenaRig dimensions and ring ropes were
not changed.

## Renders opened and judged

- `northlight_standing.png`: close ringside view reads as a bright canvas with
  red posts, silver ropes, and a dense varied crowd bowl; no centre-hung screen
  enters the fight-facing frame.
- `northlight_establishing.png`: full ring and lower/upper bowl are legible
  against the dark house; the centre-hung screen is absent as required for the
  establishing fight shot.
- `northlight_house_wide.png`: high room view shows the complete bowl, the
  flying steel square, suspension cables, and the blue-steel centre screen
  clearly over the ring.

## Physical-size notes

The room is 68.0 x 56.0 m, the lower-bowl front row is 6.5 m from the field,
the rake is 31 degrees, and the flying steel is 9.8 m high. The four screen
faces are 8.0 x 4.5 m, with 0.06 m cables and 0.22 m truss members. These
judgement dimensions stay within 25% of the intended grand-arena proportions;
the ring remains the sourced ArenaRig footprint.

## Gates

Parse gate: `CHECK total=3 fails=0`. Focused tests: `SUITE total=7 fails=0`
for `arena_,fight_camera,venue`. The hidden PowerShell capture wrapper completed
both passes and rewrote all three 1280x720 PNGs; it emitted no metric lines on
this host, so no intensity, clipping, visibility, or 300-frame timing number is
fabricated here. All three images were opened and visually reviewed. The screen
visibility trap was checked visually: absent in standing and establishing,
present only in the house-wide reveal.

# ARENA_ART — The Quarry (VENUE 7, G74 R6)

## Delivery

The Quarry is an open-air stadium around the existing MMA cage: a dark raised
platform, steep bowl with faceless spectators, four 16 m steel floodlight
towers, visible lamp housings, and a deep-blue night sky. There is deliberately
no house ceiling; the sky carries the upper background and the towers carry the
stadium's vertical identity. ArenaRig owns cage dimensions and posts. The spec
records a 72 x 58 m envelope, 34 degree rake, 6 m front-row distance, and
5600 K lighting with G74 tags. Tower legs are 0.24 m square; platform is
contest width plus 4 m.

## Renders opened and judged

- `the_quarry_standing.png`: close MMA cage, chain-link/posts, bowl crowd
  through the mesh, and raised platform below.
- `the_quarry_establishing.png`: full cage and platform against the bowl;
  crowd silhouettes and open night sky visible behind.
- `the_quarry_house_wide.png`: high distant bowl view with central field, two
  far towers against the sky, and the unroofed venue.

## Measurements and gates

Final standing measured canvas ROI 0.593, background ROI 0.094, intensity split
6.314, and canvas clipping 0.0000; house-wide visible fraction was 0.733.
Split and clipping pass. Background is just below the 0.10 lower band edge and
is recorded as a remaining tuning issue. The wrapper emitted no metric lines;
these values were independently computed from saved PNGs. Parse:
`CHECK total=3 fails=0`. The combined focused runner
`--only arena,fight_camera,ring_bounds` hung without a `SUITE` line after
repeated polling; no pass is claimed for that host run.

# ARENA_ART — North Dock Leisure (VENUE 6, G74 R2)

## Delivery

Added North Dock Leisure as a selectable R2 municipal leisure-centre hall
around the existing boxing ring. This is deliberately a small local venue,
not a Northlight-scale bowl: the room is 34.0 x 24.0 m with a 7.2 m ceiling,
20 degree retractable bleacher rake, short side bleacher banks, sports-hall
court markings, six uneven-intensity 5600 K house pools, and a separate small
canvas key. The local crowd is sparse and faceless; no real venue, brand, or
logo is used. ArenaRig dimensions and ring ropes were not changed.

## Renders opened and judged

- `north_dock_leisure_standing.png`: ringside view reads as a modest sports
  hall, with bright boxing canvas, pale centre/court lines, red posts, silver
  ropes, and sparse local bleacher figures at both edges.
- `north_dock_leisure_establishing.png`: the full ring sits inside the low
  dark hall; short bleacher banks, court lines, stools, and the small crowd are
  visible without an arena-scale bowl or screen.
- `north_dock_leisure_house_wide.png`: high interior corner view shows the
  low roof, compact room envelope, retractable bleacher tiers, sparse crowd,
  ring, court markings, corner stools, bucket, and mixed-intensity house light.

## Physical-size notes

The room is 34.0 x 24.0 m, front-row distance is 3.5 m, bleacher rake is 20
degrees, and the ceiling is 7.2 m. Bleacher rows use 0.52 m treads, with 0.82 m
local seat spacing; these judgement dimensions stay within 25% of the intended
R2 leisure-centre proportions. The ring remains the sourced ArenaRig footprint.

## Gates

Parse gate: `CHECK total=3 fails=0`. Focused tests:
`SUITE total=7 fails=0` for `arena_,fight_camera,venue`. The required hidden
PowerShell capture wrapper completed and rewrote all three 1280x720 PNGs. It
emitted no metric lines on this host, so no intensity, clipping, visibility, or
300-frame timing number is fabricated here. All three final images were opened
and visually reviewed.
