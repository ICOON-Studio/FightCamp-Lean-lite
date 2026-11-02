# K87 - Kalli - The first corner is played

Answer first: the first fight always stops at the first bell. One corner card opens with the camp's plan already selected and a gold edge that says where it came from. The player can confirm it, change it, or let the clock run out, and the call goes in either way. No corner ever opens on NO INSTRUCTION again. Round 2 shows one line naming the call and the boxer visibly does it.

## 1. The first corner, second by second (45 s clock)

- 0.0 s, bell. Fight time freezes. The camera cuts to the corner stool (broadcast cut, 1.0 s). Mara sits; the chief second steps in.
- 1.0 s. The corner card slides up from the bottom centre. The 3D view stays live behind it; the ring centre is never covered.
- On the card, top to bottom:
  - Round strip: "ROUND 1: EVEN" (read-the-round verdict) and her stamina and the worst region as two small bars.
  - One line from the chief, under 60 characters, from the sim: "She's finding your left early."
  - THE CALL: three call buttons. The camp's call is lit teal with a gold "FROM CAMP" tag (icon `tent`, tooltip "See the camp that set this call"). Two other calls sit beside it, unlit.
  - Gold button: "SEND IT" (confirm). Small link: "Change call" is not needed; clicking another button changes it.
- 1-10 s. Tutorial "how" line (first fight only): "Click a call, or press SEND IT to keep the camp's plan."
- 10 s. If nothing is clicked, the lit call pulses once. No sound.
- 30 s. The clock bar turns amber.
- 45 s, or SEND IT. The call is sent. If the player waited, the card says "Camp's plan sent" for 1 s, so waiting is a choice, not a miss. The card slides down; round 2 bell.
- Cutman and doctor lanes stay closed in fight 1 unless there is a cut, swelling over the first threshold, or a knockdown (K86 fix 7). If one opens, it gets its own small row under THE CALL with its own default (Ice for swelling, Swab for a cut), so it never adds a second required click.

Why the default is the camp's plan: the player already decided what this fight is about when they set the camp focus. The corner repeats their own plan back to them, so the first corner teaches "your week shows up here" instead of "pick from a menu you have never seen".

## 2. Camp focus to default call

| Camp focus (training plan) | Default corner call | Why |
|---|---|---|
| Jab and distance | Keep her long | The camp built range |
| Pressure and volume | Walk her down | The camp built the engine |
| Body work | Go to the body | The camp drilled hooks to the body |
| Counter punching (the drilled 1-2 chain) | Wait and counter | The pad chain fires on her lead |
| Defence and head movement | Slip and score | The camp built the slip |
| Conditioning | Bank the round | The camp built late-round gas |
| No focus set (player skipped the plan) | Hold the centre | The neutral call; card tag reads "COACH'S CALL" in place of "FROM CAMP" |

Scouting adds one thing: if the camp bought the opponent's tell (Elena Perez drops her right when she lunges with the hook), the default call's chief line names it: "Her right drops on the hook. Wait for it." The call is the same; the reason is the scout.

How the player sees it came from the camp:
- The gold "FROM CAMP" tag on the lit call, with a tooltip "Open the camp that chose this".
- The same icon (`tent`) appears on the camp focus pin on the training plan wall in the gym, so the link is learned once.
- On the result card, one line: "Corner calls: 2 of 3 from camp."

## 3. Round 2 after the call

- One line on screen for the first 8 seconds of round 2, under the scorebug: "CALL: WAIT AND COUNTER - from camp" (or "from you" if changed).
- The boxer visibly does it: each call changes the fight AI's weights for that round only, and the change shows in movement.
  - Keep her long: more jabs, steps back after each exchange, less time at close range.
  - Walk her down: forward steps, more punches per minute, stamina drains faster.
  - Go to the body: dips into hooks to the body; body region on the opponent wears faster.
  - Wait and counter: stands her ground, fewer leads, the 1-2 chain fires when the opponent jabs.
  - Slip and score: more head movement, fewer power shots.
  - Bank the round: lower output, stamina recovers, she clinches when pressed.
  - Hold the centre: plants in the middle, average output.
- The read-the-round verdict at the next bell says whether the call worked ("ROUND 2: YOURS - the counter landed 4 times"). Results are never scripted; the call shifts odds, the sim decides.

## 4. Corners 2+ and later fights

First fight:
- Corner 1: always a stop (as above).
- Corners 2 and up: also stop, but the card opens with the PREVIOUS call lit (not the camp's) if the player changed it, so a changed plan sticks. Tag reads "FROM YOU".
- The "how" line shows only in corner 1.

Fights 2 to 4:
- Every corner is a stop by default.
- SIM TO RESULT on fight night asks once: "Skip the corner? The camp's plan will be sent every round." Two buttons: "Play the corners" (gold) and "Skip, send the camp's plan". The answer applies to that fight only.

Fight 5 and later:
- A setting in the corner card itself (small toggle `fast-forward`, tooltip "Auto-send the camp's plan every round"): auto-play the default. With it on, each corner shows the card for 3 seconds with the call that is being sent, then continues. The player can click during those 3 seconds to stop and play the corner.
- Auto-play always stops anyway when: a knockdown happened in the round, a cut or swelling opens the cutman lane, the doctor is called, the round verdict is "THEIRS" two rounds in a row, or it is the last round of a close fight (scores within one round).

## 5. Three ways it goes wrong, and the guard

1. Too slow. 45 seconds of a frozen fight every round for 10 rounds is 7.5 minutes of waiting. Guard: SEND IT ends the corner at once; the camp default makes "one click" the normal corner; from fight 5 auto-play runs 3-second corners; the clock bar is visible so the player knows they can leave.
2. Ignored. Players press SEND IT every time without reading. Guard: that is allowed (the camp plan was their decision), but the round 2 line and the next round verdict name the call, and the stop conditions force a real read when the fight turns (knockdown, two lost rounds, cut). The result card counts calls from camp vs from you, which teaches that changing a call is possible.
3. Feels fake. The call changes nothing visible, or the fight seems scripted to reward it. Guard: every call has a visible movement change in round 2 (section 3); the outcome stays a sim result, and the verdict can say "ROUND 2: THEIRS - she was waiting, Perez wasn't jabbing", so the player sees why a call failed.

Arguing against my own strongest ruling (the first fight always stops): forcing a stop on a player who just wants to see the fight can feel like a tutorial wall. It stays, because it is one stop of at most 45 seconds that SEND IT ends in one click, and the review's finding was that the heart of the game could be skipped without the player ever knowing it existed.

NOT COMPUTED: whether the AI weight changes per call are strong enough to be seen in one round at the current fight sim tuning; whether 3-second auto corners read on the broadcast camera.
