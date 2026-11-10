# Fight display, approach B (with A's best parts): game-feel and interface critic (S419)

Lens: how the display MOVES. Picture: `docs/mockups/s419/fight_critic_feel.png` (from `fight_critic_feel.html`, a frozen frame; numbered gold marks are review marks, not part of the display).

Drawing facts: 15 words on screen (ROUND, FIGHT, WORK THE BODY, DROPS THE RIGHT, TIRING, HANDS UP, BEST, BODY, TIE UP, names aside). Smallest type 24 px; key numbers 32-52 px. About 60% of the picture is clear (panels 28%, top bar 6%, bottom bar 6%). Never he/she.

## 1. THE LOOK, 0-10: 6 (B as drawn)
Good: one panel per boxer, face plus body so the six places read as pictures; tanks have icons; the unknown side is dashed, hatched and "?". Colours separate the sides.
Hard-fail check: no type under 22 px (smallest is 24: pass). No bare number: the three tank numbers sit under icons but the icons are 40 px away at the tank top; the 74/90 body rings carry no word or icon of which organ (the liver is only a side). Meter meaning needs no manual (pass). No list (pass). Coverage about 40% (pass). So no cap, but the look stays at 6 because it is STILL: the panel is a lot of equal-weight rings and the eye has no ranking. Nothing tells the eye which of 20 numbers moved.
What a feel designer sees: the picture is right, the motion layer is the missing half. A fight HUD is judged at 60 fps, not in a still.

## 2. WHAT IT SHOWS, element by element (KEEP / CHANGE / CUT; what the player learns or does)
- Head ring (41), left eye (49), right eye (63), nose (58), two rib rings (68, 90): KEEP as radial gauges, CHANGE from a plain number ring to a gauge that fills with the remaining share, with a doctor tick at 15 and a white ghost arc for the last 2 seconds of loss. Learns: where the damage is and how fast it came. Does: Aim call, gloves-high or elbows-in fix, cutman job.
- Liver side (right ribs): CHANGE, give it its own organ glyph inside the ring and a pulse ring when hit. It is the one place a single punch can end a fight (body shot, count) and the player has a plan line for it ("work the body" is also what Erin can do to Lucy).
- Face close-up with the cut and the closing eye: KEEP. CHANGE the eye so the slit narrows as the eye ring falls; the picture IS the meter. Learns: an eye is closing. Does: ask the cutman card in the corner minute, tell the boxer to keep hands up.
- Energy, Legs, Guard tanks with band ticks: KEEP the three tanks, CHANGE each to a ghost-bar tank (bright fill, white ghost where it just was). Drain arrow KEEP and CHANGE to a number per 30 s (a rate you can act on), amber down, green up.
- Punch counts 4/12, head 3, body 1: KEEP as a quiet footer, no motion except a 0.3 s tick when it changes. A is better here: the tug bars compare, so TAKE A's landed-this-round tug bars into the footer, one row, not four.
- Exchange blocks (six): KEEP; the running block fills like a clock over 30 s, the winner colours it with a 0.4 s wipe. Learns: who is winning the round. Does: decide to switch the call or hold.
- Clock: KEEP; turns amber and ticks at 0:10.
- Fight bar (tug): KEEP and CHANGE to carry a ghost tick where it stood at the start of the round. Learns: the trend, not just the level.
- Plan chip (WORK THE BODY): KEEP; lights for 1.2 s when a landed punch fits the plan (the plan paying off, the Why's "right answer" made visible live) and goes grey-amber when a plan line is being punished.
- Scouted habit chip (DROPS THE RIGHT): KEEP; it must PROVE itself live: the eye icon pulses once when the habit appears in the ring, and the chip gets a tally of times seen.
- Unknowns on the opponent: KEEP as dashed rings with "?". One extra rule: a range appears (hatched band) only after a scouting tell, never before.
- Corner call with three effect chips: KEEP the best call big; CHANGE its timer from a ring far away to the card's own bottom edge draining, with the ring kept as a tiny echo left. The two other calls: KEEP small and key-numbered; CUT the idea of showing all effect chips on them (hover only).
- Timer ring: KEEP; resets with a soft thump each 30 s.
- Big-shot burst: KEEP, but it must be anchored to the actual impact in the ring, with the number travelling to the damage ring (see hint 4).

## 3. THE HINTS (ranked by how much they change a player's decisions)
Each: TRUE / SHOWN (element, colour, motion, sound, seconds) / DONE. "Scouted-only" marked.

1. TRUE: the last call is not working (Lucy lost two of the last three exchanges after it). SHOWN: the call card's gold glow, which was steady, goes to a 1 Hz amber-to-grey pulse for 3 s, the two exchange blocks since it was shouted get a thin strikethrough bar; a low two-note falling sound once. Must NOT fire on one lost exchange (needs two), and must not fire in the first 5 s after the shout. DONE: shout another call, or switch the plan line in the minute.
2. TRUE: Lucy's liver side has taken a shot and the body is the weak place. SHOWN (mark 2): the liver ring gives a 0.5 s red ripple (two rings expand from 24 px to 44 px, opacity 0.5 to 0), the number flashes white 0.12 s then counts down over 0.6 s while a white ghost arc holds 2 s and drains; a dull low thud 0.2 s louder than a head shot; the whole left rib area dims red-tinted for 1.5 s. Fires only on a landed body punch worth 3 points or more. A chip of 1-point touches never animate (noise). DONE: Hands up call, Gloves high fix, or training the body next week (the body report's button).
3. TRUE: an eye is closing and the next clean shot may bring the doctor. SHOWN (mark 3): eye ring crosses 55 (amber) and the picture swells: the slit narrows in 0.8 s; at 35 the ring pulses amber at 0.7 Hz and the doctor tick at 15 glows. Steady while above 35 (no pulse, just the swelling picture). At 15 the ring is solid red with a thin white outline and a single bell tone. Never a pop-up (agreed). DONE: cutman job in the minute, tell hands up, accept the stop-or-go choice.
4. TRUE: that punch was Erin's big hook and it cost 12. SHOWN (mark 4): the burst appears at the impact for 0.25 s in the ring, the number -12 rises 40 px over 0.5 s, then a comet (0.45 s) carries it along a dotted arc to the head ring, which takes the hit exactly at arrival (ghost arc, flash, thud synced to the arrival, camera nudge 4 px for 0.1 s). The tie is the whole point: the player sees WHICH punch cost WHICH place. Fires only on shots of 8 or more; smaller hits skip the comet and just tick the ring. DONE: nothing at that second; it teaches the value of Hands up and what a hook costs; next week trains Defence.
5. TRUE: Erin tires (scouted: habit "drops the right" after the jab; tired boxers drop it more). SHOWN (mark 5): Erin's guard tank is hatched (unknown) but the opponent figure in the ring draws a faint dashed arc where the right glove should be (a 0.6 s fade in and out each time the glove drops), the eye on the habit chip blinks once. TIRING gets a blue drop that falls every 3 s only while Erin is truly under 40 energy; it stops when Erin recovers. Scouted only. Unscouted: no arc and no eye chip, the chip says nothing and the drops still show (tiredness is visible in the ring). DONE: Draw the lead, Let hands go, or Go for the finish.
6. TRUE: Lucy's Energy is draining faster than normal (a flurry or a plan on Push). SHOWN (mark 1): energy tank's white ghost segment above the fill, holds 0.4 s then slides down over 1.2 s; the arrow figure beside the number (per 30 s) turns from amber to red under 40; fill colour ramps yellow to orange to red at 40 and 20; below 20 the tank edge pulses 1.5 Hz and the sound of heavy breathing fades in under the crowd. Steady drain never flashes: only a step bigger than 5 in one exchange. DONE: Breathe pick your shots, Save pace, Tie up.
7. TRUE: Guard is low, so head shots land cleaner. SHOWN: the shield tank fill ramps blue to dull grey-blue under 35 and the face close-up shows glove-shaped dark marks beside the face; the shield icon cracks (a 0.3 s hairline) only when it passes 35. DONE: Hands up, move your head.
8. TRUE: Lucy is hurt (rocked). SHOWN: the whole left panel gets a 0.25 s red vignette inward pulse, the face wobbles 2 px for 0.6 s, the ring audio ducks the crowd 3 dB for 1.5 s and a ringing tone fades in then out; the call buttons that fit (Hands up, Tie up) get a gold outline. Fires once per rocking, never repeats. DONE: Tie up or clear the head in the minute.
9. TRUE: Erin answers the jab with a right hand every time. SHOWN (scouted only): the habit chip gains a small counter dot each time it happens in this fight (dot fills 0.2 s). After the third, the chip turns gold and a ghost glove arrow shows in the ring where the counter will come. Unscouted: it never appears; after three seen in the ring the chip appears as "?" dashed, so the player learns there is something to look for (learning by watching, then confirmed in camp). DONE: Draw the lead; write the plan line next fight.
10. TRUE: the fight bar crosses from Lucy's side to Erin's. SHOWN: the marker slides over 0.6 s with a soft whoosh, leaves a white ghost tick where it started the round; the side that took over flashes the bar edge once for 0.3 s. Never flickers: the marker moves only at the end of an exchange, never mid-exchange. DONE: decide whether to push or save.
11. TRUE: the round is nearly over with a close card. SHOWN: at 0:10 the clock turns amber and ticks, a thin white line draws around the exchange blocks; at 0:00 a bell, the six blocks collapse into the round result (10-9) for 1 s. DONE: spend the last call and plan the minute.
12. TRUE: the call just shouted fits (best) or does not (wrong). SHOWN: the card flares gold with a star and a rising chirp (best) 0.4 s after the shout; or dims red with a flat buzz (wrong) and the effect chips flip sign colour. Fires once per call. DONE: next call, trust the corner card.

Scouted-only honesty: hints 5 and 9. The unscouted look: dashed outline, "?" and no motion; only things seen in the ring (tired drops, glove falling) animate, because they are true without a scouting file. Unknowns never pulse (a pulsing "?" says there is something, which is cheating).

## 4. WHAT IS MISSING / USELESS
Missing: (a) a sound plan (nothing in B or A says what each change sounds like; the ear carries the hints so the eye can stay on the ring). (b) A 3 s "since your call" chip showing the result of the last call in the three effect chips' own terms (+4 guard so far). (c) A recovery tick between rounds so the minute can open from the same display. (d) A card estimate pip (rounds won so far) on the scorebug; A has it, B dropped it; take it back.
Useless: the 20 numbers shown all at 36 px alike: only 3 should ever be big; the rest 24 px until they change. The "?" rings on three places next to each other: collapse to one dashed silhouette, "?" only where a tell is known. The call buttons Body/Tie up with no effect chips beyond hover: fine; do not widen them.

## 5. THE MOMENTS (one line each)
- Knockdown and count: the panels fade to 30% except the downed boxer's, the big number counts 1..10 in the centre at 1 per second with a thud each, the called-against call row collapses; a ring on the heart tank (energy) ticks recovery.
- A cut: a red streak draws across the face, the eye or head ring flashes, a short flesh tearing sound, a cut icon sits on the ring until closed.
- Hurt (rocked): hint 8.
- Last 10 seconds: hint 11, nothing else moves louder.
- Corner minute opening: panels slide in toward the middle 60 px over 0.4 s, tanks refill to the recovery forecast as ghost bars, the call card is replaced by the three recovery points, the clock becomes a 1:00 ring.

## 6. SCORES (0-10)
- Look: 6 (B as drawn; 7 with mine, held at the stage because it is a frozen frame)
- Read in two seconds: 7 (the tug bar, the call card, the two faces; but the body numbers compete)
- Depth for the player who looks longer: 7 (ghost bars and trends are the missing depth; the three tanks, six rings and counts are there)
- How well it teaches: 5 (nothing moves, so nothing is learned by watching)

## 7. HOW TO REACH 10/10 (most important first)
1. Build the motion grammar as ONE small module: events in (landed punch with place and size, call shouted, state change) and effects out with fixed timings (flash 0.12 s, ghost hold 0.4 s then drain 1.2 s, pulse 0.5 s, ripple 0.5 s, comet 0.45 s). All hints use it, so the display feels like one thing.
2. Gate every effect by size: nothing under 3 points on a place, nothing under 5 on a tank, nothing that repeats within 2 s. Quiet by default; the player must trust that a flash means something.
3. Tie each number to its punch: the comet from the impact in the ring to the damage ring, timed to the 3D hit. This is the single biggest teacher.
4. Add the sound layer: one low thud for body, a sharper crack for head, a falling two-note for a failing call, a rising chirp for a best call, a bell tone for the doctor line. Keep sounds off by default for hints 6 and 11 below the threshold.
5. Ghost bars on the three tanks and every damage ring; a trend arrow per 30 s on energy only.
6. Face and body as the meter: the swollen eye narrows, the head ring reddens, a rocked boxer wobbles. One picture per fact.
7. Make the opponent honest: dashed "?" and no motion unless scouted or seen in the ring; ranges only after a tell.
8. Wrong-call and best-call flare (hint 12) so the corner learns its own record live.
9. Cut flat numbers: only the ones that moved in the last 4 s are big; the rest dim to 60%. This is the "eye is led" rule: motion draws, stillness recedes.
10. Add the card pip and 0:10 clock rule from A.

## 8. THE DRAWING
`docs/mockups/s419/fight_critic_feel.png` shows (frozen frames, numbered):
1 ghost bar on the energy tank (white segment where the fill just was, 66 to 58) with the drain arrow.
2 liver ripple (two rings around the 68, white ghost arc where it dropped from 90).
3 closing left eye (49, amber, narrowed purple slit, doctor tick on the ring).
4 the big hook: the burst at the impact, -12 rising, a dotted comet flying to the head ring (41 with a white ghost arc).
5 Erin's dropped glove: dashed arc in the ring plus the eye chip (scouted).
6 the call card: gold glow, effect chips (+12 guard, -2 head, -1 energy), BEST, timer draining along its bottom edge.
7 the fight bar's ghost tick where it stood at the round's start, the marker now past the centre.
