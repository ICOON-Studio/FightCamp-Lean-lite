# JOHN_CARDGAMES_RESEARCH_JOHN - John answer (seat queue SQ281)

Brief: research/JOHN_CARDGAMES_RESEARCH.md
Sent: 2026-11-21 23:10 | collected: 2026-11-21 23:40 by Tools/seat_queue.py (the 30-min reconcile)
Verify the sources before using it.

---

On it. I'm starting with the five card games you named, then I'll add Yomi, BattleCON, Exceed and Punch Club. I'll pick out what would move our fight plan, the 30-second call and the corner.

The card-games research is running. I'll post the memo here when it's done, with a straight answer on whether it's worth exploring.

**J_CARDGAMES_S536: yes, explore card games, but take the ideas, not the card format.** The best card fights make a choice matter for two reasons. You can partly see what the opponent is likely to do, and every option has a counter whose value changes with the moment. Those two ideas would fix pace, the corner pick and the sparring partner. Random hands and building a deck before each bout would not.

Tags: SOURCED means I read it on the linked page, INFERRED is my reading, and NOT FOUND means it wasn't on the page.

## 1. How each game works

**1-2 Punch (Alright Games, 2021).**
- Each turn, both players secretly pick two of the same six moves (jab, retreat, advance, block, punch, rest), put them in order and turn them over together. The card with the lower timing number acts first.
- The ring has three spaces: your corner, the centre and theirs.
- A jab wears a guard down, and a punch breaks a guard that's already worn. Breaking all three guards is a knockout.
- Played cards stay spent until you Rest. Discard piles are open, so you always know what the opponent still holds.
- *SOURCED:* [The Game Crafter page](https://www.thegamecrafter.com/games/1-2-punch) and the rules PDF.
- *INFERRED:* reading pays because you can count what's left. No Block in hand means you're open to the punch, and an opponent who Rests gives you a free turn.
- It's barely tested: 2 store reviews and 3 BGG ratings.

**Uncaged: World Fighters.**
- A fight is 3 rounds of 4 combos, and in each combo one player attacks and the other defends.
- Both players set 5 cards face down in order and reveal them in pairs. Some moves only count straight after another move, and the defender's "combo breaker" ends the string.
- Stamina is your hand size: big moves cost discards, and the hand refills between rounds.
- *SOURCED:* [the Uncaged manual](https://uncaged-cards.com/files/UNCAGED_Manual.pdf).
- *INFERRED:* reading pays when you place the breaker where the attacker's string is heading.

**Mixed Martial Cards (Steam, not yet released).**
- You build a deck of strikes, takedowns, submissions, defences and coach actions.
- Each attack can be normal, full power or a feint, and the opponent doesn't know which until it lands.
- *SOURCED:* [the Steam page](https://store.steampowered.com/app/4265810/Mixed_Martial_Cards/). It has no reviews yet and lists 20 to 30 minutes a match.

**Topps Chrome Boxing and Starr Cards** are collectibles with no fight turn; they're covered in section 3.

**Yomi.**
- Both players reveal at once. Attack beats throw, throw beats block or dodge, and block or dodge beats attack. When both play the same type, the faster card wins.
- Each kind of win pays differently. The designer's key point is that uneven, hard-to-compare rewards mean the right choice depends on life totals, the cards in hand and what the opponent fears.
- *SOURCED:* [Designing Yomi](https://www.sirlin.net/articles/designing-yomi) (2014).

**BattleCON.**
- Each turn you pair a shared base card with one unique to your fighter. Range, power and speed add up.
- *INFERRED:* the lesson is distance as the main state. The read is "where will we be?" as much as "what will they throw?" *SOURCED:* the Board Game Authority review and a Steam guide.

**Exceed.**
- A line of 9 spaces, face-down strikes revealed together, and the faster card goes first. You can also swing blind off the top of your deck.
- *SOURCED:* the rulebook and a Sprites and Dice review. The reviewer says knowing the matchup matters as much as knowing your own fighter, and that blind swinging is "annoyingly viable" for beginners.

**Punch Club (2016), the fight screen.**
- You pick skills before each round, the round plays itself, and you swap skills between rounds.
- *SOURCED:* [the Punch Club wiki](https://punchclub.wiki.gg/wiki/Fighting). GameGrin's review says combat gives "the least sense of control".
- *INFERRED:* this is the closest match to our setup, and it shows what happens when nothing mid-round depends on what you read.

**Slay the Spire, the intent display.**
- Each enemy shows its next move with the exact damage. Before this, players found deciding whether to defend "a guessing game". Showing the next move made them play more boldly and made room for "if the enemy is attacking" cards.
- *SOURCED:* Rock Paper Shotgun, February 2018.

## 2. The five mechanics most worth stealing, ranked

| # | Mechanic (from) | Our screen | What choice it makes depend on the moment |
|---|---|---|---|
| 1 | **Show the opponent's tendency** (Slay the Spire's intents, Exceed's matchups) | The 30-second call, fed by the scouting / film file | One line before each exchange, such as "The opponent: likely to load the right hand (3 of the last 4 after a jab)". The call becomes a read on it. Better scouting turns "likely" into "telling you". |
| 2 | **A counter triangle with uneven rewards** (Yomi, 1-2 Punch, MMC's feints) | The 30-second call and the fight plan | Press beats Cover, Cover-and-counter beats Press, and Clinch or Move beats Counter. A feint beats Cover. The rewards shift with the state: cut, ahead on cards, tired, or the opponent hurt. Repeat a call 3 times and the AI corner starts countering it. |
| 3 | **Calls run out, and the corner gets them back** (1-2 Punch's Rest, Uncaged's stamina as hand size) | The corner and the fight plan; this fixes pace | Each call has a few uses per fight (for example Big Push ×2 and Body Attack ×3). A high pace spends uses faster. In the corner, "rest and reset" gets spent calls back, set against "fix the guard" or "close the cut". The opponent's spent calls are shown so you can count what's left. |
| 4 | **Distance as a state** (1-2 Punch, BattleCON, Exceed, Uncaged's standing and ground) | The fight plan's when-lines and the 30-second call | Show where the fight is: centre, on the ropes or inside. Some calls only work at some ranges, and when-lines key off it, such as "if pinned on the ropes, clinch". Standing and ground work the same way in BJJ. |
| 5 | **What you trained becomes what you can call** (Uncaged and MMC's deck building, Exceed's fighter decks) | The training week, the sparring partner and the fighter card | Drilling the counter right adds "Counter right" to the call list. Sparring a southpaw gives a "seen it" bonus. Chains such as "after the jab lands, the hook" need both parts drilled. The sparring partner then decides which calls are sharp. |

The runners-up are a feint layer on the call and a saved combo breaker.

**What would not translate:**
- **Choosing every punch.** A coach shouts one call every 30 seconds, so each card becomes a call or a when-line for us, never a punch.
- **Random hands.** We already have dice for each exchange, and form and ratings play the part of the draw.
- **Building a deck before every bout.** Our "deck" is the training week.
- **Identical decks for both sides.** Our boxers should differ in what they can call.

## 3. Collectible cards: who a fighter is at a glance

| Card | What's on it | How rarity or form shows |
|---|---|---|
| Topps Chrome Boxing 2024 | Portrait and name plate, with a crown on champions' plates. The back has vitals, the pro record and a bio. *SOURCED:* cardlines.com (2025). | Shiny cards with a printed run (/199 down to 1 of 1), an "RC" mark on rookies, and Future Stars and Ring Generals sets. *SOURCED:* checklistinsider.com. |
| Starr Cards | Portrait, bio, profile, stats, trivia (made by the buyer). *SOURCED.* | NOT FOUND |
| Uncaged | Health and stamina bars, one special ability, the style (for example BJJ). *SOURCED.* | No rarity |
| 1-2 Punch | Hometown, weight, height, titles. *SOURCED.* | None |

**For our fighter card and tale of the tape (INFERRED), five facts in this order:**
1. Record and form, with the last 5 results as W and L marks.
2. Stance and style in plain words, such as "southpaw counter-puncher".
3. Weight, height and reach.
4. One signature strength.
5. One plain weakness, which turns Uncaged's single ability line into a read.

Status goes in the name plate as a champion's mark or a "novice" tag. Form works like the shiny variants: a border that lights only on a 3-win run or a slump, with colour only for risk.

## 4. Pitfalls and how the good ones avoid them

| Pitfall | Where it shows | How the good ones avoid it |
|---|---|---|
| One best card | Any option with no counter, or rock-paper-scissors with equal rewards | Yomi gives everything a counter and makes the rewards uneven. |
| Pure guessing | Slay the Spire's prototype | Give tells: shown intent, open discard piles, known matchups. A read needs something to read. |
| Too much maths | Slay the Spire's damage ranges were worse than exact numbers | One short, exact line. |
| Too slow | MMC takes 20 to 30 minutes, and Uncaged has up to 60 reveals | Few choices, each one heavy. For a 10-round pro bout, let the plan run and stop only on a flagged moment (hurt, cut, a strong tell). |
| Luck beats skill | Exceed's blind swing | Make luck cost the read. Keep our dice, but a correct read must move the edge more than one die. |
| No control mid-fight | Punch Club | Swaps between rounds aren't enough. The round needs something to read (mechanic 1). |

The full memo with all sources is saved at `/workspace/cardgames/J_CARDGAMES_S536.md`. Some review dates weren't shown on the pages. Beast is still offline, so this hasn't been landed or sent to Claude yet; it's queued with the rest of the backlog.
