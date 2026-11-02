# K-FIGHT3D1 - Kalli's answer, verbatim (8947 chars, 2026-10-28 S298)

**PART 1 of 3**

**1. Round length**
- **Full mode:** 40 seconds per round, whatever the real round length (2 or 3 minutes). A 3-round bout plays in about 2 minutes, and a 4-round pro debut in under 3.
- **Highlights mode** is the default. Only the beats that land play, about 15 seconds a round, with an idle cut between them.
- **Speed:** 1x and 2x on one icon button with a tooltip. Space toggles it.
- **Skip:** a SKIP ROUND icon jumps to the bell and the cards. SKIP BOUT jumps to the result. Skipping never changes anything, because the result was decided before the watch.
- **Arguing against myself:** 40 seconds may still feel long by the fifth bout. A fallback of 25 seconds in full mode is reasonable. The right length is NOT COMPUTED until someone plays it.

**2. What happens in one round**
- **Exchanges:** 8 to 10 beats, where a beat is one move by one boxer, so about one every 4 to 5 seconds in full mode.
- **Landed punches:**
  - Close round: the winner lands 4 and the loser 3.
  - Clear round: 5 against 2.
  - Dominant round: 6 against 1.
  - Every other beat is blocked, a miss, or footwork.
- **Making the winner readable without the words.** There are three signals and every round uses all three:
  - **Who moves forward.** The round winner does all the step_in beats. The loser does all the step_out beats and ends nearer the ropes.
  - **Who lands last.** The final landed punch before the bell is always the winner's.
  - **Who reacts.** Only a clean landed blow plays a hit reaction. A dominant round also gets one knockback on the loser.
- **Out-boxer exception:** when the winner is the out-boxer, the first signal flips. She steps out and lands as the other woman comes in. The other two signals still hold.
- **Corner call effect:** the next round's first two beats show the call, for example two jabs for "box behind the jab", a body_hook for "go to the body", or a step_out off the ropes for "stay off the ropes". The call's caption runs over them.

**PART 2 of 3**

**3. What's on screen during the round** (the minimum)
- **Scorebug, top left:** both names, the round number and the clock (scaled to the 40 seconds), and nothing else. No punch counter. A counter invites the player to argue with the cards, and the cards are already final.
- **Captions, bottom centre, one line at a time:** these are the round's existing word lines, tied to the beats they describe. There are 3 to 4 a round, so not every beat gets one.
- **After the bell:** the three judges' 10-9 cards for that round, plus the running total, on the existing card panel for 3 seconds, or until clicked.

**4. Between rounds**
Cut to the same 2D corner picker over a dimmed, frozen frame of the ring. Don't build a 3D corner with a stool and coach. That's new animation, new cameras and new staging, and it shows nothing the picker doesn't. The next round opens straight on the call's beats, so the player sees their shout pay off.

**5. Camera**
- One broadcast camera: high three-quarter from the apron, with a slow drift to keep both women in frame.
- One cut per round at most. The round's biggest landed punch gets a 1.5-second close-up when it lands.
- No replays in version 1. A replay doubles the time the round takes and needs its own camera logic.
- A knockdown is the exception: it always gets the close-up and a 2-second replay at half speed, from the same close-up camera.

**6. Endings, in the fewest shots**
- **Decision:** bell, both women walk to neutral (just an idle plus a step), cut to the cards panel, then the result card. That's 2 shots.
- **Draw:** the same as a decision. The result card reads DRAW and neither boxer plays a winner pose.
- **Knockdown, not the end:** the punch, the close-up, and the knockback into a fall (the knockout-loser clip cut short). Then a caption reads "Count. She's up at six." and the round carries on. She stands up with a guard idle blend, and nothing new is built. NOT COMPUTED: whether the cut-short knockout clip reads as a knockdown and not a knockout.
- **Stoppage:** the punch, the close-up, then the knockout winner and loser clips. A caption reads "Referee stops it, round {n}.", then the result card. That's 3 shots.

**7. Not in version 1**
- No 3D corner, ref model, crowd animation, sound or commentary.
- No replays except on knockdowns.
- No punch stats, health bars or stamina bars.
- No live camera control by the player.
- No clinch (there's no clip; it stays in the format but doesn't play yet).
- No combinations blended inside one beat. Each beat is a single clip.
- No round-to-round fatigue look, cuts, swelling or blood.
- No walkouts or ring introductions.
- The older clips (rear uppercut, body hook, slip) only go in if they import cleanly on day 1. If not, swap body_hook for lead_hook and slip for step_out.

**PART 3 of 3**

**8a. The rule from the round winner to the beats**
- **Landed punches by margin:**
  - Close: the winner lands 4 and the loser 3.
  - Clear: 5 against 2.
  - Dominant: 6 against 1, plus one knockback.
- **Margin from the cards:** close if one judge or more scores the round the other way. Clear if all three give it 10-9. Dominant if any judge gives 10-8.
- **The rest of the round:** fill to 9 beats with blocked punches, misses and footwork. The loser gets more of the blocked and missed beats.
- **Order:** the winner always has the final landed beat. In rounds 2 and up, the first 2 beats show the corner call.
- **Timing:** beats are spaced over the round's seconds, 3 to 6 seconds apart, and the last beat comes at least 2 seconds before the bell.

**8b. Example bout:** Lucy Hart (a) vs Holly Marsh (b). Lucy wins 2-1: round 1 clear for Lucy, round 2 close for Holly, round 3 close for Lucy. The corner call after round 1 was "Box behind the jab" and after round 2 "Go to the body".
```json
{"rounds":[
{"n":1,"winner":"a","seconds":40,"beats":[
{"t":2.0,"who":"a","move":"jab","result":"lands","caption":"Lucy finds the jab early."},
{"t":6.0,"who":"b","move":"step_in","result":"none","caption":""},
{"t":7.5,"who":"b","move":"cross","result":"blocked","caption":""},
{"t":11.0,"who":"a","move":"jab","result":"lands","caption":""},
{"t":15.0,"who":"b","move":"lead_hook","result":"lands","caption":"Holly lands a hook coming in."},
{"t":19.5,"who":"a","move":"cross","result":"lands","caption":""},
{"t":24.0,"who":"b","move":"jab","result":"misses","caption":""},
{"t":28.5,"who":"b","move":"cross","result":"lands","caption":""},
{"t":33.0,"who":"a","move":"jab","result":"lands","caption":"Lucy doubles the jab and walks Holly onto the right hand."},
{"t":35.0,"who":"a","move":"cross","result":"lands","caption":""}
],"end":"bell"},
{"n":2,"winner":"b","seconds":40,"beats":[
{"t":2.0,"who":"a","move":"jab","result":"lands","caption":"Box behind the jab: Lucy starts long."},
{"t":4.5,"who":"a","move":"jab","result":"blocked","caption":""},
{"t":9.0,"who":"b","move":"step_in","result":"none","caption":"Holly walks through the jab."},
{"t":11.0,"who":"b","move":"lead_hook","result":"lands","caption":""},
{"t":15.5,"who":"a","move":"step_out","result":"none","caption":""},
{"t":19.0,"who":"a","move":"cross","result":"lands","caption":""},
{"t":23.5,"who":"b","move":"body_hook","result":"lands","caption":"Holly digs to the body on the ropes."},
{"t":28.0,"who":"a","move":"jab","result":"lands","caption":""},
{"t":32.0,"who":"b","move":"step_in","result":"none","caption":""},
{"t":34.0,"who":"b","move":"cross","result":"lands","caption":"Holly lands last. Her round."},
{"t":36.0,"who":"b","move":"lead_hook","result":"lands","caption":""}
],"end":"bell"},
{"n":3,"winner":"a","seconds":40,"beats":[
{"t":2.0,"who":"a","move":"body_hook","result":"lands","caption":"Go to the body: Lucy rips one under the elbow."},
{"t":5.0,"who":"b","move":"cross","result":"blocked","caption":""},
{"t":9.0,"who":"b","move":"lead_hook","result":"lands","caption":""},
{"t":13.0,"who":"a","move":"slip","result":"none","caption":""},
{"t":14.0,"who":"a","move":"cross","result":"lands","caption":""},
{"t":19.0,"who":"b","move":"step_in","result":"none","caption":""},
{"t":21.0,"who":"b","move":"rear_uppercut","result":"lands","caption":"Holly finds an uppercut inside."},
{"t":26.0,"who":"a","move":"body_hook","result":"lands","caption":""},
{"t":30.0,"who":"b","move":"jab","result":"misses","caption":""},
{"t":33.0,"who":"b","move":"cross","result":"lands","caption":""},
{"t":36.5,"who":"a","move":"cross","result":"lands","caption":"Lucy lands the last clean shot of the fight."}
],"end":"bell"}
]}
```
In round 1, Lucy lands 5 and Holly 2 (clear). In round 2, Holly lands 4 and Lucy 3 (close). In round 3, Lucy lands 4 and Holly 3 (close). The `seconds` field is the watched length, not the real round length.

**Kit gaps:** there's no clinch clip, no standing-up-from-a-knockdown clip and no referee. Whether the body hook, rear uppercut and slip clips from the older pipeline import cleanly is NOT COMPUTED.
