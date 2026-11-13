# COACHFIT_CRITIC_S450_JOHN - John answer (seat queue SQ63)

Brief: research/COACHFIT_CRITIC_S450_BRIEF.md
Sent: 2026-11-13 15:34 | collected: 2026-11-13 16:10 by Tools/seat_queue.py (the 30-min reconcile)
Verify the sources before using it.

---

Reading COACHFIT1 v1 against the pack now. The full critic return follows.

# COACHFIT1 v1 (S450): critic

Depth **6/10**, play **6/10**. Growth that you choose by assignment, and a school that limits Signature, are real decisions. Four things keep the scores down:
- The load numbers never bind with the roster the code allows.
- The coach's rating is counted twice.
- Most school entries have no mastery to act on.
- The corner bond conflicts with who actually shouts on fight night.

I couldn't open `office_a.png` because your computer is offline, so I judged from the text.

## 1. Logic check

**Load and the roster:**
- **"The start (four fighters, the head coach plus one assistant)" contradicts the code.** The code gives 3 roster places at the Unit, +2 per premises tier and +1 per second coach (pack 8). A Fresh doors start begins with one walk-in, and the BJJ athlete also takes a place.
- **Load never binds early.** The head coach has 3 places and one assistant has 2, so 5 places for at most 3 boxers. Overload only becomes possible at the Bigger unit with 5–6 places. The load penalty and "3 of 2" are dead for the first year or more.
- **The head coach doesn't train today.** With no assistant, training runs at 60%, and the head coach has one edge (for example, Strength coach +10% body mornings), not area ratings. "The player's areas come from the HeadCoach background, which is today's rule" is wrong: no such area ratings exist. Taking 3 fighters at full fit also contradicts the 60% rule.

**Ratings, pad nights and morale:**
- **Rating is counted twice, or three times.** Coach factor (0.5 + rating × 0.7%) already scales every gain, and M6's pads rating already sets every bar's speed. The fit's +14 to −12 for the area rating applies it again.
- **The pad night units don't match across maps.** This map keeps PADPOOL1's 8 club nights. AMATEURWEEK1 v4 uses PadWeek's 3 per boxer. Four boxers at 3 each is 12, which is more than 8. Pick one unit.
- **The morale thresholds aren't the game's bands.** "Low mood under 40" and "high mood" don't match the pack's bands: Low is under 30, Flat is 30–49, Steady is 50+, Fired up is 75+.

**Schools:**
- **Most school entries do nothing today.** `step_in`, `step_out`, `tie_up`, `push_off`, `cut_off`, `herd`, `step_back`, `pivot_out`, `roll_out` and `feint` are StrikeMap arrows. The pack says they have no mastery and always work in full.
  - The conditioning coach's school is one punch (Body hook).
  - The footwork coach's school is empty in effect.
  - Half of the pads coach's school does nothing.
- **Uppercut is in no current coach's school.** Every current boxer is capped at Sharp on Uppercut until the young pads coach is hired. That may be intended, but the map doesn't say so.
- **The head coach has no school.** Under the "outside it" rule, every boxer on the head coach's list learns at ×0.9 and can't pass Sharp on anything.

**Tempers:**
- **Drill sergeant (×1.05 on gains and fatigue) and Technician (×1.15 on move learning) are flat-percentage perks.** The map's own rule says "no +5% training perks".
- **"Old hand" is already a head coach background** (easier cuts). One word per concept means the temper needs a different name.

**Bond:**
- **Two rules disagree on a swap.** Section 8 says a swap resets the bond to Stranger. Section 6 says the bond is per pair and decays by 2 a week. Swapping back to a former coach should keep what's left.
- **"+10 for a loss survived together" pays more than a win.** A lost bout with the coach in the corner gives +16; a win gives +6.
- **"−20 when moved off the list mid-camp":** amateurs no longer have camps (AMATEURWEEK1). Say whether the fight week counts.
- **Which sessions build bond is undefined.** Mornings, roadwork and weights: is a coach running them?
- **The quarrel event has no odds or effect.**

**The corner:**
- **The player is the head coach and makes every shout.** "Who works the corner: the head coach, or the assistant with the best bond" would mean the player's shouts land on the assistant's bond, or that the player gives up the corner. The only case where an assistant works a corner is two shows on one night.
- **There are two formulas for that case.** AMATEURWEEK1 v4 already prices it as right 0.5 + rating/200 of the time. Section 6 adds a bond multiplier on top, and the map doesn't say how the two combine.
- **Three multipliers now stack on a shout:** morale trust (0.7–1.05), coachability (0.7–1.0) and bond (0.9–1.1).

**Names and pronouns:**
- The map fixes he and him for every coach ("his rating", "his list", "let him go") and she and her for fighters ("worked her corner"). That breaks S412.
- The who-runs-whom table puts a coach in every row. If that cell shows the coach's name, it breaks S448. Use the portrait and the role ("pads coach").

## 2. Depth: 6/10

**What works:**
- **Growth is chosen by assignment.** Running a coach in a weak area costs fit now (−12 under 40) and builds the coach for later. That's a real trade.
- **The school caps Signature.** Who reaches Signature on which punch depends on who coaches them. That's a real season decision, but only for the punches in a school.

**Where it breaks:**
- **One coach per fighter makes the best assignment obvious.** All of a fighter's sessions sit with one coach, so the conditioning coach runs pads at low fit for their own fighters, and the pads coach runs conditioning. The obvious answer is "split by area", which the model doesn't allow.
- **"The coach runs it" solves the week.** Three or four fighters and two coaches give 16 or fewer combinations. Once fit is shown, the auto pick is always right this week. The player only has an edge over the long run (growth and bond), and the screen doesn't show that.
- **A temper nobody hires: the Old hand.** One tiredness a rest day is worth little. The fit bonus only applies to veterans or boxers back from injury.
- **A bond that rarely matters.** Its corner effect lands only when an assistant works a corner, which is two shows on one night. Everywhere else the bond is the head coach's "known" level, and that grows by itself.
- **Growth that does get noticed:** the "7 sessions to 66" ticks and the milestones on the Monday review.

## 3. Play: 6/10

Watching a cheap coach grow toward 65 and a second learning slot pulls you through Continue. Everything else lands as hover numbers between ×0.94 and ×1.10. Until the probe proves the season gap (4–8 in 100), the weekly swap is a formality behind "The coach runs it".

## 4. Options and menus

| Menu | Verdict |
|---|---|
| Week board session row | Keep the fit word, with its parts on hover. Remove the area-rating part, because it's counted already. |
| Staff app, who runs whom | Assigning per fighter is the wrong unit. **Missing:** assigning per area for each fighter (pads, conditioning, strength, sparring), a growth column and a "bond by the next bout" column. Swap's price preview: keep. |
| Staff app, market cards | Keep the temper, school, list, growth line and wage. The school shows arrows that do nothing. |
| Office Desktop overload | Can't happen before the Bigger unit. It's fine once lists are sized to the roster. |
| Fighter page, Training | Keep the coach, fit and bond. |
| Fighter page, move bar line | Keep the line where a coach stops. This is the best visible piece. |
| SLOTS1 school reason | Keep. |
| Monday review | Keep. |
| Bout card, who works the corner | Useless outside two shows on one night, because the player is the corner. |
| Fight shouts by bond | Only for an assistant's corner. Merge it with v4's formula. |
| Result "the corner: Trusted, 4 of 5 heard" | Keep. |
| Let go | **Missing:** that it also costs every Corner-step fighter's mood (−8) and loyalty (−5). The map states this in section 6, but the card doesn't show it. |

## 5. To reach 10/10 (mechanics, most important first)

1. **Assign per area, not per fighter.** Each fighter's week has four coaching slots: pads, conditioning, strength and sparring. Load counts coached sessions per coach per week (cap 8, +2 at an area rating of 80+), not fighters. The trade becomes the best area coach against a coach who is full or who is growing, every week.
2. **Size the head coach to the code.**
   - The head coach can run up to 4 sessions a week. Each one costs the club's evening class (−$350 a week, already in 4.13) or a day of club admin.
   - The head coach's areas come from the background: Ex-pro has sparring 70, Strength coach has strength 70, Old hand has conditioning 60, Amateur coach has pads 60.
   - Keep the 60% rule for a club with no assistant.
3. **Take the area rating out of the fit.** Coach factor already reads it. Fit is weakness match + temper + load + bond only, and the probe sizes it again.
4. **Build schools only from things with mastery.**
   - Punches and the combos the code holds. Arrows join schools only when StrikeMap arrows get mastery.
   - Every coach has a school, the head coach included (by background).
   - The pack's six punches are all covered by at least one starting coach.
   - The young pads coach's draw is Uppercut to Signature, said on the market card.
5. **Settle the corner.**
   - The player is always the head coach in the corner. Only the head coach's bond (the "known" level) multiplies the player's shouts.
   - An assistant's bond applies only when an assistant works the second show. Then the right-call chance is 0.5 + rating/200 (v4), and a call lands at the coachability rule × the bond step.
   - Remove "who works the corner" from ordinary fight weeks.
6. **Make tempers situational, never a flat percentage.**
   - Drill sergeant: the overreach line moves from 80 to 85 for Discipline 70+ fighters, and −1 morale a week for a Flat or Low fighter.
   - Technician: ×1.3 learning on Raw moves only (0–30), so it shines on new punches.
   - Motivator: as written.
   - Rename the Old hand temper to Steady hand. Effect: an injured fighter returns a quarter sooner, the same as the Physio job (an injury lasting 4 weeks takes 3), not stacking with it.
7. **Fix bond bookkeeping.**
   - Stored per pair. A swap keeps it, and it decays −2 a week apart.
   - Only coached sessions count (+1 each). Corner work +6. A loss in the corner +4, not +10.
   - "Mid-camp" becomes "inside a fight week".
   - The quarrel is defined (1 in 20 a week for a Drill sergeant with a Low fighter: −10 bond, −4 morale) or cut.
8. **Give the player an edge over "The coach runs it".** The auto pick maximises this week's fit only. The table shows two forward columns: area ticks gained this week, and the bond step reached by the next booked bout. FITPROBE1 adds a bar: a season-planning player beats always-auto by 3+ wins in 100. If not, the weekly swap is dead.
9. **Pick one pad-night unit** (PADPOOL1's 8, or PadWeek's 3 a boxer) and use it in both maps.
10. **Use the morale bands** (Low under 30, Flat 30–49) in every temper condition.
11. **Names and pronouns:** rows show portraits and roles. No fixed he for coaches or she for fighters anywhere in the strings.

## The 10/10 Staff app at 1920×1080

- **Dark top bar (64 px) and left rail (96 px):** as they are now.
- **Header, 100 px:** "Staff" with the club name once. The week's coaching load against capacity ("26 of 32 sessions"), and the one pulsing button, Confirm the week.
- **Left column, 520 px: THE COACHES.** One card per coach, by portrait and role:
  - Area bars with growth ticks ("7 sessions to 66"), and the ceiling once known.
  - The temper word with its one effect.
  - School chips (punches only), each showing how far the coach can take it.
  - A load meter of sessions this week. Wage.
  - Let go at the bottom, with its price, including the bonds lost.
- **Centre, 860 px: WHO RUNS WHAT.**
  - A grid with fighters as rows (portrait and class, no names) and Pads, Conditioning, Strength and Sparring as columns.
  - Each cell holds a coach portrait, a FIT word with its number, and the bond step pip.
  - Drag a portrait to swap. A ghost preview shows the new fit, the bond kept or Stranger, and the growth that stops.
  - Above the grid: "Coach's pick" and "Back to last week".
- **Right column, 440 px: WHAT THIS WEEK BUYS.**
  - Gains against the coach's pick, per fighter.
  - Growth ticks earned per coach.
  - Bond steps by each fighter's next bout, with the corner's multiplier on fight night.
  - Any overload in red, with its cost.
- **Bottom strip, 140 px: THE MARKET.** Four assistant cards (portrait, role, temper, school chips, wage, growth ceiling once watched), and Hire. A greyed card gives its reason ("no roster room", "can't afford").
