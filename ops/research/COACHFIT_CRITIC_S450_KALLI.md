# COACHFIT_CRITIC_S450_KALLI - Kalli answer (seat queue SQ61)

Brief: research/COACHFIT_CRITIC_S450_BRIEF.md
Sent: 2026-11-13 15:10 | collected: 2026-11-13 15:33 by Tools/seat_queue.py (the 30-min reconcile)
Verify the sources before using it.

---

Scoring COACHFIT1 v1 on this brief alone. First I'm checking whether the office mockup is on my computer.

Part 1 of 3

# COACHFIT1 v1, coaches who fit, fill up, grow, have a temper and bond: critic (S450, Kalli)

Judged on this map and the pack. I opened `docs/mockups/s449/office/office_a.png`, the office desktop, with the file tool. Staff app screen 5 isn't drawn, so the who-runs-whom table is judged from the text. I didn't open the Miro board or the real screens.

**Verdict:** Depth 5/10, Play 5/10.

Every piece is wired to a lever the game already has, and the cheap coach who grows into a good one is a real arc. But the choice settles in the first week and then stops being a choice:
- The coach's area rating already sets training speed, and the fit counts it a second time.
- The bond rewards never moving anyone.
- At the start, the roster has fewer boxers than the coaches' lists have places.
- Two of the four tempers are worth nothing.

The map's own risk section names the "set once" problem but has nothing in it that forces a change.

## 1. Logic check

**1. The coach's rating is counted twice.** Today the coach factor (0.5 + rating x 0.7 per cent) already scales every gain, and M6 says the pads rating sets every bar's speed. The fit adds +14 / +7 / 0 / -12 from the same rating, so a high rating pays out twice. Either the fit drops its rating part, or the coach factor stops reading the rating for sessions the fit covers.

**2. Mornings don't have coaches.** The fit runs on "pads, bag, conditioning, strength, sparring". The week is seven mornings (roadwork, intervals, heavy bag, weights, speed bag, slip rope, shadow, neck work) and seven evenings (Pads, Sparring, Rest, Film). The map never says who runs a morning, or which CoachArea each morning session reads. If only evenings count, the fit touches only about 3 pad nights and 1 or 2 sparring nights a week.

**3. Load never binds at the start.** The roster holds 3 places in the first premises (+2 per premises tier, +1 per second coach). The head coach alone takes 3, so a one-coach club is never over its list. The mockup's four fighters include the BJJ athlete, who the map puts outside the lists, so 3 boxers fill 5 places. Overload only appears at the bigger unit or later, which means the "overloaded single coach costs 2 to 5" bar can't happen in the first season.

**4. Two load models.** The map counts fighters on a list ("2 of 2"). The mockup's staff strip counts pad nights ("pad nights 4 of 6 used", "3 of 3 used"), and the map leaves the club's 8 pad nights a week (PADPOOL1) unchanged. 6 + 3 is 9 nights, not 8. Three boxers on 3 pad nights each is also 9, above the pool. Pick one unit for load, and say what happens when lists have room but the pool doesn't.

**5. The head coach as a coach with areas.** The pack says the player's background gives one edge (Old hand, Ex-pro, Amateur coach, Strength coach), not area ratings, and that "without any coach, training runs at 60%". The map says "the player's areas come from the HeadCoach background, which is today's rule", but that rule doesn't exist in the pack. A head coach with 3 list places and a rating breaks the 60% rule. CHECK (Claude): whether HeadCoach has area ratings in code.

**6. Stranger lasts much longer than two weeks.** The map says "the first two weeks with a new coach are Stranger". Working starts at 30 points, at +1 a session. Two weeks is about 8 to 14 sessions, so Stranger really lasts 3 to 6 weeks, longer if mornings don't count. Either the threshold or the line is wrong.

**7. Growth is very fast, and "a session" isn't defined.** +1 per 10 sessions, with 2 fighters on 3 pad nights each, is +1 in pads every 2 weeks, about +13 in a season. A pads 74 coach passes 80 (an extra list place) in about a month. Corner King's step is about 75 sessions, and the map takes the idea at 7.5 times the speed. It also needs to say whether a shared pad night counts as one session or one per fighter, since a split night doubles growth.

**8. Growth with a fixed wage.** A coach grows for free and keeps the hire wage. Nothing raises the wage, asks for a raise, or lets a rival gym poach the coach. So the cheapest young coach is always the right hire. The only brake is the hidden ceiling, and the market card hides it until 4 weeks after hiring.

**9. School nodes that have no mastery.** Five of the six schools' nodes (step_in, step_out, tie_up, push_off, cut_off, herd, step_back, pivot_out, roll_out, feint) are StrikeMap arrows. The pack (S448) says they have no mastery today and always work in full. A x1.1 or x0.9 on them changes nothing, and "can't take it past Sharp" has nothing to cap. Those code ids also aren't the game's words: write Step in, Tie up, and so on.

**10. The school cap and the head coach.** "Outside the school: not past Sharp" makes Signature impossible for any move no coach on the staff teaches. The head coach takes 3 fighters and has no school in the map, so every fighter on the head coach's list caps at Sharp. With the starting staff (the pads coach and the conditioning coach), Uppercut can never reach Signature. M6's Signature rule, clamp((pads - 55) / 20, 0.25, 1), is a rate, not a cap. The school turns it into a wall.

**11. Mood words on the wrong scale.** The Motivator's "+8 with low mood (under 40)" doesn't match the game's bands: Fired up 75+, Steady 50+, Flat 30+, Low under 30. Use Flat or Low.

**12. Three trust multipliers stack on the shout.** Coachability (0.7 to 1.0), morale trust (Low 0.7 up to Fired up 1.05) and the bond (0.90 to 1.10) multiply together, with two instructions a minute on top. A Low fighter with a Stranger corner and coachability 20 hears 0.7 x 0.7 x 0.9, about 0.44. Say which order they apply in and the floor. Also say who shouts when an assistant works the corner: the player always makes the calls, so the bond is with whoever stands in the corner, not the voice.

**13. The quarrel has no rule.** "A quarrel event (rare)" has no chance, no trigger, no warning and no price. The pack's rulings want every random swing readable. As written, it's a random -X bond the player can't see coming.

**14. Loyalty -5 has no effect.** Loyalty exists but isn't on the board, and a fighter leaving over it is AGREED, NOT BUILT. "-5 loyalty (coach_left)" moves an unseen number with no effect. CHECK (Claude): whether Loyalty.gd reads anything on screen.

**15. "The coach runs it" has no coach to run it.** In the pack, C20 is a per-fighter "Coach runs it / I run it" switch. Here the head coach is the player, so the auto-assign must come from the assistant (with that assistant's rating as how sure it is), or be a plain best-fit fill with no face.

**16. The second club coach.** The staff job "Second club coach 10 h" gives +1 roster place. The map doesn't say whether that coach has a list, a fit, a temper or a bond.

**17. Names, pronouns and the art style.**
- **Pronouns.** The map writes "his rating", "his list", "his school", "her corner" throughout. That's a fixed he for coaches and a fixed she for fighters (S412). The risk is the row text: "in his school x1.1" must be "in the pads coach's school x1.1".
- **The who-runs-whom table.** It has coach and fighter on every row, so it needs portraits with role and class, not names. Names go only in the Staff app header or a coach card's header.
- **The mockup.** It keeps names out (good). But "Feather 57 kg" on a male card isn't a men's class (57.5), and "Welter 69 kg" isn't one either (70). It also draws a dark slate desktop, not the whiteboard look (Look B) of section 7, and its left rail (Desktop, Mail, Schedule, Fighters, Staff, Finance, Records) isn't the pack's five buttons. If OFFICE1 is ruled, the pack needs updating.
- **The staff strip.** It shows pad nights, not the list and fit this map puts there (logic 4).

Part 2 of 3

## 2. Depth: 5/10

I tried to break it with four boxers, the head coach and one or two assistants.

**Is there an assignment that's always right?** Yes. Put the highest-rated coach in each area on the most sessions, and never move anyone.
- The rating part (+14) is the biggest single part, and it's paid twice (logic 1).
- The bond only grows while a pair stays together. A swap costs Stranger -6, and -20 mid-camp.
- Growth only happens where the coach already works.

All three point the same way: set the list in week 1 and leave it. The only things that change week to week are mood (after a loss) and a fight week's load, and both are small next to the bond.

**A temper nobody hires.**
- **Drill sergeant:** x1.05 gains and x1.05 fatigue nets out, since fatigue only matters past 80, and the coach takes -10 fit with any Flat fighter plus the quarrel risk. Nobody picks it.
- **Old hand:** +1 tiredness recovered per rest day, on a 0-100 scale, is invisible.
- **Technician:** x1.15 move learning on pad nights is bigger than the whole fit's spread (x0.90 to x1.10). Every pads coach should be one.
- **Motivator:** the -12 to -8 loss is real but rare (a few losses a season). It's the only temper with a moment the player sees.

**A bond that never matters.** Corner step needs 160 points, about a season. Before that, the corner multiplier sits at 0.90 to 1.05, inside what the map wants BONDPROBE1 to show (2 to 4 wins in 100 on close bouts). The mood hit when a Corner-step coach leaves only happens if the player fires the coach, and nothing makes coaches leave. So the bond is a reason not to change anything, not a decision.

**Growth nobody notices.** The opposite: it's too fast to miss (logic 7). Growth is noticed, but with a fixed wage, it's free.

**The weakest-stat part (+8)** belongs to the session, not the coach. It doesn't change who should run the session, so it adds a number without adding a choice.

**What changes a number the player sees?**
- On the week: yes, the fit word on each row, and the gain and tiredness.
- On fight night: the bond's "Heard / Half heard".
- The school: half its nodes have no mastery (logic 9).
- Loyalty: unseen (logic 14).

**The good part:** hiring the young Motivator at pads, watching the pads number climb, and reaching 65 for the second learning slot. That's a season arc a player will feel.

## 3. Play: 5/10

**It pulls me on:**
- "6 pad sessions to 65: second learning slots" on the Monday review.
- A bond step reached.
- The corner line on the result ("4 of 5 calls heard").

**What holds it at 5:**
- After week 1, Monday's table has nothing to do, and "the coach runs it" gives the same answer every week.
- Load can't bite until a bigger unit.
- The fight-week corner pick is always the head coach until an assistant reaches Corner.
- Nothing about a coach can go wrong: coaches don't leave, ask for money, get poached, or fall out in any way the player can see coming.

## 4. Options

**Missing:**
- **Who runs each morning:** a CoachArea for every morning session.
- **A wage review for a coach who grows** (pay the rise, or risk a rival gym's offer), so growth has a price.
- **The head coach's areas and school,** or a plain rule that the head coach runs no sessions.
- **Split a fighter by area:** one coach on pads, another on sparring. Today a fighter has one coach, so a Technician and a sparring specialist can't both serve one boxer.
- **The corner pick with its price** (bond x shout against the head coach's own) on the bout card, as an option and not just a line.
- **A warning before a quarrel,** with a choice to avoid it.
- **The ceiling at hire** as a range ("ceiling 70 to 80"), narrowed after 4 weeks, so hiring isn't blind.

**Useless as written:**
- The Drill sergeant and the Old hand tempers.
- The school on StrikeMap arrows.
- The -5 loyalty.
- The weakest-stat fit part as a coach choice.
- Load at the start.

**The menus:**

| Menu | Right place? | Found? | Can't act on or wrong |
|---|---|---|---|
| Week board (Training) | Yes | Yes | Mornings have no coach (logic 2); the rating counted twice |
| Office: Staff app (screen 5) | Yes, if OFFICE1 is ruled | From the desktop's rail | Not drawn; rows need portraits and roles, not names; Swap is rarely right |
| Office: Desktop | Yes | Yes | The mockup strip shows pad nights, not lists (logic 4); overload can't happen early |
| Fighter page, Training | Yes | Yes | One coach a fighter, no split by area |
| Fighter page, moves | Yes | Yes | The school cap stops Signature on moves no coach teaches; arrows have no bar |
| Learning-slot cards (SLOTS1) | Yes | Yes | The school reason is fine where the move has mastery |
| Monday review | Yes | Yes | Good; add a wage ask when a coach grows |
| Bout card / fight week | Yes | Yes | The corner shows as a line; make it a pick with its price |
| Fight: shouts | Yes | Yes | Three multipliers stacking; who shouts in an assistant's corner |
| Result page | Yes | Yes | Fine |

Part 3 of 3

## 5. To reach 10/10

Mechanics, most important first.

1. **Take the rating out of the fit, or out of the coach factor.** Keep one place where the area rating speeds gains (M6's pads rule). The fit then reads only what is about the pair: temper with mood, load, bond, school. Size it in FITPROBE1 so best against worst is still 4 to 8 wins in 100 without the rating.
2. **Assign by area, not by fighter.** Each fighter has a coach per area:
   - pads
   - sparring
   - conditioning mornings (roadwork, intervals)
   - strength mornings (weights, neck work)
   - bag mornings (heavy bag, speed bag, slip rope, shadow)

   A list counts sessions, not fighters (an assistant runs 8 sessions a week, +2 at area rating 80+). This uses the PADPOOL1 unit, so one load model runs everywhere, and with three boxers it binds at once. Now putting the Technician on pads and the conditioning coach on mornings for the same boxer is a real split, and load is a weekly trade.
3. **Make loyalty to one coach cost something.** The bond grows as written, but a pair at Trusted or Corner gets -4 fit in an area where the fighter's stat is within 5 of its ceiling with that coach ("this coach has taught all the coach can here"). Swapping that area to a fresher coach is then the right move at the right time. FITPROBE1 checks that the best list changes at least 3 times a season.
4. **Give growth a price.**
   - Each 5 points a coach gains, the wage asks +$50 a week on the Monday review: Pay, or say no (-10 coach mood and a 1 in 4 chance a rival gym makes an offer within 4 weeks, shown as a flag with its three answers: match it, promise, let go).
   - The market card shows the ceiling as a range from day one.
5. **Rework the tempers so each is somebody's best hire.**
   - **Drill sergeant:** sparring nights count as 1.25 of a sparring night for mastery and plan tests, at +3 fatigue a night. Best for a boxer far from the bout.
   - **Old hand:** a boxer back from injury or overreached (fatigue 80+) loses the x0.6 gains and x3 injury penalties one week sooner. Best for a crowded calendar.
   - **Technician:** x1.15 on pad learning only for moves already Usable, so it polishes rather than starts.
   - **Motivator:** keep it.

   FITPROBE1 bar: each temper is the best hire for at least one boxer type in the four bots.
6. **Fix the school.**
   - Schools hold only moves with mastery (punches and combinations) until StrikeMap arrows get mastery.
   - Replace "not past Sharp" with M6's Signature rate at x0.5 outside the school, so Signature is slower, not impossible.
   - The head coach's school comes from the background (Ex-pro: the pads moves; Amateur coach: Jab, Cross, Body hook; and so on).
7. **Set the head coach's rule.** Either the head coach runs 4 sessions a week at a fixed rating from the background, and the 60% no-coach rule becomes "the head coach alone", or the head coach runs none. CHECK (Claude) on HeadCoach.
8. **Make the corner a pick.** On the bout card, Who works the corner shows each candidate's shout multiplier (coachability x morale x bond, with the floor at 0.5). The player still makes the calls. A Corner-step assistant beating the head coach's own number is the reward a season of bond buys.
9. **Make the quarrel readable.** A Drill sergeant with a Flat or Low fighter shows "friction" on the row. Each week at friction, 1 in 6 chance of a quarrel (-15 bond, -5 mood), with the chance on hover and an answer: move the area or keep going.
10. **Fix the numbers.**
    - Use the Stranger threshold the two-week line means (about 12 sessions), or change the line.
    - Growth +1 per 20 sessions, and a shared night counts once per coach.
    - Mood bands Flat and Low.
    - Drop "-5 loyalty" until loyalty has an effect.
11. **The second club coach** gets a list of 4 sessions, conditioning mornings only, with no corner.
12. **The game's words and pronouns:** "the pads coach", "the fighter", "Step in", never his or her.
13. **The probe order:** FITPROBE1 (with the per-area lists), BONDPROBE1, the four S412 bots with the wage rise and the ceiling refresh on, then the build.

These need things the game can't do yet: the rival gym's offer (AGREED, NOT BUILT), loyalty with an effect, StrikeMap mastery, the office (OFFICE1), and the per-area coach on mornings.

### The 10/10 Staff app at 1920×1080

Inside the office desktop shell: dark top bar, the app rail on the left. It's drawn in the gym's whiteboard style if the owner keeps Look B for the office, or the dark kit if OFFICE1 is ruled otherwise.

- **Header** (full width, about 90 px): "Staff". Sessions used across the club against the pool ("23 of 26 this week"), the wage bill a week, and the one pulsing button: Lock the week.
- **Who runs what** (left and centre, about 1180 x 620 px): a grid. Rows are the boxers (comic portrait, class, mood word); columns are the five areas.
  - Each cell shows a small coach portrait, the fit word, and the bond step as a pip (Stranger to Corner).
  - "Taught all here" shows as a small marker on the cell.
  - Hover gives the fit's parts with points.
  - Drag a coach portrait from the right onto a cell to swap. Before the drop, the cell shows the new fit, the bond reset, and what stops growing.
  - A row for the second club coach appears only when that coach is hired.
  - "Coach runs it" sits at the bottom of the grid, with the assistant's face and one line on why.
- **The coaches** (right, about 560 x 620 px): one card per coach, the head coach first.
  - Portrait and role. The name appears in the card's header only.
  - The temper word with its one effect.
  - The five area bars with growth ticks ("7 sessions to 66").
  - The ceiling (a range until watched), sessions this week against the list, the school as move chips, and the wage.
  - A flag on the card when a wage ask or a rival offer is waiting, with its answers.
- **This week's price** (bottom left, about 900 x 230 px): the change in gains and tiredness the grid gives against "Coach runs it", per boxer, and any overload in red with its cost.
- **The market** (bottom right, about 840 x 230 px): up to four assistant cards (temper, school, area bars, ceiling range, list size, wage, signing fee) with Hire. A greyed card says why it's locked (no roster or wage room).

There's no score and no best-list badge. Hovering any number shows its rule.

CHECK (Claude): whether HeadCoach has area ratings; what Loyalty.gd reads on screen; whether mornings carry a CoachArea; the PADPOOL1 count against the mockup's 6 + 3.
