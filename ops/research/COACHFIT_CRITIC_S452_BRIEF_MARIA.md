# COACHFIT_CRITIC_S452_BRIEF_MARIA - Maria answer (seat queue SQ68)

Brief: research/COACHFIT_CRITIC_S452_BRIEF.md
Sent: 2026-11-13 15:43 | collected: 2026-11-13 16:10 by Tools/seat_queue.py (the 30-min reconcile)
Verify the sources before using it.

---

I couldn't open `office_a.png` from here: it's on your machine and Beast didn't come up in this turn. So the screen part below is judged from the map's menu table, not the mockup.

## 1. Logic check

**Contradictions with the pack or the code**
- **The head coach's rating doesn't exist.** The map says so itself (section 7, CHECK). Until `HeadCoach.gd` gets a rating, the head coach's row on the table has no number to show, and its fit word can't be computed.
- **Pads coach versus conditioning coach.** The pack's code facts say Luke Reid is pads 74 (rating 58) and Marcus Hale is pads 58 with conditioning 90 (rating 74). The map makes "the pads coach" a Technician and "the conditioning coach" a Drill sergeant. That works, but Marcus is also the better-rated coach overall. If the rating "counts once" in the coach factor, the table will usually put Marcus on everything he's rated for, until his list fills. That's fine, but the map never shows that the list cap, not the fit, is doing the work.
- **Bout card corner pick versus amateur rules.** In the pack, the corner minute and calls exist for every bout, but the Cutman staff job is "$150 a pro night". The map doesn't say whether the corner pick includes a cutman slot. On a pro night that's a second corner role the player already pays for.
- **"SAY NO costs the -10 mood only."** Coach mood doesn't exist in the code or the pack. Only fighters have morale. The pay-or-say-no choice therefore has no consequence the game can act on today, and "coach mood" has no screen, no effect and no recovery rule.
- **"Old hand" is used twice.** It's a head-coach background (easier weight cuts) and the map's new assistant temper (sooner return from injury). One word should mean one concept (section 7 ruling), so the temper needs another word.
- **Discipline and coachability.** The map reads discipline 70+ and coachability 70+. The S448 code facts say the old personality values are kept as a summary and the new attribute set has Composure and Heart. Discipline and coachability still exist as personality values (section 3, BUILT), so that's OK. But the map should say which file it reads them from, because the attribute rewrite might drop them.
- **Session count assumption.** "Four boxers training about 5 coached sessions each (20)" doesn't match the week as built: 7 mornings plus 3 pad nights plus sparring nights is 10 to 12 possible sessions per fighter. If every non-rest session is "coached", four fighters need 30 to 40, not 20. The list binds harder than the map says, so "alone" becomes the default rather than an exception. Either define which sessions count as coached (for example evenings plus Hard mornings only) or resize the lists.
- **Roster places.** Four fighters needs the Bigger unit (5 places) or a second club coach (+1). With the starting Unit (3 places) the map's own example can't happen. That's worth saying, because the system only bites mid-game.

**Buttons or numbers the game couldn't act on at that moment**
- **Swap during taper week:** the swap carries a -20 bond penalty mid-camp. The map doesn't say whether Swap is allowed on fight week or locks. It should show the price or be greyed with a reason.
- **Pay / Say no on a raise when cash is below $0:** Pay should be disabled with "not enough cash", or allowed to push into debt. That has to be decided.
- **The rival offer flag:** AGREED, NOT BUILT, so the 1-in-4 chance has nothing to fire. Hide it until it's built.
- **"Ceiling 62-74" range:** the range should narrow over 4 weeks, but nothing says what the player does to narrow it faster. That's fine as a reveal, but it isn't an action.

**Names outside a header**
- None in the map's rows. The bout card's "WHO WORKS THE CORNER" list will show coach names in rows. That's allowed only if each candidate is a card with the name as its header. Spell that out for the build.

## 2. Depth: 6/10

**What holds up**
- Area assignment with session lists makes the coach a scarce resource every week, not a one-off hire.
- The taught-out rule is the best idea here. It forces a change at the right time, and it's driven by the fighter's progress, so it moves on its own.
- The corner pick turns a season of bond into a fight-night number. That's the payoff.

**Where it breaks**
- **There's an always-right default.** Fit sits on top of a rating that still drives the coach factor. The best-rated coach on the fighter with the nearest bout is right almost every week until taught-out kicks in. Taught-out needs Trusted or Corner plus a stat within 5 of the ceiling, so it arrives late, maybe twice a season per pair. The FITPROBE1 bar of "the best table changes 3+ times a season" is too low for "a real decision every week".
- **The fit spread is small.** Gains move x0.90 to x1.10 and tiredness x0.94 to x1.10. On a morning that adds a fifth of a point, the difference between TOP FIT and RISKY is about 0.04 of a stat point. Nobody will see that on the week. It becomes visible only over a season, which is exactly the problem Kalli flagged in v1.
- **The temper choice is mostly hire-time.** Each coach has one fixed temper. You choose it once, at hiring. Week to week, the temper only matters through friction (Drill sergeant with a Low fighter) or the Motivator bonus. Both depend on mood swings the player doesn't control. So the decision is "react when mood drops", not "plan".
- **Old hand (the temper) is narrow:** it only matters after an injury or overreaching. Since overreaching is a player mistake, an Old hand rewards bad play, and a careful player never hires one.
- **Bond is mostly time.** +1 per session and -2 a week apart means you build bond by never moving people, which works against taught-out. That tension is the design. But the numbers (Working at 12, Trusted at 60, Corner at 140) mean Corner needs about a season with one coach. With one assistant across four fighters, only one pair reaches it, so bond matters for one fighter only.
- **Growth is visible only as raise demands.** The +1 per 10 sessions shows up as a cost, not as a gain the player sees on the week. Nobody notices growth on the week board until the coach asks for money.

## 3. Play: 5/10

A Monday table of fighter × area × coach with fit words is spreadsheet work, unless something visibly happens because of it. The map's visible outcomes are a fit word on a row, a hover with points, a raise prompt, friction now and then, and a corner number on fight night. The weekly gain differences are too small to feel. The best moments are the taught-out swap and the corner pick, and they come rarely. I wouldn't press Continue to find out how my coach table did. I'd press it for the fight, and fix the table only when a flag tells me to.

## 4. Options: missing, useless, and what each changes

**By menu**

| Menu | Missing | Useless or weak | What it would change |
|---|---|---|---|
| Week board | A visible gain preview per session in stat points ("+0.22 Power, TOP FIT; +0.19 RISKY") | The fit word alone, without its effect in points | The player sees the decision's payoff on the week, not only a label |
| Staff app table | "Copy last week" and "Lock this cell" (so the coach-runs-it fill won't overwrite it) | Swap on a cell where the alternative is the same coach or "alone" with the same fit | Fewer clicks; the important cells stand out |
| Staff app cards | A history line: sessions run with each fighter, and bond trend this month | A ceiling range that never narrows faster by any action | Growth becomes visible, not just a raise demand |
| Office desktop | A "list full next week" warning before Monday, not only "over list" after | — | The player plans instead of reacting |
| Fighter page | The fighter's preferred coach (from bond and fit), and what the fighter loses if moved | Showing all five areas when three are "alone" | Moving coaches has a visible cost on the fighter |
| Monday review | Growth as a gain: "the pads coach reached 65: Technician bonus now applies to Sharp moves" | A raise prompt with no context on the coach's value | The raise becomes a value judgement, not a tax |
| Bout card | A cutman slot on pro nights; each candidate's number shown against the head coach's | — | The corner pick becomes a real comparison |
| Fight shouts | — | "Heard / Half heard by bond" if bond's multiplier (0.90 to 1.10) never changes a call's outcome in testing | Remove it if BONDPROBE1 shows no effect |
| Result | — | "4 of 5 calls heard" without what the unheard call cost | Tie it to the Why: "the unheard call cost about 3% win chance" |

**Missing outright**
- A way to raise the coach's list, other than the area-80 rule: overtime pay for +2 sessions this week, with tiredness for the coach.
- A coach's own fatigue or burnout. Without it, a coach over their list just takes a fit penalty forever.
- The fighter asking for a coach ("wants the pads coach on the pads before the bout"), tied to the existing "her asks" mechanic. That makes bond and mood a two-way decision.

## 5. To reach 10/10

**Mechanics, most important first**
1. **Make the fit change visible numbers every week.** Widen the fit's effect to gain x0.80 to x1.20 and tiredness x0.85 to x1.15. Show each session's predicted gain in stat points on the row. Target: TOP FIT versus RISKY differs by at least 0.5 stat points a week on a focused area. Check it in FITPROBE1 by measuring weekly visible change, not wins per season.
2. **Define a "coached session" so the lists bind correctly.** Count evenings (pads and sparring) and Hard mornings only; Light and Normal mornings train alone at 0.6 unless the player assigns them. Then four fighters need about 16 to 22 coached sessions against 12 available: tight, not hopeless.
3. **Give coaches a weekly energy, not just a list.** Each coach has 10 energy a week. A session costs 1, a Hard session 1.5, a corner night 3. Over the list, energy goes negative and next week's list shrinks by the deficit. That turns "over list" into a two-week trade, not a flat penalty.
4. **Bring taught-out forward and make it graded.** Start the fit penalty at Working when the stat is within 10 of the ceiling (-2), rising to -6 within 3. Show "taught out in about 3 weeks" on the row. Then the move is planned, not sprung on the player.
5. **Make each temper a weekly choice, not only a hire.** Give every temper a "mode" for the week: the Motivator can "lift" (+mood, -1 gain tick) or "drill" (normal). The Drill sergeant can "push" (+mastery, +fatigue) or "ease". One toggle per coach per week, with its effect on the row. Now the temper is a weekly lever.
6. **Replace coach mood with something the game can act on.** "Say no" to a raise lowers the coach's list by 1 session for 4 weeks ("working to rule"), shown on the card. When the rival offer is built, add it on top.
7. **Spread bond.** Lower the thresholds (Working 8, Trusted 35, Corner 90) and make "apart" decay -1 a week, so two or three pairs can reach Trusted in a season, and taught-out swaps don't destroy everything.
8. **Make the corner pick show the difference.** On the bout card, show each candidate's expected heard calls ("about 4 of 6 heard") and the swing in win chance that comes from it, from BONDPROBE1's measurement.
9. **Retire the injury-only temper.** Rename the temper (one word per concept) and make it about the calendar: "Steady hand: on a week with a bout inside 14 days, tiredness x0.85 on every session". Everyone with a busy fight schedule then wants one.
10. **Tie the fighter's asks to coaches.** A fighter at Trusted with a coach asks for that coach on the pads in camp. Hear it (+5 mood) or overrule it (-5 mood). That uses the existing mechanic.

**My 10/10 screen: Office › Staff, 1920×1080**
- **Top bar (dark, as built):** the shell, with the big button. Its line names the next stop, for example "to Mon 12 Feb, set the coach table".
- **Header (full width, 80 px):** "STAFF: WEEK 6" with this week's coached sessions against capacity ("18 of 16 sessions coached; 4 alone") and one red flag if a list is over.
- **Left column (420 px), COACHES:** one card per coach (the name only in the card's header), stacked.
  - Each card shows the face (comic portrait), temper word plus this week's mode toggle, area ratings as small bars with growth ticks, the ceiling range, energy (10 pips, coloured by state, with a word), wage, and any raise request with Pay / Say no.
  - At the bottom, "Hire" opens the market as a slide-over.
- **Centre (1000 px), THE TABLE:** rows are fighters (the name in each row header only, the rest pronoun-free), columns are the five areas.
  - Each cell shows the coach's portrait, the fit word with a fill bar, the predicted gain this week in stat points, the bond step as 4 pips, and a tag (FRICTION, TAUGHT OUT IN 3 WKS or ALONE).
  - Click a cell for a small popover: each available coach with the new fit, gain, energy cost and bond reset shown before the switch. One button: Swap.
  - At the bottom: "Coach runs it" (fills the table and says why in one line), "Copy last week", and per-cell lock icons.
- **Right column (420 px), WHAT THIS TABLE DOES:**
  - The season-to-date chart of each fighter's focus stat, with the coach table's share of the gain shaded.
  - THIS WEEK's predicted gains per fighter as numbers.
  - The next bout's corner candidates with expected heard calls and the swing in win chance.
  - One line for the next problem coming: "the pads coach's list full from week 8 when the second camp starts".
- **Footer (60 px):** "Back to the office" and the hover key for the words. The only pulsing button is the top bar's.

That screen gives the player a decision with a visible payoff every week, which is what the map still lacks.
