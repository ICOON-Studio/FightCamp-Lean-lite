# UX audit, S442 (menus, the first hour, and the fight HUD)

Done by a UX pass for the owner's ask "a UX expert to audit game and make improvements". Seen on real screens rendered on
the hidden desktop (`tools/layout_snapshot.gd`, 46 stills, and `tools/fight3d_play.gd`, 14 fight stills), plus the
screen scripts. Before stills: `E:/FightCamp/tmp/uxaudit/before/`, `E:/FightCamp/tmp/uxaudit/hud/`. After:
`E:/FightCamp/tmp/uxaudit/after2/`, `E:/FightCamp/tmp/uxaudit/hud_after/`. Nothing committed.

## For the owner: the five things that would most improve the game for a player

1. **One set of numbers.** The same boxer is shown with three different stat lists (reception, camp, week review,
   scouting and World use 7 old names; her page uses the 10 attributes, 5 skills and mind; the roster uses
   Head / Hands / Guard / Cardio / Legs) and two "overall" numbers (60 on the roster, 59 on her page). "Cardio" and
   "Stamina" are the same thing with different numbers on one camp page. A player cannot trust numbers that change
   name between screens. Needs your call on one word: **Stamina or Cardio**. Picture: `docs/mockups/s442/ux/ux_a_one_number_language.png`.
2. **The fight screen hides the fight.** Two full-height body holograms (350 x 530 px each) stand over the ring, her
   state is shown three times (a box over the opponent's head, the name plate, a box in the bottom bar), and the
   small controls (2x, Skip round, Skip bout) are as loud as the score. Picture: `docs/mockups/s442/ux/ux_c_fight_hud.png`.
3. **The Money page carries five dead buttons** ("Not built yet" for four MMA coaches and the Cage) on the page read
   every month, and its price tags cut their own numbers. Fixed the cut numbers now; the dead rows need your OK to
   hide. Picture: `docs/mockups/s442/ux/ux_b_money_regroup.png`.
4. **Words that mislead.** "3-1 Nationals ready" when she is not ready (it is the next step); "Scout to narrow" on an
   amateur offer that has no scout button; "Leave it" beside a greyed "Leave" button; a fixture reading "A Bout Offer
   Arrives (lucy)". All fixed now (list below). Some live in the rules files I may not touch (listed for the next
   session).
5. **Small type.** The game's floor was 15 px; you said "fonts are small". The floor is now 16 px everywhere the shared
   kit draws text, and the 11-15 px buttons are 16 px. The one important button on a screen now breathes slowly
   (your "slowly expand and shrink" ask).

## The nine rules from the video, scored

Pass / Partly / Fail, with evidence and the fix. "Menus" = all the 2D screens; "HUD" = the live fight and the corner.

| # | Rule | Menus | Evidence | HUD | Evidence | Fix |
|---|---|---|---|---|---|---|
| 1 | Limited colour palette | **Fail** | 197 distinct hex colours and 239 more `Color(r,g,b)` literals across 172 scripts in `scripts/ui` (count below); four different reds (#e2483d, #e0503c, #c8312a, #e0503c-ish chip red), four golds | Partly | the HUD keeps red/blue corners + gold/green/blue bars, but each meter has its own colour | Set below; a palette file is a proposal, not done (it touches every screen) |
| 2 | Contrast UI vs background | Partly | slate cards on dark gym photo read well; the Money page's italic hand-font text on slate is low; the 3D corner clock was muted brown on black (fixed) | Partly | plates on the ring are fine; the corner card was 88% opaque and a rope highlight crossed its numbers (raised to 95%) | fixed the two worst; rest in the HUD proposal |
| 3 | Consistent font and buttons | **Fail** | 28 distinct literal font sizes (11 to 138 px), 19 button/panel variations; the same action has different words ("Start week" vs CONTINUE, "Plan the week" vs "Training") | Partly | HUD labels lower case ("energy / legs / guard") beside caps elsewhere | 16 px floor done; type scale proposed below |
| 4 | Highlight the selected button | Pass | tabs (cream + red edge), Rows/Cards, camp choices, pace/aim pills, the selected day all lit | Pass | the chosen call is lit, the round being scored has a gold dashed box | nothing to fix; one shared hover style is in the hover-label proposal |
| 5 | Prioritise most-used interactions | Partly | CONTINUE / NEEDS YOU top right on every screen: good. The week's "Start week" duplicates CONTINUE; Home is a picture with hotspots and the needs are only in the top-right button | Pass | calls are the biggest controls | Home layout is an approved design; noted, no change |
| 6 | Obvious what to do next | Partly | NEEDS YOU always says it. Fails found: the 2D corner page cut its only way on (the calls) below the screen; a greyed "Leave" button on every untouched week; "Scout to narrow" with no scout button | Partly | the corner minute's last step ("pick the plan, it starts the round") is clear; nothing says how long the minute has left except a small clock | fixed all three menu fails now; the pulse marks the one decision |
| 7 | Subtle animation | Pass | bars tween, cards arrive, rows hover-grow, now the one decision breathes | Pass | bars and the clock animate | Pulse added |
| 8 | Group similar, logically | Partly | Money page mixes books, shopping, staff, deals and four "not built" coaches in three columns; the fighter page splits body numbers between "Attributes" and "Body" | **Fail** | her state in three places; landed/your calls/state box/heard dots spread over one bar | Money and HUD proposals |
| 9 | Hide non-essentials until needed | Partly | "Not built yet" rows, MMA tab, "5 prospects scouted" footers, legends under every table | **Fail** | 2x / Skip round / Skip bout always full bright; two holograms always up | hover-label proposal (secondary buttons only) |

### Rule 1 and 3, counted (scripts/ui, S442)
- Colours: 197 distinct `Color("#xxxxxx")` values plus 239 `Color(r, g, b)` literals. Most used: #ffd54a (10), #e2483d (8),
  #6cc27a (7), #e0503c (5), #2f6fdb (5), #efe6d8 (5), #f0a020 (4), #b8a88f (4), #1f2a44 (4).
  **Limited set proposed (12):** ink #241f1a, chalk #efe6d8, soft #b8a88f, slate #24262a, wood #6b4a2b, panel cream #f6efe0,
  red corner / danger #e2483d, blue corner / primary #27589e (light #6f9cf0 on dark), green good #2fb56e, amber warn #d97a00,
  gold accent #f2c14e, elite purple #8a5cf0. Every other literal maps to one of these.
- Font sizes used as literals: 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 24, 26, 27, 28, 30, 32, 34, 38, 44, 46, 48, 50,
  52, 56, 64, 138 (28 sizes). **Scale proposed (7):** 16 small, 19 body, 22 emphasis, 28 heading, 36 big number, 52 page
  title, 64+ display only.
- Button styles (theme variations in use): Btn 59, BtnSolid 52, BtnQuiet 23, TabOn 8, Link 5, PillOn 4, ChoiceOn 3, Go 3,
  GhostDark 2, Ghost 1, Choice 1, FlagRed 1, RailOn 1 (+ Card, Modal, Note, Chip, Toast panels). **Proposed:** primary
  (one per screen), secondary, quiet, tab, pill, danger. Ghost/GhostDark/Link fold into quiet.
- Fonts: four families on screen (Permanent Marker titles, Kalam hand notes, Barlow body, Bebas in the fight). The video's
  Dead Cells lesson: Kalam at small sizes is the hardest to read (the Money price tags, the "Each week the tin shrinks"
  lines). Fixed the price-tag bodies to Barlow; the rest is in the palette/type proposal.

## Ranked findings

BLOCKER = a player can get stuck or misled into a wrong decision. MAJOR = costs understanding or many clicks. MINOR = polish.
Stills: B = before (`tmp/uxaudit/before`), H = fight (`tmp/uxaudit/hud`).

| # | Rank | Screen | Finding | Where | Fix | Status |
|---|---|---|---|---|---|---|
| 1 | BLOCKER | Fight night, corner page (2D, after a skipped/simmed round) | the page ran past 1080: the calls - the only way to the next round - were below the screen, no scroll | B 19b_corner1; `scripts/ui/modals/FightNight.gd:31-51` | the corner page scrolls inside a 1040 px frame | **fixed** |
| 2 | MAJOR | Every screen with numbers | three stat vocabularies, two overall numbers (60 vs 59), Cardio vs Stamina with different values on one camp page | B 04, 06, 08, 09, 14, 34; `scripts/ui/AttrBoard.gd`, `RosterRow.gd` (rules), `CampCard.gd:71` | one block (proposal A); your word: Stamina or Cardio | proposal |
| 3 | MAJOR | Fighters roster | "3-1 Nationals ready" when she needs a 5th bout (it is the next step) | B 06_training; `scripts/ui/RosterRows.gd:118` | "Next: Nationals ready" | **fixed** |
| 4 | MAJOR | Fights, amateur offer | "Scout to narrow" under the win band; amateurs cannot scout an offer | B 10_offers; `scripts/ui/OfferCard.gd:87` | "Camp film narrows it" | **fixed** |
| 5 | MAJOR | Training tab | the coach's line "Leave it" beside a greyed "Leave" button on every untouched week (a dead button, and the same word) | B 06b; `scripts/ui/WeekBoard.gd:396,428` | line: "The week is right as it is"; button: "Back to the coach's week", shown only when there is a change to undo | **fixed** |
| 6 | MAJOR | Money | price tags cut the one number that matters ("Week -$309 to -$..."); 4 MMA coaches + Cage as "Not built yet" dead buttons | B 26_money; `MoneyTags.gd:99`, `MoneyPanels.gd:105`, `ClubSpend.gd:167` | tag shows "-$362 a week", the full line on hover (fixed); hide the not-built rows (needs your OK, proposal B) | partly fixed |
| 7 | MAJOR | Fight HUD | full-height holograms over the ring; state shown 3 times; small controls as loud as the score | H p02, p06c; `scripts/fight3d/SidePanel.gd`, `CornerBar.gd`, `FightHud.gd` | proposal C | proposal |
| 8 | MAJOR | Fighter page | the page is ~25 px wider than the screen at week 2 and after the first fight: the Menu button and the right cards are cut at the edge | B 09_fighter, 23_record (headless OFF FRAME Shell 1945 px; 2055 px on Playbook > combos) | not found in a headless width probe at day 7 / 30 (it only appears in the snapshot's flow); needs a windowed probe | **open** |
| 9 | MAJOR | Money | the page needs 1188-1194 px in a 1001 px frame (menu_money_test fails the same way before and after this audit) | `tests/menu_money_test.gd:154` | proposal B fits one screen | open (pre-existing) |
| 10 | MAJOR | 3D corner | the corner card was 88% opaque; a rope highlight crossed its numbers | H p05_corner_card; `scripts/fight3d/CornerOverlay.gd:84` | 95% | **fixed** |
| 11 | MAJOR | 3D corner | the top-left clock "CORNER 0:51 ROUND 2 NEXT" was 16 px muted brown on black | H p05; `CornerOverlay.gd:69` | 19 px, light soft ink | **fixed** |
| 12 | MAJOR | Coach says (roster) | the tag says DRILL on "Scout the opponent" and "Write a game plan", FIX on "Find a bout" | B 15, 16; `scripts/rules/RosterRow.gd:172-174` (rules: not mine to edit) | tags by kind: PLAN / BOOK / DRILL / REST | **for the rules owner** |
| 13 | MAJOR | Result | "Tank at the last bell" and "8 of the tank" (jargon; the HUD says Energy) | B 21_result; `scripts/rules/FightStats.gd:56`, Why lines | "Energy at the last bell" | **for the rules owner** |
| 14 | MINOR | All screens | 15 px floor; 11-15 px buttons on Money, week, drill, mat map, area tabs | `UI.gd:44-45`; `AreaHead.gd:75`, `MoneyPanels.gd:359`, `MoneyTags.gd:150`, `WeekCards.gd:255,381`, `WeekDay.gd:32`, `DrillCard.gd:120`, `MatMap.gd:218,237`, `MatTree.gd:204` | 16 px | **fixed** |
| 15 | MINOR | Roster | weight caption cut "59.8 kg on th..." | B 15; `RosterRows.gd:225` | "Day: 59.8 kg" (over: "Day: 1.2 over"), the full line on hover | **fixed** |
| 16 | MINOR | Fights > fixtures | "A Bout Offer Arrives (lucy)": capitalize() title-cased the line and lower-cased the name | B 40 (behind the modal); `Fixtures.gd:27` | first letter only | **fixed** |
| 17 | MINOR | Roster (no-gi) | "Her class on the mats" (pronoun) | `RosterRows.gd:202` | "The class on the mats" | **fixed** |
| 18 | MINOR | Week review, fight prep, drill cards, week camp, week board | ASCII "->" | `WeekReview.gd:99,116`, `DrillCard.gd:175,194`, `FightPrep.gd:155,159`, `WeekCards.gd:173,253`, `WeekCamp.gd:170,223`, `WeekBoard.gd:470` | "→" | **fixed** |
| 19 | MINOR | Camp, card flip, game plan, combos | ASCII "->" asserted by tests | `CampCard.gd:71`, `CampSide.gd:80`, `FlipCard.gd:132,174`, `GamePlan.gd:282`, `ComboStrip.gd:121`, `MatchupCards.gd:115`, `CornerJobsRow.gd:209` | "→" | **left: tests assert it** (see below) |
| 20 | MINOR | Fight HUD | "YOUR CALLS: Draw the" - the call name is cut | H p06c; `scripts/fight3d/RoundBoard.gd:113-118` | needs 16 px or a wider column; round_board_test demands 20 px | **left: test asserts 20 px** |
| 21 | MINOR | Result | the Learned tile cuts its line ("Real...") | B 21_result; `AftermathTiles.gd` | two lines or a hover | open |
| 22 | MINOR | Pro offer | "BBBofC licence", "Fighter's half of the 6 past 60" | B 40_prooffer; `modals/ProOffer.gd` | "Boxing licence", "Her half of the tickets past 60" | open (wording to check with the numbers) |
| 23 | MINOR | Week review | "Gold award: 8/8 sessions", "Bleep test 8.3 → 8.3" (jargon, no action) | B 39; `WeekReview.gd:116` | cut or hover | open |
| 24 | MINOR | Interview / Club staff | "Lucy, pad work: moves +24.3 → +31.1 a week" (what unit?) | B 05_gym_staff | "Pad moves gain 31 a week instead of 24" | open |
| 25 | MINOR | Mail | 34 unread at week 15: Mail opens World News and nothing marks it read on that path | B 40 top bar | mark read on open | open |
| 26 | MINOR | Home | the art has an "MMA GYM" sign; boxing and BJJ only at launch | B 03_home_start | art fix (Ludo) | open |
| 27 | MINOR | Cash chart | event pins draw 11 px digits in a 16 px disc | `CashChart.gd:47` | 20 px disc + 16 px | open (icon, kept) |
| 29 | MAJOR | 3D corner, "One change" row | with four changes on offer ("Elbows in", "Gloves high", a habit fix, "Leave it") the fix card's second line runs under "Leave it" | `hud_after/p05_corner_card.png`; `scripts/fight3d/CornerOverlay.gd` / `CornerMinute.gd` row | two rows, or "Leave it" as a small quiet button under the row | open (layout) |
| 30 | MAJOR | 3D corner card | the card is still see-through in the still 0.6 s after it shows (the 0.4 s fade starts after the camera cut); a rope highlight runs across its numbers | `hud_after/p05_corner_card.png`; `CornerOverlay.gd:41` CARD_FADE_S, `:84` | the opacity fix (95%) only shows once the fade ends; a darker scrim behind the card while it fades | partly fixed |
| 28 | MINOR | Fight intro | "FIGHT NIGHT" 16 px muted at top left | H p01; `CornerOverlay.gd:167` | same fix as #11 (shared label) | **fixed with #11** |

## The fight HUD (scope added by the owner: "and HUD too if can do both")

Seen: `E:/FightCamp/tmp/uxaudit/hud/p01..p08` (real flow, round 1 and 2 live, the shout bar, the corner card, the result).

- **One glance?** The round and time: yes (big clock, round dots, R1/R2/R3 cards). Who is winning the round: yes ("LANDED
  5 - 2" and the card colours). Energy: yes, top bars with numbers. Hurt: only as "EYE" / "RIBS" words in the plate
  corners and numbers on the holograms - easy to miss. What the corner can do now: yes, three calls with Works / Beats it /
  Risky and their cost.
- **Covers the fighters?** The two holograms do not cover them on the broadcast camera, but they take ~37% of the width
  and on the layout-snapshot camera (B 20_round3) the right one stands over the blue boxer. The "Waiting to counter" /
  "Draw the lead" boxes sit just above the heads and touch the gloves on a guard (H p06c).
- **Text over 3D:** plates are dark enough; the lower-case "energy / legs / guard" and the cut "Draw the" are the defects.
- **His rulings kept?** "Risky" not "Wrong": yes. Words, not symbols, on the corner bar: yes. Calls small on the left with
  the live round board: yes. Halo glow, not flat borders: the state boxes over the heads are flat bordered boxes.
- **Cannot be acted on:** "Heard 0 of 3" dots and "lasts to R3" are explanations (keep, hover); "EYE" / "RIBS" alone does not
  say what to do (the corner card does).
- Fixed now: the corner clock and intro label contrast (19 px, light ink), the corner card opacity (95%).
- Proposal C (drawn): small body maps in the name plates, her mode once (on her plate), the speed/skip controls at 35%
  that light up near the mouse, labels in caps.

## Fixes made (17 files)

| File | What changed |
|---|---|
| `scripts/ui/UI.gd` | text floor and TINY 15 → 16 px (every `UI.label` / chip / pill) |
| `scripts/ui/AreaHead.gd`, `WeekCards.gd`, `WeekDay.gd`, `DrillCard.gd`, `MoneyPanels.gd`, `MoneyTags.gd`, `MatMap.gd`, `MatTree.gd` | 11-15 px button text → 16 px |
| `scripts/ui/MoneyTags.gd` | price tag: "-$362 a week" (full line on hover); tag body in Barlow so two whole lines fit at 16 px |
| `scripts/ui/RosterRows.gd` | "Next: <step>" on the road word; weight caption "Day: 59.8 kg"; no pronoun; the first urgent DO NEXT breathes |
| `scripts/ui/OfferCard.gd` | "Camp film narrows it" |
| `scripts/ui/Fixtures.gd` | sentence case, names kept |
| `scripts/ui/WeekBoard.gd` | coach line and the undo button (shown only when there is something to undo); arrow |
| `scripts/ui/modals/WeekReview.gd`, `FightPrep.gd`, `WeekCamp.gd` | arrows |
| `scripts/ui/modals/FightNight.gd` | the corner page scrolls when it runs past the screen |
| `scripts/ui/modals/WeighIn.gd` | "Step on the scale" breathes |
| `scripts/ui/areas/Fights.gd` | the first safe offer's Open breathes |
| `scripts/fight3d/CornerOverlay.gd` | clock / intro label 19 px light ink; corner card 95% opaque |
| `scripts/ui/Pulse.gd` (new, 72 lines) | the breathing helper |
| `tests/pulse_test.gd` (new) | its test |

Before / after stills: roster `before/15_fight_camps_real.png` → `after2/15_fight_camps_real.png` (Next:, Day:); training
`before/06b_guide_go_real.png` → `after2/06b_guide_go_real.png` (no dead Leave); offers `before/10_offers_real.png` →
`after2/10_offers_real.png`; money `before/26_money_real.png` → `after2/26_money_real.png` (tags whole); corner
`before/19b_corner1_real.png` → `after2/19b_corner1_real.png` (scroll bar, calls reachable); weigh-in mid-pulse
`after2/16_weighin_real.png`; 3D corner `hud/p05_corner_card.png` → `hud_after/p05_corner_card.png`.

## Pulse: which button breathes, and why (owner: "slowly expand and shrink to draw players eyes")

`scripts/ui/Pulse.gd`: scale 1.00 → 1.04 → 1.00 over 1.6 s, sine, about the centre; never changes size; stops on hover
(resumes when the mouse leaves), stops for good on press, never runs on a disabled or hidden button, back to exactly 1.0
when it stops. There is no reduced-motion setting in `Settings.gd` today; the file names where to check one when added.
Kept as its own file (not in MenuFx.gd) so the rule "one pulsing button per screen" has one home and one test.

| Screen | Button | Why this one |
|---|---|---|
| Fighters > Roster | the first DO NEXT that is urgent (style "Go") | the most urgent fighter's decision; never two rows |
| Fights | Open on the first safe offer | an offer waiting for an answer, with a deadline; unsafe offers never pulse |
| Weigh-in | Step on the scale | the only thing to do; the clock waits on it |
| Not pulsed | Bout page Accept / Pass | pulsing one would push the answer |
| Not pulsed | Corner minute calls | every call is a choice of equal weight; the coach already stars one; and the brief allows only defect fixes in `scripts/fight3d` |
| Not pulsed | Start week, CONTINUE, tabs, Back | excluded by the brief (CONTINUE already says what it stops for) |
| Not pulsed | Home | the need is the red hotspot and the top-right NEEDS YOU; a second pulse would compete |
| Not pulsed | Result page | its "Train X next week" fix did not show in the stills; add it when it does |

## Hover labels (Hades idea, as a proposal) - read with `ops/research/HADES_UX_VIDEO_S442.md`

In Hades only five small secondary icons hide their word (it appears at once on hover); Play / Options / Quit always keep
theirs. For FightCamp:
- **Keep words, always:** the big button (NEEDS YOU / CONTINUE), each row's main action, tabs, page titles, the corner bar's
  calls (your ruling "words, not symbols"), the bout page's Accept / Pass, anything on the first day.
- **May hide the word after 3 uses** (shown at once on hover or keyboard focus, 0.05 s after the mouse stops): back / forward,
  Home, Mail, Menu, a row's small tools (notes, fight plan, scout), the fight's speed / skip / view. A new button arrives
  with its word. Setting: "Always show button labels" (off by default).
- **Per screen:** Home (top bar icons only); Fighters (row tools; DO NEXT keeps words); Fighter page (tabs keep words;
  small tools may hide); Fights (Accept / Open keep words); Club / Money (Buy / Hire keep words; the cash-book tabs keep
  words); World (tabs keep words; filter chips may hide); fight HUD (calls, pace, aim keep words; 2x / skip / view at 35% and
  labelled on hover).
- Drawings: `docs/mockups/s442/ux/ux_d_hover_labels_menu.png` (top bar and roster, at rest and on hover),
  `docs/mockups/s442/ux/ux_c_fight_hud.png` (the HUD with the hover inset).

## Proposals (layout changes: his pick)

| Proposal | Picture | Solves |
|---|---|---|
| A. One set of numbers on every screen | `docs/mockups/s442/ux/ux_a_one_number_language.png` | #2; needs his word Stamina / Cardio |
| B. Money regrouped: books, in and out, what you can buy now, deals and staff; not-built rows gone | `docs/mockups/s442/ux/ux_b_money_regroup.png` | #6, #9, rules 8 and 9 |
| C. Fight HUD regrouped, chrome at 35% with labels on hover | `docs/mockups/s442/ux/ux_c_fight_hud.png` | #7, #20, HUD rules 8 and 9 |
| D. Hover labels for secondary buttons, at rest and on hover | `docs/mockups/s442/ux/ux_d_hover_labels_menu.png` | rule 9, the Hades idea |

## Tests run (headless, one at a time through godot_slot)

pulse_test `PULSE failures=0`; roster_rows_page_test `PASS roster_rows_page_test`; menu_world_test `MENU_WORLD failures=0`;
camp_cards_test `CAMP_CARDS failures=0`; week_board_clarity_test `WEEK_BOARD_CLARITY PASS`; weigh_forecast_test
`WEIGH_FORECAST failures=0`; review_reveal_test `REVIEW_REVEAL PASS`; test_pad_review `PASS`; drill_card_test
`DRILL_CARD PASS`; corner_card_test `CORNER_CARD PASS fails=0`; hud_shown_test `failures=0`; round_board_test
`ROUND_BOARD failures=0`; bjj_tree_ui_test `BJJ_TREE_UI failures=0`; nocamp_page_test `NOCAMP_PAGE failures=0`;
tape_rows_test `TAPE_ROWS failures=0`; membership_why_test `MEMBERSHIP_WHY failures=0`; file_limits_test
`FILE_LIMITS failures=0`; dues_card_test `DUES_CARD failures=0`; dues_wire_test `DUES_WIRE failures=0`;
fight_polish_test `FIGHT_POLISH checks=9 failures=0`.
**menu_money_test fails** (`content height 1194 <= visible 1001`): it fails the same way with the old 15 px floor
(1188 px), so it is not caused by this audit; proposal B is the fix.
Second batch (after the later fixes): week_board_clarity_test `WEEK_BOARD_CLARITY PASS`; week_coach_test `WEEK_COACH PASS`; ko_continues_test `KO_CONTINUES failures=0`; corner_jobs_test `CORNERJOBS failures=0`; golden_path_test `GOLDEN_PATH failures=0`; menu_money_test still the pre-existing fail above.

## Words tests assert, so left as they are
- "->" in `CampCard.gd:71` (camp_cards_test:72,96), `FlipCard.gd:132` (card_flip_test:100), tie-up / game plan arrows
  (tieup_panel_test:106,122, tieup_plan_test:213,258), `cardio_camp_test.gd:72` ("-> %.1f by fight night").
- The round board's call names must be 20 px or more (`round_board_test.gd:34`), so "Draw the lead" stays cut until the
  column is wider (proposal C).
- Coach tags must be FIX / REST / DRILL (`roster_rows_page_test.gd:161`); the wrong tags live in `scripts/rules/RosterRow.gd`.
- `menu_world_test.gd:35` asserts the MMA tab's "Not built yet" tooltip.

## Could not see or check
- The fighter page's ~25 px overflow cause (#8): a headless probe at day 7 and day 30 did not reproduce it.
- The Home notice board / "More below" content and the Result page's "Train X next week" button: not in the stills.
- The knockdown count and the intro cards in motion: the fight flow ran without a knockdown.
- Keyboard focus states: not checked.

## Numbers that move (owner's question on animated numbers, S442)

The rule agreed: a number, bar or graph that CHANGES in front of the player moves to its new value in 0.3-0.6 s, never
blocks input, is skipped by any click, tints green (up) or red (down) for a moment; only values that just changed move,
not everything on a screen opening. Counters roll, bars slide, graphs draw in left to right. No glow or particles on
routine bars; those are for milestones.

**The helper:** `scripts/ui/Tally.gd` (104 lines, pure static). `Tally.number(label, key, value, fmt)` rolls a counter,
`Tally.bar(bar, key, frac)` slides any control with `frac` (the existing `Bar.gd`). It remembers the last value the player
saw by a stable key (screens rebuild on every action, so the label is a new node each time). The first sight of a key
(a screen opening, a new or loaded career) is set at once. A second call ends the running roll and starts from where the
player saw it (never two tweens). Any mouse click ends every roll at its value (a small `TallySkipper` node on the root).
0.45 s, cubic ease out, green/red tint fading out over the same time. Headless runs (tests) set the value at once.
There was no shared bar-tween helper to reuse: `MenuFx.count` counts up from 0 on every open (the opposite of the new
rule) and each screen tweens its own bars (`BoutCompare.gd:41`, `FighterCard.gd:91`, `WeekReview.gd:243`, `ReadPanel.gd:51`,
`RosterRowBits.gd:269,294,320`). Tally is the one helper for values that change; those open-time grows were left alone.
Test: `tests/tally_test.gd` (first sight is instant, a change rolls through the values and stops on the target, the tint
clears, a rebuilt label carries on from the last value, a second call retargets without stacking, skip and a click jump to
the end, a bar slides, a freed label does not crash).

**Where a value snapped, and what was done**

| Place | File:line | Changes when | Done |
|---|---|---|---|
| Top bar cash | `scripts/ui/Shell.gd:189` | every buy, hire, deal, repair, bill, each day | **rolls** (key per career) |
| Top bar "running -$N a week" | `scripts/ui/Shell.gd:197` | hire, stipend, deal, kit budget | **rolls** |
| Money tiles: cash, members, net a week, next bill | `scripts/ui/areas/Money.gd:102-121` | the same actions on the page | **rolls** |
| Money tile "money lasts N weeks" | `scripts/ui/areas/Money.gd:110` | the same | snaps (it can read "grows"; a word, not a count) |
| Money "In / Out, a week" bars and totals | `scripts/ui/areas/Money.gd:189` (`_col`) | kit budget, stipend, deal | snaps: next to wire (`Tally.bar` per line key) |
| Price tag "-$N a week" | `scripts/ui/MoneyTags.gd:99` | kit budget, any buy | snaps |
| Cash chart | `scripts/ui/CashChart.gd:55` (`_draw`) | each week | drawn at once: should draw in left to right on the new week only |
| Roster big numbers + bars (tiredness, mood, weight) | `scripts/ui/RosterRows.gd:194-199, 215-227` | each day, Hold/Cut | numbers snap; the bars grow from 0 on EVERY open (the old house rule; against the new "only what changed" rule) |
| Week board tiredness graph and "peaks Friday at 46" | `scripts/ui/WeekTired.gd:144, 317` | every edit of a day | redraws at once: should slide the line to the new shape |
| Week board pad mastery "0 → 11" | `scripts/ui/WeekCards.gd:173` | every drill card moved | snaps |
| Staff page tiles (places, classes income) | `scripts/ui/StaffCard.gd:246, 259` | hire / let go | snaps |
| Fight HUD energy / legs / guard numbers | `scripts/fight3d/SidePanel.gd:296-306` | every exchange | snap with the bars; HUD scripts outside the allowed list for this change, left |

**Milestones: where a celebration belongs (proposal; glow and particles only here)**

| Moment | Today | Proposal |
|---|---|---|
| A goal met | the goal ring reads MET; a toast | a gold glow round the goal card, once, on the day it is met |
| A move reaches Usable / Sharp / Signature | the week review flips the pad card (`FlipCard.gd`, the only one celebrated) | keep; add the same flip on the fighter page the first time it is seen |
| A skills award passed (gold, platinum) | `PassedStamp.gd` stamp in the week review | keep |
| A perk opens | the text "(open)" on the perk road (`FighterPage.gd:107`) | a gold card turning over on the week review |
| First win / a ranking reached (enters the regional table at 4 wins) | a line in the result page and the Why | a gold rank badge sliding in on the result page |
| Peak camp made | a word in "What decided it" | a gold stamp on the result page |
| Nationals: through a round, a title | bracket line moves | gold glow on the bracket winner, a title card |
| Turning pro (the debut signed) | the pro offer modal | the poster reveal already used for an accepted bout |
| BJJ stripe / new belt | a toast | the belt sliding onto the road picture |
| First week the gym makes a profit / money lasts "grows" | nothing | a green glow on the NET tile once |
| A sponsor signed | a toast | a logo dropping onto the wall, once |

Tests and stills for this section: see the end of this file.

**Tests and still (numbers):** tally_test `TALLY failures=0`; golden_path_test `GOLDEN_PATH failures=0`; menu_world_test
`MENU_WORLD failures=0`; dues_wire_test `DUES_WIRE failures=0`; menu_money_test the same pre-existing overflow fail.
Still `E:/FightCamp/tmp/uxaudit/after3/24_deals_real.png`, taken just after signing the sponsor: the top bar's "running"
line and the NET A WEEK tile are caught mid-roll at -$424 on the way from -$607 to -$357, tinted green (up).
