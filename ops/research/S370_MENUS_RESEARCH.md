# S370 menus research - training, planning, booking, growth (what players want, what we have, what to fix)

Operator S370: "work more on the player experience, through the menus, make it clear how each menu works what info it
gives"; "use the miro to get the game logic and how it should be presented"; "assigning training, planning moves for the
fighter, booking the fight, how the fighter improves - all these need special attention"; "lets focus on the training and
planning aspect ... a fighter doesnt want to compete just learn and get stronger, faster - how we make the player feel the
goal"; ideas: "stitch moves like hollywood animal ... display the combo strength/stamina cost", "moves and strikes as cards".

Evidence: the playthrough guide (tools/guide_tour.gd + tools/guide_gif.py -> ops/previews/S370_guide/guide.gif, 30 steps,
an amber STILL UNCLEAR line per screen), two research passes (ours + praised games, sources below), Miro uXjVEV03QWA=.

## Miro rules every menu must meet (frame 5)
One area per job (six); tabs always visible, one level; every name opens its page; CONTINUE never moves and says where it
stops; must-answer items stop time and turn red; moments wait as flags, nothing opens by itself; Back always works;
EVERY NUMBER EXPLAINS ITSELF ON HOVER. Fighter's path (frame 4): walk-in -> sign -> first goal -> training weeks -> week
review -> offer -> bout page -> accept -> camp -> fight week -> weigh-in -> fight night -> result -> next goal.

## Praised games, the rules that matter (sources in the agent report; key URLs)
- Training: preview the effect before committing, show the actual after (FM14 put intensity controls in the report:
  whatculture.com FM2014 p6); never drop a stat without a named cause; few choices a week, no forced minigames (Fight
  Night Champion minigames called repetitive; Punch Club decay "makes the game grind": steamcommunity 394310); delegation
  real but slightly worse.
- Planning: the scouting report sits beside the plan, each lever names the threat it answers (FM opposition
  instructions, passion4fm); familiarity/mastery visible with a hover why; 3-4 corner options with visible effect
  (WCBM2 reviews: satisfying but "why can't we yell instructions?"); hunt dominant builds (Punch Club one build wins).
- Booking: one offer card says it all (record, style, ranking, purse, camp length, staff risk with an uncertainty band
  that narrows with scouting - FM black stars, fmscout); show both outcomes; mark unknowns; few terms, real trade-offs;
  the ladder always visible (WCBM2: no rankings = "no sense of where our opponent was").
- Growth: every change carries its cause; partial progress visible (bar to the next point); potential as staff opinion
  with a band; staged reveals (preview -> event -> report); milestones beyond numbers (Game Developer "well-placed
  milestones and intentional plateaus"); Pokemon SwSh made hidden EVs visible.
- Tooltips: every number hoverable to a breakdown (CK3/Victoria 3 nested tooltips, Paradox dev diary 29), two-three
  levels max; systems unlock the week they matter (Two Point); actions inside reports.

## What we have and what is unclear (guide.gif amber lines + ops/research digests)
- Training: the whiteboard is the game's identity (critic 8/10) and goal lines move with a session - but the goal is a row
  of text ("+2.5 conditioning in 28 days"), and Fighters > Training is a second place for the same job.
- Week review: decimals (+0.4, +0.09) with no cause, most of the page empty (UI.gd:455-458 "+%.2f"; RESTART_PLAN.md said
  bars to the next point + whole-point gains). Quiet weeks get no reveal (S361).
- Booking: the opponent file is thin until the camp's tape; you say yes before you can learn (S369 playtest).
- Planning: the tape room cannot write into the plan (TapeRoom.gd:437); the plan rates only her archetype, no rounds; the
  plan is invisible in the ring; double jab dominates; Combos is fun but shows no numbers.
- Growth: holo body only in the fight; the Body tab is weight/diet; Ana's gains missing from the review.

## Decisions (S370, Claude; operator approves on the board)
1. TRAINING GOALS ARE TESTS (board question, canvas https://claude.ai/artifact/HLaiSxhMXEPERsM3naACY7): a dated test with a
   target, a projection the week moves, a Sunday check-in, test day as a moment (stamp, record, unlock), four grade roads
   (Power, Speed, Engine, Skill) - the career of a boxer who never competes; competitors take the same tests. Real tests and
   values from John (TASK_J_TESTS1) before any number enters the game.
2. COMBO CARD STRIP (built under Q-S294-91 "interactive ... visually and progressively rewarding"; operator's own idea S370):
   her moves as cards with a level; the chain is a strip with each join judged (ComboFlow's rules) and totals - flow, power,
   stamina, time, hit chance vs the booked opponent (ComboOdds). Not a separate card battle: the ring's calls already are
   the "hand"; later the corner calls can be drawn as cards from her plan.
3. WEEK REVIEW: whole points with the cause named, a bar to the next point for the rest (the restart plan's own rule).
