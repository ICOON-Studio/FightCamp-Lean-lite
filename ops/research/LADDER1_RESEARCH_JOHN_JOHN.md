# LADDER1_RESEARCH_JOHN_JOHN - John answer (seat queue SQ145)

Brief: research/LADDER1_RESEARCH_JOHN.md
Sent: 2026-11-15 00:10 | collected: 2026-11-15 00:40 by Tools/seat_queue.py (the 30-min reconcile)
Verify the sources before using it.

---

I'm starting LADDER1 now. First I'll check how eight management and sports games show a ladder and book fights, and how real England Boxing and BBBofC offers are decided. Then I'll write the full return here: sources, reputation earns and unlocks, the screen, To reach 10/10, and the 1920×1080 page. Your computer is offline, so I can't open `CRITIC_PACK.md`; I'll work from the pack facts I already have.

Correction to what I said: I found a copy of `CRITIC_PACK.md` on my computer, dated Nov 13, so I'm working from it and from the ladder code in that copy. The research is running now, and I'll post the full return here when it's done, with the 1920×1080 page as an image.

**LADDER1 (S475), part 1 of 3: the game today, and the games**
Read 2026-11-15, from my computer's copy of the code (commit 9d4d1ad6, 13 Nov). I changed nothing.

**What the game does today**
- **Pro offer:** 7 wins plus a top-3 place, or 9 wins at any place (`Roster.gd:29-31`, checked at `:174-182`). A declined offer comes back after 2 more wins (`:32-34`). A national finalist gets the call at once (`:177`).
- **Regional table:** your boxer joins it at 4 wins (`Region.gd:16`). It sorts by net wins, then wins, then rating (`:182-190`).
- **Amateur asking:** the rules exist, with a reach of 4 places (`AskBout.gd:19`), but no screen calls them.
- **Pro asking:** you can ask up to 5 places above you, or from #15 down when unranked. A top-5 name needs 3 fans (`Matchmaking.gd:34-37`, `ask()` at `:179-191`).
- **Two partial reputations already exist:**
  - club reputation (`Career.gd:22`): a win gives +5, a loss −2 and a stoppage loss −4 (`BoutRules.gd:115-123`);
  - pro fans, from −5 to 12 (`Matchmaking.gd:62-63`, `:241`).
- An amateur boxer has no reputation of their own.

**The games.** Every click count is an ESTIMATE from guides and walkthroughs; I played none of them.

| Game | Ladder screen | Clicks to booked | What reputation unlocks | Copy / Avoid |
|---|---|---|---|---|
| Boxing Manager (Steam, out 10 Nov 2026) | Store page lists world, regional and domestic titles, and "Choose every opponent" | NOT FOUND (6 reviews) | NOT FOUND | approach anyone / too new to judge |
| World Championship Boxing Manager 2 | Tiers only | none: opponents are random | moving up a tier | its ranking-up tutorial / "No rankings… No option to choose opponents" (the top complaint, 111 upvotes) |
| Football Manager | Reputation on a 0–10,000 scale (in FM09, 5,250 is continental and 7,500 world; from a search snippet); continental rankings decide seeding | approach, then a yes or no with a reason | better signings | the no says why / reputation rises slowly and drops fast |
| Motorsport Manager | Star rating and series tier | approach, then "Not interested" | who will talk to you | a reason under every no / drivers stay "never interested" for seasons |
| WWE 2K25 MyGM | 4 matches and 3 promos a show; popularity; rivalry level 1–4 | 4 | popularity over 50 draws crowds; a level-4 rivalry must end at the pay-per-view | a rivalry as a stake that ages / ratings maths is hidden |
| EA UFC 5 | Fight offers and hype | 2–3 | ranked offers need hype and a record | hype earned from camp choices / players at 22-0 with no ranked offer and no reason |
| Fight Night Champion (Legacy) | Legacy Central: rank, popularity, calendar | 4–5 | "Only fellow up-and-comers accept… at first" | popularity drops when you're inactive / no reason per opponent |
| Out of the Park Baseball | Trade screen | Submit, or Complete instantly | winners sign with winning teams | "Make this Work Now" shows what turns a no into a yes / personality effects are "unpredictable" |
| Punch Club 2 | League table | 2 | rank 1 plus over 2,000 points to move up a league | the next name is always visible / a grind gate |
| Undisputed | 3 offers, plus a pick from the rankings | 3–5 | fame raises the purse and the offers | offers plus a free pick / players at 14-0 with no title shot and no reason |

**The pattern:** the best ladders book straight from the table. The best refusals say why, and Out of the Park Baseball's also say what would change the answer. The worst hide the gate.

**LADDER1, part 2 of 3: real boxing, and reputation as currency**

**Real boxing** (OFFICIAL unless marked)
- **Matchmaker:** England Boxing's free Matchmaker went live on 1 June 2018, "developed with… Club matchmakers". It records every bout.
- **Rule Book 2026:**
  - "Boxers are to be matched on experience and weight." The weight gap may be no wider than the smaller boxer's class allows (2.7.8).
  - Seniors are limited to 18 bouts a season (2.7.9).
  - The national championships need at least 5 bouts.
  - The regional draw is made "without bias" (6.15.5).
  - How seeding works: NOT FOUND.
- **Box-offs:** they happen only when the selection panel asks for one: "Athletes have no entitlement to a box-off". The panel weighs "recency, relevance, quality and level of competition", and a medal "does not guarantee selection" (U15 Europeans 2026 selection policy).
- **BBBofC pro licence:** "The Board expects that all applicants have had experience in amateur boxing. Amateur records are checked." Applicants with little amateur experience must pass a gym assessment. After that come an interview, the Area Council, a medical with brain scans, and a vote of the full Board. A minimum amateur record: NOT FOUND.
- **Small-hall pro shows:**
  - they are "funded purely by ticket sales", and a show starts "£20,000 down";
  - 55 tickets at £40–45 raise "just over £2,000" (MEASURED, BBC 2022);
  - a boxer must sell enough to cover their "own purse and that of the opponents" (BBC, Dec 2025);
  - promoters also sign boxers from "the social media space".
- **BoxRec:** it rates results every day. A KO counts 1, a unanimous decision 0.875, a majority 0.55 and a split 0.45. A boxer counts as inactive after 365 days without a bout.

**Where reputation is real:** in the selection panel's judgement, ticket sales, TV audiences and BoxRec. Real boxing uses fixed counts only for safety and entry, never for who gets offered a fight.

**Ways to earn reputation.** All numbers are ESTIMATES. Boxer reputation runs 0–100; the club has its own.
1. **Win:** +10 × (1 − the win chance when the bout was booked). A win at 80 in 100 gives +2; a win at 25 in 100 gives +8. The club gets +1 for every 3 the boxer earns. *Replaces the flat club +5.*
2. **Type of win:** a stoppage ×1.15; a split or majority decision ×0.5 (as BoxRec weights them).
3. **Beat a rival or a top-3 boxer:** +3, once per opponent per season.
4. **Titles:** a regional title +10, a national medal +15, a national final +20, and +5 to the club.
5. **Full house** (90% of 400 seats at your hosted show): club +3, and each of your winners +1.
6. **Televised or streamed bout:** gains and losses ×1.5.
7. **A clip** after a stoppage or a Signature moment: +2, one per bout, halving after 4 weeks.
8. **Spar a known name** (the $160 partner) and do well: +1 per camp.
9. **Take a short-notice bout:** club ×2 (as today), boxer +2.
10. **A club boxer in the top 3:** club +1 a month.

**Losing reputation**
- A loss costs 6 × the win chance at booking, and a stoppage loss ×1.5.
- Missing weight or pulling out costs the boxer 5 and the club 3.
- After 8 weeks without a bout the boxer loses 1 every 4 weeks, and drops off the table after 52 weeks.
- **No grinding:** beating someone 6+ points below you gives 0, a repeat opponent gives half, and clips and spars are capped.

**What reputation unlocks** (*italics mark one that replaces a fixed count*)
1. *Table entry after 1 bout, ordered by reputation (was 4 wins).*
2. *How far up you can ask: 2 places plus 1 for every 15 reputation (was 4, or 5 and 15 for pros).*
3. *A yes-chance from a ranked opponent (was a hard no, and 3 fans for a top-5 pro).*
4. *A pro offer at reputation 55 with 40+ tickets sold; a re-offer after another 8 reputation (was 7 wins plus top 3, or 9 wins; re-offer after 2 more wins).*
5. Debut terms and the ticket quota scale with reputation.
6. At 40, top of the bill at a club show (your cut goes from $450 to $600); at 60, a dinner show.
7. A sponsor at 30, 50 and 70: $50, $100 and $200 a week.
8. At club reputation 50, the sparring partner fee drops from $160 to $110.
9. At 35, rival clubs start offering your boxer bouts.
10. At 70 plus a medal, a squad camp invite (the panel still decides).

**These stay fixed counts, because the real rules are counts:** novices box novices, the weight gap, 18 bouts a season, 5 bouts to enter the nationals, and age 18 to turn pro.

**LADDER1, part 3 of 3: the screen, To reach 10/10, the page and sources**

**The ladder screen that would score 9/10.** It sits under Fights. Your fighters' names sit as chips in the header; the only other names are opponents' row labels, which a ladder can't do without. That's the one loose reading of S448.
- **Reputation bar** at 47/100, with pins at 30, 50, 55 (the pro offer), 60 and 70. One line says what to do next: "8 to the pro offer: beat the #3 (win chance about 47 in 100) for +5, or win the regional for +10".
- **Season strip** of 26 weeks: club shows, the regional, the nationals and your bookings, with the next show your boxer can enter ringed.
- **Each row shows:**
  - place and movement arrow, then name and club;
  - record with a Novice or Open tag;
  - reputation, style and last bout;
  - win chance as a range;
  - **will say yes, "62 in 100"**, in green, amber or red;
  - what a win gives and what a loss costs.
- **Rows you can't book** are grey, with the reason in words: "Novice (3 bouts) can't box an open boxer", "3.1 kg apart", "Boxed 9 days ago: free from 6 Dec".
- **Hover on the yes-chance** shows its parts:
  - base 17;
  - reputation gap +20;
  - their coach wants a ranked win +15;
  - one place apart +10;
  - rested +5;
  - southpaw −5.
- **Filters:** In reach, Legal now, Likely yes 50+, Ranked, Rivals, Pros. Sort by place, yes-chance, win chance or reputation gained.
- **Card on the right:**
  - your boxer against the opponent, side by side;
  - the yes-chance and the win chance;
  - the stakes: a win gives +5 reputation and moves #4 to #3; a loss costs 3;
  - the date and the camp;
  - "To raise the yes" (the Out of the Park Baseball idea): book the southpaw partner for +5, or win next Saturday first for +12.
  - The one pulsing button is **ASK FOR THIS BOUT**.
- **Clicks:** pick a row, then press Ask, so 2 clicks. The answer arrives at the end of the week, or at once when the yes-chance is 90 in 100 or more.

**To reach 10/10** (most important first)
1. Give every boxer, amateur or pro, their own reputation (0–100), with pro fans folded into it. The game can't do this yet: only club reputation and pro fans exist.
2. Build the amateur Ask panel on the ladder. The rules in `AskBout.gd` are there but have no screen.
3. Give every row a yes-chance with its reasons on hover, replacing the plain yes or no in `Matchmaking.ask` (`:179-191`). Legal blocks stay absolute.
4. Replace the fixed counts (`Roster.gd:29-34`, `Region.gd:16`, `AskBout.gd:19`, `Matchmaking.gd:34-37`) with reputation lines printed on the bar.
5. Show the reputation at stake (win +x, loss −y) on every offer and bout page.
6. Add the season strip.
7. Add the filters and sorting.
8. Add inactivity decay and the anti-grind rules.
9. Wire up the unlocks: sponsors, show slot, ticket cut, partner fee and rival clubs' offers.
10. Give rival boxers a reputation that moves.
11. No-gi keeps the belt as its ladder until MMA lands.

**The 10/10 page (1920×1080, Look B, image below):**
- the dark shell, with cash, the week and the guide strip;
- inside it, a cream whiteboard in marker fonts: the LADDER header with name chips, the reputation bar with pins, and the season strip;
- a 10-row table: your boxer's row yellow, the selected row blue, 3 grey rows with reasons, and one 18-in-100 long shot;
- one hover open;
- the card on the right with the pulsing red ASK FOR THIS BOUT.

The grey rows and the long shot show the hard cases on the same page. The memo, the HTML and the PNG are on my computer in `/workspace/jladder1/`.

**What I couldn't find:** an England amateur ranking list, a BBBofC minimum amateur record, how England Boxing seeds its draws, and Boxing Manager's screens (released 10 Nov 2026, only 6 reviews). The wiki blocked the Football Manager reputation page, so its numbers are from a search snippet.

**Sources** (read 2026-11-15)
- [Boxing Manager on Steam](https://store.steampowered.com/app/1605370/)
- [FM Scout world rankings](https://www.fmscout.com/world.htm), [FM wiki on reputation (snippet only)](https://footballmanager.fandom.com/wiki/Reputation)
- [Motorsport Manager "never interested" thread](https://www.reddit.com/r/MotorsportManagerPC/comments/1cxy2as/claire_white_is_never_interested_when_trying_to/)
- [SmackDown Hotel MyGM guide](https://www.thesmackdownhotel.com/news/wwe2k25/wwe-2k25-mygm-mode-full-guide-all-features-tips-tricks), [2K MyGM page](https://wwe.2k.com/2k25/ringside-report/mygm/)
- [EA help, UFC 5 career](https://help.ea.com/en/articles/ufc/ufc-5/level-up-fighter/), [UFC 5 22-0 with no ranked offer](https://www.reddit.com/r/EASportsUFC/comments/1e9uogc/220_ufc_5_still_no_offers_to_fight_a_ranked/)
- [Fight Night Champion manual](https://eaassets-a.akamaihd.net/eahelp/manuals/fight-night-champion-manuals_Sony%20Playstation%203.pdf)
- [OOTP making trades](https://wiki.ootpdevelopments.com/index.php?title=OOTP_Baseball%3AImportant_Game_Concepts%2FThe_Trading_Model%2FMaking_Trades), [OOTP personalities](https://wiki.ootpdevelopments.com/index.php?title=OOTP_Baseball%3AImportant_Game_Concepts%2FThe_Player_Model%2FPersonality_Ratings%2FPlayer_Personalities)
- [Punch Club 2 guide](https://platget.com/guides/punch-club-2-fast-forward-trophy-guide/)
- [GINX Undisputed career guide](https://www.ginx.tv/en/career-guide), [Undisputed title-shot thread](https://www.reddit.com/r/undisputedboxing/comments/1aq8r9h/how_to_get_a_title_fight_in_career_mode/)
- [England Boxing Rule Book 2026](https://www.englandboxing.org/wp-content/uploads/2026/01/2026-Rule-Book-Final-01-26.pdf), [Matchmaker launch](https://www.englandboxing.org/news_articles/england-boxing-launches-new-matchmaker/), [U15 Europeans 2026 selection policy](https://www.englandboxing.org/wp-content/uploads/2026/09/U15-European-Championships-2026-Selection-Policy-2.pdf)
- [BBBofC boxers page](https://www.bbbofc.com/boxers), and BBBofC Rules and Regulations 2025 (from J_LADDER1)
- [BBC on small halls, 2022](https://www.bbc.co.uk/sport/boxing/60127424), [BBC on ticket selling, 2025](https://www.bbc.co.uk/sport/boxing/articles/c0kdrd1zkmzo)
- [BoxRec ratings method](https://boxrec.com/wiki/index.php/BoxRec_Ratings_Description)
- World Championship Boxing Manager 2 reviews, via J59 (read 2026-10-03)

Your computer is offline, so I haven't landed the memo or told Claude yet; I'll do both once it's back.
