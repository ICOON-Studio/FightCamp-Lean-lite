# S345 digest (2026-11-01) - the fight HUD that beats UFC 6, the move player verified on the GPU

## Shipped (Lean, pushed - commit in the HANDOFF line)
- FIGHTHUD2 (operator Q-S294-69 "Yes, build it"; plan research/FIGHTHUD_S344.md):
  - scripts/rules/FightMeters.gd (pure): six bars a boxer {fill, keep, known} - HEAD = her worst head place (BodyMap head,
    eyes, nose), BODY = her worse rib side, LEGS = 1 - legs Burn, STAMINA = energy with the grey end = min(round start,
    100 - body shots x BODY_COST) (every body shot greys the tank for the fight), GUARD = 1 - max(shoulder Burn x 0.6, the
    3D's glove drop), HEART = 1 - (counts x 0.22 + hurt moments x 0.06) x (1.5 - heart/100) (a heart-55 boxer near empty at
    the 4th count, where the referee stops it). Round edge = the round's own rule: net exchanges won / 3, margins only
    nudge (0.15). Scouting: her guard shows once a habit of hers is found (no habit on file: her weapon), her heart once
    her weakness is. tests/fight_meters_test.gd 30 checks (Maria, Priya, Dana files), in run_tests.sh.
  - scripts/fight3d/HudBars.gd (UI): her block top left, the opponent's top right (mirrored), icon + bar per row, tooltips
    carry the numbers and the words; bars ease, a band change pulses, a body shot flashes BODY + STAMINA together; unknown =
    dashed box with a gold "?"; the corner says "Her hands are coming down - over the top!" once a round when her scouted
    guard sinks under 0.55. EdgeMeter: red half / blue half tug of war with ticks at each exchange.
  - FightHud.gd: the scorebug is the round box top centre (ROUND n OF m, the clock, the edge meter); buttons under it; the
    text rows (ENERGY 82, BODY TAKEN 4) gone. BodyLive panels moved under the bars (TOP 200); CompuBox stats are the tooltip
    of her name. Icons.gd + Lucide "shirt".
  - Evidence: real GPU stills (hidden desktop, tools/fight3d_play.gd, new `noscout` switch) docs/playtest/S345/
    hud_round2_scouted.png, hud_round2_unscouted.png (+ zoom), hud_round1_verdict.png. golden_path_test green.
- MOVEPLAYER1 hand merge (S344's tmp/MovePlayer_merged_s344.gd + probe patch) applied and fixed:
  - _update_camera ran before the camera existed (SCRIPT ERROR on every build) - guarded.
  - Reach measured from the glove centre to the head bone (the base of the skull): read 0.16-0.19 m on every punch. Now
    PunchRange.record's own measure (stage.glove_front -> stage.target_point): 0.015 / 0.004 m.
  - A punch combination starts at the pair's own jab gap (FightStage.gap_m, where the fight throws it), not the card's
    middle; the probe expects the same.
  - Camera 3.4 m (fov 35 cut both women at the shins at 2.5 m); moveplayer_still.gd now shoots at each punch's contact
    (it shot after every clip had played, so "contact" showed her back in guard).
  - GPU probe MOVEPLAYER OK 5/5; stills docs/playtest/S345/moveplayer_contacts.png (jab, cross, hook at contact, pivot out):
    both women head to feet, boots, jab and cross on the face, the hook partly on her raised guard. NOT wired into the move
    map yet (next session).
- CI red on main since S343: tests/injuries_test.gd "the week's hours go into her usual" failed on a random career seed
  (the week-end training roll injured her, the test then expected a rest week; end_week books the hours before the roll).
  The test now expects the normal week. 3/3 local runs green.

## Collected / looked at
- FIGHTCARD1 r5 (Cursor): ALIVE, not dead - the board reconcile looked for the wrong worktree name; it was rendering
  card=own_ropes in E:/FightCamp/wt/LEAN_FIGHTCARD1 at 13:35. Out file empty so far. Leave it to land.
- TELLS1 r2 (Goose #17, run 41301350509): still in progress at 13:30. PADWORK1 r3 (#13, 5633c78) and CLINCH2 (#14, 31ccc38)
  pushed; their GPU stills are next session's first collect.

## Decided (Claude is the developer)
- HUD numbers that were Claude's call: TIRE_SHOW 0.6, KD_COST 0.22, HURT_COST 0.06, EDGE_FULL 3, TIE_NUDGE 0.15, GUARD_LOW
  0.55 - each tied to a rule already in the game (Knockdowns' four counts, Exchanges.round_of). LEGS is one bar, not
  UFC's two lines: the body keeps one legs Burn (BodyLoad), and a second line would be invented.

## HANDOFF
Working commit: see roadmap now.last_working_commit. Next: (1) collect FIGHTCARD1 r5 / TELLS1 r2 / PADWORK1 r3 / CLINCH2
with the GPU visual gate (re-measure every probe; hidden_desktop drops stdout - use --log-file). (2) Wire MOVEPLAYER1 into
the move map's bottom-left (bottom card row up to y 0.64, key behind '?', click a move or a plan row's TV icon plays it;
headless = no player). (3) TAPEFIGHT1 once TELLS1 is in. (4) Scout trip + OPPPLAN1. The operator closes the HUD and move
player stills (board review, S345).
