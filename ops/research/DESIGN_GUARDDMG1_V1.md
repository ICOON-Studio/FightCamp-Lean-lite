# GUARDDMG1 v1: damage through the guard (S500, 2026-11-16)

The owner: "the punches and the guards need real numbers for damage and reduction , the guard should negate the punches
damage , if not some damage goes through", then "Yes, design it" and "actually have critics to check the design and
improve it". This is a first draft for critics to check and improve. Every number marked (P) is PROVISIONAL: it is a
placeholder to be replaced by real-world evidence, not a decision.

## 0. What the game does today (from the code)
- A round is settled as exchanges. Each punch in it LANDS, is BLOCKED or MISSES. Only a landed punch does anything: it
  scores the exchange, marks a place on the body map (head, eyes, nose, left and right ribs), takes energy, can cause a
  hurt moment or a knockdown. A landed body shot also removes one slice from the top of the tank for the whole fight.
- A blocked punch and a missed punch do nothing to the boxer who defended. Blocking is free.
- The fight screen shows six bars a boxer: head, body, legs, stamina, guard, heart. The GUARD bar today only shows tired
  shoulders (the gloves sink as the shoulders burn). It protects nothing.
- A boxer's defence profile decides how a punch that does not land is stopped: block, slip, weave or pull.
- On screen a blocked punch is caught on the glove: the glove is knocked back, the boxer rocks, a block sounds.

## 1. The rules proposed
1. EVERY PUNCH HAS A DAMAGE NUMBER. Jab 1, power punch (cross, hook, uppercut) 2.5, big shot 4 (P). The puncher's power
   and the arm's tiredness scale it, as they already scale a landed punch.
2. A BLOCKED PUNCH LETS A SHARE THROUGH. Share through a fresh guard: jab 10 %, power 20 %, big 30 % (P). What goes
   through is real damage of the same kind as a landed punch, only smaller: head damage on a head punch, rib damage and
   energy on a body punch.
3. BLOCKING WEARS THE GUARD. Every blocked punch takes guard points: jab 1, power 3, big 5 of 100 (P). The guard bar is
   now this number (tired shoulders still lower it, as today). It comes back slowly while the boxer is not being hit, and
   by a fixed amount in the corner between rounds (P: 15 points, more with a good cutman or corner call).
4. A WORN GUARD LETS MORE THROUGH. The share through grows as the guard bar falls: at 50 guard the shares double, under
   20 the guard is BROKEN: half of every blocked punch goes through and one blocked punch in three counts as landed (P).
5. WHAT A BLOCK NEVER DOES: it never scores for the judges; it never causes a knockdown by itself. A hurt moment through
   the guard is possible only from a big shot on a broken guard.
6. SLIPS AND PULLS COST NOTHING TO THE GUARD but cost legs and energy (they already do in the tiredness rules) and fail
   more often when the legs are gone. So there are two ways to defend, each with its own price: cover up (guard wears,
   damage leaks) or move (legs and tank wear, nothing leaks).

## 2. What the player decides (the mechanic has to be played, not only watched)
- FIGHT PLAN, before the bout: a defence line for each phase of the fight: "cover up", "move your head", "step off".
  Covering saves the legs and wears the guard; moving saves the guard and wears the legs.
- CORNER CALL, between rounds: "Hands up" (guard comes back more, punches out drop), "Move, don't cover" (switch to
  slips and pulls for a round), "Go to the arms" (aim at his guard on purpose to break it: more blocked punches now,
  a broken guard in two rounds).
- TRAINING, in the week: shoulder endurance (the guard bar is longer and wears slower), defence skill (more slips
  succeed), and for the puncher heavy-bag power (more through the guard).
- THE OPPONENT'S FILE, from the tape: "covers up under pressure" (his guard can be broken), "light hitter" (your
  guard is safe to rely on), "heavy hands" (covering up against him is a slow loss).
- GLOVES (the gear idea already agreed for later): bigger gloves let less through and hit softer.

## 3. Every menu it appears on, and what each is wired to
| Menu | What shows | Wired to |
|---|---|---|
| Fight screen, the six bars | The guard bar is the real shield: it drops on a blocked punch, greys when broken | guard points, rule 3 |
| Fight screen, LANDED panel | A third count beside head and body: "on the guard" and how much got through | rules 2 and 4 |
| Fight screen, corner calls | "Hands up", "Move, don't cover", "Go to the arms" with their prices | section 2 |
| Result page | Punches caught on the guard, damage that got through, rounds with a broken guard | the bout record |
| Fight plan | The defence line per phase with its price in guard and legs | section 2 |
| Training | Shoulder endurance and defence skill say what they change in a fight | rules 3 and 6 |
| Opponent's file / tape room | The three reads above | the opponent's profile |
| Boxer's page | Guard endurance as a number the player can raise | rule 3 |

## 4. Risks I see
- A dominant pick: if covering is always cheaper than moving, or the other way, there is no choice. The two prices must
  cross over inside a normal fight.
- Fights get longer or shorter: leak damage adds damage to every round; the balance harness must hold knockdown and
  stoppage rates where they are.
- Too many numbers on the fight screen: one bar and one count, the rest on hover and on the result page.

## 5. Open questions
1. The real shares: how much of a punch's force reaches the head through a glove guard, and through the arms to the body?
2. Should a blocked punch tire the PUNCHER more than a landed one (hitting arms and elbows)?
3. Does the guard come back within a round, or only in the corner?
4. Amateur bouts are three rounds: is there time for a guard to break at all, or is this a pro-fight mechanic?
