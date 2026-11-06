# Dominus Gladiatus study (S389, 2026-11-06)

Operator: "check the game running on my samsung monitor for each structure and tutorial guide and design ... it basically has
1-2 maybe 3 main hub". Notes and numbers in our own words; nothing of theirs is in this repo. Screens are outside the repo:
E:/FightCamp/tmp/s389/dominus/shots. Unity, Mono build, by Brain Seal Entertainment, Steam app 3572090.

COVERAGE: days 1-3 of one new save. Seen: courtyard, fighter page, owner page, fight card, rival page, one event, one power.
NOT seen: a fight, the slave market, Equipment, any built room, days after 3. Tutorial steps come from the game's text table,
not from watching them play, because this save started without the tutorial.

## Structure: he is right, two hubs and a strip
| Place | Reached by | Holds |
| --- | --- | --- |
| Courtyard (one painted scene, always behind everything) | It is the game's home | People and rooms you click; clock top right |
| Fighter page | Click a fighter | Info, Skills, Equipment, Actions, Stats |
| Owner page | Click your owner on the balcony | General (costs, market), Info, Build, Staff, Armory |
| Countdown strip, top left | Always on the courtyard | Next fight, rival/season finale, your owner's power |

Every other screen opens from one of those: the fight card from the Colosseum icon, the rival page from the portrait.
There is no menu bar. Nothing is two clicks from home except a tab. Close is the same X, top right, on every page.

Ours today: 7 rail buttons, 25 tabs, 8 fighter tabs, 10 modals. PLAYER_PATH proposes 5 / 8 / 5.

## The pattern on each page
- Fighter Info: portrait left, one line of character, then about 10 plain rows: base health, talent, injury, fatigue 0-5, freedom goal
  (0/13 victories), temperament, morale, what high morale does, what low morale does, suicide risk.
- Each fighter differs at a glance: talent, temperament, high and low morale behaviour, freedom goal all roll per person.
  This is what gives two fighters different stories without a big system behind it.
- Skills: picture cards with rank diamonds (2-5 ranks), one detail panel on the right. The skill in training fills by itself:
  Combat read 66% after two days. Pick once, then time does it. Class choice is a page of three figures.
- Build and Staff: same layout as Skills. Card grid left, one panel right with picture, one line, price, one button.
  5 rooms, 7 staff roles. One layout learned once, used four times.
- Fight card: venue, rule (until surrender), what a loss pays (25%), crowd mood, the purse (35), days left, opponent figure, and an
  empty silhouette for your fighter. All the information for the decision, on one page, no table.
- Rival: portrait, short story, the next dirty trick and its terms, tricks left, how relations stand. A second tab shows who you face at the
  season finale and the days left.
- Events: parchment card, portrait, two choices. They stop the clock.

## Tutorial: goal first, then one line when you need it
1. One intro card: the goal and the clock. Plain: first tournament, 28 days, beat your rival in the final.
2. One-line prompts, one per verb: pause, train a skill, buy a slave, fight, move a gladiator, open a room, change equipment, use the
   Palus. Each is a single sentence naming the click.
3. A card the first time a system bites: Fatigue, Morale, Injury. Rule and threshold only (fatigue 3 lowers health, over 5 injures;
   three of one injury become grievous). Shown when it happens, not before.
A "!" over a fighter marks something waiting. A settings toggle shows the tutorial at start; none of it forces a route.

## Pressure and numbers seen
Start 15 gold, upkeep 1 a day plus 1 per gladiator (3 a day with two). Gold went 15 -> 2 -> -1 over two days; the wine in the first event
looks like 10 (inferred: 15 - 3 upkeep - 10). First purse 35, a loss pays 25%. Quarters cost 30, a doctore 80. So you cannot buy
anything before the first fight, and the first fight is on day 4: the money problem points you at the arena at once.
Three clocks run at once: next fight 1 day, season finale 27 days, power charges 2. Time is real-time days with a pause.

## What we take, what we do not
TAKE
1. Two hubs. Home plus the fighter page carry nearly everything; Club becomes the owner-style page. Replaces our rail thinking.
2. A strip of countdowns on Home: next fight, next money problem, season goal. Matches PLAYER_PATH clocks, but always visible.
3. One card-grid-plus-panel layout for Skills, Staff, Facilities, Moves. Fewer layouts to learn and to build.
4. Fighter Info rows with personality that changes play. This answers C238, and the data list is in ops/research/MENUDIR_*_S388.md.
5. Fight card answers C237: venue, rule, stakes, crowd, purse, days left on one page, and an empty slot for your fighter.
6. Tutorial shape: goal and clock card, one-line prompts, a card the first time a system bites. Replaces our first-week guide text.
7. A named rival with a countdown gives the season a shape. Our arc is not approved yet; this is a candidate.

DO NOT TAKE
- Their art, names, setting, words or numbers. Their prices are not a baseline for ours.
- A clickable scene as the whole interface, yet. It needs art we do not have and PLAYER_PATH puts skin last. Plain Home first; the office
  scene stays a later skin (MENUDIR, awaiting his go).
- Real-time days. Our Monday stop is a better fit for planning; PLAYER_PATH section 7 stands.
- Three clocks only work because each is one icon. Do not add a fourth.

## Open
Does a fight hold up? Not seen. Worth one look in the operator's own play, since Dominus's fight is watched, like ours.
