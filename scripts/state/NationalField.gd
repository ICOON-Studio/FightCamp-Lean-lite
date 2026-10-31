extends RefCounted
## S328 update 30: the other regions' champions at the National Amateur Championships (fictional boxers, real club names
## outside London). One field per championship and division, made from the career's own dice, so two careers meet
## different women and a reload meets the same ones.

## Champions of the other regions: stronger than a club-show opponent (the London region's own run 58-72).
const RATING_MIN := 62.0
const RATING_MAX := 73.0

const CLUBS: Array[Dictionary] = [
	{"club": "Collyhurst & Moston Lads Club", "region": "North West"},
	{"club": "Rotunda ABC", "region": "North West"},
	{"club": "Everton Red Triangle ABC", "region": "North West"},
	{"club": "Birtley ABC", "region": "North East"},
	{"club": "Hartlepool Catholic ABC", "region": "North East"},
	{"club": "Steel City ABC", "region": "Yorkshire"},
	{"club": "Burmantofts ABC", "region": "Yorkshire"},
	{"club": "Small Heath ABC", "region": "Midlands"},
	{"club": "Wednesbury ABC", "region": "Midlands"},
	{"club": "Hoddesdon ABC", "region": "Eastern Counties"},
	{"club": "Leicester ABC", "region": "East Midlands"},
	{"club": "Bristol ABC", "region": "Western Counties"},
]
const FIRST: Array[String] = ["Ellie", "Kayla", "Niamh", "Shauna", "Leah", "Courtney", "Hannah", "Zara", "Molly", "Amira",
	"Jess", "Paige", "Demi", "Rachel", "Keira", "Lauren"]
const LAST: Array[String] = ["Booth", "Farrell", "Mensah", "Clarke", "Hargreaves", "Quinn", "Iqbal", "Doherty", "Walker",
	"Kaur", "Riley", "Thornton", "Ellis", "McGuire", "Shaw", "Barker"]
## Style, what she hurts you with, what you can use (the same words the region's opponents carry).
const STYLES: Array[Array] = [
	["Pressure fighter", "Body hooks in close", "Walks in straight"],
	["Counter-puncher", "Right hand counter over the jab", "Slow to start"],
	["Volume puncher", "Never stops throwing", "Leaves her chin open"],
	["Boxer-puncher", "Straight right", "Stands still after combinations"],
	["Out-boxer", "A long jab she lives behind", "Struggles when she is backed up"],
	["Pressure fighter", "Left hook to the body", "Fades after round 2"],
]


## `count` entrants for the division, each a full opponent (the fight reads name, first, club, stance, style, record,
## rating, threat, weak). Names never repeat inside a field.
static func field(seed_value: int, count: int, div: String) -> Array:
	var rng := RandomNumberGenerator.new()
	rng.seed = seed_value
	var firsts: Array = FIRST.duplicate()
	var lasts: Array = LAST.duplicate()
	var clubs: Array = CLUBS.duplicate()
	_shuffle(firsts, rng)
	_shuffle(lasts, rng)
	_shuffle(clubs, rng)
	var out: Array = []
	for i in mini(count, mini(firsts.size(), clubs.size())):
		var st: Array = STYLES[rng.randi_range(0, STYLES.size() - 1)]
		var w := rng.randi_range(6, 16)
		var height := rng.randi_range(160, 174)
		out.append({"name": "%s %s" % [firsts[i], lasts[i]], "first": firsts[i], "club": clubs[i]["club"],
			"region": clubs[i]["region"], "age": rng.randi_range(19, 29), "stance": "southpaw" if rng.randf() < 0.25 else "orthodox",
			"style": st[0], "threat": st[1], "weak": st[2], "w": w, "l": rng.randi_range(1, maxi(2, w / 3)),
			"height": height, "reach": height + rng.randi_range(-1, 4),
			"rating": snappedf(rng.randf_range(RATING_MIN, RATING_MAX), 0.5), "div": div})
	return out


static func _shuffle(a: Array, rng: RandomNumberGenerator) -> void:
	for i in range(a.size() - 1, 0, -1):
		var j := rng.randi_range(0, i)
		var t = a[i]
		a[i] = a[j]
		a[j] = t
