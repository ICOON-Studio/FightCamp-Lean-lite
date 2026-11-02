# FIGHTLINK - training shows in the fight (S248 direction, for the operator's OK)

The operator, S248 (verbatim): "should we focus on the training floor mechanics ( or let that just be animation without player
interference) or on mechanics and presentation ... that really simulate the training and its results to a fight (without silly mobile
mechanics of course) , give the player understand where the fighter lacks how strong he is , i do not even know how damage is
calculated,how the fighter chooses where to hit etc , how these can be regulated through training?" and on Q-S246-4: "build it only if
everything is shown to the player in a comprehensive way and [not] too complicated , my main concern is how all the training is
translated to the fight". Follow-up: "how skill training impacts how good a move is and how this shown in the fight".

Sources: research/FIGHT_SIM_MAP_S248.md (today's code), ludo_rx/LUDO_R114_raw.txt, LUDO_R115_raw.txt, ludo_rx/LUDO_OPERATOR_PANEL_S248.txt
(his own Ludo chat), Paul P28 ("Point the project at that link and at nothing else until it is on the camera").

## The answer in one paragraph
The training floor is NOT a clicking game and NOT wallpaper: you plan the day/week (stations, drills, intensity, sparring partner,
weight cut), the floor runs it on its own, and you step in only on exceptions (strain in the red, sloppy form, moving the coach).
All the depth goes into the LINK: every trained number changes something you can see in the fight, and the game tells you why.

## What gets built, in order (Ludo r114 4-week plan, cut to boxing and to what exists)
1. FIGHT MATH THAT CAN BE EXPLAINED (week 1) - the three holes in today's model:
   - EVASION: a punch can MISS (today defence only softens a landed punch). P(whiff) = evasion*1.2 / (evasion + attacker accuracy)
     x distance fit; a whiff costs the thrower 1.5x stamina and opens a counter window.
   - CHIN: a real knockdown threshold (today it does nothing). High chin shrugs off a hook that floors a low chin.
   - ACCURACY: clean vs scattered landings (split out of technique).
2. MOVE MASTERY (week 1-2) - every punch he knows has a mastery 0-100: RAW (1-29) / USABLE (30-59) / SHARP (60-84) / SIGNATURE (85+).
   Mastery makes THAT punch faster to land (jab windup 266 ms raw -> 166 ms signature), harder to read (telegraph), harder-hitting
   (power transfer 65% raw -> 92% signature), quicker back to guard, cheaper in stamina, and thrown in the right situation.
   Gained on the pads (+1.8-2.4/hour), heavy bag, shadowboxing, sparring; better coach = faster; capped by technique + ring IQ;
   fades 0.75/week when not drilled (never below Usable once earned).
3. THE PLAYER SEES IT (week 2) - three screens, numbers first, square corners:
   - FIGHTER PROFILE: every attribute with today's gain and ceiling; the punch list with each mastery tier; weaknesses flagged.
   - IN THE FIGHT: a sharp punch snaps and returns, a raw one telegraphs and leaves him open; quiet notes under the clock
     ("Reyes fires Sharp Jab (M88) -> snaps head back"); the corner report between rounds names which punch works and which is a liability.
   - AFTER THE FIGHT: the three decisive factors, each tied to training ("Sharp jab M88 vs his evasion 64: landed 48 of 82").
   - A one-page "How fights are decided" in plain words.
4. CAMP LEVERS (week 3-4): gameplan, opponent-focus drills, sparring partner style, corner instructions between rounds.

## Not now
Customers, equipment shop, story, MMA, room resizing, more HUD art - until 1-3 are on the game camera (Paul P28).

## How it is checked
A test red on today's tree first: two camps for the same fighter (one drills the jab to Sharp, one neglects it) -> in the fight the
drilled one lands more jabs, whiffs less, tires less, and the post-fight screen names the jab as a decisive factor. Then a game-camera
fight video beside the new screens, on the board for the operator.

## Added S248 from Ziva (research/ZIVA_DESIGN_ANSWER_S248*.txt - read the real engine, same verdict)
- Mastery today is read ONLY by pad chains/MoveCards, never by FightMoves.select or the contact ladder - FIGHTLINK2 wires it there.
- Seat readiness/wear into the bout: _fresh_body_condition() starts every region at 100 - seed regions + stamina from BodyReadiness and
  area_wear, so an over-trained fighter starts vulnerable (step 1b, after evasion/chin/accuracy).
- The post-fight 'why' is mostly SURFACING: dm_tally, guard kinds, defence timing, per-region condition, significant strikes already exist.
- Plan effectiveness scales with the drilled skill it relies on (counter plan <- counter mastery, body plan <- body work) - camp levers.
- Ziva offers to build + playtest: mastery in the engine, wear into the bout, the post-fight panel (run_tests + run_scene).
