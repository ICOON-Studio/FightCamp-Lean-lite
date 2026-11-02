# Kalli reply (Grok bot via gbot, S235, 7756 chars, verbatim)

PART 1 of 2. A Sparring Flash Moment is a 3-second exchange the ring plays from the real fight engine when a trigger fires. The player then makes one call out of 2 or 3. A block holds at most 2 moments, and the calls move card progress, readiness, strain, risk and morale. There is no timing input, only a judgement.

**1. When a moment fires**
- **Cap:** at most 2 per sparring block (a 60-90 minute block) and 4 per day. The first one never fires before 10 minutes into the block.
- **Base roll:** every 10 game minutes of sparring, 15%. The rate goes up with the following triggers and only one fires at a time.
  - **Card in play:** the drilled move card's trigger happens in the exchange (the partner jabs and the 1-2 counter is on him). +20%.
  - **Stat gap:** the partner is 15 or more points above him in a matching stat (speed vs speed, power vs chin). +15%.
  - **Fatigue:** his stamina is under 35, or strain is over 60. +15%.
  - **Style match:** the partner's style matches Friday's opponent (swarmer vs swarmer). +10%. This is the readiness hook.
  - **Wear:** a region is over 50% worn and the partner's style targets it. +10%.
- **Priority when several apply:** card, then style match, then fatigue, then stat gap, then wear.

**2. What the player sees and the calls**
- **0.0s:** the camera holds the mid view on the ring with no broadcast cut. A thin brass frame lights round the ring.
- **0.0-3.0s:** the engine plays the exchange live, such as a jab, his slip and the counter. If the moment is a hurt one, the engine plays a 0.5s slow beat on the impact frame.
- **3.0s:** the day clock pauses and a small card rises beside the ring, never over it. It has one line under 60 characters ("He's slipping the jab but not punching back") and 2-3 call buttons with their numbers in the tooltip. If no call is made in 20 seconds of real time, the coach's default call goes in, so a card never blocks.
- **The calls (base values; the table below tunes them per moment):**
  - **STAY IN THE POCKET:** +15% card progress for the rest of the block, +4 readiness if the style matches, +6 strain, cut risk +3% this block.
  - **PULL HIM OUT:** the block continues as technical work. Card progress +5%, strain -4, no risk, morale -1 if he was winning the exchange.
  - **LET THE PARTNER TURN IT UP:** the partner's output goes up 20% for the rest of the block. Card progress +25%, readiness +6 on a style match, strain +10, knockdown risk +5%, cut risk +5%, morale +3 if he wins the next exchange and -3 if he doesn't.
  - Some moments add a fourth effect, a stored tell ("Tell banked") or a wear change on a region.

**3. Ties to Gameplan Readiness and Corner Rehearsal**
- **Readiness (0-100, built by drilling Friday's opponent's counters):** only style-match moments, plus card moments where the card is a counter in the gameplan, move readiness. The tooltip says so ("Friday's opponent is a swarmer. This counts"). The cap is +12 readiness per day from sparring, so drilling stays the main source.
- **A tell banked in sparring:** it shows up in the fight-night corner card as the chief's line ("She drops the right on the hook. You saw it Tuesday"). It also lights the matching counter on the readiness bar.
- **Corner Rehearsal:** a block with a moment ends on the Corner Rehearsal card with that moment's result as its first line ("Pocket held. Card +18%, strain 61"). The default next call follows from the moment: a hurt moment defaults to "ice the region", a won one to "push the same station". The two systems share one card grammar, so the floor teaches the fight-night corner.
- **Load Ledger:** every strain point from a call is spent from the weekly ledger. A ledger over 85 adds a warning line on the call ("Over budget: injury roll doubles").

PART 2 of 2

**4. What it must NOT become**
- No timing input, no QTE, no clicking inside the exchange. The exchange plays first, the call comes after, and the player decides on what they just watched.
- No more than 2 a block. If moments fire often, the ring becomes a pop-up machine.
- No scripted outcome. The exchange comes from the real engine, and the call shifts weights and risks. It never decides the next exchange.
- No call without a cost. Every call trades something (progress vs strain, readiness vs risk), so no option is always right.
- No blocking. The 20-second default means a player who walks away loses nothing but the choice.
- No broadcast camera or fight HUD. It stays a gym moment in the gym's view, at the gym's CPU cost.

**5. The moments**
Format: id | trigger | text (60 characters or less) | calls | effects
1. `pocket_slip` | card in play (counter card) | "He's slipping the jab but not punching back" | POCKET / PULL / TURN UP | base values; POCKET +5% extra card progress
2. `counter_lands` | card in play, counter landed | "The 1-2 landed off her jab. Again?" | POCKET / TURN UP | POCKET +20% card progress; TURN UP +30% card progress, +5 readiness on a style match
3. `swarmer_crowd` | style match (swarmer) | "Partner's walking him down like Friday's opponent" | POCKET / PULL / TURN UP | POCKET +5 readiness; TURN UP +8 readiness, +10 strain
4. `outside_stuck` | style match (out-boxer) | "He can't close the distance on the long jab" | CUT THE RING / PULL / TURN UP | CUT THE RING +6 readiness, +5 strain, footwork +1 stage progress
5. `gassed_guard` | fatigue (stamina under 35) | "Hands are dropping. He's tired" | PULL / POCKET | PULL: strain -6, stamina +10, no risk. POCKET: +10% card progress, knockdown risk +8%
6. `strain_grind` | fatigue (strain over 60) | "He's grinding through it. Shoulders are tight" | PULL / POCKET | PULL: strain -8. POCKET: +8 strain, niggle chance +15% on the arms
7. `speed_gap` | stat gap (partner faster) | "Partner's beating him to every punch" | POCKET / PULL / TURN UP | TURN UP: speed +1 stage progress, morale -2 if he loses the next exchange
8. `power_gap` | stat gap (partner hits harder) | "That right hand shook him" | PULL / POCKET | PULL: morale -1, no risk. POCKET: chin test, knockdown risk +10%, composure +1 stage if he survives
9. `old_eye` | wear (head_neck over 50%) and partner targets the head | "He's catching shots on the cut side" | PULL / ICE AFTER / POCKET | PULL: wear stays. ICE AFTER: head_neck wear -10 at block end, ends the block 20 minutes early. POCKET: cut risk +12%
10. `body_shot` | wear (torso_core over 50%) | "Body shot. He folded a little" | PULL / POCKET | PULL: torso wear +2. POCKET: torso wear +6, defence +1 stage progress
11. `tell_spotted` | style match plus a scouted opponent | "Partner just did Friday's tell. Did he see it?" | BANK IT / DRILL IT NOW | BANK IT: tell banked, readiness +4. DRILL IT NOW: the next 20 minutes drill the counter at +30%, readiness +8, tell banked
12. `heated` | stat gap plus low composure | "It's getting heated. Partner wants a war" | CALM IT / TURN UP | CALM IT: morale +2, composure +1 stage. TURN UP: +8 readiness on a style match, strain +12, knockdown risk +8%, cut risk +6%

**6. A real game that does it well: Punch Club 2**
Its sparring and practice beats show a short exchange, then hand the player a choice whose cost is plain: pushing builds stats but burns health and energy. Copy two things. The choice comes after the action, never during it, and the cost is printed on the button. Don't copy its grind of repeated taps.

I argued against the 2-a-block cap with the case that more moments means more fun. A ring that interrupts every 15 minutes trains the player to hit the default without reading, though, and that kills the call's weight. Two stays.

Not computed: whether the engine can play the 3-second exchange in the gym view within the CPU budget, and whether +12 readiness a day from sparring outruns drilling.
