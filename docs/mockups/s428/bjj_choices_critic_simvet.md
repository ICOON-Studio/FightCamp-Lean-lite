Seat: management-sim veteran (football manager, Boxing Manager, Two Point, roguelike deckbuilders). My 10/10 drawing: `docs/mockups/s428/bjj_choices_10_simvet.png` (source `bjj_choices_10_simvet.html`).

# BJJ live choices page: verdict

## Scores (0-10)

| | Score | One line |
|---|---|---|
| **Whole design, depth** | **4** | Nine names, about three real decisions. The "Right when" columns show the answers are lookups. |
| D1 Move call | 5 | The one real decision. Fixed duplicates and PAID_ONCE help. Odds-by-kind is still "pick the biggest %". |
| D2 Pace | 4 | Push is almost free (see economy), so it is "Push early, Work later". |
| D3 Referee's count | 5 | A good real-rules hook. Take the 1st penalty is dominant, then Show work. Rare (0-2). |
| D4 Points or finish | 4 | This is a D1 card with a label, not a new decision. Same token, same settle. |
| D5 Answer their best move | 3 | A free x0.8 when owned. Own it and pick it; don't own it and nothing happens. |
| D6 Back to the feet | 5 | Real risk and reward (miss = initiative lost). Also a D1 card from underneath. |
| D7 Caught deep | 4 | Fight it dominates, except on open days, which the page itself says need the carry-over built. |
| D8 The 2:30 word | 2 | Invisible effect (shifts a default pick), no price, no rival. |
| D9 The last minute | 4 | Strong clock maths (3 counts in 60 s), but it is a pace shout again. |
| Look | 4 | Only a chip list. No picture, nothing drawn for the card or the shout bar. |
| Clarity | 5 | Each option is explained, but the 2-shouts-a-minute rule is boxing's, reused. |
| What to do | 4 | Nine named asks, but the card tells you the answer ("Right when"). |
| Anticipation | 3 | Asks come on a timer, not from a build-up. Nothing to look forward to or dread. |
| Reward | 4 | Calls move the win chance by 3-10 in 100 spread over 9-11 asks, so about half a point each. Nobody feels it. |

## What is good
- The costs come from three different pots (a token, a shout, gas), and the page admits what is invented and what is real.
- The ref's count, Lute, advantages and the 2nd/3rd penalty ladder are good material. "Take a free 1st penalty when ahead" is a real, learnable play.
- The duplicate fix is right: one option per kind and landing. The kill list is honest.

## What is wrong, in order of damage

**1. The card solves itself.** Every table has a "Right when" column. If the game knows when each option is right, the player is reading the tutorial, not deciding. Boxing Manager and Football Manager give you the information (fatigue, opposition shape) and the price. They never print the answer. The 15-60% probe band for "best pick" is a good bar, but the visible "Right when" text defeats it. Show odds, costs and risks; hide the recommendation.

**2. The rival has no agency.** In boxing the opponent fights one way at a time (Pressing, Waiting to counter...) and that clue is what the corner reads. Here the only rival input is "has tried the same kind twice" (D5), a rear-view mirror. Without a live mode for the opponent there is nothing to read, so each decision is only about Ana's own state. Linked decisions with real rivals need a rival state that changes the ranking of the options.

**3. The shout economy is not an economy.** Shouts are free apart from "two a minute". The scheduler already spaces asks at most 30 s apart and never repeats, so you can never reach the cap. The cap does not bind, and a third shout "at half" never happens. Result: shouts have no opportunity cost, so there is nothing to ration. The 4 tokens are the only real scarcity.

**4. Tokens are first-come.** D1, D4 and D6 all spend a token, and a 5:00 bout offers about 5-9 such cards for 4 tokens. The player is spending the pot on whatever asks first, with no way to save one for a better moment, unless skipping is free and clearly shown. The best decision in the page ("hold a token for the last minute") is not written down.

**5. D1 + D4 + D6 are one decision in three coats.** All three are "a heavy settle, pick among 2-3 moves". D4 is the same card with a sub on it, D6 the same card from underneath. Three names make the page look nine-deep. Real count: move card (D1/4/6), pace/orders (D2/8/9), crisis cards (D3/5/7). Merge them and make each layer deep.

**6. D2, D8, D9 are three pace dials.** Push, "Go get the finish", "Everything on it" all push odds and gas toward sub-hunting. D8's effect ("shifts the default pick") is invisible, so the player cannot learn it or tell it worked.

**7. Filler by design.** "D2 pace is always eligible, so a quiet stretch can always be filled" is a decision manufactured to meet a 30 s quota. A veteran sees that at once. Silence is fine in a match if the screen tells you why and when the next moment is coming. The quiet is where anticipation lives.

**8. Effect size.** 3-10 in 100 over 9-11 asks. The game's own design rule is that a good plan is worth about 14 points in boxing. Live orders should be 8-15 combined. At the moment I could ignore the corner and not notice.

**9. D7 has no stakes in one match.** Tap = lose now. Fight = escape 30-70% and, if it fails, you lose anyway (plus an injury roll). Fight dominates unless there is a next round. The page says so itself ("this needs the carry-over built, or it is weak"). Treat that as a prerequisite, not a footnote.

## Economy and degenerate play
- **Always Push early.** Gas x1.4 on a drain that the S390 patch already made light (0.015 a move, 0.025 a miss, so about 0.4 over 5:00). Push costs about 0.15 gas for +0.04 odds and 60% grips. Take it from 0:00, drop to Work under 0.5. A strategy, not a choice.
- **Always "Hold and breathe" in mount or back.** Free gas, no stall. It is only wrong if sitting there loses points, which the card does not price.
- **Always take the 1st penalty when ahead** (free), then Show work. Fine as learning, but it is solved after one match.
- **Always name an owned answer** (D5). The other two options only win in narrow cases.
- **Always fight a choke.** See 9.
- **Nobody takes**: "Slow it down" (it starts a 20 s count outside exempt spots), "Let it come", "Tie up and breathe" (also starts the count), "Set it up" (+0.06 for a delay). These are traps, not choices. Cut or give each a real upside.
- **Shouts when gassed land at half** while tokens still work: the hurt fighter is worse off in both pots at once. Spiral, not choice. Better: gas hurts the options on the card (fewer, riskier), not the shout power.
- **Tokens never recover.** One back on a landed read would make reading the rival pay.

## One 5:00 bout, ask by ask

- 0:00-0:20 standing. D2 pace. Answer: Push. Nothing else to do. No opening decision (pull guard or wrestle) exists, the best first choice in real no-gi.
- 0:30 D1 settle. Three arrows, "Right when" tells you. Pick. Token 1.
- 1:00 D2 again (after a score change). Probably leave Push. Filler.
- 1:20 D1. Possibly same shape as the last. Token 2.
- 1:50 D6 (she is underneath). A real one if the stand-up odds are close to the sweep odds. Token 3.
- 2:30 D8 the word. Pick the one matching the score. No cost, no visible effect. Nothing to do.
- 2:50 D5 (habit). Owned: Name it. Done.
- 3:15 D3 (count). 1st penalty: take it. Done.
- 3:40 D4. Same as D1 with a sub. Token 4, last.
- 4:00 D9. Based on the score: "Ride it out" or "Everything on it". Obvious.
- 4:30 D7 if the opponent rolls a near miss: Fight it.
- 4:50 nothing.

Nothing to do: 0:20-0:30, 1:30-1:50, 3:50-4:00, 4:30-5:00 after any of the above. The answer is always the same at: every D2 ask, D8, D3's first penalty, D5, D7 on a single match. The real choices are three: D1 at 0:30, D6 at 1:50, D4 at 3:40. That is what I call depth 4.

## Compared with other games
- **Boxing Manager**: a handful of persistent orders (style, aggression, go-for-the-KO), a visible stamina/damage read on both men, a few corner interventions between rounds. Few inputs, each big, each readable, each with a visible cost. Your design has more inputs and smaller, hidden effects.
- **Football Manager**: the player sees the opposition's shape and the match stats, then picks a mentality, shouts, and subs. Shouts have a visible response (the team's mood icon), and a sub is a one-time resource. Your tokens are the sub, the shouts are the shouts, but the response is never shown live.
- **Roguelike deckbuilders** (Slay the Spire): a hand of 3-5 cards, an energy pool, and the enemy's *intent* shown above its head. The enemy intent is the thing that makes every hand a puzzle. This page needs its intent icon (the "tell" in my drawing).
- **Two Point**: the loop is readable because every number has a place on screen and every action shows its result. The Why after the bout is that, but live results are not stamped.

## To reach 10/10 (most important first)

1. **Give the rival a visible mode and make it rank the options.** One clue line, like the boxing opponent mode ("settling her weight, hunting the neck"), plus the habit chip and her gas word. Every card's best option must depend on it. This is the link between D1, D5, D7 and D2. Without it nothing else matters.
2. **Stop printing "Right when".** Show odds, gas, the miss cost and the rival's answer rate on each option. Keep the "right when" logic for the probe (15-60% best-pick), and for the Why.
3. **Collapse nine into three layers.** (a) ORDERS: Survive / Points / Finish, one persistent dial replacing D2, D8 and D9; (b) the MOVE CARD: D1+D4+D6 as one card with 2-3 arrows of different kinds, a 6-8 s timer, and "skip" free; (c) CRISIS CARDS: D3, D5, D7 only when the thing really happens. Fewer, bigger.
4. **Make the budget real.** 4 tokens shown as coins, skip is free and shown, +1 token back when a read lands. Shouts: charge a visible cooldown (each shout locks that shout for 30-40 s) instead of the unreachable two-a-minute cap. Gassed means fewer or riskier arrows on the card, not weaker shouts.
5. **Make cost bite.** A Push that costs a real gas cliff (under 0.35 = tunnel vision, in the drawing), a visible rival gas bar to push against, and hold/tie-up carrying a stated price (the ref's count). Kill or buff the options nobody takes (Slow it down, Set it up, Let it come).
6. **Drop the scheduler filler.** No ask unless a real situation exists. Replace the quiet with a signposted "a tell is coming" marker on the timeline (the "?" in my drawing) so waiting is anticipation. Keep a minimum of one real moment per 40 s from the rival's own behaviour.
7. **Stamp every result live.** LANDS / MISSED / READ RIGHT / READ WRONG on the card, the log and a live trust meter, not only in the Why. That is the reward loop. Raise the combined effect to 8-15 win points.
8. **Add the missing options:** an opening choice (pull guard or wrestle for the takedown); a grip lead (who wins the hand-fight); an "ask the ref to restart" / go-out-of-bounds exit once ahead near the end; a scout-based answer shown before the bell (camp link).
9. **Give D7 its stakes before building it:** open-day gas carry-over, injury weeks and the next bracket round, with a "must win now" flag on a single match. Otherwise cut D7 for single bouts.
10. **Build order:** probe first as the page says, but add two bars: no option is the best pick under 15% or over 60%, and a "do nothing" bot (ignores all asks) must lose by 8+ win points to the best-play bot.

Drawing: `docs/mockups/s428/bjj_choices_10_simvet.png`. It shows the score plate with advantages, penalties and a count ring, the rival's gas and tell, the card with costs but no recommendation, the orders dial, shouts with cooldowns, live result lines, and a timeline with used cards and "tell coming" markers.
