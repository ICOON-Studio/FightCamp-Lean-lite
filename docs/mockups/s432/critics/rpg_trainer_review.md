# RPGLAYER1 review: a former pro trainer, fresh and blind (S432)

Read whole: CRITIC_PACK.md, CRITIC_ACCESS.md, RPG_LAYER_MAP_S432.md, CLUBWEEK_MAP_V4_S432.md; drawings rpg_coach.png and rpg_fighter.png.
Code checked: scripts/rules (FighterProfile.TRAITS, CoachNotes, CornerTrust, Exchanges.FULL_SHOUTS, Knowledge.gd, TheRead.gd, Recruit.ambition, PerkRoad).
My 10/10 drawing: `docs/mockups/s432/critics/rpg_trainer_10.png` (html beside it).

## Depth score: 6.5 / 10
The choices are real and paid in the club week's own coin. But "the read" is a new copy of a module that is already built, and its name is taken.
The trait sheet shows what moves a trait, never what the trait does. Coach, the hired coach, does not grow at all. The moment deck runs dry in the second season.

## What a real gym gets right here
- The bond is built where it is built in life: in the corner, on your own pads and in promises kept. Experience counts only what you do in person. That is true.
- Either/or coach perks where both sides move the same coin (your hours, one-on-one against the room, voice against minute) are real trade-offs. They are not "+5% training".
- The three gym styles (hard school, craft first, family club) are how clubs are known. Boxers do move gyms over that fit.
- The knockout turn is the best idea in the map. Rest is the honest answer, and rushing a boxer back "never the same" is real.
- A build direction that drifts the style dials over weeks is how a style is really built. Changing it costs nothing but the weeks already spent. Right.
- The menu table is complete, and every price has a probe with a cut rule.

## What is weak, in a trainer's words
1. THE READ IS ALREADY BUILT, AND ITS NAME IS TAKEN. `scripts/rules/Knowledge.gd` (KNOW1, S411, owner Q-S294-139, "the range never lies") already narrows each attribute's range with sessions, sparring and bouts. It does this per group (body, skills, fire), and only its own test uses it. The map invents a new CoachRead with 5 steps instead of wiring this one. "The read" is also already the in-fight rule (`TheRead.gd`: a fighter reading an opponent's habit). One word per concept is the owner's rule.
2. TRAITS SHOW THE CAUSE, NEVER THE EFFECT. The Character tab says coachability is "wearing down: +1 a bout you corner well". It does not say what 36 coachability does: in the code it sets how much of each shout lands, 0.7 to 1.0. A trait the player cannot see working is a word, not a choice.
3. COACH DOES NOT GROW. The owner asked for RPG "with coach and fighters". In this game's own words, "Coach" is the hired coach. The map reads the ask as you, the head coach, and leaves Coach's growth for later. In a real gym the assistant gets better on the pads with the boxers they hold, and a boxer can follow that assistant out of the door.
4. THE MOMENT DECK IS THIN AND FORGETS. There are 11 cards at one a fighter every 6 weeks, so the same cards come back in season 2. No card remembers an earlier answer, so a promise never comes due as a card. Card 2 (the name above) repeats the bout sheet's "name above" card. Card 6 (your pads, not Coach's) repeats the talk card's "give the pad place back". The Loyal-only answer to the wedding card costs nothing, so it is a click, not a choice.
5. NO SQUAD. Every link runs between you and one fighter. Real gyms run on partners and pecking order: two who spar every week get better together, and one leaving shakes the other. Two short fuses become a feud. "Sparks in sparring" touches this once and forgets it.
6. PROGRESSION STOPS IN SEASON 2. Level 6 is the cap, at about 90 experience, and a first season gives about 79. In an open-ended career the coach stops growing for good in the second spring.
7. TRUST ME SITS IN THE WRONG PLACE. A fighter at 85 loyalty who is also Low is rare, so TRUSTME1 will likely cut it, and the top band would then reward almost nothing. In life the trusted coach's word matters in the corner minute when the fighter is hurt, not in a shout.
8. NOTHING LASTS ON THE SHEET. The knockout turn, a first title or a broken promise move a number and are gone. An RPG character sheet keeps earned marks: "came back harder, Feb 2026".
9. STYLE NEVER MEETS SIGNING. Your gym's style suits some characters and clashes with others, but the trial and walk-in cards do not show the fit. So the style never shapes who you take on, and in a real gym that is its biggest effect.
10. THE DRAWINGS DRIFT FROM THE GAME'S SHELL. The fighter tabs invent "Condition" and "Fight plan" and drop "Fight prep". The top bar says "Mall (2 new)" for Mail, and the left rail is missing. "About 4 levels a season" on Club > You is not something the player can act on.

## Missing options
- What each trait does, in numbers, on the Character tab and in hover.
- Coach (the hired coach) growing: areas rising with sessions run, a signature drill, a raise or leaving, and "Coach runs it" per fighter linked to how well you know them and to loyalty.
- Training partners and feuds between fighters.
- Earned marks that stay on the sheet.
- Style fit on the trial card, the walk-in card and Find a fighter.
- The fighter's ambition and season target on the Character tab.
- Follow-up moment cards: a promise coming due, a card that remembers your last answer.
- Levels after 6 (deepen a perk you took).

## Useless options, as written
- Moment 2 "The name above": the bout sheet already offers a name above.
- Moment 6 "Your pads, not Coach's": the talk card already offers the pad place back.
- Moment 3's Loyal-only "Go, train Sunday: nothing lost": an answer with no price.
- Read step 1 "the habit's cost shown exact": too small to be a step.
- TRUST ME as a shout for Low fighters at 85+ loyalty: the case almost never happens.
- The drawn "Condition" and "Fight plan" fighter tabs: not in the game's structure. The "About 4 levels a season" line.

## To reach 10/10 (most important first, each buildable)
1. Wire "the read" onto the built `Knowledge.gd` and rename it. Your coached mornings and pad places add to "session", sparring evenings add to "spar" by their setting, and cornered bouts add to "bout". Keep its three groups (Body, Skills, Fire) and continuous ranges, and draw the 5 pips from the same numbers. Drop the new CoachRead. Call it "HOW WELL YOU KNOW <first name>" (one word: "Known"). "The read" stays the fight rule (TheRead.gd).
2. Give every trait an effect line on the Character tab and in hover, from the code: Coachability gives the share of each shout taken in (0.7 to 1.0, Exchanges); Heart gives count speed and the late rounds when behind; Discipline under 45 skips 1 alone morning in 3; Confidence covers the name-above ask and its loss; Temper covers sparring sparks and the corner talk. Do the same on the fighter card's two trait words.
3. Make Coach grow, small. Each of Coach's five areas (CoachAreas) rises +1 every 10 sessions run in it, up to the hire's ceiling. At 40 sessions on one move, Coach's signature drill opens (that move x1.2 on Coach's pads). Each two steps, Coach asks for +$40 a week, or loyalty bands for staff (under 25 leaves for Eastside ABC). Show "Coach and <name>" on the Character tab: sessions together, and the loyalty a fighter would lose if Coach left (-6 at 20+ sessions). Tie the agreed "Coach runs it" per fighter to this: that fighter's read of you does not grow, and their loyalty leans to Coach.
4. Earned marks: at most 4 per fighter, each with a date and one small, measured effect. HARDENED or SHAKEN comes from the knockout turn (count beats 1 second sooner, or round-1 composure -2 for the next bout). FIRST HOME WIN gives +2 fans a home bout. BROKEN PROMISE makes the next promise's price x1.5. PARTNERS comes from item 5. They show on the Character tab, the card hover and History.
5. Training partners: two fighters who spar 6 of 8 weeks become PARTNERS. They get +5% sparring gain together, and the other loses 4 loyalty when one leaves or turns professional. Two Short fuses who spar Hard 3 times become a FEUD: no sparring between them for 4 weeks unless the corner talk settles it (1 of your pad places). Show it on the sparring pair picker and the Character tab, and add PARTNERS1 to the probes.
6. Grow the moment deck to 18 and give it memory. "You said March" comes the week a dated promise falls due. The wedding card remembers a yes, and the old coach calls back. Card 2 becomes a named rival from the region calling the fighter out, and card 6 folds into the talk card. Every third answer for Loyal fighters has its own price (cash, one of your mornings), never "nothing lost". MOMENT1 also checks that no card repeats inside a season.
7. Move TRUST ME into the corner minute. At 85+, once a bout, your TALK lands in full whatever the mood, and a hurt fighter's RECOVER gets one more point. Probe it on hurt rounds. If it still fails, 85+ brings a friend to the trial mat: a recruit, not a number.
8. Levels 7 to 10, one a season: each one deepens a perk you took (Long evenings: 4 pad places on your evening; Ringside voice: shouts in round 3 also land in full). Each is still a pick of two, and still paid in the same coin.
9. Show the style fit (suits or clashes, with the "?" rule) on the trial card, the walk-in card and Find a fighter, so the gym's style shapes who you sign.
10. The Character tab carries WHAT <NAME> WANTS: the ambition, the season target, whether they match (+5 or -5), and what is left to reach it.
11. Fix the drawings to the game's shell: the fighter tabs are Overview, Week, Fight prep, Playbook, Character and History. Use Mail, not Mall, and keep the left rail. Cut "About 4 levels a season".

## Is the RPG layer complete for this version, with the list applied?
Yes. With items 1 to 7 applied, the layer covers what a real trainer means by "the bond":
- you grow, and so does your hired coach;
- each fighter grows, keeps marks and has a will of their own;
- what you know of them grows with the hours you give;
- the squad is linked through partners and feuds;
- every reward is paid in the club week's own coin and measured before the build.

Items 8 to 11 are polish for the long career and the screens. The rival club that poaches, scars, decline and retirement can wait, as the map says, because they need the living world.
