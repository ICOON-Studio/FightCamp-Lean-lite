# S494 digest (2026-11-15)

## His board answers, acted on
- Q-253 rival club card "Build it": scripts/ui/ApproachCard.gd now draws option C made simpler (docs/mockups/s493/overview/
  overview_C2.png): three answers MATCH IT / HALF EACH / LET THEM GO; each column = the outcome (stays / leaves Monday), the
  loyalty before -> after bar with the white mark at 50 (Gain inner class), the costs (red with a falling mark); the talk is one
  button above ("Talk to her first"). MOVE and PROMISE stay in Approach.answers, off the card (ON_CARD). The talk line keeps the
  real rule (landed = HALF EACH counts in full, +10 not +6), not the mockup's "+10 on any answer". Pronoun from Faces.sex.
  LET THEM GO reads Leaving.REP_LEAVE(_RANKED) and Loyalty.MOVES["teammate_left"] (the approach exit is Leaving.leave, not let_go).
  approach_wire_test checks three answers, no names in columns/offer, MATCH loyalty, LET GO leaves Monday, HALF names the
  team-mate's loyalty. Still: ops/previews/s494/approach/approach_overview.png.
- Q-252 Training K "Change more" + his mark 1 ("this is a training screen, opponents have nothing to do here, remove it and
  maybe move it in players tab"): Training K v5 (docs/mockups/s494/training_k/training_k_v5.png, generator make_v5.py) - win
  chance + ON FIGHT NIGHT panels gone, no win % anywhere; right column = THIS WEEK (moves, mastery bars with the Usable flag)
  + MORNINGS (stat gains); session tray in a morning row and an evening row. The win chance moves to the fighter's own page.
  -> board Q-255.
- Q-254 Miro empty slots "Yes": P0 redrawn - 12 surplus slots + 4 orphans (KNOWBOTS1 / rear uppercut cards stacked on other
  cards) deleted = his 16; 10 created, 28 updated. Ledger learn + trim done (card:now:20 not yet stamped: next redraw).

## Defects found and fixed
- His saved text size is Largest (settings.cfg text=3): the fighter Overview ran to 2111 px (boxer column 567 + attributes and
  glance 1528), cutting the top bar and the right column - before this card too. DarkOverview: name through TextScale.fit to
  LEFT_W, class line wraps, SIDE_W 440 -> 380, attribute bar floor 50 -> 34, change column 58 -> 50. Now 1852 min.
  The S491 audit (TextScale.overflow) checks words against their boxes, not a page against 1920 - a page-width check is missing.
- roster_slate_test red since S493 (palette made the Overview's TEXT/MUTED equal WoodKit's chalk inks, and the boxer column
  stands on the page with no slate): WoodKit.on_dark / ink read an "on_dark" meta; DarkOverview's boxer column sets it.
- UI.gd and BodyFigure.gd were 501 lines (file_limits red): one line each.

## Agents and seats
- PALETTEGUARD1 (Qwen, PR 319) collected by diff: tests/palette_guard_test.gd + baseline; baseline refreshed 868 -> 649 raw
  colours (S493's sweep); in tools/run_tests.sh; PR closed. Refresh with `-- write` after each palette file.
- STYLE5: already finished in S490 (final pts in S490_DIGEST); docs/STYLE5_RESULT.md in the checkout is an empty leftover.
- CLASH10 (Qwen) running, ETA 22:32.
- COACHSPEC1 round 4: Dola 8/8/7 (pass), John 7/6/6 (general 6: undefined second coach / R13 split / deal owner; members past
  the building, pads "saturate"; names and "he"; held pad night dominant) -> round 5 brief to Kalli (SQ190).
- LADDER1 v4 (Kalli SQ187: the player picks any ranked boxer; reach limit, pay by gap, the other side may refuse) -> critic
  briefs to Dola (SQ188) and John (SQ189), bar 7+.

## His video (Reddit)
- A fight-analysis web page (Alvarez vs McGregor): video + per-fighter strike log (time, hand, type, target, landed/missed/
  blocked, click to seek), a Show me filter, stance / strike pies, landed vs thrown, generated summary sentences, combinations
  and Vulnerabilities (e.g. right hook -> dropped right hand, 6 times). Told him: the page is easy; detecting strikes from TV
  footage needs a trained vision model; our sim already logs every punch, so the same page for our fights is screen work.
  Asked whether to design it.

## Tests
approach_wire, approach_ui, approach_contract, home_bout, pull_out_wire, roster_slate, wood_kit, text_scale, file_limits,
body_figure, palette_guard, golden_path: all pass. Export built.
