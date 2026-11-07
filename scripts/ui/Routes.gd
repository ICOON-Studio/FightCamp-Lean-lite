extends RefCounted
## S396 screen cut (docs/STRUCTURE_DESIGN_S395.md 5.4, rank 2): 5 rail buttons, 8 area tabs, 5 fighter tabs. Old addresses
## stay valid: every route passes through canon(), which sends a tab that was folded into another page to its new home.
## Fighters: Roster | Find a fighter (Training and Fight camps live on each fighter's page). Fights: one page. Club:
## People | Money | Records. World: News | Rankings | Championships (| Search until every name is a link).
## Fighter page: Overview (stats, body, contract) | Week | Fight prep | Playbook | History.

## Fighter-page tabs that fold into Overview (old Attributes and moves, Body, Contract and goals).
const INTO_OVERVIEW := [1, 2, 6]


static func canon(r: Dictionary) -> Dictionary:
	var out := r.duplicate()
	var area := str(out.get("area", "home"))
	var tab := int(out.get("tab", 0))
	match area:
		"fighters":
			if str(out.get("fighter", "")) != "":
				if INTO_OVERVIEW.has(int(out.get("ftab", 0))):
					out["ftab"] = 0
			elif tab == 1 or tab == 2:
				tab = 0
		"fights":
			tab = 0
		"gym":
			if tab == 3:   # Facilities: repairs and upgrades are spending, on Money
				area = "money"
				tab = 0
			elif tab != 4:   # Staff and Members are People
				tab = 1
		"money":
			tab = 0
		"world":
			if tab == 4:   # Nationals are a championship
				tab = 2
	out["area"] = area
	out["tab"] = tab
	return out
