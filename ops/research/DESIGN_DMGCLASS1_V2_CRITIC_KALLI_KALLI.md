# DESIGN_DMGCLASS1_V2_CRITIC_KALLI_KALLI - Kalli answer (seat queue SQ264)

Brief: research/DESIGN_DMGCLASS1_V2_CRITIC_KALLI.md
Sent: 2026-11-21 01:40 | collected: 2026-11-21 02:10 by Tools/seat_queue.py (the 30-min reconcile)
Verify the sources before using it.

---

Got both. I'm writing LADDER1 v6 against John's and Dola's 10/10 lists, and scoring DMGCLASS1 v2 as a fresh critic, both at once.

Both are underway. You'll get each one in full, in parts, as soon as it's written.

# DMGCLASS1 v2: fresh critic score (Kalli, S459)

I judged the mechanic from the critic pack and the map only. The repo can't be reached, so every code line the map cites, and every system the pack doesn't list, is marked CHECK. Anything I say about real boxing is from memory, labelled as such, and needs checking. I haven't added any sources.

**Scores**
- **Depth: 6 / 10.** Below the bar.
- **General design: 6 / 10.** Below the bar.
- **Play: 5 / 10.**

It doesn't pass the S459 bar yet. The engineering is good. The design has three gaps: the player never sees the class factor, the one real choice about class (whom to sign) is left out, and the class list doesn't match the owner's.

## 1. DEPTH: 6 / 10

**What works**
- The map is honest that weight class can't be changed. Your boxer's sex and class are fixed at signing, and the pack agrees (4.4: "a class limit"; no move up or down anywhere). The map refuses to invent a class picker, and that's right.
- The class factor really does change which pick is best in existing choices. Say your gym has a women's 57 kg amateur and a men's 75 kg amateur. The same step-up offer, the same towel line and the same plan lines are worth different amounts to each. A good player should handle the two differently, so the factor touches the whole roster, not one screen.
- Some trade-offs hold up:
  - **The towel line in heavy men's classes.** Careful protects the chin cap and avoids a second 30/90/365-day ban. But it throws away your boxer's own puncher's chance when behind on the cards.
  - **The pull-out replacement.** Double reputation against a short-notice opponent who's 5 points better is a fair gamble at 60 kg women's. At 75 kg men's, spending a favour makes more sense (CHECK: the pull-out card and club favours aren't in the pack).
  - **Chin against engine in camp.** +4 chin cuts the count odds by about 28% (exp(−4/12) ≈ 0.72, and the maths is right). That's worth a lot in heavy men's classes and almost nothing at 57 kg women's amateur.
- It ties into the economy. A stoppage loss costs 2 members and 4 reputation (pack 4.13), against 1 and 2 on points. So a gym with heavy men's boxers carries more member and reputation risk, and the class mix of your roster becomes a money question too. The map doesn't say this, but its numbers produce it.

**Why it isn't 7+**
1. **The five choices are existing choices whose payoffs move.** That's contextual depth, which is real, but it's tuning, not a new decision. On its own it lands around 6. The map says "five genuine multi-axis choices, zero dominant picks". But all five existed before; the factor only reweights them.
2. **The one real class choice is missing: signing.** The pack (section 1, 5.4, 5.9) says you pick whom to sign, and walk-ins and prospects each come with a class. That's the only moment where you choose a class. If finishes really run about 3–5× more often in men's 75 kg than in women's 57 kg, then signing a heavy puncher or a light out-boxer is a long-term strategy call: more stoppage wins and faster climbs, against more bans and more wear. The map never puts the class factor on the trial or signing card, so the deepest use of the mechanic is never offered.
3. **Some options go dead in light women's classes, and the map treats that as depth.** Choice 2 itself says next-round stop risk at 57/60 kg women's sits around 5–10% (ESTIMATE), under even Careful's 12. So the towel line almost never matters there, and Iron chin, which turns the first count into a stagger, has almost no counts to work on. Under the pack's "only actionable information" rule, a choice that changes nothing for a whole class of boxer has to be greyed with a reason, not counted as a trade-off.
4. **Choice 3 (plan slots) is asserted, not shown.** "PlanTest rewards when-hurt defence in heavy divisions" may be true, but nothing measures it. The pack's design rule (good plan about 59%, none 45%, bad 41%; 5 stat points about 72%) was measured on one class-blind matchup. With finishes cut to 1–2.5% in women's amateur, the plan's value and each perk's value could shift a lot. Depth claims need a per-class re-run.
5. **Several of the example numbers are shaky.** They're marked ESTIMATE, but they still support the depth claims:
   - The "62% KO share against a puncher" at men's pro middleweight is above the map's own 48–55% band.
   - "Saves about 11 points of stoppage risk" treats the hazard as linear. The real chain isn't: count odds, then a wave-off roll, a cap of 0.85 on each count roll and a cap of 0.9 on each wave-off roll, and decay on repeat count rolls.
   - "+5 rating means ×1.5 count odds" assumes +5 rating is +5 power over chin. Rating isn't power minus chin. CHECK.

## 2. GENERAL DESIGN: 6 / 10

**What works**
- It puts the factor in the right place. v1's mistake (adjusting a display formula) is found and fixed. One pure rule file is read by the in-round hurt roll, the round-end counts, the puncher's chance, the towel's 200-trial forecast, the plan tester and the world sim. That's one source of truth, and it follows the pack's "true numbers" principle. CHECK for every file and line cited.
- Existing tests stay green by design. The new factors go in separate keys that default to 1.0, apart from the perk multiplier. That's careful.
- Medical rest stays class-blind. **I agree, firmly.**
  - Real-world memory (CHECK): medical suspensions are set by the result and the medical, not by weight. A 57 kg boxer stopped cold isn't cleared faster than a 75 kg one.
  - The map lets the class difference show up the honest way. Heavier classes take more damage, so they get longer stand-downs (5/10/21 days from damage taken) and more stoppage losses over a career. No hidden multiplier does it.
- Measuring the unchanged game before fitting is the right order. It answers the double-counting worry in principle. The game already adds rounds and builds up damage (damage/60), so stacking real-world ratios on top would over-stop long bouts.
- The build order is clean: probe and baseline, then the factor and the fit, then the shown numbers.

**Why it isn't 7+**
1. **The class list doesn't match the pack or the owner.**
   - Pack 4.4: women's 57/60/65/75 and men's 57.5/60/70/75.
   - Owner Q-S294-233 added women's 70 kg. The map has it, so the pack needs updating.
   - The map's men's lightest class is 55 kg (`mfw`, "from code"). The pack says 57.5. One of them is wrong, so CHECK the code, then ask the owner which is meant.
   - Either way, both turn pro into the same pro class (the 57.5 kg cut-off), so it's an amateur-cell problem. But it is still a mismatch the map should flag up front, not in a thin-data note.
2. **The class names on the rows are loose.**
   - Women's 65 kg and 70 kg amateur are both called "Welterweight". From memory (CHECK), current Olympic and World Boxing women's classes are about 54/57/60/66/75, so 70 kg is closer to light-middle.
   - Men's 55 kg isn't an Olympic class from memory (57 is featherweight), and men's 70 kg sits near the Olympic 71 kg. CHECK.
   - The game shows classes in kg. Rows should be labelled by kg, not by real-world names that don't fit.
3. **The player never sees the factor, and that breaks "hover explains every number".**
   - The towel's "X in 100" and the Ask's "possible / a real risk" will quietly shift by class, with no line saying why.
   - There's no "in this class" part in any hover breakdown, no Why line on a stoppage ("Stopped round 2: third count, 44 damage"), and nothing on the signing card.
   - A player who moves from a women's 60 kg boxer to a men's 75 kg one will just see more stoppages and think the dice are cruel. That goes against pack principle R11 (a readable reason for every random swing).
4. **The pro "Stoppage %" stays a separate formula.** The map feeds class-aware inputs into `(1 − win chance) × KO share`, but that is still not the ring maths. Two numbers for one thing will drift. The towel already runs the real rules 200 times, so the pro row should use that method, or a table fitted from the probe, and a test should keep shown and real within a set tolerance.
5. **Women's pro 2-minute rounds are hidden inside the factor.** The map is honest about this in its notes, but it's hidden from the player and from the rest of the game.
   - A 2-minute round in the game still has six 30-second exchanges: full stamina use, full scoring, and the "first 2 uses per round" plan read on a 3-minute clock.
   - Squeezing the stoppage factor down fixes stoppages only. Energy, fades, Second wind and how the plan pays out are all still wrong.
   - The pack's own model makes the honest fix trivial: a round is a run of 30-second exchanges, so a 2-minute round is 4 of them.
   - Memory (CHECK): some women's title bouts have recently been fought 12×3 by agreement. That's another reason to make round length a rule setting, not a fudge in a factor.
6. **The fit is overfitted and under-sampled.**
   - 17 cells × 3 factors is 51 free numbers, fitted to about two targets per cell. Many different sets will pass, so the result isn't stable.
   - Strict monotonicity is checked after the fact instead of built in.
   - N=400 is too small for the low cells. At a true 2% rate, one standard error is about 0.7 points, against a band only 1.5 points wide (1.0–2.5). The pass/fail is mostly noise.
7. **Round length is still half handled.** One factor per pro cell must fit the 4/6/8/10-round mix at once. The map prints a separate table for each length but sets no target for any of them, so a cell can pass on its average while 4-rounders barely stop and 10-rounders become shootouts. That's double counting by another route.
8. **It leans on systems the pack doesn't list:** towel lines (Careful/Normal/Brave), the pull-out card, club favours, the liver count, the cracked rib, and the stopped-to-counts rule from John's knockdown research note. They may all exist (the map cites lines), but the pack is the critic's truth. CHECK each one, and update CRITIC_ACCESS / the pack if they've landed.
9. **The words don't follow the owner's rules.**
   - The map is a wall of code names. That's fine for Claude, but there's no plain-words summary for the owner.
   - The same idea is called "Stoppage", "Getting stopped", "stop risk", "finish" and "end early". Per "one word per concept", pick one for screens: I suggest "Getting stopped".
   - The pack's 4.5 says the Ask is built (S512–S518), and section 8 says amateurs can't ask. The newer line wins, but flag it for the pack.

## 3. PLAY: 5 / 10
- **For:** heavy men's classes will feel different. More counts, real comeback knockouts, and towel calls that matter make for tense fight nights. Light women's classes become fights won on points, where the plan and the jab decide. Variety across a roster is good for a sandbox (S412).
- **Against:** nothing tells you it's happening, so there's no anticipation and no reward you can feel. The player never gets a "your 75 kg boxer finishes 1 in 6, make the most of it" moment. No week-to-week hook comes from the mechanic itself.

## 4. The numbers: SQ257 bands against real boxing (memory, CHECK)

| Cell | Map band | My read |
|---|---|---|
| Women's 57 kg amateur | 1.0–2.5% | Fits elite tournament books (women's RSC rare, memory). But the game's club shows are novices with wider gaps, and memory says club-level stoppages run higher. Suggest 1.5–4% for club shows, ESTIMATE. |
| Men's 75 kg amateur | 12–16% | High compared with my memory of recent elite tournaments, which is single digits to low teens. Plausible for club novices. CHECK. |
| Men's 75 kg pro | 48–55% | Fits the common memory that about half of pro wins at middleweight come early. But record-based KO rates are pushed up by mismatches, and the game's world pairings are fairer. Fit the world pairings near the bottom of the band. CHECK. |
| Women's pro, all | 14–26% | Fits memory (women's pro mostly goes to points). The 72.6 kg note is a good catch. |
| Glove weights | 12 oz above 67 kg | My memory is a 64 kg cut-off for men's amateur. CHECK. |

**Sources:** BoxRec, FightMatrix, the IBA/Paris 2024 results books and the England Boxing rule 4.1.2 are plausible. I can't confirm the papers (Bianco 2013, Gavagan 2017, Krkeljas & Kovac 2021) from memory, so CHECK each one before it's quoted anywhere.

**Names in headers (S448):** no person's name appears in the map body. ✓
**No fixed he or she (S412):** the map says "your boxer" throughout. ✓

## 5. Options: what each changes, what's missing, what's useless

**What each existing option changes once the class factor is live**

| Option (where) | What the class factor changes | Verdict |
|---|---|---|
| Take / Pass an offer, and Ask for a bout (Fights, Ask panel) | The chance of getting stopped, and so the expected ban, wear and lost lesson | Real choice, but the class part isn't shown |
| Pro offer rows: Tune-up / Step up / Payday | The shown "Stoppage %" | Real choice. The shown number still comes from a separate formula |
| Towel line: Careful 12 / Normal 20 / Brave 33 (Fight prep) | How often the towel decision comes up | Real in heavy men's classes; **nearly dead in light women's** |
| Throw the towel / Box safe / Send out (corner) | The odds of each outcome | Real in heavy classes; rarely shows in light ones |
| Plan lines: when hurt, opponent hurt, pace (Playbook) | What defence lines and finish lines are worth | Probably real; **not measured** |
| Plan Test (Playbook) | Results follow the class automatically | Good, if it shows how bouts end (see below) |
| Pull-out answers (fight week, CHECK) | The replacement's stop risk | Real; the class part isn't shown |
| Camp focus, and the stats you train | What chin is worth against footwork and jab | Real; hard to see without a class line |
| Perks: Iron chin, Finisher | How much each pays | **Near-useless in women's amateur** unless it's shown |
| Sign / Pass a walk-in or prospect | Career finish rate, bans, wear, climb speed | **The best use of the mechanic, and missing** |

**Missing options and lines**
1. "Getting stopped in this class: n in 100" on the trial/signing card and on Find a fighter cards.
2. A class part in every stoppage hover: "power over chin +x · damage so far · class: men's 75 kg".
3. A Why line on every early ending: the round, the count, the damage, and the class.
4. The Plan Test result split into points and early endings, so you can see a plan's finish rate in this class.
5. On each perk card: "In this class worth about n wins in 100".
6. The towel row with a reason when it rarely comes up: "Rarely comes up in this class: 4 of 100 bouts."
7. A rule setting for round length: 2-minute rounds = 4 exchanges.

**Useless or harmful as written**
- **Towel line in light women's classes:** grey it with a reason, or show how often it comes up.
- **Iron chin in women's amateur:** keep the perk, but show what it's worth.
- **The pro "Stoppage %" formula:** replace it with the real-rules forecast.
- **"Featherweight / Welterweight" row names that don't match the kg:** use kg.
- **`WorldSim._roll_stoppage`:** dead code; delete it in the build.
- **A weight-class picker:** correctly not added. Good.

## 6. To reach 10/10 (most important first)

1. **Fix the class list and the labels.** CHECK the code's men's lightest class (55 against the pack's 57.5) and ask the owner which is right. Confirm women's 70 kg (Q-S294-233) and update pack 4.4. Label every cell by sex, kg and amateur/pro, and drop the real-world class names.
2. **Make the factor visible, with one shared hover.** Build one breakdown, used by the towel strip, the Ask answer, the offer card, the full report, the pro row and the pull-out card: "Getting stopped: 18 in 100. Power over chin +4: +6 · Damage taken so far: +3 · This class (men's 75 kg amateur): bouts end early about 3× as often as women's 60 kg." Use one word, "Getting stopped", everywhere, with the number and the word together ("18 in 100 · possible"). The pack's hover rule requires all of this.
3. **Put the class on the signing decision.** Trial/signing card and Find a fighter cards: "In this class: about 1 in 8 bouts end early (women's 60 kg amateur about 1 in 40)." Add the climb trade-off in one line: "More early wins; more bans and wear." This is the only place where class is a choice, and it turns tuning into depth.
4. **Make the pro "Stoppage %" the real forecast.** Compute it the way the towel does (a few hundred runs of the real rules, cached for each offer) or from a table the probe fits. Test that shown and real stay within ±3 points in every pro cell. Delete the separate formula path.
5. **Make round length a rule setting.** Exchanges per round becomes a setting: 6 for 3-minute rounds, 4 for 2-minute rounds (women's pro), and bouts agreed at 3 minutes keep 6. Fit the factor after this change, so it no longer hides a format difference. CHECK what changes: energy, Second wind, the "first 2 uses" plan read (2 of 4 exchanges is a bigger share), and scoring. Show "10 × 2 min" on terms.
6. **Cut the free numbers.** Replace 51 numbers with a shape: punch factor = exp(a × (kg − 60)) × a sex factor × an amateur/pro factor. Tie the count factor to the punch factor by one ratio, and fit the class stop factor once for each sex and amateur/pro. That's about 6–8 numbers, it can't break the class order, and the order test turns into a guard.
7. **Make the probe trustworthy.** Use N = 2,000 for cells under 5% (400 is fine above 10%). Print a 95% range for each cell, and pass a cell when its range overlaps the band. Add a target for each round count (4r / 6r / 8r / 10r, or at least "10-rounders end early no more than twice as often as 4-rounders", ESTIMATE), so a cell can't pass on the average alone.
8. **Re-measure the design rules for each class**, on the four class extremes: the plan's value (59 / 45 / 41), the stat gap (72 / 95), and what each perk is worth. Publish the results. Where a perk is worth under 1 win in 100 in a class, the perk card says so. If the plan's value falls a lot in women's amateur, check that "the plan is the star" still holds.
9. **Towel row in low-risk classes.** Fight prep shows "Comes up in about n of 100 bouts in this class" beside Careful / Normal / Brave, taken from the probe. Below 5 in 100, grey the row with that reason (the owner's actionable rule).
10. **A Why line for every early ending.** "Stopped round 2: third count of the round. 44 damage taken; heavy class." On a win: "Finished round 3: the opponent was hurt twice; your hooks line paid."
11. **Plan Test shows how bouts end:** "20 bouts: 13 wins (4 early), 7 losses (2 early)."
12. **Check the systems the pack doesn't list.** Confirm towel lines, the pull-out card, club favours, the liver count, the cracked rib and the counts-to-stoppage rule in the code, then add them to the pack and CRITIC_ACCESS. Until then, choices 2 and 4 are CHECK.
13. **Check SQ257.** Confirm each paper and book exists and says what's quoted. Re-anchor the amateur bands on club-level data where it exists; if it doesn't, mark them ESTIMATE and keep the Olympic bands as the floor. Fit the pro cells near the bottom of each band, because the world's pairings are fairer than real records.
14. **Add a plain-words summary for the owner** at the top: six lines, no code names. Keep the code map below it for Claude.
15. **Not built, and needs an owner decision:** moving a boxer up or down a class (a weight cut against strength trade-off). It would be the strongest depth this mechanic could have, but it needs a new rule and the owner's OK. Leaving it out is right for now.

## 7. The 10/10 as a 1920×1080 page (Look B)

**Screen: Fights > a bout offer > Full report, with the "How it can end" board.** This is where the mechanic pays off: one offer, priced honestly for this class.

**Frame and kit**
- Warm tan plaster wall and a wood-framed whiteboard, with cream paper notes pinned on.
- Headers in Permanent Marker and body text in Kalam, nothing under 12 px. Numbers in a clean mono.
- **Gold on one thing only: the Accept button.**
- Names appear once, in the header.

**Top bar (0–56 px, dark):** Back and Forward arrows, the gym name, "Sat 28 Mar · Week 12" (hover card), cash "$4,210 · running +$85 a week" (hover card), the big button "CONTINUE to Thu 19 Mar, the offer expires", and Menu.

**Header strip (56–150 px, cream paper taped to the board)**
- **[Your boxer's name] vs [Opponent's name]**, in marker.
- Under it, plain chips: "Women's 60 kg · amateur · 3 × 3 min · club show 28 Mar · answer by 19 Mar".
- No other names anywhere on the page.

**Left third (x 40–640): Tale of the tape polaroids**
- Two stylized comic portraits, head to feet, in boots, on red and blue paper.
- Record, age, weight on the day against the limit, height, reach, stance.
- Strength gap chip: "+3 the opponent".

**Middle (x 680–1240): HOW IT CAN END** (the mechanic's board, drawn as a marker pie on the whiteboard)
- One pie of 100 bouts: "Your boxer wins on points 38 · wins early 4 · loses on points 52 · gets stopped 6".
- Under it, the line in marker: **"Getting stopped: 6 in 100 · unlikely."**
- **Hover card (on hover, never auto-open):**
  - "Power over chin: the opponent +3 → +2"
  - "Your boxer's damage coming in: fresh → 0"
  - "This class: women's 60 kg amateur. Bouts here end early about 1 in 40; men's 75 kg about 1 in 7 → −5"
  - "Total 6 in 100 (ESTIMATE until the probe lands)"
- A sticky note under the pie, only because it's actionable here: "Towel rarely comes up in this class: about 3 of 100 bouts. Your line: Normal." (link: Fight prep)
- A second sticky, shown only when the Plan Test has been run: "Plan Test, this opponent: 13 wins (3 early) of 20." (link: Test it)

**Right third (x 1280–1880): IF YOUR BOXER WINS / IF YOUR BOXER LOSES** (two cream cards)
- **Win:** rank change, +8 members, +5 reputation, $450 ticket cut, morale +8.
- **Loss on points:** −1 member, −2 reputation, morale −12, next offer at the normal time.
- **Loss by stoppage (6 in 100), its own short block:** "30 days out (90 if it happens again within 90 days) · chin ceiling −2 for good · −2 members, −4 reputation · next offer 8 weeks later."
- Each number has a hover with its rule. Rest lines show no class part, because rest is the same in every class.

**Bottom strip (y 960–1040)**
- Pass (flat button) and Full file (flat button) on the left.
- **Accept the bout** in **gold**, on the right.
- If the bout is unsafe, the Accept button is greyed with the reason written on it.

**Two smaller frames (described, not on this page)**
- **Trial/signing card:** a polaroid, the RPG stats and a cream line: "In this class: about 1 in 7 bouts end early. More early wins, more bans and wear." The header carries the name; the line doesn't.
- **Result Why after an early ending (dark fight-night style, handwritten):** "Stopped round 2: third count of the round. 44 damage taken. Heavy class: counts come fast. NEXT: chin and a 'when hurt → tie up' line." with Train Durability next week.

The pie, the hover breakdown, the signing line and the Why line together make the class factor something you can see, act on, and feel. That's the gap between today's 6 / 6 / 5 and a 10.

LADDER1 v6 is still being written; it follows when done.

That's the full DMGCLASS1 v2 score: 6 Depth, 6 General design, 5 Play, so it misses the 7+ bar. The three fixes that matter most are showing the player the class factor in every hover, putting the class on the signing card, and settling whether men's lightest amateur class is 55 or 57.5 kg.

# LADDER1 v6: the season ladder, priced in full (S459, 2026-11-21)

Kind: design map, full replacement for v5. Design only, no code. Scores carried in: v5 got 7 / 6 / 7 from one critic and 8 / 8 / 8 from the other (Depth / General design / Play).
Marks on every number: (P) proposed here; CODE in the game today (pack section named); DERIVED worked out from CODE or (P) rules; ESTIMATE a guess the probes must replace; CHECK the pack could not confirm it.

## What v6 changes from v5, in one screen
1. The card prices the bout in the game's real lines only. The ticket cut is paid on every bout, win or lose ($450, CODE 4.13), so money no longer separates rows. Gym standing and win morale now scale with the bout (P). Injury is a line (6 in 100, CODE 4.10).
2. Venue and travel are cut. The game holds no venue (S410) and no travel cost, so the home/away part of the yes score and the travel line are gone.
3. The yes score is a fixed threshold, not a dice roll: 50+ is a yes, every No names its biggest minus part, and a host with no minus parts always says yes. It sits on top of the Ask the game already has (BUILT S512-S518).
4. The clock: a bout 20+ below doesn't stop the clock, and the weeks booked for it still count as free weeks.
5. The cases use the code's win band, not Rep's expected. Each opponent shows their bout count, and NOT SAFE rows are greyed. A new Case D shows the ladder paying for training.
6. The card gains "Write a line", "Pull out later: $300", one ask for both dates, Pin → goal, and Study tape → Film evening. The rematch link, the Makes weight filter and the 30 / 45 marks are cut.
7. The filters gain Low risk. Greyed rows say when they open and what the yes score will be then. "Not this show" covers "remind me later". The season strip opens a season view on a press.
8. Look B (pack section 7) rules the page. The owner question on the look is dropped.

## 0. Owner rules this map keeps (quoted)
- The screen: "this is not bad that john made". The ladder screen the player uses keeps that screen's structure: table on the left, yes card on the right, the bout card below, show and fight week at the foot.
- S425: every menu the mechanic appears on is listed with what it is wired to (section 9). The bar is 7+ Depth and 7+ General design from fresh critics.
- S403: "i do not want stupid and unecessary information to be displayed unless the player can really do something about it." Every line on the card changes a pick. Every greyed row says when it opens.
- S448: "notice how the names are only mentioned on the header , nowhere in text menus options , follow that rule". In a list of people, each row's header is the boxer's name. Lines, tips and buttons say "your boxer", "the opponent", "their corner".
- S412: "Never write about one boxer as the story, and never a fixed he or she." Any gym, any boxers, women or men.
- Pack 7: "nothing opens by itself". The ladder, the season view and every card open on a press. Moments come as top-bar flags or Home notes.
- Q-250, S475, S428: kept as v5 section 0 quoted them, unchanged.
- Q-S294-233: the women's 70 kg class exists.
- S405: every critic ends with To reach 10/10 (this map ends with its own).

## 1. Words and units
- **Rep**: the boxer's ladder number, 0–100 (P). It moves only on results (R3) and the clock (R8), never on stats.
- **Gym standing**: the gym's number on screen. It is the code's gym reputation (CODE 4.13: drives members and the sponsor tier). Only the label is new (owner question 1).
- **Place**: the row number in the class table, by Rep. A boxer shows a rank only at 4+ wins (CODE 4.14); others show "–".
- **Gap**: the opponent's Rep minus your boxer's Rep. Every distance is in Rep points, never places.
- **Win band**: the code's win chance shown as a band (CODE 4.5, BoutRead). It reads stats. Rep's "expected" reads only Rep. The two differ on purpose (Case D).
- **Fight week**: the TAPER week before a bout (CODE 4.1). Amateurs have a fight week, not a camp.
- Money in USD. Stamina and Fight IQ are the stat words. The facility is the gym.

## 2. The rules

### R1 The table
- One table per sex and class, the same table World > Rankings shows (CODE 4.14). Women's 57 / 60 / 65 / 70 / 75 kg (70 kg by Q-S294-233), men's 57.5 / 60 / 70 / 75 kg. Women never fight men: every row in a table is the same sex and class as your boxer.
- Columns: place, rank (4+ wins, CODE), the row header (the boxer's name with a portrait), record, bouts (new column, DERIVED from record), Rep, style word (CODE), and the duck mark (R7).
- Ladder size per class: CHECK 1.

### R2 Reach
- Up: your boxer may ask anyone up to **10 + Rep ÷ 5** points above (P). At Rep 30 that is 16 points (DERIVED).
- Down: no limit on asking. A bout **20+ points below** doesn't stop the clock (R8).

### R3 How Rep moves (P, numbers checked)
- Expected = 1 / (1 + 10^((opp − you) / 25)).
- Winner gains round(16 × (1 − expected) × weight). The loser loses the same amount.
- Weights: unanimous 1.0, majority 0.65, split 0.5. Stoppage 1.15, plus 2 more each way.
- Draw: your boxer moves round(8 × (0.5 − expected)) and the opponent moves the opposite.
- Rep floors at 0. Any amount below 0 is logged as "Ladder top-up" so the table stays even.
- Worked example, Rep 30 vs Rep 40 (expected 0.285, DERIVED): unanimous win +11, loss −5; stoppage win +15, stoppage loss −7; majority win +7; split win +6; draw +2.

| Gap | Expected | Win | Loss | Stoppage win | Stoppage loss |
|---|---|---|---|---|---|
| +16 | 0.186 | +13 | −3 | +17 | −5 |
| +10 | 0.285 | +11 | −5 | +15 | −7 |
| +8 | 0.324 | +11 | −5 | +14 | −8 |
| +2 | 0.454 | +9 | −7 | +12 | −10 |
| −4 | 0.591 | +7 | −9 | +10 | −13 |
| −8 | 0.676 | +5 | −11 | +8 | −14 |
| −22 | 0.884 | +2 | −14 | +4 | −18 |
All DERIVED from R3. Halves round up.

### R4 The full price on the card
Two columns, IF YOUR BOXER WINS / IF YOUR BOXER LOSES. There is no total and no single value column.

| Line | Win | Loss | Mark |
|---|---|---|---|
| Rep and place | +W → new place | −L → new place | DERIVED (R3) |
| Members | + Rep won, at least 2, at most 12 | −1 (stoppage loss −2) | win (P), today a flat +8 CODE; loss CODE 4.13 |
| Gym standing | + Rep won ÷ 2, at least 1, at most 8 | −2 (stoppage loss −4) | win (P), today a flat +5 CODE; loss CODE |
| Money | +$450 ticket cut | +$450 ticket cut | CODE 4.13 ("a bout adds a $450 ticket cut"); paid on a loss: CHECK 5. No purse for amateurs (CODE 5.6) |
| Morale | + (11 − 8 × expected), at least 4, at most 10 | −12 | win (P): +4 at expected 0.86, +10 at 0.14; today a flat +8 CODE; loss CODE 3 |
| Training | 1 fight week, about −0.6 stat points against a normal week | same | TAPER CODE 4.1; −0.6 ESTIMATE |
| Injured | 6 in 100 | 6 in 100 | CODE 4.10 (about 6% a 3×3 bout) |
| Stopped | — | "Stopped in n of 100: out 30 days, next offer 8 weeks later" | 30-day suspension CODE 4.10; STOP_REST_WEEKS CODE (S451). These are two separate rules. n ESTIMATE (probe 9) |
| Would miss | — | the shows, the stage or the goal date the layoff covers | DERIVED |
| Clock | resets, or "won't stop the clock" | same | R8 |

Small print under the card: booking adds +5 morale whichever way it goes (CODE 3). "Pull out later: $300" is the empty slot the club pays (CODE 4.4).

- **Would miss**: each club show the layoff covers costs one bout's $450 and its Rep chance. A regional stage the layoff covers is valued at **P(miss) × P(win the stage) × 5 Rep, plus the road to the national draw** (ESTIMATE; 5 is a stand-in for what a stage win is worth, P(win the stage) comes from the code's win band against the stage field). The card shows P(miss) as "n in 100" and the Rep as "about x Rep". The road stays in words because it can't be priced.
- Why no total: one number to sort by brings the script back (see the answers table in section 8).

### R5 Hard rules: the row greys out, says why, and says when it opens
Every greyed row shows **when it opens and the yes score from that date**, for example "Comes off rest 22 Mar · yes score 53 from that date" (DERIVED from R6).
- OUT OF REACH: more than 10 + Rep ÷ 5 above. Opens when the gap closes, shown as "in reach after one more win" (DERIVED from R3).
- BOOKED: either boxer has a bout. Opens the day after that bout (S520, CODE 4.5).
- RESTING: 10-day rest after any bout (S520, CODE), the 30-day suspension, an injury, or STOP_REST_WEEKS. Shows "Comes off rest <date>".
- AT THE NATIONALS: no other offers come while a boxer is in the run (CODE 2.8). Opens when the run ends.
- NOT SAFE: a novice (0–10 bouts) against an open boxer can't be accepted (CODE 4.5). Shows "Safe after your boxer's 11th bout · n bouts away" (DERIVED).
- CLUBMATE: same gym. Never opens.
- TWICE THIS SEASON: at most 2 bouts against one opponent per season (P). Opens on 1 Jan.
- TOO HEAVY: the code's weight forecast says your boxer can't make the limit by that show (CODE 4.4). Shows the first show date that can be made.

### R6 The yes score (P, on top of the built Ask)
What the game has (CODE 4.5, S512-S518): Ask for a fight names the sheet name, a step up, or a name you pick, at one of the next club shows. A host can say No and give its reason. A No to a boxer ON A RUN is a DUCK. Two ducks in 8 weeks and that corner OWES the bout. The door opens the day after a bout (S520). The asked show still falls after the 10-day rest, and if nothing was asked the sheet sends its own offer when the rest ends.

What v6 adds: the ladder is the "name you pick" screen, and the host's answer is shown before you press, as a score made of parts.
- **Yes score = 50 + the parts. 50 or more is a yes. Below 50 is a No.** No dice (P).
- Every No names its biggest minus part, or all of them if tied. A host with no minus parts always says yes (DERIVED: the score can't fall below 50).

| Part | Value | Mark |
|---|---|---|
| Their odds | (their win chance − 50) ÷ 2, held between −15 and +15 | (P); their win chance = 100 − the middle of your boxer's win band (DERIVED from CODE) |
| Your boxer's run | −5 a straight win from the 3rd, down to −20 | (P). "On a run" in the built Ask: CHECK 6 |
| Their clock | +2 a week since their last bout beyond 4, up to +20 | (P) |
| Their place | −10 if a loss would drop them out of the top 3 | (P). The top 3 matters for the pro offer (CODE 2.9: 7 wins and a top-3 regional rank) |
| Manager | careful −10 / normal 0 / bold +10 | (P). Hidden until that corner first answers you; until then the score shows as a range ±10 |
| Owed | the bout is a yes while it is legal | CODE 4.5 (OWES) |

- **One ask for both dates** (P, CHECK 7 for the built Ask): one press asks for the next two club shows. The host takes the first date where the score reaches 50.
- **TO RAISE THE YES**, under the score: only things the player can do, each with its gain: "Ask for 11 Apr: their clock +4", "Ask after their top-3 place is safe: +10". The run part is never listed, because there is no move that lowers it except losing.

### R7 Ducks and owed bouts
- Built (CODE 4.5): a No to your boxer while on a run is a DUCK. Two ducks in 8 weeks and that corner OWES the bout.
- Added (P):
  - The row shows "ducked 1 of 2" so the player sees an owed bout coming. A No that the yes score showed in advance still counts as a duck, which gives the player a reason to ask a host that will say no.
  - Your corner can duck too: passing an offer from a boxer on a run counts as your duck. Two in 8 weeks and your corner owes that bout.
  - An owed bout refused (only possible when the boxer who owes it chooses Pass while legal): **the boxer who refused pays 2 Rep to the challenger**.

### R8 The clock
- Free weeks count from your boxer's last counting bout. A counting bout is any bout against an opponent above, or no more than 20 points below.
- After **8 free weeks** Rep falls **1 a week** until a counting bout (P).
- A bout 20+ below doesn't stop the clock, and **the weeks booked for it, fight week included, still count as free** (P).
- The clock pauses while RESTING or AT THE NATIONALS (P).
- The card shows "Clock: 5 free weeks left" or "Won't stop the clock" (DERIVED).

### R9 Offers on the table
- An offer from another corner (the sheet name, CODE 4.5) sits above the table: the opponent row, the date, the yes is already given.
- Buttons: **Accept**; **Not this show (free)**, which comes back for the next show if it is still legal and is "remind me later" (P); **Pass (free)**.
- Pass costs only under R7. Then the button reads "Pass: your boxer pays 2 Rep to the challenger".
- A No to your own ask pays nothing, except a refused owed bout (R7).
- Whether offers come from a rival's corner through AmateurBooking: CHECK 4.

### R10 The top and the season end
- The season runs 1 Jan – 31 Dec (P).
- At season end the top 3 are named in the news and the #1 goes into Records as the season #1 (P). Rep carries over (P).
- The table's top-3 place is the one the pro offer reads (CODE 2.9), so the top is worth more than Rep alone.
- The bar above the table marks the place your boxer needs for the pro offer. The 55 mark stays as v5 defined it. The 30 and 45 marks are cut: the old CHECK on a boxer sponsor and squad selection found neither in the game.

## 3. Options on the screen, and what each changes
- **Filters**: In reach ✓ and Legal now ✓ are the default; there is also Show all.
  - In reach hides rows out of reach. Legal now hides greyed rows; the line "3 in reach can't be asked now ▸" lists them with their open dates.
  - Likely yes: score 50+.
  - Ranked: 4+ wins.
  - Rivals: boxers the gym has met or who ducked it.
  - **Low risk**: stopped in under 8 of 100 (P; 8 matches the built Ask's "unlikely" cut, CHECK 3).
- **Sort**: by Rep, the table order (CODE). Other sorts: yes score, gap, bouts.
- **A row**: a press opens its yes card and bout card on the same page.
- **Ask for this bout**: sends the built Ask for both dates (R6). Disabled with the reason on greyed rows.
- **Step up**: picks the highest-gap row in reach with a score of 50+ (the built Ask's step up, CODE).
- **Plan chip**, "Plan: Works vs Counter-puncher": **Write a line** opens Playbook > Game plan rated against that style (CODE 4.7 Rate against).
- **Study tape**: puts a Film evening on next week's plan against that opponent. It opens one tell on their file (tape study CODE 4.6, Film evening CODE 4.1). Greyed when "no tape" (an opponent with no bouts, CODE 4.6).
- **Pin as target**: marks the row. The next goal talk offers "Beat the pinned boxer by <date>" (goal talk CODE 4.11). It sits on the season strip.
- **Pull out later: $300**: a line on the card, not a button. Once booked, the bout page's pull-out costs the empty slot (CODE 4.4).
- **Season strip**: shows the shows, the regional stage, rests, the pinned target and the clock. A press opens the season view (P), section 7.
- Cut: the rematch link (TWICE THIS SEASON and the ask cover it), the Makes weight filter (TOO HEAVY already greys the row), and the 30 / 45 marks (R10).

## 4. Worked cases (the code's win band, not Rep's expected)
Setting for A, B and D: a women's 60 kg table. Today is Mon 2 Mar 2026 (week 9). Club shows are on Sat 14 Mar, 28 Mar and 11 Apr (every other Saturday from day 12, CODE 2.7). Entries for the nationals close at the end of week 10, Sun 15 Mar (CODE 2.8). The regional stage is Sat 18 Apr (P, from the v5 strip).
Your boxer: Rep 30, 10th, record 5-1, 6 bouts (still a novice), a run of 4 straight wins, last bout 28 Feb, so resting to 10 Mar (S520).
Win bands, stopped-in counts and managers are ESTIMATE examples. A real boxer's come from BoutRead and probe 9.

The table at default filters. Each row's header is that boxer's name; it is shown here as [Name].

| Place | Header | Record | Bouts | Rep | Gap | Style | Win band | Stopped in | State |
|---|---|---|---|---|---|---|---|---|---|
| #5 | [Name] | 8-2 | 10 | 46 | +16 | Pressure fighter | 30–45 | 9 | legal |
| #7 | [Name] | 7-3 | 10 | 40 | +10 | Slugger | 40–55 | 12 | legal, ducked 1 of 2 |
| #8 | [Name] | 6-2 | 8 | 38 | +8 | Out-boxer | 40–55 | 4 | legal |
| #9 | [Name] | 6-2 | 8 | 32 | +2 | Counter-puncher | 50–65 | 6 | legal |
| #12 | [Name] | 4-4 | 8 | 26 | −4 | Volume puncher | 60–75 | 5 | legal |
| – | [Name] | 1-5 | 6 | 8 | −22 | Volume puncher | 85–95 | 2 | legal, won't stop the clock |
| "3 in reach can't be asked now ▸" | | | | | | | | | |
| #6 (grey) | [Name] | 9-3 | 12 | 44 | +14 | Boxer-puncher | — | — | NOT SAFE: safe after your boxer's 11th bout · 5 bouts away |
| #11 (grey) | [Name] | 5-3 | 8 | 28 | −2 | Out-boxer | — | — | RESTING: comes off rest 22 Mar · yes score 53 from that date |
| #13 (grey) | [Name] | 4-5 | 9 | 24 | −6 | Pressure fighter | — | — | BOOKED 14 Mar, then rests to 24 Mar · yes score 51 for 28 Mar |
Out of reach (above Rep 46, hidden by the default filter): #1–#4.

### Case A: climb, hold or farm. Every row wins a different line
Averages over points results (the stoppage weights are left to probe 11). Money is the same on every row, because the $450 is paid on every bout.

| Row | Rep | Members | Gym standing | Morale | Money a bout | Injured | Stopped | Clock |
|---|---|---|---|---|---|---|---|---|
| #5, gap +16, band middle 38 | **+3.1** | +3.9 | +1.4 | −3.6 | $450 | 6 | 9 | resets |
| #7, gap +10, 48 | +2.7 | **+4.8** | +1.8 | −1.9 | $450 | 6 | 12 | resets |
| #12, gap −4, 68 | +1.9 | +4.4 | **+2.1** | +0.2 | $450 | 6 | 5 | resets |
| Farm, gap −22, 90 | +0.4 | +1.7 | +0.7 | **+2.4** | $450 | 6 | 2 | won't stop it |

How the figures are made (DERIVED from R3 and R4, using the ESTIMATE bands):
- #5: win +13, loss −3; members win 12; gym standing win 7; morale win 10. Rep = 0.38 × 13 − 0.62 × 3 = +3.1.
- #7: win +11, loss −5; members 11; gym standing 6; morale 9.
- #12: win +7, loss −9; members 7; gym standing 4; morale 6.
- Farm: win +2, loss −14; members 2; gym standing 1; morale 4.

Money over a season (ESTIMATE): a stoppage pushes the next offer 8 weeks back, about 4 club shows. Bouts lost to layoffs per pick: 0.36 / 0.48 / 0.20 / 0.08, worth $162 / $216 / $90 / $36.

- Read: the farm leads only on morale and on money over a season. It never leads on Rep, members or gym standing, and its weeks still run the clock.
- That is the bounce-back bout: a boxer near Flat (30) or Low may need it, because a Low boxer takes in only 0.7 of the corner's word (CODE 3). The farm's lead on morale is kept on purpose.
- v5's Case A separated rows by a $23 money gap. That gap is gone, and nothing replaces it.

### Case B: asking. The yes score, one ask for both dates, and ducks
Parts at 14 Mar / 28 Mar (R6):

| Row | Their odds | Run | Their clock | Their place | Manager | Score | Answer |
|---|---|---|---|---|---|---|---|
| #5 | +6 (they win 62) | −10 | +4 / +6 | 0 | not met, ±10 | 50 / 52, range 40–62 | Unknown until asked. The manager decides |
| #7 | +1 | −10 | 0 / +2 | 0 | careful −10 | 31 / 33 | No: "your boxer's run and a careful manager, −10 each". It is a duck, their 2nd in 8 weeks, so their corner now OWES the bout |
| #9 | −4 | −10 | +2 / +6 | 0 | bold +10 | 48 / 52 | One ask, the host takes 28 Mar |
| Farm | −15 | −10 | +16 / +20 | 0 | normal 0 | 41 / 45 | No: "their odds, −15". TO RAISE THE YES lists nothing the player can do, so the row says "won't say yes before the season ends unless the odds change" |

- Read: asking the #7 is a sure No, and still worth pressing. The No is a second duck, so the #7's corner owes the bout and the next ask is a yes while it is legal (CODE 4.5). The yes score turns a refusal into a plan with two steps.
- The greyed #11 shows its open date and its score from that date. "Not this show" on an offer from the #11's corner would bring it back for 28 Mar.

### Case C: the last bout before the nationals. The layoff line decides
A different boxer: Rep 30, 5 bouts, registered 3+ months, **stopped on 14 Feb**, so a second stoppage inside 90 days means longer out ("longer for repeats", CODE 4.10; 90 days, CHECK 8).
The 14 Mar show is the last before entries close. The #7 (Slugger, gap +10) and the #8 (Out-boxer, gap +8) cost the same on Rep: win +11, loss −5 on both (DERIVED: the two gaps round to the same numbers). The bands are equal at 40–55.

| | #7 Slugger | #8 Out-boxer |
|---|---|---|
| Win morale | +9 | +8 |
| Stopped in | 12 | 4 |
| Would miss the regional (stopped, or injured with a layoff of 35+ days: 6 × 0.5) | 12 + 3 = **15 in 100** | 4 + 3 = **7 in 100** |
| Stage value at risk: P(miss) × 0.5 × 5 | about 0.4 Rep and the road to the national draw | about 0.2 Rep and the road |

P(win the stage) 0.5 and the even layoff spread over 14–56 days are ESTIMATE.

- With no earlier stoppage, both rows would show "would miss: 3 in 100", and the #7's extra point of win morale would decide.
- Read: Rep can't tell these rows apart. The layoff line does. The card made the trade visible without a total.

### Case D: training ahead of Rep. The ladder pays for training
The Case A boxer, but with stats 5 points ahead of a same-Rep boxer. The pack measures that as about 72% (pack section 1).

| Row | Band | Rep | Members | Gym standing | Morale |
|---|---|---|---|---|---|
| #9, Case A boxer | 50–65 (58) | +2.3 | +4.8 | +2.1 | −1.0 |
| #9, trained boxer | 65–80 (72) | **+4.5** | +6.2 | +3.0 | +1.7 |
| #5, trained boxer | 45–60 (52) | **+5.3** | +5.8 | +2.7 | −0.6 |

Rep reads results only, so a boxer who trains ahead of Rep gains about +5 a bout. Rep catches the stats in about 4 bouts, roughly +18 to Rep 48 (ESTIMATE, probe 12). Then the bands meet the expected and the gains flatten. The ladder pays for the week's work and then asks for more of it.

## 5. Probes (renumbered; the old 13 is now 11, the old 16 is now 9)
All bars are (P). The runs are headless bot seasons.

| # | Measures | Bar |
|---|---|---|
| 1 | Table size and Rep spread per class, day 0 and after a season | Closes CHECK 1. A table holds 12+ rows |
| 2 | Rows in reach and legal at Rep 10 / 30 / 50 | 4–10 rows at the default filters |
| 3 | Rep drift and top-ups over 3 seasons | Class mean moves under 5 a season |
| 4 | Share of asks that are a yes, by gap | 30–70% of in-reach asks. Every No names a part (unit test) |
| 5 | Owed bouts per boxer per season | 0.5–2 |
| 6 | Weeks a boxer spends falling on the clock, normal bot | Under 10% of weeks |
| 7 | Rep against the win band | Rep tracks the band within 6 bouts |
| 8 | Season members with the scaled gain against a flat +8 | Within ±15% of today's total |
| 9 | Stopped in n of 100 by gap and style | Fills the card's Stopped line |
| 10 | Average win morale with the new rule against a flat +8 | Within ±1 |
| 11 | The five lines (Rep, money, members, gym standing, morale) for bots that always CLIMB / LEVEL / DROP / FARM | No bot best on all five. FARM never best on Rep, members or gym standing. A mixed bot beats each pure bot on 3+ lines |
| 12 | Training pays: a bot with +5 stats against the same bot | +15 Rep or more over a season |
| 13 | Busy boxer (12 bouts) against choosy (6): stats lost to fight weeks | Replaces the −0.6 ESTIMATE |
| 14 | P(win a regional stage) for typical entrants | Replaces the 0.5 ESTIMATE |

## 6. CHECKs
Closed by the pack:
- The ticket cut is per bout (4.13).
- There is no travel cost, so the line is cut.
- There is no venue (S410), so home/away is cut.
- The 30-day suspension and STOP_REST_WEEKS are two rules, both in code (S451).
- Rest between bouts is the game's 10 days (S520).
- Morale moves in a fight: +8 win, −12 loss, +5 booked, ±2 / 1 for corner calls (section 3).
- NOT SAFE is 0–10 bouts against an open boxer (4.5).
- The 4-win ranking is read by the pro offer's top-3 rule (2.9, 4.14).
- No boxer sponsor or squad selection exists, so the 30 / 45 marks are cut.
- The amateur Ask is BUILT (4.5).

Still open (8):
1. Ladder size per class.
2. Does the win band include the written plan?
3. Is the built Ask's "unlikely" cut 8 in 100? (Low risk filter.)
4. Can offers come from a rival's corner (AmateurBooking)?
5. Is the $450 paid on a loss too?
6. What counts as "on a run" in the built Ask?
7. Can one ask name two dates?
8. Does a booked bout stand after entering the nationals, how long is a repeat suspension, and does a layoff over a stage date end the run?

## 7. The season view (P; opens on a press of the season strip, never by itself)
- One cream paper sheet, 1 Jan – 31 Dec, one column a fortnight.
- It shows every club show (CODE fixtures), the entry close and the regional and national dates (CODE 5.8), and your boxer's bouts, rests and suspension.
- It also shows the clock's free weeks as a shaded run, the pinned target's goal date, and owed bouts with their 8-week window.
- A press on a show date filters the table to that date's legal rows.
- Built from the Fights fixtures list and World > Championships (both CODE). Close returns to the ladder.

## 8. Every critic point, answered

### John's To reach 10/10 (1–10)
| # | Point | v6 answer |
|---|---|---|
| 1 | Price the card in the game's real lines | Done, in four parts: (a) R4 pays the $450 on every bout (CODE 4.13; CHECK 5 for losses); (b) gym standing scales with Rep won, from +1 to +8 (P); (c) win morale goes from +4 at expected 0.86 to +10 at 0.14 (P); (d) probe 11 measures Rep, money, members, gym standing and morale. Case A was redone without the $23 money gap. Partly not: the farm also leads on morale, kept on purpose as the bounce-back bout for a Flat or Low boxer (Case A) |
| 2 | Farm weeks must not pause the clock | Done, R8: the weeks booked for a bout 20+ below count as free |
| 3 | Make the yes a fixed threshold, and align it with the built Ask | Done, R6 and R7: 50+ is a yes; every No names its biggest minus part; no minus parts means always yes; manager careful −10 / normal 0 / bold +10, shown after the first answer. Built on the S512-S518 Ask (DUCK, OWES), the door opening the day after a bout and the 10-day rest (S520) |
| 4 | R9 wording | Done: "Your boxer pays 2 Rep to the challenger", only under OWED. A No to your ask pays nothing, except a refused owed bout |
| 5 | The game holds no venue | Done: the home/away part and the travel line are cut (S410). This is buildable from what the game has |
| 6 | Redo the cases on the code's win band | Done: section 4 uses the band, shows each opponent's bouts, greys NOT SAFE with its countdown, adds Case D (training pays), and values the regional stage as P(miss) × P(win the stage) × 5 plus the road (ESTIMATE) |
| 7 | The card's options | Done: Injured 6 in 100 (CODE 4.10); Write a line on the plan chip; one ask for both dates; Pull out later: $300; Pin → goal talk. Cut: the rematch link, the Makes weight filter, the 30 / 45 marks (55 kept) |
| 8 | What Study tape does | Done: a Film evening next week against that opponent, opening one tell. There is no camp for amateurs |
| 9 | Close the CHECKs the pack answers | Done: section 6 closes 10 and leaves 8 open |
| 10 | Look B | Done: section 13 is in Look B, and the owner question on the look is dropped. The kit conflict is one line there |

### Logic points (11)
| # | Point | v6 answer |
|---|---|---|
| L1 | The ticket cut is per bout, not per win | R4: on every bout |
| L2 | Gym standing ignored the size of the bout | R4: scaled with Rep won |
| L3 | Win morale ignored the odds | R4: scaled with the expected |
| L4 | A farm bout's booked weeks stopped the clock | R8: they count as free |
| L5 | A random yes broke the pack's "never random refusal" | R6: a fixed threshold, no dice |
| L6 | The pass cost named the wrong payer | R9: the boxer who refuses pays the challenger |
| L7 | The home-show part needs a venue the game lacks | Cut |
| L8 | The travel line needs a cost the game lacks | Cut |
| L9 | The cases used Rep's expected for the win chance | Redone on the band. Rep's expected only prices Rep |
| L10 | The 30-day suspension was put inside STOP_REST_WEEKS | Two rules on the Stopped line (S451) |
| L11 | The 30 / 45 marks point at things not in the game | Cut |

### Dola's To reach 10/10 (1–5), and the options she flagged
| # | Point | v6 answer |
|---|---|---|
| 1 | A Low risk filter | Done: stopped in under 8 of 100 (CHECK 3 on the cut) |
| 2 | Greyed rows: next date and the yes change | Done, R5: "Comes off rest 22 Mar · yes score 53 from that date" on every greyed row |
| 3 | Remind me later | Done as "Not this show (free)": the offer comes back for the next show if still legal (R9). There is no separate reminder, because Home notes already carry offers (CODE 5.3) |
| 4 | A net-value sort | Declined: one number to sort by makes the top row the answer every week, and that brings the script back. Case A only works because five lines disagree |
| 5 | A season calendar | Done: the season strip opens the season view on a press (section 7), never by itself |
| Missing options | Low risk, remind later, a season view | All three added above |
| Useless options | The rematch link and the Makes weight filter | Cut (R5 TOO HEAVY and TWICE THIS SEASON cover them) |

## 9. Every menu the ladder touches, and what each is wired to (S425)
New pure rule modules (P), each a static script with no screen code: **BoutPrice** (the R4 lines), **YesScore** (the R6 parts), **LadderRep** (R3 Rep, R8 clock, R10 season).

| Menu | What the ladder adds | Wired to |
|---|---|---|
| Fights (amateur) | The ladder page: offer strip, filters, table, yes card, bout card, show and fight week, season strip | Region table (CODE 4.14), BoutRead band (CODE 4.5), built AskFlow for Ask and Step up (CODE 4.5), BoutPrice, YesScore, LadderRep (P) |
| World > Rankings | The same table: Rep and bouts columns, duck mark; a row opens the Rival file | Region rankings (CODE), LadderRep (P) |
| Rival file | Study tape, Pin as target, the yes score line | Tape study (CODE 4.6), Week Film evening (CODE 4.1), goal talk (CODE 4.11) |
| Fighter > Overview | NEXT STEP shows Rep, place, the clock, Rest until and the pinned target; Find a bout opens the ladder | NextStep (CODE 5.5), LadderRep (P) |
| Fighter > Week | The Film evening placed by Study tape, shown as a normal evening card | WeekBoard (CODE 4.1) |
| Playbook > Game plan | Write a line from the plan chip, already rated against that style | GamePlan, Rate against (CODE 4.7) |
| Goal talk | "Beat the pinned boxer by <date>" among the goals offered | Goals (CODE 4.11) and the pin (P) |
| Home notice board | Notes: an offer to answer (CODE), an ask answered, an owed bout, amber "Clock: 2 free weeks left" (P) | Home needs (CODE 5.3). Nothing opens by itself |
| Top bar | CONTINUE stops for an offer's last day (CODE) and an owed bout's last legal show (P); OFFER flag | Shell (CODE 5.0) |
| Bout page | TERMS gains the R4 lines and Pull out later: $300 | BoutPage (CODE 5.6), BoutPrice (P) |
| Fight result | Rep with the new place, members, gym standing and morale, each against what the card priced | BoutFinish (CODE), LadderRep (P) |
| Week review | Rep moves, a clock row, ducks and owed bouts | Week review (CODE 5.9), LadderRep (P) |
| Club > Money | $450 in ONE-OFFS IN, $300 in PAID OUT | Money (CODE 4.13) |
| Club > People | The members' reason line names a win up the ladder | Members (CODE 4.13) |
| Pro offer modal | The top-3 place line | Turning pro (CODE 2.9) |
| World > Championships | Stage dates feed the strip and the Would miss line | Championships (CODE 5.8) |
| Records | Season #1, ducks and owed bouts | Records (CODE 5.7), LadderRep (P) |
| Season view (new modal, on a press) | The year at a glance (section 7) | Fixtures (CODE 5.6), LadderRep (P) |

## 10. Owner questions (4, down from 6)
1. Show the gym's reputation as "Gym standing"?
2. Replace the flat +8 members, +5 reputation and +8 win morale with the scaled versions? Probes 8 and 10 hold season totals within ±15% and ±1.
3. Hide a manager's manner until their first answer (a ±10 range until then)?
4. A refused owed bout pays 2 Rep to the challenger, and your corner can duck too: yes?
Dropped: the random yes (now a fixed threshold) and the look (pack 7 rules it).

## 11. Self-score
- **Depth 8.** Four rows each win a different line (Case A). A sure No is worth asking (Case B). Two rows equal on Rep split on layoff (Case C). Training pays through Rep (Case D). It touches the nationals, the pro offer, goals, the Week and the Playbook.
- **General design 8.** Every number is marked. Venue and travel are cut. It sits on the built Ask, uses the game's words, and every greyed row says when it opens.
- **Play 7.** There are weekly reasons to look: owed bouts coming due, the clock, pinned targets, the season #1. The reward is still the next bout, not the ladder itself.

## 12. To reach 10/10
1. Run probes 11, 9 and 4 first, and replace every ESTIMATE on the card (bands, stopped-in counts, the −0.6, the 0.5 stage chance).
2. Close CHECKs 5, 6 and 7 against the built Ask and the ticket cut, then fix R4, R6 and R7 to match.
3. The fight result lights the card line that came true ("Members +11, as priced"), so the price is felt after the bout, in the Why's style. This needs a small addition to the result screen.
4. A rival corner that ducks twice gets a news line and a Records entry. This needs the AGREED, NOT BUILT rival gym for the full version (pack 4.14).
5. Two boxers from your gym in one class: one view of the table shows both, with CLUBMATE rows and each one's yes scores side by side.
6. Season view: drag the pin onto a show date to ask for that date. This waits on CHECK 7.

## 13. The 10/10 page at 1920×1080, Look B (pack section 7)
Kit note, one line: pack 7's Look B (Permanent Marker headers, Kalam notes) replaces v5's Bebas Neue / IBM Plex Mono. Nothing is under 12 px, gold sits on one thing (Ask for this bout), and green is only Continue.

- **Top bar** (dark, 0–64 px, S410): back and forward, gym name, date, flags, cash, CONTINUE in green.
- **Left rail** (0–96 px): the five buttons, with Fights lit.
- **The wall**: warm tan plaster with a wood ledge. The header on a strip of masking tape, Permanent Marker 40 px: your boxer's name, then "Women's 60 kg · Rep 30 · 10th". A polaroid portrait pinned at its left. This is the only name outside the row headers.
- **Offer sticky note** (yellow, 120–220 px, x 120–1100): "Offer: the #11's corner · 28 Mar" in Kalam 20 px, with Accept / Not this show (free) / Pass (free) as marker-drawn buttons.
- **Table** (whiteboard in an aluminium frame, x 120–1100, y 240–760):
  - Filter magnets on top: In reach and Legal now on; Likely yes, Ranked, Rivals and Low risk off; Showing 6 of 24, Show all.
  - Rows in Kalam 18 px: place, the row header with portrait and name in Permanent Marker 20 px, record, bouts, Rep, gap, style, a small stopped-in figure, the duck mark.
  - The selected row is ringed in red marker. Greyed rows are written in pale marker behind the line "3 in reach can't be asked now ▸", each with its open date and score.
  - A thin bar above the table marks the top-3 and the 55 mark.
- **Yes card** (cream paper on a magnet, x 1140–1820, y 120–560):
  - "WILL SAY YES" with the score 52 / 100 and "50+ is a yes".
  - The parts as a written sum: Their odds −4 · Run −10 · Their clock +6 · Manager bold +10.
  - The win band "50–65%" and the plan chip "Works vs Counter-puncher · Write a line".
  - TO RAISE THE YES with only what the player can do. The No reason is in red marker when below 50.
- **Bout card** (cream paper, x 1140–1820, y 580–900), "IF YOUR BOXER WINS / IF YOUR BOXER LOSES":
  - Rep +9 → 8th / −7 → 14th.
  - Members +9 / −1. Gym standing +5 / −2. Money +$450 / +$450. Morale +7 / −12.
  - Training: 1 fight week. Injured 6 in 100. Stopped 6 in 100: out 30 days, next offer 8 weeks later. Clock resets.
  - Small print: Pull out later: $300.
- **Foot** (wood ledge, y 920–1040):
  - The season strip with show dates as circled marker dates, 18 Apr starred, and the pin.
  - SHOW AND FIGHT WEEK: "Ask for 14 Mar or 28 Mar · the host takes 28 Mar".
  - Buttons: Study tape, Pin as target, and **ASK FOR THIS BOUT** in gold.
- **Hover**: every number shows its formula on a paper tag.
- **Motion**: every bar tweens. Nothing opens by itself.

The LADDER1 v6 map above is complete. I scored it 8 / 8 / 7. Fix three things before you paste it on:

- **Owner quotes in section 0:** the line for Q-250, S475 and S428 is a placeholder. Copy the exact quotes over from v5's section 0.
- **John's 11 logic points (L1–L11) in section 8:** I rewrote these from his critique. Swap in his own wording if it differs.
- **The easy bout leads on morale as well as money.** That's on purpose: it's a bounce-back bout for a boxer whose morale is low. It never comes out best on Rep, members or gym standing.

A copy is saved on my computer at `/workspace/ladder/LADDER1_V6.md`.
