# TASK K-HABITS1 - KALLI - fighter habits, mood lines and the coach's notes (lean restart, fight model words)

Model: Kalli (Grok bot, game design + content). Discipline: boxing (demo). Words and numbers only: no code, no repo.

## What exists
A boxing gym manager (PC, deep management sim, think Football Manager). The player runs a London gym with women amateur
boxers (Lucy Jackson, Kira Mensah, Samira Okafor, Tess Reilly), books bouts, runs camps, and watches the fights (words +
a 3D view). The agreed fight model gives every fighter:
- 8 ratings: power, speed, technique, defense, conditioning, fight_iq, chin, footwork.
- 4 style dials: pressure <-> out-boxer, work rate, head/body targeting, counter tendency.
- 6 hidden personality traits 0-100: heart, temper, confidence, discipline, coachability, loyalty.
- 2 habits from a bank (below), learned by the player, never shown as numbers.
- 1 stored morale 0-100 shown as a word: Fired up (75+) / Steady (50+) / Flat (30+) / Low.
Morale moves with: win +8, loss -12, goal met +10, goal missed -20, rest week +4, a month without a fight -6, a bout booked +5.
The player learns a fighter from a COACH'S NOTES card that fills in with words from sparring, trials and fights, and an
opponent's from scouting and film study.

## What to write (answer every part; longest complete answer you can, then "continue")
1. HABIT BANK: 20 habits. For each: an id (snake_case), the plain name, WHEN it fires in a round (trigger), WHAT the ring
   shows (one beat a 3D view can play with: jab, cross, lead hook, body hook, uppercut, block, slip, weave, step in, step
   out, clinch, cover up, tired idle, taunt), what it COSTS or GAINS (who it helps), and how an opponent who studied the
   film punishes it. Our first 8 ids, keep them and add 12: drops_right_after_jab, slow_starter, digs_body_when_hurt,
   freezes_on_ropes, switches_stance_under_pressure, talks_when_ahead, loads_up_when_hurt, covers_up_when_hurt.
2. COACH'S NOTES: for each habit, 3 short notes (max 60 characters) as a coach would say them after sparring ("Drops the
   right after she jabs. Every time."). And 2 notes per personality trait, one for high and one for low (12 x 2).
3. MOOD LINES: for each of the 4 mood words, 4 one-line reasons the fighter card shows (max 48 characters), tied to the
   events above ("Hasn't fought in 3 months", "Two wins on the bounce").
4. IN-RING LINES: 15 short lines (max 70 characters) that tie a beat to training ("Her hook keeps landing: six weeks on
   the pads"), with the condition that triggers each (which number or habit).
5. JSON at the end, exactly this shape, every string filled:
   {"habits":[{"id":"","name":"","trigger":"","beat":"","effect":"","punish":"","notes":["","",""]}],
    "trait_notes":{"heart":{"high":"","low":""}, ...},
    "mood_lines":{"Fired up":["","","",""],"Steady":[...],"Flat":[...],"Low":[...]},
    "ring_lines":[{"when":"","line":""}]}
   Use {name} and {her} as placeholders where a name or pronoun goes.

## Prior research
Our old project's personality design (2026-09-04) and Football Manager's hidden attributes + coach reports; the S299 fight
model (operator-approved).

## What would a human do?
Football Manager scout reports ("Tends to dive into tackles"), Fight Night Champion fighter tendencies, a real coach's
sparring notebook.

## Prefab check
Words only; nothing to buy.
