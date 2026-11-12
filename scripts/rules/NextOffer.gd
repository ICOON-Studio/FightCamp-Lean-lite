extends RefCounted
## NEXTOFFER (S440, PAGES2B round 3): the day a boxer's next bout offer comes, read from the clock the game itself keeps.
## Sim.step_day moves the day on, then Bouts.day_events rolls an amateur pair on the first day at or past next_offer_day
## (set at signing, and again after an expiry, a decline, a missed weight, a fight or an injury); a pro on the ladder hears
## the promoter at pro_next (ProLadder.day_events). Clock.next_stop stops CONTINUE on the same day.
## -1 = no day the clock promises: booked, an offer still open, in the championships, a pro off the ladder, the no-gi athlete.
## Bar: tests/next_offer_test.gd (steps the real days and sees the offers arrive on this day, not before).

const Bouts := preload("res://scripts/state/Bouts.gd")
const Champs := preload("res://scripts/state/Champs.gd")
const ProLadder := preload("res://scripts/state/ProLadder.gd")


static func day(c: Career, f: Dictionary) -> int:
	if str(f.get("sport", "boxing")) == "bjj" or not (f.get("bout", {}) as Dictionary).is_empty():
		return -1
	if bool(f.get("pro", false)):
		if ProLadder.on_ladder(c, f) and (f.get("pro_offers", []) as Array).is_empty():
			return maxi(int(f.get("pro_next", 0)), c.day + 1)
		return -1
	if Champs.active(f) or not Bouts.offers_settled(f) or not f.has("next_offer_day"):
		return -1
	return maxi(int(f["next_offer_day"]), c.day + 1)
