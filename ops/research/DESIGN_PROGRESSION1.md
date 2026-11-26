# DESIGN_PROGRESSION1 - how a fighter grows: moves, other arts, attributes (S559, paper only)

Owner S559: "should we also spec the game from the aspect of progression, how a boxer learns other arts cards or not
yet ?" then "write it but i want this to be done properly , you already have research on deckbuilding games , see witch
of them have been praised for progression,replayability etc" and "should we also add attributes progression and rpg
elements ?". Nothing here is built. The order stays: kickboxer v kickboxer balanced first (owner S559 "Yes, kickboxer
first"), and every lever below is probed on the balance tool before it reaches a critic or a screen (DEPTH_SCOPE_S534).

## 1. What the praised games teach (evidence, then the lesson)

| Game | Progression | What players and reviews say | Source |
|---|---|---|---|
| Slay the Spire | Between runs: new cards and relics unlock (more options, not more power); Ascension: 20 levels, each adds one hardship, opened by winning the level before | The genre's benchmark for replayability: clarity, archetype depth, run tension; Ascension named as the replay value | GameSpot, glyphshuffle, Steam threads (below) |
| Monster Train | Each clan levels 1-10 by playing runs with it; each level adds that clan's cards to the pool; 25 Covenant (difficulty) levels | Praised for combo runs and variety from clan pairs; levelling to 10 "takes longer than it probably needs to", but the unlocks teach each clan | Microsoft Store page, Steam discussion, guides |
| Griftlands | A card gains experience when you PLAY it; at the threshold you choose one of two upgrades | "Using cards to level them up was such a good idea"; the risk named at once: farming by dragging fights out (a fatigue cap answers it) | Gamer Journalist, Klei forum |
| Hades | Two tracks: the Mirror (permanent talents, each slot a choice of two, re-choosable) and the Pact (opt-in hardships that pay better rewards) | "Balancing carrot and stick"; the Pact keeps the game from going stale | Tom's Guide, RPG Site, Kotaku |
| Cobalt Core | Characters and ships unlock; combinations before each run | The most praised for replayability of its group; the unlock pace called too slow and grindy | rogueliker, vaporlens |
| Fights in Tight Spaces (92% of 2,471) | Add and upgrade cards | "Feels like an action-movie fight"; the sequel's complaint: block cards clog the deck | our JOHN_CARDGAME_MARKET_S538_JOHN.md |
| Submission Saga (100% of 39) | Techniques unlock by belt, white to black; 8 stats trained at the gym | Authentic | same |
| Deck of Fist | A skill tree you cannot finish: you must choose | (no ratings) | same |
| MMA Arena (68% of 95) | Training mini-games unlock moves; leagues up to a belt | Complaint: grind | same |
| Martial Arts Brutality (85% of 720) | Styles unlock, cards upgrade | Complaint: "styles feel alike" | same |
| Wildfrost, Inscryption | Unlocks between runs | Criticised for thin variety and replay (PC Gamer, AV Club) | below |

Community view (Steam, ResetEra; opinion, not measurement): permanent stat boosts turn runs into a grind and cheapen the
challenge; Slay the Spire and Monster Train keep progression to UNLOCKS (more options, sideways) rather than raw power;
too many unlocks can dilute a pool.

**The lessons (L1-L7), each used below:**
- **L1 Options, not raw power.** What a fighter gains should mostly be new choices, not bigger numbers (StS, MT).
- **L2 Earn it by using it.** Practice the thing to grow the thing (Griftlands cards, MT clans) - with a cap against farming.
- **L3 Every step up is a choice.** At an upgrade, pick one of two (Griftlands, Hades Mirror); you cannot have it all (Deck of Fist).
- **L4 Identity through style.** Distinct ways to win (StS characters, MT clans); "styles feel alike" is the named failure.
- **L5 Hardship you opt into.** Replay comes from a ladder of harder conditions that pays more (Ascension, Covenant, Pact).
- **L6 No clog.** A defensive card that is always taken clogs the deck (Fights in Tight Spaces 2): the pre-fight pick must stay a pick.
- **L7 Pace the unlocks.** Too slow reads as grind (MT, Cobalt Core, MMA Arena); too fast leaves nothing to chase.

## 2. What our game already has (read in the code, S559)
- `scripts/rules/MoveTree.gd`: 16 boxing moves in a coach's order, three rows (row 2 opens at 5 moves usable, row 3 at 9),
  each with what it needs (e.g. Uppercut needs Cross 30 and step in 30). Six STYLES, three moves at 60+ each.
- `scripts/rules/MoveMastery.gd`: one number per move and five words - New, Learning (<30), Usable 30, Sharp 60,
  Signature 85; gain per hour by station (pads 2.1), a coach x1.40, a ceiling from technique and ring IQ, 0.75 lost a
  week undrilled but Usable is never lost. Decided: a new move is a weapon in 2-3 weeks of pad time (CLAUDE.md).
- `scripts/rules/LearnSlots.gd`: 1 move studied at a time, 2 with an assistant on pads 65+; learning speed from
  coachability and age; the coach's three cards for what to study next, with ANSWERS to each opponent style.
- `scripts/rules/FighterGoal.gd`: 14 attributes (strength, explosiveness, speed, stamina, recovery, flexibility,
  durability, fight IQ, composure, accuracy, timing, defence, footwork, inside), 0-100.
- Ring Switches (`proto/twohands/order.html`, `kick.html`): every man has every switch; health 18, stamina 8, guard 6,
  the same for both. Nothing links the two halves yet: THAT is what this spec adds.

## 3. The design

### 3a. A switch is a move your fighter knows (L1, L7)
- A move at Usable (30+) is a switch on his fight board. A move still Learning shows on the board DIMMED with its bar
  ("Teep - Learning 22/30"): the thing he is chasing, seen in the fight (the "one more week" pull, D68).
- PROPOSAL: a new fighter brings the moves his data says he knows at 30+ (MoveTree row 1 - jab, lead hook, cross, body
  hook, step in, step out - is only OPEN to learn at signing, `MoveTree.gd:3-4`), plus the guard holds; the rest is learned. The board grows with him - the deckbuilder's "add a card", taught by a coach in the gym.
- The ruleset decides what is shown: in a boxing match no kick switch appears, however well he kicks.

### 3b. Mastery changes the switch a little, and each step up is a choice (L2, L3)
- Usable = the move as the balance tool set it.
- **Sharp (60): pick one of two upgrades for THIS fighter** (Griftlands), shown as two cards on the fighter's page:
  "cheaper" (1 stamina less, min 1) or "faster" (one speed step: medium becomes fast). Kicks and some punches get a
  different pair (a low kick: "two leg marks on a landed kick" or "cheaper"). The choice is his style, permanent.
- **Signature (85): one move per fighter** becomes his signature: a small effect of its own (the jab "keeps him out" -
  the S554 rule; the teep pushes two places; the check hurts the kicker 2). One signature only (Deck of Fist: you cannot
  have it all). The ceiling (technique and ring IQ) already stops a raw athlete reaching it.
- **Earned by use (L2):** mastery grows on pads (as today) AND a little from throwing the move in a real bout - capped
  per bout (Griftlands' fatigue cap) so a long fight cannot be farmed.

### 3c. Other arts are new branches, taught by a coach who knows them (L1, L4)
- MoveTree gets a KICKBOXING branch: check, teep, low kick, body kick, head kick (later Muay Thai: knees, elbows,
  the Thai clinch, catch-and-sweep). Each with needs, from real teaching order (PROPOSAL, to be checked by John):
  check first (no needs) -> teep (step out 30) -> low kick (check 30) -> body kick (low kick 30) -> head kick
  (body kick 60 and flexibility 55).
- Only a coach with that art teaches it: hiring a kickboxing coach is the money decision that opens the branch
  (the gym's Staff page). A boxer who learns only the check and the teep is a real hybrid style - and the balance tool
  must show he neither beats a full kickboxer nor is useless (the S559 boxer style, `noKick`, generalised to a list of
  known moves).
- Learning slots (1-2) stay the brake: every week spent on a kick is a week not spent on a punch (L3).

### 3d. Attributes set the fight's base numbers - few, visible, sideways (your RPG question; L1, L7)
Yes to attributes, with three limits: (1) only FOUR feed the fight board at first, each to one number the player sees;
(2) the spread is small (a great fighter is not twice a poor one); (3) they grow slowly by training and age, as the
gym game already does (decided: 1.0 a focused week, headroom clamp).
| Attribute (FighterGoal key) | Feeds on the board | Range (PROPOSAL, to measure) |
|---|---|---|
| durability | health | 16 to 20 (today 18) |
| stamina | the stamina bar | 7 to 9 (today 8) |
| recovery | stamina back each beat | 1, and +1 every second beat at 70+ |
| defence | guard | 5 to 7 (today 6) |
The other ten keep their gym jobs (training, injuries, mastery ceiling) and may join the board one at a time, each only
after a probe (e.g. fight IQ = how many of his last beats you see; flexibility = the head kick's needs).
MEASURED (S563, P3 = docs/PROGP3_RESULT.md, Arena, n=84 a pair; owner Q-342 "Right amount" on the four): the proposed
ranges decide too much - health 20 v 16 alone 73% (bar 55-62), best v worst 79% (bar 70). Kept ranges: durability ->
health 17 to 19; stamina -> the stamina bar 7 to 9 (worth the most per step: 9 v 8 = 61%); recovery -> 1 for everyone for
now (the +1 every second beat alone is 64%: too much for one level); best v worst with these = 65%, inside. DEFENCE ->
GUARD DECIDES NOTHING (7 v 5 = 53%, bout for bout the same as 7 v 6): the guard almost never breaks, so its size never
matters. Defence needs another job before it joins the board (the map's "Guard bar: cut or rebuild"); until then three
attributes feed the fight board, not four.
Football Manager shows 36 attributes, our reference boxing managers 6-7 (K66): we show 14 in the gym, 4 in the fight.

### 3e. Styles are the identity (L4)
MoveTree's six boxing STYLES (three moves at 60+) gain kickboxing ones (the Dutch kicker: jab, cross, low kick; the
teep man: teep, body kick, back off). A style is what his upgrades and signature add up to - and what the opponents
read. Bar: two styles must not play alike on the balance tool (their switch use must differ by 20%+ on two switches).

### 3f. The fight plan: pick what goes in (L6, PROPOSAL)
Before a bout the player may set the plan: which known moves are "in" (up to 6 switches besides the holds and the
feet). It is the deckbuilder's pick, tied to scouting the opponent, and it keeps the board short. Measured first: if
one pick is always right, it is a clog (L6) and the plan is cut.

### 3g. Replay: harder careers that pay more (L5, later)
A new career can take opt-in hardships (a poorer gym, a tougher region, an older first boxer) for a higher score or
reward - our Ascension / Pact. Only after the main career is good. Listed, not designed.

## 4. Where it shows (menus wired)
| Menu | What it shows | Wired to |
|---|---|---|
| Fighter page (profile) | moves with their word and bar; Sharp choice cards; signature; the 4 fight attributes | MoveMastery, MoveTree, FighterGoal |
| Training page (gym) | what he studies this week (slots), the coach's three cards incl. kicks if a kick coach is hired | LearnSlots, TrainingWeek |
| Staff page | a kickboxing coach opens the branch | staff hire |
| Fight board (Ring Switches) | only his known switches; Learning ones dimmed; the upgrade on the switch (e.g. "Jab - fast") | the fighter's moves at the bell |
| After the fight | what grew from the bout (capped), "was -> now" (S544/S545 rules) | MoveMastery |

## 5. Feedback loops (each with its cap; the one-rep trial before any probe)
1. Use -> mastery -> better moves -> more use: capped per bout and by the technique/IQ ceiling; a one-rep trial = one
   bout's gain printed before a season run.
2. Wins -> better opponents -> more mastery from bouts: matchmaking by rating already holds this (Matchmaking.gd).
3. Upgrades -> stronger fighter -> easier wins: the Sharp choice is sideways (cheaper OR faster), and the balance tool
   bar is "a Sharp move wins 52-58% against the same move at Usable", never more.
4. Attributes -> health/stamina -> wins: the spread is bounded (16-20, 7-9, 5-7); bar: the best v the worst
   attribute set wins at most 70%.
5. Kick coach cost -> gym money: a weekly wage like any coach (GymBills); no loop back.

## 6. The probes, before any critic (greybox, the balance tool)
P1 a boxer with check + teep v a full kickboxer (kick.html, per-man known moves): 25-45% wins for the hybrid.
P2 each Sharp choice v the same move at Usable: 52-58%, and no choice taken in 80%+ of fighters (a must = a clog).
P3 attribute sets: best v worst at most 70%; health 20 v 16 alone 55-62%.
P4 two styles play differently (switch use differs 20%+ on two switches).
Then two fresh critics (one code-checked) for depth and play, 8+ to stay (owner S534).

## 7. For the owner (3 questions, taste and scope)
1. At Sharp, pick one of two upgrades for each move - yes?
2. A fight plan (pick which moves go in) before each bout - try it?
3. Four attributes on the fight board (health, stamina, recovery, guard), the rest in the gym - right amount?

## Sources
- [GameSpot: best games like Slay the Spire](https://www.gamespot.com/gallery/best-games-like-slay-the-spire/2900-7287/), [glyphshuffle: best roguelike deckbuilders 2026](https://glyphshuffle.com/blog/best-roguelike-deckbuilders-2026), [TheGamer: Balatro v Slay the Spire](https://www.thegamer.com/balatro-vs-slay-the-spire-comparison-which-game-is-better/)
- [Ascension levels (Slay the Spire 2, with the original's 20)](https://allthings.how/slay-the-spire-2-ascension-explained-every-level-and-how-it-differs-from-the-original/), [PCGamesN ascension](https://www.pcgamesn.com/slay-the-spire-2/ascension-levels)
- [Monster Train store page (25 covenants, clan levels 1-10)](https://apps.microsoft.com/store/detail/9np4bgblllxm), [Monster Train 2 clan XP discussion](https://steamcommunity.com/app/2742830/discussions/0/599653598138270985), [Destructoid: unlocking cards in MT2](https://www.destructoid.com/how-to-unlock-new-cards-in-monster-train-2/)
- [Griftlands card upgrades](https://gamerjournalist.com/griftlands-upgrade-cards/), [Klei forum on card experience and farming](https://forums.kleientertainment.com/forums/topic/109026-experimental-update-353413/)
- [Hades meta-progression](https://saschb2b.github.io/game-mechanics/games/hades/meta-progression), [RPG Site: Pact of Punishment](https://rpgsite.net/feature/10287-hades-pact-of-punishment-heat-modifiers-and-how-to-maximize-your-rewards), [Tom's Guide on Hades](https://www.tomsguide.com/uk/features/hades-exclusive-interview-supergiant)
- [rogueliker: Cobalt Core](https://rogueliker.com/cobalt-core-review), [vaporlens: Cobalt Core](https://vaporlens.app/app/2179850/cobalt_core.md), [PC Gamer: Wildfrost](https://pcgamer.com/wildfrost-review), [AV Club: Inscryption](https://www.avclub.com/in-inscryption-one-of-the-best-games-of-2021-card-battl-1847869630)
- Meta progression debate: [ResetEra](https://www.resetera.com/threads/do-you-like-meta-progression-in-your-roguelikes-roguelites.1341955/page-2), [HELLCARD Steam thread](https://steamcommunity.com/app/1201540/discussions/0/3776867914941362236/)
- Ours: `ops/research/JOHN_CARDGAME_MARKET_S538_JOHN.md`, `CARDREF1_REFERENCE_GAMES.md`, `K66_ATTRIBUTE_SYSTEMS_IN_SHIPPED_GAMES.md`, `D68_ONE_MORE_TURN.md`, `G134`, `J57`.
