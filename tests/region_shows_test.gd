extends SceneTree
## RegionShows: the region's club-show calendar and each show's slots by sex and class.

const RegionShows := preload("res://scripts/rules/RegionShows.gd")

var checks := 0
var failures := 0


func _initialize() -> void:
	_test_constants()
	_test_week_shows()
	_test_slots()
	_test_offered()
	_test_for_div()
	_test_short_name()
	_test_year()
	print("REGION_SHOWS checks=%d failures=%d" % [checks, failures])
	quit(1 if failures > 0 else 0)


func _check(condition: bool, label: String) -> void:
	checks += 1
	if not condition:
		failures += 1
		print("  FAIL: %s" % label)


func _test_constants() -> void:
	_check(RegionShows.HOSTS.size() == 6, "six host clubs")
	_check(RegionShows.DIVS.size() == 8, "eight weight classes")
	_check(RegionShows.SHOW_DOW == 5, "shows run on Saturday (SHOW_DOW = 5)")
	_check(RegionShows.SHOWS_PER_WEEK_MIN == 1 and RegionShows.SHOWS_PER_WEEK_MAX == 2,
		"shows per week range is 1..2")
	_check(RegionShows.BOUTS_MIN == 8 and RegionShows.BOUTS_MAX == 12,
		"bouts per show range is 8..12")
	_check(is_equal_approx(RegionShows.WOMEN_SHARE, 0.35), "WOMEN_SHARE is 0.35")
	_check(is_equal_approx(RegionShows.NAMED_SHARE, 0.25), "NAMED_SHARE is 0.25")
	var div_sex_ok := true
	for item in RegionShows.DIVS:
		var div: String = str(item)
		var sx: String = str(RegionShows.DIV_SEX.get(div, ""))
		if sx != "f" and sx != "m":
			div_sex_ok = false
	_check(div_sex_ok, "DIV_SEX maps every class in DIVS to 'f' or 'm'")


func _test_week_shows() -> void:
	var seen_counts := {}
	var all_counts_ok := true
	var all_distinct_hosts := true
	var all_known_hosts := true
	var all_saturday := true
	var all_bouts_ok := true
	for w in 20:
		var monday := w * 7
		var shows := RegionShows.week_shows(monday)
		if shows.size() < RegionShows.SHOWS_PER_WEEK_MIN or shows.size() > RegionShows.SHOWS_PER_WEEK_MAX:
			all_counts_ok = false
		seen_counts[shows.size()] = true
		var hosts_seen := {}
		for item in shows:
			var sh: Dictionary = item
			var host: String = str(sh.get("show", ""))
			var day: int = int(sh.get("day", -1))
			var bouts: int = int(sh.get("bouts", 0))
			if hosts_seen.has(host):
				all_distinct_hosts = false
			hosts_seen[host] = true
			if not RegionShows.HOSTS.has(host):
				all_known_hosts = false
			if day != monday + RegionShows.SHOW_DOW or posmod(day, 7) != RegionShows.SHOW_DOW:
				all_saturday = false
			if bouts < RegionShows.BOUTS_MIN or bouts > RegionShows.BOUTS_MAX:
				all_bouts_ok = false
	_check(all_counts_ok, "week_shows returns 1-2 shows each week")
	_check(seen_counts.has(1) and seen_counts.has(2),
		"over 20 weeks both 1-show and 2-show weeks appear")
	_check(all_distinct_hosts, "two shows in one week never share a host")
	_check(all_known_hosts, "every show host comes from HOSTS")
	_check(all_saturday, "every show lands on Saturday (monday + 5)")
	_check(all_bouts_ok, "every show has 8-12 bouts")
	var first_a := RegionShows.week_shows(14)
	var first_b := RegionShows.week_shows(14)
	_check(first_a == first_b, "the same monday returns identical shows twice (repeatable)")
	var neg := RegionShows.week_shows(-7)
	var neg_day: int = int((neg[0] as Dictionary).get("day", 0)) if not neg.is_empty() else 0
	_check(neg.size() >= 1 and posmod(neg_day, 7) == RegionShows.SHOW_DOW,
		"negative monday still lands on Saturday")


func _test_slots() -> void:
	for b in range(8, 13):
		var card := {"show": "Repton", "day": 12, "bouts": b}
		var card_slots := RegionShows.slots(card)
		var expected_women := maxi(1, roundi(float(b) * RegionShows.WOMEN_SHARE))
		var women_n := 0
		var men_n := 0
		for item in card_slots:
			var s: Dictionary = item
			if str(s.get("sex", "")) == "f":
				women_n += 1
			elif str(s.get("sex", "")) == "m":
				men_n += 1
		_check(card_slots.size() == b, "slots count equals bouts=%d" % b)
		_check(women_n == expected_women and men_n == b - expected_women,
			"bouts=%d has %d women and %d men (share %.2f)"
			% [b, expected_women, b - expected_women, RegionShows.WOMEN_SHARE])

	var tiny := RegionShows.slots({"show": "Lynn AC", "day": 5, "bouts": 1})
	_check(tiny.size() == 1 and str((tiny[0] as Dictionary).get("sex", "")) == "f",
		"1-bout show keeps at least 1 women's slot")
	_check(RegionShows.slots({"show": "Lynn AC", "day": 5, "bouts": 0}).is_empty(),
		"0-bout show returns empty slots")

	var big_card := {"show": "Fitzroy Lodge", "day": 19, "bouts": 12}
	var big := RegionShows.slots(big_card)
	var big_again := RegionShows.slots(big_card)
	_check(big == big_again, "slots on the same show are repeatable")

	var fields_ok := true
	var sex_matches_div := true
	var opp_format_ok := true
	for item in big:
		var s: Dictionary = item
		for key in ["show", "day", "sex", "div", "named", "opp"]:
			if not s.has(key):
				fields_ok = false
		var div: String = str(s.get("div", ""))
		var sx: String = str(s.get("sex", ""))
		if str(RegionShows.DIV_SEX.get(div, "")) != sx:
			sex_matches_div = false
		if typeof(s.get("named")) != TYPE_BOOL:
			fields_ok = false
		var want_opp := "%s %s boxer" % ["Fitzroy Lodge", RegionShows.short_name(div)]
		if str(s.get("opp", "")) != want_opp:
			opp_format_ok = false
		if str(s.get("show", "")) != "Fitzroy Lodge" or int(s.get("day", -1)) != 19:
			fields_ok = false
	_check(fields_ok, "every slot has all 6 fields with matching show/day and bool named")
	_check(sex_matches_div, "every slot's sex matches its class in DIV_SEX")
	_check(opp_format_ok, "every slot's opp uses '%s %s boxer' placeholder")

	var spread_ok := true
	for h_item in RegionShows.HOSTS:
		var host: String = str(h_item)
		var c12 := RegionShows.slots({"show": host, "day": 26, "bouts": 12})
		var f_total := 0
		var m_total := 0
		var counts := {}
		for s_item in c12:
			var s: Dictionary = s_item
			var div: String = str(s.get("div", ""))
			counts[div] = int(counts.get(div, 0)) + 1
			if str(s.get("sex", "")) == "f":
				f_total += 1
			else:
				m_total += 1
		for d_key in counts:
			var d: String = str(d_key)
			var n: int = int(counts[d])
			var sex_total: int = f_total if str(RegionShows.DIV_SEX.get(d, "")) == "f" else m_total
			if n * 2 > sex_total:
				spread_ok = false
	_check(spread_ok, "12-bout card: no class gets more than half of its sex's slots (all 6 hosts)")


func _test_offered() -> void:
	# From Monday day 0: 1-3 weeks out is days [7, 21] -> Saturdays 12 and 19.
	var off0 := RegionShows.offered(0)
	_check(not off0.is_empty(), "offered(0) returns slots in the 1-3 week window")
	var bounds0_ok := true
	var sorted0_ok := true
	var prev0 := -999999
	var days0 := {}
	for item in off0:
		var s: Dictionary = item
		var d: int = int(s.get("day", -1))
		if d < 7 or d > 21:
			bounds0_ok = false
		if d < prev0:
			sorted0_ok = false
		prev0 = d
		days0[d] = true
	_check(bounds0_ok, "offered(0) keeps only days in [7, 21] inclusive")
	_check(sorted0_ok, "offered(0) is sorted soonest first")
	_check(days0.has(12) and days0.has(19) and days0.size() == 2,
		"offered(0) includes Saturdays 12 and 19 only")

	# Saturday day 5: 1-3 weeks out is [12, 26] -> Saturdays 12, 19, 26 (inclusive endpoints).
	var off5 := RegionShows.offered(5)
	var days5 := {}
	var bounds5_ok := true
	var sorted5_ok := true
	var prev5 := -999999
	for item in off5:
		var s: Dictionary = item
		var d: int = int(s.get("day", -1))
		if d < 12 or d > 26:
			bounds5_ok = false
		if d < prev5:
			sorted5_ok = false
		prev5 = d
		days5[d] = true
	_check(bounds5_ok, "offered(5) keeps only days in [12, 26] inclusive")
	_check(sorted5_ok, "offered(5) is sorted soonest first")
	_check(days5.has(12) and days5.has(19) and days5.has(26) and days5.size() == 3,
		"offered(5) includes inclusive boundary Saturdays 12, 19 and 26")

	# From Wednesday day 2: 1-3 weeks out is days [9, 23] -> Saturdays 12 and 19.
	var off2 := RegionShows.offered(2, 1, 3)
	var bounds2_ok := true
	for item in off2:
		var d: int = int((item as Dictionary).get("day", -1))
		if d < 9 or d > 23:
			bounds2_ok = false
	_check(not off2.is_empty() and bounds2_ok, "offered(2, 1, 3) keeps only days in [9, 23]")
	_check(RegionShows.offered(0, 3, 1).is_empty(), "offered with weeks_min > weeks_max returns empty")


func _test_for_div() -> void:
	var unsorted := [
		{"show": "Repton", "day": 26, "sex": "f", "div": "wlw",
			"named": false, "opp": "Repton 60 kg boxer"},
		{"show": "West Ham", "day": 12, "sex": "m", "div": "mlw",
			"named": true, "opp": "West Ham 60 kg boxer"},
		{"show": "Lynn AC", "day": 12, "sex": "f", "div": "wlw",
			"named": false, "opp": "Lynn AC 60 kg boxer"},
		{"show": "All Stars", "day": 19, "sex": "f", "div": "wlw",
			"named": true, "opp": "All Stars 60 kg boxer"},
	]
	var wlw := RegionShows.for_div(unsorted, "wlw")
	_check(wlw.size() == 3, "for_div keeps only matching class slots (3 of 4)")
	var only_wlw := true
	for item in wlw:
		if str((item as Dictionary).get("div", "")) != "wlw":
			only_wlw = false
	_check(only_wlw, "every slot returned by for_div matches the requested div")
	_check(wlw.size() == 3
		and int((wlw[0] as Dictionary).get("day", 0)) == 12
		and int((wlw[1] as Dictionary).get("day", 0)) == 19
		and int((wlw[2] as Dictionary).get("day", 0)) == 26,
		"for_div sorts results soonest first (12, 19, 26)")
	_check(int((unsorted[0] as Dictionary).get("day", 0)) == 26,
		"for_div does not mutate the caller's input array")
	_check(RegionShows.for_div(unsorted, "wfw").is_empty(),
		"for_div returns empty when class is absent")

	var off := RegionShows.offered(5)
	var mww := RegionShows.for_div(off, "mww")
	var mww_ok := not mww.is_empty()
	var prev_day := -999999
	for item in mww:
		var s: Dictionary = item
		if str(s.get("div", "")) != "mww" or int(s.get("day", 0)) < prev_day:
			mww_ok = false
		prev_day = int(s.get("day", 0))
	_check(mww_ok, "for_div on offered() returns only that div, soonest first")


func _test_short_name() -> void:
	_check(RegionShows.short_name("wfw") == "57 kg", "short_name wfw -> 57 kg")
	_check(RegionShows.short_name("wlw") == "60 kg", "short_name wlw -> 60 kg")
	_check(RegionShows.short_name("www") == "65 kg", "short_name www -> 65 kg")
	_check(RegionShows.short_name("wmw") == "75 kg", "short_name wmw -> 75 kg")
	_check(RegionShows.short_name("mfw") == "57.5 kg", "short_name mfw -> 57.5 kg")
	_check(RegionShows.short_name("mlw") == "60 kg", "short_name mlw -> 60 kg")
	_check(RegionShows.short_name("mww") == "70 kg", "short_name mww -> 70 kg")
	_check(RegionShows.short_name("mmw") == "75 kg", "short_name mmw -> 75 kg")
	_check(RegionShows.short_name("unknown") == "", "short_name unknown -> empty string")


func _test_year() -> void:
	var div_counts := {}
	for item in RegionShows.DIVS:
		div_counts[str(item)] = 0
	var host_counts := {}
	var total_slots := 0
	var named_slots := 0
	var year_valid := true
	for w in 52:
		var monday := w * 7
		var shows := RegionShows.week_shows(monday)
		if shows.size() < RegionShows.SHOWS_PER_WEEK_MIN or shows.size() > RegionShows.SHOWS_PER_WEEK_MAX:
			year_valid = false
		var week_hosts := {}
		for sh_item in shows:
			var sh: Dictionary = sh_item
			var host: String = str(sh.get("show", ""))
			if week_hosts.has(host):
				year_valid = false
			week_hosts[host] = true
			host_counts[host] = int(host_counts.get(host, 0)) + 1
			var card_slots := RegionShows.slots(sh)
			if card_slots.size() != int(sh.get("bouts", 0)):
				year_valid = false
			for s_item in card_slots:
				var s: Dictionary = s_item
				var div: String = str(s.get("div", ""))
				if str(RegionShows.DIV_SEX.get(div, "")) != str(s.get("sex", "")):
					year_valid = false
				div_counts[div] = int(div_counts.get(div, 0)) + 1
				total_slots += 1
				if bool(s.get("named", false)):
					named_slots += 1
	_check(year_valid, "52 weeks (mondays 0..357): every show and slot passes invariants")
	_check(host_counts.size() == RegionShows.HOSTS.size(), "52 weeks: all 6 host clubs appear")
	for item in RegionShows.DIVS:
		var div: String = str(item)
		var n: int = int(div_counts.get(div, 0))
		var avg := float(n) / 52.0
		_check(n >= 20, "52 weeks: %s appears %d times (>= 20)" % [div, n])
		_check(avg >= 0.8 and avg <= 3.0, "52 weeks: %s averages %.2f slots/week (0.8-3.0)" % [div, avg])
	var named_share := float(named_slots) / float(maxi(1, total_slots))
	_check(named_share >= 0.15 and named_share <= 0.35,
		"52 weeks: named share is %.1f%% (15%%-35%%)" % (named_share * 100.0))
