# Toribash - a read of the installed game, beside Puncher's chance (S567)

Owner S567: "toribash isinstalled on e if you want to have alook at ti" (after the question "is there any other game out
there similar to ours?"). Read-only look at `E:\SteamLibrary\steamapps\common\Toribash` (406 MB): its rule files and bot
script were read for their numbers; nothing was run, hooked or copied. Notes in our own words.

## What it is, from its files
- THE SAME CORE AS OURS: both players set their fighter in secret, then the turn plays for both at once.
- THE BODY IS THE CONTROL: about 20 joints, each in one of four states (hold, relax, turn or bend one way, the other way),
  plus the hands' grip. A turn is "set the joints you want, then let the physics run". There are no named moves at all.
- TIME IS FRAMES. A rule file gives the match length and the length of each turn in frames. Stock examples:
  - kickboxing: a 220-frame match in turns of 20 (11 turns);
  - aikido: 350 frames in turns of 10, 20, 20, 30, 30, 35, 35, 40, 40, 40, 50 - the first turn is short and they get longer;
  - judo: 1000 frames in turns of 70; a quick mode: 150 frames in turns of 10.
  So a whole bout is roughly 5 to 20 decisions, about what one of our rounds-and-a-half is (we have 18 beats).
- EVERYTHING ELSE IS A RULE FILE TOO: how far apart the men start, gravity, the size of the floor, whether limbs can break
  or come off and at what force, what touching the floor outside your feet costs. 40 stock rule sets in seven families
  (combat, sport, sparring, parkour, vehicles, boss fights, fun); boxing and kickboxing are among them.
- THE STOCK BOT IS RANDOM: its script sets each joint to a random state, or replays a fixed list. There is no reading
  opponent in the box. The game's depth is other players and the physics.
- Replays are first-class: a saved match is a small file of the joint choices, replayed by the engine; a script ships just
  to save them.

## Beside our game
| | Toribash | Puncher's chance |
|---|---|---|
| what you set a turn | ~20 joints x 4 states | three switches (lead hand, rear hand, feet) and their order |
| what a move is | whatever the physics makes of the joints | a named punch or step with a known cost, reach and line |
| can a new player read a turn | no: famous for its learning curve | yes: the card says where it reaches and what it costs |
| resources | none: one continuous exchange | health, stamina, guard, ground; three rounds |
| the opponent | random bot, or people | three men with habits who read yours, or people (the league) |
| the result of a turn | simulated, can surprise | resolved by rule, explained line by line |
| turn length | set per turn, short first then longer | fixed: three moments a beat |

## What is worth taking (ideas, none measured)
1. A SHORT FIRST BEAT. Their matches open with a short turn and lengthen. Ours opens every round with a full three-moment
   beat at Long where only a jab reaches. A one-moment opening beat a round ("feel him out") would cost nothing and read
   as boxing. One line in the rules, then the instrument.
2. THE REPLAY AS A FILE. Theirs is the list of choices, replayed by the game. Ours could be the same: both men's plans,
   beat by beat, as a short text a player can paste to a friend, who watches it on the page (the round replay built in
   S567 already plays a tape; scene.html already plays a scripted exchange). That is also how a test player sends us a bout.
3. RULE SETS AS FILES. They ship 40. Our tweak files (ops/research/s558_balance/*.json) are already this; a "house rules"
   picker on the page is cheap and gives the kick, head and All in pages one home.
4. WHAT NOT TO TAKE: control by joints. Their strength is surprise and slapstick; their cost is that almost nobody can say
   why a turn went wrong. Ours is the opposite bet: every result has a sentence.

## Where that leaves the description of our game
Toribash and Your Only Move Is HUSTLE are the two cousins: secret simultaneous turns in a fight. Neither is boxing with
hands that guard lines, ranges and a stamina budget, and neither explains its turns. "A readable Toribash for boxing" is a
fair one-line pitch to someone who knows that game.
