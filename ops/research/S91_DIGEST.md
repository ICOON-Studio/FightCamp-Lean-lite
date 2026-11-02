# S91 DIGEST - the front door: the lobby, the earned museum, the walk-in who becomes a member (G124 + D34 + D36)
Claude, 2026-09-26. Roadmap `now` from S90.

## Shipped
- **`FrontDoor.gd` (pure module, zero preloads) - G124's funnel.** Walk-in -> completed trial 60% with the owner
  greeting between classes, 70% with a desk hand ("50-70% if greeted"); trial -> member 25% base, +10 points for a
  desk's same-day follow-up, +1 point per earned piece at the door (at most 3; "prestige, not a published lift"),
  +0.1 point per reputation point above 50 (at most 5; "reputation and class quality move the rate"). **Hard cap 40%**
  - desk + full museum + a famous name sum to 43%, and the cap is what binds (G124: "do not use vendor 60-80%").
- **The market still decides how many want the gym.** The week's step toward the city target is what the owner's
  reference funnel lands (it reproduces steps 1-6 exactly: 6 members = 40 walk-ins -> 24 trials -> 6). A desk converts
  more of the SAME door traffic (40 -> 28 -> 10) and never past the gap; at target it adds nobody - G124's one mistake
  ("a lobby that multiplies members without a cap") cannot happen. Wired in `Membership.settle_week` via a
  `front_door` override; absent it, R44's step stands untouched. The settled funnel is stored as `last_funnel`.
- **The desk hire:** part-time, $16/h x 20 h = **$320 a week** (G124 s4: gym front desk ~$16/h, $15-18 band), a
  fictional name, a news line. Its wage is on every payroll sum (weekly billing, billing summary, the desk's weekly
  projection, scouting affordability, the save summary). Hire / let go from the lobby.
- **The lobby in 3D (`Lobby3D.gd`, extends TrainingFloor3D's greybox helpers; route `lobby`, `LobbyPanel.gd`).** Warm
  tile floor, the club name, the front desk with sign-in tablet and waivers, whoever stands behind it (the head coach
  "on the desk between classes", or the hire), a walk-in at the counter when the week brings one, a bench, a merch
  rack of club kit. **The museum wall - "THE GYM'S HONOURS"** - mirrors every earned GymDecor piece, named and dated
  (the ring wall keeps its own slot, G122); every earned piece still to come hangs as a gold honour frame that says
  how it is earned. Doors: OUT TO THE CITY (fights hub) and THE TRAINING FLOOR. Cards: THE WALK-INS (this week's
  walk-ins -> trials -> joins, the rates and the cap, and the same week with the other desk choice) and THE DESK.
- **Physical doorways (D34).** The floor's doors moved into the LEFT wall - the one full-height wall the camera sees
  whole; the front wall is a knee-high cutaway and cropped them. Each is a deep frame, a dark opening with the leaf
  standing ajar, a sign board over the lintel and the same words painted on a floor mat. The button row is gone.
  Decor slots skip the cells a doorway stands in. The street door is now FRONT DESK · STREET -> the lobby.
- **D36 acted on (first change):** every earned piece wears a raised gold border; the belt case now reads as a belt
  (red velvet, curved strap, side plates, round centre plate); the empty reserved frames are gold honour frames with a
  belt ghost and "YOUR NEXT CHAMPION". The mural's unlock now says how: "a tier 4 gym and one of your fighters
  holding a belt".

## Collected
- **G124 (Grok):** `G124_THE_FRONT_DOOR.md` (98 sources) - built as its s5 judgement says.
- **D36 (Dola):** `D36_FRESH_EYES_THE_WALLS.md` - acted on as above.
- **Q192 (Qwen):** merged - see below.
- **U186 (Cursor):** see below.

## Tests
- NEW `front_door_test`: 0 failures (54 checks: the rates, both caps, the reference step 1-6 exact, desk wage on
  and off the payroll, a settled week with the desk, the lobby's nodes, museum named + dated, doors route, a click on
  the street doorway, the desk card, D36 trim + belt ghost on the floor). **Five real mutants, all red:** no conversion cap (2 fails); no gap
  clamp (1); desk wage off the payroll (1); museum not mirrored (1); funnel not applied in settle_week (1).
- `training_floor_3d_test`: the street door now opens the lobby (its own contract changed by design); every door in
  the left wall; no button row; sign board + floor signage. `scene_router_test`: `lobby` added to the route contract.
- Subset (gym_/training_floor/membership/smoke/spar/fight_camp/floor/wing/day_feed/career_loop/menu_clarity/home_pin/
  equipment_market/visiting/decor/news/morale/front_door/router/finance/billing/shell): **33 tests, 32 green, the one
  red was scene_router's route count - fixed, re-run green.** Nightly: `AgentComms/nightly/latest.txt` (2026-09-26 at
  9847dd13: 416 tests, 13 known reds).

## Renders
`docs/previews/s91/` - `floor_doorways.png`, `lobby_owner.png`, `lobby_desk.png`. Tool: `tools/s91_render_front_door.gd`.

## Operator
Bought **Tripo Pro** (2026-09-26). S92 = regenerate the twelve fighters on Pro, then the portraits (M35 s3); G125
(Grok) researches the regeneration and the portrait recipe for it.
