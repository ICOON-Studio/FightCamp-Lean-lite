# RUNESTEP1 - the step in Rune Coliseum, and whether its logic fits Ring Switches (S558)

Owner, 2026-11-25: "can you check the step mechanic included/or required in some moves on the game RuneColossieum
(installed on e:) , play it in the background you can use any saved games i have ,i do not care and try see if its
logic fits our switch/card game ."

## Verdict: FITS IN PART
1. Three of its step rules fit Ring Switches as rules of one moment: a punch that carries its own step, a punch that
   pays extra for catching a man who is stepping, and a back off that charges your next punch. Each is a tweak file.
2. Best first: **the pull counter** (a back off arms your next punch this beat, +1). It goes straight at "backing off is
   dead" (8 back offs in 366 beats) and needs no new switch. Second: **catch the step**. Third: **the lunge jab**.
3. What does not fit: its queue is laid against an enemy queue you can SEE, and it is broken open by "reaction
   moments". Ring Switches is a blind, both-at-once beat by design. So their queue does not carry over; their step rules do.
4. Our old verdict ("a queue laid blind is a guess or a lookup", CARDREF1 s10) does not describe this game: its queue
   is not blind. That verdict was right about blind queues, but it was aimed at the wrong game.
5. **I did not play three fights.** The game would not take input on the hidden desktop (below). Everything here
   comes from its installed files: its text tables in seven languages, its card database and the names in its code.

## What happened when I tried to play (read this first)
- **Started on the real desktop for about 70 seconds.** Started directly, the game exits and Steam starts it again,
  and that second copy opened on the normal desktop (about 20:58:00 to 20:59:13). I stopped it by its PID as soon as I
  saw it. If a black Rune Coliseum window showed up on your monitor around then, that was it. Fix, used after that: start it with the
  environment variable `SteamAppId=2360210` (no file in the install folder), and Steam does not take it over. The
  second start stayed hidden the whole time (`wins`: nothing on the visible desktop).
- **It takes no input while hidden.** It is a Unity game. Clicks and keys posted to its window, and the same messages sent
  after telling the window it was active, did nothing: it stayed on the language screen (pictures
  `E:/FightCamp/tmp/runestep1/s01.png` to `s04.png`). Unity's input system reads the real devices, and those never reach a
  hidden desktop. To play it you would need either a mod loader in the install folder (the brief forbids touching
  that folder) or a visible window. I did neither.
- **Saves.** Backed up first to `E:/FightCamp/tmp/runestep1/saves_backup/`. The one launch that reached the menu
  rewrote three files in `SaveData/GameData_C/Curent` (AchieveData, Index, PlayerData). I copied the backed-up
  versions back. A diff against the backup now shows no change.
- I did not use the REA decompiler. It cannot open this assembly: the game's code is a .NET DLL, and REA's metadata
  reader hits its 64 MB limit. Installing ILSpy was refused. So the code evidence below is the names of the game's
  classes, methods and log lines, read straight from the DLL (no code bodies).

## 1. Moves that carry a step or need one (14 rows)
"Name" is how the game's text tables name the card. Everything else is in our own words. Distances are the game's
metres. In this game the step is part of each attack's animation: every attack animation in the card database has a
measured travel distance ("allDistance"), and a contact distance for grabs ("CATDistance").

| Move | Step it carries or needs | Range before -> after | Cost | If the step is blocked / he moved first |
|---|---|---|---|---|
| Advance ("Forward 1 m", per weapon 1 m / 2 m; cards up to 5 m) | carries a step forward | one step closer; a step that would pass through him is corrected | one move card (its energy); a passive lowers move costs | V5 rule: moves resolve FIRST in a queue slot and ignore Power, so nothing blocks the step itself |
| Retreat ("Back 1 m", "Back I", back 2 to 4 m variants) | carries a step back | one step further | 2 energy (the tutorial says so: dearer, but it opens the distance to dodge) | it dodges only an attack whose red range it leaves. Older tutorial rule: a move in the SAME slot as an attack fails, so put it one slot earlier |
| Forward Roll ("roll a mid distance to behind the enemy") | carries a long step through him | ends behind him | a card | when it lands behind him, his next action is replaced by a turn-around. A log line says the roll makes him unhittable until its end event |
| Back roll (I / II) | carries a longer step back | further than Retreat | a card | as Retreat |
| Charge / Charge Shield / spear charge | carries a run in | closes to contact, some versions pass through him | a card, with a stance first ("charge ready") | a boar version passes through and, if it hits, charges back |
| "Advance a short distance and attack" (many weapon attacks) | the attack carries its own short step | mid -> near, then the hit | the attack's stamina (set by the weapon's weight) | the hit is checked at the new distance: out of reach and it is "not resolved" (a log line: distance not met) |
| "Advance a mid distance and attack" (blade arts, a stun version, a bleed version) | a longer built-in step | far -> near | the attack's cost | as above. One version slows BOTH men afterwards |
| Shield rush ("spend all your block: every 10 block = 2 m forward and a shield bash") | the step is bought with block | as far as the block buys | all your block | each 2 m comes with a bash. Run out of block and the rush stops |
| Running pass ("deal damage, move 8 m forward, knock down and pass through") | an 8 m step through him | ends behind him | a strong card | if the hit fails, he is not knocked down (an attack card's Power must beat his card) |
| Knockback attacks ("knock him back 3 m; if he blocks, 5 m"; 1 to 11 m versions) | moves HIM | opens the range for him | the attack's cost | a block makes the push LONGER: a guard does not stop the push, it adds to it |
| Spear grips (end grip / middle grip) | needs a distance | tip hit 1.2x Power, shaft 0.7x, within 1.5 m 0.2x | end grip costs 35% more stamina | at too close a range the spear is nearly worthless: "keep him at the tip" is the spear's whole plan |
| "If you have played no move this round: +x Power" | needs NO step | - | - | rewards planting your feet |
| "Every metre backed off adds one thrust to this card" | needs a retreat BEFORE it | - | - | the retreat charges the attack (our "pull counter") |
| Tracking attacks ("follows the enemy's position; a move card dodges it") | follows his step | - | - | only a move card escapes it |
| Counter card ("hit an enemy in the middle of a move: he is always knocked down") | punishes HIS step | - | - | the step is the moment you are open (our "catch the step") |
| Weapon pick-up (disarmed: click the weapon on the floor) | the man walks 1 m on his own | - | a turn | - |

## 2. How distance works there
- **Places:** distance is in metres, not places. The debug lines name three bands: near, mid and far
  ("current distance {0}, in [near]"). Each attack's reach = how far its animation carries + the weapon. The
  developers rebuilt this system (a folder named "displacement rebuild").
- **Both move:** in V5 "moves always resolve first, then other actions". Each fighter has a forward priority and a
  back priority. Two steps that would cross are corrected ("A left, B right, too close or passing through"), and
  pointless back-and-forth steps are removed. Bosses' backward steps are removed.
- **A step takes a slot:** yes. A move card sits in the queue like any card (code: "insert a move into the queue",
  "generate a move"). There is a per-round cap on moves ("extra movement times per round", the Mobility stat) and a
  count of forbidden moves.
- **Interrupted:** a knockdown's get-up replaces everything left in that man's queue. Some cards "interrupt the enemy
  queue", and one boss skill interrupts displacement. The counter card above knocks down a man caught mid-move.
- **Stamina or time:** a move costs its card's energy (Retreat 2 in the tutorial), and passives lower it. Moves ignore
  Power checks (V5). Each attack also has a wind-up and a recovery. One wind-up type is marked "can be overcome by
  a retreat".
- **The start distance of the next exchange is chosen** (code: "choose next round's start distance"). Not every round
  opens at the same range.

## 3. How the player is told
- An eye icon above each queue slot previews that card: **blue = where this card moves you, red = where it hits**
  (the game's help text).
- Move buttons on the character ("click the character's arrows to go forward or back"; "Forward 1 m" / "Back 1 m").
- The tutorial page "Move & Attack": a move and an attack in the same slot, the move fails, so put the move one slot
  earlier to dodge. Later, the V5 help says moves now resolve first. Both texts are still in the files.
- The card says the step in its text ("advance a short distance and attack", "move forward 8 m").
- An achievement for finishing a run without one retreat card ("Never Retreat").
- The enemy's queue is shown. What is hidden is named as a danger ("the card inside an enemy's slot card cannot be
  seen: be careful"), and "hidden intent" is a special modifier. So the normal state is open.

## 4. Three fights
NOT DONE: the game took no input while hidden (above). There are no fight screenshots. Only the language screen was
photographed (`E:/FightCamp/tmp/runestep1/s01.png`).

## 5. Does it fit Ring Switches
Today (S558): three switches a beat (lead, rear, feet) in an order over three moments. Feet = step in / hold / back
off, 1 stamina. A step in beats a back off in the same moment. The playtests found: backing off is dead (8 in 366
beats), Long is a corridor every round opens with, and "walk in" is every round's first beat.

| Rune Coliseum rule | In Ring Switches | Fixes | Breaks | Verdict |
|---|---|---|---|---|
| Moves resolve first in a slot, ignore Power (V5) | already ours: feet resolve before the punches of their moment | - | - | nothing to do |
| (old) A move in the same slot as an attack fails: place it earlier | a back off would dodge only LATER moments | nothing on the list | makes the back off weaker still | no |
| Retreat costs 2 | back off 2 stamina | - | makes it rarer | no |
| "Every metre backed off adds a thrust" | **pull counter**: a back off arms your next punch this beat, +1 health; cut off by his step in, it arms nothing | backing off gets a reason (Mayweather's pull counter); the ORDER matters more (back off first, punch after) | nothing structural; it still gives ground, so the ropes and the judges' tiebreak stay | **1st, `rune_pull_counter.json`** |
| "Hit a man mid-move: he goes down" | **catch the step**: a punch that lands in the moment he steps in takes 1 more health | the first-beat walk-in is no longer free; Long becomes a place where holding is a threat | it feeds the jab (lands 76-79% already, the one failing bar). Pair it with something that costs the jab | **2nd, `rune_catch_step.json`** |
| Attacks carry their own step | **lunge jab**: a lead punch that steps in a place in its own moment, 2 stamina, the lead hand stays out the next moment | the corridor: a man at Long can be reached without a walk-in beat; frees the feet switch for a second move | the three-switch idea (a hand does the feet's job), and it is one more jab | **3rd, `rune_lunge_jab.json`** |
| A wind-up beaten by a retreat | slow punches miss against a back off in the same moment even in reach | a little of the back-off problem | mostly already true through reach | later, if the pull counter is not enough |
| Knockback, longer when blocked | a cross blocked at Mid pushes him to Long | range churn instead of the corridor | blocks would cost ground: the guard loses value | no for now |
| No move this round: +Power | holding all beat: +1 | - | rewards never moving: the opposite of what we need | no |
| Roll behind him: his next action becomes a turn | an angle step (pivot) | Long-and-Mid sameness | needs a fourth position or lateral switch | later (an angle is real boxing, but it is a new system) |
| The next exchange's start distance is chosen | the round winner (or his corner) picks where round 2 opens | "Long is a corridor every round opens with" | nothing | worth a one-line probe; not filed (three tweak files max) |

**Tweak files** (all three load: `node proto/twohands/tools/tweak_check.mjs <file>` prints TWEAK_CHECK loads; each rule
checked on one beat with a scratch script, the numbers below). The brief said not to measure them, so I did not run
balance.mjs:
- `ops/research/s558_balance/rune_pull_counter.json`. Inside: you back off (moment 1), then cross (moment 2): the
  cross lands for 4, not 3, "off the pull, +1". Your back off cut off by his step in: the cross lands for 3 (no bonus).
- `ops/research/s558_balance/rune_catch_step.json`. You jab at Long, he steps in in the same moment: the jab lands
  at Mid for 2, not 1, "caught stepping in, +1".
- `ops/research/s558_balance/rune_lunge_jab.json`. At Long the lunge jab lands at Mid, and his cross in moment 2 lands
  (your lead hand is still out). The plain jab control has that cross blocked. If he backs off in the same moment, the
  range stays Long. Known flaw: the story line says "your lead hand was held high" when it was still out, and the
  step itself is not narrated as a range line.

## Our old verdict, tested
CARDREF1 s10 said "Rune Coliseum is not installed ... a queue laid blind is Form A again." The game is installed now.
Its queue is NOT laid blind: the enemy's queue is shown, hidden parts are flagged as dangers, and "reaction moments"
(a perfect block, a perfect dodge, a doubled Power) let a man draw and play a card into the running queue. So
it is an open puzzle with surprises, closer to a "lookup" with interrupts than to a guess. The old line was right
about blind queues and wrong about this game. For Ring Switches the queue model stays ours (simultaneous and hidden).
What we take from Rune Coliseum is the step rules.

## NOT SURE
- Nothing here was seen in play. Each rule comes from the game's help text, card texts or code names. Some texts may
  belong to versions the game no longer uses: the tutorial's "a move in the same slot fails" and V5's "moves resolve
  first" are both in the files.
- I take "the enemy queue is shown" from three strings (AI places cards; "hidden intent" is a modifier; an enemy
  slot's inner card "cannot be seen"). I did not see a screen.
- Retreat's 2 energy is from one tutorial line. Real costs live in the card database, which I could not read row by row.
- The band edges in metres (near / mid / far) are not in any text I found.
- The tweak files are sketches. The pull counter and catch the step have not been through balance.mjs. The catch step
  may push the jab bar (76-79%) higher.
- Live play needs either his OK to add a mod loader to the install folder, or a visible window while he is away from
  the PC.

## Prior research
CARDREF1_REFERENCE_GAMES.md s10 (tested above), C17_FIGHT_SCENE.md l.235, DESIGN_CARDGAME_SCOPE.md, docs/RINGSWITCH_S558.md.
