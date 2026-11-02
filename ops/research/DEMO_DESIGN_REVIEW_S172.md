# Demo design review - S172, 2026-10-06 (Claude as lead designer, operator: "judge the demo's design in depth")

Evidence: the design of record `DESIGN_ON_PAPER_S159.md` (D35) and `CAMPAIGN_PLAN.md` (D36), measured against a full first-hour
walk on the dev tree with the game switches ON (`research/s171_story5.plan`, as_game, 60 steps, 0 dead ends; stills
`docs/previews/s172_story5/01-60`) plus `s172_train2` (planner). The walk takes the shortest path a player can take:
it presses no optional button (no fight plan, no corner call; SIM TO RESULT after round 1). Every point below names its still.
Note: the operator's exe (S165) is OLDER than this tree, and three built features (timeline bar, gym-as-menu, candidate card v2)
are still OFF until he okays them.

## Verdict in one paragraph
The shell is sound: the first-job guide leads every step, a first fight happens in game week 5 in ~30 presses, fight week and the
tape are a strong setpiece, and the result is honest about what happened. But the game's central promise - **scout -> plan -> camp ->
fight -> corner, every win a decision you made** - is not yet visible to a player. On the shortest path the camp builds nothing you can
see, the corner is never asked for, and the result explains the score instead of your decisions. Today the demo plays as a well-dressed
booking-and-watch loop. The work that matters most now is making the player's decisions show up on fight night, not adding screens.

## Scorecard against the four pillars (0 = absent, 3 = done)
| Pillar (D35) | Score | Why (still) |
|---|---|---|
| 1. The corner is where you play | 1 | Never asked for. The bout ran with "NO INSTRUCTION" (53) and SIM TO RESULT sits beside 1X; the result says "ONLY ONE CORNER CAME WITH A PLAN" - ours had none and nothing stopped us (56). The wired corner (CORNER2: plan, words, towel) exists but only appears if you stay at 1X/2X to the bell. |
| 2. The week prepares the fight | 0.5 | Four-week camp vs a named opponent was set (35), then fight week says **"CAMP BUILT OVR 49 -> 49 ... This camp built: nothing yet"** (46) and the first week review says **"Nobody trained this week"** (41) while a camp was running. The bet never pays out on screen. |
| 3. Every fighter is a person | 1 | The first boxer is two numbers (rating 49 / potential 74) - no style, no strength, no flaw (14). Only ONE candidate can be signed, so the first choice is not a choice. His record reads 7-4-1 on the card, **0-0-0 on the offers** (26), 7-4-1 at fight week, and **1-0-0 after the win** (56). |
| 4. Honest, readable outcomes | 2 | Scorecards, punch table and THE READ are honest and clear (56). But "THREE MOMENTS THAT DECIDED IT" restate the score ("outlanded 41-24", "won the round tally", "takes a unanimous decision") - none names a moment or a decision. |

First-hour timetable (D35 s9): city + gym (6 presses, OK) -> first fighter (1 click via FIRST JOB, OK) -> first fight offered (week 1, OK)
-> scout/plan/camp (the camp sheet is there but the opponent has no weapon/weakness on the offer) -> first fight night + first corner call
(**missing on the shortest path**) -> "the result says why" (**score, not why**).

## The ten findings, ranked
1. **CRITICAL - the camp pays nothing visible** (46, 41). Either the gains are real but not shown, or the camp and the week programme do
   not talk (camp started, no programme set, "nobody trained"). This is the single most important design defect: it breaks pillar 2 and
   makes every camp decision feel fake. Fix: fight week and the bout must show what the camp bought ("drilled the jab: lands 40% vs 32%
   without a camp", the camp's shape in the scorebug instruction line), and a running camp must count as training in the week review.
2. **CRITICAL - the corner is optional and silent.** The heart of the game can be skipped without a word. Fix for the demo: the FIRST
   fight always stops at the first bell for one corner card (tutorial), the camp's plan is the default instruction (no more "NO
   INSTRUCTION" after a camp), and SIM TO RESULT asks once ("skip the corner?").
3. **HIGH - "why" is the score, not the cause.** The three moments must be causal and tied to the player: the round the plan changed,
   the punch type that won it vs the scouting read, the corner call and what followed (D35 s5 example: "Round 4 - you switched to body
   work; his output dropped 30% after it").
4. **HIGH - the camp sheet is a spreadsheet with MMA leftovers** (35). Seven choice rows (~22 cards), decimals ("+0.03", "+0.15"),
   and options a boxing gym cannot use: "THE MAT MECHANIC" (ground game), "ANTI-WRESTLER", a JUDO visiting coach. D35 says a week is 3-5
   real decisions. Fix: boxing-only options (a defect - fix now), whole-number effects in words; for the demo show three choices
   (plan/focus, sparring partner, weight cut) and fold the rest behind "more".
5. **HIGH - one record, everywhere** (14/26/46/56). Amateur and pro records are shown inconsistently; trust in every number drops.
6. **HIGH - the first fighter is not a person** (14). Card v2 (built, OFF) gives 1-20 numbers + band words + VS OUR GYM, but still no
   style/trait. Fix: three candidates on day one, each with a style and one strength + one flaw in a sentence (D35 s7, s9 minute 3-8).
7. **MEDIUM - the payoff screen opens on a panel of zeros** (56): SETTLEMENT is $0 on eight rows for an amateur bout. Show one line
   ("Amateur bout - no purse; +12 hype") and give the space to the story line / what changed.
8. **MEDIUM - the opponent is a blank on the offer** (26): three EVEN 0-0-0 opponents differ only in icons without words (64%, +4, 0, 4W).
   Pillar 2 starts here: each offer needs his style and one scouted weapon in words, so picking a fight is a puzzle.
9. **MEDIUM - looks**: the home gym is a dim sepia painting, not "bright and alive" (10); fighters barefoot, shorts with white blotches
   (53; P2-16 from S146 still open); the sponsor is the "Cyprus Mixed Martial Arts Federation" for a boxing gym (26; P2-18 open).
10. **LOW - wording**: the planner tile says REST, the day says OFF (s172_train2/37); week review "Bills $0" beside "monthly bill so far
   $1,673" (41); a stray green square on the NET card (41).

## What is good and must be kept
- FIRST JOB guide: every step of the loop is one obvious button (10, 14, 26 GUIDE chip).
- Fight week + THE TAPE + weigh-in: the strongest presentation in the game (46).
- Result honesty: three judges round by round, punch table, THE READ, THE PLANS (56).
- The drag planner (TRAIN2) is direct and readable (s172_train2/37).
- The scorebug is broadcast-clean (53).

## What I recommend, in order (the first three are the demo)
1. Make the camp visible (finding 1) - investigate first: is it a display gap or a real disconnect.
2. The first corner is played, the plan defaults from the camp (finding 2).
3. Causal "three moments" (finding 3).
4. Defects fixed on sight: boxing-only camp options, one record everywhere, boxing sponsor, zero settlement rows, REST/OFF.
5. Operator taste calls: turn on timeline bar + gym-as-menu + candidate card v2 after he watches the video; three day-one candidates
   with a style line; the camp sheet cut to three visible choices.
6. Then DAYLAP1 (the day as a lap) - it builds on 1 and 2; without them it would be "a prettier Advance button" (DAYLAP opinions).

---

# Part 2 - judged against the NEW plan (operator: "judge the design according to the new plan")

The new plan = NAV1 "the gym is the menu" (timeline bar, places not rail, panels over the gym, people move with the week),
DAYLAP1 (the day as a lap in one zoomable 3D gym), the story chapter (D36). Walked ON: `as_game timeline_bar gym_is_menu
candidate_card_v2`, plan `research/s172_nav1.plan`, stills `docs/previews/s172_nav1/10`, `s172_nav1d/11-17`, `s172_nav1b/13`.

## Slice by slice
| NAV1 slice | Built? | What the player actually gets (still) | Grade |
|---|---|---|---|
| 1 TIMELINE1 | yes | Play / pause / fast + two weeks of days on top (10). Clean, the right reference (Two Point). Pins for weigh-in/fight are not on screen yet in week 1 (nothing booked). | B+ |
| 2 GYM-CLICK1 | half | No rail, eight places with a live line each, the coach gives the next job (10, 17). BUT a click opens the OLD full-screen hub with a Back button (12: Street door -> the whole SCOUTING screen), not a panel over the right third with time paused. The "coach by the door" is an icon disc, not a person. | C+ |
| 3 CARD1 | yes | The candidate on the FM logic: 1-20 + band word, VS OUR GYM, THE ASK in money, ambition, one gold SIGN FIGHTER (13). Big step up. But all eight numbers sit at 9-12 "Good" - he has no shape; Rating/Potential are listed as if attributes; still no style line; still one candidate. | B |
| 4 PEOPLE1 | no | The gym is a still sepia PAINTING with labels on it. After signing, Torres is a 2D card at the bottom (17); nobody is in the gym. NAV1's promise "the programme you set is what you see" is absent. | F (not built) |
| DAYLAP1 | no | Designed only. It depends on slice 4 (people on stations) and on the camp paying visibly (Part 1 finding 1). | - |

## The core judgment
The new plan is RIGHT and is the stronger game: one screen, time that moves, places instead of menus. What is built is its
**chrome** (bar, labels, card), not its **substance**: a living gym where your decisions are visible. Three gaps decide it:
1. **The gym is not 3D and nobody is in it.** NAV1 and DAYLAP both assume "the 3D gym (the camera we have)". The HOME today is a
   painted backdrop with hotspots (10). D33 (operator S151: "rooms stay 3D") and the S159 paper ("a bright, lived-in 3D gym ... the
   home screen") both say 3D. The 3D training floor EXISTS (WATCH THE FLOOR, TRAIN1/S170 stills with Torres + coach working).
   Decision I recommend: **the 3D training floor becomes the HOME** behind gym_is_menu - one camera, the places are its stations,
   the fighters you have are on it doing their programme. That is PEOPLE1 and the stage DAYLAP needs, in one move.
2. **Places open screens, not panels.** Every click leaves the gym (12). The plan's rule "one panel over the right third, time
   paused" is what keeps the player IN the gym. Recommend: hubs open as a right-third overlay (the router already has the routes).
3. **The loop still pays nothing visible** (Part 1, findings 1-3). The new plan makes this worse, not better, if left: a living
   gym where the camp shows "OVR 49 -> 49" is a prettier Advance button - exactly the failure both DAYLAP outside opinions named.

## New-plan defects seen in the walk (fix on sight)
- Record shown three ways: card "7-4-1", gym card "7-4" (17), offers "0-0-0" (Part 1).
- "The board: Torres #2 Flyweight" for a newcomer on day one (17; P2-19).
- Monday report on day one says "Quiet week. Leave him." before any week happened (17).
- Scouting header image bleeds text ("OVERCOMMITS TO BODY SHOTS / SLOW TO ADJUST") behind the title (13).
- Two guides at once: the coach speech AND the gold "GUIDE · Sign your first boxer" chip (13).

## Order I recommend for the new plan
1. Camp pays visibly + the first corner is played (Part 1, 1-2) - the substance.
2. HOME = the 3D floor with your people on it (PEOPLE1), places = stations (behind gym_is_menu).
3. Hubs as right-third panels, time paused.
4. Then DAYLAP1's one-day slice on that floor.
5. Operator video of the first ten minutes with all of it ON, then switches ON by default.
