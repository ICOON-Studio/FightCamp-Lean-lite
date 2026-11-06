# Dominus Gladiatus: the fatigue loop and RPG layer (S390, 2026-11-06)

Operator: "this simple loop to watch and rest plus few other things your fighters felt satisfying ... find all this with rea and see if they can help us".
Read-only inspection of the installed files (REA metadata, the assembly's IL, the data assets). The game was not run; his save was not touched. Notes in our own words.
Dumps stay outside the repo: E:/FightCamp/tmp/s390/dominus. Follows ops/research/DOMINUS_STUDY_S389.md, which saw days 1-3 only.
Their numbers explain pacing. They are not a baseline for ours (real-world benchmarks stay the rule).

## The loop, as the code runs it
One small meter per fighter, 0 to 1, plus a fatigue count 0-5.
| Fighter is | Meter | Result |
| --- | --- | --- |
| Training | Fills in 2 days | Full: +1 fatigue, meter resets |
| Doing nothing | Drains in 2 days | Empty: -1 fatigue |
| In the dorm | Own timer, 0.5 days a point | 4x faster than idle; a morale lift too |
| Working outside | Frozen | Neither |

A day is 9 real seconds. Talent can speed rest. Fights add fatigue: 1 for a medium beating, 2 for a critical one (1 on easy).

What fatigue does: arena health penalty 0 / 0 / 0 / 5% / 10% / 20% at 0-5. Arena injury risk is 10% per point (the tutorial says from 3). **Each point past 5 is a certain injury plus a morale hit.**
Operator's memory was right on 3; at 5 the real rule is harsher than "big chance": going over is guaranteed.

Pick a skill once and it fills by itself. Speed adds up: +20% in the training ground's bonus slot, +100% from the trainer's boost for 2 days (charges, 5-day cooldown), talent, high-morale state; a head injury takes 10/20/30% off.
Fights teach too: +10% of a skill on a win, **+15% on a loss**.

The clock stops by itself on: a skill finishing (a setting), returning from the arena (a setting), events.

## Why it feels good: the arithmetic
Train from fresh: fatigue 3 at 54 s, 5 at 90 s. A dorm empties 5 points in about 22 s; idle takes 90 s.
So one fighter wants a decision about every 90 s, and with 7 staggered that is **one small decision every 13 s or so**, each one a click, each visible on the fighter before it bites.
Train 90 s and dorm 22 s is about 80% training time; train and idle is 50%. The dorm visibly pays. Nothing is hidden: the risk sits on the fighter's head.
It is one verb per fighter, not a plan.

## RPG layer, from data
- Rolled per fighter at purchase: health (85/100/115), temperament (Stoic, Balanced, Hot-Blooded: changes the morale ceiling), starting talent (4 kinds), morale, freedom goal (12-16 wins).
- Morale 0-5 in five named bands. High rolls good states (faster training, a fight damage boost, inspiring others). Low rolls trouble (refuses to train, refuses to fight, theft, spreading fear), each a two-choice card.
- Injuries hit one body part with one meaning: head slows training, arm cuts damage, torso cuts health, 10/20/30%. Three of a kind become permanent.
- At 7 wins a fighter becomes a veteran and you pick health or damage: a small, memorable choice.
- Fight offers come in four kinds: favourable, balanced, dangerous, trap; strength 0.8-1.4x, pay 0.8-1.6x. A trap hides its nature half the time.
- Cost of a long list: 13 morale modifiers, 7 fatigue modifiers, but the player only ever sees two pips.

NOT established: exact skill training times and talent ranks (those records did not decode cleanly), chances of morale events, whether the trait classes (Heroic, Cowardly and others) ship: they have code but no display text was found. Injury risk's "from 3" comes from the tutorial text, the x10 from the code.

## How it is actually played (operator, with two screenshots; this corrects a card-board wireframe)
The screen is the yard: fighters always in view unless in a special room, a training bar over each head, skulls at their feet, "!" over whoever waits. The player pauses and unpauses constantly: pause, click a fighter, Skills tab, pick a skill card, back to the yard, unpause, watch the bar and skulls fill. When a skill finishes the fighter can simply be left idle until the skulls drop.
Everything is managed against the next fight day, counted down on the arena icon top left: there must be enough fighters who are not tired that day.
Code confirms: any open screen stops the clock; Space pauses, holding a key runs 2x; a fighter is dragged into a slot.
For us the yard is the gym floor we already have. That makes the floor, not an office, the candidate for Home.

## Against ours
We already have the depth: fatigue 0-100 with a real decay (keeps 87% a night), overreached at 80, heavy legs at 50, a 7-day AM/PM plan, a forecast. What we lack is the feel.
| | Dominus | FightCamp |
| --- | --- | --- |
| Input | One skill per fighter, once | 14 slots a week per fighter |
| Feedback | Pips on the fighter, moving | A forecast, then a week review |
| Rest | A place you send them, visibly worth it | A session type in a plan |
| Threshold | Two, memorable: 3 and 5 | 50 and 80 of 100, in a gauge |
| Decisions at 7 fighters | Small, spread out | One big planning job each |

## Verdict (Claude)
TAKE
1. Fatigue as five pips on every fighter, everywhere. Our 0-100 stays underneath; 3 pips = 50, 5 = 80. Display only, cheap, do first.
2. Two plain rules a player can recite: 3 costs you in the fight, past 5 injures. Ours already has the first; the second is new and needs balancing with InjuryRoll.
3. Rest as a place: a recovery room in the gym (physio, sauna) that is clearly faster than doing nothing. Fits the rooms we draw.
4. Focus: one skill per fighter, running until you change it. The week plan stays for fight camps. This fixes the one thing PLAYER_PATH leaves open: seven fighters must not mean seven plans.
5. Losses teach more than wins. One line of rules, and it softens the worst moment in the game.
6. Fight offers with a risk kind, including a trap that may hide. Goes straight into C237.
7. Per-fighter rolls: temperament, one talent, a career goal; a veteran-style pick at a milestone. Goes into C238.
8. Injuries that each mean one thing. We have types; give each one plain effect.

CHANGE MY S389 CALL
"Real-time days: do not take" was written from three days of play. The operator's experience of this loop is better evidence. Proposal: keep the Monday stop, but let the days between run visibly with pause, pips moving, one click to pull a fighter to rest. A week of about 30-60 s. Test it on a plain wireframe before building: it touches the clock, PLAYER_PATH section 7 and the week flow.

DO NOT TAKE
- Whipping and suicide. Wrong tone for a gym, and a Steam risk. The honest version: "push through" (more fatigue, others' morale drops) and a fighter who quits.
- Their numbers, names, art or words.
- A morale event deck before the base loop works. Two or three cards first.

## Wireframe (S390)
Playable, no art: https://claude.ai/artifact/GKE5w2WLJBTeW3gBKLf5QA. Simulated, 1,500 seasons a style, 26 weeks, goal 38 wins: nobody trains 13.1 wins, cash -3,980; always trains 28-31 wins, 21-23 injuries, bankrupt; a fixed ritual of bedding the two most tired 2 days out 39.7 wins, 5.9 injuries; aims skills at the opponent's weakness and reads the risk 43.3 wins, 0 injuries.
These are bots, not fun. Blind critic: 3/10 and 5/10 on the card version, 4/10 on the first scene version; the final version is not re-scored. Its open points: Recovery was barely a decision, and a fixed ritual came close to good play.
Design changes it implies, none decided: one shared fight day instead of per-fighter bookings; the gym floor as Home; one skill at a time instead of the week plan outside camps.
