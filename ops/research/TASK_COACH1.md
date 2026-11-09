# TASK COACH1 - CURSOR (Grok 4.7 High) - what a coach is good at, and a staff screen that says so

Status: OPEN (S411, Claude main). Discipline: boxing. Model: grok-4.7-high.

## Contract
OWNS: scripts/rules/CoachAreas.gd, scripts/ui/StaffCard.gd, scripts/ui/areas/Gym.gd, scripts/rules/WeekPlan.gd, scripts/state/Sim.gd, scripts/state/Data.gd, tests/coach_areas_test.gd
RED_TEST: tests/coach_areas_test.gd -> COACH_AREAS failures=0
REGRESSION: week_plan_test, training_week_test, plan_board_test, first_week_test, golden_path_test, save_load_test, balance_harness_test, plain_words_test, no_pronoun_test, grey_reason_test, file_limits_test
VISUAL: stills, opened by Claude after landing

## Read first
ops/research/MENU_BUILD_RULES.md (binding, items 14-22 above all), scripts/ui/RosterCards.gd and scripts/ui/VersusPanel.gd (the look), scripts/ui/areas/Gym.gd coach card (line ~132 on), scripts/state/Sim.gd coach_rating, scripts/rules/WeekPlan.gd (`ctx.coach`), scripts/rules/StaffRoles.gd. ops/research/GDSCRIPT_TRAPS.md. Sim.gd is at the 500-line limit: new code goes in CoachAreas.gd.

## Prior research
Owner, on the coach card: "i do not understand what training quality 91 : means , i do not know what this coach is good at , make this porperly"; "they need to show what they impact on the game(what they train better by how much etc)". Claude checked the code: `spec` ("Pad work") is display text only. A coach has one rating, and every session uses it through 0.5 + rating x 0.7 / 100. Concept (look only; its numbers are invented): docs/mockups/s411/staff/concept.png.

## What would a human do?
Ask what this coach is good at, and what my boxer would get out of it.

## Prefab check
RosterCards, VersusPanel, MenuFx.set_wall, KitIcon, Faces. No new art: the head photo, large, until staff full-body renders exist.

## The rule
scripts/rules/CoachAreas.gd, pure:
- `AREAS`: pads, bag, conditioning, strength, sparring. `area_of(session_id)` covers every session in WeekPlan: roadwork, intervals, mobility -> conditioning; strength, neck -> strength; heavy_bag, speed_bag, shadow, slip_rope -> bag; pads -> pads; sparring -> sparring. Rest has none.
- Each coach in Data.COACHES gets `areas`: Luke Reid {pads 74, bag 64, sparring 58, conditioning 48, strength 46}; Marcus Hale {conditioning 90, strength 84, bag 72, sparring 66, pads 58}. **Their average equals the coach's overall rating exactly (58, 74)**, so the career balance holds. Overall stays what fight-plan lines read.
- `rating_for(coach_or_empty, session_id) -> float`; no coach = the existing alone value.
- WeekPlan and the session gain read the area's rating instead of the single number, wherever the coach factor is applied. Trace every use of `ctx.coach` and of `coach_rating`.
- `lift(rating) -> float`: how much more a session teaches than training alone, as a percentage: (0.5 + r x 0.7 / 100) / the alone factor - 1.

## The screen: Club > People
Drop "Training quality 91% (alone: 60%)" and the rows of text. Each coach is a card in the Fighters and Versus look, painted surface behind the page.
- The face, large; the name in the brush font; the job as a small tag.
- **One bar per area**, sorted strongest first, with a big "+67%" (the lift, against training alone) and the area's icon. The best area is marked "Best at".
- **On your boxer**: under the bars, for the fighter next in line, the real weekly number from WeekPlan with and without this coach for the best area: "Lucy, pad work: +0.16 → +0.27 a week".
- Fight-plan lines as a tile: 6 lines (hover: how many lines you can write in a plan). Cost a week, evening classes and net as three small tiles.
- Unhired coach: the same card with Hire and the signing fee. A coach you can compare: two cards side by side when two are on offer.
- The other staff (strength coach, physio, second coach, cutman) are the same kind of card, smaller, each with its one effect as a graphic tile, from StaffRoles' own numbers, and Hire. Your own head coach's edge stays on top.
BARS: words <= 110 on the People tab with one coach and four staff jobs; page bottom <= 1080, no scroll. `PageInk.read`. Print `STAFF_INK words=<n>`.

## Do
tests/coach_areas_test.gd first: averages equal the overall ratings; every WeekPlan session has an area or is rest; a pad session gains more with Reid than a conditioning one does; rating_for with no coach equals the old alone value; the lift numbers; the card exists by name, shows five bars sorted, "Best at", the boxer line equals WeekPlan's own numbers. Run REGRESSION. Change no number in an existing test. If balance_harness moves outside its bars, report the numbers.

## Rules
No file over 500 lines. Godot only through `python ops/Tools/godot_slot.py run --who cursor -- <godot cmd>`, headless, --audio-driver Dummy, never the console build. Nothing opens on the monitors. No his/her.

## The one trap
The Hire action and the guide's "Hire an assistant" step drive this page: keep the node names Hire_<id>, or the first week breaks while the card looks right.

## Result lines (PR body)
RESULT: tests/coach_areas_test.gd -> COACH_AREAS failures=0
RESULT: STAFF_INK words=<n>
