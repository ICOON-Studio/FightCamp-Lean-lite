# Combos - design for approval (S302)

You asked: "we need to introduce combos, how to make them trainable, how they will work". This is my design. Nothing
is built until you approve it.

## What real boxing says (the evidence)
- Half of all attacks are combinations. Elite women amateurs (2023 World finals) split almost evenly between single
  punches and combinations (winners 47% combos, losers 52%).
- A few combos do most of the work. Half of all combinations seen in bouts are 12 standard ones; the most common is
  the jab-cross (the "1-2"). Lighter weights use more variety (Thomson 2012).
- A combo is one learned movement, not separate punches. Boxers throw a drilled combination faster than single punches
  (start to contact 0.32 s in a combo vs 0.61 s for a lone power shot), and punch 1 to punch 4 lands in about
  1.05 s when hands alternate, 1.35 s when the same hand repeats (Piorkowski, Lees & Barton 2011).
- A jab lands slightly more often inside a combo than alone (49% vs 45%, Thomson 2012).
- Combos are learned on the pads, with a coach calling them, one at a time, until the fighter throws them without thinking.

## How it works in FightCamp
1. A COMBO BOOK. Ten real combos, named the way coaches call them (punch numbers: 1 jab, 2 cross, 3 lead hook,
   5/6 uppercuts, b = to the body):
   1-1 (double jab), 1-2, 1-1-2, 2-3 (cross, hook), 1-2-3, 1-2-3-2, 3b-3 (hook to the body, then the head),
   1-2-3b (finish downstairs), 1-6-3 (jab, uppercut, hook), and 2-3 off a slip (the counter combo, needs Check hook).
2. TO LEARN ONE, she must own every punch in it: each punch at least USABLE (30), the same line where a move becomes
   a weapon today. A fighter with only a jab and a cross can learn the 1-1, the 1-2 and the 1-1-2, nothing else.
3. TRAINING. In her week plan you pick the combo she is drilling (beside the move she is learning). Pad rounds with
   the coach build it, like a move: RAW -> USABLE -> SHARP -> SIGNATURE. Longer combos take longer (a 4-punch combo
   about twice a 2-punch one). A combo can never be sharper than its weakest punch, and the old cap from her
   technique and ring IQ applies. Combos she stops drilling fade slowly, like moves.
4. IN THE FIGHT (the result). Each USABLE combo adds a small edge to her rounds, like an extra weapon does now, a
   little more when it is SHARP or SIGNATURE. Small on purpose: about the 4-point accuracy gain the real numbers show,
   never a win button. Opponents get combos too, from their style and the scout's words ("doubles the jab" = 1-1).
5. IN THE RING (what you see). Her exchanges are her real combos, picked from her book, her best ones most often;
   a fighter with no combos throws single punches and the odd 1-2. A better-drilled combo is visibly quicker: a RAW
   combo lands about 0.45 s a punch, a SIGNATURE one about 0.30 s (around the measured 0.35 s). When a SIGNATURE combo
   lands, the caption names it ("The 1-2-3 she drilled all camp").
6. WHERE YOU SEE IT. FIGHTERS > her page > Attributes and moves gets a COMBOS section (the same bars and tiers as
   moves, locked ones show which punch they still need). The week review says "1-2-3 is now USABLE". The coach's
   notes can say "Throws the 1-2 like she was born with it."

## Who builds what (after your yes)
- Qwen: the pure rules module (the combo book, unlock, training gain, fade, fight edge) + its test.
- Claude: wiring into training, the fight result, RoundScript and the 3D ring, the screen, stills and a film.
- Kalli: the combo names' captions and the coach's lines for each combo.

## Added on his yes (2026-10-29): "combos should also be associated with energy (stamina) in the fight"
7. ENERGY. Every boxer has an energy tank that runs across the bout. Single punches cost a little, combos cost more,
   longer combos cost more per punch. Her conditioning sets how fast she burns it and how much comes back in the
   minute between rounds. A tired boxer (low tank) throws shorter and slower combos, gets less edge from them and,
   near empty, loses power in the round; the ring shows it (shorter exchanges, tired beats). The corner call matters:
   "calm" spends less, "to the body" more. Numbers start as marked estimates; John researches the real ones (energy
   cost of combinations, how output falls by round 3 in women's amateur boxing) and they get calibrated.
