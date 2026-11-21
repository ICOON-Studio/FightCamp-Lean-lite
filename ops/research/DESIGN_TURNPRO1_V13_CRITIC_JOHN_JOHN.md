# DESIGN_TURNPRO1_V13_CRITIC_JOHN_JOHN - John answer (seat queue SQ283)

Brief: research/DESIGN_TURNPRO1_V13_CRITIC_JOHN.md
Sent: 2026-11-22 00:10 | collected: 2026-11-22 00:40 by Tools/seat_queue.py (the 30-min reconcile)
Attachments on the bot's box (not downloaded): turnpro13_10.html
Verify the sources before using it.

---

On it. First I'll go over TURNPRO1 v13's sums: the tune-up rule at +2, the card aimed at 78 and probe 13's bars. Then I'll score it against the 8+ DEPTH and 8+ PLAY bar. Beast is still offline, so I'll be reading the pack and the map rather than the code.

The TURNPRO1 v13 critic is running as a fresh read of v13 alone, without my earlier scores. When it's done I'll post the logic check, then the full return with the page image, then the HTML file.

**Logic check for TURNPRO1 v13.** Most of the sums hold, but four claims need fixing before the board sees them.

- **The tune-up rule.** The map's reason doesn't add up, though the number it claims is plausible.
  - Paying +2 on two thirds of the guarantee road's 0.85 extra wins gets back only 1.7 reputation.
  - Probe 13's swing is 5.8 to 6.4 (2.3 with the rule off against 8.1 to 8.7 with it on). That needs the guarantee road to win about 2 more tune-ups at 3 points each. Four fights at 80 % with two thirds of them tune-ups gives 2.1, which fits.
  - So the swing comes from every tune-up on the safe road being worth less, not from the 0.85.
- **"+14 at 56 seats" is ambiguous.** 56 ÷ 4 = 14 is the bonus alone, so a win pays +19 in total. Only that reading matches the night lead probe 12 measured.
- **The name doesn't pay back the cash by week 40.** One reputation point is worth $4.85 a week, which checks out. But a lead of 8.4 needs 45 to 49 weeks to earn $1,812 to $1,976. With about 30 weeks left it makes $1,099 to $1,221, so the name covers only about half the cash.
- **The card.** 75.0 becomes 78.0 against 78.6 played, and 60.4 becomes 60.5 against 59.9, so it's consistent.
  - **CHECK:** v12's +1 for each week past 4 adds +2 on the 6-week guarantee debut. An aim of 78 would then pick a harder opponent than today's. This needs reading in the code.
  - **CHECK:** the cards give a gap of 18.9 debut wins in 100, not the 28 the map quotes.
- **One fork, solved by one number.** What's left is one fork plus a calendar button, and the room line gives the answer.
- **The probe misses the new lever.** The bot never reads +2 or +5, so the player's actual choice of a tune-up or a step up is unprobed.
- **Side effects of the rule:**
  - A loss now costs twice: −2 or −4 reputation, then only +2 for the rebuild win, for the whole career.
  - The club-show draw and the grant odds also drop for builder gyms.
- **Words.**
  - Section 2's "his boxer" and "throws him in" break the no-fixed-he-or-she rule.
  - "The hall" isn't anything the game has; the board line should say "sells 60+ seats".

# TURNPRO1 v13: DEPTH 5 · GENERAL DESIGN 7 · PLAY 5
It's below the 8 and 8 bar, so it doesn't stay as written. This is a fresh, static reading of the pack and the map: Beast is offline, so I couldn't open the code, the mockups or the probe 13 result.

**DEPTH 5.** One number, the room in the gym, solves the fork. Each house's road mostly forces which fights you take, so the +2 and +5 sit on rows the player can't choose between. Nothing reads the boxer, and the house remembers nothing from fight to fight.

**GENERAL DESIGN 7.** It's carefully cited, and the cuts are right; dropping every ask but Later +2 is honest. Marks come off for:
- the wrong reason given for the swing;
- the "+14" ambiguity;
- the weeks term and the 28;
- the word "hall";
- the fixed "he";
- a loss costing twice;
- claiming the name pays back the cash, which is about twice what the sums give.

**PLAY 5.** The debut night and the table seat are good beats. After signing, though, the road plays itself, reputation turns into members too slowly to feel, and nothing builds anticipation before the debut.

**Real boxing:**
- **Lomachenko:** Arum promised the shot, and Lomachenko fought for a vacant WBO title in his second pro fight, losing to Salido (ESPN and BBC, March 2014). That's the hard road at its extreme.
- **UK small-hall ticket deals:** a York Hall show starts about £20,000 down, and 55 tickets raise about £2,000 (BBC, 28 Jan 2022). One boxer sold about 120 tickets for the debut, then "the tickets dwindled" after losing the second fight (BBC, 8 Mar 2022).
- **Builder against hard road:** Warren talks about building fighters, while Red Owl's line is "We build reputations, not records."

**Options:**
- **Keep:**
  - both houses;
  - Later +2, as a calendar tool;
  - Stay amateur, showing the drop to a 10 % share when loyalty would fall under 50;
  - Review later.
- **Useless for now:** the +2/+5 line, until the road actually gives a choice.
- **Missing:**
  - a choice of fight type at every one of the first six fights;
  - a promoter who remembers;
  - switching house;
  - the boxer's own wish;
  - a way to sell more seats before the debut;
  - a debutant of the same year on the other road, for comparison.

**To reach 10/10, most important first:**
1. Make each of the first six fights a choice on both roads. The house marks the kind it prefers, and the probe bot reads +2 and +5.
2. Give each house a favour score from 0 to 10.
   - At 8, the ticket house opens an area title shot after 4 wins, and the guarantee house adds $300 a purse plus a rebuild that pays +5.
   - Under 3, offers stand 4 days instead of 7.
   - The game can't do this yet.
3. Allow one switch of house after fight 3, for 20 % of the next purse. The game can't do this yet either.
4. Let the boxer's wish count, read from Confidence and Heart: +3 or −6 loyalty, shown when it crosses 50.
5. Fix the numbers and words: the 28, the weeks term, "+5, and +14 for the seats", the reason for the swing, "hall", and the claim that the name pays back the cash.
6. Show a debutant from the same year on the other road, from the pro table.
7. Give the weeks before the debut a seats lever: an open night at the gym for $200 and +6 seats.
8. Make rebuild fights pay +5.
9. After a debut loss on the ticket road, cut the seats at the next fight.
10. Show the room as a forecast, with a one-click move on the fit-out loan.
11. Use "your boxer" in section 2.

**What the game can't do yet:** promoter memory, switching contracts, a wish that has any effect, a venue, the rival gym and a seats lever.

**The 10/10 page:**
- **Header:** "TURN (FIRST NAME) PRO?"
- **Centre:** two house cards, each with the debut chance, what a win makes, six road magnets the player picks fight by fight, the house's favour and the switch clause.
- **Left notes:** your boxer's wish and the loyalty cost of each button, with the drop to a 10 % share in red.
- **Right notes:** the room forecast with a link to move, and the other road.
- **Bottom row:** Later +2, Stay amateur, Review later, and one pulsing "SIGN WITH THE TICKET HOUSE".

The money figures on the page are examples, not measured. The full text is in `/workspace/turnpro1/v13/TURNPRO1_V13_critic.md`.
