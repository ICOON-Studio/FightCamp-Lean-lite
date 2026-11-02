# Ludo round 37 - the fighter profile, Claude's verdict for the operator (S202, 2026-10-11)
Sources (Ludo verbatim): LUDO_ROUND37_S202_reply2a.txt (20.6k chars: overview + 3 tabs), LUDO_ROUND37_S202_reply2b.txt
(25.9k: quick-look card, scouting 0-3, redesign rationale, Godot node tree; cut inside the floor table), mockup
previews/ludo_r37/01_profile_overview_mockup_screen.jpg. Asked because you said (S202): "do not use
placeholders use the real designs , if you do not have one ask ludo to deliver it". Credits: 805 before.

## What Ludo designed - TAKE
1. FULL PROFILE SCREEN, 1920x1080 (opened from the fighter, replaces the S198 card grid):
   - top bar: back, breadcrumb, tabs OVERVIEW / TECHNIQUES / MEDICAL / TRAINING PLAN (gold underline), COMPARE + SCOUT REPORT;
   - identity banner: flag + origin, NAME in 32 px Chakra Petch caps with the nickname in gold, 4 slices (age, division
     + weight, record, stance), chips for morale / weight cut / composure, contract badge;
   - left column: a REAL-TIME 3D PORTRAIT of our fighter (chest up, warm key, cool fill, gold rim light), under it a front +
     back body silhouette whose 6 regions glow by wear (green -> lime -> amber -> orange -> red -> dark red, pulsing
     above 50%) with a % table beside it;
   - centre: the 9 attributes as cards 268x148 with a big number coloured by band (90+ indigo, 75-89 green, 60-74 amber,
     40-59 orange, <40 red), the change since last month, and a 20-SEGMENT TICK BAR (one segment = 5 points) with a
     white pin for a scouted opponent and a ghost mark for last month; under them a radar + potential/scouting panel;
   - right column: NEXT BOOKED BOUT banner (opponent, rounds, title, venue, date, camp week 5 of 8, button to the fight
     plan), camp panel (coach, cutman, this week's sessions, last spar read), contract + wants with patience pips,
     last-5 form badges (W/L circles);
   - colour tokens: charcoal #0B0E14 base, navy #12161F panels, gold #D69E2E accent, 1 px #1F2637 borders.
2. QUICK-LOOK CARD (410 px, opaque, the click on a fighter on the gym floor - replaces today's drawer): name + nickname,
   age/division/record, what he is doing now and how hard, stamina-today and worst-wear bars, the 9 numbers as a 3x3
   mono grid, training focus, next-bout pill, and OPEN FULL PROFILE. Drops portrait, body diagram, radar, contract, plan.
3. SCOUTING 0-3 on the same screen: 0 = public record only, radar covered by "assign a scout"; 1 = ranges; 2 = exact;
   3 = hidden injuries and weaknesses.

## Corrections (Claude) - why
- NO INVENTED NUMBERS: Ludo filled panels with data the game does not hold yet (purse in pounds, contract months, reach,
  date of birth, gameplan mastery %, recovery days per region, peak-age window, ceiling confidence, concussion index,
  hyperbaric/renal readouts, "sub-attributes" like LEFT HOOK 82). A panel shows only what the game really has; the rest
  stays hidden until a system feeds it. Nothing is a placeholder value.
- RADAR: Ludo's axis list has 8 axes and drops CHIN - ours has all 9.
- FONT: Ludo's body text is Inter, which the game does not ship; body text uses Chakra Petch Regular (headings) and
  JetBrains Mono (numbers), the two families already in the game.
- MEDICAL tab: the 6 regions + weight cut only (what we track); the orthopaedic/neurology ledger is parked as NEW.
- TRAINING PLAN tab: shows the game's own week and stations; Ludo's drag-and-drop Mon-Sat grid and the fatigue graph
  come after the existing plan screen is wired (no second plan system).

## Build order (nothing starts until you approve)
- PROFILE2A: the 410 px quick-look card on the gym floor (replaces today's drawer). Small, visible at once.
- PROFILE2B: the full OVERVIEW screen at 1920x1080 with the 3D portrait, body diagram, tick-bar cards, radar, right
  column - behind its own switch until you OK a still from the game.
- PROFILE2C: TECHNIQUES, MEDICAL (reduced), TRAINING PLAN tabs; scouting levels on the same screen.
Each closes on a still from the real game, opened by Claude, plus your OK.
