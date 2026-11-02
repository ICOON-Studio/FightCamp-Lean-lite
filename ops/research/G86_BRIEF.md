# G86 - FEINTS: how often real fighters feint, what the other man does, and what it opens (Grok, research) - S68, 2026-09-24
Sent S68 2026-09-24 to https://grok.com/c/51ca5758-b573-4e8f-be45-a8347dd98a6a (Expert mode).

FightCamp is a combat-sports gym management game (Godot) whose fight engine simulates two fighters exchange by exchange.
Your own G73 mechanism audit (`research/G73_*.md` in the repo) ranked "feint -> reaction -> the shot the reaction
opens" as the #1 missing mechanism: today `boxing_feint` is a learnable catalogue node whose effect nobody spends, and
there is no opponent-reaction state at all. Before we build it, we need REAL numbers, so the engine is calibrated to
fights rather than to our guess. Research only - no code.

## The questions
1. **Feint RATE**: feints per minute (or per 100 exchanges) in pro boxing, kickboxing/Muay Thai and MMA - by style
   (pressure fighter vs counter-puncher), by round, and elite vs amateur where found. Say how it was counted (manual
   video coding, a tracking product, a thesis). If nobody has counted, say NOT FOUND and give the best proxy.
2. **REACTION RATE**: of feints thrown, what share draws a visible reaction (flinch, guard raise, slip, step back, counter
   attempt, level drop)? What kinds of reaction, in what shares? Sports-science deception literature counts: e.g. the
   feint effect on reaction time and error rate (Güldenpenning, Kunde, Weigelt; handball/basketball/fencing head-fake
   studies) - give the measured cost in ms and in errors, and say how far it transfers to striking.
3. **PAYOFF**: after a feint that drew a reaction, how much more often does the next strike land than an unset strike?
   Any coded data from boxing/MMA analysts (Lee Wylie, Jack Slack, Fightmetric/UFC Stats, CompuBox, academic
   performance-analysis papers in IJPAS / J Sports Sci)? What is the DECAY - does a fighter stop reacting to a feint
   that is never followed by a real shot, and how fast (tells, habituation)?
4. **COST**: what does a feint cost the feinter (time, stamina, getting countered on the feint, telegraphing)?
5. **HOW SHIPPED GAMES MODEL FEINTS** (EA UFC 3/4/5, Fight Night Champion, Undisputed, Tekken/SF cancel-feints):
   input, cost, what the AI does with it, and what players said about feint spam or feints being useless.
6. **WHAT THE ENGINE SHOULD GATE**: a table per discipline - feint rate band, reaction-rate band, landed-rate lift on the
   follow-up, decay - each figure with its source, NOT FOUND where there is none.

## Deliverable
ONE markdown document titled "G86 - FEINTS", sources inline, ending with one line saying what is still unknown. PASTE THE
WHOLE DOCUMENT IN THE CHAT as your reply (the operator cannot open files in your sandbox).
