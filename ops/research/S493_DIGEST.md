# S493 digest (2026-11-15)

## His board answers acted on (Q-248..251, given after S492's start)
- Q-251 one palette, "do it and i will judge": `scripts/ui/Palette.gd` (19 colours by job, shade rules, bands, tiers,
  CLEAR, WALL_DARK). UI.gd / WoodKit.gd / TV.gd constants now read it (TV's 34 importers follow at once). Moved to zero
  loose colours: areas/Office.gd (family G, the navy desktop is now the gym look), the fight result menus (HeadlineCard,
  CornerSwapCards, TapeVersus, ResultTabs, CallButtons - the "now" shout is the red main-action button, no gold fill -
  ApproachCard, RecoverCards, BodyTip, SwapLink, AftermathTiles, MatchStats, Tally), DarkOverview (bands = the palette's
  band table), BodyFigure, Tips + the native tooltip (hover cards are dark HOVER with TEXT, no cream paper). On slate a fill
  green/red WORD becomes the lightened word colour (WoodKit._chalk) - 3.0:1 -> 4.6:1.
  Left (next session, worst first): WeekCards 34, HudRegroup 27, HudBars 26, RosterCards 22, ReadPanel 18, MatchupCards 16,
  MatMap 16, GrapplerPage 13, WhiteboardKit 13, RoundGraphics 12, HomeNeeds 12, DrillCard 12, then the small ones.
  Guard test: TASK_PALETTEGUARD1 queued on Qwen (counts raw colours per file, baseline only falls).
- Q-249 Training K "Change first": v4 drawn with his 3 marks (docs/mockups/s493/training_k/training_k_v4.png) - THIS WEEK
  two plain rows; rounded-square pictures (no crop); presets row + red bands gone -> board Q-252.
- Q-248 rival club card "c but make it simpler": docs/mockups/s493/overview/overview_C2.png - three answers, each: what
  happens to her, one loyalty bar (white mark = 50), the cost; talk-first one button -> board Q-253.
- Q-250 ladder "make it so player can decide whos the best opponent ... and apply rules": LADDER1 v4 brief to Kalli
  (SQ187): no script; the player asks any ranked boxer; rank-gap limit, worth by gap, the other side may refuse, mandatory /
  eliminator as rules; two fresh critics at 7+ before his board.
- Miro P0 redraw (16 empty slots) -> board Q-254.

## Design loop
- COACHSPEC1 round 3 critics: Kalli depth 6 / general 5 / play 5, Maria 7 / 6 / 6 -> round 4 written (map section 12):
  corner R10 (the club coach works every corner; edge floored at x1.00), staff growth cut (R11, leaving warned a week
  ahead), S&C load R12 (x0.85 tiredness on their mornings, taper -3 at the bell), class nights cost pad minutes R13,
  the payoff R14 (week review + fight log name the night you held), wins and members columns, roster break point; pronouns,
  names, Strength/Flexibility words, section order -> fresh critics Dola SQ185 + John SQ186.

## Plan lesson shown to the player (WHYGRADE1, S492)
- `PlanLines.blind(arrows, place)`: the situations a no-IF line walks into (PlanFight fit wrong) with no IF covering them.
  PlanChart's bell box puts an amber info icon on that row: "Walks into it when the opponent tires or the opponent is hurt.
  With no IF, this line is thrown whatever happens here: add an IF for that." plan_lines_test test 6.

## Nightly red plan_bots
- Same cause as WHYGRADE1: its GOOD plan had no WHEN. GOOD is now fight_why_test's 6-line WHEN plan, 3b-3 drilled.
  RESULT: PLAN_BOTS checks=35 failures=0 (plan+sim 0.548 vs coach 74 0.451 vs none 0.361; rule 4 still OPEN, -0.035).

## Clipping audit (CLASH7-9) -> CLASH10
- CLASH7's SkelPump (PR 313): hit_carry 34 failures, hit_frame 5 -> not taken, PR closed. CLASH8/9: one glove-on-glove
  frame per jab is left because the drawn glove axis turns after the push (diagnosis c). TASK_CLASH10 (Qwen, from main):
  clear glove-on-glove on the drawn axis, re-read after each push, up to 3 times inside the clash pass.
- PR 318 (WHYGRADE1) closed: collected in S492.

## Tests run this session (the ones the changes touch)
- Wave 1 (Palette/UI/WoodKit/Office): 14 PASS + wood_kit_test 1 FAIL = the intended change (red word on slate is now the
  readable red); the test now says so.
- Wave 3 (wood_kit, plan_lines, plan_chart, game_plan, plan_screen, fight_why): all pass.
- Wave 4 after the TV.gd default fix (golden_path + 25 fight-menu tests): all pass; body_figure_test re-run after the hit
  flash went back to white (BODY_FIGURE failures=0). Trap found by golden_path: a function default `= Palette.CLEAR` in TV.box
  broke 30+ fight scripts ("Could not resolve external class member") - signatures keep `Color(0, 0, 0, 0)` literals.
