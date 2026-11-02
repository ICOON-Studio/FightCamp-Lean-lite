# G109_HUB_LIVE_COUNTS (Grok, collected S82 2026-09-26 from grok.com chat "G109HUBLIVECOUNTS")

**What would a human do?** A management-game UI designer picks ONE number per hotspot (the decision the player
would otherwise click to discover), turns it into an alert only when action is required (colour + badge; pulse only
for time-critical), and at zero hides the numeral so empty rooms do not shout.

## 1. How the listed games put state on a hub picture
- **Two Point Hospital (2018)** - rooms carry a circled queue count + missing-staff glyphs; colour overlays are
  TOGGLED, not always-on. SOURCED two-point-hospital.fandom.com/wiki/Icons; PC Gamer review 2018-08-30.
- **Two Point Campus (2022)** - same grammar (queue numeral, missing-staff icon). SOURCED fandom Visualisation_Modes.
- **Football Manager Home -> Portal (FM24-26)** - SI merged Home into Inbox because Home use was "limited"; the unread
  badge and red "Must Respond" are the only Home chrome players remember. SOURCED SI manual FM24 2023-10-12; FMRo 2025-09-11.
- **Motorsport Manager HQ (2016)** - building level/upgrade state, no occupancy numerals. SOURCED fandom wiki.
- **Hollywood Animal (2025)** - buildings needing a hire/research go red "click me". SOURCED Digitec 2025-04-25.
- **Game Dev Tycoon** - occupancy is diegetic (empty vs busy desks), no numeric pins. SOURCED fandom Staff.
- **Punch Club 2 (2023)** - map pins are travel nodes, not live counts. SOURCED Steam news 2023-05-24.
- **Cage Legacy demo (2026-08)** - tab screens, no painted hub. PROXY Reddit 2026-08-04.

## 2. Praise / complaint
TPH queue + missing-staff icons praised (IGN 2018-09-06); advisor pop-ups called spam; TPC persistent head icons
"driving me nuts" (Reddit 2022-12-28); FM Portal chrome ignored except the unread badge (SI forums 2025-10-25).
Matches G106: scenery dies unless it carries a decision.

## 3. Readability
Peripheral HUD cannot carry strings; few, large, high-contrast marks; motion only for the one urgent thing (Player
Research 2026-09-18). Plaque + dark scrim beats raw white text on gym art (JUDGEMENT). **4 always-on labels is the
ceiling** for one hub shot; a fifth label or a second line per pin reads as HUD (PROXY).

## 4. Recommendation for FightCamp's four pins
| Pin | One count | Alert | Zero |
|---|---|---|---|
| Office | pending decisions (offers + contracts + inbox items that block a day) | badge, amber at >=1 must-act; pulse only if a deadline is today | hide numeral, no "0 offers" |
| Staff room | staff needing you, not headcount | amber if anyone waiting; red if a session is blocked by a missing coach | hide numeral |
| Ring | live sessions now ("2 sparring") | amber if booked and unwatched | hide numeral |
| Gym floor | athletes on stations now | amber only if a station is blocked (broken / no coach); occupancy itself is NOT an alert | hide numeral, sparse picture |

Max 4 plaques, at most one pulsing badge; the picture swap does the "packed" work. Colour + count = action exists;
pulse = time-critical; zero = silence; the tooltip holds the extra nouns ("3 offers - 1 contract expiry").
