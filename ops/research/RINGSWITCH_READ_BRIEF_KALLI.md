# RINGSWITCH_READ_BRIEF_KALLI - Kalli answer (seat queue SQ335)

Brief: research/RINGSWITCH_READ_BRIEF.md
Sent: 2026-11-25 19:10 | collected: 2026-11-25 19:40 by Tools/seat_queue.py (the 30-min reconcile)
Verify the sources before using it.

---

On it. I'm writing the read design now: the table first, then the costs, the pictures, and the case against it.

**THE LOAD.** Between beats, his picture shows **one** body cue taken from the beat he has already chosen. Each cue tells you about **one** of his three switches, never the moment he acts in, and some cues are fakes. So you learn *which hand* is likely busy, but not *when* it will be out of its guard. You still have to guess the moment.

| Cue on his picture | Shown where | What it tells (if true) | True how often (proposal, NOT COMPUTED) |
|---|---|---|---|
| **Rear shoulder dropped** | his picture, rear side | his rear hand throws a big punch this beat (cross, overhand or rear uppercut), so his rear guard line opens in one of the three moments | Slugger 80%, Jabber 70%, Body Snatcher 60% |
| **Level dropped** (knees bent, chin down) | his picture, whole body | a body punch or an uppercut is coming, and his lead hand held high is likely gone | Body Snatcher 65% (fakes 1 in 3), Slugger 75%, Jabber 75% |
| **Front foot heavy** | his picture, feet | his feet step in this beat | Jabber 85%, Slugger 70%, Body Snatcher 70% |
| **Still** (plain guard) | his picture | no big punch is loaded, or he is hiding one (see costs) | n/a |
| **Tell ledger** | his card, after each round | each cue he showed this bout, marked true or false | always true |

One cue a beat, never two. Both men still act at once: the cue comes from his *chosen* beat, but you never see his switches, and he never sees yours.

**DIFFERENT FOR EACH MAN, AND HOW YOU GET BETTER**
Each man lies by one fixed, hidden rule, and the player can learn it:
- **The Jabber** tells honestly with his feet, but his shoulder drop is a fake when he's ahead on health. He loads, then jabs.
- **The Slugger** almost never fakes. When his stamina is 3 or less, he drops the shoulder and holds instead, because he's too tired to commit.
- **The Body Snatcher** fakes the level drop on purpose, and more often after you blocked his last body punch.

Bout 1 feels like 60 to 80% odds. By bout 10 you've learned *when* each man lies, so his tells are close to certain in the right moments and worthless in the wrong ones. The tell ledger is how you learn it without memorising beats.

**WHAT IT COSTS**
- **A tell is where power comes from:** any big punch (3 or more) carries its cue. Throwing it **hidden** (Still) makes it an arm punch, at −1 health.
- **A fake cue costs 1 stamina.**
- So an honest man hits harder, a hiding man hits softer, and a faking man tires. Each style leans on one of the three.
- **You have tells too:** your loaded big punches show the same cue on *your* picture, which he reads by his own skill rate (the Jabber reads best). You can hide one for the same −1, or fake one for 1 stamina. It's one toggle on the punch button, Loaded or Arm, set to Loaded by default. That is the answer to "is he reading me or playing his own game": you can watch what you showed him.

**THE PICTURES**
- **With today's set alone:** I'd draw the cue as a guard pose with one hand held high or low, plus a cue word on his card. That's honest, but it reads as a glove, not a body, and the playtester asked for body language. Good enough to test the rules.
- **Needs new pictures,** per boxer: **rear shoulder dropped**, **level dropped** and **front foot heavy**, three guard poses in all. That's three still frames per boxer, plus the same three mirrored for the player. No new motion.

**THE CASE AGAINST MY OWN DESIGN**
1. With cues 60 to 85% true, a player may just follow the cue every beat and do well. The hidden lie rules have to be strong enough to punish that.
2. A Loaded/Arm toggle is a fourth thing to set each beat, and it could bury the clean three-switch idea.
3. If the lie rules are found and posted online, the read becomes a lookup, not a skill.

**TO REACH 10 OUT OF 10 FOR FUN**, most important first:
1. **Build the three cues as words on his card first, then measure** before drawing anything. Following every cue blindly should win no more than 55% of bouts. A player who knows a man's lie rule should win 70% or more. NOT COMPUTED.
2. **The tell ledger after each round:** "Shoulder dropped 4: true 3, fake 1". The fun is in catching him lying, and that's the screen it shows on.
3. **One lie rule per man, tied to a state the player can see** (health lead, stamina, a block he just took). No random lies.
4. **Your own cue on your picture,** so you know what he saw.
5. **The three new guard poses per boxer,** once the numbers hold.
6. **The −1 arm punch and the 1-stamina fake.** Leave the toggle out until 1 to 5 pass, and add it only if hiding still matters.

Kit gap: there's no "cue" chip on the opponent card yet, and the tell ledger needs a small table component.

The read design is in the message above. Before each beat his picture shows one body cue that's usually true, and each of the three men lies by one hidden rule you can learn. A big punch shows its cue unless he throws it as a weaker arm punch, and your own big punches give cues away to him the same way.

Two things are still wrong. None of the four research files you named are in my copy of the project, which dates from 16 November and can't be updated while your computer is offline, so I worked from your brief alone. Please paste `DESIGN_TELLPLAY1.md` and `ZIVAPLAY1_REPORT.md` if you want me to check the design against why tells failed before. And none of the truth rates or win rates have been measured, so they're NOT COMPUTED until the measuring tool runs them.
