# TASK K30 — KALLI — WHAT A FIGHTER DOES BETWEEN EXCHANGES, AND HOW A HIT MOVES HIS HEAD

**Research only.** No code, no downloads. Prose, numbers, citations. One pass. Reply in this chat.

## Why this exists

We are building a fighting game that must LOOK like a real bout, and every automated test that claims
realism has to compare the game with numbers measured in real bouts (the operator's rule). Your K29 gave us
the time-motion structure and marked these NOT FOUND. Our realism test now has rules that stand on nothing
because of them: how a boxer's neutral time is filled (he is never frozen - but with what, how often, how
big), and how a head moves when a punch lands. Find those numbers, from DIFFERENT kinds of sources than K29
searched: sports-biomechanics lab and field studies (IMU, force plate, motion capture, high-speed video),
notational/video analyses of real bouts, and injury-biomechanics studies of head impacts.

## What we already hold - do NOT re-research, cite only if you extend or correct

- JPES 2016 (boxing time-motion): active 1.2 +- 0.8 s, inactive 2.3 +- 1.8 s; inactive over 4 s averages
  5.6 +- 1.7 s about 7.6 times a round.
- Dunn 2017 (elite national male boxers), as K29 read it: bounce time per round R1 57 +- 27 s, R2 45 +- 28,
  R3 44 +- 26 (of about 180 s); step time about 63-69 s; guard-drop cumulative time R1 24 +- 15 -> R3 34 +- 19 s.
- Menzel & Potthast 2021 (bag, n=11): retraction to guard cross 169 +- 41 ms, hook 168 +- 97, jab 262 +- 42,
  uppercut 171 +- 33.
- Schortgen 2023 (32 French elite bouts): distance between the men 1.23 +- 0.16 m.

## What to find - one table row per quantity, per discipline where it differs

1. **Verify Dunn 2017.** Its full citation and DOI or URL, the sample, and whether the bounce and step
   figures above are what its table actually says (they came from a table image). Correct them if not.
2. **Bounce in neutral:** frequency (Hz or bounces per minute) and vertical amplitude (cm) of a boxer's,
   kickboxer's or taekwondo athlete's rhythmic bounce while in stance. Taekwondo and karate kumite
   footwork studies are the likeliest source; say which sport each number is from.
3. **Steps in neutral:** steps per second or per minute, and step length (cm), while moving in stance
   (not attacking).
4. **Standing still:** any measure of how much of neutral time a fighter is stationary in stance versus
   bouncing or stepping (a share or seconds per round).
5. **Stance switches:** how often orthodox/southpaw switches happen per round in boxing, kickboxing or MMA.
6. **How a landed punch moves the head:** peak linear acceleration (g), peak rotational acceleration
   (rad/s^2) or velocity (rad/s), head displacement (cm or degrees), and the time from contact to peak (ms),
   for jab/cross/hook/uppercut where split. Real bouts, sparring or instrumented dummies - say which.
7. **How long a hit reaction lasts:** time from contact until the struck fighter's head or trunk is back in
   stance, or until he throws again, in real bouts or sparring.

## Rules

- Label every number: **DOCUMENTED** (you read it in the primary study), **SECONDARY** (a review quoting a
  named study), **LAB** (bag, pad, dummy or lab task, not a bout), or **NOT FOUND**. NOT FOUND is a valid
  answer - never fill a cell with a guess or a coaching rule of thumb.
- Every row: the number with its spread (mean +- SD or range), the sample (n, level, sex, weight class if
  given), and the source (authors, year, title, journal, DOI or URL).
- A number you could not open the primary for is SECONDARY at best - say what you could and could not read.

## Deliverable

One markdown table per quantity (1-7), columns: Quantity | Sport and sample | Number (+- spread) | Label |
Source. Then a short **GAPS** list of what is still NOT FOUND, and for each, the kind of source that could
answer it.
