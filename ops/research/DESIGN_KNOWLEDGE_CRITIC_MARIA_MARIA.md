# DESIGN_KNOWLEDGE_CRITIC_MARIA_MARIA - Maria answer (seat queue SQ94)

Brief: research/DESIGN_KNOWLEDGE_CRITIC_MARIA.md
Sent: 2026-11-14 04:11 | collected: 2026-11-14 04:41 by Tools/seat_queue.py (the 30-min reconcile)
Verify the sources before using it.

---

I give PROGRESSIVE KNOWLEDGE v2 **DEPTH 7, GENERAL DESIGN 5, PLAY 7**, so it doesn't reach the owner's bar yet. The idea is strong, and it's the first map in this loop with a bot result behind it. General design fails because the map clashes with rules the game already has: amateur scouting, the Old hand edge, staff jobs, the week review's gain lines and fixed pronouns.

## Scores

**1. DEPTH: 7/10**
Each read costs something different: money ($250 to scout), a roster place and stipend (trial), a morning session (test day), injury and fatigue risk (harder sparring), or a whole bout. A player with a $1,800 rent bill has to choose which unknowns are worth paying for, so no read is free and none is dominant. It also touches most of the game:
- **Signing.** Hype makes a prospect look better than they are, so a flop is a read you skipped, not a rigged roll.
- **Booking.** Win chance comes from what you know, so a step up with an untested chin is a real gamble.
- **Hiring.** Staff become ways of seeing, which gives the strength coach and the physio a second reason to exist.
- **Later years.** A knockout, a layoff or a step up makes old knowledge go stale. That matches real boxing: a chin that holds at club level hasn't been tested at regional level.

What holds it back:
- **The proof is thin.** The reading bot beat the bar by one top-10 boxer per 60 worlds (+6 against +5), and only on one set of seeds. Spending about $10,000 per world for 6 more top-10 boxers across 60 worlds shows reads help a bot that reads well. It doesn't show that a human sees why a read paid off.
- **Under-fire reads have one source.** Only bouts can finish the under-fire group. The real choice is how hard to spar, which overlaps with today's camp and injury-risk choices rather than adding a new one.
- **Every read is price-only.** Nothing makes one read better for one kind of boxer. For example, a test day could reveal more on a raw novice than on an experienced boxer, which would add a real trade-off.

**2. GENERAL DESIGN: 5/10**
"The range never lies, and the bout reads the truth" is clean, and it keeps the fight's balance where it is.

What holds it back:
- **It breaks amateur scouting.** The pack says there's no scouting before accepting an amateur offer: amateurs learn tells only from tape study in fight camp, and only pros pay $250 to scout. The map turns "Scout" into one $250 button for any opponent or prospect without saying whether amateur tape study stays or goes.
- **It leaks the truth through gain lines.** The week review fills bars to the next whole point, and each morning's gain uses the headroom formula, which depends on potential. A player who reads the weekly deltas can work out a hidden stat or potential. The map says weekly gain lines don't change, but they have to show the range moving, not exact deltas.
- **Hires and edges don't match the game:**
  - Today the Old hand edge makes weight cuts easier. "Old hand: habits appear sooner" either replaces that or adds a second edge, and the map doesn't say which.
  - The staff jobs in the game are "Strength and conditioning ($100)", the physio, the second club coach and the cutman. The cutman is hired only for pro nights, so "cut risk, named" means nothing for an amateur.
  - "The injury meter over each boxer" isn't in the game.
- **The trial contract collides with the game's signing flow.** Today a trial is free: the prospect comes in on the Monday, and you sign or pass. A four-week paid trial needs a roster place (3 at the starting Unit), and the map never says whether the reception walk-in also gets one. It's marked "needs care", but those rules are the design.
- **The words break owner rules.**
  - "Rebuild his defence" and "I think she can take a shot" use fixed pronouns, against the sandbox rule (S412).
  - "Coach's guess in words" and "Hyped" have no fixed word list, against the rule of one word per concept.
  - Heart is a personality trait in the game, but the map counts it as an under-fire stat, and the map doesn't say which list wins.
- **Costs and widths are missing.** The test day fee, the width of each range on day one, how much each session narrows it, and how much hype moves the centre are all marked "(G)" or not given at all.
- **The goal-attribute rule is a deliberate leak** ("taken as a deliberate choice"). It makes "set a goal" a free read, which undercuts every paid read.

**3. PLAY: 7/10**
The moment you find out is the best part. The game stops at the round where a chin holds or breaks, shows the old range ghosted beside the new one, and offers one button to act on it. That's a reason to watch sparring and bouts. A first bout around week 4 that teaches you a lot fits the first-hour flow. Two things drag: up to three unknowns per boxer on every Monday report, and being stopped on a quiet sparring night for a small change.

## Options: missing, useless, and what each changes

**Missing**
- An amateur version of opponent reads: keep tape study in camp and say how it fits with the new $250 scout.
- A way to read the walk-in before signing (today you can only Sign or Pass).
- Which day-one range width each kind of boxer gets, and the hype size, as numbers.
- A threshold for when "the moment" stops the game, so small changes go to Monday.
- Clearing a "Hyped" tag: what read removes it, and does the trial remove it.

**Useless as written**
- **"Cut risk, named" from the cutman** for amateurs, because there's no amateur cutman.
- **Setting a goal as a read**, because it makes paid reads pointless for the goal's attribute.
- **"Weekly gain lines: no change"**, because unchanged lines give away the truth.

**What each option changes**
- **Scout ($250):** opens one opponent tell, or narrows one group on a prospect.
- **Trial:** four weeks' stipend and a roster place; the prospect's groups narrow through training; you walk away with no penalty.
- **Test day:** a morning session plus a fee; the body group narrows at once.
- **Spar them harder:** a named injury and fatigue risk; the under-fire group narrows up to halfway.
- **A real bout:** the only way to finish the under-fire group.
- **Hires:** each makes certain rows exact or faster to narrow.
- **The moment's button:** acts on the new knowledge straight away (for example, rewrite the plan or book the step up).

## To reach 10/10

1. **Keep the amateur and pro scouting split.** Amateur opponents: tells open only through tape study in fight camp, as today. Pro opponents: $250 to scout, as today. Prospects: the new $250 scout narrows one group. Say this on each button.
2. **Close the gain-line leak.** The week review shows each range's centre and edges moving ("Strength 58–66, narrowed by 2"), never an exact delta. Headroom uses true potential inside the rules, but the screen shows only "room to grow: some / lots / little". Probe: a bot reading only the screen can't recover a true stat within 2 points before its range does.
3. **Write out every number.**
   - Test day: $60 and one morning (EXAMPLE).
   - Day-one widths: body ±8, skills ±12, under fire unknown (EXAMPLE).
   - Each session narrows a group by 1 point at each edge; a bout narrows under fire by 4 (EXAMPLE).
   - Hype adds 3 to 8 points to the shown centre (EXAMPLE).
   - The bot test sizes them all.
4. **Fix the trial.** A trial takes a roster place, costs half the stipend for four weeks, and needs a free place. The walk-in gets the same choice: sign now, trial, or pass.
5. **Match hires to the game's staff.**
   - Strength and conditioning ($100): makes the body rows exact.
   - Physio ($75): makes recovery and flexibility exact and shows a training injury chance on the Week.
   - Second club coach: skills narrow 25% faster.
   - Cutman: pro nights only.
   - The Old hand keeps easier cuts. "Habits show sooner" stays off unless the owner makes it a second edge.
6. **Cut the free read from setting a goal.** The goal shows the range, and meeting the goal narrows that attribute by a set amount.
7. **Give "the moment" a threshold.** The game stops only when a range moves its centre by 5+ points or an under-fire group opens for the first time. Smaller moves go to the Monday report, at most two unknowns per boxer.
8. **Add one read that favours a kind of boxer.** A test day narrows twice as much on a boxer with under 5 bouts. A spar against an outside partner ($160, from fight camp) narrows the under-fire group up to 75% but carries the injury risk.
9. **Fix the words.** "Rebuild the defence", "The coach thinks your boxer can take a shot." Set one word list for the coach's guess (Unknown, Rough, Good read, Exact) and one tag (Hyped). Move Heart into one list only.
10. **Re-run the bots on three seed sets,** with a "human" reader who only uses the moment and the Monday report. Bar: +5 top-10 boxers on every set, after costs.

**My 10/10: the Fighter page Overview with knowledge, 1920×1080**
- **Header (120 px):** portrait, name, weight class, age, stance, record, and a "Hyped" tag if the boxer has one.
- **Left column (560 px), WHAT WE KNOW:**
  - Three bars (Body, Skills, Under fire). Each shows a range drawn as a fading band with its centre marked and a word from the list (Rough, Good read, Exact).
  - Opening a bar shows its rows.
  - Each row's hover says what narrowed it and what would narrow it more.
- **Centre (800 px), FIND OUT:** one card for each read that's available now: Test day, Spar them harder, Trial for prospects, and Scout for pros. Each card shows its price (money, a session or a named risk), what it narrows, and by how much. One button each, greyed with the reason when it can't run.
- **Right column (560 px), WHAT'S STALE:** groups that widened, with the cause ("a step up to regional: under fire widened"), the next bout and how much it would teach, and the hires that would make rows exact, with their cost.
- **Bottom strip (100 px):** the last "moment" kept as a card (old range ghosted beside the new one, one sentence, its button) until the player acts on it or the week ends.
