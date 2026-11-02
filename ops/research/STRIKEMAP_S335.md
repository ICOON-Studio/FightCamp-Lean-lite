# STRIKEMAP_S335 - the boxing version of the GrappleMap browser, and the coach's whiteboard game

S335, 2026-11-01. Design proposal by Claude (D49: Claude decides design, the operator approves before anything is built).

## What the operator asked (verbatim, S335)
- "can we make a nice menu with in&outs like in the website for each position and even for bxoing and others"
- "can have animations like this in the training tabs (coach and player etc)"
- "make the combos something like the transitions ?"
- "make a game for coach on the visual canvas ?"
- He also pasted an overview of striking "strike trees" (Miro / draw.io maps, Dartfish tagging, Kinovea, Mixamo).

## What exists now
- **Ground (built S335, Lean `scripts/grapple/`)**: a browser plays GrappleMap on two of our women. Pick a position and
  it lists the moves in and out (mount: 18 in, 7 out). Click a move and it plays, lands on the next position, and that
  position's moves show. Open it with `FightCamp.exe -- jump=grapple`. Stills: `S335_stills/b01-b04`.
- **Boxing combos today** (`Lean scripts/rules/Combos.gd` BOOK): 10 combinations (1-2, 1-2-3, slip 2-3 ...). Each is a
  list of punches with no idea of WHERE it starts or ends. Ranges exist only inside the 3D fight (PunchRange,
  Clinch at 0.77 m). Nothing ties the two together.
- **No public "StrikeMap" exists.** The pasted text says so too. Coaches draw strike trees by hand in Miro or draw.io.
  We author ours. It is small: about 8 positions and 40 moves, where GrappleMap has 601 positions and 1,485 moves.

## The proposal

### 1. Boxing positions (the cards)
Real coaching talks in range and ring place. Each card is one situation both boxers are in:

| Position | What it is |
|---|---|
| Outside | Out of range, feinting, hands low enough to move |
| Long range | Jab range (~1.2 m, CLIPREVIEW1) |
| Mid range | Hook and uppercut range (0.75-0.85 m) |
| Inside | Heads close, short punches (< 0.65 m) |
| Clinch | Tied up, until the referee breaks it |
| Her back on the ropes | She is trapped |
| Opponent on the ropes | She has trapped the other woman |
| Corner trap | Either woman in a corner |

### 2. Combos become moves between positions (his "make the combos something like the transitions")
Each combination, defence and step gets a FROM and a TO. Examples:
- Jab step-in: Outside -> Long range
- 1-2: Long range -> Long range (she resets)
- 1-2-3: Long range -> Mid range (the hook needs the step in)
- Slip 2-3 counter: Mid range -> Mid range on the angle
- Body hook - head hook (3b-3): Mid range -> Inside
- Tie up: Inside -> Clinch, then referee break: Clinch -> Long range
- Pivot off the ropes: Her back on the ropes -> Mid range
- Cut off the ring: Long range -> Opponent on the ropes

Combos.BOOK keeps every number it has now (energy, mastery, learn at 30) and adds `from` / `to`. The same
browser then lists, for each card, what she can throw from here and what gets her here. A combo she hasn't learned
shows greyed, with the reason (this matches Q-S294-59's "reason on every greyed button").

### 3. Clips in the training tabs (coach and boxer)
The combo page in Training plays the move on two bodies, the same way the ground browser does: the coach holding
pads and the boxer throwing. In the fight it plays as boxer against boxer. The pad clips (mitt pop, S256) and the
four MetaHuman punches exist already. Each combo needs its paired clip. That is the animation work the cloud
pipeline (ANIMCLOUD1) is for.

### 4. The coach's game on the whiteboard (his "a game for coach on the visual canvas")
The fight plan becomes a small map the player draws on the gym whiteboard (look B):
- Drag position cards on the board, then draw a combo arrow between two cards. For example: "at long range:
  1-2-3; if she gets pinned on the ropes: pivot out; inside: tie up."
- **Limits make it a game.** The plan holds as many arrows as the coach's skill allows (a new coach 4, a top coach
  9). An arrow she hasn't drilled in camp works at a lower rate. Each camp week adds pad time to a few arrows.
- **In the fight**, she follows the map. The broadcast shows which arrow she just used, and the round stats count the
  arrows that worked (landed, missed, countered: what a Dartfish analyst tags). Between rounds the corner may change
  ONE arrow, which fits the corner minute we have.
- Real basis: coaches really do write game plans by range and situation. Analysts tag a fight the same way
  (punch, range, outcome). The Dartfish research is running now (`DARTFISH_S335.md`).

### 5. Corner shouts on right and wrong moves (operator S335: "build the corner shouts on the correct or wrong transitions")
Since every combo is a move from one card to another, the corner can judge each one as it happens, the way a real
corner yells:
- **Right move**: her move matches the plan's arrow for this card, or it is the textbook answer (she is on the ropes
  and pivots out). Praise shout: "That's it, turn her!", "Good, double the jab!" Her confidence goes up a little.
- **Wrong move**: she throws something the card does not allow (she wings a long hook at long range and walks onto a
  counter), or she stays where the plan says leave (she sits on the ropes). The corrective shout names the fix: "Off
  the ropes!", "Step in behind the jab!", "Tie her up!". If she listens (Ring IQ, the coach's voice), her next move
  follows the arrow.
- The shout bar and THE READ exist already (S323-S333). This gives every shout a reason the player can see: the card
  she is on, the move she made, and the arrow the plan had.

### 6. The player builds her own combos (operator S335: "a mechanic so that the player can mix clips to make own combos i think would be a hit")
On the whiteboard the player chains single moves (jab, cross, lead hook, body hook, uppercut, slip, pivot, step in)
into a combination of her own and names it. The map keeps it real:
- **Each move starts where the last one ended.** A move only links if its FROM matches the last one's TO, and its hand
  is free. After a cross the rear hand is still coming back, so a rear uppercut straight after is slow and easy to
  see coming. The board shows that as a red joint ("slow: same hand twice") before she ever throws it.
- **A new combo has to be learned.** Like the book's combos, it starts at mastery 0 and needs pad time on the Training
  page (learned at 30). The clips play it with the coach on pads, and the joins between clips are smoothed by the
  JoinSmoother we already have.
- **The numbers come from the moves.** Energy follows Combos' rule (punch cost x the combination cadence). The landing
  chance and how well it is hidden come from each joint: a well-chained combo (1-2-3: the hands alternate, and the
  step goes with the hook) beats a clumsy one. So a player who understands boxing builds better combos, which is the
  hook.
- **The corner can call it by name** ("Now, the Lucy special!"), and the round stats count it like any other arrow.
- The real thing: coaches teach set combinations, and fighters keep a few of their own. Each move ending in a place
  and on a free hand is how pad work is actually taught.

## The pasted tools, judged
- **Miro / Whimsical / draw.io**: drawing tools, not data. Our own whiteboard screen does their job in the game. Our
  Miro production map already uses Miro.
- **Dartfish**: an analyst's tagging panel. It is a model for our round stats and film study. The agent's report is
  on its way.
- **Kinovea**: free, open source (GPL-2), a video analyser. Useful to US for measuring real fight footage (punch
  timing, hip turn) to check our clips. It is a tool, not something we ship.
- **Mixamo**: we moved to MetaHuman + Rokoko / ActionForge clips (S272-S274). Mixamo's boxing clips are one body,
  with no partner. The two-body moves are the hard part, as on the ground.

## Order, if approved
1. `Combos.BOOK` gets from/to plus the 8 position cards. It is a pure rule module with a test (Qwen or Arena).
2. The boxing browser: the ground browser's screen pointed at the boxing map, using the clips we have (one body per
   move until the paired clips land).
3. The combo clips on the Training page (coach with pads + boxer).
4. The whiteboard plan game: the plan screen, arrow limits by coach, the fight following the plan, and one change at the corner.
Boxing is the demo, so this is demo work. The ground browser stays a separate prototype for the MMA update.
