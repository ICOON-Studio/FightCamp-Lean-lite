# K_WOMEN70 (S480, Kalli): the women's 70 kg class - opponents and rivals table

The owner said yes (board Q-S294-233, "add womans only"): the game gets a fifth women's amateur class, **70 kg
(light middleweight)**, between 65 kg and 75 kg (World Boxing and England Boxing both box it). Men stay at four classes.

Write the class's content in the SAME shape the game already uses for the other classes. Fictional fighters, REAL
English amateur club names (as in the other classes). Never a real boxer's name.

## 1. The division row (one)
- name: "Light middleweight, women's amateur"   short: "light middleweight"   limit: 70.0   sex: "f"
- opponents: three fictional women (first + last name), offered in turn, even matches
- mismatch: one fictional woman, the open fighter the novice rule keeps away (many bouts, clearly better)

## 2. The rivals table (six rows, like the 65 kg class)
One row each for the three opponents + the mismatch + two more women in the class. Every row has exactly these fields:

`{"div": "wlm", "name": "...", "first": "...", "club": "<real English ABC>", "age": <18-30>, "stance": "orthodox|southpaw",
"style": "Out-boxer|Counter-puncher|Volume puncher|Pressure fighter|Boxer-puncher", "w": <wins>, "l": <losses>,
"rating": <55.0-70.0>, "threat": "<one plain sentence: what she does that hurts>", "weak": "<one plain sentence: what you can use>"}`

Rules for the numbers (copy the spread the 65 kg class uses):
- the three opponents: ratings 57-63, records under 12 bouts, one southpaw among them
- the mismatch: rating 68-70, 18-26 bouts
- the two extra rivals: ratings 58-64
- five different styles across the six rows if you can; threat and weak in game words (no jargon, no names in them)

## 3. Answer format
Give the division row and the six rivals as GDScript dictionary lines exactly as above (one per line), then one line per
row saying why that style and that weakness fit a 70 kg woman. Nothing else.
