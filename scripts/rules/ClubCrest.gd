extends RefCounted
## S412 operator on the versus screen: "behind the maybe the lgoos of each gym ?". Each club keeps one crest for good, from seven
## Ludo stamps (assets/ui/art/crests). A club whose name holds a crest's word takes that one. Pure.
##   of(club) -> crest name. pair(a, b) -> [crest of a, crest of b], never the same. path(name) -> the texture.

const CRESTS := ["glove", "anvil", "lion", "bulldog", "fist", "bell", "laurel"]
const WORDS := {"lion": "lion", "anvil": "anvil", "bell": "bell", "glove": "glove", "bulldog": "bulldog", "fist": "fist", "star": "laurel"}


static func of(club: String) -> String:
	var low := club.to_lower()
	for w in WORDS:
		if low.contains(w):
			return WORDS[w]
	return CRESTS[absi(hash(low)) % CRESTS.size()]


static func pair(a: String, b: String) -> Array:
	var ca := of(a)
	var cb := of(b)
	if ca == cb:
		cb = CRESTS[(CRESTS.find(cb) + 1) % CRESTS.size()]
	return [ca, cb]


static func path(crest: String) -> String:
	return "res://assets/ui/art/crests/%s.png" % crest
