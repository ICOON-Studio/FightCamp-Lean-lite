## The game's terms for the T3 sticky notes (S362, J90 6c "a keyword opens a sticky note beside the card": the term, a
## definition of 15 words or fewer, a "Why:" line). Every line states what the code does - read from the module named
## beside it, never a claim about real gyms.
##   Glossary.term(id) -> {name, def, why} or {}
## Pure static; preloads nothing.

const TERMS := {
	# WhiteboardKit.fatigue_word / AMBER_AT 70 / RED_AT 80
	"fatigue": {"name": "Fatigue", "def": "How tired the fighter is by night, 0 to 100.",
		"why": "At 80 or more the next morning trains at 60% and a camp that peaks there fails its line."},
	# Injuries.ratio, WeekCamp LOAD_OVER
	"load": {"name": "Training load", "def": "This week's training hours against a usual week.",
		"why": "At 1.5 the injury risk is three times the usual."},
	# BoutRules.WEAPON_MASTERY 30, BeltRoad.OWNED_AT 30
	"weapon": {"name": "Weapon", "def": "A move at mastery 30 or more.",
		"why": "Weapons get thrown on the night; past the first 4, each adds 0.3 to the edge, up to 0.9."},
	# WeekPhase
	"phase": {"name": "Camp phase", "def": "BASE, BUILD, PEAK or TAPER, counted back from fight night.",
		"why": "The phase writes the coach's week: volume in BUILD, the hardest week at PEAK, light in TAPER."},
	# WeekTwist
	"twist": {"name": "Twist card", "def": "The week's surprise, dealt on Monday.",
		"why": "Answer it by Monday or the coach's pick stands."},
	# GymBills.status WARN_RUNWAY_WEEKS 8, CLOSE_AFTER_WEEKS
	"runway": {"name": "Runway", "def": "Weeks the cash lasts at this week's net.",
		"why": "Under 8 weeks the cash turns amber; weeks below $0 in a row close the gym."},
	# GymBills.FEE_MONTH, Membership.weekly_dues
	"dues": {"name": "Dues", "def": "Each member pays $35 a month; the gym keeps it by the week.",
		"why": "Members are the gym's steady income."},
	# Membership.natural_members
	"reputation": {"name": "Reputation", "def": "What the town thinks of the gym.",
		"why": "It sets how many members the gym can carry; wins raise it, losses cost it."},
	# FighterProfile.trust (S361)
	"trust": {"name": "Trust", "def": "The fighter's mood, read as trust in the corner.",
		"why": "A Flat or Low fighter takes in less of the corner's calls between rounds."},
	# GameMoney.BILL_EVERY_DAYS
	"bill": {"name": "Month-end bill", "def": "Wages and upkeep, paid every four weeks.",
		"why": "Time stops on the bill day so you see it land."},
}


static func term(id: String) -> Dictionary:
	return TERMS.get(id, {})
