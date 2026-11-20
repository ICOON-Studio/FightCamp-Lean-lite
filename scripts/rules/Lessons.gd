extends RefCounted
## S532 GUIDETIPS1 (ops/research/GUIDETIPS1_STANDARD.md section 3c): what the old trainer teaches, as data. A new mechanic
## adds one row. Every line is 11 words or fewer and names nobody (S448: your boxer, the opponent).
##   PAGES: what each page is FOR, said once, on the first visit (explore first: no dim, no ring).
##   LIST: the lessons that arrive when their thing first happens; "note" is the Glossary note its MORE opens.
## Career.lessons keeps lesson id -> "learned" | "dismissed" (saved with the career).
##   Lessons.page_id(route) -> "" | "home" | "fighters" | ...     Lessons.page_line(c, route) -> the line, "" once learned
##   Lessons.left(c, page)   the page was left: its line is learned     Lessons.row(id) -> the lesson's row
## Pure: preloads nothing.

const MAX_WORDS := 11

const PAGES := {
	"home": "This is your gym. Click a room to go there.",
	"fighters": "Your fighters, and what each one needs from you.",
	"fighter": "Everything about one fighter. The tabs go deeper.",
	"training": "Plan the week here: mornings for the body, evenings for moves.",
	"prep": "Get ready for the bout here: plan, weight, the corner.",
	"playbook": "The moves your fighter knows, and the plan for a fight.",
	"gym": "Your staff and your building live here.",
	"money": "Where the money comes from and where it goes.",
	"fights": "Offers come here. Read the opponent before you say yes.",
	"world": "The ladders: where your fighters stand.",
}

## stage: week1 | fight1 | later. The lines are the standard's table.
const LIST := [
	{"id": "clock1", "stage": "week1", "note": "", "line": "Continue plays the days, one by one, to the next stop."},
	{"id": "clock2", "stage": "week1", "note": "", "line": "Press it again to pause. Change anything, then carry on."},
	{"id": "clock3", "stage": "week1", "note": "bill", "line": "We stop for week's end, bills, weigh-ins, fights and offers."},
	{"id": "clock4", "stage": "fight1", "note": "", "line": "Days too fast or slow? Menu, then Settings."},
	{"id": "tiredness", "stage": "fight1", "note": "fatigue", "line": "Your boxer is getting heavy-legged. Look at the week."},
	{"id": "mastery", "stage": "fight1", "note": "mastery", "line": "That bar is the move. Reach the flag: it is usable."},
	{"id": "fight_week", "stage": "fight1", "note": "fight_week", "line": "Amateur bout: no camp. Pick a light fight week."},
	{"id": "camp", "stage": "fight1", "note": "camp", "line": "This one needs a camp. Set it on Fight prep."},
	{"id": "towel", "stage": "fight1", "note": "", "line": "Tell the corner when to stop it. Your call."},
]

const PREP_TAB := 5
const PLAYBOOK_TAB := 7


static func page_id(route: Dictionary) -> String:
	var area := str(route.get("area", ""))
	if area == "fighters":
		if str(route.get("fighter", "")) != "":
			var ftab := int(route.get("ftab", 0))
			return "prep" if ftab == PREP_TAB else ("playbook" if ftab == PLAYBOOK_TAB else "fighter")
		return "fighters"
	return area if PAGES.has(area) else ""


static func page_line(lessons: Dictionary, route: Dictionary) -> String:
	var id := page_id(route)
	return "" if id == "" or lessons.has("page_" + id) else str(PAGES[id])


static func left(lessons: Dictionary, page: String) -> void:
	if page != "":
		lessons["page_" + page] = "learned"


static func row(id: String) -> Dictionary:
	for r in LIST:
		if str(r["id"]) == id:
			return r
	return {}
