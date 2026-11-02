# S90 DIGEST - decor step 1: the walls tell the gym's story (G122 + G123)
Claude, 2026-09-26. Roadmap `now` from S89.

## Shipped
- **`GymDecor.gd` (pure module, zero preloads).** G122 s5's eight pieces at G122's prices, each with its ONE unlock:
  BOUGHT - flyer wall $50 (open gym), framed poster rack $200 (10 members or a first show), slogan paint $400 and
  neon wordmark $600 (a tier-3 gym). EARNED - fighter photo row (a title or tournament gold), trophy cabinet (3 amateur
  medals), belt case (one of your fighters holds a belt), history mural (tier 4 + a champion of your own). Earned
  pieces hang FREE (the frame is not the point; JUDGEMENT) and are never for sale.
- **Wall SLOTS, not free placement (G123 s5, which backed the decided design).** Slots are cells along the back wall
  (less the clock's) and the left wall. The two back-wall slots nearest each side of the clock are RESERVED for earned
  pieces - "readable from the training floor"; a bought piece never takes one, an earned piece falls back to a free
  slot only when a tiny room runs out. `move_decor` rearranges within kind. A wing re-seats pieces (`reseat`).
- **One capped wall score (G123 s2/s5).** Earned and bought each summed best-first with x0.6 diminishing; bought paper
  capped at a 2.5 band; the whole at 8. Every earned piece (2-3 points) outscores every bought one (0.5-1.5) - G123's
  one mistake to avoid ("paper must never beat a belt"). Effects, SMALL (G122 s4: no study shows walls sell members):
  + score as walk-in reputation into `Membership.player_scores` (0-100 scale), and the weekly morale drift baseline
  65 -> 65 + min(2, score/3). A full museum is +8 reputation, +2 morale.
- **Earned pieces hang themselves the day they are earned.** `_hang_earned_decor` runs at the title-win site (the day
  the belt comes home) and in the weekly pass (medals, golds, a tier reached); name + week on the piece (G123); a news
  line ("X's belt goes up in the case at <gym>"); idempotent. Unlock facts are DERIVED from the career every read
  (members, shows, room tier, belt holders off the stored championships, event-result medals) - no counters.
- **Drawn on the 3D floor** (`TrainingFloor3D._build_decor`, greyboxes until G114's pack): cork board, three framed
  posters, "EARN IT" band, pink "OPEN" neon, the belt case with a gold plate, the photo row, the cabinet, the mural;
  an EMPTY reserved slot shows a bare frame - the place the next belt goes. Generic posters give way to the pieces.
- **Gym hub: WALLS filter** in the store drawer - "WALL SCORE 6.7 / 8 · REPUTATION +7 · MORALE +2", a row per piece:
  price + BUY, the reason it is locked, ON THE WALL, or for earned pieces how they are earned.
- **D35 acted on:** the visiting pro's card says the RISK plainly ("he is a level above X - if he stops him, the clip
  costs the gym reputation"); the result reads "reputation +2 (now N / 100)".
- `get_gym_hub` stays a pure projection: decor reads never write the save, and belt holders are read off the stored
  championships (get_championships ensures/ticks the world - `gym_hub_test` caught the first version).

## Collected
- **G123 (Grok):** `G123_DECOR_AS_A_GAME_LAYER.md` - slots, reserved earned slots, one hard-capped number, name + date,
  paper never beats a belt. Built as written.
- **D35 (Dola):** `D35_FRESH_EYES_VISITORS.md` (reply trimmed from the raw capture) - acted on as above.
- **U184 (Cursor), Q192 (Qwen): STILL RUNNING at handover** (worktrees Temp/FightCamp-U171, Temp/FightCamp-Q164) -
  owned by S91, merge bars in roster.json.

## Tests
- NEW `gym_decor_test` 0 failures: prices, kinds, every unlock at its threshold and not one below, earned > bought;
  no slot on the clock, reserved = nearest the clock, bought never reserved, a wing re-seats; the cap (full wall = 8,
  paper <= 2.5, a second piece worth less, reputation/morale capped); a career: earned refused, tier-3 paint refused,
  $50 flyer, bought once, no cash no paint; a belt held -> the case hangs itself in a reserved slot, named, one news
  line, reputation up, never twice; morale drifts to 65 + lift; the pieces and empty frames drawn in 3D; the hub's
  WALLS rows. **Six real mutants, all red:** no cap; no bought band; earned buyable; earned never hangs; bought takes a
  reserved slot; morale uncapped.
- `equipment_market_filter_test` expects the new WALLS chip (its own contract changed by design).
- Subset (gym_/training_floor/membership/smoke/spar/fight_camp/floor/wing/day_feed/career_loop/menu_clarity/home_pin/
  equipment_market/visiting/decor/news/morale): **29 tests, 29 green** (`--jobs 2`, CPU 15% with two agents waiting
  on their APIs). Nightly: `AgentComms/nightly/latest.txt` (2026-09-26 at 9847dd13: 416 tests, 13 known reds).

## Renders
`docs/previews/s90/floor_walls.png` (tier-3 academy: four bought pieces, belt case + photo row hung by themselves,
two empty frames by the clock), `hub_walls.png` (the WALLS list), `floor_visit_risk.png` (D35's RISK line).
Tool: `tools/s90_render_decor.gd`.

## Assigned
G124 (Grok, grok.com/c/43ff8546-b4c3-4775-9eb7-7ef68d615c0e): the front door - lobby, desk, the walk-in funnel,
trial conversion, desk-hire wage - for S91. D36 (Dola, newest Cici chat): fresh eyes on the S90 walls.

## Not done
The lobby/door museum and physical doorways (S91, G124 + D34). Real prop models (G114). Left-wall slots are live but
unused in these renders (the back wall had room).
