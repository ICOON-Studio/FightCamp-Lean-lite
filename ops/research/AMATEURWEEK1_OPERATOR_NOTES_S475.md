# AMATEURWEEK1 v8 - the owner's notes (S475, board answer to Q-S294-229, 2026-11-14)

His words, verbatim:

> 4.1 looks like useless logistics and painin the ass for the player, either remove it or adjust it. make the sparring partner
> mandatory maybe we need a screen where left side is players fighter in the middel is a list of sparring partners and ton the
> right athe opponents card (whatever its know about him) so the player can make comparison and decide what sparring partner he
> needs.4.4 is connected to other things likescouting and film ? 4.8 i want to be clear and aeasy for the player to see the
> ladder and find an opponent and book a fight season ladder needs tobe at least 9/10 (maybe make reputation play bigger role in
> amateurs and pro fights instead of using set number of fights required for soemthing,this way the player can think of other
> ways to get the benefits o higher reputation)) , there many games out there that can help you get there. "TRUTH: a SEEN tell
> is true 70 in 100 (ESTIMATE). A tell whose mode came up and didn't show is cleared as false. A tell whose moment never came
> stays SEEN." : how is this shown to the player ? "The choice is right one way or the other depending on how many lines rely
> on one tell." : need toexplain tome how this works . How is mood gained and whatiaffects ? I am not sure about the trip
> mechanic. I want to see 9s frame.

## What this changes in the map (Claude, S475)

1. **4.1 WHERE TO TRAIN is cut as written** (trips, food, cottage, commute, coach away). It becomes **CHOOSE A SPARRING PARTNER**,
   mandatory for every sparring night: one screen, three columns -
   - LEFT: your boxer (style, the plan lines to be readied, stats that matter for the matchup);
   - MIDDLE: the list of partners available (club boxers in or near the weight, club members, partners at other clubs), each
     with style, size, level, cost (most are free; a partner from another club costs a favour or a fee), and what sparring
     him readies;
   - RIGHT: the opponent's card - only what is known (scouted / filmed tells, record, style word), the rest "?".
   The player compares and picks the partner who looks most like the opponent. The match between partner and opponent sets how
   much the night readies and how far the plan test can be trusted. The round-1 edge from 4.1 moves here (a close match gives it).
   The trips' "who pays" (4.6) goes with the trips; a fee for an outside partner is paid by the club.
2. **4.4 sparring is tied to scouting and film**: the partner list can only be matched to what is known about the opponent. A
   filmed tell ("leads with the jab", "fades late") shows on the right column and lets the player pick a partner who does the
   same; with nothing known, every partner is a guess. Sparring itself still never confirms a tell; only the fight does.
3. **4.8 SEASON becomes a ladder question for its own map (LADDER1)**: a clear season ladder - where the boxer stands, who is
   near, how to book them - scored 9/10 by critics, with REPUTATION as the main currency instead of fixed win counts (pro offer,
   championship seeding, show slots). Benchmark: other management games' ladders (research brief LADDER1_RESEARCH).
4. **Tells on screen** must show the player what SEEN 70 / 90 / CONFIRMED / CLEARED mean in plain words, on the opponent's card and
   on the plan line that relies on the tell (see Claude's explanation below). The map must draw this.
5. **Look again vs next group** must be explained on screen in one line, not left to the player to work out.
6. **Mood**: the map must say what moves mood and what mood does, using the game's real events (below).

## Claude's answers to his questions (from the map and the code, S475)

- **How is a tell's truth shown?** In v8 it is not drawn anywhere yet - only the tag on a plan line (SEEN 70). It needs: on the
  opponent's card each tell with a confidence word ("seen on tape - likely", "seen twice - very likely", "confirmed in the
  fight", "didn't happen - crossed out"), and the same word on each plan line that reacts to that tell.
- **"Look again or next group"**: a second film night either re-watches the same tells (they go from likely to very likely)
  or opens new ones (more tells, each only likely). If several plan lines react to ONE tell, making that tell surer pays more;
  if the plan reacts to many different things, seeing more tells pays more.
- **Mood (code today, FighterProfile.MORALE_EVENTS)**: a win +8, a loss -12, a bout booked +5, a rest week +4, a month with no
  fight -6, a goal met / missed, a night off given +4 / refused -4, her ask granted +5 / overruled -5, a corner call that worked
  +1 / went wrong -2. Heart softens losses, confidence scales gains, coachability softens being overruled. Mood words: Fired up
  75+, Steady 50+, Flat 30+, Low under 30. What it does today: a Low boxer stops taking in the corner's calls, and trust in the
  corner follows the mood word.
