Depth 7 / Play 6 - PUSHTANK v2, critic B (corner coach, Motorsport Manager player), S442

Read: CRITIC_PACK.md, CRITIC_ACCESS.md, PUSHTANK_MAP_V2_S442.md, fight_bars_v2.png; code checked in PaceAim.gd, Exchanges.gd
(round_of, SHE_TIRED 35, FULL_SHOUTS 2), Duels.gd (TIRED_LEGS 12 / TIRED_SNAP 6, ROPES 8, FORWARD_CLOSE), Knockdowns.gd
(8 / 18 / 32 to the loser, KO from 60). No other review read.

## 1. Scores

**Depth 7.** Wind, legs and the head as three different budgets is how a corner actually thinks: "has he got gas", "are his
legs there", "how much has he taken". Two controls that spend two different things, a minute that refills one well, one
poorly and one never, and an opponent with his own corner make a real trade every round. I would build the model (after the
probe) as it stands. It is not higher because one case teaches bad boxing (a hurt fighter told to Push), the opponent's tank
is read from film instead of from what you see tonight, and the legs model misses the two things every coach knows about the
body (the liver shot takes the legs at once; a dry weight cut takes the chin too).

**Play 6.** The Motorsport Manager feel is there in the minute: set the mode, watch the refill, pick the stint. In the round
it is thinner. The panel is ten readouts per side that change every 30 seconds while the 3D round plays at 40 seconds a round,
and the player's in-round job is mostly "do I spend a shout on HANDS/FEET or on a call". MM works because the tyre and fuel
bars move slowly and the decision comes at clear moments (a lap, a pit window). Here the clear moments exist (the 40 line,
the 30 line, 60 head) but the screen shows everything always. The opponent side is labels ("pushing since round 2 - seen"),
not tells to read, so the guessing game MM gets from rival strategies is not there yet. The scoreboard shows the cards
("CARDS 1-0"), which no amateur corner ever sees; most cases lean on knowing the score exactly, which takes away the biggest
real corner decision.

## 2. True to boxing?

Right:
- Three things. Wind (breath) refills fast, legs refill slowly, head never. That is the order you see on the stool.
- Low wind wearing the legs: true. A gassed fighter stops bouncing first, then plants.
- Push fading to nothing and then hurting: true. Tired punching is arm punching; the counters come in.
- Press costs more legs than Hold; a pinned fighter pays to get off the ropes: true.
- The minute giving no head back: correct, and it is the most important line in the design. Ice and a clear head do not
  undo what the chin took.
- Under 30 legs, Press acts as Hold: true ("he wants to go but the legs won't take him").
- A mid-round change costs a shout: true. A fighter hears one or two things in a round, usually from the corner when he is
  near it.

Wrong or missing, as a coach would say it:
- **"Hold" is the wrong word.** In boxing "hold" means clinch. "FEET: Hold" next to the call "Tie up" will be read as holding.
  Call it Centre (take the middle of the ring, plant).
- **Body shots take the legs later: half true.** Accumulated body work does take the legs over a round or two. A clean liver
  shot takes them at once (the fighter freezes, drops or holds). Needs a rare instant legs hit (say 15-25 off on a landed
  liver shot from a hook to a hurt side), plus the late 0.6.
- **The weight cut takes the chin, not only the tank.** A dry fighter is easier to hurt. Damage taken x1.1-1.2 at the first
  bell for a hard cut, beside the wind and legs drain.
- **Pressing a mover: who pays depends on how you press.** A presser who cuts the ring (steps across, not after) spends less
  than the mover. A presser who follows spends more. The x1.5 / x1.3 split should lean on the presser's Footwork and Ring IQ
  against the mover's.
- **The minute's 20% back on legs is a little stingy.** A good second working the thighs and a minute sat down gives a
  quarter to a third. Make the "ice" recover point able to go to the legs (rub the thighs) instead of the ribs.
- **What gassed looks like:** mouth open, hands slow to come home, shorter combinations (one or two punches), holding after
  every exchange, leaning on the opponent, sitting heavy on the stool. **What legs gone looks like:** flat feet, square stance,
  walks straight back, cannot turn off the ropes, back foot drags, a stumble on a shot that would not move him fresh. The
  design's effects (hands fade from wind, guard/footwork fade from legs, Press locked under 30) match. The 3D must show those
  looks or the meters are the only proof.
- **Coast losing more head when the round is lost:** true in the game's model, but in a real corner "take a round off"
  means box behind the jab and move, not stand there. Coast + Move should cost less head than Coast + Centre; today the
  design does not separate them.
- **Cards.** Amateur corners do not see the scores. Pro corners mostly do not either. The design shows "CARDS 1-0" and cases 1,
  2, 13 and 15 depend on knowing it. The corner's own read of each round, with how sure it is, is the true version, and it is a
  better game (MM's rival pace you do not see).

## 3. The case table

| # | Case | Verdict | Why |
|---|---|---|---|
| 1 | Ahead 2-0 into 3: Steady + Move | Depends | Right if you know you are 2-0; a corner only thinks it. If round 2 was close, Steady + Move can give away the fight. Without cards: Steady + Centre, win the round "safely". |
| 2 | Behind 0-2: Push + Press, finish | Right | You need a stoppage or counts. Every corner says "you need him out". |
| 3 | Level 1-1: Push + Press to 40, then Steady + Hold | Depends | On the opponent's wind, which the panel does not show exactly. Real: win the first minute and the last 30 s; never empty the tank at 2:00 and walk the last minute. Spend in the middle only if he is the one fading. |
| 4 | Opponent hurt: Push + Press, Go for the finish | Right | With the rider coaches always add: stay behind the jab, short shots, do not load up and punch yourself out. "Only above 40 wind" is right. |
| 5 | Our fighter hurt: Push (above 40) + Move, Tie up when caught | **Wrong** | No coach tells a hurt fighter to push. Hands home, move, hold, survive, clear the head. The code reason (the hurt roll lives under margin -30, so Push keeps you above it) is a model hole, not boxing: Push while hurt must raise the head taken (open while trading). Correct answer: Coast + Move, Tie up. |
| 6 | Body puncher: Steady + Move | Right | Keep him at the end of the jab, turn him, tie up inside. |
| 7 | Mover: Push + Hold | **Wrong as drawn** | Centre is right (cut the ring, do not chase). Push at range throws at air and burns wind for nothing; against a mover you invest when you trap him. Correct: Steady + Centre, Push + Press only when he is near the ropes. |
| 8 | Their wind lower: Steady + Press | Right | "Make him work, walk him down." |
| 9 | Slow starter: Push + Press all round 1 | Depends | On our own tank. In a 3x3 a full round of Push + Press against a fresh man can cost round 3. Right if our Stamina is better; else Push + Centre. |
| 10 | Fader: Steady + Centre with body, then Push + Press | Depends | Right in 6+ rounds. In 3 rounds the fade may not come before the bell; and if rounds 1-2 are won the push in 3 is only for a stoppage. |
| 11 | Short fuse: Steady + Hold, Calm down | Right | It is the talk, as the map says. |
| 12 | Drained by the cut: Steady + Move | Depends | Move spends the legs the cut already took. Steady + Centre behind the jab is usually better; and the chin is the real risk (see 2). |
| 13 | Steal the last 30 s: Push the last exchange | Right | The oldest corner shout there is. |
| 14 | Pinned: Steady + Move over 30 legs, Tie up under | Right | "Turn him, pivot off, do not go straight back." |
| 15 | Round lost 0-4: Coast + Move if head under 40; Steady + Hold near 60 | **Wrong for near 60** | A fighter near 60 head (one bad round from a stoppage) is told to move and hold, never to stand in the centre. Near 60: Coast + Move + Tie up. The low-head half is right. |
| 16 | Two pushers: Push + Hold with the better tank and chin, else Steady + Move | Right | |
| 17 | 6-round pro, round 4: Steady + Hold | Right | Legs decide long fights. |

**Missing situations:** we just took a count (the standing eight: next 30 s hold and move, nothing else); a closing eye or a
cut (the cutman, links to Move: keep the bad eye away); the opponent switches stance; the opponent is holding to survive (ref
warnings, break and push off); a referee warning on us for holding (Tie up overused costs a point); a reach/height gap (Centre
for the shorter man is a losing place); our fighter looks better than he is (the corner reads its own fighter's tells too,
not only meters); the opponent's corner changes plan at the break.

## 4. The minute and the shouts

True to a corner. The minute is where instructions land; mid-round you get one or two words through, mostly "MOVE" or "HANDS
UP" - feet shouts are the most common real ones, so FEET as a shout is very true. Free in the minute, a shout in the round, a
Low-trust fighter keeping the minute's setting: right.

Enough to do? In the minute, yes. In the round there are six decision moments, each with 3 calls + up to two control changes
against a budget of two full shouts. That is enough choice; the problem is reading, not doing. Make the in-round screen
quiet: the rings under the feet and one line at the moment a line is about to be crossed; the full panel only on hover or in
the minute.

## 5. The opponent

Right idea: ranges until film, head exact (we see what we landed). Two faults:
- Film tells you how he usually fades (a prior: "faded in R3 in 2 of 3"); it does not tell you tonight's tank. Tonight's tank is
  read by eye. The ranges should narrow from tells seen in this fight; film only sets where the range starts.
- What is drawn are labels ("pushing since round 2 - seen", "breaking soon at this pace", "pressing costs these legs too"),
  not tells. "Mouth open after the jab" is the only true tell drawn.

Tells a corner really reads: breathing (mouth open, shoulders heaving); hands (slow coming home, dropping after combinations,
shorter combinations); holding (grabs after each exchange); feet (stopped bouncing, flat, square, slow off the ropes); legs
after a shot (a dip, stiff legs, a stumble); their stool (sits heavy, the second rubbing the thighs = legs going, ice on the
ribs = body hurting, working an eye); their corner's shouts (you hear them: "let your hands go" = they will push). Each tell
should name which bar it narrows.

## 6. Words

- "Hold" (feet): wrong word, means clinch. Use Centre.
- "Head 24" with no scale: a player does not know 24 of what. "Damage 24 of 60", or a bar with the 60 line only.
- "a dominant round lost adds 32": jargon and a number nobody can use. Say "a bad round adds a lot; a count can end it from 60".
- "Push worth nothing" on the 40 line: game talk. Say "pushing stops paying here".
- "Coast": fine. "Steady", "Push", "Press", "Move", "Wind", "Legs": all words a coach uses. "Gassed", "legs gone": right.
- "The pit stop" stays off the screen.
- Clock time ("gassed 2:00 into round 3"): right, it is how corners think ("he'll be gone in the last minute"). For our own
  fighter one time is fair (we know him from sparring). For the opponent it must be a window ("between 2:00 of round 2 and 1:00
  of round 3"), or it gives away a number the corner cannot know.
- "CARDS 1-0" on the scoreboard: remove (see 2).

## 7. Branches

First build, true and worth it:
- Training: Stamina for wind, Stamina + Footwork for legs; Recovery for the minute. True. Add: hard sparring rounds in camp are
  what make the own-fighter readout exact (no sparring = a window, not a time).
- Weight cut: wind and legs at the first bell, true; add the chin (damage taken up).
- Corner minute as the pit stop: the core, first.
- Opponent HANDS by style and score: needed, first.
- After the fight: rest days from legs and wind, no sparring from head: true (medical stand-downs after a hard fight are real).

Second:
- Plan before the fight with a ROUND row: true, coaches plan rounds ("feel him out in the first"). PlanPhase if ahead / if behind
  must use the corner's read, not the cards.
- Judges: amateur criteria are quality blows, domination by technique and tactics, competitiveness. Press wins
  competitiveness; Move that never punches loses it (running is scored against you in the "who controlled it" sense). Pro:
  effective aggression and ring generalship. Worth it once judges are wired, because it gives Move a real cost on the cards.
- Heart second wind: true and good.

Missing: the cutman and a closing eye (Move to keep the bad eye away, a stop decision); a liver shot; a referee warning for
holding; sparring partners' style in camp shaping the legs late; age (older fighters lose legs before wind).

## 8. To reach 10/10 (most important first)

1. **Fix case 5 and the model behind it.** A hurt fighter at Push takes x1.3 head per exchange lost (open while trading); the
   recommended answer becomes Coast + Move + Tie up. While hurt, the panel greys Push and "Let your hands go" with the reason.
   The probe must show Coast + Move beating Push for a hurt fighter.
2. **Take the cards off the screen.** Replace them with the corner's own read of each round (won / close / lost, and how sure),
   built from the exchanges won and the landed totals the player can see. Cases 1, 2, 13, 15 and PlanPhase read the read, not
   the cards. The Why after the fight reveals the real cards.
3. **Rename FEET Hold to Centre**, and make Centre mean "take the middle": against a mover it is the cut-off, not chasing.
4. **Fix case 7:** against a mover, Steady + Centre; Push + Press only once he is within one step of the ropes. Make the press
   cost depend on the presser's Footwork + Ring IQ against the mover's (cutting the ring vs following).
5. **Opponent bars narrow from tells seen tonight; film only sets the prior.** Tells drawn as an evidence list (breathing, hands,
   holding, feet, legs after a shot, their stool, their corner's shouts), each naming the bar it narrows and when it was seen.
   Their HANDS mode is learned from what you hear and see, never printed as a label.
6. **A liver shot takes the legs at once:** a landed hook to a hurt liver side has a chance to take 15-25 legs now and add
   a "hurt" freeze; ordinary body work stays the late 0.6.
7. **Weight cut takes the chin:** a hard cut adds x1.1-1.2 damage taken for the bout, shown on the weigh-in line and in the
   first-bell readout.
8. **Fix case 15 near 60 head:** Coast + Move + Tie up, never Centre. And separate Coast + Move from Coast + Centre on head
   taken (boxing behind the jab on the move costs less than standing there).
9. **Quiet in-round screen:** rings under the feet and one line at the edge about to be crossed; the full five-row panel only
   on hover and in the minute. Damage shown as "x of 60", no "dominant 32" text.
10. **Minute legs:** the ice recover point can go to the thighs (legs back a further 10), so the minute has a real wind / ribs /
    legs choice.
11. **Add the missing cases** to the table and the probe: after a count, a closing eye, opponent switching stance, holding
    warnings, reach gap, a fighter hiding how hurt he is.
12. **Opponent readout as a window** ("tires between 2:00 of R2 and 1:00 of R3"), own fighter as a time only with camp sparring
    rounds behind it.
13. **The 3D must show the states:** gassed = mouth open, hands slow home, shorter combinations, holds; legs gone = flat,
    square, straight back, cannot turn off the ropes. Otherwise the meters are the only proof and the corner fantasy breaks.

## 9. My 10/10 drawing

`docs/mockups/s442/pushtank_v2_critic_b/ten.html` -> `ten.png` (1920x1080): round 3 with 1:10 left, no cards (the corner's read of
each round instead); our boxer HURT, so the panel suggests Coast + Move then Tie up and greys Push; FEET is Press / Centre /
Move; DAMAGE 52 of 60; own readouts in clock time; the opponent's wind and legs as ranges with an evidence list of tonight's
tells (breathing, hands, feet, holding, their stool, their corner's shout, film as the prior); the minute's legs choice; the
three body rules.
