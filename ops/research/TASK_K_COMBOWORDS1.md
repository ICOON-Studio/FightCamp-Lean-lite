# TASK K-COMBOWORDS1 - KALLI - the words for combos (captions, coach's lines, week review)

Kind: content (game words). Model: Kalli. Discipline: boxing (demo). Assigned 2026-10-29 (S302).

## Why
The game (women's amateur boxing management, you wrote the habit bank and the ring lines) gets 10 trainable
combinations, learned on the pads, costing energy in the fight. Design: research/COMBOS_DESIGN_S302.md.
The combos (coach's call names): 1-1 (double jab), 1-2, 1-1-2, 2-3 (cross, lead hook), 1-2-3, 1-2-3-2,
3b-3 (lead hook to the body, then the head), 1-2-3b (jab, cross, hook to the body), 1-6-3 (jab, rear uppercut, lead
hook), slip 2-3 (slip, then cross and lead hook: the counter).

## What to write (JSON, so it drops into assets/data/combo_words.json)
{"combos": [{"id": "1-2", "name": "<what fans and coaches call it, short>", "plain": "<one line: what it is, for a
player who never boxed>", "coach_learning": ["<3 lines the coach says while she drills it>"], "coach_signature":
["<2 lines once it is her signature>"], "ring_lands": ["<2 short captions when it lands in a fight, {name} = her
first name>"], "ring_tired": ["<1 caption when she is too tired to finish it>"]}, ...],
 "energy_lines": {"fresh": ["<2>"], "tiring": ["<2>"], "empty": ["<2>"]}  (corner/commentary lines by her energy)}
Rules: plain words, short (captions under 70 characters), British amateur gym voice like your habit bank, no swearing,
women's boxing ("she"). No numbers in the lines.
