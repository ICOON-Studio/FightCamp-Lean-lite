# BUILD1 critic: Kalli (fresh, game design) - S570
Seat: Kalli (Grok bot), brief ops/research/BUILD1_CRITIC_BRIEF_KALLI.md (the critic pack's first part + the fight page + the
whole DESIGN_BUILD1.md at commit 4ecd137). Answer copied from the bot's thread unchanged (seq 1889, 1892, 1894); the 10/10
page is BUILD1_CRITIC_KALLI_10.html (rendered: BUILD1_CRITIC_KALLI_10.png), with the bot's own two fixes applied.

**Verdict: it doesn't stay yet.** Mapping the body to the ship is the right spine, because for the first time a week in the gym changes what the player can press in the next bout. But neither bar is met. The pools don't pay off in v1 or v2, there are dead cards, and the one new idea, "his punches take your cards away", hasn't been measured or even fully designed.

| Score | /10 | Why |
|---|---|---|
| DEPTH | 6 | The builds really do play differently (plan-mix distance 0.7 to 1.3 against 0.1 to 0.2 in mirrors). But putting points into defence wins 19% in v1, an even spread beats every choice in v2, the pressure fighter's lead hook gets 0 to 3% of beats, and the overhand gets 0 to 1%. |
| PLAY | 6 | Drafting a fighter and then fighting with that body is a strong hook. Losing cards to a hurt part has the same shape as the health-to-stamina link the page itself threw out for halving comebacks (25% down to 11%). |
| GENERAL | 5 | Several words clash. "Core" means both the trunk and the engine. "Legs" here is "Feet" on the fight strip. Chin lives in two places (Head passives and the Defence pool). "Generalist" isn't one of the game's six styles. And the three pools are a fourth layer that the agreed 10 attributes never feed. |
| SPEED | 6 | A beat today means four picks (lead, rear, feet, order). Combining two cards adds a drag. Seconds per beat: NOT COMPUTED. Building in camp happens once per camp and is fine. |
| FIRST FIVE MINUTES | 4 | Before the first bout a new player meets five parts, slots, three pools, two thresholds, a combination table and flows. In five minutes they get to "my coach built this" and not much further. |

**Missing options:** a preview of the result before you commit a slot (Breachway shows its combined result, and this design dropped that), an undo or reset for the build, a line explaining why a card is greyed, and a view of the opponent's build before the bout. **Useless:** the Head passive slots (Defence already owns the chin) and the flow list (it isn't measured and only repeats what the order of moments already does).

**From my own bouts (five losses against five agents):** feint then cross decided every one of them. Against Ziva today it landed three times for 12 health. Today that combination is free to everyone. This design is the first fix for it: make feint and cross one combined card that takes a slot, so only a build that pays for it owns it. Keep that and say so on the page.

**To reach 10/10: DEPTH**
1. Make the pools pay in kind, as round 3 proposes, then measure it against the page's own bar: each choice wins 35 to 65% against an even spread. If the even spread still wins, raise the Attack 60 threshold to 65 so that spreading misses it.
2. Run every cell at 200 bouts or more. At n=36, a 53/47 result is about 16 points either way, so the 35 to 65% cross-match bar can't be judged.
3. Fix the dead cards before adding any. Give the pressure build the one body-then-head card in place of the lead hook. Let the overhand cost 2 when Attack is 75 or more, so it leaves stamina for the feet.
4. Turn "protect the part" into a choice by letting a held hand guard a part, not just a line. For example, the lead hand held low protects the Core cards this beat. Then guarding is a decision about cards, not only about health.

**To reach 10/10: PLAY**
1. Make a hurt part cost one card for the next beat only, not for the round, and measure comebacks with it at 20% or more before anything else ships.
2. Let the player hurt his parts too, and show which of his cards a body shot would take before you throw it.
3. Make the combined feint and cross a slot card, take it out of the free base cards, and give it a cost he can see: the lead hand is open in the moment after.

**To reach 10/10: GENERAL**
1. Use one word per concept: Feet (as on the fight strip), Trunk for the body part, and Engine for conditioning.
2. Cut the Head part. The chin belongs to Defence, which leaves four parts: Lead, Rear, Feet, Trunk.
3. Show which agreed attributes feed each pool: Conditioning from Stamina and Durability, Attack from Strength, Explosiveness and Speed, Defence from Defence skill and Composure. The design page has to state this split before anything is built.
4. Swap Generalist for Boxer-puncher, one of the six styles the game already uses.

**To reach 10/10: SPEED**
1. Pre-fill each beat with last beat's choice, so a beat where nothing changes is one click and the target is 8 seconds or less.
2. A combined card is one card in the hand, not something you drag together during the bout. You join cards in camp, never in the fight.
3. Order the moments automatically by speed, and let the player change the order only by dragging.

**To reach 10/10: FIRST FIVE MINUTES**
1. The first bout uses the style's ready-made build with only the base cards and one discipline card. Show the pools as three numbers with no thresholds.
2. Open one new thing per bout: slots after bout 1, thresholds after bout 2, combining cards after bout 3.
3. One line under each greyed card explains it, such as "Trunk hurt: clinch away next beat."

My 10/10 camp screen comes next.

Two fixes for the page before anyone renders it. Delete the stray `background:#6b7witness` in the `.fill` rule; the inline colours already override it. And in the TRUNK group of the bout strip, change the label `hurt` to `0 cards` and the line under it to "Learn the clinch in camp to hold a trunk card." A card she never learned can't be the one a hurt part takes away.
