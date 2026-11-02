# K_CORNER_ICE_S321_KALLI - Kalli answer (seat queue SQ23)

Brief: research/K_CORNER_ICE_S321.md
Sent: 2026-10-31 10:10 | collected: 2026-10-31 10:40 by Tools/seat_queue.py (the 30-min reconcile)
Verify the sources before using it.

---

It's fun only if a choice is rare and real. Make the tap skippable by default, and make it urgent only when two problems compete. Full answer coming in parts.

**PART 1 of 2**

**Recommendation:** keep Claude's plan, with three changes.
- **The corner works itself by default.** The cutman, or the amateur coach, auto-picks the worst problem. The figure only asks for a tap when there's a real conflict: two problems, one pair of hands. With nothing wrong, the figure shows CLEAN and the corner is just the call.
- **The player's whole decision is one tap: what to leave untreated.** Show both wounds glowing, and the tap says which one to let go.
- **Show the cost of the choice next round, in the words and in the 3D, every time.**

**1. Is it fun across a career?**
- **Where it goes stale:**
  - Most corners have no damage, so a tap there is just a chore.
  - A dominant answer would also kill it. If "close the cut" is always right, the player taps it like a reflex by fight three.
  - Neck ice adding composure every corner becomes a free buff the player always takes. That makes it a tax, not a choice.
- **How to stop it:**
  - No conflict, no tap. The default is good, so most corners take two seconds.
  - Real choices should come about 1 corner in 4 at most in a hard fight, and 0 in an easy fight. That's NOT COMPUTED and needs a playtest.
  - Neck ice is only offered when composure is low AND no wound needs those hands. Then it competes for real.
  - Let the opponent drive variety. A puncher with a hook opens the left eye, a jabber swells both, a cut-prone fighter bleeds. The film study tells the player which problem to expect, so it ties back into the rest of the game.
  - Escalation inside a fight: a wound left untreated gets worse. The tap made in round 2 sets up round 4's dilemma.
- **Arguing against myself:** maybe automating 3 corners in 4 hides the feature, so players never learn it. The answer is a teaching corner in the first bout where it happens, plus a short reason line on every corner the coach handles alone ("Coach iced the left eye.").

**2. What makes the dilemma real**
- **Two wounds that hurt in different ways:**
  - The cut bleeds into her eye. Next round her defence drops and the doctor risk grows.
  - The swelling closes the eye slowly. Her vision on that side is gone in 2 rounds.
  - Composure falls, so habits start to fire (loads_up_when_hurt, freezes_on_ropes).
  - Each is a different kind of loss: losing rounds, the doctor stopping the fight, or bad habits.
- **One pair of hands, or two:**
  - In the amateurs there's one pair: work the wound or give the full instruction.
  - In the pros there are two pairs: the cutman's job plus one ice spot.
  - In both, there's always one problem more than there are hands.
- **The round matters:**
  - Late in the fight, if she's ahead on the cards, survival beats sharpness, so close the cut.
  - Behind on the cards, she needs her eye and a full instruction to win the round.
  - The scorebug shows the cards, so the player can weigh it.
- **Hidden traits change the answer:** with high heart, ignoring the swelling is safer. A low-temper fighter with low composure needs the neck ice more than her eye does.

**PART 2 of 2**

**3. What the player sees after the choice**
- **In the same corner, straight away:**
  - The treated wound goes from red to amber on the figure. The untreated one stays red and gets a small "+" icon with a tooltip saying "Will get worse next round".
  - One coach line: "Cut's shut. Left eye's going to be a problem."
  - In the amateurs, the instruction slot shows the half-call greyed with a tooltip, "Short call: you worked the cut", so the cost shows before the bell.
- **Next round:**
  - The first caption names the choice: "The cut holds. {name} can see." or "The left eye is closing. She can't see the hook."
  - The 3D gets one beat tied to the untreated wound, an opponent's punch landing on that side. It plays from the round script and decides nothing.
  - The figure updates live on the side panel. Blood only runs if the cut was left.
- **After the fight:** the result's "what decided it" line names a corner choice when it mattered, for example "Closing the cut in round 3 kept the doctor away."
- No numbers on screen. Plain words, icons and tooltips.

**4. Cut, change or add**
- **Cut:**
  - Ice as a stamina refill, as your research says.
  - Tapping the figure when there's only one wound, since the default handles it.
  - Any timing or minigame in the corner. Ludo cut QTE mechanics, and a corner must stay a judgement call.
  - Blood running every round regardless of state, which turns into noise. Blood shows only when a cut is open and untreated.
- **Change:**
  - The neck ice gives composure only below a threshold, so it's never a free top-up.
  - The doctor's check is a visible risk word on the figure (LOW, WATCH, DANGER), never a hidden roll.
  - In the amateurs, the "one instruction" penalty means a short call with half its usual effect, not losing the call outright.
- **Add, using known patterns:**
  - **Triage under scarcity:** more problems than hands every time the tap appears.
  - **Readable consequence:** every decision gets one visible payoff line next round.
  - **Escalating clocks:** an untreated wound climbs one step a round, so delay has a price.
  - **Smart defaults with an override:** the AI handles routine corners, and the player steps in only for the interesting ones.
  - **Pre-match planning that feeds in-match choice:** film study warns which wound to expect, and the camp can drill cut work for a cutman perk later.
  - **Personality as a modifier:** traits change which wound matters most, so the same wounds play out differently for different fighters.

**Open (NOT COMPUTED):**
- How often a real conflict comes up in a full career.
- Whether 1 corner in 4 feels rare enough.
- Whether the amateur half-call penalty is harsh enough to make the choice hurt.
