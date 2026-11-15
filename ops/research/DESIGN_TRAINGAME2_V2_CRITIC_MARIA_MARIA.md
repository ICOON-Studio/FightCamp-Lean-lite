# DESIGN_TRAINGAME2_V2_CRITIC_MARIA_MARIA - Maria answer (seat queue SQ180)

Brief: research/DESIGN_TRAINGAME2_V2_CRITIC_MARIA.md
Sent: 2026-11-15 15:10 | collected: 2026-11-15 15:40 by Tools/seat_queue.py (the 30-min reconcile)
Verify the sources before using it.

---

**TRAINGAME2_V2: DEPTH 6, GENERAL DESIGN 6, PLAY 6.** It clears the S459 bar, just. The trade is now real and its costs are drawn from the rule. But two of its five options already exist in the game, one may not exist at all, and the main payoff number ("fires 1 in 2") still has no wins figure behind it.

**DEPTH 6/10**
- The week's question is real. "Check hook or body hook ready by Friday" has a right answer only against the opponent's style, through the Playbook's Rate against. That ties training to the plan, which is the game's star.
- I re-did the arithmetic and it holds:
  - A's check hook goes from 12 to 28.2, which is 8.1 a night over two nights.
  - B and C add a third night to reach about 34.6.
  - E multiplies A's 16.2 gain by 1.12 to about 18.1, so 30.1, Usable by a hair.
- The three prices for "both moves ready" are genuinely different currencies: C costs a sparring night (Fight IQ and the sparring share), D costs tiredness and load, E costs money. That's good design.
- **The overreach band is the strongest part.** From a carried-in 60, D's Saturday lands at about 81. That night's own gain drops to ×0.6 and injury risk rises ×3, so adding a night can be a loss. Real coaches see the same pattern: overreaching in the last two weeks before a bout is the classic cause of flat performances and sparring injuries.
- **Where depth leaks:**
  - **E probably isn't a choice.** Most gyms have one assistant coach. Unless CHECK 3 shows that pad rating feeds the gain and the 74 coach can be put on one boxer's night, E is either always on or never available.
  - **C may be close to free.** Fight IQ +0.12 is about one whole point every 8 weeks. If sparring's drill share is small at 29–35 mastery, swapping sparring for pads wins almost every time. CHECK 1 decides it.
  - **Breadth against depth is named but not priced.** Section 2.4 admits that Usable over not ready is NOT MEASURED. Until P2 runs, the player can't weigh "two moves Usable" against "one move toward Sharp".
  - **No interaction with the other two users of pad nights:** the step study slot (StepMastery rises on pad nights, about 6 a week) and a second fighter sharing the coach's nights (agreed in pack 4.2). Padding the check hook should visibly slow the step in the slot.

**GENERAL DESIGN 6/10**
- Cleaner than v1:
  - one vocabulary (Stamina, Fight IQ, Attrs words for mornings);
  - the night as the unit;
  - the drawn tiredness line replaced by the rule's line;
  - the useless 70/30 and 30/70 pills and the Neck tile cut;
  - an S425 menu table with wires.
- **C and D aren't new.** Pack 4.1 already lets the player set any evening to Pads, Sparring, Rest or Film, so swapping sparring for pads and adding pads on a rest night are plain editing today. What's new is only the forecast. The map should say so, and owner question 2 is then about removing a freedom, not adding one.
- **Film is missing** from the evening options altogether, though it's one of the four evening types in code.
- **The menu table names "Gym > Staff",** which doesn't exist. Staff lives on Club > People.
- **The 10/10 page uses Bebas Neue and IBM Plex Mono.** The owner's kit is marker fonts (Permanent Marker, Kalam) on the Look B whiteboard, and he complained about "no art consistency".
- **Nine CHECKs carry the numbers,** including the tiredness cost of a pad evening (CHECK 1), on which C, D and the whole P1 tuning rest. The repo wasn't opened, and neither was `CRITIC_ACCESS.md`, so the forecast chip isn't checked against the real Week screen.
- **"Fires 1 in 2" is honest but weak.** It describes a mechanism, not an outcome, so the player can't act on it until P2 runs.
- The fight-night line depends on an unanswered owner question 1. The recommendation (a) matches real practice: nothing new is taught in fight week, only sharpened.

**PLAY 6/10**
- Anticipation is good: "Check hook 28.2 of 30 · last night to make it: Fri 20" is a clear weekly question with a deadline.
- The reward lands three times: the week-review stamp, the ring turning toward Sharp, and the fight-log line "drilled Fri 20". That last one is the best idea in the map, because it ties a Tuesday decision to a Saturday punch, the way the Why ties the plan to the result.
- The miss is visible too, with plan lines greyed for a move not ready.
- **What holds it at 6:**
  - The payoff on fight night is a fire count, not a wins figure.
  - A week with no near-tier move has no question at all.
  - The map doesn't say what the top strip reads then. Most weeks between fights may be quiet, which is fine, but say so.

**What each option changes**
- **Night card:** +6 to +9 mastery on one move per whole night, the main lever.
- **Whole night or half and half:** one move +7.5, or two moves about +3.7 each. Useful only within about 4 of a tier.
- **Swap sparring for pads (C):** +1 pad night, at the cost of Fight IQ +0.12 and sparring's share for moves at 30+.
- **Pads on a rest evening (D):** +1 pad night, at the cost of tiredness (+7 on the line) and a possible load jump to ×2–4 injury.
- **Pad coach on the night (E):** gains ×1.12, only if CHECK 3 holds.
- **Morning session and Light, Normal or Hard:** one ability at ×0.6, ×1 or ×1.3. Hard adds tiredness.
- **Diet Hold or Cut 500:** weight on the day.
- **Sunday rest:** tiredness −8.

**Missing options**
- Film evening (CODE). Its price against pads should be on the trade: an opponent tell against mastery.
- The step in the study slot as a sixth claimant on pad nights, with its own forecast ("Step back 22 of 30, slower this week").
- Cut a night (pads to rest), the right answer at carried-in 70+. The map describes the case but offers no card for it.
- The second fighter's claim on the coach's nights, once CLUBWEEK lands.
- A drill-on-the-bag fallback at 1.05 an hour, for a move that misses its pad night.

**Useless or weak options**
- E, unless CHECK 3 proves pad rating feeds the gain and can be assigned per night.
- Half and half outside the 4-from-a-tier window. It should only be offered there.
- C, if CHECK 1 shows a pad evening and a sparring evening cost the same tiredness. It then becomes a free +1 night.

**To reach 10/10**
1. **Close CHECK 1 first.** Find the tiredness of a pad evening, a sparring evening and a Hard morning, then price C and D from the rule. If C costs nothing in tiredness, give sparring a real return at 29–35 mastery or cut C.
2. **Run P2 and put a wins figure on every card.** Replace "fires 1 in 2" with "about +n wins in 100 against this opponent".
3. **Run P1 with its pass lines.** Each of COACH, NEAREST, SWAP and PLAN must be best in 10%+ of states, and NEAREST must lose in 30%+.
4. **Add the step study slot to the trade.** Show what padding a punch costs the step's weekly gain, and give the slot its own forecast chip.
5. **Add Film and Cut a night as cards,** each with its own price on the trade.
6. **Settle E with CHECK 3.** Either the 74 coach is assignable per night with a wage cost shown, or E is cut.
7. **Get owner question 1 answered (recommend a).** Rewrite question 2 as "keep the free evening edit" rather than "add a new option".
8. **Fix the page:** Club > People, not Gym > Staff; marker fonts for titles only, Barlow for text; and a written state for a quiet week ("No move near a tier: nothing to decide").
9. **Probe that every forecast chip matches the week review to 0.1,** and add the fight-log line for a drilled move (CHECK 8).

**The 10/10 page (1920×1080, Look B whiteboard)**
- **Top bar:** dark. CONTINUE (the only green) reads "to Mon 23, the week review".
- **Header:** portrait, the name once, "70 kg · fight Sat 28 · weigh-in Fri 27", with the fight date circled in red marker.
- **Top strip, the week's question in marker:**
  - "Check hook 28.2 of 30 · last night to make it: Fri 20";
  - a ring filling to 30;
  - "Against this opponent: Beats it · about +n wins in 100".
- **Centre (x 40–1380), seven columns:**
  - **Mornings:** a magnet each with session, Light/Normal/Hard, and the ability by its Attrs word.
  - **Evenings:** night cards, each with "+7.5 mastery" and its tier line ("Usable Fri 20"). A hatched BAG card where a move misses pads. A STEP chip, "Step back 22 → 28".
  - **The ghost row:** the coach's week, faint, underneath.
- **Under the columns:** the tiredness line from the rule.
  - The band above 80 is shaded and labelled "overreached: gains ×0.6".
  - Every night past the band is marked with a word, not only colour.
  - The injury chip sits at the end ("Injury ×1" or "×3 overreached").
- **Right (x 1420–1880), THE TRADE:**
  - Up to five cards: The coach's week, All on the check hook, Swap sparring, Add Saturday, Film instead.
  - Each card shows both hooks' tiers by fight night, the step's gain, and its cost in one line.
  - The ONE gold frame sits on the recommended card, with a coach's line under 70 characters and no numbers.
- **THIS WEEK BUYS (bottom centre):** Stamina +0.22 (next whole point in about 3 weeks), weight on the day against 70.0, and moves reaching a tier.
- **Bottom:** red buttons Back to the coach's week and Use this week.
- **Bottom-right panel, about 520×260:** the quiet state, "No move near a tier: nothing to decide".
