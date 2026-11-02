# G89 - FIGHT HYPE: what makes a fight feel big, and what can be measured (Research, no code) - FightCamp, 2026-09-24

FightCamp is a combat-sports gym management game (Godot). You can read the repo through your GitHub connector (this brief
is research/G89_BRIEF.md). The operator, verbatim: "i want the hype to the fight feel as real as possible especially
vs rival gyms or high stake tournaments what other features we can add".

WHAT ALREADY EXISTS (read these before proposing): `Godot/scripts/Rivalries.gd` (a HEAT 0-100 per fighter pair, stoked by
fights, callouts, same-belt chases, poaching; read by grudge-match purses, the sim, morale, fame, rematch asks),
`Godot/scripts/PressConferences.gd` (fight-week questions whose answers move the bout's HYPE, heat, morale, fame and gym
reputation, with backlash), `Godot/scripts/Tournaments.gd`, `Godot/scripts/PromotionsBoard.gd`. There is NO gym-vs-gym
rivalry object (rivalry is fighter-to-fighter), no weigh-in face-off, no betting line, no ticket/PPV number driven by hype,
no crowd composition, no build-up content in the 3D fight.

## The questions
1. WHAT DRIVES REAL INTEREST - MEASURED. Which factors move PPV buys, gate, attendance, streaming viewership or betting
   handle, with numbers: rivalry/rematch, title stakes, undefeated records, hometown, trash talk and press-conference
   incidents, national/team rivalries (e.g. gym vs gym: AKA vs ATT, Tristar; boxing stables), tournament finals (Grand
   Prix, PFL playoffs, K-1 WGP). Sources: PPV buy tables (boxing and UFC), Nielsen/streaming figures, attendance records,
   economics papers on fight demand (e.g. studies of UFC PPV demand determinants), betting market volume and line movement.
   NOT FOUND where there is none.
2. HOW THE BUILD-UP IS STAGED: the real fight-week and fight-camp sequence (announcement, media day, open workout, press
   conference, face-offs, ceremonial weigh-in, Embedded / 24/7 / Countdown episodes, social callouts), which of those
   measurably move interest, and which incidents became famous (and why).
3. GYM VS GYM: how real team rivalries form and are covered (gym wars, camps sending fighters at each other, team
   scoring in amateur tournaments, TUF coaches), and whether any interest data exists for them.
4. HOW GAMES DO IT: EA UFC career mode (hype meter, callouts, social feed), Fight Night Champion legacy, WWE 2K / TEW
   (feud heat, promos), Football Manager (derby build-up, media), Punch Club, MMA Manager / Boxing managers - input, what it
   changes in the game, what players said works or is shallow.
5. PROPOSE FOR FIGHTCAMP: a ranked list of hype features, each with (a) the real-world evidence behind it, (b) which
   existing FightCamp system it extends (the files above), (c) what it would CHANGE in the game (money, fame, the fight
   itself, the crowd), (d) cost to build small/medium/large. Put gym-vs-gym and high-stakes tournaments first.

## Deliverable
ONE markdown document titled "G89 - FIGHT HYPE", sources inline, ending with one line saying what is still unknown. PASTE
THE WHOLE DOCUMENT IN THE CHAT as your reply (the operator cannot open files in your sandbox).
