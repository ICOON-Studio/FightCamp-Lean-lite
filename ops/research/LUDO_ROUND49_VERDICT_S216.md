# LUDO ROUND 49 - VERDICT: the 9 stats from the other boxing game (S216, 2026-10-13)

Asked in the Ask Ludo chat "Gym Management Screen" (header read). Ask: `LUDO_ROUND49_ASK_S216.txt` (game-facts sheet + the operator's
screenshot as text + what we already have + 5 questions, 11.1k chars). Reply verbatim: `LUDO_ROUND49_REPLY_S216.txt` (26,966 chars, one
message, complete).

## The short answer
We do NOT add any of the nine as new core stats. Six are already in the game under our names, two are arcade ideas we reject, and two of
them point at something real that we are missing: how fast a boxer's heart comes down in the corner, and how easily his face cuts.

| Their stat | Ours | Verdict |
|---|---|---|
| Accuracy | comes from TECHNIQUE vs the other man's DEFENCE | not added - a flat accuracy number would double-count technique |
| Attack Speed | SPEED | not added - same thing |
| Strength | POWER | not added - same thing |
| Chin | CHIN | already there |
| Footwork | FOOTWORK | already there |
| Stamina | STAMINA (conditioning + the heart-rate cardio) | already there |
| Health | the six body regions (fine / hurt / critical / doctor) | rejected - one HP bar is a step backwards |
| HP Recovery | - | becomes CUT & SWELL RESISTANCE (new readout) |
| SP Recovery | - | becomes RECOVERY RATE (new readout) |

## What gets added (operator approves)
1. RECOVERY RATE - how many beats per minute his heart drops in the 60 s corner, and how fast it settles when he steps out of range in a
   round. Ludo's real-world anchors: about 19 BPM per break for a poor engine, 33 for an elite one (heart-rate recovery is a real,
   measured trait). Generated from conditioning plus a small personal variation; trained slowly by roadwork, rower, air bike and hard
   sparring rounds; peaks in the early twenties and falls from 29, faster from 34; the breathing technique (boxing_breathing_rhythm, in our
   catalogue) adds a little. Scouts see a range until they have watched him.
2. CUT & SWELL RESISTANCE - how easily his face opens and swells. We already track scar tissue (the doctor/scar rules, CutsDoctor):
   this readout shows that existing scar level to the player as a 0-100 with plain words ("skin clean" / "mild scar tissue over the right
   eye" / "heavy scar tissue - cut risk"), so a veteran of wars reads as cut-prone before the fight. Every bad cut lowers it for good; it
   cannot be trained, only protected (headgear in sparring, full healing before the next fight).
3. TALE OF THE TAPE - we already have one before the fight. It gets the two new rows and a "signature threat" row (his best-staged
   technique), and every row shows a range until he is scouted.

## Changed or rejected by Claude
- NO DOUBLE COUNTING: conditioning already drives stamina recovery. Recovery Rate takes over part of that job (the corner and the in-round
  breather) with the AVERAGE fighter recovering exactly as today, so fights stay calibrated; only the spread between men grows.
- REJECTED: Ludo's weight-class bias (heavyweights -12, flyweights +14) - no source; generation uses conditioning + personal variation only.
- REJECTED: a second cut-chance multiplier. The existing scar rules already make a scarred man cut more easily; the new readout SHOWS that
  number instead of adding another one on top. Ludo's cutman-efficiency formula waits for its own corner round.
- REJECTED: "high composure restores 4-8 points of Ring IQ in the corner" (a new mechanic, not asked).
- Ludo's own numbers (BPM anchors, ageing slopes, training rates) are design values, bounded in tests - never gated as exact counts.

## Build order (after your OK)
1. Pure module: Recovery Rate (generation, training, ageing) + the Cut & Swell readout words from the scar level, with tests (cloud seat).
2. Engine: the corner and in-round heart-rate drop read Recovery Rate (average unchanged - a control arm proves it); a 12-round test shows an
   80 man clears more beats per break than a 20 man and throws more in round 12.
3. Profile + Tale of the Tape rows with scouting ranges, animated bars; stills to Ludo, then to you.
