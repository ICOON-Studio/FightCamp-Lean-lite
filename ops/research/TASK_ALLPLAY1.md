# ALLPLAY1 - every agent plays Ring Switches and judges it on FUN (S557)

Owner, 2026-11-25 (S557): "have it playtested by all agents and also you".
Discipline: boxing. You write a report and nothing else: no game file, no page file, no commit. Nothing opens on the
owner's screens (your image tool only; no browser window, no viewer).

## What it is
Ring Switches is a small boxing game the owner loves. Each beat you set three switches (lead hand, rear hand, feet) and
the order you throw them; he sets his at the same time; three moments are played out. A hand that does not punch is
held high or low and blocks one line. Three ranges. It is a browser page, so you play it IN WORDS, on the page's own
rules and its own three opponents (from E:/FightCamp/Lean, or from your clone of the repo):

```
node proto/twohands/tools/play_cli.mjs help                                  (every switch, cost, reach, what blocks what, the points)
node proto/twohands/tools/play_cli.mjs new  <dir>/b1.json opp=0 seed=<your seed>     (0 Jabber, 1 Slugger, 2 Body Snatcher)
node proto/twohands/tools/play_cli.mjs beat <dir>/b1.json lead=jab rear=high feet=in order=feet,lead
node proto/twohands/tools/play_cli.mjs beat <dir>/b1.json clinch
node proto/twohands/tools/play_cli.mjs show <dir>/b1.json
```
`<dir>` is `E:/FightCamp/tmp/allplay1/<your seat name>/` (a cloud seat: any folder of its own). Each bout's beats are
logged to `<state>.log.txt`. He chooses before he sees your beat. Read only the tool's output; do not read order.html or
the tools' code before you have played your honest bouts (a player cannot). New since the first playtest: the tool
prints his last three beats and what each of his hands did this round, the points of every landed punch, what a body
punch does to the stamina bar, and offers a cheaper plan when you cannot pay for yours.

A seat with NO shell (a chat seat) plays by message: you are sent the state and you answer with ONE line,
`lead=<punch|high|low> rear=<punch|high|low> feet=in|hold|back order=<feet,lead,rear in your order>` (or `clinch`), and one
line of WHY. The result of the beat comes back in the next message.

## What to do
1. PLAY SIX BOUTS (a chat seat: three), deciding every beat yourself, one line of WHY before each beat:
   two against each opponent, playing to win (a chat seat: one against each).
2. JUDGE IT ON FUN, each point with the bout and beat that proves it:
   - the three best moments and the three dullest; a beat that felt unfair or could not be explained from what was shown;
   - is "which line is open" a READ now that his last three beats are shown, or still a coin flip;
   - a plan that is right every beat, a switch you never wanted, a range where nothing is worth doing;
   - each opponent: a different man? too hard, too easy? does reading him pay;
   - do rounds 2 and 3 play differently from round 1; do a knockdown, the ropes, the stamina bar change what you do.
3. SCORES, 1 to 10, one line each: FUN, DEPTH, CLARITY, VARIETY. The first playtest (Ziva, before this week's changes)
   gave 6, 7, 6, 6: do not anchor on it, score what you played. Say what you could NOT judge from words.
4. END WITH "TO REACH 10/10": the concrete changes, most important first, specific enough to build, each tied to a beat
   you played. Then DRAW your 10/10 fight screen as one 1920x1080 HTML page (`<dir>/ten.html`).

## Where the result goes
`<dir>/ALLPLAY1_<SEAT>.md` (verdict first, then a NOT SURE list, then the sections above), the state files and logs
beside it. Say in your last message: ALLPLAY1 DONE.

## Prior research
ops/research/ZIVAPLAY1_REPORT.md (the first playtest) and docs/RINGSWITCH_S556.md (what the measuring bots say) - read
them only AFTER your honest bouts, then say where your play agrees and where it does not.

## What would a human do?
A playtester plays cold, talks aloud, and marks the moment he stops caring. He does not read the design first.

## Prefab check
None: nothing is built.

## Limits
One light command at a time (each beat a second or two). No sound, no window. If a command fails, paste its output in
the report and go on with the next bout.
