# DESIGN_PLANFLOW1_V1_WRITE_KALLI_KALLI - Kalli answer (seat queue SQ117)

Brief: research/DESIGN_PLANFLOW1_V1_WRITE_KALLI.md
Sent: 2026-11-14 15:10 | collected: 2026-11-14 15:28 by Tools/seat_queue.py (the 30-min reconcile)
Verify the sources before using it.

---

# PLANFLOW1 v1: the fight plan as an if-then flowchart (S459, S469, 2026-11-14)

Part 1 of 4

**Owner rules this map keeps, quoted**
- S469: "go with your recommendation". The flowchart is the new look of the plan the game already has, not a second plan system. It ships in three steps, simplest first ("ok").
- S448: "notice how the names are only mentioned on the header, nowhere in text menus options, follow that rule". Boxes, diamonds, lines and tooltips say your boxer, the opponent, your coach.
- S412: any gym, any boxers, men or women. No fixed he or she anywhere on these pages.
- S425: wired and shown on the correct menus, deep enough for a critic's 7/10.
- Section 7: "i do not want stupid and unecessary information to be displayed unless the player can really do something about it".
- The pack: no timers, no flavour text, one word per concept. Females never fight males. Scouting means opponents.

**Tags**
- **CODE** means Claude read it in the code (S469 brief or the pack).
- **REAL** means real boxing practice.
- **GAME VALUE** is a value the game already uses, carried over.
- **ESTIMATE** is a starting value the probes size.
- **NEW** is a small addition this map asks for, named so Claude can price it.

## 1. The decisions, in order

| When | What the player chooses | What it costs or risks | Tag |
|---|---|---|---|
| **The bout is booked** | Nothing to press. Your coach's preset for the opponent's style loads as the plan, built only on free habits (section 3) | none; the preset is about half a good plan | CODE (assistant writes one, "poor to about half") |
| **Camp, film study** | Which camp days go to Film; each opens one habit on the opponent's file, which unlocks one diamond | a film night is a night off the pads: about 240 drill units lost | CODE (tape opens a tell every few camp days; 240 units a pad night) |
| **Pro: scout** | Scout ($250) opens weapon and weakness at once | $250 | CODE |
| **Camp, the editor** | Draw the main line (3 to 4 boxes), place up to 3 IFs on found habits, set Plan B | each box is a move your boxer must drill, so the plan spends pad time | CODE (worth × pad time) |
| **Camp, the tray** | The Training tab's tray becomes "THE PLAN vs the opponent": drag each box's drill card to a pad night | under 30 the box wears the red stamp and is skipped on fight night | CODE |
| **Camp, Test it** | Run the plan against the opponent's file (limited tries) | tries are limited, so testing is a choice | CODE (Test it exists) |
| **The night before** | Last edit, then the plan locks at the weigh-in | an untested late change keeps its red stamps | ESTIMATE (lock point) |
| **Fight night, live** | v1 nothing: watch which branch fires. v2 one shout aims a box (section 5.3) | v2 a shout spent on a box is a shout not spent on a call | CODE (shouts) |
| **Corner minute** | Change ONE box or diamond, with this round's fired counts on screen | one change a round; changing a box that worked resets its reads | CODE (one arrow a round; reads reset at the corner) |
| **After the bout** | The result's "The plan, lit up" shows the flowchart with counts. Redraw for the next opponent | a reused plan meets opponents who adjust, and a pro corner that reads it | CODE (adjust, ProRead) |

## 2. Today's data, drawn as the flowchart (nothing the bout can't honour)

| On the page | In the code | Rule |
|---|---|---|
| **Top node**: "Opening: <card>" | the card the opponent's game puts your boxer on at the bell | CODE (PlanFight). The player doesn't pick it; the file shows it once film finds the opponent's game |
| **A box on the main line** | the ANY-TIME arrow `{move, when: any}` on one card | CODE (PlanBoard) |
| **The line from box to box** | where a WON exchange leaves your boxer: the card the box's move goes to | CODE (PlanChain). So the main line is a real chain: box 2 sits on the card box 1's move leads to |
| **An IF diamond beside a box** | a SITUATION arrow `{move, when: <habit>}` on that box's card | CODE. It's taken first when the habit holds this exchange, else the box (PlanBoard.pick) |
| **A diamond's colour** | best / ok / wrong against the opponent's game | CODE |
| **The number on a box** | worth = match × pad time − the average of everything your boxer can do on that card | CODE. Shown as "+n edge", hover shows the parts |
| **The red stamp** | mastery under 30; the coach skips the step on fight night | CODE |
| **The read pips** | reads up (gold pips) or down (red) this round, to the cap | CODE. They reset at the corner minute |
| **Plan B bar** | see below | |

**What Plan B is in code terms.** It's the any-time arrow on the card a LOST exchange sends your boxer to: the opponent's card (CODE, PlanFight). That card is also the opening card, so on the page Plan B is the box at the top, and the "return to top" arrow from the owner's picture is honest: a lost exchange really does go back there.
- So Plan B is drawn as a bar at the bottom with its return line, but it is the opening card's any-time arrow, written once. It is not a third thing.
- **The tired and hurt rule is NOT Plan B.** "When tired or hurt your boxer stays where the fighting is" (S466, CODE) is drawn as a fixed grey diamond, "HURT: hold this card", on every box. In v1 the player can't change it; v2 makes it a state IF (section 5.2).
- **Rejected:** a Plan B that fires "after losing an exchange" as a separate arrow. It needs a new `when` reading the last exchange's result. It's cheap, but it adds nothing the return line doesn't already show. CHECK (Claude): whether `when: lost_last` would be one line in PlanBoard.pick. If it is, it's a v2 candidate.

**Main line length.** A won exchange can lead to a card already on the line, for example a move that steps back out to long range. The line then loops, drawn as an arrow back up, and that's honest. The editor allows at most 4 boxes, one per card (CODE: one any-time arrow per card).

**A diamond with no box.** A situation arrow on a card with no any-time arrow is legal in code. It's drawn as a diamond hanging off an empty, dashed box, "no main move: improvises here". It's legal and shown, but the empty box costs edge 0 exactly as the code does.

## 3. The IF habits

An IF is a habit that holds for a whole exchange, never one punch's outcome (S469). A diamond may sit only on a habit film found, or on one marked FREE, which every opponent of that style has.

### 3.1 Boxing (10)

| IF the opponent… | Free or found | Right answers (best, then ok) | Tag |
|---|---|---|---|
| **presses** | free for a Pressure fighter or Slugger; found for others | best: step back + check hook, pivot out. ok: tie up, 1-2 | mode CODE (Pressing) |
| **boxes at range** | free for an Out-boxer; found for others | best: cut off + jab to the body, herd. ok: 1-1-2 | mode CODE |
| **waits to counter** | free for a Counter-puncher; found for others | best: feint, draw the lead. ok: 1-1 | mode CODE |
| **loads up** | free for a Slugger or Boxer-puncher; found for others | best: jab first, slip 2-3. ok: tie up | mode CODE |
| **tires** | FREE, everyone | best: body hook, let the hands go (1-2-3-2). ok: 2-3 | mode CODE (Tiring) |
| **is hurt** | FREE, everyone | best: the finishing combination your boxer owns. ok: 1-2 | mode CODE (Hurt) |
| **shells up** | found | best: body hook, pivot out. ok: uppercut | tell name CHECK (Claude) |
| **circles away** | found | best: cut off, check hook. ok: step in + jab | tell name CHECK (Claude) |
| **switches stance** | found (free against a known switch-hitter) | best: lead hook to the new lead side, step out. ok: jab | tell name CHECK (Claude) |
| **bites on feints** | found | best: feint + 1-2, feint low + cross over the top. ok: feint + jab | tell name CHECK (Claude) |

**On the ropes is NOT an IF.** The ropes are a card, so they're a box. In the owner's picture, "on the ropes" is answered by the box on the ropes card.

**Habit share.** Each found habit says on the file how often it showed: "pressed in 3 of 4 films". That number is what the diamond is worth betting on (section 4). CODE for the tells; the share line is NEW (the count of films it showed in).

### 3.2 BJJ (6, on the position tree)
The steps are positions on BjjTree: guard, half guard, side control, mount, back. A box is the pass, sweep or submission your athlete drills from that position.
- **Timing.** A BJJ beat is about 11 seconds (CODE, S405), so an IF holds over a run of 3 beats, about one exchange's 30 seconds. ESTIMATE.
- CHECK (Claude): whether BjjSide's picks can read a habit over 3 beats.

| IF the opponent… | Free or found | Right answers |
|---|---|---|
| **turtles** | found | best: take the back. ok: front headlock |
| **stalls in guard** | FREE | best: the pass your athlete owns. ok: stand to break |
| **bridges from mount** | found | best: follow to technical mount. ok: armbar |
| **frames from bottom side** | found | best: knee on belly. ok: switch to mount |
| **guards the neck** | found | best: switch to the armbar. ok: keep position for points |
| **tires** | FREE | best: keep the pace, pass. ok: hold for points |

Part 2 of 4

## 4. Depth: why a good flowchart beats a lazy one

### 4.1 What we have, measured
- **S396:** a good plan wins 59% of close bouts, no plan 46%, a bad plan 43% (CODE, measured). So the plan already turns about 1 close bout in 8.
- **S468:** on 20 sample bouts, the plan as written wins 9 of 40, and the best single change 11 of 40 (CODE, measured). One change is worth about 1 bout in 20. That's too little for the player to feel, and it's why the editor isn't yet worth drawing.

### 4.2 What makes the plan matter more (no flat bonus)
Each lever comes from a cause the fight already has.

1. **Found diamonds are the only route to "best" against a found habit.** A free-habit preset can reach "best" only on the free modes. So a hand-made plan with three found IFs gets about two more "best" exchanges a bout than the preset (ESTIMATE, probed).
2. **Reads compound inside a round.** A right planned answer that wins puts the opponent one read down for the rest of the round (CODE). A diamond that fires in exchange 2 makes exchanges 3 to 6 easier. That's why an early-firing IF is worth more than a late one, and the page says so: the box hover shows "fires early: reads build".
3. **Habit share decides the bet.** A diamond on a habit the opponent shows in 1 film of 4 rarely fires. One the opponent shows in 4 of 4 fires most rounds. The player weighs a strong answer to a rare habit against an ok answer to a common one.
4. **Pad time is the budget.** Every box and diamond is a move to drill. Four boxes and three diamonds can be up to 7 drill cards, and a week has 3 pad nights (CODE). A plan with more boxes than your boxer can drill gets red stamps, and the coach skips those steps. The plan's size is a training cost, not a free choice.

**Target numbers, ESTIMATE, set as probe pass lines (section 6):**

| Plan | Close-bout win rate |
|---|---|
| No plan | 46% (CODE, S396) |
| Coach's preset (free habits only) | 51–53% |
| Hand-made with 3 found IFs, all drilled | 62–66% |
| One wrong IF | −3 to −5 points against the same plan without it |
| Built on a habit that didn't show | about the main line alone (section 7) |

### 4.3 What the opponent does about it
- **Adjusts.** An answer used again and again loses edge (CODE). A diamond firing 4 times in a round is worth less on the 4th. This caps any one diamond and rewards a plan with two or three different answers.
- **The pro corner reads it.** After round 1 a pro opponent's corner reads your boxer's plan (ProRead, CODE). On the page, the most-fired diamond gets a dashed outline and the coach's line says "They've seen the body hook." CHECK (Claude): which arrow ProRead targets. This map assumes the most-used one.
- **Habits shift.** A mode can change mid-round, for example from Pressing to Tiring. That's the code's own mode change, so the diamond that fires changes with it.

### 4.4 What a wrong IF costs
A wrong answer that loses puts your boxer one read DOWN for the rest of the round, and the planned wrong answer shrinks the energy ceiling (CODE). So a wrong diamond costs more than an empty one, which costs edge 0. That's the point: don't place a diamond you can't back.

### 4.5 Why redraw between fights
- **The habits are the opponent's.** A found IF on one opponent may not exist on the next.
- **The preset is per style.** The player's own plans are per opponent, saved on that opponent's file and reloadable for a rematch.
- **Reuse is punished.** For pros, a plan used against the same corner twice starts with that corner's read already in, from round 1. ESTIMATE: a NEW use of ProRead's memory, CHECK (Claude).
- **Your boxer changes.** New Sharp moves open better boxes, and new slots open (v2, section 5.1).

**No dominant plan.**
- A plan of all-free habits caps at the preset's level.
- A plan stuffed with diamonds runs out of pad time.
- A one-diamond plan is read and adjusted.
- The best plan is opponent-specific, drilled, and spread over two or three answers. Probe pass line 4 checks it.

## 5. The owner's further ideas, weighed (S469)

### 5.1 Slots from knowledge: TAKE, v2
How many boxes and diamonds a plan holds:
- Base 3.
- +1 at 5 bouts, +1 at 12 bouts, +1 at Fight IQ 65, +1 with an assistant coach rated 70+.
- The cap is 7, so the page stays readable.

ESTIMATE. Bouts, Fight IQ and coach rating are CODE. This replaces "the coach's skill sets how many lines (4–6)" with your boxer's and your coach's knowledge together. Plan B never takes a slot.

### 5.2 State and clock triggers: TAKE, v2, with one change

| IF | Exchange-level? | Notes | Tag |
|---|---|---|---|
| **The opponent's tank low** | yes, it's Tiring | already the free "tires" diamond; no new IF | CODE |
| **Your boxer hurt** | yes | the grey "HURT: hold" diamond becomes editable: hold this card, tie up, or shell | CODE (S466 rule) + NEW (choice) |
| **The opponent cut or swollen** | yes | needs the doctor's check (the pack lists cut states and a cutman job); the diamond appears only after a cut is called | CHECK (Claude) that the cut state is readable mid-round |
| **The last exchange of a round** | yes, exchange 6 is one exchange | "steal the round" | CODE (six exchanges) |
| **The last round, behind** | **change** | amateur boxing has no open scoring, so the corner can't know the cards. The trigger reads your coach's own count from the corner card, labelled "behind on your coach's count", and it can be wrong. That's honest | REAL (no open scoring) + CODE (corner card) |

### 5.3 Corner shouts: CHANGE
The idea is 2 a round, each pushing a box for the next exchange. The game already has a shout every 30 seconds, and only two a minute get through fully (CODE). A second counted resource beside it would be a second system, which S469 rules out.
- **Change:** v2 lets a shout aim at a box on the flowchart ("Body hook now"). It forces that box next exchange and uses the existing two-a-minute rule.
- This makes the shout bar and the plan one system.

### 5.4 Bait and conditioning: TAKE, v3
- Each won exchange to the body adds one "expects the body" pip on the opponent, up to 3.
- A diamond "IF expects the body: feint low + cross over the top" cashes the pips.
- The pips are the code's reads, given a target (CODE hook). Their payoff per pip is probed, never flat.
- A sharp opponent (Fight IQ 70+) gains pips at half speed (ESTIMATE).
- The pips show beside the opponent on the flowchart.

### 5.5 Composure: TAKE, v3
- Only after a knockdown or a hurt, the page shows the chance first: "Holds the plan: 70%". ESTIMATE, from Composure and Heart, both CODE attributes.
- **Fail:** the plan greys out and your boxer fights the style's default (edge 0) until the corner minute.
- It's never hidden, and never at any other time.

### 5.6 Drilled or hesitant: TAKE, v1
It's already in the code. The box shows the mastery tier and number, and the red stamp under 30. With FireLevel on (S451, CODE), the box shows the fire rate:
- Usable: "fires 1 in 2"
- Sharp: "3 in 4"
- Signature: "always"

### 5.7 Between rounds: TAKE, v1
The corner minute shows the small flowchart with each box's and diamond's count this round, and FixLab's suggested line (CODE) outlined. The one change is made on the flowchart.

### 5.8 Feint loops: CHANGE
Taken only as the habit "bites on feints", found on film (3.1).

### 5.9 Signature chains: CHANGE (agree with Claude)
- No flat bonus. A chain's worth comes from causes the fight has: body work drains the tank, a drained opponent tires, and "tires" fires the finishing box.
- When a plan's main line plus diamonds is used in 3 bouts, the player may NAME it ("the body-to-head plan") and your boxer becomes known for it.
- A scouting opponent then finds it on film: their corner starts with one read on it (ESTIMATE, v3).

### 5.10 Left out, agreed
Cage, takedowns out of boxing, hybrids (MMA later), live sliders, gear with percentage buffs, any name outside a header, a 2D radar.
- **Real-time countdown on the corner change:** agree, leave it out. The pack's "no timers" rule and a paused corner minute are the game's identity. A countdown would punish reading, which is the very thing the flowchart asks for.

Part 3 of 4

## 6. Probes (400 bouts a cell, three seed sets, close bouts: rating gap under 3)

| Bot | Rule |
|---|---|
| NONE | no plan |
| PRESET | your coach's preset for the opponent's style, free habits only |
| GOOD | hand-made: the 3 most-shown found habits, best answers, all boxes drilled to Sharp |
| WRONG | the same shape with one diamond's answer set to "wrong" |
| STUFFED | 7 boxes, drilled only as far as 3 pad nights allow |
| ONE | one diamond, reused every bout |

**Pass lines (all ESTIMATE):**
1. GOOD beats NONE by 12+ points, and PRESET by 8+ points, in close bouts.
2. PRESET beats NONE by 4 to 8 points, so the preset helps but leaves room.
3. WRONG loses 3+ points to the same plan without the wrong diamond.
4. **No dominant plan:** STUFFED and ONE each finish under GOOD, and against pros ONE loses 3+ points from round 2 (ProRead). No single plan shape is best against all six styles.
5. **The player sees it:** a diamond fires at least 3 times in a 3-round amateur bout in 80%+ of GOOD bouts, and no diamond fires more than 9 (else it's really the main line).
6. **The main line works too:** at least 4 exchanges a bout go through main-line boxes after a won exchange.
7. **Habit share honesty:** a diamond on a "3 of 4 films" habit fires 2 to 4 times more often than one on "1 of 4".
8. **Training still wins:** a 10-point stat gap still wins about 90%+ with the weaker side on GOOD. The pack's rule is that training beats planning.
9. **BJJ:** the same as lines 1 and 5, over 3-beat runs.

## 7. The failure path that teaches (no rigged roll)

**The plan on a habit that didn't show.**
- Film found "presses: 2 of 4 films". The player built two of three diamonds on it.
- Tonight the opponent opens Boxing at range and stays there: the code's own mode pick, given the matchup.
- **Live:** those diamonds stay dark. The round line says, once a round, "Never pressed this round: your main line fought alone."
- **Corner minute:** the counts show 0 and 0 on the two diamonds. FixLab outlines the box on long range.
- **The Why:** "YOUR PLAN: two IFs on pressing, never fired. The main line won 5 of 12 on its own."
- **NEXT:** "Build the main line to stand alone; bet IFs on habits shown in 3 of 4 films."

**What it teaches:** habit share is a bet, and the main line must work without diamonds. The odds were on the file before the fight.

**A second failure: the undrilled box.** A diamond's move is under 30 on the night. It shows a red stamp and fires 0 times because the coach skips it (CODE). The Why line names it: "Uppercut not drilled: skipped 3 times."

## 8. Every menu, and what each is wired to (S425)

| # | Menu | What shows | Wired to |
|---|---|---|---|
| M1 | Fighter page > Playbook > Game plan | **the editor**, replacing the move-map arrows as the default view; "Open the map" stays as a switch | PlanBoard, PlanChain, worth calc |
| M2 | Fight prep > WHAT YOUR PLAN SHOULD ANSWER | each found habit with its share and "Add IF" (opens M1 at that card); hidden ones say what opens them | tells, M1 |
| M3 | Fight prep > Tape Room > YOUR ANSWER | the picked move becomes a diamond on the right card, not a loose line | Tape Room, PlanBoard |
| M4 | Fighter page > Week > the tray, "THE PLAN vs the opponent" | one drill card per box and diamond, each with the red stamp or tier; drag to a pad night | PadWeek, mastery |
| M5 | Fight prep, the primary button | "Write the game plan" until the plan has a main line; then "Check the plan: n stamps" while any box is under 30 | Fight prep state |
| M6 | Playbook > Game plan > Load preset | your coach's preset for the opponent's style; free habits only | preset per style (NEW content, 6 styles) |
| M7 | Playbook > Game plan > Test it | worth against no plan, and which diamonds fired in the test | Test it (CODE) |
| M8 | Fight night, live | the flowchart panel; the box in play outlined; a fired diamond lit with FIRED; read pips; the round line carries it | PlanFight, reads, round line |
| M9 | Fight night, corner minute | small flowchart with counts; FixLab's line outlined; change ONE box or diamond here; the pro "They've seen" note on the read diamond | corner change (CODE), FixLab, ProRead |
| M10 | Result > The plan, lit up | the full flowchart with fire and win counts per box and diamond | existing result view |
| M11 | Result > The Why | YOUR PLAN lines name diamonds and boxes, not "lines" | Why |
| M12 | Fighter page > Overview | "Fight plan (n boxes, n IFs)", replacing "(n arrows)"; opens M1 | Overview button |
| M13 | Rival file (modal) | each found habit with its share and whether your plan answers it | tells |
| M14 | Fighter page > History | per bout: the plan used, its counts; v3 the named plan | Records |

**Not on:** Home, Club, World, Fights. The plan isn't money or booking (section 7 rule). The bout offer's win band already counts the plan through the chance, so no plan chip goes on it.

## 9. Scope: what it does NOT do
- No punch-by-punch IFs.
- No live sliders.
- No gear buffs.
- No timers.
- No second plan system.
- No plan beyond 7 boxes.
- No name outside a header.
- No new screen: the editor replaces the Game plan tab's view.
- No MMA, cage or hybrid.
- No AI writing a plan better than the preset.

## 10. Owner questions (scope, money, taste)
1. Should the flowchart **replace** the move-map arrows as the Game plan tab's first view (the map kept behind a switch), or sit beside it?
2. In v2, should a corner shout aimed at a box use the existing two-a-minute rule (this map), or be its own 2 a round as in your list?
3. "Last round, behind" reads your coach's count, which can be wrong. Is a trigger that can misfire acceptable, or cut it?
4. v3 named plans: should an opponent who scouted a named plan start with a read on it, so being known costs something?

## 11. CHECKs
- **CHECK (Claude):**
  - Which tell names exist for shells up, circles away, switches stance and bites on feints.
  - Whether the cut state is readable mid-round.
  - Whether `when: lost_last` is one line.
  - Which arrow ProRead targets.
  - Whether ProRead remembers across bouts.
  - Whether BjjSide can read a habit over 3 beats.
  - The films-shown count per tell.
- **CHECK (John):** whether UK amateur corners keep their own round count (supports "behind on your coach's count").

Part 4 of 4

## 12. Build order (three steps, simplest first; owner "ok")

**v1: the look, the habits, the fired branch**
- The editor drawn from PlanBoard and PlanChain (section 2), with Plan B as the opening card's any-time arrow and its return line.
- The ten habits, found or free, with the share line.
- Red stamps and fire rates on boxes.
- The live panel with FIRED and the round line.
- Corner minute counts and one change.
- "The plan, lit up", the Why wording, and the presets.
- Probes 1, 2, 3, 5, 6, 7, 8.

**v2: slots, and state and clock triggers**
- Slots from knowledge (5.1).
- The editable HURT diamond, the opponent cut, the last exchange, and the last round behind on your coach's count (5.2).
- A shout aimed at a box (5.3).
- Probe 4.

**v3: bait and composure**
- The expects-the-body pips (5.4).
- The Composure check with the chance shown (5.5).
- Named plans and opponents reading them (5.9).
- Probe 9 for BJJ if BJJ lands then.

## 13. The editor page, 1920×1080 (Look B whiteboard, warm wall)

- **Header, 0–120 px:** polaroid of your boxer left (name once), "VS" and the opponent's polaroid right (name once), with the class in kg, style word and stance each.
- **Left column, x 40–440, "THE FILE":**
  - Habit chips, each 360×56: habit word, share "3 of 4 films", FOUND or FREE. Locked chips say "Film opens this".
  - Under them, the opening card: "Bell: long range".
  - Load preset button, 360×48.
- **Centre, x 480–1440, the flowchart:**
  - Top node 320×64 at y 160: "OPENING: <card>".
  - Main line: up to 4 boxes, each 320×110, x 560, at y 260 / 410 / 560 / 710, joined by arrows labelled with the card the move leads to.
  - Each box shows the move or combination (marker, 28 px), tier and number ("SHARP 64"), fire rate ("3 in 4"), and edge ("+2.1"). A red stamp sits top-right under 30.
  - Diamonds sit right of their box, 150×150 at x 960, with a line in. Each holds the habit word (22 px), the answer move under it, and a best/ok/wrong dot.
  - Grey "HURT: hold" stubs sit left of each box, 90×40.
  - Plan B bar: 760×70 at y 880, "PLAN B: <move> on <card>", with the return arrow up the left edge to the top node.
- **Right column, x 1480–1880, "WHAT IT'S WORTH":**
  - Slots "5 of 6" (v2), drill cards needed against pad nights left ("6 cards, 5 nights").
  - Warnings, one line each: "Uppercut under 30: skipped".
  - The worth line "+8 over no plan, your coach's test", in **gold** (the one gold on the frame).
  - Tests left "2 of 3".
- **Bottom bar, y 980–1060:** Save plan, Test it, Clear. No green; Continue lives in the top bar.
- **Hover:** every number explains itself: a box's edge breaks into match, pad time and card average.

## 14. The live fight page, 1920×1080 (fight night, dark and tight)

- **Top, 0–90 px:** the scorebug: both names once (header), the round, the exchange "3 of 6", and the opponent's mode clue word.
- **Left 1180×800, x 40–1220, y 110–910:** the 3D fight of the settled exchange, both fighters head to feet.
- **Right panel, x 1260–1880:** the flowchart at 60% scale.
  - The box in play is outlined in white.
  - A fired diamond fills red with "FIRED" (32 px) over it for the exchange, its line glowing back to the box.
  - The count by each diamond ("2").
  - Read pips beside the opponent's polaroid at the top of the panel: up to the cap, filled in gold when your boxer is up (the one gold) and red when down.
  - Dashed outline on a diamond the pro corner has read.
- **Bottom strip, y 930–1050, the round line,** one line, under 70 characters, no numbers: "Shelled up: the body hook lands, pivot out."
- **Corner minute, the same panel larger:** counts per box, FixLab's line outlined, "Change one" on each box and diamond.

## 15. My score
**DEPTH 6, GENERAL DESIGN 7, PLAY 6** (my own, not a critic's).
- **Depth.** Found habits as the only route to best answers, habit share as a bet, pad time as the budget, reads compounding, adjust and ProRead. The numbers that prove it are ESTIMATE until the probes run.
- **General design.** One system with a new look. Every element maps to code (section 2). 14 menus wired, no new screen. Points come off for seven CHECKs.
- **Play.** FIRED is the moment, and the failure path teaches. The live fight is still watched, not steered, until v2.

## To reach 10/10
1. **Run probes 1 to 8 on three seed sets.** Replace every ESTIMATE in 4.2 and 5.x with probed values. If GOOD doesn't beat PRESET by 8+, the found-only rule needs a stronger edge for found answers before the editor ships.
2. **Settle the CHECKs:** tell names, cut state, ProRead's target and memory, and the films-shown count. Each decides one row of section 3 or 5.
3. **Owner answers 1 and 2:** replace or beside, and the shout rule.
4. **Write the six presets as content:** one per style, free habits only, sized to pass line 2.
5. **Draw the two pages as PNGs at 1920×1080** from sections 13 and 14, with the eight MMA fighters for stress (a long combination name, a switch-hitter).
6. **BJJ:** confirm the 3-beat habit window, then draw the BJJ editor with positions as boxes.
7. **v2 slot numbers** probed so a green boxer's 3-box plan still beats the preset when drilled.
8. **Bait payoff and Composure chance** probed so neither becomes the dominant plan or a hidden swing.
