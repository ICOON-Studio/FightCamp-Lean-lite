# ALLPLAY3 - play Puncher's chance as it is today and judge it (S567)

Owner, 2026-11-26 (S567): "have agents to playetest , judge the current version".
Kind: playtest. Discipline: boxing. You write a report and nothing else: no game file, no page file, no commit (Arena:
commit only your report folder). Nothing opens on the owner's screens (your image tool only; no browser, no viewer).

## What it is
Puncher's chance is a small boxing game the owner loves (older notes and the tool's own words call it "Ring Switches":
the same game). Each beat you set three switches (lead hand, rear hand, feet) and the order you throw them; he sets his at
the same time; three moments are played out. A hand that does not punch is held high or low and blocks one line. Three
ranges (Inside, Mid, Long). Three rounds of six beats. It is a browser page (`proto/twohands/order.html`, version
0.567.2), so you play it IN WORDS, on the page's own rules and its own three opponents (from E:/FightCamp/Lean, or from
your clone of the repo):

```
node proto/twohands/tools/play_cli.mjs help                                  (every switch, cost, reach, what blocks what, the points)
node proto/twohands/tools/play_cli.mjs new  <dir>/b1.json opp=0 seed=71      (0 Jabber, 1 Slugger, 2 Body Snatcher)
node proto/twohands/tools/play_cli.mjs beat <dir>/b1.json lead=jab rear=high feet=in order=feet,lead
node proto/twohands/tools/play_cli.mjs beat <dir>/b1.json clinch
node proto/twohands/tools/play_cli.mjs show <dir>/b1.json
```
`<dir>` is `E:/FightCamp/tmp/allplay3/<your seat name>/` (a cloud seat: `ops/research/allplay3/<seat>/` in its clone).
Each bout's beats are logged to `<state>.log.txt`. He chooses his beat before he sees yours. NO TELLS in this round: the
page has none today. Read only the tool's output; do not read order.html or the tools' code before your bouts (a player
cannot).

A seat with NO shell (a chat seat) plays by message: you are sent the state and you answer with ONE line,
`lead=<punch|high|low> rear=<punch|high|low> feet=in|hold|back order=<feet,lead,rear in your order>` (or `clinch`), and one
line of WHY. The result of the beat comes back in the next message.

NOT in this round: kicks, head movement, the "All in" switch (the words tool plays the boxing page only). Say what you
could not judge.

## What to do
1. PLAY THREE BOUTS, one against each man: seeds 71, 72, 73 for opp 0, 1, 2. Decide every beat yourself, one line of WHY
   before each beat, playing to win.
2. JUDGE IT ON FUN AND DEPTH, each point with the bout, round and beat that proves it:
   - the three best moments and the three dullest; a beat that felt unfair or could not be explained from what was shown;
   - is "which line is open" a READ or a coin flip;
   - a plan that is right every beat (name it and how often it won), a switch you never wanted, a range where nothing is
     worth doing;
   - each opponent: a different man? too hard, too easy? does reading his last beats pay;
   - do rounds 2 and 3 play differently from round 1; do a knockdown, the ropes, the stamina bar change what you do;
   - the feint, the overhand and the clinch: did "step in, feint, overhand, then clinch" win for you? How often did you
     use it, and what stopped it?
3. THE SCREEN (only if you can open images; say so if you cannot): `ops/research/allplay3/screens/` holds three stills
   of the page a player sees - his lead hand's moves at Long, his rear hand's moves at Mid, the opponent's lead hand.
   Each punch card shows the ranges it reaches (lit), where he will stand when it goes (framed), its damage (red) and its
   stamina cost (green). Could a new player choose a beat from this screen with no manual? What is missing, what is noise?
4. IF YOU PLAYED AN EARLIER ROUND (ALLPLAY1 or ALLPLAY2: your own report, read it AFTER your bouts): what is better, what
   is worse, what is unchanged, beside your earlier scores.
5. SCORES, 1 to 10, one line each: FUN, DEPTH, CLARITY, VARIETY. Score what you played.
6. END WITH "TO REACH 10/10": the concrete changes, most important first, specific enough to build, each tied to a beat
   you played. Then DRAW your 10/10 fight screen as one 1920x1080 HTML page (`<dir>/ten.html`; a shell seat renders it
   with `python tools/render_mockup.py <dir>/ten.html <dir>/ten.png` if that tool runs for you, and looks at the png).

## Where the result goes
`<dir>/ALLPLAY3_<SEAT>.md` (verdict first, then a NOT SURE list, then sections 2 to 6), the state files and logs beside
it. Say in your last message: ALLPLAY3 DONE.

## Prior research
ops/research/allplay1/ and ops/research/allplay2/ (the earlier all-agents playtests, S558 and S563),
docs/RINGSWITCH_S558.md. Read them only AFTER your honest bouts.

## What would a human do?
A playtester plays cold, talks aloud, and marks the moment he stops caring. He does not read the design first.

## Prefab check
None: nothing is built for the game.

## Feedback loops
None built: a report only. One to watch while you play: a plan that wins makes you repeat it, and his AI reads your last
beats - say whether repeating a winning beat got punished, and by which man.

## Contract
- OWNS: ops/research/allplay3/<seat>/ALLPLAY3_<SEAT>.md (and the bout files beside it)
- RED_TEST: none (a playtest)
- REGRESSION: none
- VISUAL: none
