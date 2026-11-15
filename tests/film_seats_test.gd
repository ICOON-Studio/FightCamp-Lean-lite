extends SceneTree
## FilmSeats test: who watches with the coach, who watches alone.
## Map: ops/research/DESIGN_CLUBWEEK1_V9_REVISE_KALLI_KALLI.md 3.4
## Build plan: ops/research/CLUBWEEK1_BUILD_S485.md, item 4

const FilmSeats := preload("res://scripts/rules/FilmSeats.gd")

var fails: int = 0


func _initialize() -> void:
	_test_owned()
	_test_deal_empty()
	_test_deal_sessional_three()
	_test_deal_full_time_three()
	_test_tie()
	_test_alone_count()
	_test_line_sessional_three()
	_test_line_four()
	_test_opens_tell()
	_test_seat_of()
	_test_deal_does_not_reorder()
	if fails == 0:
		print("FILM_SEATS PASS fails=0")
	else:
		print("FILM_SEATS FAIL fails=%d" % fails)
	quit(0 if fails == 0 else 1)


func _check(cond: bool, label: String) -> void:
	if cond:
		print("ok   %s" % label)
	else:
		fails += 1
		print("FAIL %s" % label)


func _test_owned() -> void:
	_check(FilmSeats.owned("sessional") == 2, "owned(sessional) == 2")
	_check(FilmSeats.owned("full_time") == 3, "owned(full_time) == 3")
	_check(FilmSeats.owned("none") == 2, "owned(none) == 2")


func _test_deal_empty() -> void:
	var empty: Array = []
	var dealt: Array = FilmSeats.deal(empty, "sessional")
	_check(dealt.size() == 0, "deal([]) == []")
	_check(dealt == [], "deal([]) returns []")


func _test_deal_sessional_three() -> void:
	var boxers: Array = [
		{"id": "a", "fight_day": 20},
		{"id": "b", "fight_day": 13},
		{"id": "c", "fight_day": 16},
	]
	var dealt: Array = FilmSeats.deal(boxers, "sessional")
	_check(dealt.size() == 3, "sessional three: size 3")
	if dealt.size() == 3:
		var d0: Dictionary = dealt[0]
		var d1: Dictionary = dealt[1]
		var d2: Dictionary = dealt[2]
		_check(str(d0.get("id", "")) == "b" and int(d0.get("fight_day", 0)) == 13 and str(d0.get("seat", "")) == FilmSeats.COACHED, "sessional three: b first coached")
		_check(str(d1.get("id", "")) == "c" and int(d1.get("fight_day", 0)) == 16 and str(d1.get("seat", "")) == FilmSeats.COACHED, "sessional three: c second coached")
		_check(str(d2.get("id", "")) == "a" and int(d2.get("fight_day", 0)) == 20 and str(d2.get("seat", "")) == FilmSeats.ALONE, "sessional three: a third alone")
		# also check order b, c, a
		var ids: Array = []
		for i in range(dealt.size()):
			var row: Dictionary = dealt[i]
			ids.append(str(row.get("id", "")))
		var packed := PackedStringArray(ids)
		var joined: String = ", ".join(packed)
		_check(joined == "b, c, a", "sessional three order b, c, a is " + joined)


func _test_deal_full_time_three() -> void:
	var boxers: Array = [
		{"id": "a", "fight_day": 20},
		{"id": "b", "fight_day": 13},
		{"id": "c", "fight_day": 16},
	]
	var dealt: Array = FilmSeats.deal(boxers, "full_time")
	_check(dealt.size() == 3, "full_time three: size 3")
	if dealt.size() == 3:
		var all_coached: bool = true
		for i in range(dealt.size()):
			var row: Dictionary = dealt[i]
			if str(row.get("seat", "")) != FilmSeats.COACHED:
				all_coached = false
		_check(all_coached, "full_time three: all coached")
		_check(FilmSeats.alone_count(dealt) == 0, "full_time three alone_count 0")
		_check(FilmSeats.line(dealt, "full_time") == "", "full_time three line == empty")
		var d0: Dictionary = dealt[0]
		var d1: Dictionary = dealt[1]
		var d2: Dictionary = dealt[2]
		_check(str(d0.get("id", "")) == "b", "full_time three order b first")
		_check(str(d1.get("id", "")) == "c", "full_time three order c second")
		_check(str(d2.get("id", "")) == "a", "full_time three order a third")


func _test_tie() -> void:
	var tie_in: Array = [
		{"id": "b", "fight_day": 13},
		{"id": "x", "fight_day": 13},
	]
	var dealt: Array = FilmSeats.deal(tie_in, "sessional")
	_check(dealt.size() == 2, "tie: size 2")
	if dealt.size() == 2:
		var d0: Dictionary = dealt[0]
		var d1: Dictionary = dealt[1]
		_check(str(d0.get("id", "")) == "b" and str(d1.get("id", "")) == "x", "tie b(13), x(13) keeps input order b then x")
		# verify stable via join
		var ids: Array = []
		for i in range(dealt.size()):
			var row: Dictionary = dealt[i]
			ids.append(str(row.get("id", "")))
		var packed := PackedStringArray(ids)
		var joined: String = ", ".join(packed)
		_check(joined == "b, x", "tie join is b, x got " + joined)


func _test_alone_count() -> void:
	var boxers: Array = [
		{"id": "a", "fight_day": 20},
		{"id": "b", "fight_day": 13},
		{"id": "c", "fight_day": 16},
	]
	var dealt: Array = FilmSeats.deal(boxers, "sessional")
	_check(FilmSeats.alone_count(dealt) == 1, "alone_count sessional three == 1")


func _test_line_sessional_three() -> void:
	var boxers: Array = [
		{"id": "a", "fight_day": 20},
		{"id": "b", "fight_day": 13},
		{"id": "c", "fight_day": 16},
	]
	var dealt: Array = FilmSeats.deal(boxers, "sessional")
	var got: String = FilmSeats.line(dealt, "sessional")
	_check(got == "Film: 3 boxers, 2 seats - one watches alone", "line sessional three: got '%s'" % got)


func _test_line_four() -> void:
	var boxers: Array = [
		{"id": "a", "fight_day": 10},
		{"id": "b", "fight_day": 11},
		{"id": "c", "fight_day": 12},
		{"id": "d", "fight_day": 13},
	]
	var dealt: Array = FilmSeats.deal(boxers, "sessional")
	_check(dealt.size() == 4, "four boxers size 4")
	_check(FilmSeats.alone_count(dealt) == 2, "four boxers alone_count 2")
	var got: String = FilmSeats.line(dealt, "sessional")
	_check(got == "Film: 4 boxers, 2 seats - 2 watch alone", "line four sessional: got '%s'" % got)


func _test_opens_tell() -> void:
	_check(FilmSeats.opens_tell("coached") == true, "opens_tell(coached) true")
	_check(FilmSeats.opens_tell("alone") == false, "opens_tell(alone) false")
	_check(FilmSeats.opens_tell(FilmSeats.COACHED) == true, "opens_tell(COACHED) true")
	_check(FilmSeats.opens_tell(FilmSeats.ALONE) == false, "opens_tell(ALONE) false")


func _test_seat_of() -> void:
	var boxers: Array = [
		{"id": "a", "fight_day": 20},
		{"id": "b", "fight_day": 13},
		{"id": "c", "fight_day": 16},
	]
	var dealt: Array = FilmSeats.deal(boxers, "sessional")
	_check(FilmSeats.seat_of(dealt, "a") == "alone", "seat_of(dealt, a) == alone got '%s'" % FilmSeats.seat_of(dealt, "a"))
	_check(FilmSeats.seat_of(dealt, "b") == "coached", "seat_of(dealt, b) == coached")
	_check(FilmSeats.seat_of(dealt, "zz") == "", "seat_of(dealt, zz) == empty")


func _test_deal_does_not_reorder() -> void:
	var boxers: Array = [
		{"id": "a", "fight_day": 20},
		{"id": "b", "fight_day": 13},
		{"id": "c", "fight_day": 16},
	]
	var before_ids: Array = []
	for i in range(boxers.size()):
		var row: Dictionary = boxers[i]
		before_ids.append(str(row.get("id", "")))
	var _dealt: Array = FilmSeats.deal(boxers, "sessional")
	var after_ids: Array = []
	for i in range(boxers.size()):
		var row: Dictionary = boxers[i]
		after_ids.append(str(row.get("id", "")))
	var before_packed := PackedStringArray(before_ids)
	var after_packed := PackedStringArray(after_ids)
	var before_join: String = ", ".join(before_packed)
	var after_join: String = ", ".join(after_packed)
	_check(before_join == after_join, "deal does not reorder caller array: before %s after %s" % [before_join, after_join])
	_check(before_join == "a, b, c", "caller order stays a, b, c got " + before_join)
