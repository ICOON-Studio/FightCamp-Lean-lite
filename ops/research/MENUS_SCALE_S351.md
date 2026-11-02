# Menus at 3-4 fighters and with BJJ (S351, operator: "check these menus when you have bjj training and 3-4 fighters,
# how these menus will work"; reference: mmapromoter.com, "check mmapromoter.com for a proper interview card")

References (never shipped): E:\FightCamp\refs\S351\mmapromoter_fighter_profile.jpg, _training_plan.png, _dashboard.png.

## What breaks today (read in the code)
- FIGHTERS > Training stacks one full TrainingBoard per fighter (Fighters.gd: `for f in c.fighters`). Each is ~1,000 px
  with its own header: 3-4 fighters = 3-4 screens of scrolling, no way to compare them.
- The board is 8 boxing sessions in a ring round her body (4 a side). BJJ / MMA adds at least 4 (wrestling + takedown
  defence, BJJ drilling, BJJ rolling live, kicking): 12+ cards do not fit round one figure.
- The Interview modal is a short form (meet her, pick 3 week cards) - not a fighter card.

## What MMA Promoter does (seen on its site)
- ONE fighter profile card: photo, name + age, nickname, flag + nationality, style tags (Submission Wrestler, Scramble
  Grappler), division, stance, status chips (SHOWMAN, ACTIVE), record, organisation; tabs Profile / Attributes / Metrics /
  History / Development / Relations / Training / Contract; profile = popularity by region (map + bars), mindset, goal,
  loyalty bar, weight profile (walk-around, division limit, cut, height, reach, "weight misser"), a short bio.
- Training is a TAB OF THE FIGHTER, one fighter at a time: a grid, rows Punching / Kicking / Wrestling / Ground / Base,
  columns Offense / Defense, each cell a focus (e.g. "Strike Offence: punch power, hand speed +0.5"), picked cells framed,
  a tier tag; under it the training team (camp), its specialty (BJJ), reputation, coaching staff with ratings, and the
  areas it includes as chips.

## Played in the game (S351, operator signed in; refs mmapromoter_ingame_*.jpg/png)
- ROSTER: one table for 154 fighters - portrait, name, flag, age | class | rank | record (+ in-org) | style |
  personality | contract ($/fight, fights left) | Renew / Cut. Filters: all / active / injured / expiring, search,
  style, personality, weight-class tabs. Tabs: Fighters, Rivalries, Alumni, Signing class.
- TALK (their interview): a text-message chat. Header (photo, flag, age, class, record), history, four short lines to
  send ("how's camp going", "saw the last fight. good work", "let's talk about keeping that belt", "how's the cut
  looking"); the fighter answers in 1-2 bubbles; RELATIONSHIP and MORALE bars show the change; "Next talk in 3 weeks".
- TRAINING tab: the grid; each cell tagged GYM SPECIALTY / COACH SPECIALTY; his training team (city, specialty,
  reputation, 3 coaches rated /95), the gym's facilities as chips, "Change team".
- TRAINING TEAMS (156 worldwide): rows = gym, city, specialty dot, a stack of fighter faces +N, coach stars, reputation,
  tier; filters by specialty (Striking, Wrestling, BJJ, Muay Thai, Conditioning, MMA) and tier. Expanded (Iron Lotus,
  BJJ, 32 fighters): coaching staff each with ONE specialty + rating, the roster as bars per weight class, and the
  fighters split under HEAD COACHES (tabs, 6-7 fighters each).
- Lesson for us: many fighters are handled by GROUPING (a coach's group, a weight class) and by one card at a time,
  never by stacking full pages; a talk is a short exchange with a visible effect and a cooldown.

## Proposal (Claude, for his OK - mockup stills next session)
1. Training tab = a fighter strip on top (portrait, main session, load gauge, injury dot) + ONE board for the picked
   fighter; a "Squad week" toggle shows all fighters as rows x sessions as columns (blocks as small bars) to compare
   and copy a week.
2. Sessions by discipline: boxing keeps its 8; MMA/BJJ fighters get grouped AREAS like MMA Promoter's grid -
   STRIKING / WRESTLING / GROUND / BASE x OFFENCE / DEFENCE; each cell is a session card (picture, rounds, - / +);
   the body figure moves to a side panel and lights the parts the hovered card trains. The rounds rule (TrainingPlan)
   works unchanged on any list of sessions.
3. Coaches get a specialty (boxing / BJJ / wrestling) that speeds the matching cells (his "training team" panel).
4. Interview = a proper fighter card in MMA Promoter's shape, at amateur scale: photo, name, age, flag, style tags,
   stance, weight class; record; mindset + goal; weight profile (walk-around vs limit = the cut); a short bio; local
   reach instead of world popularity; then the week cards to pick.
Scope note: BJJ / MMA is the MMA update after boxing (Q-S294-70); items 1 and 4 matter for boxing now (3-4 fighters).
