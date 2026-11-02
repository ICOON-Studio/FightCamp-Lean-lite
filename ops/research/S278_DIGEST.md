# S278 digest - BUILD window like MGT2, draw the zone then the items, walk-ins follow the drawn rooms (2026-10-21)

## What now works (all on the real route, as_game, game-camera stills opened)
1. **BUILD from every screen** (a17fc25e). The one top bar has BUILD (wrench) on every career screen. On the gym floor it opens or
   closes build mode; anywhere else it goes to the floor with the window open. `ui/BuildWindow.gd` replaced the long bottom tray. It
   is laid out after MGT2's own build windows, measured on the operator's install (level2 RectTransforms, numbers only): a 314 px
   window docked left, a title bar, one list and key hints. Ours is 340 px with tabs ROOMS / OBJECTS, and picking an entry swaps the
   list for a placing card. Probe `tools/s278_build_window_probe.gd -- as_game` starts from the OFFICE desk: fails=0.
2. **One piece at a time** (78d15fb6). Training equipment is bought singly at its catalogue price
   (career `club_places_bought` + its `club_place_moves` row). R turns a piece, drag moves it, Delete sells it
   (PlacementRules.refund). Refusals are in words; the selected piece has a gold outline. `tests/build_single_piece_test.gd`.
3. **Operator: "you draw the room/zone and then you put the suitable items, you do not put the zones"** (25101df4). ROOMS
   draws the Training Floor as an open zone (maple like the approved C78 floor, as many as he likes; career
   `club_training_floors`, drawn by ClubZoneFloor). OBJECTS on the shell sells only the ring and single pieces; the zone packages
   are gone. A piece stands only on a drawn training floor. Memory: feedback_draw_zone_then_items_s278.
4. **"Why there is this separation?"** (b4e5236b). The pale band across the empty shell was `Shell/FrontCorridorFloor`, the old
   1.6 m aisle in front of the fixed front rooms. It is no longer drawn on the shell (tools/s278_band_probe.gd).
5. **Walk-ins go to the reception he drew** (4a91c4d3). `GymClubLayout._shell_walk_in` rebuilds the walk-in graph from the
   street door and the drawn reception, office and locker doors, plus his desk. `tests/shell_walk_in_test.gd`.
6. **Collected**: ASGAMERED4 round 1 (Goose, ca71b485: dev_built_gym restores the starter roster). ASGAMERED1 had already been
   collected in S277.

## Decided and why (Claude as developer)
- Each training piece is a station place of the club data, so the money/member model counts it with no new system.
- Training floors are not walled rooms: kept in their own career list and drawn by the existing floor-patch renderer.
- The 3 as_game reds in the regression set (gym_club_3d, floor_hud2, gym_hall_panel, reception_club_props) are pre-existing
  design pins. Proof: reception_club_props is red with this session's change switched off. Handed to Cursor #309 / Goose #312.

## Waiting on the operator (board)
- **Q-S277-1**: rooms-that-work verdict (Ludo's reply, 27k chars): lockers gate members, office PC full purses, physio table and
  shelving rules, 9 room items, bags need a wall arm ($550) or a stand ($950). research/LUDO_S278_ROOMSWORK_VERDICT.md.
- **Q-S273-7 answer "no need for rent build the rest"**: "build the rest" is acted on (STARTECON1 launched). "no need for rent" is
  ambiguous (drop the S277 rent, or no need to ask again?). Asked in the S278 closing message; rent stays as built until he says.

## In flight
- Goose #312 ASGAMERED5 (round 2 + batch-B reds + floor_hud2, gym_hall_panel, reception_club_props; story tests skipped).
- Qwen #313 ROOMUNLOCK1 (room unlock rules pure module), Qwen #314 STARTECON1 (loans, bail-out, pay tiers, income channels).
- Cursor #303 NIGHTLY12, #309 ASGAMERED2, #310 ASGAMERED3; Ziva ZIVATREMBLE1 (wt/ZIVA, editor restarted S278).

## Next (S279)
1. Collect what lands (above).
2. The taped floor ring / sparring pit (room_types `sparring_pit`, key item `taped_floor_ring`): a drawn zone + its item; sparring
   must work on it (today sparring needs the $18,000 ring's place).
3. Wire ROOMUNLOCK1 into BuildMode.room_types (locks open when met), then STARTECON1 into GameState + office screens.
4. After Q-S277-1: rooms that work (key item rules, room items, bag mounts).
5. Ludo's 16-goal first hour (approved Q-S273-7).
