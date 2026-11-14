# DESIGN_WEIGHT1_R2_CRITIC_KALLI_KALLI - Kalli answer (seat queue SQ103)

Brief: research/DESIGN_WEIGHT1_R2_CRITIC_KALLI.md
Sent: 2026-11-14 05:11 | collected: 2026-11-14 05:41 by Tools/seat_queue.py (the 30-min reconcile)
Verify the sources before using it.

---

# WEIGHT1 round 2: critic score (S459, fresh critic)

Part 1 of 3

**DEPTH 8, GENERAL DESIGN 6, PLAY 7. It clears the S459 bar (6+ and 6+), only just on General design.**

This is the deepest map in the loop. Weight is decided three times: the class (a career choice), the contract weight (a deal choice) and the camp plan (a week choice). Every option is priced in one currency, win chance, and the reason sits in its own column. General design is held at 6 by four things:
- **Names in the body,** an S448 breach throughout.
- **Amateur rules that don't match England Boxing:** a catchweight and a kilo favour at a same-day matched scale.
- **A second word for the energy ceiling** that clashes with other maps.
- **A build of 14 tasks and 5 new modules** with no smaller first release.

## DEPTH 8

**What works:**
- **No plan row is free.** HOLD + big trim, LEAN + mid trim and CUT + small trim each win in a different state: kg to lose, a goal that needs every morning, a same-day scale where trim is dear. P3 tests that each is best in 15+ in 100 camps, which is the right test.
- **The fighter pushes back.** Discipline drives weekend slips, house rules buy them down with money or mood, and discipline grows slowly from clean camps. That's a long-term investment with a weekly cost.
- **The opponent lives by the same rules behind fog.** Their trim shows only after tape, and WRITE IT turns their lower energy into a plan line. That ties weight to the Playbook, the part the owner calls really fun.
- **Every class option has a real price.** DOWN costs diet weeks, lost ticket cuts and a roster clash. UP costs size and a thinner ladder. Test the weight is the scouting move for your own boxer.
- **Monday checks** turn a hidden miss into a decision with weeks to spare.

**What keeps it from 10:**
- **The GAMBLE row is the best row whenever a favour is held.** It shows 56 against 54, and its downside (still a favour at 0.7 over) is nearly the same as its upside. Favours become a weight currency, and the gamble wins until favours run out.
- **The WIN spread across sensible rows is 52 to 56.** P10 asks for 3+ in 100 in 60% of camps, and the drawn example only just meets it. The player will often see rows within 2 in 100, which makes it the coach's pick in practice.
- **Size edge is dead for amateurs** at a same-day scale (the map says so). The class choice for the first 9 wins rests on energy and the ladder only, so UP and DOWN are thinner trades for most of a career.

## GENERAL DESIGN 6

**Rule breaches:**
1. **S448 and S412.** "Samira", "Kayleigh" and "Lucy Jackson" appear in rows, plan names, the ask card, the trim note, the fog line and the WRITE IT line. Even the vocabulary note says "Names, never he/she… 'If Samira slips'". The owner's rule is the opposite: the name sits once in the header, and the body says your boxer and the opponent. "Her way = heard" is a fixed pronoun. Every one of these has to go.
2. **Class words.** "Welterweight · 65.0 kg" names classes the code doesn't hold. The game says classes in kg (women's 57/60/65/75, men's 57.5/60/70/75), and 65 kg isn't a welterweight limit in amateur boxing.
3. **The amateur scale rules.** England Boxing seniors are matched at a same-day weigh-in within the width of the smaller boxer's category (rule 2.7.8), which makes a kilo allowance a matter of the match gap, not a favour. Two parts aren't real amateur practice: "CATCHWEIGHT +1 kg costs 1 favour" and "ASK A KILO up to 1.0 kg". CHECK (John): whether a show's matchmaker may re-pair inside the gap on the night.
4. **Words that clash.** ENERGY ("never Tank, Fresh") and FATIGUE ("never tiredness") collide with the pack's "Week tiredness" and with other S459 maps that use "tank". One word per concept has to hold across maps: pick ENERGY or the tank once, and keep the pack's "tiredness" on training screens.
5. **Old stat names.** Power and Durability as the size edge: Power isn't an Attrs value (it's read from Strength, Explosiveness and skill). Put the edge on Strength and Durability.
6. **Currency.** The TO SOURCE prices are in GBP and the game is in USD. Pick one.

**Buildability:**
- **The scope is too big for one row:** 5 new modules, 14 tasks, 18 menus and 14 probes. There's no cut line between the first release and later.
- Pro water, refuel, the second-day clause, title checks, short-notice catchweights and no-gi weigh-ins all sit beside the amateur core. The amateur road is the first 9 wins and most of the game.
- **Ownership.** The build table names Qwen, Arena, Cursor and Grok Dev as owners. The owner's loop is designers, critics and Claude committing, and the pack has no such seats. CHECK (Claude).
- **The bar.** "Nothing starts before two critics score 7+" contradicts the owner's S459 bar of 6+.

**Strong points:**
- Every number is tagged REAL, CODE, GAME VALUE, ESTIMATE or TO SOURCE, with a file and line.
- The energy sum is rebuilt and checkable (HOLD 81, LEAN 86, CUT 85 all add up).
- The menu wiring table is complete, with 18 rows plus new wiring.
- Round 1's points are answered in a table.

## PLAY 7

- **Good:** the line to the scale with a Monday check, a slip in the news with its cause, "clean camps 1 of 3", and seeing the opponent's trim after tape and turning it into a plan line. These are small weekly beats with a payoff on fight night, and the Why line closes the loop.
- **Weak:**
  - **House rules are set once,** which takes away a weekly decision but lowers the noise; that's the right call.
  - **With four boxers cutting,** the weight panel is one more screen a week per boxer. The coach's pick is the default, so a player who skips it loses only 1 to 2 in 100. That's fine for pace, but low for anticipation.

Part 2 of 3

## Logic check

| Claim | Check | Result |
|---|---|---|
| Energy sums | HOLD 100−4−0−15 = 81; LEAN 100−4−3−7 = 86; CUT 100−4−8−3 = 85 | holds |
| Trim prices | 0.6 = 5 + 2 = 7; 0.9 = 5 + 8 = 13; 1.2 = 5 + 14 = 19 | holds |
| Slip chance at discipline 34 | 0.8 − 0.34 = 0.46, about 1 in 2; meal prep 0.23; weigh-in 0.115, about 1 in 9 | holds |
| Opponent energy | 100 − 4 − 2 − 13 = 81, five under 86 | holds |
| WIN formula | 54 + 0.4 × (energy − 86) − 1.5 for a goal left close; CUT 85 gives 53.6 − 1.5 = 52.1 | holds |
| GAMBLE | energy 90 gives 55.6, about 56; needs a favour either way | the best row whenever a favour is held (a dominance risk) |
| Amateur size edge | same-day scale, back by the bell at most 1.5–2.1% + 0.3 kg | the size edge rarely reaches 1 kg, so one line: holds |
| Walk drift | half back in week 1, the rest over 3 weeks; REAL 3.5–4.8% a week | holds |
| Repeat misses | 3 in 12 months forces a class up | sound, but at amateur level a walkover loss already ends a nationals run |

## Missing options

1. **Re-weigh within the window at amateur shows.** Real club shows let a boxer step off and re-weigh inside the weigh-in session. That's a cheap fix that would replace "Ask a kilo".
2. **A cut-line for the first release.** An amateur-only version (class card, plan rows, house rules, Monday check, same-day scale, opponent fog) and a pro version later.
3. **Pull out before the scale.** When the Monday check shows a sure miss under 2 weeks out, the player should be able to withdraw early, which costs the slot but no walkover on the record. The pack already has "pull out (club pays the empty slot)" for injury.
4. **A coach-pick trust line:** how often the coach's plan row was right last season, so the player knows when to override.
5. **Weight across two boxers in one class:** the roster clash is shown but has no option (share shows, alternate, or one moves).

## Useless or weak options

- **CATCHWEIGHT +1 kg at amateur level.** It isn't real at a matched same-day show. Cut it for amateurs and keep it for pros.
- **ASK A KILO as a favour.** Replace it with the match gap and a re-weigh.
- **MATCHED WEIGHT ± 0.5 kg** as a separate option at club shows. Amateur matching is already by gap, so this is the default, not an option.
- **The cycle-week band.** It changes nothing the player acts on except "the coach advises a few days earlier". Keep it only if it moves the Monday check, or else hide it (section 7, actionable information only).
- **The second-day limit clause:** a rare pro edge case, for later.

## What each option changes

| Option | Changes |
|---|---|
| Class DOWN / STAY / UP, now or after | cut % each camp, diet weeks, energy at the bell, size, ladder place, offers, roster clash, pro limit |
| Test the weight | one bout at a midpoint catchweight; half ladder credit; real slip and trim data on the card |
| Hear / overrule a class ask | morale +5 / −4, loyalty −3 past an 8% cut |
| Contract weight (limit / catch +1 / +2 / matched / second-day) | cut size, energy, the opponent's size, ladder credit, purse share or a favour |
| Short notice at +2 or the walk | no camp, no cut; purse +30% or a favour owed |
| Plan row (diet + trim) | scale weight, training gains, tiredness, energy, camp goal, miss risk, WIN |
| Water and refuel (pro) | energy, night weight, size edge |
| House rules | slip chance, against $70 a diet week or mood −1 a Monday |
| Nutritionist | trim price ×0.8, an exact forecast, slips ×0.75 for every boxer, $100 a week |
| Monday check: switch diet / move date | gains and tiredness re-priced / a favour or promoter trust |
| Standing order on the opponent's miss | box (money or a favour) or refuse (walkover or slot fee) |
| WRITE IT | adds a plan line tied to the opponent's lower energy |
| Sweat or pay; ask a kilo or walkover | energy / purse share; a favour / a loss, mood −6, −$450 |

## Menus

The map's own table (M1 to M18) is complete. Three notes:
- **M3 (CLASS card)** puts names in the ask card. It should read "your boxer asks to move up".
- **M13 (News)** is a body line, so it says "your 65 kg boxer", not a name.
- **The Office desktop is missing.** The next four weeks there should carry "scale today 4 pm" and the Monday check (Desktop is built, S451).

Part 3 of 3

## To reach 10/10 (most important first)

1. **Take every name out of the body** (S448, S412). Plan rows, ask cards, fog lines, WRITE IT, news, the trim note and the vocabulary note say your boxer, the opponent, your 60 kg boxer, and her / him for that fighter's own. Names stay in the CLASS card header and the weight plan header only. Fix "Her way = heard".
2. **Rewrite the amateur scale to England Boxing.** Same day, about 1 hour before boxing at club shows (7.1.3). Matched within the gap allowed by the smaller boxer's category (2.7.8). A boxer outside the gap may re-weigh once inside the session (ESTIMATE window 30 minutes), CHECK (John). Cut amateur catchweight and ASK A KILO; the favour moves to "ask the matchmaker for another name". Championships keep the class limit.
3. **Classes in kg only.** "65 kg", never "Welterweight · 65.0". The two new classes (women 70 kg, men 65 kg) go to the owner as a scope question with their kg, and names only if he wants them.
4. **One energy word across all maps.** Decide ENERGY or the tank once, put it in the GLOSSARY, keep the pack's "tiredness" (Week tiredness) on training screens, and drop FATIGUE.
5. **Put the size edge on Attrs:** +0.6 Strength and +0.6 Durability per kg from 1 kg, capped at 4 kg. No Power.
6. **Price the GAMBLE so it isn't dominant.** A favour spent on a weight gap also costs host trust −1 for 8 weeks (ESTIMATE), or the gamble's miss branch is a walkover with no favour route. P3 must show the gamble best in 5 to 25 in 100 even with favours held.
7. **Widen the plan spread or fold rows.** If P10 fails, show only the coach's row and one alternative ("Instead: CUT + trim 0.3, energy 85, 52 in 100"), and keep the full table behind "All plans".
8. **Cut a first release.** Release 1 is the amateur core: walk, class card, plan rows (HOLD / LEAN / CUT with trim), house rules, the Monday check, same-day scale with re-weigh, opponent fog with WRITE IT, the Why line, the nutritionist. Release 2 is pro: water, refuel, second-day clause, contract catchweights, title checks, short notice. No-gi comes with John's sourcing. Re-number B1 to B14 under these two releases.
9. **Add "Pull out before the scale"** on the Monday check when the plan's miss risk passes 1 in 3 under 2 weeks out. The club pays the $300 slot, the record shows no walkover, and mood −3 (ESTIMATE).
10. **Give the roster clash an option.** On the CLASS card, when two of the club's boxers share a kg class: "share shows" (the longer wait gets the slot) or "one moves" (opens DOWN / UP for one of them).
11. **Make the cycle band actionable or hide it.** If kept, the Monday check uses the wider band, so a check can fire a week earlier. Otherwise cut it from the screen.
12. **Add the Office desktop** to the menu table: scale day and hour in the next four weeks, and the Monday check as a need.
13. **Align with the loop.** The bar is S459's 6+, not 7+. Owners are Claude and the design seats, with no unlisted tool owners. Use one currency (USD) with GBP as a TO SOURCE note only.
14. **Run P3, P10 and P12 first** and print the measured WIN spread before any panel is built.

## The 10/10 page at 1920×1080 (Fighter page > Week, WEIGHT PLAN, Look B)

- **Dark top bar (64 px):** "to Mon 23 Feb, weight check" on CONTINUE (green, the only green).
- **Header (110 px):** polaroid portrait and the name once, the class in kg, the walk ("walks 66.8 kg · class 65 kg · 2.8% over"), the scale chip ("SCALE SAT 28 · 4 PM · same day, matched within 2.5 kg") and the MISS RISK badge ("2 in 100").
- **Left (760 px), THE LINE TO THE SCALE:**
  - The chosen plan solid and the others dashed, with the slip band shaded.
  - Monday check markers (a tick or a red ring) and the three trim days hatched, with the limit as a red line.
  - Under it, THIS WEEK BY CAUSE in one marker line and one coach swap with its kg and a "Do it" magnet.
- **Centre (680 px), THE PLAN:**
  - The coach's row in the one gold frame: diet + trim, scale result, camp goal, energy as a stacked bar (tiredness carried, diet's share, trim), WIN "54 in 100", and "if your boxer slips Saturday: 50".
  - One alternative row below it, and "All plans" opens the rest.
  - The trim stepper with every step marked (made −7, made −13, the 2% cap in red).
- **Right (480 px):**
  - **THE OPPONENT:** the walk as a range until tape, then the trim; "the opponent starts 5 energy under" with a WRITE IT magnet showing "+2 in 100".
  - **HOUSE RULES:** three pills with slip odds in fractions ("1 in 2 / 1 in 4 / 1 in 9") and their prices.
  - **Nutritionist line** with its effect, or Hire.
  - **IF YOUR BOXER MISSES:** re-weigh once, then a walkover loss, −$450, mood −6, and the ladder place lost.
- **Bottom (96 px):** your assistant's note (one reason, never "best") and the red **Lock the week**.
- No names outside the header. Every number has a hover with its parts.
