# The menus refined against Corner King (S401)

Operator, board Q-S294-125: "compare the structure to corner king and have ritics review it and refine it".
Input: CORNER_KING_COMPARE_S401.md. Three independent critics (sonnet sub-agents), not blind to which game is which: UX lead, a player
who knows the genre, a producer. None played Corner King: it was judged from our read-only notes. Stills for several fight-night screens
were not available to them, so "we are ahead there" is unproven by this round.

| Critic | Draft structure | Corner King | One line |
|---|---|---|---|
| UX lead | 6 | 6 | The spine is right; Home and the Fights flow do not pay it off yet |
| Player | 6.5 (first month 8, long arc 4) | 7 | "Yes, as a second game": 20 weeks in a night, then out of "next" |
| Producer | "mostly parity-chasing" | - | Only Ask for a fight, the two-fighter coach, camp risk and cheap fight-night reasons add to the pitch |

## What the critics got wrong (checked against the code and his answers)
- Producer and UX asked for autosave, Settings and Handbook: built in S396. Title shows Resume/Load when a save exists (their capture had none).
- Producer treated career length as open: he answered Q-S294-113 "Yes, open-ended", so World and Grow are NOT "as is for Early Access". The world
  that keeps running is the biggest missing job, and it is what the player missed most.
- BJJ: he answered Q-S294-115 "No, launch together"; the producer's "ships in the first update" does not apply.

## What all three agree on
Five rail buttons, one home per job, no mailbox. Protect the Playbook and the interview. Ask for a fight with a reason when refused. The big button says what it
stops for. Never: 17 sections, email as the decision pipe, directories, chat threads, press scenes, face creator, day-by-day clicking.

## The rule-breaks they found in our own build (fix first; no new design needed)
1. The week review pops up by itself: it breaks "nothing opens by itself". It becomes the Monday state of Home.
2. The guide strip ("First week 1/2/3/4", "Three jobs") still sits on every page at week 20: a fifth voice. Home only, gone after the first week.
3. The offer dead end, "That offer is gone": an expired offer closes itself and clears its flag.
4. A booked fight is one Home card with a countdown, then camp, weigh-in and tape in a straight line.
5. The needs flag text is cut off ("Answer a bout offer: Lucy Jackson vs ..."): say what is needed and open it from the flag.
6. Playbook's right pane is empty until a hover: it plays a default. The Week's pad cards sit below the fold: move them beside the goal line.

## The 14 menus, refined
| # | Menu | Verdict | What changes |
|---|---|---|---|
| 1 | Home | CHANGE | The Monday page, one next action, a fight-day state with a countdown. A line under the big button says what will stop time. Her polaroid, the whiteboard look |
| 2 | Start | CHANGE, small | Keep the coach edge. Two or three named starts that are the difficulty, each stating cash, members, fighters |
| 3 | First week | KEEP | Her polaroid card. Show the chance she says yes as a percentage. The first hire: 2-3 coaches side by side. A short checklist on Home for the first hour only |
| 4 | Fighters | KEEP | With one fighter it opens her page. Never a directory |
| 5 | Fighter page | CHANGE | Week: real whiteboard, pads beside the goal line. History: every bout with its Why, and a progress chart. Big portrait |
| 6 | Playbook | KEEP | Three tabs: Moves (Escapes folded in, unlock path as a goal), Game plan on a drawn board, Combos as is. Default play in the pane. More consequences in the fight |
| 7 | Fights | CHANGE | One page: offers, ASK FOR A FIGHT (level, date window, a refusal gives its reason), dated list, results with their Why |
| 8 | Fight prep | CHANGE | Camp lives only on her Fight prep tab. Risk shown per camp choice. Weigh-in one real screen. "Let the coach plan it" comes later, for long saves |
| 9 | Fight night | KEEP the flow | Skip walkout and break, fight speed. After the Why, one concrete change for next time, carried into the plan: the loop to chase. Money under the Why |
| 10 | Money | KEEP content, concept v4 look | Make the pressure felt: tighter money earlier. Sponsor line and per-fighter costs wait until there are 3+ fighters |
| 11 | People + Records | CHANGE | Staff cards with faces, a members panel (who joined, who left, why). No chat, no "wants" system |
| 12 | World | CHANGE, bigger | The open-ended world: rivals who develop, rankings that move. Today it is 8 rows. News cut to what touches you |
| 13 | Top bar | CHANGE | Mail goes. Menu opens under its button. The date opens Simulate to the next stop |
| 14 | Grow | CHANGE, bigger | The second fighter arrives by week 8-10 with a real clash: one coach, two camps. Prospects have a deadline. A rival gym comes for your fighter (after the world exists) |

## Where they disagreed, and my call
- **Rival gym raids:** player's number 1, UX and producer say later. Call: the need is real and open-ended makes it bigger, but it needs the running world first. It goes straight after that, not at the end.
- **Coach pairing:** producer says build now; player says a fit number of 0.88-1.12 is felt as nothing. Call: build it as scarcity, "two fighters, one coach: who gets the pads", not as a fit score.
- **Named starts:** UX calls it taste. Call: small and it gives replay; keep it.

## Build order proposed
A. The six rule-breaks above, on today's screens where they do not depend on a menu you have not approved.
B. Fight-night depth: skips, scorecards, readable reasons, wrong call costs trust (CORNERTRUST1, in progress), the one change after the Why.
C. Decisions: camp risk per choice; two fighters, one coach; Ask for a fight (first prove by bot test that a smart ask beats a plain one); named starts.
D. Simulate to the next stop. Home rebuilt once B and C exist to put on it.
E. The open-ended world: rivals who train and age, a ladder that moves, then the rival gym that comes for your fighter.
F. Five strangers play it: 3 of 5 keep playing and can say why a fight went as it did.
Then: progress chart polish, sponsor line, world sorted by closeness.

## Risks the producer named, for the record
Corner King can add a Why text screen in one update: our real moat is plan authoring and true causes. Fighters must look and fight differently before launch. A first fight should arrive by about minute 25
and look acceptable (Steam refunds under 2 hours). They ship 6 languages, we ship 1. The whiteboard fonts need text scale. No demo or wishlist plan is written yet.
