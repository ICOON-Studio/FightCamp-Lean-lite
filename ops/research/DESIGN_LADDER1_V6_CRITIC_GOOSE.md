# LADDER1 v6 — Second Critic Score (S513)

Critique by Goose — sports management sim designer perspective.
Read the full critic pack, the v5 design map, both v5 critic answers (John and Dola), and the v6 revision.
Did not read Dola's v6 answer before writing this.

---

## Summary verdict

LADDER1 v6 is a significant improvement over v5. The designer addressed John's core objections — money is now equal across rows, members scale with Rep gain, the clock exception actually works, the yes-chance moved to a fixed threshold with temperament, and the Pass wording is unambiguous. The three cases now show genuinely different best picks driven by gym state rather than Rep alone. This is a matchmaking system that respects the player's intelligence.

It is not yet 10/10. The remaining gaps are mostly about unconfirmed foundations (11 CHECKs, no probes run) and a few missing interactions that would turn a good system into a great one.

---

## Scores

### DEPTH — 8/10

**What earns the 8:**

- **The full price card is the right design move.** By showing Rep, members, gym standing, money, morale, injury risk, stoppage layoff and clock impact on one card, every row becomes a multi-axis decision. The player is never just picking the highest number. In Case B the Slugger wins on Rep but loses on stage risk — that is a real trade, and the card makes it visible.
- **The yes threshold with temperament is learnable.** Unlike a seeded roll, the player can build a mental model: "this manager is careful, so I need more heat before asking." After the first interaction the temperament is revealed, which turns refusals into information. This is how good management sims create depth — the player learns the system and exploits it.
- **DUCKED and OWED create social memory.** Two ducks in eight weeks turns a hot streak into leverage. This is the kind of emergent story that makes players talk about their career: "they ducked me twice, now they owe me." It is small but it matters.
- **The clock actually bites now.** The v5 fix — bouts 20+ below count as free weeks — means farming no longer hides you from the drain. Combined with the 8-week free window, the player has to box regularly but cannot box mindlessly.
- **Plan quality connects the ladder to the Playbook.** The ±7 plan shift means the same opponent is worth different amounts depending on whether you wrote a good line. This is the right kind of cross-system interaction — the ladder is not isolated.
- **Case C shows timing as a resource.** The fast route (28% in one bout) versus the two-step (33% in two bouts, $900, but the #1 window closes) is a genuinely hard choice. Either can be right depending on the gym's goal.

**What keeps it from 10:**

- **No probes have run.** The design's claims about balance rest on untested math. Probe 13 (FARM vs THINK over two seasons) is the load-bearing test — if farming still wins on gym standing or morale, the depth is theoretical. Until the bots run, the depth score is a promise, not a measurement.
- **The "overtrained boxer" scenario is missing.** The most interesting hidden decision in any ladder system is: your boxer is better than their Rep says. Their training has outrun their ranking, and every bout above them pays disproportionately. Case D was proposed by John but never written. This scenario teaches the player that Rep is a lagging indicator and that smart matchmaking means exploiting the gap between training and ranking.
- **Regional stage value is still abstract.** "~0.9 effective Rep at stake" is a formula, not a felt cost. The player needs to see what missing the stage means in concrete terms: the nationals path closes, the pro offer window shifts, sponsors pause. Without that, the Slugger's "12% → miss stage" is a number, not a fear.
- **Rivals have no arc.** Temperament is learned once and never changes. A careful manager who gets upset by your boxer should become more cautious, or a bold one who ducks you should become more aggressive. The ladder needs rivals who develop, not just boxers who move up and down.
- **No way to invest in a matchup.** The player can study tape, write a plan, and build heat — but there is no "I am preparing specifically for this opponent" action beyond the camp (which amateurs do not get). A dedicated "targeted prep" week that boosts plan effectiveness against one style by a small amount would add a strategic layer.

### GENERAL DESIGN — 7/10

**What earns the 7:**

- **One unit, two labels.** Rep for the boxer, Gym Standing for the club. Every distance in points. This is clean and consistent. The player never has to convert between systems.
- **Every refusal names its reason and its date.** OUT OF REACH says "Needs 6 more Rep." TOO HEAVY says "Start a cut: makes 60 kg by 11 Apr." NOT SAFE says "Opens after 3 more bouts." This is the gold standard for management sim design — the player always knows what to do next.
- **Greyed rows fold elegantly.** "3 in reach can't be asked now ▸" keeps the default view clean without hiding information. The player sees the count and can expand if curious.
- **The fixed threshold replaces the seeded roll.** This resolves the "never a random refusal" conflict with pack §4.5. Every no has a largest factor, and the player can act on it.
- **Single rematch rule (2 per season).** Clean, no contradictions. The TWICE THIS SEASON status shows when the next opening is.
- **Pass rule is now unambiguous.** "Your boxer pays 2 Rep to the challenger" — the cost direction is clear. "A no to your ask pays 0 Rep" — the OWED exception is stated.
- **Look B confirmed.** Permanent Marker headers, Kalam body, IBM Plex Mono data, warm tan wall, cream paper. This matches the owner's ruling and the rest of the game's visual language.
- **Names only in headers.** Full S448 compliance. The opponent's name sits in the row header and nowhere in the card, tips or buttons.
- **The card prices the pull-out.** "$300 empty slot fee" on a confirmed bout — this was missing in v5 and is now present.
- **Study Tape for amateurs has a path.** Film evening that week, reveals one habit. This connects to the existing week system.

**What keeps it from 10:**

- **Eleven CHECKs are still open.** This is the biggest structural problem. Travel cost, venue (home/away), sponsor mark, squad camp mark, the 18-bout cap, England Boxing rest days, the ticket cut confirmation, whether the code's win chance includes the plan, NOT SAFE counts, rival manager offers, and morale changes in a fight — all pending. A design with this many unconfirmed foundations is not finished. If travel and venue do not exist in code, the home/away factor and the travel line must be cut, which changes the yes threshold and the card. If the 18-bout cap cannot be confirmed, the SEASON CAP row status is speculative.
- **The "one ask for both dates" UX is underspecified.** The rule says one action returns two separate answers, but the screen description shows a single ASK FOR BOTH DATES button. What does the player see? Two cards? A split card? The answer needs a clear visual description, because the two dates may have different yes outcomes and different prices.
- **Filter redundancy.** "Makes weight" and "Legal now" overlap — Legal now already hides TOO HEAVY rows. The Makes weight filter adds nothing unless it also surfaces Weight at risk rows, which the chips already do. Cut one.
- **The Rep bar marks at 30 (Sponsor) and 45 (Squad Camp) are conditional on CHECKs.** If they are cut, the bar has only one mark (55, Pro offer). That is fine — one mark is cleaner than three uncertain ones — but the design should state the fallback clearly.
- **The draw formula is fair but untested.** 8 × (0.5 − expected) means a draw against a favoured opponent pays slightly positive, and a draw against an underdog pays slightly negative. This is correct in principle but has not been probed for edge cases (what happens at expected = 50%? The draw pays zero, which is right).
- **The card shows injury risk as a flat "6 in 100" with no variation.** In reality, injury risk depends on the stat gap, the style matchup and the plan. A pressure fighter who walks into counters takes more damage. The card should show a matchup-adjusted figure, or at least a band.
- **Season strip density.** Shows every other Saturday to 31 Dec is about 26 dates. On a 1920-wide screen this is tight. The design needs to state what happens when the strip is long — does it scroll, compress, or show only the next N?

### PLAY — 7/10

**What earns the 7:**

- **The card creates anticipation.** You see the full price before you ask. The "Leans Yes 60" with a breakdown makes the answer feel earned, not random. The answer arriving the next morning gives the player something to look forward to.
- **"To raise the yes" is excellent game feel.** Three actionable tips, each tied to a factor: "Ask for 11 Apr: their stage is past, +30." This transforms a refusal from a wall into a roadmap. The player always has something to work toward.
- **Heat and DUCKED create story.** A hot streak is not just a number — it is leverage. When an opponent ducks you and then owes you, that is a rivalry moment. These are the stories players tell their friends.
- **The season strip grounds decisions in time.** You can see the regional stage, the nationals dates, and your bout count. Decisions feel part of a larger plan, not isolated picks.
- **The upset payoff is visceral.** "+11 Rep, now ranked 5th" — the player feels the jump. The rank change is shown immediately, which is the reward moment.
- **Pin as Goal connects to the goal system.** "Beat the #3 by June" becomes a goal with morale on it. This turns a matchmaking decision into a narrative commitment.

**What keeps it from 10:**

- **The week-to-week loop lacks a signature moment.** In Football Manager, match day is the event. In this ladder, the ask-and-answer is the closest thing, but it is a modal that resolves off-screen. The player presses ASK, presses CONTINUE, and the answer arrives as a notification. There is no tension in the waiting. A brief "answer day" event — the notification appearing on Home with a sound, the card flipping from "Pending" to "Yes" or "No" — would make the loop feel alive.
- **No variety in the seasonal rhythm.** Every other Saturday is predictable. Real boxing has variation: a big show, a quiet month, a sudden opportunity. The twist card system in training provides some of this, but the ladder itself is metronomic. A "headline show" event every 16 weeks (the club show from pack §4.13) could be a ladder event — bigger stakes, more members, a ranking bonus.
- **Rivals do not feel like people.** Beyond temperament, the opponent has no personality. No quote, no style description on the card, no "they said this about your last fight." The rival file exists (CODE) but the ladder card does not use it. A one-line quote from the opponent's corner after a close fight would make the rivalry feel real.
- **No "build your reputation" action.** The player can win, wait, or build heat — all passive. There is no "make them an offer they cannot refuse" or "send a message" action. In real boxing, promoters build narratives. The ladder could allow a "promote the fight" action that boosts the yes chance by 5 but costs $200 in marketing. This fits the gym-owner fantasy.
- **The default view may be too clean.** Eight rows or fewer in 80% of opens is a good target, but it means the player often sees only the safe picks. The interesting rows — the high-risk, high-reward ones — may be folded into the "3 in reach can't be asked now" line. The design should ensure that at least one "reach" row (above the player but askable) is always visible in the default view.

---

## Options: Missing, Useless, and What Each Changes

### Missing options

| Option | What it adds | Priority |
|--------|-------------|----------|
| **Case D: the overtrained boxer** | Shows that Rep lags behind training. A boxer whose stats run 5+ points ahead of their Rep earns disproportionate gains from bouts above. Teaches the player to exploit the gap. Without this, the ladder never shows its most interesting decision. | High |
| **Targeted prep week** | One week of focused film and pad work against a specific opponent's style. Boosts plan effectiveness by +3 against that style for the next bout. Costs a training week (−0.6 stat gain). Gives the player an active investment in a matchup. | Medium |
| **Promote the fight** | Spend $200 to boost the yes chance by +5. Fits the gym-owner fantasy. Creates a money-vs-relationship trade. | Low |
| **Injury risk variation by matchup** | Show injury risk as a band (4–8 in 100) that depends on the style matchup and plan rating. A counter vs a pressure fighter who walks in takes less damage; a pressure fighter vs a counter who loads up takes more. Makes the risk line actionable. | Medium |
| **Answer day event** | The answer arrives as a visible moment on Home — a sticky note flips from "Pending" to "Yes" or "No" with a sound cue. Creates tension in the waiting. | Low |
| **Regional stage concrete value** | Show what missing the stage means: "Miss regionals → nationals path closes → pro offer delayed ~8 weeks." Turns an abstract 0.9 Rep into a felt cost. | High |
| **Rival arc** | Temperament shifts after each interaction. A careful manager who gets upset becomes more cautious (−5). A bold manager who wins becomes more aggressive (+5). Creates rivals who develop. | Medium |
| **One-line rival quote on the card** | After a close fight or a duck, the opponent's corner says something. "They're not ready for this level." or "We'll see them at regionals." Makes the rivalry feel human. | Low |

### Useless options

| Option | Why it is useless | Action |
|--------|------------------|--------|
| **Makes weight filter** | Legal now already hides TOO HEAVY rows. The Weight at risk chip shows the rest. This filter adds a chip that duplicates existing information. | Cut it |
| **Sponsor (30) and Squad Camp (45) marks on Rep bar** | Pending CHECK 8. If neither exists in code, these marks are placeholders. A design should not show marks for features that may not ship. | Cut unless CHECK 8 confirms both |
| **Ask for a rematch link (separate from the row Ask)** | The row's own Ask button already handles rematches under TWICE THIS SEASON. A separate link duplicates the action and confuses the flow. | Cut it — the row Ask is sufficient |
| **Travel cost line (if no venue)** | The game has no venue data (pack S410). If CHECK confirms no venue, the −$40 travel line and the home/away factor in R6 cannot be built. | Cut if no venue in code |

### What each kept option changes

| Option | What it changes |
|--------|----------------|
| **Reach rule (10 + Rep ÷ 5)** | Defines the window of possible opponents. Moves as Rep grows. Creates the "protecting" dynamic at the top. |
| **Full price card (R4)** | Turns every row from a single-number comparison into a multi-axis decision. The player weighs Rep against members, money, morale, risk and clock. |
| **Yes threshold with temperament (R6)** | Makes refusals learnable. The player builds a mental model of each manager and plans around their tendencies. |
| **DUCKED / OWED** | Turns a hot streak into social leverage. Creates rivalry stories. Punishes opponents who refuse fair matchups. |
| **Clock (R8)** | Creates time pressure. The player cannot wait forever or farm easy wins. Bouts 20+ below count as free weeks, so farming does not hide you. |
| **Rest until (one 4-week pause per season)** | Gives the player a strategic pause button. Protects a training block from clock drain. One per season keeps it meaningful. |
| **Pass at −2 Rep to challenger** | Gives saying no a price. Prevents infinite farming of refusals. The challenger goes quiet for 8 weeks. |
| **Not this show (free once per opponent per season)** | Gives the player a "not now, maybe later" option without burning the relationship. |
| **Pin as Goal** | Connects matchmaking to the goal system. Turns a pick into a narrative commitment with morale on it. |
| **Study Tape → Film evening** | Gives amateurs a scouting path without a camp. Connects to the existing week system. |
| **Pull out at $300** | Prices backing out of a confirmed bout. Prevents casual cancellation. |
| **Two selectable dates** | Gives the player timing as a resource. The later date may open a protecting opponent or let weight come down. |
| **No EV column** | Prevents the player from reducing the decision to one number. Forces judgement. This is the right call. |
| **Season strip** | Grounds decisions in a timeline. The player sees regionals, nationals, and bout count. Decisions feel part of a plan. |

---

## To reach 10/10

Most important first, each specific enough to build:

### 1. Close the 11 CHECKs — especially 5, 8 and 10

The design cannot be finished with this many unconfirmed foundations. Priority order:

- **CHECK 5: Does the ticket cut pay on every win, or every bout?** If per bout, the money column is equal across all rows (as v6 assumes). If per win, the farm still dominates on money and probe 13 fails. This is load-bearing.
- **CHECK 8: Do boxer-level sponsors and squad selection exist?** If not, cut the 30 and 45 marks from the Rep bar. One mark (55, Pro offer) is cleaner.
- **CHECK 10: England Boxing rest days between bouts.** This sets the 18-bout cap and the 8-week stoppage rest. Without it, SEASON CAP is speculative.
- **CHECK: Does the game have venue data?** If not, cut the home/away factor from R6 and the travel line from R4. The yes threshold loses two parts, which simplifies it.
- **Remaining CHECKs:** Run in parallel. Each one either confirms a feature or cuts a line.

### 2. Run probes 13–18 and publish the numbers

The design's balance claims are untested. Priority:

- **Probe 13: FARM vs THINK over 2 seasons on all five lines (Rep, money, members, gym standing, morale).** If FARM still wins on three or more lines, the full price card has not solved the farm problem. Adjust gym standing scaling or morale scaling until FARM loses on the boxer's lines.
- **Probe 16: Stoppage table by stat gap and style.** The "Stopped in N/100" figure needs to come from actual fight data, not an estimate. This feeds the card's layoff risk line.
- **Probe 17: In 2 of 3 cases, the best row with full price differs from Rep alone.** This is the core proof the mechanic works. If it fails, the card is not adding depth.
- **Probe 18: Default view shows 8 rows or fewer in 80% of opens.** Keeps the screen clean.

### 3. Add Case D: the overtrained boxer

A boxer at Rep 30 whose stats run 5 points ahead of their Rep (training has outrun the ranking). Show that bouts above them pay disproportionately: a win against a Rep 40 opponent yields +14 instead of +11 because the expected chance is lower. This teaches the player that Rep is a lagging indicator and that smart matchmaking means exploiting the gap between training and ranking. It is the most interesting decision the ladder can offer, and it is currently invisible.

### 4. Make regional stage value concrete

Replace "~0.9 effective Rep at stake" with a visible chain: "Miss regionals → nationals path closes → pro offer delayed ~8 weeks → −2 Rep clock drain during idle." Show this on the card when a bout's stoppage risk conflicts with a stage date. The player needs to feel the cost, not calculate it.

### 5. Add matchup-adjusted injury risk

The flat "6 in 100" does not reflect reality. A pressure fighter who walks into a counter takes more damage. A boxer with a good plan takes less. Show a band: "Injured in 4–8 of 100" with hover explaining the range. The band width reflects plan uncertainty; the centre reflects the matchup.

### 6. Add a targeted prep week

One week of focused film and pad work against a specific opponent's style. Effect: plan effectiveness +3 against that style for the next bout. Cost: −0.6 stat gain (the week is not spent on general training). This gives the player an active investment in a matchup, beyond just writing a plan. It connects the ladder to the training system.

### 7. Add a rival arc

Temperament shifts after each interaction:

- A careful manager who gets upset by your boxer becomes more cautious: temperament drops by 5 (more likely to refuse).
- A bold manager who wins becomes more aggressive: temperament rises by 5 (more likely to accept).
- A manager who ducks you twice and then owes you becomes wary: temperament drops by 10.

This creates rivals who develop over time, not just boxers who move up and down. After three or four interactions, the player has a read on each manager.

### 8. Add an answer day event

The answer arrives as a visible moment on Home. A sticky note flips from "Pending" to "Yes" or "No" with a sound cue. The card updates immediately. This creates tension in the waiting and makes the loop feel alive, not bureaucratic.

### 9. Cut the useless options

- Cut the Makes weight filter (duplicates Legal now).
- Cut the Sponsor (30) and Squad Camp (45) marks unless CHECK 8 confirms them.
- Cut the separate "Ask for a rematch" link (the row Ask handles it).
- Cut the travel line and home/away factor if no venue data exists.

### 10. Specify the "one ask for both dates" UX

The design says one action returns two separate answers. Show the visual: after pressing ASK FOR BOTH DATES, the card splits into two columns — one per date — each showing its own yes verdict, price and tips. The player then confirms one date, or withdraws both. This needs a clear description before it can be built.

### 11. Ensure at least one "reach" row is visible in the default view

The default view should always show at least one row above the player's Rep (within reach but challenging). This ensures the player sees the high-risk, high-reward options, not just the safe picks. If the folded "3 in reach can't be asked now" line hides all the interesting rows, the default view is too clean.

---

## The 10/10 page (1920×1080, Fights > Who do we fight?, Look B)

**Top bar (0–64):** Dark shell. OFFER flag if an incoming offer exists. Continue in green, showing what it stops for.

**Header (64–140):** Cream whiteboard. Your boxer's polaroid left, class and record. "Rep 38 · 8th" in Permanent Marker. Name once only.

**Rep bar (140–190):** Marker line on a ruled strip. Only the 55 Pro offer mark (30 and 45 cut unless confirmed). Hover shows the formula.

**Season strip (190–240):** Fixtures pinned on the board. Your bouts circled in marker. Regional stage, nationals dates. "Bouts 7 of 18." Scrolls if more than 12 dates.

**Incoming offer (if any, 240–290):** Sticky note. "Offer from Eastside · Leans Yes 60 · 28 Mar." Three buttons: Accept, Not This Show, Pass: "Your boxer pays 2 Rep." Conflict note if your ask covers that date.

**Status line (290–310):** "Clock: 5 free weeks → drain at week 8 · Target: beat the #3 by June."

**Left table (40–1180, 310–1040):** Cream paper on warm tan wall.

- Filter chips: In reach ✓, Legal now ✓, Likely Yes 50+, Ranked, Rivals, Pros, Beats plan. (Makes weight cut.)
- "Showing 6 of 24 · Show all."
- Dashed reach line at 55, labelled "Your reach: up to 55."
- At least one row above your Rep visible (the reach row).
- Folded line: "3 in reach can't be asked now ▸."
- Red chips only for risk: Weight at risk, Stopped 12%, Injured 4–8%.
- Your row with slate background.
- Columns: Rank ▲▼, Record, Rep, Style · Plan (link to "Write a line"), Last, Win Chance (code band), Leans Yes (hover for breakdown), Win →, Loss →, Chips.

**Right card (1220–1880, 310–1040):** Paper sheet with aluminium frame.

- "Your boxer v the #3" — no opponent name repeated.
- Leans Yes box: "Leans Yes +10" with hover breakdown. Temperament shown: "Careful manager."
- Win Chance box: code band with hover: "Rep gap +6 · Plan beats counter · tape: 1 of 3 habits."
- IF WE WIN / IF WE LOSE in two columns. Every line from R4. Injury risk as a band: "Injured in 4–8 of 100."
- Show dates: two columns, one per date. Each shows its own yes verdict and price. Player confirms one.
- TO RAISE YES: up to 3 tips, each tied to one R6 factor.
- Regional stage conflict (if any): "Stoppage risk 12% → would miss Regionals 18 Apr → nationals path closes."
- Buttons: ⚡ ASK FOR THIS DATE (gold, only one date confirmed), Pin as Goal, Study Tape → Film evening.

**Type and hover:** Nothing under 14 px. Every number opens its sum on hover. Marker fonts for headers, mono for data. Gold accent only on the main button.

---

SCORE depth=8 general=7 play=7

