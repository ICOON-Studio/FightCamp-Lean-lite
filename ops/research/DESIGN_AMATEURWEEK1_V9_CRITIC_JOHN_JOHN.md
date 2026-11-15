# DESIGN_AMATEURWEEK1_V9_CRITIC_JOHN_JOHN - John answer (seat queue SQ156)

Brief: research/DESIGN_AMATEURWEEK1_V9_CRITIC_JOHN.md
Sent: 2026-11-15 03:10 | collected: 2026-11-15 03:40 by Tools/seat_queue.py (the 30-min reconcile)
Verify the sources before using it.

---

On it. I'm checking AMATEURWEEK1 v9's numbers against the critic pack first, then I'll score it. Beast is still offline, so `CRITIC_ACCESS.md`, the board and the mockups aren't open.

**Logic check.** Several numbers do hold up:
- The tank example works: 25 + 6 = 31, 25 + 12 = 37, and 37 + 5 + 5 = 47.
- The assistant's sureness works: 0.5 + 58/200 = 0.79 and 0.5 + 74/200 = 0.87.
- Three pad nights at 240 units is 720.
- An unscouted opponent caps the match at 4 points (PART).
- The film maths works: Look again saves 0.2 of a line per line relying on a tell, and Next group is worth 0.7. So Look again wins at 4 or more lines.

Twelve things don't hold or aren't stated:

1. **The day counts miss the evenings that exist.**
   - Club shows are on Saturdays (GAME), and fight week starts on Monday, 5 days out.
   - So the cheap fight-week sparring tier (7 or 6 days out, 3 off the tank) only falls on the Saturday and Sunday before.
   - That means every weekday sparring night in fight week is in the costly tier: 5 off the tank, injury ×2.5, and a cut that ends the bout 3 times in 100.
   - Frame B's own header, "Sparring, Thu, 6 days out", needs a Wednesday bout.
   - The week before's "8+ days out" also leaves day 7 belonging to no tier.
2. **The tiredness layer reads two different times.** Rest up brings tiredness to 30 "before the bell", but the worked example charges Tick over the full start tiredness of 75, even though it has a rest day and half the volume. Say whether the layer reads tiredness at the bell (then Tick over's 31 is wrong) or at the start of the week (then Rest up's 0 is wrong).
3. **"Flat" and "Sharp" already mean something.** Round 1 FLAT −2.0 uses the mood word Flat (30–49), and round-1 "Sharp" uses the mastery tier Sharp (60). That breaks one word per concept twice, on the same TONIGHT panel that shows both the mood line and the fire levels.
4. **An UNSPARRED Usable line drops to Raw.** Raw is under 30, which isn't a weapon, and FireLevel gives Raw no fire rate. If Raw never fires, writing any new line blanks it for two of the three amateur rounds. State Raw's fire rate. Also state what happens when Tick over's level up and UNSPARRED's level down land on the same line.
5. **The camp's southpaw rule has gone.** In the game today, an outside partner of the opponent's stance removes the round-1 penalty for a boxer who has never faced a southpaw (GAME 4.3). The match table gives stance only 1 point and never mentions the penalty, so amateur bouts would lose a working rule.
6. **The partner's price is far bigger than its gain.**
   - The match only moves the round-1 edge (+0.5 or +1.0, about 1–1.5 wins in 100) and how far the test can be trusted, since every match readies lines.
   - $160 for at most about 1.5 wins in 100 never pays back. Against the $450 ticket cut plus members, it's worth about $7–10 a bout.
   - PARTNERPROBE's goal, "worth its fee in 1 bout in 4", has no measure.
   - An outside partner without a tell your gym found earlier also caps at PART, the same as a free club boxer of the right style. So the fee buys only style or stance the club lacks.
7. **Favours have the wrong host.** They're earned with a show's host by filling a late gap, about 1 show in 6. But an outside partner costs "1 favour with that club's host", and the partner's club needn't host shows. Spending runs at four places (partner, kilo, a weight miss, next month's slot) against one rare way to earn. Say whose favours pay for a partner.
8. **The weight gap has no direction and no target.**
   - At club shows, both boxers are matched at walking weight within a gap.
   - The opponent's weight on the day isn't on any card, so the "scale margin against the gap" has nothing to measure against.
   - If your boxer is the lighter one, Eat less makes the gap wider.
   - Say what weight of the opponent is known, and when.
9. **A tell that can be false is a new system.** In the game, a found tell is true (GAME 4.6). "Likely", "very likely" and "didn't happen" make tells probabilistic. Mark it NEW in section 11 and as a CHECK for Claude.
10. **Rematch tells come back weaker than they were.** A tell confirmed in the last fight returns as "seen on tape: likely". That's below what the player saw happen. It should return as "very likely", or confirmed with the date, with the hover saying boxers change.
11. **Some costs aren't stated:**
    - Whether a fight-week sparring night still hands out its 180 sparring units.
    - What the week-before night's price, "one pad night's mastery", is net of: sparring's own gains, or not?
    - Whether a club boxer used as a partner pays anything: tiredness, injury risk or a night lost.
    - What a "tell group" is. The pack opens one tell at a time.
    - Whether a fight week with Rest up counts as the rest week behind "+4 mood".
12. **Small things:**
    - Section 3 is missing; the numbering jumps from 2 to 4.
    - The pull-out roll fires 35 times in 100, but nothing shows the player those odds before paying a $160 fee.
    - With a stoppage loss's +8 weeks plus a 6-week READY wait, ring rust can land on top of the forced rest. Say READY starts after the rest.

There are no names outside headers and no fixed he or she.

The John CHECK on whether a host may re-match a boxer who missed the weight under England Boxing rules isn't researched in this pass. I'll treat the 1 in 3 as an ESTIMATE.

I score AMATEURWEEK1 v9 at depth 7, general design 6 and play 7, so it meets the owner's 6+ bar. The 10/10 list and page are at the end. Beast is offline, so I judged it from the critic pack and the map, without `CRITIC_ACCESS.md`, the board or the mockups.

## Scores

**Depth 7.** Fight week now has four real trades that pull against each other:
- **Load:** Tick over, Train through or Rest up, which sets the tank against banked mastery against round 1.
- **Sparring:** when to spar sets readied lines against the tank, injury and cut risk.
- **Weight:** Eat less, Train it off or Ask for a kilo costs tank, tiredness or a favour.
- **Film:** Look again or Next group, with a real break-even at 4 lines.

The partner choice ties fight week to scouting, as the owner asked: filming a tell is the only route to CLOSE. The truth words then pay off in the corner minute.

What holds it at 7:
- The partner's effect is small: at most about 1.5 wins in 100 in round 1, and every match readies lines. So the mandatory screen mostly decides whether the test is trusted, not the fight.
- The $160 fee can't pay for itself.
- The cheap fight-week sparring tier lands on weekend days only, so in practice it's "spar the week before or pay the late price".

**General design 6.**
- **What's right:**
  - Every owner S475 point and every change from Claude is answered and traceable (0.1, 0.2).
  - Trips and savings are honestly cut.
  - Mood is answered from the game's own events.
  - Every number is marked, and probes run before anything prints.
  - Every menu is wired (section 10).
- **What holds it at 6:**
  - The day counts are wrong against Saturday shows.
  - The tiredness layer reads two different times.
  - Flat and Sharp are reused words.
  - The UNSPARRED drop to Raw is undefined.
  - The southpaw rule is lost.
  - Favours have the wrong host.
  - The weight gap has no target.
  - The false tell isn't flagged as NEW.
  - Eight NEW systems (partner pick, match score, favours, weight gap, the amateur WeekPhase branch, tell truth, bout sheet, region shows) make a heavy build, and no probe has run.

**Play 7.**
- Each bout now has a shape across its fortnight: sheet, partner, film, load, scale, fight.
- The partner screen is a tangible choice the player looks forward to, with the opponent's card right beside it.
- "Confirmed in the fight" or "didn't happen" in the corner is a real payoff for filming.
- The pull-out roll and the replacement card bring real amateur drama.

What holds it at 7: the payoffs are small numbers, and the 35-in-100 pull-out can wipe out a paid partner and two film nights with no warning of the odds.

## What each option changes, and verdict
| Option | What it changes | Verdict |
|---|---|---|
| Swap slot | Which same-class boxer fights | Keep |
| Pass / refuse a named card | Nothing / that club's lockout count | Keep |
| Rest window 3 / 5 / 8 | How soon the next sheet comes | **Weak:** Pass already does this. Keep only if it also stops "a month with no fight" mood while it's set |
| Sparring partner | Round-1 edge (≤ 1.5 in 100), how far the test is trusted, injury when the partner is above, cash or a favour | Keep; make the effect bigger (below) |
| Club member row | Readies lines, LOOSE always | Keep as the floor, labelled "readies lines, no match" |
| Outside partner ($160 or a favour) | A style or stance the club lacks | **Useless at today's numbers**, because it can't pay back |
| Sparring nights | Ready lines, against tank, injury and cut risk | Keep; fix the days |
| Load stop | Tank, round 1, banked mastery, tiredness after | Keep |
| Eat less / Train it off / Ask a kilo | Weight margin, against tank / tiredness / a favour | Keep, once the gap's target is defined |
| Film / Look again / Next group | Which tells are known and how sure | Keep; best part of the map |
| Fall-through answers | The bout, mood, a favour | Keep |
| Use the pick | Applies the load and weight stops | Keep; fold to two stops if the probe says so |

**Missing options**
- **The southpaw answer:** a partner of the opponent's stance removes the round-1 "never faced one" penalty (GAME), shown on the row as "clears the southpaw penalty". This is the real reason clubs bring in a southpaw.
- **A cost to your own boxer used as a partner:** their tiredness, injury risk, or their own pad night. It should work like R55's coach's pad nights, and it makes picking a club mate a real trade.
- **A way to earn favours both ways:** lend one of your boxers as a partner to another club's boxer, which earns 1 favour with that club. This also fixes the host mismatch.
- **The pull-out odds on the bout card,** "falls through about 1 in 3", before any fee is paid. With it, a hold option: book the outside partner for the Tuesday after the Monday roll at the late price.
- **The opponent's walking weight** on the bout card ("about 64 kg, from last bout"), so the gap has a target.

## To reach 10/10
1. **Fix the days against Saturday shows.**
   - Week before is days 13–7 out; fight week is days 6–1.
   - The cheap tier is fight-week Monday and Tuesday (5–4 days out) at 3 off the tank.
   - The late tier is Wednesday to Friday (3–1 days out) at 5 off, injury ×2.5 and cut 3 in 100.
   - Frame B's header becomes "Sparring, Tue, 4 days out".
2. **Make the partner matter.** CLOSE readies every line, PART two, and LOOSE one. Keep the round-1 edge, and add the southpaw penalty clear for a stance match. Then the fee buys readied lines, which are worth wins in all three rounds. PARTNERPROBE measures CLOSE against LOOSE on readied lines, with a target of 3–5 in 100.
3. **Make the tiredness layer read bell tiredness for all three stops.** Give each stop its fall:
   - Rest up: to 30.
   - Tick over: −15.
   - Train through: +6.
   - Then redo the worked example. At 75, that's 0 / 16 / 43 / 53 off.
4. **Rename the round-1 states** "Fresh", "Fresh (no boost)" and "Heavy legs", so Flat stays mood and Sharp stays mastery.
5. **State Raw's fire rate (1 in 4)** and the stacking rule: Tick over's level up cancels UNSPARRED's level down on the chosen line. Show it on the line chip.
6. **Make favours per club, not per host.** Earn one by filling a late gap or lending a partner. Spend one on that club's partner, or on its show (kilo, miss, next slot). Cap at 3 per club.
7. **Define the weigh-in target.** Show the opponent's last walking weight on the card, gap direction arrows, and Eat less greyed when your boxer is already the lighter one.
8. **Mark tell truth NEW** in section 11, with a CHECK for Claude on OppFile holding a "real" flag. Rematch tells return as "very likely (seen in the fight, date)".
9. **Price the costs that aren't stated:**
   - A fight-week sparring night gives its 180 units.
   - The week-before price is net (240 pad units lost, 180 sparring units gained).
   - A club-mate partner pays +4 tiredness and the level-above injury risk if they're lighter.
   - A "tell group" is one tell.
   - Rest up isn't a rest week.
10. **Show the pull-out odds** on the bout card and on the outside-partner button.
11. **Cut the rest window,** or make it stop the no-fight mood loss while it's set, so it does something Pass doesn't.
12. **Restore section 3 or renumber.** Start READY after any forced rest.
13. **Run the probes,** get the owner's answers 1–6, and draw both frames as PNG boards before any build.

**CHECK (John), re-matching a boxer who misses at club shows:** not researched in this pass. It stays an ESTIMATE until I do.

## The 10/10 page (1920×1080, Look B; Frame B, CHOOSE A SPARRING PARTNER)

**Shell (0–64 px):** dark top bar, with the big button reading "NEEDS YOU: pick a partner for Tue".

**Header (64–160):** "Sparring · Tue · 4 days out", your boxer's name once, the mood word, and favours shown per club as chips.

**Left (24–540): your boxer.**
- A polaroid, the class in kg, stance, height and reach, and style word.
- The three matchup stats.
- The plan lines as chips, each READY / UNSPARRED, with the count this night will ready: "CLOSE readies all 5 · PART 2 · LOOSE 1".

**Middle (560–1360): six partner rows on cream paper.** Each row has a face or silhouette, style, stance, reach against the opponent ("+3 cm"), level, cost, and the match word with its points as dots. Example rows:
- A southpaw row with a tape note: "clears the southpaw penalty".
- A club mate's row in red marker: "+4 tiredness for them".
- A marker note on one row: "your assistant's pick: same style".
- The outside row's button reads "$160 · falls through about 1 in 3".
- Hovering the match word shows each point.

**Right (1380–1896): the opponent's card.** Record, style, stance, size, last walking weight, and the filmed tells: one underlined "seen twice: very likely", one "seen on tape: likely". The "?" lines say "film night: next tell".

**Bottom (960–1040):** "film a tell to reach CLOSE" (only when none is filmed) and Back to the week. The one pulsing button is "Spar with this partner", on the chosen row. Gold is only on that row's match word.

**Frame A is the same shell.** The seven day columns run Monday to Saturday, with Monday and Tuesday's sparring magnets in red and Wednesday to Friday hatched "late: 5 off, cut 3 in 100". The tank bar shows grey for the bell tiredness and colour for the choices. ON FIGHT NIGHT is in gold on the right, with "Fresh" for round 1 and the mood line separate.

## Sources
No new outside sources this pass. Every figure is DERIVED from the critic pack (4.1–4.8, S448, S451, S463) and the map's own numbers. The England Boxing weigh-in rules (7.1.3, 2.7.8) and the pull-out rate come from my earlier passes and weren't reread today.
