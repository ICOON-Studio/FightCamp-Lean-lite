# CARDPROTO1 — independent, code-checked critic

## Verdict

**DEPTH: 5/10 · PLAY (fun): 6/10 · GENERAL: 5/10.**

**Does not meet the keep-mechanic bar (8+ depth AND 8+ play).** Keep this as an experiment, not a validated core. There is a readable, compact boxing guessing game here; there is not yet a reliable opponent-reading/deck-building game. Fun is an inference from the rules and simulated decisions, not a claim of human playtesting or browser usability testing.

Reviewed `proto/cardgame/README.md` and the complete `rules.js`. No prototype or test was changed. The README's scouting-performance claim does not describe the current `chooseAiCard`: that function never reads `fight.scouting`.

## Method and numerical evidence

Ran **24,640 complete bouts through the real rules**: 22 configurations × 1,120 bouts, including AI-vs-AI, random, a public-information tactical policy, largest printed damage, and all 12 single-card priorities. Also ran 200 supplementary AI bouts and live-state probes. No substitute combat resolver was used.

Reproduction specification for the main experiment:

- Enumerate ordered distinct pairs with `BOXERS.flatMap(a => BOXERS.filter(b => a !== b).map(b => [a.id,b.id]))`: 56 pairs, including both orientations, 20 repetitions each. Seed = `100000 + repetition*56 + pairIndex`.
- `createGame`, four `pickCampCard(game, aiCampPick(game))`, then `startFight`; prepare the opponent with `applyCampTo(f.opponent, campModsFor(opponentId, seed))`. This is symmetric camp preparation, not the UI's player-only camp advantage.
- In each fight call `playExchange` with the player's policy; the engine chooses the opponent. Between rounds use `pickCorner(game, aiCornerPick(game))`, except the random-corner ablation.
- Random policy draws a hand index from a separate `makeRng(hashSeed(seed,'policy'))`; it never consumes combat RNG. Duplicate cards retain their multiplicity. Fixed-card policies play that ID whenever held, otherwise hand[0]; these are legal priority strategies, NOT unlimited copies conjured into the hand.
- “Largest” chooses the largest `head + body` from `dmg || counter`, ignoring cost/range. Ties retain hand order.
- Tactical (“smart”, not optimal) chooses the hand card maximizing `expectedSwing(id, weights) * rangeFactor * affordabilityFactor + .015 * printedDamage`, with factors 1/.62 and 1/.6. Start with opponent style weights. For the first revealed habit whose `when` matches `contextOf(f,'opponent')`, set its card weight to 4 and multiply other weights by .3. This uses public state and revealed habits, never the hidden opponent hand or RNG prediction. Sort ties by hand order.
- Wins below exclude draws; draws are reported separately. Percentages are not win shares with half-credit draws. The identical seeds make configurations comparable, but different actions branch combat RNG; they are not identical luck tapes. A single win percentage near 45% has roughly ±3 percentage points binomial 95% sampling uncertainty (not a formal clustered/paired interval).

| Player policy vs engine AI | W–L–D / 1,120 | Win % |
|---|---:|---:|
| Engine AI | 510–530–80 | 45.54 |
| Random hand card | 373–667–80 | 33.30 |
| Tactical public-information policy | 488–571–61 | 43.57 |
| Largest printed damage | 430–613–77 | 38.39 |
| Always Jab if held | 354–668–98 | 31.61 |
| Always Cross if held | 388–664–68 | 34.64 |
| Always Lead hook if held | 398–638–84 | 35.54 |
| Always Body hook if held | 387–662–71 | 34.55 |
| Always Uppercut if held | 406–639–75 | 36.25 |
| Always Slip if held | 370–677–73 | 33.04 |
| Always Block if held | 391–640–89 | 34.91 |
| Always Roll if held | 371–666–83 | 33.13 |
| Always Clinch if held | 360–692–68 | 32.14 |
| Always Step back if held | 394–647–79 | 35.18 |
| Always Pivot out if held | 396–652–72 | 35.36 |
| Always Cut off the ring if held | 393–652–75 | 35.09 |

**Smart decisions beat random, but not overwhelmingly:** engine AI +12.23 percentage points; tactical +10.27 points. Merely picking printed damage gains +5.09 points over random and trails tactical by only 5.18 points. No tested one-card priority dominates; the best, Uppercut, still loses 639 bouts. This does not prove absence of exploits in optimized camps or human play. The AI is not a minimax benchmark and its own habits can override sensible choices.

### Length and swing

For AI-vs-AI: **17.64 exchanges average**, minimum 5, maximum allowed 18; **138/1,120 stoppages (12.32%)**, **1.568 knockdowns/bout**, 80 draws (7.14%). Player-minus-opponent total damage: mean **+0.47**, SD **26.15**. Thus most fights run their whole three-round length, but damage outcomes vary substantially. Total damage is cumulative inflicted damage, not remaining head/body after healing. No wall-clock human duration was measured.

For random: 17.78 exchanges, 7.41% stoppages. For largest-damage: 17.48 exchanges, 15.18% stoppages, damage-margin SD 28.44. Tactical: 17.70 exchanges, 9.82% stoppages, SD 26.66. More aggression increases volatility without making it the best winning policy. Seeded reproducibility is good, but misses, draws, shuffles, knockdowns and judge noise create several layers of luck over only six actions per round. These results measure aggregate spread, not an isolated judge-noise causal effect.

## Do scouting, habits, camp and corner change decisions?

### Scouting: usable by a human; inert to the shipped fight AI

In **1,757 live exchange states** over seeds 1–100 (default Ada, AI camp/opponent, actual exchange loop), choosing the player AI card with the original scouting file, an empty file, and both opponent habits revealed produced **zero changes**. Inspection confirms there is no scouting access in `chooseAiCard`. The README's AI scouting win-rate comparison cannot be reproduced by merely changing the file in this implementation.

My tactical policy changed its choice on **1,232/19,825 exchanges (6.21%)** when its revealed-habit weighting was switched off at the same state. That establishes actual decision relevance for a policy deliberately using the file, not the shipped AI.

| Tactical policy ablation | W–L–D | Win % | Difference vs tactical baseline |
|---|---:|---:|---:|
| Baseline | 488–571–61 | 43.57 | — |
| Clear scouting initially and after every corner | 469–587–64 | 41.88 | −1.70 pp |
| Reveal both initially | 492–562–66 | 43.93 | +0.36 pp |
| Remove both fighters' habits after starting | 505–545–70 | 45.09 | +1.52 pp |
| Remove player's camp benefits before starting | 528–515–77 | 47.14 | +3.57 pp |
| Pick camp uniformly from each offer | 517–532–71 | 46.16 | +2.59 pp |
| Pick corner uniformly from each offer | 491–558–71 | 43.84 | +0.27 pp |

Caveats: clearing scouting also makes the AI corner pick Study more (943 vs 579 times), so the −1.70 is a whole-policy effect, not isolated information value. Full scouting also changes corner choices. Removing habits leaves the tactical policy's scouting model intact, intentionally exposing its stale predictions; it is not a pure information test. Removing camp also resets its scout bonus and changes deck/shuffle consumption. Small differences should not be sold as proven advantages.

### Habits: real commitments, with a backwards condition

`habitCard` checks ordered habits and actual availability, then returns immediately, bypassing affordability and tactical scoring. Reads are probabilistic because the signature card may not be held. However, `contextOf.selfAhead` is **damage TAKEN by self > damage taken by foe + 6**, the reverse of “ahead on damage.” Probe: player head=20, foe head=0 yields `selfAhead === true`. Tomas/Rio can therefore hold because they are losing, contrary to the scouting sentence.

README says each habit is drilled twice into the deck; `makeSide` only copies the roster deck plus camp additions. There is no generic habit injection: e.g. Ada's opening Jab has two copies, but some signatures do not. Correct the promise or the data, not the critic's expectations.

### Camp: changes decks/stats, but AI preferences are not evidence of a plan

Adds are real, and Power/Stamina/etc. affect resolution. But random camp and even deleting the player's camp outperformed the default preference list in this sample. That is a warning about deck dilution and style-only camp priorities, not proof training is harmful generally. The camp adds cards but offers no removal, replacement, deck-size budget, or opponent-specific plan. Benefits are confounded with draw order. A meaningful next experiment is fixed-offer, per-card camp intervention across paired seeds, not a claim that all camp cards are balanced.

### Corner: tangible options, two broken promises

- **Gloves high:** stores `mods.punch = -0.15`, but `strike`/`playExchange` never consumes that field. Only the Block discount works. A seed-42 forced Cross-vs-Jab probe dealt **10.85175** with or without `{punch:-.15}`. Its advertised 15% punch penalty is absent.
- **Change the plan:** player gets two extra cards (up to seven), then refill targets five; this is a persistent larger choice set until played down, not a discard/redraw. Opponent pays its wind but `applyCorner` skips its draw because of `key === 'player'`.
- **Study his corner:** helps a human or my policy, not the shipped fight AI. At two known habits it can still be offered, charge 3 wind, and reveal nothing. AI baseline picked Study **574** times and Gloves high **707** times. Random corners were effectively tied with the heuristic in the tactical experiment.
- **Breathe**, **Ice the eye**, and **Sit on the stool** have concrete recovery/tempo consequences. The generic between-round recovery (+14 plus rounded .12×Stamina, and −6 body damage) reduces urgency and can cap away some card recovery.

## Defensive damage, dominated cards and dead choices

Defence is not zero-damage: `strike` uses `counter` instead of `dmg` and Speed instead of Power. Slip/Roll start at 3 head, Block/Step back at 2, Pivot at 1, Clinch and Cut off at 1 head + 3 body. They use accuracy, range, opponent Defence, and the resolution multiplier just like punches. Clinch additionally drains 4 wind on any hit; body damage drains rounded .45×body wind.

Important mismatch: `l` is **0.3 damage**, not “you do not land.” `w` is 1.15, trade .7; only `X` and `n` guarantee zero. Losing cards can hit, increment landed counters, set up a Jab combo, trigger Clinch drain, and move range. `rangeAfter` prioritizes any hit in order Cut off, Clinch, Uppercut, Body hook, Step back, Pivot, Jab, rather than the exchange winner. Thus a smothered Cut off can override a successful escape. The descriptions hide a consequential rule.

AI-vs-AI card usage across both sides: **39,512 card plays**. All twelve appeared; Block was least used, **1,313 (3.32%)**, not dead. Highest usage was Jab **6,626 (16.77%)**. Average damage/play: Uppercut **7.83**, Lead hook **6.83**, Cross **5.33**, Body hook **5.12**, Jab **3.09**; Block **1.12**, Pivot **0.93**. These are selection-biased contextual averages, not causal card strengths or bout-win rates.

No fight card is demonstrated universally dominated: Cross trades slightly more raw damage for worse matchups than Lead hook; Block has better guard than Slip but less counter damage; Pivot has broad favorable matchups but costs 5 and barely hurts. Roll is weaker at outside range but answers Body hook. Cheap defence can earn safe points, conserve wind or deny a big shot. Conversely, no single-card priority proved competitive with contextual play.

**Actually useless or misleading pieces:** the Gloves high punch-penalty field is dead code; Study's reveal is dead at full scouting; Change the plan's opponent draw is dead; “work rate” has no meaningful action-count choice because both sides throw once every exchange, including footwork and holds. Speed is described as deciding the sharper counter/ties, but there is no Speed comparison resolving initiative. Those are more urgent than deleting Block for low damage.

## Missing options

No Rest/Recover action during a round, no feint/delayed commitment, no deck removal/replacement, no explicit limited-use finisher, no referee/holding limit, no player adaptation model in the opponent, no multi-exchange setup beyond Jab, and no range-contest rule players can reliably infer from exchange wins. Do not add a second martial art to conceal these holes.

## THE ORDERED LIST — TO REACH 10/10

These are proposed experiments and acceptance criteria, not changes made or claims of proven balance.

1. **Make tactical promises true before tuning.** Fix `selfAhead` to compare damage dealt (or reverse current damage-taken comparison). Apply Gloves high's **×0.85 punch damage** next round. Give Change the plan **+2 choices to both sides** under the same draw rule. Disable Study at two known habits or substitute a free legal option. Add focused regression tests without removing existing checks. Replace README scouting numbers with a reproducible shipped-policy experiment.
2. **Turn scouting into an actual prediction decision.** Incorporate revealed conditional habits into the player-side AI estimate without inspecting the opponent hand; show the triggering condition and uncertain availability to humans. Make the opponent adapt from the player's last **3 cards**, so repeatedly choosing Uppercut/Slip has a price. Test tactical-vs-random improvement of at least **15 pp** over **10,000 seeded bouts** plus human comprehension tests; do not achieve it with hidden-hand cheating.
3. **Make “win,” “smother,” and positioning explicit.** Preserve chip only if the UI says **30% on a loss**. Restrict range movement to `w/W` (or define a separate movement contest): Cut off beats Step back; Pivot beats Cut off. Losing Jab should not grant a full setup: require `w/W/t` for its **+15%** next-punch setup. Add pair tests for losing Cut off versus Pivot and losing Clinch versus Jab, including stamina drain and range.
4. **Give the player a resource tempo choice.** Trial **Catch breath**: cost 0, restore **6 wind**, no counter damage, vulnerable to Body hook/Cut off; and **Feint**: cost **2**, no immediate damage, next punch **+10% accuracy**, cancelled by a clean opponent hit. Limit recovery to once per round initially. This creates an alternative to automatically spending wind every exchange; measure stalls and dominant recovery loops.
5. **Make camp construction, not deck inflation.** Keep four weeks, but let Double-jab drills replace up to **2** cards with Jabs; Right-hand work/Uppercut on the pads replace **1** card each. Offer one removal alongside each three-card menu and cap the deck at **16** for the trial. Run camp interventions by boxer/opponent, aiming for informed construction to outperform random picks rather than the observed reverse. Re-evaluate Roadwork's **+5 Stamina** against cost-rounding breakpoints.
6. **Create distinct corner plans with honest costs.** After fixing Gloves high, test **−1 Block cost / −15% punches** against **Breathe +16 wind / −35% first exchange**. Redesign Change the plan as “discard up to **2**, draw the same number, pay **3 wind**” symmetrically; make Study free when it cannot reveal anything, preferably unofferable. Target at least two contextually competitive choices in most offers, not one automatic heal or one dead reveal.
7. **Add counterplay to repeated holding and defensive scoring.** Trial referee warning after **2 consecutive Clinches**, then a point deduction on the third consecutive hold; reset on a non-Clinch. Separate punches landed from defensive contacts and attempts from footwork, so a 1-head Pivot is not the same landed-event category as a Cross. Rebalance Block/Slip only after measuring damage prevented, wind saved, and position, not average damage alone.
8. **Tune volatility after agency exists.** Separate RNG streams for hit, knockdown, shuffle and judging to enable clean paired experiments. Publish per-style and per-policy confidence intervals, round lead changes, score disagreements and outcome sensitivity to judge seeds. Trial lowering judge noise from **.10/.06/.14 to .05/.03/.07**, then compare blind human sessions; do not remove the drama merely to make bot tables prettier.
9. **Validate PLAY with humans, not just green checks.** Run at least **12 blind first-time sessions**, ask players to predict Slip–Cross, Cut off–Pivot, and smothered Clinch outcomes before resolution, and require **80% rule comprehension** plus a majority wanting an immediate rematch. Repeat with experienced players testing fixed priorities. Only award 8+ after decisions feel legible and varied; 10/10 needs that evidence, not more card art.

## Verification

Executed the required command unchanged: `node proto/cardgame/rules.test.mjs`.

**32 passed, 0 failed**

Exact final output line: `RESULT: PASS - all 32 checks green`.

The green suite establishes its checked invariants, not balance or semantic correctness of every description: it currently passes despite the scouting non-use, reversed ahead condition and unused punch penalty above.
