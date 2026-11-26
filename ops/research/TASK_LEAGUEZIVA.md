# TASK LEAGUEZIVA - you are the Ziva player in the agents' league at Puncher's chance (S567)

Kind: playtest. Model: Ziva Smart. Discipline: boxing. Seat: Ziva's own chat (shell commands only: node; no Godot scene, no editor change).

## The owner's words
S567: "make it a league with the agents and you play also on opus", then "use ziva too".

## What this is
Six seats (Kalli, John, Maria, Dola, Claude and you, Ziva) each fight every other once at Puncher's chance, a small
boxing game. A bout is three rounds of six beats between two players with the same boxer. Each beat both players seal a
plan WITHOUT seeing the other's; then the beat is played and both see what happened. You play five bouts. PLAY TO WIN:
read what the other player does and punish it. Do NOT read the game's code, the page, the tools' source or the other
players' folders: a player cannot. You may read your own bouts' output and the game's help.

## How you play (from E:/FightCamp/Lean; nothing else is yours to run)
1. Once: `node proto/twohands/tools/play_cli.mjs help` - every switch, cost, reach, what blocks what, the points. (There is
   no computer opponent in the league: ignore the lines about "HE READS HABITS" and the three named opponents.)
2. Then loop:
   - `node ops/Tools/league.mjs turn ziva` prints one of:
     - `YOUR TURN <bout.json> who=<a|b>`: run `node proto/twohands/tools/versus.mjs show <bout.json> who=<a|b>`, think, then seal
       your beat: `node proto/twohands/tools/versus.mjs plan <bout.json> who=<a|b> lead=<punch|high|low> rear=<punch|high|low> feet=in|hold|back order=<feet,lead,rear in your order>`
       (or `... who=<a|b> clinch`). A refused plan costs nothing: read why and send another. Before each plan, append ONE
       line of WHY to `<the bout's folder>/ziva_why.txt`.
     - `WAIT`: the other player is choosing, or your next match has not started. Wait about 20 seconds
       (`sleep 20`), then ask again. Waiting can last many minutes: keep asking, do not stop.
     - `VERDICT <bout.json> who=<a|b> -> write <file>`: that bout is over. Read the whole bout (`<bout.json>.log.txt`), then
       write the named file, at most 500 words: (1) why you won or lost - the two beats that decided it; (2) what the other
       player did that you could read, and what you could not; (3) was playing another agent more fun than a scripted
       opponent would be, and why; (4) one plan that felt too strong and one switch you never wanted; (5) one line each,
       1 to 10: FUN, DEPTH, CLARITY, VARIETY; (6) TO REACH 10/10: the three changes to the game, most important first, each
       tied to a beat of this bout. End the file with the line: VERDICT END
     - `LEAGUE DONE`: all your bouts are played and judged. Write `ops/research/versus/LEAGUE_ZIVA.md` (at most 300 words:
       your record, the one plan you would call broken, the one change you would make first). Do NOT commit anything: the main session collects the file. Then stop.

## Rules for you
- Decide every beat yourself from what the tool shows. No scripts that pick plans, no reading of code.
- Nothing opens on the monitors. No browser, no image viewer.
- Do not ask questions: a tab that asks cannot be answered. Decide and carry on.
- Edit no file of the repo except the ones named above. Other workers are alive in the same checkout.

## Feedback loops
None built: you only play. One to watch: a plan that wins makes you repeat it, and the other player reads your last three
beats - say in your verdicts whether repeating a winning beat was punished.

## Contract
- OWNS: ops/research/versus/LEAGUE_ZIVA.md (the per-bout files live outside the repo, in E:/FightCamp/tmp/versus)
- RED_TEST: none (a playtest)
- REGRESSION: none
- VISUAL: none

## Prior research
None to read before playing (a player plays cold). ## What would a human do?
A boxer in a league studies the man in front of him during the bout, not the rulebook's source.

## Prefab check
None: nothing is built.
