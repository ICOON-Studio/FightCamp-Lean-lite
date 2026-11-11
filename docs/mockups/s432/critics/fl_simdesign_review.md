# From the build to the fight: a blind review by a sports-sim designer (S432)

Critic: fresh and blind (sports simulation designer). Read: CRITIC_PACK.md, CRITIC_ACCESS.md, the code (below), the real result and Game plan
screens (`E:/FightCamp/critic_pack/screens/21_result_real.png`, `23h_playbook_plans_real.png`), the measured probes in the research notes.
Linked, not redesigned: CLUBWEEK_MAP_V41_S432 (the week, the fight week, Legs), RPG_LAYER_MAP_S432 (perk versions, build direction, the
ledger of picks), HYPE_MAP_S432. TRAINING_MAP_S432.md did not exist when this was written.

**Depth score: 6 / 10.** One line: the engine under the fight is deep and honest (attributes fight named duels at three distances, drilling
feeds the punches, traits steer the corner), but the plan ignores who your fighter is, a hidden "form on the night" roll is as big as five
points of training, and the result page explains only the plan, so the player cannot tell which choice won or lost the bout.

## How the build decides the fight, as built (traced in the code)

One exchange (30 s, 18 a bout) is settled in `LiveRound.exchange` as one number `d` (power points) plus two dice, each worth +/- 33
(`Exchanges.EX_SPREAD` 66: the noise on one exchange has a spread of about 27). `d` is a sum of these parts:

| Part of d | Where | Size per exchange | What feeds it | Shown to the player |
|---|---|---|---|---|
| The duel at this distance | `RingDuel.step` -> `Duels.at` | A fighter 5 points better everywhere = +5 (measured: +5 stats wins about 72 in 100, +10 about 95) | 14 attributes + 4 punches (jab, straight, hooks, uppercuts = move mastery, `Attrs._punches`), pace and forward dials, reach, height, stance; tired and hurt copies (`Duels.effective`) | Round report line "The duel that decided it" when 2+ exchanges agree; bout page "wins at range, breaks inside" (`BoutCompare`). Not on the result page. |
| Form on the night | `RingDuel.form` | Each side a normal roll, spread 5, fixed for the whole bout: the gap has a spread of about 7 | Nothing. Pure dice. | Never. |
| The corner call | `Exchanges.call_edge` | best +17, ok +5, wrong -10, times the "can she do it" grade (from her attributes and punches: Good 1.0 / OK 0.6 / Poor 0.3), times uptake (coachability 0.7-1.0, halved after two shouts) times trust (morale) | Fight IQ finds the ok answer alone; Ring general x1.25 | Shout bar with grade words; Aftermath tile counts right / wrong / ignored |
| The plan line | `PlanFight.edge`, `PlanRead`, `PlanPressure`, `ReadBack` | best +9, ok +3, wrong -7 minus the card's average; reads stack +3.5 x2; pressure +3; wrong answers shrink the tank ceiling | The ANSWERS table (opponent's game only), whether the punches are learned, combination drilled or not | The Why: grade, right / wrong answers, "worth about +X%" |
| Habits | `HabitFix` | -6 x 1.75 = about -10 when the situation punishes it and the corner has not fixed it | The fighter's habit list; corner fix x uptake | Round cards, coach's notes |
| Pace and aim | `PaceAim.edge` | Push +6 (fades to -12 on an empty tank), Save -4, hurt aim +4, body on a tired opponent +3 | Your shouts | Shout bar |
| The read (counters) | `TheRead`, `LiveRead` | landed +7, missed -5 | Fight IQ (looks needed), film head start, temperament from discipline / temper / confidence | Read meter |
| Set-up (corner minute) | `CornerJobs.setup_edge` | fitting +14, wrong -9, times mastery | Combination mastery | NOW! button |
| Camp, film, weapons | `BoutRules.night_edge`, `weapons_edge` | camp +0.25 / +0.6 / +1.0; film +0.4 a tell answered (max 1.2); weapons max +0.9; peak camp +1 to every stat | Camp choices, tape study | "What decided it" words on the result |
| Perks | `PerkFight` | Stiff jab +3 vs a presser; Ring general x1.25 on calls; Counter sense free counter 3 in 10; Second wind +10 energy in round 3; Finisher x1.5 stoppage; Fast hands x1.4 on combinations | Thresholds on attributes and weapons (`PerkRoad`) | Round line "Perks at work" |
| Stale camp fatigue | `BoutRules.stale_energy` | -2 energy per tiredness point over 50, max -20 | The week | Fight prep, Aftermath |

Then `Exchanges.round_of` (most exchanges won), `Knockdowns` (power and damage against chin, heart for the count), judges' cards.
The shown chance (`BoutRead`) walks the same duels and stays within 6 in 100 of real bouts in all eight checked cases (FIGHTER_MODEL_S397).

Measured weight of the big levers (research notes, the played bout): training +5 everywhere = about 72 in 100 from 50; a good plan 70 vs no
plan 45 vs a wrong plan 32 (S397, one matchup); reading the clue 0.67 vs the coach's pick 0.52 vs silence 0.47 (exchanges_test). Small
levers: camp intensity's own night edge, film, weapons count, most perks: each about 1 to 4 in 100.

## What is good
- Inputs really drive outcomes, and the right ones: the better-built fighter usually wins, the plan and the corner turn close fights, and the
  shown chance is honest (checked against real bouts).
- The fighter model is the best part: duels of named tools at three distances (jab against footwork, counter against guard, inside against
  strength), reach, height and stance, tiredness and hurt eating defence first, pace and forward dials with costs. This is real boxing
  reasoning, not an averaged rating.
- Drilling reaches the fight twice: move mastery IS the punch attribute in the duels (jab, straight, hooks, uppercuts), and a call's
  "can she do it" grade reads those punches (Go to the body needs hooks and power). A drilled body hook makes a corner option better.
- Traits are wired, not decoration: coachability sets how much of a shout lands, morale is trust, discipline / temper / confidence set the
  read's patience and the corner talk, heart resists the late fade and the count.
- The anti-green rule (`COMMIT`): a wrong call the fighter is good at costs more, so the player must read the clue, not the colour.
- The plan's effect is counted the honest way: the same dice replayed without the plan's edge (`plan_swing`). That method is the key to
  everything in the list below.
- The Why exists, in plain words, after every bout, with a NEXT line.

## What is wrong (most important first)
1. **The plan does not know who your fighter is.** `PlanFight.ANSWERS` rates an answer only against the opponent's game. Step back is
   "best" against a presser for a slugger and an out-boxer alike. The research notes say so too: rule 4 ("reading more must pay") is OPEN
   since S397 and PARKED in S398 because one universal plan (step back, double jab, tie up) is as good as a careful reader. So the biggest
   player-written input is a lookup table, and the build (the deepest system) does not shape it. This is the main reason for 6, not 7+.
2. **The player cannot read which choice won or lost.** The result page (`21_result_real.png`) grades the plan ("GOOD PLAN ... +15%") on a
   loss, and "What decided it" gives three sentences with no size. The largest cause, the two builds meeting in the duels, is not on the
   page at all; corner calls sit on a separate tile; habits, perks, camp and the night have no number. A player who loses with a "good plan"
   learns nothing about what to change.
3. **Form on the night is hidden and big.** A gap with a spread of about 7 power points, held for all 18 exchanges, is larger than the
   "5 points better" training lever that wins 72 in 100. Nothing the player does moves it and nothing shows it. That is luck dressed as
   skill: the worst kind of noise for a manager sim.
4. **Drilling past Usable is flat in the plan.** Sharp is worth about 1 in 100 over Usable today; `FireLevel` (usable 1 in 2, sharp 3 in 4,
   signature always: +2.8 and +2.7 in 100) is built but switched off (no code sets `fire_level`). The tier words promise more than they do.
5. **Camp choices are almost decoration on the night.** Light / Standard / Hard add +0.25 / +0.6 / +1.0 against a spread of 27; film +0.4
   per answered tell. Their real effect is through gains and tiredness, which the player is not told.
6. **The style dials are not the player's.** Pace and forward are among the strongest inputs in `Duels` (busy work takes close exchanges,
   forward closes distance and costs guard), but they are rolled at signing (`FighterProfile.make`) and never set. The pack lists an agreed
   Aggression slider; the RPG map's build direction drifts them 2 a week. Neither exists yet.
7. **Habits cannot be trained in the week.** A habit costs about 10 points an exchange when punished, but the only way out is the signing
   focus "Fix the habit" (`Recruit.apply_focus`, 4 weeks, once). After signing, the corner's per-bout fix is all there is.

## Missing options
- **Where to fight tonight**: a per-bout distance aim (Keep it long / Meet in the pocket / Walk them down) that sets the corner's default
  place (`RingDuel.CALL_PLACE`) and the plan's starting card, chosen against a visible three-distance edge strip.
- **A habit drill on the pads** in the week, with progress (links to the week's pad places, CLUBWEEK v4.1 section 3).
- **A readiness read before the bell** (warm-up: Sharp / Normal / Flat) with one choice for round 1 (start on Save or on Push).
- **"Suits the fighter" on each plan line**, beside "Beats it / Works / Walks into it".
- **The size of every cause** on the result page, in wins in 100, with a button that acts on it.

## Useless or misleading options today
- Camp intensity read as a fight-night edge (+0.25 to +1.0): invisible in play. Keep it for gains and tiredness, say so, or size it up.
- The Sharp tier on plan lines: a word with no felt effect while FireLevel is off.
- "GOOD PLAN" as the result's headline on a loss with no other cause sized: it tells the player the one thing that did not need changing.
- Plan "Rate against" a kind of opponent while the ratings ignore your own fighter: it teaches a universal plan.
- HabitBeats is picture only (by design, fine), but players will read it as cause: the ledger must carry the real habit cost.

## New mechanics (only where decisions are thin without them)
1. **Lines that suit the fighter** (rule change, no new screen): a plan line's value = its fit to the opponent's game x how well your
   fighter does at the distance that line takes the fight to: suit = clamp(1 + duel edge at that place / 10, 0.5, 1.5) from `Duels.at`.
   Step back is best against a presser only for a fighter who wins at range. This makes reading both files pay and closes rule 4.
2. **The night, earned**: form's average moves with readiness (Legs from CLUBWEEK v4.1, a weight cut on the day, mood, peak camp,
   a taper), spread cut from 5 to 3; the leftover is named "the night" in the ledger.
3. **Decision ledger**: the plan_swing replay generalised to every lever group (below, item 1).

## To reach 10/10 (most important first, each buildable)
1. **The decision ledger on the result page.** Store each part of `d` on the exchange record (duel, form, call, plan + reads + pressure,
   habit, pace / aim, read, set-up, camp + film + weapons, perks) as `rec["parts"]`. After the bout, replay the same dice with each GROUP
   removed (builds; plan; corner calls and minute; habits; camp and film; perks; the night) and print each group's wins in 100 and rounds
   turned, biggest first, with one action button per row (Train Defence, Open the plan, Fix it on the pads). "Your choices +N, builds and
   the night -M". Replaces "What decided it" words; the Why's three lines stay under it. Test: the parts sum to the exchange's `d` within
   0.01; the ledger's season sum matches a probe's average (links RPG map section 13, which needs this same hook).
2. **Lines that suit the fighter** (new mechanic 1) in `PlanFight.value`, the Game plan rows ("Beats it, suits Lucy +4"), CoachPlan,
   BoutRead and the Why. Gate (from RULE4_PARKED_S398): a reader beats both a board-top headline bot and the fixed universal plan by 3 in
   100 or more on each of four opponents, N = 600.
3. **The three-distance strip**: At range / In the pocket / Inside, each with the duel edge number and both best tools ("Lucy's jab over
   Priya's feet +4"), from `Duels.at` on the public file. On Fight prep, the bout card, the Game plan header, the corner minute (live, with
   tiredness), and the result (fought / won per distance). The week review shows its change ("at range +1.2 since last month").
4. **Form readable and earned** (new mechanic 2): shown after the warm-up as Sharp / Normal / Flat with its number; one round-1 choice.
5. **Switch FireLevel on** (usable 1 in 2, sharp 3 in 4, signature always) and print "fires 3 in 4" on each plan line and drill card.
6. **A per-bout distance aim** (missing option 1), wired to `CALL_PLACE` defaults and the plan's opening card; its edge shown from the strip.
7. **A habit drill on the pads**: a card per habit, 1 pad place a week, 3 to 5 weeks (faster with coachability); half-way halves
   `HabitFix` cost. The ledger and AGAINST YOU name the habit's cost so the player sees why to pay.
8. **Player-set style dials**: the agreed Aggression slider (pace and forward) inside a band the attributes allow (+/- 15 of the rolled
   value), with the guard cost shown; the RPG map's direction moves the band, not the slider.
9. **Camp sized honestly**: either camp intensity's night edge reaches 1.5 in 100 per step (measured on the played bout) or it is removed
   and the camp card says "Hard: +35% on the camp stat, tiredness +X; nothing extra on the night".
10. **One lever table, measured nightly** (LEVERS1, a tool beside `plan_effect_probe.gd` / `train_effect_probe.gd`): wins in 100 for +5
   attributes, each mastery tier, good / wrong plan, reading vs silence, each camp level, film, peak camp, each perk, a fixed vs open habit,
   form, on four matchups. Any lever under 1.5 is cut or relabelled; every "worth about" on screen reads from this table.

## Complete for this version?
Yes, with the list applied. Four fighters, amateur bouts to the first professional fight, need no new system here: the engine already has
the parts. The list is mostly wiring (the plan must read the build), legibility (the ledger and the distance strip) and honesty (form,
camp, mastery tiers). One reservation: the BJJ fighter's match (`BjjMatch`, `BjjClash`) was not traced in this review; it needs the
same ledger (its own groups: belt gap, drilled moves, your calls) before it can be called complete.

## The 10/10 drawing
`docs/mockups/s432/critics/fl_simdesign_10.png` (from `fl_simdesign_10.html`): the result page as a decision ledger (seven rows in wins
in 100, each with its cause and a button), the three-distance strip with fought / won, and NEXT with its price.
