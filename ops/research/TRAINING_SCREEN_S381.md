# TRAINING SCREEN S381 - the week as ink session cards, the plan's moves as cards you drill

Operator (S381): "also we need to work training screen ? not sure how fun it is to setup training yet and how to train
the moves for the plan ?" and "is that how fighters train, they train on a fightplan or learn moves?"

Inputs: the training-screens audit of main edc03163 (Lucy, code + existing stills, no Godot), the rules on main
(`MoveMastery.gd`, `Combos.gd`, `OwnCombos.gd`, `TrainingWeek.gd`, `TrainingPlan.gd`, `Sim.gd`), the camp build on
`claude/camp2` (`E:/FightCamp/wt/LEAN_CAMP2`: `WeekStrip.gd`, `NightBar.gd`, `CampMatch.gd`, `PlanTest.gd`,
`BoutRules.PROTOCOLS`), our reference notes (`E:/FightCamp/tmp/ref_study/COMPARE_S381.md`, Corner King, Elite MMA,
Gladiator Command, Rune Coliseum, the Undisputed-style career gym clip). Pairs with `PLAYBOOK_SPEC_S381.md` (its
TRAINING WIRING section): the Playbook decides WHAT the plan is, this screen decides HOW she gets it into her hands.
All projections below were run with a re-implementation of `MoveMastery.gain` (Lucy: Technique 60.1, Ring IQ 59.0,
coach Luke rated 58, station tier 2). Numbers in our own words; nothing from the reference games is copied.

---

## 0. The answer in five lines

1. Today the week is a coach default you watch; the move and combo pace is fixed and nothing on the whiteboard changes it.
2. New: the Training tab opens on ONE strip of the week - 7 days, each an AM card (a body session) and a PM card (pads,
   sparring, film or rest) - with a tray of DRILL CARDS above it: the moves and combinations she is working on.
3. Drag (or click-click) a drill card onto a PM pad night to drill it there; two cards on one night split it.
4. Every drill card says when it lands, from the same math that runs the week: "usable Wednesday", "sharp in 3 weeks",
   "held at 37 by the Lead hook", "signature needs Technique 83". When a card crosses 30 / 60 / 85 it flips gold.
5. Between fights the tray is "LEARN" (new moves, own combos, a habit). When a fight is booked it turns into "THE PLAN
   vs Maria": the plan's moves and answers, with an honest x0.8 stamp on anything not yet usable by fight night.

A normal week is 0 clicks (CONTINUE runs the coach's week) and a "my week" is 2-3 clicks.

---

## 1. What is wrong today (from the audit, with the numbers that matter)

| # | Problem | Number |
|---|---|---|
| A | The pace of moves and combos is fixed: `TrainingPlan.pads_factor` reads a week plan no screen edits since S356; pad evenings and sparring nights do not touch mastery | new move 420 min/week, combo 240 min/week, always |
| B | One combo slot (`f["combo_learning"]`) written from 3 places (whiteboard pick list, ComboPlanner, PLAYBOOK Drill it); drilling her own combo silently drops the 1-1 | 1 slot |
| C | The cap is never drawn; the planner promises a signature she cannot reach | Lucy cap = 40 + 0.4 x 60.1 + 0.2 x 59.0 = 75.8 < 85 |
| D | An un-drilled punch decays and caps her own combo for good | Lead hook 37.3 -> 30 floor at 0.75/week; Jab-Jab-Step-Lead hook levels off under 30 |
| E | The week review never shows a combo; the 1-1 gives 4 weeks of silence | 3 screens to answer "did it work" |
| F | Moves are drilled from hidden drop-downs ("More: pads, combo"), 25-item morning pickers, a dimmed twist gate | 8-10 clicks on 2 screens for a week |
| G | The Training tab buries the week under the awards card and the planner | board below the fold at 1080p |

---

## 2. How real fighters train: two modes, one screen

| | MODE 1 - BETWEEN FIGHTS | MODE 2 - FIGHT CAMP |
|---|---|---|
| When | No bout booked | Bout booked: 2-6 weeks amateur, 6-12 pro (camp2's weeks strip counts it down) |
| The player decides | What she becomes: which new move, which own combo, which habit to fix, which body session leads | How the PLAN gets into her hands: drill the plan's combos and answers, spar the plan, rehearse the rounds |
| Tray title | LEARN | THE PLAN vs <opponent face> |
| Tray cards | the coach's next move (first move under 30), unlocked book combos (`Combos.unlocked`), her own combos (`OwnCombos.entries`), the open habit fix (`HabitFix`) | every move and combo the Game plan uses (plan lines + GO-TO), answers to tells found on film (camp2 "film = answered tells"), the southpaw partner card on spar nights (camp2 `CampMatch`) |
| Moves under 30 | learned normally | may still be started, but the card wears a red stamp "UNDRILLED - x0.8 on fight night" (`PlanBoard.UNDRILLED = 0.8`) and its ETA is shown against fight night honestly ("usable 9 days AFTER the fight") |
| PM nights | pads + 1 sparring | pads, sparring = plan tests (camp2 `PlanTest`/`SparNights`), film; last week = TAPER: pads rehearse the round plan, half minutes |
| Gauges | Legs, Risk (Scale only when she is over her walk-around band) | Legs, Scale, Risk (camp2 survivor 4, "three dials that delete the text") |

The switch is visible: the strip header is a plain "THIS WEEK" until a bout is booked; then it becomes camp2's weeks
strip ("4 BUILD | 3 BUILD | 2 PEAK | 1 TAPER | Maria's face + date") and the tray re-titles and re-fills with a
short slide (one tween, no modal). After the fight it slides back to LEARN. Real-world basis: the plan uses moves she
already owns; pads turn into the opponent from week 2; partners mimic her; film finds her habits; the last week
rehearses the round plan (Corner King's camp sparring None/Light/Moderate/Hard and Elite MMA's Light/Normal/High
intensity are the benchmark for 3 intensity steps - we keep camp2's Light / Standard / Hard).

---

## 3. The screen (FighterPage > Training tab, top to bottom)

```
+----------------------------------------------------------------------------------------------+
| THIS WEEK  (or camp2 WeekStrip: 4 BUILD | 3 BUILD | 2 PEAK | 1 TAPER | [Maria] Sat 14)       |
| [Light] [STANDARD] [Hard]      LEGS ====|---   SCALE  64.1 / 63.5 kg   RISK  4 %   CONTINUE > |
+----------------------------------------------------------------------------------------------+
| LEARN  (or THE PLAN vs Maria)                                         + Build a combination   |
|  +---------+  +---------+  +---------+  +---------+                                           |
|  | UPPERCUT|  |  1 - 1  |  | JAB JAB |  | HABIT:  |   each card: ink picture, name,           |
|  | [art]   |  | [chips] |  | STEP LH |  | drops   |   mastery bar 0-100 with ticks 30/60/85,  |
|  | ==|  |  |  | ===|   |  | =|  ##  |  | hands   |   a hatched wall at her cap (75.8),       |
|  | usable  |  | usable  |  | held at |  | 2 wks   |   one ETA line                            |
|  | Wed     |  | wk 4    |  | 37: LH  |  |         |                                           |
|  +---------+  +---------+  +---------+  +---------+                                           |
+----------------------------------------------------------------------------------------------+
| GOAL  Technique 60.1 ---->|61 (gold tick: "jab and move" at 61)       INTENSITY  14 / 16 blocks |
|  MON       TUE       WED       THU       FRI       SAT       SUN                               |
| [AM:shadow][AM:bag ] [AM:road][AM:slip][AM:shadow][AM:speed][ rest ]   <- body sessions (pics)|
| [PM:PADS  ][PM:spar] [PM:PADS][ rest  ][PM:PADS  ][ rest  ][ rest ]   <- drill cards land here|
|  Uppercut   test     Upp|1-1            1-1                                                    |
|  Luke x1.23 Thu       50/50              tier 2 x1.0                                           |
+----------------------------------------------------------------------------------------------+
| (below the fold: awards card, the old coach line)                                             |
```

- The strip is the screen. Nothing auto-opens; the twist note becomes a sticky card on its day (no 35 % dim gate).
- AM cards: the 8 `TrainingWeek.SESSIONS` (sparring, neck, shadow, heavy bag, speed bag, pads, slip rope, roadwork) as
  ink pictures plus Rest. Click a morning -> a row of 9 picture cards opens under the strip (not a 25-item list);
  pick one -> it closes. The GOAL bar above sums the mornings: the focus stat now -> end of week, with camp2's
  `NightBar` gold tick at the stat that changes the night. INTENSITY sums the blocks (see 5.4) and feeds LEGS.
- PM cards: PADS / SPARRING / FILM / REST. The number of PM nights is the intensity step (Light / Standard / Hard).
  A pad night shows the drill card(s) on it, the coach chip ("Luke x1.23", "no coach x1.00") and the pad tier chip
  ("tier 2 x1.0"); a sparring night shows "plan test" in camp and the partner face.
- Pictures over text menus: every choice is a card; one line each; no flavour text.

---

## 4. Interactions and click budget

| Action | How | Clicks |
|---|---|---|
| Accept the coach's week | CONTINUE | 1 |
| Drill a card on a night | drag the tray card onto a PM PADS card, or click the card then click the night | 1 drag / 2 clicks |
| Mixed night | drop a second card on an occupied pad night: it splits 50/50 (diagonal split on the card); click the split to cycle 50/50 -> 70/30 -> 30/70 | 1 |
| Take a card off | drag it out, or right-click the night | 1 |
| More or fewer nights | Light / Standard / Hard (adds or drops a pad night; gauges tween) | 1 |
| Change a morning | click the AM card, click a picture | 2 |
| Fix a held-back combo | the card's red chip "held at 37: Lead hook" has a "+ drill it" button: puts the Lead hook card in the tray and on the next free pad night | 1 |
| Drill a Playbook combo | PLAYBOOK > Combos "Drill it" now PINS the card into the tray (no slot overwrite); same for a plan line's "1 untrained" | 1 |

Typical "my week" between fights: drag the 1-1 onto Friday (1), Hard (1), CONTINUE (1) = 3 clicks, one screen.
Typical camp week: the tray is already the plan and the coach has spread it over the pad nights; drag the slip 2-3
answer onto Wednesday (1), CONTINUE (1) = 2 clicks. Today: 8-10 clicks on 2 screens (audit).

The coach's default (zero clicks) reproduces today's pace exactly (5.2): the new move on Mon + Wed pads, the combo on
Fri pads. In camp the coach puts the plan's GO-TO first, then the plan's other combos, then the answers.

---

## 5. Rules with numbers

### 5.1 Unchanged
- `MoveMastery.gain(m, station, minutes, coach, tier, eff, cap)`: dm = rate x minutes/60 x tier/2 x (1 + 0.40 x
  coach/100) x (1 - m/cap); pads rate 2.1/h, ring sparring 1.5/h; an unlearned move drilled starts at >= 1.0.
- `MoveMastery.cap(T, IQ)` = clamp(40 + 0.4 T + 0.2 IQ, 50, 100). Lucy 75.8.
- `MoveMastery.decay_week`: -0.75 a week un-drilled, floor 30 once usable, never below 0.
- Tiers: RAW < 30 <= USABLE < 60 <= SHARP < 85 <= SIGNATURE (`Combos.LEARN_AT` 30, `ComboWords.SIGNATURE_AT` 85).
- `Combos.drill` / `OwnCombos.drill_week`: minutes x 2 / n over the n steps of the chain (a longer chain takes longer);
  a combo never passes its weakest punch nor her cap (`Combos.cap`, `OwnCombos.cap`).

### 5.2 New: pad nights replace the two fixed lumps
- `PAD_NIGHT_MINUTES = 240` drill-minutes per PM pad night (game units, the same scale as today's constants).
- Default between fights (Standard, 3 pad nights): new move on 2 nights = 480 (today `LEARN_MINUTES` 420), combo on
  1 night = 240 (today `COMBO_MINUTES` 240). The default week lands where today's does:

| Lucy, coach 58 | today (weekly lump) | new default (per night) |
|---|---|---|
| New move from 0 (Uppercut) to usable 30 | week 2 | week 2, Wednesday (19.3 after week 1, 33.7 Wed week 2) |
| 1-1 (Jab 51.1 holds it) to usable 30 | week 4 | week 4 (10.3 / 18.6 / 25.2 / 30.4) |

- Concentration pays but stalls the rest: 1-1 on 3 nights a week = usable in 4 nights (week 2, Wednesday); on a
  50/50 split night every night = 9 nights. A card on no night decays 0.75 a week (unchanged).
- Each night is applied in order with `MoveMastery.gain` (the projection and the run are the SAME function, the lesson
  from the reference study: a forecast not computed by the sim that plays it kills trust).
- Light / Standard / Hard set the nights (camp2 `BoutRules.PROTOCOLS` nights 3 / 4 / 5, spar 1 / 2 / 2):
  between fights Light = 2 pads + 1 spar, Standard = 3 + 1, Hard = 4 + 1; in camp Light = 2 + 1, Standard = 2 + 2,
  Hard = 3 + 2; film (camp2) takes a pad night. `TrainingPlan.pads_factor` becomes pad nights / 3, so every existing
  reader keeps working.

### 5.3 New: sparring and combos keep their punches
- A drilled combo counts as drilling its punches for `decay_week` (drilled_this_week = true) - no gain, just no fade.
  This removes trap D: Lucy's Lead hook holds at 37.3, and Jab-Jab-Step-Lead hook reaches 30 in 11 pad nights
  (about 4 weeks on 3 nights) instead of never. Its card still says "held at 37 by the Lead hook" because SHARP (60)
  needs the hook there first: 3 nights of Lead hook take it 37.3 -> 51.0.
- A sparring night gives every plan card already >= 30 a `ring_sparring` share: 180 min split over those cards
  (3 cards: about +1.5 each at m 10 of cap 51). Small, honest: you can only spar what is in your hands. Cards under 30
  get nothing from sparring ("not in her hands yet").

### 5.4 New: AM blocks and the intensity sum
- One morning card = 2 blocks, one PM pad night = 1 pads block, one sparring night = 1 sparring block. The default
  week = 6 mornings x 2 + 3 pads + 1 spar = 16 = `TrainingPlan.DEFAULT_TOTAL`; the shares/curve/TOTAL_CAP rules of
  `TrainingPlan` run unchanged on blocks built from the strip, so the GOAL bar is `TrainingPreview` of that plan.
- INTENSITY = blocks / 16 shown as "14 / 16"; Hard over 16 raises LEGS (fatigue) and RISK (`InjuryRoll`) as today's
  load does (camp2 `load` 0.75 / 1.0 / 1.2).

### 5.5 New: projections on every card (pure, from `PadWeek.project`)
- "usable Wed" when the 30 line is crossed by a night this week; "usable in N weeks" when the current nights keep
  going; "sharp in N weeks" for 60; nothing when no night carries it ("not on a night - fades 0.75/week").
- Cap: if cap < 85, the signature tick is grey behind a hatched wall at the cap and the line reads "signature needs
  Technique 83" (T needed = (85 - 40 - 0.2 IQ) / 0.4; Lucy IQ 59 -> 82.75).
- Held: if the weakest punch < the next tier, a red chip names it ("held at 37: Lead hook") with "+ drill it".
- Camp: ETA past fight night -> red stamp "UNDRILLED x0.8 on fight night".
- Modifiers as chips, never a sentence: coach x(1 + 0.4 r/100) (Luke 58 -> x1.23, none x1.00, 80 -> x1.32);
  pad tier: `STATION_TIER` 2 today, gym upgrades 2.2 / 2.4 (x1.1 / x1.2; `gain` takes a float tier).
  For scale: 1-1 to usable = 5 nights with no coach, 4 with Luke, 4 with coach 80 (31.9 vs 30.4 at night 4).

### 5.6 Payoff
- When a night pushes a card over 30 / 60 / 85, the card FLIPS (0.35 s turn) to a gold back with the tier word and the
  coach's one line (`ComboWords` coach_learning / coach_signature, `MoveWords`), the bar pulses (animated meters rule).
  It plays in the week review the player opened with CONTINUE, on the day it happened; nothing opens by itself.
- The week review gets a PADS row: each drill card with before -> after on its bar, the nights it got, the flip if any.
  This closes gap E (today `WeekReview.gd` has no combo code).

---

## 6. Data

- `f["pad_week"]`: `{"mon": [{"card": "move:Uppercut", "share": 1.0}], "wed": [...], "fri": [...]}`; days without a
  PADS PM card are ignored. The coach rewrites it each new week only for nights the player did not touch.
- `f["tray"]`: up to 5 card ids, pinned by the player or filled by the mode (`move:<name>`, `combo:<book id>`,
  `own:<n>`, `habit:<id>`, `answer:<tell id>`).
- `f["learning"]` / `f["combo_learning"]` stay as DERIVED fields (the move and combo with the most minutes this week)
  so news, `Sim.twist_needs`' "combo" flag and older readers keep working; nothing writes them directly any more.
- Save migration: an old save with `combo_learning` = X gets X on Friday's pad night; `learning` = Y on Mon + Wed.

---

## 7. Files each part touches (all stay under 500 lines)

| Part | File | Lines now -> after (est.) | What |
|---|---|---|---|
| Pad-night rules | NEW `scripts/rules/PadWeek.gd` | 0 -> ~190 | `defaults(f, mode, nights)`, `minutes_for(card, pad_week)`, `project(f, pad_week, coach, tier) -> {card: {path, day30, weeks30, weeks60, held_by, sig_needs_T}}`, `nights_for(protocol, in_camp, film)`; pure static |
| Week run | NEW `scripts/state/DrillWeek.gd` | 0 -> ~170 | `Sim.drill_week`, `drill_combos`, `_fade_own` move here and loop night by night; combo punches no-fade; spar-night share |
| Sim | `scripts/state/Sim.gd` | 527 -> ~430 | calls DrillWeek (gets it back UNDER the 500 cap) |
| Mastery | `scripts/rules/MoveMastery.gd` | 69 -> ~85 | `station_tier` float; `technique_for(target, iq)`; nothing else changes |
| Combos | `scripts/rules/Combos.gd`, `OwnCombos.gd` | 287 -> ~300, 241 -> ~250 | `held_by(moves, chain) -> [punch, m]` shared helper |
| Plan cards | NEW `scripts/rules/PlanCards.gd` | 0 -> ~120 | Mode 2 tray: the Game plan's lines + GO-TO + film answers (`OppFile.found`) as card ids; Mode 1 tray: next move, unlocked/own combos, habit |
| Drill card | NEW `scripts/ui/DrillCard.gd` | 0 -> ~210 | ink card, bar with 30/60/85 ticks, cap wall, ETA line, held chip, x0.8 stamp, flip tween |
| Tray | NEW `scripts/ui/DrillTray.gd` | 0 -> ~160 | LEARN / THE PLAN title + slide, drag source, "+ Build a combination" (to PLAYBOOK) |
| Day cards | `scripts/ui/WeekDay.gd` | 146 -> ~230 | the day becomes the AM picture card + PM card; PM is a drop target, split shares, chips |
| Board | `scripts/ui/WeekBoard.gd` | 282 (268 on camp2) -> ~260 | hosts the strip header (intensity buttons, gauges, CONTINUE), GOAL/INTENSITY sums; loses the pick lists |
| Kit | `scripts/ui/WhiteboardKit.gd` | 224 -> ~170 | drops "More: pads, combo" and the 25-item morning list (9 picture cards instead) |
| Camp side | `scripts/ui/WeekCamp.gd` | 245 -> ~150 | THIS CAMP text column becomes the LEGS / SCALE / RISK gauges (camp2 survivor 4) |
| Tab order | `scripts/ui/areas/FighterPage.gd` | 258 -> ~262 | Training tab: strip + tray first, awards card below |
| Planner | `scripts/ui/ComboPlanner.gd` | 116 -> 0 | deleted; its list is the tray, its Build button moves to the tray |
| Playbook | `scripts/ui/ComboBuilder.gd` | 315 -> ~318 | "Drill it" pins into the tray (`PadWeek`), no slot write |
| Game plan | `scripts/ui/GamePlan.gd` | 550 (over cap) | ONE line: "1 untrained" gets "Drill it" -> tray. The split of this file belongs to `PLAYBOOK_SPEC_S381.md`; this work adds nothing else to it |
| Review | `scripts/ui/modals/WeekReview.gd` | 363 -> ~420 | PADS row of DrillCards with before/after and the flip |
| Camp modal | `scripts/ui/modals/Camp.gd` (camp2) | 191 -> ~195 | one line under film: "answers go to the tray" (cards, not text) |

Gym floor stations (audit item 11) stay with the floor owner (Codex, S275); the pad tier chip is the only link.

---

## 8. What gets deleted

- The single combo slot as a player-facing choice (3 writers -> 0; derived only).
- "More: pads, combo" drop-downs, the 25-item morning picker, the 35 % twist dim gate.
- `ComboPlanner.gd` (its job is the tray).
- The fixed `LEARN_MINUTES` / `COMBO_MINUTES` lumps (become the default spread of `PAD_NIGHT_MINUTES`).
- The promise of a signature the cap forbids.

---

## 9. Build order (each a seat-sized item; tests only for what the diff touches)

1. **PADWEEK1 rules**: `PadWeek.gd`, `DrillWeek.gd`, Sim slimmed, `MoveMastery` float tier, combo punches no-fade,
   migration. Test `tests/test_pad_week.gd`: the default week reproduces today (new move usable week 2, 1-1 week 4 for
   Lucy), `project` equals the run night by night, Lucy's Jab-Jab-Step-Lead hook reaches 30 in 11 nights, spar share
   only for cards >= 30, Light/Standard/Hard nights per mode.
2. **DRILLCARD1 UI**: `DrillCard.gd`, `DrillTray.gd`, `WeekDay.gd` AM/PM cards with drag + click-click, `WeekBoard`
   header. Stills via `still_framing.gd`; play it in the exe (Lucy and the male boxer: tray, drag, split, CONTINUE).
3. **CARDFLIP1 payoff**: the review PADS row + flip; eyes on the recorded flip (video, not stills).
4. **PLANTRAY1 camp mode**: `PlanCards.gd`, tray switch on booking (needs camp2 merged: weeks strip, nights, film
   answers, partner), x0.8 stamp, ComboBuilder/GamePlan "Drill it" -> tray. Keep `move_player_probe` green.
5. **GAUGES1**: WeekCamp -> LEGS / SCALE / RISK gauges (shared with camp2 survivor 4; whoever lands first owns it).

Balance-check after 1: pad concentration (3 nights on one card) vs the old fixed split, and the spar share size.

---

## 10. Reference shapes we keep (numbers only, our words)

- Intensity in 3 steps with a visible cost (Elite MMA Light/Normal/High; Corner King sparring None..Hard): our
  Light / Standard / Hard nights with LEGS / RISK moving live.
- Instant preview while choosing (the career-gym clip: hovering a drill previews four gauges): our tray and gauges tween
  on hover over a night before the drop.
- The clip's flaw to avoid: every drill gave the same +10 and -1 lb, so the choice did not bite; ours differs by card,
  night count and split, and the cap/held chips say why.
- Punch Club's lesson (opaque why): every card shows its cause in one chip (coach, tier, held-by, cap).
- Rune Coliseum's complaint (a wrong prediction kills planning): projections come from the same `MoveMastery.gain`
  call order the week runs.
