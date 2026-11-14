extends SceneTree
## S462 INTEGRATE1 #5: M7 PROFESSIONALS GET READ (ProRead.gd) reaches fight night through ProReadWire. Each check has a
## control arm that cannot share the bug.
##   1. Tape: an amateur bout leaves no tape and carries no read; the pro debut is never read but goes on the tape with the
##      combinations she fired.
##   2. The next pro bout carries the read: the line she fired most on tape.
##   3. The price: the same 40 pro bouts with a tape that reads her plan's punch vs no tape - she wins fewer exchanges, by a
##      bounded margin. Control: a tape that reads a punch her plan does not throw plays every bout exactly as no tape.
##   4. Shown: fight prep names the punch their corner waits for on a pro bout, and nothing on an amateur bout.
##   5. S466 READ-PROOF: fight prep's season chip, lit after two read pro bouts beaten; 0/1 of 2 otherwise.
## Population: Lucy Jackson (Data.lucy, out-boxer, 1-1 and 1-2 at Sharp) against Data.OPPONENTS[0]; 40 days (the dice).

const Data := preload("res://scripts/state/Data.gd")
const Bouts := preload("res://scripts/state/Bouts.gd")
const ProReadWire := preload("res://scripts/state/ProReadWire.gd")
const FightPrep := preload("res://scripts/ui/FightPrep.gd")

const GOOD := [{"move": "1-1"}, {"move": "step_back"}, {"move": "pivot_out"}, {"move": "tie_up"}]
const BOUTS := 40

var failures := 0


func _initialize() -> void:
	# 1. Tape.
	var am := _fight(500, false, [])
	_check(not (am[1] as Dictionary).has("pro_tape") and not (am[1]["bout"] as Dictionary).has("pro_read"),
		"amateur bout: no tape, no read")
	var deb := _fight(501, true, [])
	var tape: Array = deb[1].get("pro_tape", [])
	_check((deb[1]["bout"]["pro_read"] as Dictionary).is_empty(), "the pro debut is never read")
	_check(tape.size() == 1 and int((tape[0]["fired"] as Dictionary).get("1-1", 0)) > 0 and not (tape[0] as Dictionary).has("read"),
		"the debut goes on the tape with the combinations she fired: %s" % [tape[0].get("fired", {}) if not tape.is_empty() else "none"])

	# 2. The next pro bout is read on the line she fired most.
	var nxt := _fight(502, true, tape)
	var t: Dictionary = nxt[1]["bout"]["pro_read"]
	_check(str(t.get("line", "")) == "1-1", "the second pro bout is read on her most fired punch (%s)" % str(t.get("line", "none")))
	var tape2: Array = nxt[1].get("pro_tape", [])
	_check(tape2.size() == 2 and (tape2[1] as Dictionary).has("read"), "a read bout goes on the tape with how the read line did: %s" % [
		tape2[1].get("read", {}) if tape2.size() == 2 else "none"])

	# 3. The price, with a control that cannot share it.
	var read_tape := [{"pro": true, "fired": {"1-1": 12}}, {"pro": true, "fired": {"1-1": 10}}]
	var off_tape := [{"pro": true, "fired": {"1-2-3": 12}}, {"pro": true, "fired": {"1-2-3": 10}}]
	var none := _share([])
	var read := _share(read_tape)
	var off := _share(off_tape)
	print("  exchanges won over %d pro bouts: no tape %.3f, read on her 1-1 %.3f, read on a punch she never throws %.3f" % [BOUTS, none[0], read[0], off[0]])
	_check(off[1] == none[1], "control: a read on a punch her plan never throws changes no exchange")
	_check(float(read[0]) < float(none[0]) - 0.005, "read on her plan's punch: she wins fewer exchanges (%.3f < %.3f)" % [read[0], none[0]])
	_check(float(none[0]) - float(read[0]) <= 0.12, "by a bounded margin - one edge among many (%.3f)" % (float(none[0]) - float(read[0])))

	# 4. Shown on fight prep.
	var c := _career(600)
	var f: Dictionary = c.fighter()
	f["pro_tape"] = read_tape.duplicate(true)
	_book(c, f, true)
	var w := ProReadWire.words(f)
	_check(w.contains("Double jab"), "fight prep words name the punch in game words: '%s'" % w)
	f["bout"]["pro"] = false
	_check(ProReadWire.words(f) == "", "an amateur bout shows no read")
	# 5. S466 READ-PROOF on fight prep: none before a read bout; lit after two read bouts that beat the read; not lit when
	# the last read bout lost it (control: the same tape with the last bout's wins halved).
	_check(str(ProReadWire.proof_words({"pro_tape": [{"pro": true, "fired": {"1-1": 9}}]})[0]) == "", "no read bout yet: no read-proof line")
	var beat := {"pro": true, "fired": {"1-1": 5}, "read": {"line": "1-1", "split": false, "fired_in_read": 4, "won_in_read": 3}}
	var lost := {"pro": true, "fired": {"1-1": 5}, "read": {"line": "1-1", "split": false, "fired_in_read": 4, "won_in_read": 1}}
	var lit := ProReadWire.proof_words({"pro_tape": [beat, beat]})
	_check(bool(lit[1]) and str(lit[0]).begins_with("Read-proof"), "two read bouts beaten: read-proof lit ('%s')" % lit[0])
	var unlit := ProReadWire.proof_words({"pro_tape": [beat, lost]})
	_check(not bool(unlit[1]) and str(unlit[0]).begins_with("0 of 2"), "control: the last read bout lost - not lit, 0 of 2 ('%s')" % unlit[0])
	_check(str(ProReadWire.proof_words({"pro_tape": [lost, beat]})[0]).begins_with("1 of 2"), "one read bout beaten after a lost one: 1 of 2")

	print("PROREAD_WIRE failures=%d" % failures)
	quit(1 if failures > 0 else 0)


func _career(day: int) -> Career:
	var c := Career.quick_start()
	c.fighters.append(Data.fighter_state(Data.lucy(), c.day))
	c.day = day
	var f: Dictionary = c.fighter()
	f["camp"] = {}
	f["combos"] = {"1-1": 65.0, "1-2": 65.0}
	f["arrows"] = GOOD.duplicate(true)
	return c


func _book(c: Career, f: Dictionary, pro: bool) -> Dictionary:
	f["bout"] = {"opp": (Data.OPPONENTS[0] as Dictionary).duplicate(true), "day": c.day, "weighed": true, "made": true, "done": false,
		"film": 3, "pro": pro, "purse": 1500, "arrows": GOOD.duplicate(true)}
	if pro:   # the contract a signed pro carries (Roster.sign_pro)
		for kv in [["pro", true], ["promoter", "Test"], ["purse", 1500], ["purse_step", 500], ["purse_top", 3000], ["pro_w", 0], ["pro_l", 0]]:
			f[kv[0]] = kv[1]
	return {"fid": f["id"], "step": "tape", "total": 3}


## [career, fighter, modal] after one simulated bout.
func _fight(day: int, pro: bool, tape: Array) -> Array:
	var c := _career(day)
	var f: Dictionary = c.fighter()
	if not tape.is_empty():
		f["pro_tape"] = tape.duplicate(true)
	var m := _book(c, f, pro)
	Bouts.fight_step(c, f, m, "sim")
	return [c, f, m]


## [share of exchanges she won, the exchange-by-exchange won list] over BOUTS pro bouts with this tape.
func _share(tape: Array) -> Array:
	var won := 0
	var all := 0
	var seq: Array = []
	for i in BOUTS:
		var r := _fight(700 + i, true, tape)
		for rd in r[2]["rounds"]:
			for x in rd["exchanges"]:
				all += 1
				won += int(bool(x["won"]))
				seq.append(bool(x["won"]))
	return [float(won) / maxf(1.0, float(all)), seq]


func _check(cond: bool, label: String) -> void:
	if cond:
		print("PASS " + label)
	else:
		print("FAIL " + label)
		failures += 1
