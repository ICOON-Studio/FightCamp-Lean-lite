# Playtest Report - Claude - update 26

## Session Info
- Date 2026-10-31, build Lean 2ad365f (update 26), tests 41/41.
- Runs: `tools/fight3d_play.gd` (the real flow: quick start, interview, three week cards, sign, hire Reid, run to an offer,
  accept, camp with film study, weigh-in, fight night, round 1 with the 0:30 shout, corner minute -> "lead", round 2,
  SKIP BOUT, result, round page) - FIGHT3D_PLAY failures=0; `tools/layout_snapshot.gd` (19 screens title -> corner 1);
  `tools/burn_probe.gd` (round 1 vs round 3 at 2:30, tired look + body view + shout bar), `tools/pages_still.gd`,
  `tools/ref_probe.gd` (referee on the game camera, rounds 1-3). All on the hidden desktop, 1920x1080. Stills:
  Lean Builds/s323_play, s323_screens, s323_burn5, s323_pages2.

## Test Focus
Update 26's five changes (tired look, body view, Pace/Aim, broadcast pages, referee) and the whole loop as a new player.

## First Impressions (first 5 minutes)
- Understood the goal? Yes: HOME says "A fighter is waiting at reception - Meet her" in red on the top bar; one clear
  first action.
- Understood the controls? Mostly. The top bar's II > >> >>> clock and CONTINUE are clear; "Gear" is not.
- Emotional response: engaged in the fight, neutral in the menus.

## Gameplay Flow
### What worked well
- The fight screen now carries the body: both side panels light up part by part (blue/green/yellow/red), and by round 3
  the jab shoulder of the busy jabber is red - readable at a glance.
- Tired is visible from the broadcast camera: both jab gloves at chest height late in round 3, Maria (energy 22) folded.
- The round and result pages read like TV graphics (big names in corner colours, huge numbers, the leader bright).
- The shout bar's PACE / AIM row sits in one line under the calls; the choice carries over.
### Pain points
- (High) THE CORNER MINUTE DOES NOT SHOW THE BODY TRACK. The corner card - the "pit stop" of the body-is-the-track plan,
  where the player decides what to do about a burning part - still draws the old figure (head/ribs ovals only). The
  round page's figures too. The one moment the burn matters most is the one place it is missing.
- (Medium) The corner card is dense: worked/hurt/seen/coach lines, a habit fix row, RECOVER 3/3 with +/- jobs, SET-UP,
  TALK (3), and 8 calls - about 16 things to read in 60 s.
- (Medium) Management screens are lists in brown boxes with much empty space (HOME: two short cards on 60 % blank;
  FIGHTS > Offers: two rows) - the same "spreadsheet" feel the operator named for the fight pages.
- (Low) The referee still crosses the gap between the two heads 13 % of the watched time (was 43 %), mostly walking.
### Confusion points
- PACE has no visible cost until the next round: nothing on the bar says "Push = burns faster, empties the tank".
- The body view has no key: blue = fresh is not obvious (blue is also the blue corner's colour).
### Moments of delight
- Seeing Maria fold and her jab hand drop while the HUD says ENERGY 22 - the numbers and the bodies finally agree.

## Bugs Encountered
| # | Description | Severity | Exact steps | Screenshot |
|---|-------------|----------|-------------|------------|
| 1 | Corner card figure ignores the body track (BodyFigure.set_track never called on it) | High | fight night, round 1 bell -> corner card | s323_play/p05_corner_card.png |
| 2 | Round page figures ignore the body track | Medium | round 3 bell -> round page | s323_pages2/round_page.png |
| 3 | Snapshot tool shows the "Luke Reid hired" toast still up a week later (tool steps no real time - check in the exe) | Low | layout_snapshot 06 -> 10 | s323_screens/10_offers_real.png |

## Feature-Specific Feedback
- Tired look: understood yes; engaging yes; suggestion - nothing now.
- Body view: understood partly (no key); engaging yes; suggestion - a one-line key under each panel
  (FRESH - WARM - HOT - BURNING) and show it in the corner and on the round page.
- Pace + Aim: understood yes; engaging - the cost is invisible; suggestion - one muted line under the row saying what the
  chosen pace costs ("Push: wins more, burns faster").
- Round + result pages: understood yes; engaging yes; suggestion - put the body track on the two figures.
- Referee: much better; residual crossings are walks.

## Overall Assessment
- Would play again? Yes (the fight). Difficulty: not yet felt. Pacing: the fight is good; the menus are slow and flat.

## Top 3 Priorities
1. The body track in the corner minute and on the round page (the pit stop must show the tyres).
2. Make the pace's cost visible on the bar and give the body view a key.
3. The management screens get the same broadcast treatment as the fight pages (fewer boxes, bigger figures).
