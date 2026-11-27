# Mixed Martial Cards (demo) - Claude's playtest: tutorial + a match (S569)

Owner S569: "i want to you to playtest mmc in the background play at least the tutorial and a match , for ideas ,balance,
ui,hud, general structure". Played on the hidden desktop, muted, through the Electron debug port (a script that reads the
screen text and clicks like a careful beginner: head attack -> head block, body attack -> body block, its own turn -> the
cheapest attack, every 2nd-3rd attack a feint). His save folders were backed up first (scratchpad mmc_save_backup) and
are put back after. Notes in our words; nothing of theirs copied into the project.

## What the tutorial teaches (in order)
1. Defend first: the coach attacks, you answer with a block card that names its line (head or body). Two basic blocks
   (head / body) come back to the hand every turn - you always have an answer, never a dead hand.
2. Then you attack: drag (or click) an attack card into the ring, then pick its MODE in a panel of three, each with one
   line of effect: Normal; Full power (double damage, +50% stamina; countered = you take double and are dazed); Feint
   (costs 1; if he defends or counters it he is Off rhythm).
3. "Straightforward attacks don't usually do much": the lesson of the whole game is feint first, then hit hard while he
   is Off rhythm ("Feints are the best way to land big UNDEFENDED hits").
4. Initiative: three ways to get it - block or counter his attack, call his feint (do not bite), or he passes.
5. Tutorial arc as a checklist on a clipboard in the corner: learn basics from Coach -> training arc -> license test ->
   first MMA fight.

## HUD and UI (seen on screen)
- Top: each fighter's name and three thin bars with icons (heart = health, a pink "brain" bar, lightning = stamina),
  numbers at the ends. Nothing else across the top.
- Centre: an empty 3D ring (no fighters drawn); the active card sits large on its owner's side ("Your attack" left,
  "Incoming attack" right), the answer card on the other.
- Prompt panel at the top of the ring says the PHASE in words: "React to the opponents attack - Play a defend or counter
  card. If opponent feinted, you become Off rhythm" / "You initiate! Choose action".
- Status banner over the bars when it matters: "OFF RHYTHM! Can't react".
- The game hints the right play: after a successful feint the Full power option GLOWS.
- Hand at the bottom: large cards with art, cost in the corner (lightning), name, one line of effect.
- Left rail: Tutorials, Event log, Settings. A clock and "Click to skip tutorial" bottom-left.

## Balance and structure notes (so far)
- A clear risk ladder on every attack: feint (cheap, wins the read) -> full power (double, punished double).
- Defence never runs out (two free basic blocks); the depth is in WHEN to spend the real defence/counter cards.
- The feint is self-policing: biting costs you your next reaction (Off rhythm); calling it costs him the initiative.

## Structure seen across the campaign
- Main menu: an online monthly championship banner (double-elimination bracket), PLAY / SPECTATE / PROGRESS. The PLAY
  screen itself says "Multiplayer is the recommended way to play MMC - mind games are more interesting with humans than
  bots".
- Campaign: a short chain of bouts (training: basics, training: counters and leg kicks, the MMA license test, bout 4 =
  a boss fight), each marked won / up next / new unlock; a checklist on a clipboard tracks the story beats (learn the
  basics, spar with Chris, clobber Steve, pass the license test, first MMA fight).
- Before a bout: CHOOSE DECK - three starter decks that are STYLES with a plan written on them (Combo: attacks get
  cheaper and stronger the longer the exchange; Leg Decimator: build 6+ leg injuries and he breaks down; Kickboxer: kicks
  cheaper and gain combo after a punch) + "create a new deck".
- Pre-bout talk choices with the opponent (polite / bump fists / trash talk) and rest-time talk with the coach.
- In the bout: rounds with REST TIME between them; the coach shouts advice during play ("go for the body, then
  upstairs. Watch how he covers up!").

## Mechanics seen in play
- The TURN = one attack card + one defence card. The EXCHANGE = turns until the initiator chooses END EXCHANGE ("both
  players draw cards, opponent gets initiative, reset costs") - every attack in an exchange costs more (+0, +1, +3 ... a
  calf kick reached 13 stamina): long exchanges get expensive, so you choose when to stop.
- Modes on every attack: Normal / Full power / Feint; the game greys out modes the lesson does not allow.
- Reaction: a fitting defence card, a counter (some only against non-long-range attacks), a dodge of a body part (Avoid a
  leg kick), or CALL FEINT - which is also how you take a hit you cannot answer.
- The SURPRISE window: "Last chance to play special cards and alter the outcome" - special cards fire on a condition
  ("Play when the opponent blocks a feint hook to the body" -> hook to the head instead), then CONTINUE TO RESOLUTION.
- Statuses shown as icons beside the bars: injured legs (a count), Cripple (attacks cost +1 until the rest), Off rhythm
  (cannot react), Wide open (cannot defend after a failed counter), Unguarded, Out of (a resource), Dazed (full power
  countered).
- Combo tag: keep the initiative unless you take damage; Injure Body / Injure Legs: permanent extra loss on that part.

## The matches played
The full tutorial (defend, attack, feint, initiative, counters and leg kicks), a spar with Chris, a spar with Steve, and
most of the MMA license test against the Tough-looking Kid with the Kickboxer deck (round 2, rest-time strategy picked,
me 77 health v his 51 when the script stumbled into the replay viewer; one bout replays as 11:30 long). Not reached:
the boss bout, the grappling deck (takedowns, ground, submissions) and a full points decision - the demo's campaign
gates them behind the license test. Saves restored to his state after (0 differences from the backup).

## Rating (Claude, after the tutorial and three bouts)
| | score | why |
|---|---|---|
| Ideas / structure | 8 | initiative + the exchange that gets dearer + three modes + three answer windows is one coherent loop; style decks with the plan written on them; a strategy pick at each rest |
| Depth | 7 | reading feints, choosing when to end an exchange, stacking injuries; the game itself says bots make the mind games thin ("multiplayer is the recommended way to play") |
| Balance | 6 | long-range leg kicks with no leg dodge in hand cannot be answered - calf kicks crippled me (Cripple: +1 cost on every attack) and took me to 0 in a spar; the cost climb caps long exchanges well |
| UI / HUD | 6 | good: three thin bars with icons, status badges with counts beside them, a phase panel that says what to do in words, the right option glows; bad: the ring centre is EMPTY, a 10-card hand overlaps, hover tooltips cover the panel, the pink bar is never explained |
| Speed | 5 | a turn is up to five steps (card, mode, the surprise window, continue to resolution, the answer); one bout about 11 minutes |
| First five minutes | 7 | a coach voice teaches one idea a lesson and greys out what you may not do yet - clear, but slow and very scripted |
| **Overall** | **7** | the best rules structure of the fight-card games we have read; the presentation and the click count hold it back |

### To reach 10/10 (most important first)
1. Show the fight: the empty ring should play the exchange (two fighters), not just cards sliding in.
2. Cut the clicks: skip the surprise window when no special card can be played; auto-continue to resolution.
3. A smaller, sorted hand (attacks / defences / specials) instead of an overlapping fan; tooltips beside, never over.
4. Give every long-range attack a cheap answer in every starter deck (a step back, a check) - no hit you cannot answer.
5. Name every bar and status in one line the first time it appears (the pink bar).
6. Bots that read: feint against a man who blocks a lot, call feints against a man who feints a lot.

## What Puncher's chance could take (and what not)
TAKE
- THE EXCHANGE THAT GETS DEARER: every extra action in the same exchange costs more; ending it resets the costs and hands
  the lead over. A natural cap on loops like our feint-then-overhand loop, and a decision every beat (keep going or stop).
- ONE CARD + A MODE (normal / full power / feint), each mode one line on screen - already in RULES569 R2.
- STYLE DECKS WITH THE PLAN WRITTEN ON THEM ("build 6+ leg injuries and he breaks down"): our fighters' styles could
  read the same way on the hire and fight screens.
- THE REST AS A PLAN PICK (one strategy of two, active until the next rest) - CARDREF1 said so for the corner minute.
- STATUS BADGES BESIDE THE BARS WITH A COUNT, and the phase panel that says in words what to do now.
- CALL FEINT doubles as "take it": no empty "pass" button.
DO NOT TAKE
- The empty ring (our picture cards and strip already show the fighters).
- Five steps a turn; a 10-card overlapping hand; tooltips over the panel.
- Attacks a starter hand cannot answer at all.

