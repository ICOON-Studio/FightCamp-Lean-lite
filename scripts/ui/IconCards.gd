extends RefCounted
## S533 TIPFIX3 (owner Q-S294-283 "Shorter cards"): a kit icon on a table says what its mark MEANS, as a SHORT card, not its
## bare name ("Champion", "Rising", "1-25%" told nothing). KitIcon.gd is generated from kit.js, so its one-word names stay
## there; the cards live here. The key's words (WorldCompare.key) are the titles.
##   IconCards.attach(c, id) -> true when `id` has a card (the icon's old tooltip is replaced)

const Tip := preload("res://scripts/ui/Tip.gd")

## id -> [title, what, do]. WHAT one sentence of 10 words or fewer; the card 14 words or fewer.
const CARDS := {
	"champion": ["Champion", "Holds the world title at this weight."],
	"challenger": ["Challenger", "Next in line for the world title at this weight."],
	"next_opp": ["Next opponent", "The rival in the booked bout."],
	"new_face": ["New face", "Arrived on this table at the last year end."],
	"booked": ["Booked", "A bout is on the calendar.", "See the date on Fights."],
	"camp": ["In camp", "In a fight camp for a booked bout."],
	"injured": ["Injured", "Hurt: no bouts until the injury heals."],
	"offer": ["Offer waiting", "A bout offer waits for an answer.", "Answer it on Fights."],
	"contract": ["Contract talks", "The contract is up for talks with the club."],
	"free": ["Free", "No bout booked yet.", "Offers come in on Fights."],
	"leaving": ["Leaving", "Another gym is trying to sign this fighter."],
	"retiring": ["Retiring", "Talking about hanging up the gloves."],
	"scouted": ["Scouted", "Part of this boxer is known: the range is narrower."],
	"unscouted": ["Not scouted", "Nothing known yet: the win range stays wide.", "A scout narrows it."],
	"up": ["Rising", "Moved up the table at the last rank change."],
	"down": ["Falling", "Moved down the table at the last rank change."],
	"hands": ["Stoppages", "The share of wins that ended inside the distance."],
	"warn": ["Not built yet", "This part of the game is still being made."],
}


static func attach(c: Control, id: String) -> bool:
	if not CARDS.has(id):
		return false
	var card: Array = CARDS[id]
	Tip.short(c, str(card[0]), str(card[1]), str(card[2]) if card.size() > 2 else "")
	return true
