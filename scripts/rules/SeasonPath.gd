extends RefCounted
## England Boxing 2026 guidance (Elite NAC): 5 bouts + 3 months' registered membership to enter; Elite age 19-40;
## entering the NAC moves the boxer to Elite for life. Regional qualifier, then the national draw (up to 4 bouts).
## S331 (operator Q-S294-48 on update 30: "Too long to reach"): the 3 months count from her England Boxing registration
## (the sourced rule), not from the day she joined our club - a walk-in with bouts on her card is already registered. The
## game calendar (a decision, not a sourced date) moved up: entries close in week 10 (was 20), the nationals 3 weeks after
## the regional final (was 4) - her first title run ends about week 16 instead of week 28.

const MIN_BOUTS := 5
const MIN_CLUB_DAYS := 91
const AGE_MIN := 19
const AGE_MAX := 40
const YEAR_DAYS := 364
const ENTRY_CLOSE_DAY := 70
const REGIONAL_START := 14
const REGIONAL_GAP := 7
const NATIONALS_GAP := 21
const NATIONAL_ROUND_DAYS := [0, 1, 7, 8]
const STAGE_NAMES := ["Regional semi-final", "Regional final", "National last 16", "National quarter-final",
	"National semi-final", "National final"]


## Can she enter? Checks in order: turned_pro, injured, age, bouts, reg_days (days registered with England Boxing).
static func eligible(bouts: int, reg_days: int, age: int, injured: bool, turned_pro: bool) -> Dictionary:
	if turned_pro:
		return {"ok": false, "reason": "Professionals cannot enter"}
	if injured:
		return {"ok": false, "reason": "Injured or suspended"}
	if age < AGE_MIN:
		return {"ok": false, "reason": "Too young for Elite (19+)"}
	if age > AGE_MAX:
		return {"ok": false, "reason": "Too old for Elite (40 max)"}
	if bouts < MIN_BOUTS:
		return {"ok": false, "reason": "Needs 5 bouts (has %d)" % bouts}
	if reg_days < MIN_CLUB_DAYS:
		var remaining: int = MIN_CLUB_DAYS - reg_days
		var weeks: int = (remaining + 6) / 7
		return {"ok": false, "reason": "Needs 3 months registered (%d weeks to go)" % weeks}
	return {"ok": true, "reason": ""}


## The day this year's entries close (the NEXT close on or after `day`).
static func entry_close(day: int) -> int:
	if day <= ENTRY_CLOSE_DAY:
		return ENTRY_CLOSE_DAY
	var diff: int = day - ENTRY_CLOSE_DAY
	var years_ahead: int = (diff + YEAR_DAYS - 1) / YEAR_DAYS
	return ENTRY_CLOSE_DAY + years_ahead * YEAR_DAYS


## Bouts to win a draw of `size` entrants: ceil(log2(size)); 0 for size <= 1.
static func bouts_to_win(size: int) -> int:
	if size <= 1:
		return 0
	var n: int = 0
	var p: int = 1
	while p < size:
		p *= 2
		n += 1
	return n


## Does she get a first-round bye? Byes = next power of two - size; top seeds get them.
static func has_bye(size: int, seed: int) -> bool:
	if size <= 1:
		return true
	var p: int = 1
	while p < size:
		p *= 2
	var byes: int = p - size
	return seed <= byes


## Her schedule for one championship (every bout she'd box if she kept winning, in order).
static func schedule(close_day: int, regional_size: int, regional_seed: int, national_size: int,
		national_seed: int) -> Array:
	var reg_size: int = clampi(regional_size, 1, 4)
	var nat_size: int = clampi(national_size, 2, 16)
	var regional_final_day: int = close_day + REGIONAL_START + REGIONAL_GAP
	var result: Array = []
	var num_r: int = bouts_to_win(reg_size)
	if num_r > 0 and has_bye(reg_size, regional_seed):
		num_r -= 1
	var r_start: int = 2 - num_r
	for rs in range(r_start, 2):
		var rday: int = close_day + REGIONAL_START + REGIONAL_GAP * rs
		result.append({"stage": rs, "day": rday})
	var num_n: int = bouts_to_win(nat_size)
	if num_n > 0 and has_bye(nat_size, national_seed):
		num_n -= 1
	var n_start: int = 6 - num_n
	for ns in range(n_start, 6):
		var nday: int = regional_final_day + NATIONALS_GAP + NATIONAL_ROUND_DAYS[ns - 2]
		result.append({"stage": ns, "day": nday})
	return result


## The words for how far she went. reached = STAGE_NAMES index of her LAST bout; won_it = she won that bout.
static func result_words(reached: int, won_it: bool) -> String:
	if reached >= 2:
		if reached == 5 and won_it:
			return "National champion"
		if reached == 5 and not won_it:
			return "National runner-up"
		if reached == 4 and not won_it:
			return "National bronze"
		return "Reached the " + STAGE_NAMES[reached].to_lower()
	if reached == 1 and won_it:
		return "Regional champion"
	return "Lost in the " + STAGE_NAMES[reached].to_lower()


## One line for HOME: progress toward entry, or ready to enter.
static func goal_line(day: int, bouts: int, reg_days: int, ok: bool) -> String:
	var d: int = entry_close(day) - day
	if ok:
		return "Ready for the nationals - enter before entries close in %d days" % d
	var b: int = mini(bouts, MIN_BOUTS)
	var w: int = mini(reg_days / 7, 13)
	if w >= 13:
		return "Road to the nationals: %d/5 bouts, entries close in %d days" % [b, d]
	return "Road to the nationals: %d/5 bouts, %d of 13 weeks registered, entries close in %d days" % [b, w, d]
