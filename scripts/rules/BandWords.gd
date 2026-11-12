extends RefCounted
## DEFECTS1 (S439 audit: "five word sets for the same bands"): the ONE table of the words a BodyMap band is shown with.
## BodyMap.band's own names ("hurt", "critical", "doctor") are the code's; the player reads these.
##   word(v)   how bad a place is: fine / sore / badly hurt (the result page, the damage tile, the face marks)
##   live(v)   the same during a fight, where the doctor still looks: the last band reads "doctor may stop it" (hover tips,
##             the head close-up, the corner card)
##   body(v)   what a rib place's band does to her gas during a fight (the liver / ribs close-up)
##   key()     one line naming the bands in order, for a legend
## Every screen that names a band reads it here (BodyTip, CalloutLine, Aftermath, ResultMarks, FaceMark3D, BodyPanels),
## so the tile and the pinned card under it cannot drift apart again.

const BodyMap := preload("res://scripts/rules/BodyMap.gd")

const BANDS := ["fine", "hurt", "critical", "doctor"]
const TABLE := {
	"fine": {"word": "fine", "live": "fine", "body": "costs gas"},
	"hurt": {"word": "sore", "live": "sore", "body": "gas drains faster"},
	"critical": {"word": "badly hurt", "live": "badly hurt", "body": "badly hurt, gas going"},
	"doctor": {"word": "badly hurt", "live": "doctor may stop it", "body": "doctor may stop it"},
}


static func word(v: float) -> String:
	return of_band(BodyMap.band(v), "word")


static func live(v: float) -> String:
	return of_band(BodyMap.band(v), "live")


static func body(v: float) -> String:
	return of_band(BodyMap.band(v), "body")


## The word for a band name (BodyMap.band) in one column: "word", "live" or "body".
static func of_band(band: String, column: String = "word") -> String:
	return str((TABLE.get(band, TABLE["fine"]) as Dictionary)[column])


static func key() -> String:
	var seen: Array = []
	for b in BANDS:
		var w := of_band(b, "live")
		if not seen.has(w):
			seen.append(w)
	return "Each place reads %s." % ", then ".join(seen)
