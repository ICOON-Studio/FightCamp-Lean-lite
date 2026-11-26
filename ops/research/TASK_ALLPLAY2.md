# ALLPLAY2 - play Ring Switches as it is today, with and without TELLS, and answer the owner's question (S563)

Owner, 2026-11-26 (S563): "do you thinkwe should show opponents itentions like more draditional card games or it is fine
the way it is ? Can you have ziva and some other agents playtest the current version and provide feedback".
Discipline: boxing. You write a report and nothing else: no game file, no page file, no commit (Arena: commit only your
report folder). Nothing opens on the owner's screens (your image tool only; no browser window, no viewer).

## What it is
Ring Switches is a small boxing game the owner loves. Each beat you set three switches (lead hand, rear hand, feet) and
the order you throw them; he sets his at the same time; three moments are played out. A hand that does not punch is
held high or low and blocks one line. Three ranges. Three rounds of six beats. It is a browser page
(`proto/twohands/order.html`), so you play it IN WORDS, on the page's own rules and its own three opponents (from
E:/FightCamp/Lean, or from your clone of the repo):

```
node proto/twohands/tools/play_cli.mjs help                                        (every switch, cost, reach, what blocks what, the points)
node proto/twohands/tools/play_cli.mjs new  <dir>/b1.json opp=0 seed=31            (0 Jabber, 1 Slugger, 2 Body Snatcher)
node proto/twohands/tools/play_cli.mjs new  <dir>/b4.json opp=0 seed=41 tells=1    (the same, with TELLS ON)
node proto/twohands/tools/play_cli.mjs beat <dir>/b1.json lead=jab rear=high feet=in order=feet,lead
node proto/twohands/tools/play_cli.mjs beat <dir>/b1.json clinch
node proto/twohands/tools/play_cli.mjs show <dir>/b1.json
```
`<dir>` is `E:/FightCamp/tmp/allplay2/<your seat name>/` (a cloud seat: `ops/research/allplay2/<seat>/` in its clone).
Each bout's beats are logged to `<state>.log.txt`. He chooses his beat before he sees yours.

TELLS ON is a trial (`proto/twohands/tools/tells.mjs`, words only): before each beat you see ONE thing his body does,
taken from the beat he has already chosen - his rear shoulder drops (a cross or overhand is loaded), his knees bend (a
body punch or an uppercut), his front foot creeps (a step in), or a quiet guard. A tell is usually true; each man lies by
one fixed rule a player can learn. After each beat the tool says whether his tell was true; at each bell, how often each
tell lied. Read only the tool's output; do not read order.html, tells.mjs or the tools' code before you have played
your honest bouts (a player cannot).

A seat with NO shell (a chat seat) plays by message: you are sent the state and you answer with ONE line,
`lead=<punch|high|low> rear=<punch|high|low> feet=in|hold|back order=<feet,lead,rear in your order>` (or `clinch`), and one
line of WHY. The result of the beat comes back in the next message.

## What to do
1. PLAY YOUR BOUTS in the order your launch message gives (a shell seat: six, three with no tells and three with tells
   on, one against each opponent in each set; a chat seat: four). Decide every beat yourself, one line of WHY before
   each beat, playing to win. If your launch message gives no order: no tells first (seeds 31, 32, 33 for opp 0, 1, 2),
   then tells on (seeds 41, 42, 43).
2. JUDGE IT ON FUN, each point with the bout, round and beat that proves it:
   - the three best moments and the three dullest; a beat that felt unfair or could not be explained from what was shown;
   - is "which line is open" a READ or a coin flip - with no tells, and with tells;
   - a plan that is right every beat, a switch you never wanted, a range where nothing is worth doing;
   - each opponent: a different man? too hard, too easy? does reading him pay;
   - do rounds 2 and 3 play differently from round 1; do a knockdown, the ropes, the stamina bar change what you do.
   - WITH TELLS: did you follow them? Did you find each man's lie, and in which bout and beat? Did catching a lie feel
     good, or did the tells turn a beat into a sum with one right answer?
3. THE OWNER'S QUESTION, answered from your play, in its own section: should the game show the opponent's INTENTION
   before you choose? Judge three ways, each with a beat you played that shows it:
   (a) his whole plan shown before you choose, as many card games show an enemy's next move;
   (b) one body tell, usually true, as in your tells-on bouts;
   (c) as it is now: his last three beats and what his hands did this round, nothing about the beat to come.
   Pick one, say why, and what would have to change for it to work.
4. SCORES, 1 to 10, one line each, for the bouts with NO tells and for the bouts WITH tells: FUN, DEPTH, CLARITY,
   VARIETY. Score what you played. Say what you could NOT judge from words.
5. END WITH "TO REACH 10/10": the concrete changes, most important first, specific enough to build, each tied to a beat
   you played. Then DRAW your 10/10 fight screen as one 1920x1080 HTML page (`<dir>/ten.html`; a shell seat renders
   it with `python tools/render_mockup.py <dir>/ten.html <dir>/ten.png` if that tool runs for you, and looks at the png).

## Where the result goes
`<dir>/ALLPLAY2_<SEAT>.md` (verdict first, then a NOT SURE list, then sections 2 to 5), the state files and logs beside
it. Say in your last message: ALLPLAY2 DONE.

## Prior research
ops/research/allplay1/ (the first all-agents playtest, S558) and docs/RINGSWITCH_S558.md; the tells come from
ops/research/RINGSWITCH_TELLS_BRIEF_JOHN.md (what a real boxer reads) and RINGSWITCH_READ_BRIEF_KALLI.md (the design).
Read them only AFTER your honest bouts, then say where your play agrees and where it does not.

## What would a human do?
A playtester plays cold, talks aloud, and marks the moment he stops caring. He does not read the design first. To judge
"show his intention", he plays it both ways and says which one he wanted to keep playing.

## Prefab check
None: nothing is built for the game. The trial is words only.

## Feedback loops
None built. The trial's tell is read from his already chosen beat and feeds nothing back: his AI does not know you see
it, and showing or faking a tell costs him nothing. Say so if that made the tells too easy or too hard to use.

## Contract
OWNS: E:/FightCamp/tmp/allplay2/<seat>/ (reports only). RED_TEST: none (a playtest). REGRESSION: none (no game file
changes). VISUAL: none.

## Limits
One light command at a time (each beat a second or two). No sound, no window. If a command fails, paste its output in
the report and go on with the next bout.
