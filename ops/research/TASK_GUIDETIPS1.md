# TASK GUIDETIPS1 - a guide and tooltips at the level of the best-praised games (Fable session)

Status: OPEN (S532). Seat: a Fable session the owner starts himself (memory feedback_fable_sessions_owner_starts:
start_session ignores Fable). Discipline: boxing (the whole game's UI). Model: Fable.

## The owner's words (S532, 2026-11-20, playing the build)
- "assign a fable agent to for the tooltips (your tooltips do not explain things) and the guide, i want proper research on
  the best guides praised in games and try to match that level same for tooltips"
- On a coach card tile "$450 wage a week" / tooltip "Cost a week": "what is it for ? cost a week to do what"
- On "+$350 evening classes" / tooltip "Evening classes, a week": "why you repeat the description in the tooltip ? the
  tooltip should display explaining information"
- On "Camp: no time for one" (an amateur bout 19 days out, which needs no camp): "explain the tooltip"
- On the mastery bar (dark / light purple, a flag, a dashed box): "what are the small purple highlighted section on the bars ?"
- His example of a tooltip that still fails (Fighters roster, TIREDNESS): one line across the WHOLE screen - "Tiredness 38
  of 100. Under 50 is fresh. A fight and hard training raise it; a full rest day takes off about an eighth. Over 80 the next
  morning's training counts only 60%." Numbers piled up, no wrap, no "so what do I do".
- On the guide: "should the guide be structured a bit better like give the player time to explore the tabs". Today every
  page dims at once and a ring points at the next click (scripts/ui/GuideLight.gd); the old trainer says one line
  (scripts/rules/GuideLines.gd, steps in scripts/rules/FirstWeek.gd + FirstHour.gd, the strip in scripts/ui/FirstWeekStrip.gd).
- On time (S532, asked whether Continue should go day by day): "keep as is but explain all these things in the guide how they
  work". The guide must teach the clock: CONTINUE plays the days one by one up to the next stop (week end, the month bill,
  weigh-in, fight night, an offer or event), clicking it again pauses mid-week so you can check and change things, and how
  fast the days run is in Menu > Settings (scripts/state/Clock.gd next_stop/stop_now, scripts/ui/Shell.gd ~148-180). The
  same for every "how does this work" the owner hit today: tiredness, the mastery bar, camp vs fight week, the towel.
- On a move's tooltip ("Feint and draw" / tooltip "Feint and draw", Playbook): "would it be possible on this tooltip to have
  like a gif of the animation ?" YES: every move and step tooltip (Playbook, learn cards, Training pad cards) shows a small
  looping clip of the move, baked from the SAME clip the fight plays (scripts/fight3d/FightClips.gd; the bake tools
  tools/bake_hub_sprites.gd / bake_full_body.gd on the hidden desktop make sprite strips), played in the custom tooltip
  (`_make_custom_tooltip`, an AnimatedTexture or a frame strip). Light files: ~24 frames, small, one strip per move.
- Standing rules that bind this work: names only in headers (S448; the guide says "your boxer", "the opponent"; to-do row
  TITLES may name the boxer, S532 "To-do rows keep names"); game words, not jargon (S422); only actionable info (S398);
  nothing interrupts the player (S275); every mechanic wired and shown, critics 7+ (S425).

## Why earlier work did not land (read these, then go past them)
J52_TOOLTIPS_AND_TUTORIAL.md, J90_TOOLTIPS_PRAISED.md, K84_TUTORIAL_GUIDE_PANEL_PLACEMENT.md and
research/topics/ui_screens.md already surveyed games. The game still ships 248 `tooltip_text =` lines written one by one,
with no shared standard, no wrap width, no layout, no test. Research that ends as a document changes nothing: this task ends
in a STANDARD + a COMPONENT + a TEST + the screens rewritten.

## The job, in order
1. RESEARCH (cite each source with a link; real reviews, GDC talks, UX write-ups, player threads - what exactly was praised):
   - Guides/onboarding praised by players and critics: e.g. Into the Breach, Slay the Spire, Hades, Portal, Two Point
     Hospital/Campus, Frostpunk, Football Manager (the assistant + "?" help), Crusader Kings 3 (tutorial + nested tooltips),
     Civilization VI (advisor), Rimworld (learning helper), Against the Storm, Motorsport Manager. Find what each did that
     players named as good (pacing, letting the player explore, just-in-time help, optional, replayable) and what was hated.
   - Tooltips praised: CK3 / Victoria 3 nested tooltips (hover a word inside a tooltip), Path of Exile / Slay the Spire
     keyword tooltips, Football Manager attribute tooltips, Paradox "why is this number this number" breakdowns, Into the
     Breach previews. What makes a tooltip EXPLAIN: what it is, why it is this value now, what changes it, what to do.
   - Use `python ops/Tools/prior_research.py <terms>` first; REA is allowed on games the owner has installed (CLAUDE.md
     owner rule: read-only, findings in our own words, nothing copied).
2. THE STANDARD (ops/research/GUIDETIPS1_STANDARD.md): a tooltip template (what it is / why this value / what changes it /
   what to do about it - each line short), a max width (wrap; never a full-screen line), when to show a small breakdown
   instead of prose, keyword tooltips for game words (Tiredness, Mastery, Camp, Fight week...), what a tooltip must NEVER
   do (repeat the label, pile numbers, name a person). A GUIDE design: explore first (no dim on a first visit), the old
   trainer's one line about what a page is FOR, help on idle or on "Show me", optional and replayable, never blocking.
3. CRITICS: two fresh critics (Arena + Dola, the CRITIC_PACK.md + CRITIC_ACCESS.md opening, a CODE CHECK, each ending with
   the list to reach 10/10 and a drawn 10/10 page). 7+ from both before building; otherwise another round.
4. BUILD (after the owner's yes on the board with `--attach` the standard): one shared tooltip component (wrap width,
   layout, keyword links) in scripts/ui; the guide changes in GuideLight/GuideLines/FirstWeekStrip; then rewrite tooltips
   screen by screen (Home, Fighters roster, Fighter page, Training, Club/People, Money, Fights, Fight prep, Result), most
   hovered first. Files under 500 lines.
5. TEST: a test that walks the main screens and fails a tooltip that repeats its label, is under ~6 words, runs wider than
   the standard's width, or names a person; the guide tests (tests/guide_person_test.gd, guide_ends_test, first_week_test)
   stay green. Stills of the tooltips via the hidden desktop (`tools/layout_snapshot.gd`), opened and checked, sent to him.

## Contract
OWNS: ops/research/GUIDETIPS1_*.md, a new scripts/ui tooltip component, scripts/ui/GuideLight.gd,
scripts/rules/GuideLines.gd, scripts/ui/FirstWeekStrip.gd, the tooltip lines of the screens it rewrites, a new tooltip test.
Do NOT touch scripts/fight3d (METHOD line). Run only the tests the change touches (full suite is nightly).
REGRESSION: guide_person_test, guide_ends_test, first_week_test, first_hour_test, coach_areas_test, coach_check_test,
training_k_test, roster_rows_page_test.

## Prior research
J52, J90, K84, research/topics/ui_screens.md, S148_SCHEDULE_TUTORIAL_DESIGN.md, TASK_GUIDEFLAG1/2.

## What would a human do?
A UX designer plays the five most-praised games' first hour with a notebook, writes down what the help did at each moment,
then sits beside a new player of ours and watches where they hover and get lost.

## Prefab check
Godot's built-in tooltip is a plain grey box (J90: "unreadable"); `_make_custom_tooltip` gives a custom Control per node -
the component should use it. No asset-library tooltip addon matches nested keyword tooltips; check once and name the licence.

## The one trap
Writing a better DOCUMENT again. Done = the owner hovers the coach card's pay, the Fighters TIREDNESS column and the
mastery bar in the .exe and each one tells him what it is and what to do, in a wrapped box, and the guide lets him look
around before it points.
