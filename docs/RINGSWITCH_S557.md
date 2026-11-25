# Ring Switches, S557 (2026-11-25): a page defect fixed, Ziva's clarity changes, Kalli's table measured, the low cover

Page: `proto/twohands/order.html` (http://127.0.0.1:8797/order.html). Tweak files: `ops/research/s557_balance/`.

## NOT GREEN (read this first)
- **The owner has not played this page.** I played ten beats in the browser (one bell); a test plays whole bouts.
- **"Have it playtested by all agents and also you" (owner, S557) is NOT done.** The brief is written
  (`ops/research/TASK_ALLPLAY1.md`); no seat was started and I did not play my bouts: the session reached its size limit.
- **The low-cover pictures are on the page (6 runs, gate 6 of 6, anim_check 124 of 124) but he has not seen them**, and no
  Godot test was run on the picture tools (fight_pictures_test). Strips: `ops/previews/s557_lowcover/`.
- **Ziva's three rule ideas and the ground rule for the look-ahead are measuring, not read**: outputs land in
  `E:/FightCamp/tmp/s557_ziva/` (block_g1, block_g2, block_g2w, chase) and `E:/FightCamp/tmp/s557_ground/`
  (gave_15, gave_30, gave_50, ropes50, and `probe_*.txt`). Nothing of them is on the page.
- The page is taller than a 1080 screen (the switches end at about 1416 px at 1920x1080): it scrolls, as before.
- The jab lands 73% and the body jab 69% on the measuring tool (the old failing bar): unchanged.

## A defect on the page he plays, fixed
Since S556 a comment had swallowed the line that puts a round on the cards (`cards.push(sc)`), so in the browser no
round reached the cards and a bout that went the distance ended "A DRAW 0-0". The 34 rule tests could not see it: they
test the rules above the page mark, and the bell is below it. Now the judging is one rule (`judge`) shared by the page
and the words tool, and `proto/twohands/tools/page_play_test.mjs` plays the page itself to the last bell (4 tests, 30 s;
it goes red with the line commented out again). Run it after every page edit.

## ZIVAFIX1: what Ziva's playtest asked for (words and display, no rule changed, so no new table)
- His last three beats are on his card before you choose, holds included; the hover counts what each of his hands did
  this round and says how to stop his last beat (that paragraph left his card: he likes little text).
- A landed punch says its points; a body punch says "stamina bar 6 for the rest of the bout"; the bar draws its lost
  end and the label says "(was 8)"; the floor (4) is in the hover.
- A man down twice reads "down 2x - one more ends it". The score hover says why points differ from health.
- A switch the stamina cannot pay is switched off in words ("Switched off: Overhand - you have 2 stamina"), and only
  after the bell has given the stamina back (it was dropped silently, and before the refill).
- The words tool (`play_cli.mjs`): the same lines, his last three beats, and a plan you cannot pay for is offered again
  without its dearest switch.

## Kalli's cover table for the open stance (SQ334), measured: none passes, nothing built
| Version | Bars | What broke |
|---|---|---|
| A: as she wrote it (rear hand high takes 1 off the cross, nothing stops it fully) | 4 of 9 | the cross is in 65% of beats, 9.3 a bout, lands 86%; 90% of bouts stopped, 4.6 knockdowns |
| A2: the softened cross still scores 2 points | 4 of 9 | the same bouts (only the cards differ) |
| B: her own fallback (rear hand high stops the cross, takes 1 off the overhand) | 6 of 9 | the overhand is in 38% of beats, 5.7 a bout, lands 79%; 73% stopped; the cross falls to 1.4 a bout |
Her own "case against my table" was right. Against John's two facts: A throws the cross far MORE (9.3 against 3.8) but
the jab lands 84%, not under 73%; B throws the cross LESS. The owner's rule stands ("Wait for Kalli"; build at 8 bars
or more): the southpaw is not built. Seven versions have now failed; the pattern is that whichever rear punch no hold
stops fully becomes the only punch.

## Do the opponents repeat the identical beat? (Ziva's point 6) - measured: rarely
`probe_repeats.mjs`, 30 bouts a pairing: the same beat three times running in 0 to 10% of bouts against a player who
spams one plan, 0 to 3% against a player who answers his last beat; the same two hands three times running in 0 to 17%.
A spammed plan loses every bout (stopped 97 to 100%): the read works. Letting him vary his answer changes nothing
that matters. Not a rule problem; what the player needs is the READ (sent to Kalli SQ335 and John SQ336).

## LOWCOVER1: a blocked body punch is stopped at the body (the animation item)
Study: J50 row 2 ("low block / elbow-down body guard"); the page's own rule (the lead hand held low blocks body
punches). Take: the authored hold `hold_lead_low` (HOLDTAKES1), no new take and no layer. The picture tool now tries it
first for a blocked body punch and ends the glove on that low glove; a new picture bar (`body_up_m`, the glove's front
at most 0.20 m over the body target) is red on the S556 pictures.

| Run | S556 cover-up | The lead hand held low |
|---|---|---|
| red body jab / hook / cross, blocked | 0.47 / 0.29 / 0.48 m over the body | 0.17 / 0.15 / 0.19 m |
| blue body jab / hook / cross, blocked | 0.54 / 0.36 / 0.53 m | 0.17 / 0.09 / 0.18 m |
Looked at by me on three contact frames: it reads as a body punch met by the low glove. NOT seen by the owner. A MISSED
body punch is unchanged (still at chest height).

## Tests
`rules_test.mjs` 34 pass, `page_play_test.mjs` 4 pass, `page_parse.mjs order.html` ok. No Godot test was run (only
picture tools changed under tools/; the game's scripts are untouched, so no export).
