extends RefCounted
## S410 the one corner flag on a fighter's card (Fighters > Roster): the most urgent thing only the player can answer, and where
## it is answered. Reads CoachCheck's rows; nothing here changes the career.
##   RosterFlag.pick(rows) -> {word, red, act, arg}, or {} when nothing needs a flag.

## Most urgent first: [check key, state that raises it, the word on the card, red?].
const ORDER := [
	["camp", "bad", "SET CAMP", true],
	["fight", "offer", "OFFER", false],
	["weight", "bad", "WEIGHT", true],
	["mood", "bad", "MOOD LOW", true],
]
const OFFER_WORD := "offer to answer"


static func pick(rows: Array) -> Dictionary:
	for want in ORDER:
		for r in rows:
			if str(r["key"]) == str(want[0]) and _raised(r, str(want[1])):
				return {"word": str(want[2]), "red": bool(want[3]), "act": str(r["act"]), "arg": str(r["arg"])}
	return {}


static func _raised(r: Dictionary, state: String) -> bool:
	if state == "offer":
		return str(r["word"]) == OFFER_WORD
	return str(r["state"]) == state
