# TASK STORY1 - the story campaign pitch (five writers, one brief)

Model: any. Owners: Dola (deep research + pitch), John, Kalli, Maria (one pitch each), Claude (lead designer's own pitch).
Deliverable per writer: ONE markdown file, 2,200-3,200 words, named below. Research/design only - no code, no repo commands.

## Why (operator 2026-10-05, verbatim)
"we should have a story writer for the game and make it like a campaign ... write a story based on where this game is going."

## The game you are writing for (read this, it is all you need)
FightCamp is a combat-sports management sim: you run a GYM (never "fight camp" - a camp is only the pre-bout prep), sign and train
fighters, scout, book fights, watch each fight play out in 3D (a calibrated engine, no scripted outcomes), and manage money, injuries
and a corner that reads the fight between rounds. First release is BOXING (Steam Early Access); MMA/kickboxing/grappling follow.
Fighters are FICTIONAL; organisations, belts and tournaments are REAL-WORLD style. Men never fight women; booking matches weight class.
Systems a story can hook into (they exist now or are designed): career level LADDER (amateur -> regional -> national -> world, gated by
level, not just fame); RIVALRY heat 0-100 per fighter pair (rematches, callouts, same-belt chase, sparring wars); press and fight HYPE
(rival gyms, big nights); the CORNER between rounds (reads, calls, towel); weekly calendar (train / rest / spar / bills); money (gym
dues, coach pay, purses, sponsors); injuries and long-career decline; RIVAL PROMOTIONS poaching talent; gym facility rooms (office,
locker, mat room, physio, staff). The fight itself is simulated, so a story can set STAKES and CONTEXT but never script a result.

## What to write (every section required)
1. **Logline + tone** (3 sentences) and what the player feels at the 10-hour mark and at the credits.
2. **The spine**: protagonist (the player's gym owner - who were they, why this gym), the first fighter, and the antagonistic force
   (a person, an organisation or the sport itself). Three acts mapped onto the career LADDER tiers.
3. **Recurring cast** (6-8 fictional people): name, role, want, secret, how the player meets them, what systems they touch.
4. **12 story beats** as a table: beat | trigger in the game's own state (e.g. "first fighter reaches regional level", "rival heat
   > 70", "bank < 0 for 2 weeks", "career-ending injury") | what the player sees (card, scene, call, press) | choice offered |
   consequence on a REAL system (money, heat, morale, a contract, a door opening).
5. **Choices that matter**: 5 choices with lasting consequence, and how the story still works if the player ignores it (sandbox
   must stay fully playable: story is a layer you can turn off or run beside free play).
6. **Fight-night moments**: 4 ways the story shows up INSIDE a fight (corner talk, a rival's entrance, a grudge round, an
   injury callback) without scripting the outcome.
7. **Ending(s)**: how a campaign ends and what carries over into free play / the next fighter.
8. **Smallest build**: what the minimum implementation is for a first playable slice (cards, flags, a trigger list - plain words),
   and 3 things you would CUT first.
9. **Dola only, as Part A before the pitch**: a deep survey (8-12 games/series; sports, management and boxing) of how career-sim stories
   are structured and what players actually praise or hate (cite sources), ending in 10 rules for FightCamp. Dola's pitch is Part B.
10. **The story shapes the menus, the UI and the loop (operator 2026-10-05: "use the campaign to shape the menus/ui and the
    loop") - REQUIRED, and weighted as much as the plot.** The campaign is the spine the screens hang on, not a layer on top. Design:
    (a) the TITLE MENU and new-career flow (what "New Career" asks, what a returning player sees: chapter, next fight, who is waiting);
    (b) the WEEKLY LOOP: what a week is, which beat or story card can interrupt it, the one thing the player always sees first, and how
    "one more week" is pulled by a visible story promise (a fight 3 weeks out, a rival's call, a bill due);
    (c) the FIRST HOUR, minute by minute, from a raw boxer to the first fight as chapter 1 (the demo's end is a chapter end);
    (d) each existing screen and what changes: title menu, MY GYM tab (next up, obligations, your fighters), LADDER tab, schedule and
    booking, week review, the corner between rounds, the scorebug, the result screen ("why it went your way"), the guided-career
    handbook, and the gym rooms (office, locker, mat room, physio, staff): which room hosts which story scene;
    (e) one NEW screen the story needs (e.g. a chapter card, a press/phone inbox, a rivalry wall) with a text mock-up;
    (f) the UI RULES the story implies (icons over text with tooltips; the facility is a gym; one clear next action).
    Give a loop diagram in plain text: week -> decision -> fight -> aftermath -> chapter beat.

## Reference works you may draw on from your own knowledge (names only - do NOT quote them)
Fight Night Champion story mode, Punch-Out!!, Rocky and Creed films, Football Manager / FIFA "The Journey", Motorsport Manager,
Persona's calendar-as-story, Wrestling Empire, Hades-style recurring cast. Take structure and feeling, never plot or characters.
We are NOT sending any game manuals: they would anchor you on copying a design. The system list above is our design summary.

## Prior research
searched: story campaign narrative rival career arc. Nothing exists on a story. The systems it can hook into are listed in
'The game you are writing for' above - that is all you need (the repo is private; the design pages behind it are not shared).

## What would a human do?
A writer's room: one showrunner (Claude) merges five pitches, keeps the best spine, steals the best beats and cast from the rest.
Disagreement between pitches is the point - do not try to guess what the others write.

## Prefab check
Story structures are free to copy as STRUCTURE (three acts, rival arc, mentor's death, comeback). No assets, names or text from
other games or films. Say which structure you used.

## Rules
- Fictional fighters only; real-style organisations. No real people, no real fighters' names. Boxing first; leave MMA hooks marked.
- Respect that results are simulated: stakes yes, scripted wins no.
- Everything in this brief is public: do not ask for or paste secrets.
- File names: Dola `STORY1_DOLA.md`, John `STORY1_JOHN.md`, Kalli `STORY1_KALLI.md`, Maria `STORY1_MARIA.md`. Send the whole file back as your reply.
