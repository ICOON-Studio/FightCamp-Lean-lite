# DESIGN_AMATEURWEEK1_V7_CRITIC_JOHN_JOHN - John answer (seat queue SQ80)

Brief: research/DESIGN_AMATEURWEEK1_V7_CRITIC_JOHN.md
Sent: 2026-11-13 23:11 | collected: 2026-11-13 23:41 by Tools/seat_queue.py (the 30-min reconcile)
Verify the sources before using it.

---

I'm reading AMATEURWEEK1 v7 against the pack and checking the weight widths and pull-out numbers now. The full critic return comes next.

# AMATEURWEEK1 v7 (S459): critic

Scores: **depth 6/10, general design 5/10, play 6/10**. That clears the bar on depth, and **misses the bar on general design by 1 point**. I couldn't open `CRITIC_ACCESS.md` or the board, because your computer is offline, so I judged from the map, the pack, and my S449 boxing sources.

Names and pronouns pass: names stay in headers, and the copy avoids a fixed he or she.

## Answers to the two `CHECK (John)` flags

1. **The 2026 England Boxing weight widths against the game's classes:**
   - Under [England Boxing's 2026 rules](https://www.englandboxing.org/wp-content/uploads/2026/01/2026-Rule-Book-Final-01-26.pdf) (rule 2.7.8, OFFICIAL), seniors are matched within the width of the **smaller** of the two boxers' weight categories (for example, 62.5–65 kg against 65–70 kg allows at most **2.5 kg**).
   - Against the game's 4-class tables (women 57 / 60 / 65 / 75 kg, men 57.5 / 60 / 70 / 75 kg), the map has a hole: EB splits 60–63, 63–65, 65–70, and 70–75 kg into 2–5 kg bands, whereas the game's table jumps **10 kg** at women's 65–75 kg and men's 60–70 kg. If the code reads "category width" straight from the game's 4 classes, heavyweight/welter pairs could match 10 kg apart instead of EB's 5 kg cap. Define explicit widths (2.5 kg up to 65 kg, 5 kg above 65 kg, 2 kg for skills bouts).
   - Also, v7 mixes two incompatible rules: it keeps **"slot = class limit"** (must make 60.0 kg) AND adds **"paired within category width of walking weight"**. At an EB club show there is no class limit to cut to—you weigh in 1 hour before boxing (rule 7.1.3) and match within the width. Keeping both means a 62 kg boxer can be forced to cut to 60.0 kg *and* still sit inside a width check, while **ASK FOR A KILO** over a championship-style class limit has no basis in EB rules (and there is still no real-world "$300" miss-weight fine in the rule book).

2. **The amateur pull-out rate in the final week:**
   - My S449 sources found **25–50%** lost in the final week: Wellingborough ABC lost 9 of 18 bouts in 5 days, or 50% ([Northants Telegraph, 22 Sep 2025](https://www.northantstelegraph.co.uk/sport/wellingborough-abc-homeshow-shows-off-club-talent-5329674)), and Bexhill ABC expected to lose 5–6 of 21 bouts in 4 days, or 24–29% ([Sussex Express, 4 Jun 2015](https://www.sussexexpress.co.uk/sport/boxing/club-set-to-host-first-open-show-2221853)).
   - So v7's **35 in 100** sits squarely inside the sourced range.

## Logic check

**The 25-tank cap still lets tired boxers train through and spar late for free.** Section 4.2 claims: *"The cap cuts tiredness last... A tired boxer still pays in full for Train through, sparring and a cut."* Check the arithmetic at **75 start tiredness** (25 over 50):
- **Tick over:** 6 (load) + 19 (tiredness) = **25 off**.
- **Train through:** 12 (load) + 13 (tiredness) = **25 off**.
- **Train through + 2 fight-week sparring nights (6) + Train weight off (+8 tiredness):** 12 + 6 + 7 (tiredness) = **25 off**.

In all three cases, the tank at the bell is **25 off**. Putting tiredness *last* inside the same 25 cap doesn't make a tired boxer pay more—it just relabels more tiredness as "already lost" while handing out Train through's 720 pad units and two sparring nights at zero marginal tank cost. Only Rest up changes the tank at 75 tiredness.

**Fall-through timing misses the bout, and the cottage refund defies physics.**
- Section 6–8 says fall-throughs happen "in the final week" and *"wait for Monday and stop the clock once"*. Club shows run on **Saturday**. If a Tuesday–Friday withdrawal waits for Monday, Monday is **after** the bout! It has to fire on the **Monday opening fight week** (5 days out), or else stop the clock mid-week on Thursday/Friday.
- Section 4.1 says **Hill cottage** is **"week before only"** and refunds half on a fall-through. If the bout falls through in fight week, the boxer and coach *already lived in the cottage last week*. A cottage doesn't refund a completed stay.

**Missing numbers and undefined mechanics:**
- **`EAT LESS` tank cost is missing.** Section 4.2 lists "the weight" as a tank part, and 4.5 says `TRAIN IT OFF` (+8 tiredness for 0.3 kg) beats `EAT LESS` under ~42 tiredness—yet the map never states what tank penalty `EAT LESS` (Cut 500 kcal) pays. A developer cannot build the tank bar without it.
- **`FLAT` at 65+ tiredness is contradictory.** Section 4.3 says Rest up gives *"FLAT, edge against 2.0 under 40 start tiredness, 1.0 at 40-64, none at 65+"*. If there is no edge against at 65+, what does "FLAT" mean on Round 1? Either Rest up is sharp at 65+ (just without the +1 line boost), or the map needs to say what FLAT changes.
- **Rest up "Carried: tiredness to 30"** sits in the post-bout row where Train through puts `+6 tiredness`. Clarify that Rest up lowers tiredness to 30 *during fight week* (before the bell), not after 3 rounds of boxing.
- **Plan Test vs Unsparred loop:** Section 4.4 says a sparring Plan Test rates your lines *"so the player can still change the plan"*—but any changed line immediately becomes **UNSPARRED** again, firing a tier down in rounds 1–2! Also, a week-before sparring night only readies **two lines** (on a 4–6 line plan), doesn't say *which* two, and doesn't say who an early 1-boxer club spars when there's no second club boxer yet (in the pack, the second walk-in arrives *after* the first bout).
- **Sparring 5 or fewer days out** only costs 3 tank and ×1.5 training injury (base ~1.3%/week, so ~0.6% extra). Both Pack 4.1 (`TAPER: no sparring`) and real boxing ([Frank Buglioni, Boxing News, 1 Apr 2016](https://boxingnewsonline.net/features/frank-buglioni-how-to-handle-fight-week/)) avoid sparring in fight week because of cuts, head impact, and dead legs—not a tiny 3-point tap.

**Economic and pack mismatches:**
- **Hill cottage ($745–$1,170 + $350 lost evening class = $1,095–$1,520)** eats 5–7 weeks of an early club's profit for a bout that pays **$450** (or $0 away) for a ~1–4% win bump. No sane amateur manager buys it except perhaps for a Nationals final.
- **City club week unclear:** Section 4.1 doesn't say whether City club can be picked in the Week Before, in Fight Week, or both.
- **Fundraiser is still a chore or a trap (K9/J13):** At "Known locally" it nets **−$150** (never click it); at "Respected+" it nets **+$150** once every 8 weeks with no energy, morale, or training cost (pure free click). Plus Pack 4.12/4.13 prices the assistant's evening classes at **$350/week**, so replacing an evening class needs its true net stated clearly.
- **Film on 0-bout opponents and false-tell math:** Pack 4.6 says 0-bout opponents have no tape, and S449 notes most club amateurs have little or no tape; v7 doesn't say whether 0-bout opponents lock film nights, nor whether a second film night *only* raises 70%→90% or also unlocks another tell group. And "drops a level" needs to say "cleared as false".
- **Unlisted pack changes:** Offers shrinking from 8–12 weeks (Pack 4.5) to **1–3 weeks out** changes `Matchmaking` and `Set camp` (3+ weeks), yet Section 12 omits it from the unbuilt list. `Savings` saying jobs stop *"only if the background says full-time on the stipend"* also clashes with the toggleable `$250` stipend on Money.
- **Shared-class slot lock:** Automatically handing a class slot to whichever boxer waited longer takes the matchmaking choice away from the player.

## Depth: 6/10

v7 fixes the main depth flaws from v6:
- **SEASON** no longer prints the answer, comparing only against Tick over within the start-tiredness band while leaving opponent gap, unsparred lines, and move thresholds to the player and the assistant.
- **Train through** now banks 720 pad units toward plan moves near Usable (30) or Sharp (60), creating a real tactical threshold against Tick over's temporary +1 tier boost in rounds 1–2.
- **Sparring** has real bite via `UNSPARRED` lines and the Plan Test, and **Who pays** now separates Club, Half each, and Boxer through the Confidence gate, skint penalty, and roster fairness.
- **Rest window** (3/5/8 weeks), ring rust, home-vs-away trades, and favours weave Fight Week cleanly into Money, Roster, and Matchmaking.

What keeps it at 6: the 25-tank cap still gives tired boxers Train through and late sparring for free on the tank; Hill cottage is priced out of amateur club economics; Fundraiser is a free click at Respected+ and a trap below; and auto-locking shared-class slots removes a manager choice.

## General design: 5/10

What it gets right:
- S448 names and S412 pronouns are clean throughout.
- Probes (`FIGHTWEEKPROBE4`, Assistant Probe, `CAMPPLACE1`, `BudgetProbe`) have real numeric targets and a defined fallback if the pick gap is under 1 in 100.
- Plain Attrs names, kg classes, and a Look B whiteboard spec without unapproved widgets.

What misses the 6+ build bar:
1. The tank-cap rule still fails its own claim at 75+ tiredness.
2. `EAT LESS` has no stated tank number, and `FLAT` at 65+ tiredness contradicts "none at 65+".
3. The weight rule mixes class-limit cuts with category-width pairing, and leaves the game's 10 kg class jumps undefined.
4. Fall-throughs "waiting for Monday" miss Saturday's bout, and Hill cottage refunds a week that already finished.
5. Section 12's 1920×1080 spec calls sparring magnets and weight buttons "sliders", omits the `WEEK BEFORE` strip, and keeps both `Use the pick` and `Back to the coach's week`.
6. Unclear Plan Test re-unsparring, 0-bout film locks, City club weeks, and unlisted `Matchmaking` lead-time changes.

## Play: 6/10

The loop now has real weekly decisions: setting the rest window after a tough fight, watching old rematch tells come back at `SEEN`, juggling whether a late plan tweak is worth a fight-week sparring hit, and reading the gold `ON FIGHT NIGHT` board. What holds Play back: a 35% final-week pull-out rate (3–4 times a season) will frustrate players if replacements are unscouted and film nights vanish with no upside; Hill cottage sits unusable in the corner; and Fundraiser feels like routine maintenance rather than a gym event.

## Options

| Option | What it changes | Verdict |
|---|---|---|
| Rest window (3 / 5 / 8 weeks) | Next offer timing, fatigue recovery, ring rust | Keep. Stop forcing shared-class slots onto the longer-waiting boxer. |
| Pass sheet / Pass named card | Club lockouts (2 refusals in 8 weeks) | Keep. |
| Assistant bout pick | Picks home vs away from boxer's goal | Keep. |
| Home / City commute / City alone | Round-1 style edge (+1.0 / +0.5), injury ×1.15, +1 tiredness/day, cash | Keep. State which week(s) it applies to. |
| Hill cottage | −10 tiredness, no `TrainingLoad` spike in Week Before | Useless for club bouts at $1,095–$1,520 total; keep only if re-priced or reserved for Nationals/camp. |
| Load stop (Rest up / Tick over / Train through) | Tank, R1 sharpness/boost, pad units banked, carried fatigue | Keep once the 25-tank cap stops absorbing Train through and late sparring. |
| Sparring nights (Week before / 7–6d / ≤5d) | Readies plan lines, runs Plan Test, costs pads or tank + injury | Keep, but increase the ≤5d penalty and clarify Plan Test re-edits. |
| Weight (Eat less / Train it off / Ask for a kilo) | Scale margin, tiredness, tank, −1 favour | Define `Eat less` tank cost and explicit 2.5/5 kg widths. |
| Who pays (Club / Half / Boxer) | Club cash, savings, skint risk, morale | Keep. |
| Fundraiser | ±$150 every 8 weeks | Useless / chore as written; needs a real cost (cancels pads/sparring that night) and real stakes, or cut it. |
| Film night | Opens tell group at 70% / 90% truth for 1 pad night | Keep, clarify 0-bout lock and what night 2 buys. |
| Fall-through answers (Replacement / Go home / Next month) | Bout kept vs −6 mood vs −1 favour | Keep, triggered on Monday of fight week (5 days out). |
| Use the pick / Back to the coach's week | Resets fight week choices | One is redundant; keep `Use the pick` only. |

**Missing:**
- **Pick which boxer takes a shared-class slot** when two club boxers share a kg class (default to longer-waiting, with a swap button).
- **Clear handling for a 0-bout opponent on Film nights** (locked with "no tape on a debutant") and **1-boxer club sparring** in Week 4 before the second walk-in arrives.
- **Explicit tank figure for `Eat less`** and **explicit width table** (2.5 kg ≤65 kg, 5 kg >65 kg).

## To reach 10/10 (most important first)

1. **Fix the tank-cap exploit for real.** Split the tank penalty into two layers: **tiredness over 50** caps at 25 (representing chronic fatigue), and **fight-week choices** (`Tick over` 6, `Train through` 12, fight-week sparring 3 each, `Eat less`) subtract *after* the tiredness cap (or raise the total cap to 40 while capping tiredness alone at 25). Then a tired boxer at 75 pays every single point of `Train through` (25 + 12 = 37 off) and late sparring.
2. **State `Eat less` tank cost and clarify `Rest up` wording.** Give `Cut 500 kcal` a fixed tank cost (for example 4 off the tank, matching why `Train it off` at +8 tiredness beats it under ~42 start tiredness). Rewrite `Rest up` at 65+ tiredness as **Sharp (no boost)** rather than *"FLAT, edge against: none"*, and clarify that `Rest up` drops tiredness toward 30 **before the bell**, not post-bout.
3. **Fix the England Boxing weight rule cleanly.**
   - Separate **club shows** from **championships**: at club shows, weigh in on bout day (1 hour prior, EB 7.1.3) and match within an explicit **weight-gap table** (**2.5 kg** at 57/57.5/60/65 kg, **5 kg** above 65 kg, **2 kg** for skills bouts—never reading raw 10 kg jumps from the game's 4-class list).
   - `Ask for a kilo` (-1 favour) only applies when a boxer is within that gap of the opponent's weight; **championships/Nationals** keep the hard class limit with no favours.
4. **Fix fall-through timing and the cottage refund.**
   - Roll and surface final-week pull-outs at the **Monday opening fight week (5 days out)**, so all three answers happen *before* Saturday's show.
   - Only refund Hill cottage if booked for **Fight Week** (cancelled at check-in) or remove the refund on a completed Week Before stay; also price Hill cottage for club budgets (or limit it to **Nationals / multi-week camps**).
5. **Resolve the Plan Test / Unsparred catch-22 and late sparring cost.**
   - State clearly: *"Changing a line after sparring marks that line UNSPARRED unless you run another sparring night."* Say which two lines a week-before night readies (first two changed/unsparred lines in order, or player pick).
   - Allow a generic club sparring partner for Week 4 when the player only has one signed boxer.
   - Increase fight-week sparring (≤5 days out) to **5 off the tank and ×2.5 injury risk** so it matches real fight-week risk (cuts/heavy legs).
6. **Let the player pick the boxer in shared-class slots.** Default to the boxer who waited longer, with a one-click swap to your other boxer in that kg class.
7. **Fix Fundraiser and Film night edges.**
   - Either cut `Fundraiser` from Fight Week (it belongs on Club > Money if kept) or replace the free +$150 click with a real trade: cancels that night's training/evening class and draws +$250–$500 by reputation, costing −1 pad night across the roster.
   - Lock Film night when the opponent has **0 bouts** (*"No tape on a debutant"*), say that a second film night unlocks the next tell group *and* raises `SEEN` tells from 70% to 90%, and rename "drops a level" to **"cleared as false"**.
8. **Align the pack and clean up Section 12's layout.** List `Matchmaking` lead-time changes (8–12w → 1–3w) and `Set camp` adjustment in Section 12; align `Savings` with the Club stipend toggle (day-job savings apply only when the stipend is turned off); remove the redundant `Back to the coach's week` button (keep `Use the pick`); fix "SPARRING and WEIGHT sliders" to magnets and action buttons; and give the `WEEK BEFORE` strip its own row above the 7-day board.

## The 10/10 page at 1920×1080 (Fight week, Look B whiteboard, 2-week bout)

- **Shell:** existing dark top bar and left rail around the warm tan wall and aluminium-framed whiteboard.
- **Header strip (96 px):** both portraits, both names once, class in kg (plus the club-show weight gap), records, days to the bell, Home or Away badge, host favours (`0–3`), and scale margin now / on the day.
- **Week Before strip (84 px, shown only when 2+ weeks out):** Week Before trip pill, optional Week Before sparring magnet (−1 pad night, readies 2 lines), and booked status.
- **Left column (440 px):** **WHERE TO TRAIN** cards (Home, City commute, City alone, plus Hill cottage only for Nationals/camps) with cash, round-1 edge, and fatigue/injury price; conditional red-edged **COACH AWAY** warning card (appears only when the trip pulls a coach away, showing exact home factor and -$350 if full-week); **WHO PAYS** (Club / Half / Boxer with savings, confidence gate, and skint/fairness tags).
- **Centre (920 px):** **THE WEEK** as 7 day columns of session magnets (drag/place up to 2 red sparring magnets and 1–2 tape film magnets); below it, one **LOAD** three-stop selector (`Rest up` / `Tick over` / `Train through`) with the `Tick over` Usable/Sharp line picker, and **WEIGHT** action pills (`Eat less` / `Train it off` / `Ask for a kilo` with its favour cost); under that, **PLAN LINES** chips tagged `Ready`, `UNSPARRED`, `SEEN (70%/90%)`, or `CONFIRMED`.
- **Right column (560 px):** **ON FIGHT NIGHT** in the one gold frame—three rows (`TONIGHT` stacked tank showing 25-cap tiredness + post-cap choice penalties, R1 sharp/flat, line fire shares, scale margin, win band; `BANKED` exact Attrs delta, moves crossing tiers, carried tiredness; `SEASON` vs `Tick over` in this tiredness band), each showing its delta from the assistant's pick, with component breakdowns on hover.
- **Bottom strip (120 px):** your assistant's portrait and one-sentence note (no names), **Use the pick**, and the red **Lock the week** button (green reserved for Continue).
