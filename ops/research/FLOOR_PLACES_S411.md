# The floor: places free (S411, 2026-11-09)

Owner: "i agree with this [a smaller unit that grows], maybe in ethe training area there is meter showing how many usage has left a bar showing stamina next to each fighters and things like that more graphic representation than text". Then, on what the dots count: "Places free".
Concept pictures: docs/mockups/s411/open/floor/small_unit.png and grown_club.png. Claude's call within that: the rule below.

## The rule
Every piece of training equipment has a number of places: how many people it holds at once. The dots over it are its places, lit when taken.
1. **The floor's places add up to the premises.** About one member in three trains at the busy hour, so a floor carries three members per place (real clubs run sessions of 20-25 for a roll of about 70). Unit: 70 members, about 23 places. Bigger unit: 140, about 47. Club building: 250, about 83.
2. **No change to the money at the start.** `GymSpend.member_cap` stays the one rule for how many members a club can hold. Places are that same limit, shown on the floor station by station. An upgrade that "takes room for 10 members" visibly takes about 3 places.
3. **Who fills them.** At the busy hour, the members in (members / 3) spread over the stations, by each station's share of the places. The club's own fighters take a place first, at the station of today's session.
4. **The decision it gives you.** A full floor is why the member count has stopped rising, and now you can see it: move to bigger premises, or drop an upgrade that eats room. When coaches are the limit instead (`GymSpend` already knows which), the dots are not full and the coach shows it.
5. **Each building's style** leans its places a different way, with the same total for its size. The bag wall has more bag places, the conditioning floor more mat places, and so on. Bonuses are unchanged.

## Sizes
| Premises | Members | Places | Plan |
|---|---|---|---|
| Unit, 1,500 sq ft | 70 | 23 | new, about 16 x 12 cells, one ring |
| Bigger unit, 3,000 sq ft, a second ring | 140 | 47 | today's four plans, adjusted |
| Club building, two floors | 250 | 83 | new, about 32 x 24 cells; the second floor drawn later |

## Not in this step
A full station does not yet cost a fighter any training. If the floor feels like decoration once played, that is the next rule to try, measured on the balance harness first.
Stamina bars read each boxer's real fatigue (0-100, 80+ overreached).
