extends SceneTree
## S310 the tale of the tape (TaleOfTape.rows): every row has a label and both boxers' values; our fighter's height is the
## body she is drawn with until she has her own, her reach follows it; the opponent's come from her own data.

const TaleOfTape := preload("res://scripts/rules/TaleOfTape.gd")
const Data := preload("res://scripts/state/Data.gd")

var failures := 0


func _initialize() -> void:
	var f := Data.fighter_state(Data.lucy(), 20)
	var opp: Dictionary = Data.OPPONENTS[0]
	var rows := TaleOfTape.rows(f, opp, "Anvil Street Gym", 169.0)
	var by := {}
	for r in rows:
		by[str(r[0])] = r
	_check(rows.size() == 8 and rows.all(func(r): return (r as Array).size() == 3 and str(r[1]) != "" and str(r[2]) != ""), "eight rows, each with both boxers")
	_check(str(by["HEIGHT"][1]) == "169 cm" and str(by["REACH"][1]) == "169 cm", "her height is her drawn body, her reach follows it")
	_check(str(by["HEIGHT"][2]) == "%d cm" % int(opp["height"]) and str(by["REACH"][2]) == "%d cm" % int(opp["reach"]), "the opponent's height and reach are her own")
	_check(str(by["RECORD"][1]) == "%d-%d" % [int(f["w"]), int(f["l"])] and str(by["CLUB"][1]) == "Anvil Street Gym", "record and club")
	f["height"] = 172.0
	_check(str(TaleOfTape.rows(f, opp, "", 169.0)[1][1]) == "172 cm", "a measured height wins over the drawn body")
	print("TALEOFTAPE failures=%d" % failures)
	quit(1 if failures > 0 else 0)


func _check(cond: bool, label: String) -> void:
	if cond:
		print("PASS ", label)
	else:
		failures += 1
		print("FAIL ", label)
