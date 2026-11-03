# TASK K_MEN1 - KALLI - the men's opponents for FightCamp's divisions
Kind: research

Status: OPEN (S370, Claude). The game adds men's boxing (operator S370). Write the men's opponents for FOUR men's
amateur divisions (use featherweight 57, lightweight 60, welterweight 67, middleweight 75 until John's J_MEN1 confirms
the limits): per division 3 opponents + 1 mismatch, in exactly this format (copy the women's rows' shape):
{"div": "<id>", "name": "<full name>", "first": "<first>", "club": "<a REAL UK amateur boxing club>", "age": 18-29,
 "stance": "orthodox"|"southpaw", "style": "Pressure fighter"|"Counter-puncher"|"Out-boxer"|"Volume puncher"|"Slugger",
 "w": int, "l": int, "rating": 52-70, "threat": "<one line: what hurts you>", "weak": "<one line: the opening>"}
Fictional people, real club names, a mix of backgrounds; no real boxer's name. Then 6 lines of WORLD news a men's
division would carry (results, an upset, a rival gym). Plain JSON rows, then the news lines.
