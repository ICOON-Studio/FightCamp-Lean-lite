# FightCamp - the paper design (D35) against what we built (S159, 2026-10-04)

Design: `DESIGN_ON_PAPER_S159.md` (settled D35). Evidence: two read-only code audits of the shipped game (game switches
as the player gets them), spot-checked by hand: no player towel (only `FightRealtime._maybe_corner_stoppage`, automatic,
kickboxing), knockdown slow-mo dead behind the camera director (`FightWorldLiveScreen.gd:4772`), Film Room charts
hard-coded (`FilmRoom3D.gd:532-533`), start = $25,000 and no fighters (`GameState.gd:129`).

## The verdict in one paragraph

The **week is ahead of the design and the fight night is behind it.** We built a deep camp (one booked opponent, film
study, plan sliders, taper, injury risk), a real ladder, contracts, ageing and retirement - pillar 2 is largely there.
But the moment the design calls the heart of the game - the corner - is missing its two most important parts: the
player cannot throw the towel, and he cannot read the fight (no stamina on screen, no scorecard guess, no commentary).
His corner calls change only one number in the engine. So the payoff of the whole week is a fight the player watches
but barely reads and barely steers. On top of that, about twenty features outside the first hour are reachable in a
boxing career, and the first fight is ~13 screen visits away.

## Pillar by pillar

### Pillar 1 - The corner is where you play: **BEHIND**
| Design | Built | Gap |
|---|---|---|
| Watch every round, 1x/2x/4x, skip, sim | 3D ring, 1X/2X/4X, SIM TO RESULT, SIM THE FIGHT on the tape | No skip-to-bell, no skip of the rest minute |
| TV camera that finds the action | One damped broadcast camera follows the pair | No shot changes; fine for the demo |
| Broadcast bar: clock, punches landed, stamina bars, face damage | Scorebug with names, round, clock, last order; small damage dots | **No stamina bars, no live punch count, no cuts/swelling on the faces** |
| One-line commentary ticker | Nothing during the round | **Missing** |
| Knockdown beat: slow-mo/replay, count, crowd | Fall, dust, crowd swell | Slow-mo exists but is switched off by the camera; no count on screen; scorebug knockdown pips never called |
| Corner READS: stamina, damage, confidence, round summary, opponent tendency, scorecard guess | Body figure with damage hotspots, end-of-round punch plate, camp-unlocked "his tell" card | **No stamina, confidence, scorecard guess; opponent read only if the camp unlocked it** |
| Corner CHOICES: plan + cut man + words | 6 instructions + cut/swelling/ice jobs with crew pace | Instruction moves only preferred range (+/-0.35); pace and emphasis are stored but **no engine code reads them**; no "what you say" talk |
| The towel | **Missing** | The heaviest decision in the design does not exist |
| 60 seconds to decide | A 60 s rest clock that never pauses; too slow = refused | Rushed: the player loses the choice while reading |
| Result: verdict, 3 judges, punch stats, three moments, consequences | Verdict, 3-judge round grid, ONE "why" line, output/connect card, rank/fame/injury/purse tiles | One reason, not three moments; no landed/thrown table; morale not shown |

### Pillar 2 - The week prepares the fight: **AHEAD (keep)**
- Camp exists only against a booked opponent, 1-8 weeks, focus tracks, protocols, sparring partner roles, taper,
  fatigue-on-the-night and injury bars, and Continue is gated on "set a camp or go cold". This is the design.
- Scouting is film depth that grows during camp (style -> strong/weak -> combinations). Good.
- Game plan: five sliders against the opponent with coach reactions. Good - **but a fighter with no saved plan fights
  with no plan at all**; the design says the camp's plan is his default.
- **Defect (honesty):** the Film Room's two charts (JAB SHARE, STAMINA FADE) are the same fixed numbers for every
  opponent, while the comment above them claims they are the plan's numbers. Fix now.

### Pillar 3 - Every fighter is a person: **MOSTLY THERE**
- 9 attributes (design 6); boxing shows grappling, takedown defence and top control - noise in a boxing demo.
- Personalities, ambitions, rapport with the coach, rivalries, ageing, retirement: present.
- Potential is shown openly; the design hides it and reveals it with fights and good coaches (the "find a gem" dream).
- No trait list ("cuts easily", "slow starter"); personality covers part of it.

### Pillar 4 - Honest, readable outcomes: **PARTIAL**
- Judges' grid and a causation line exist. Missing: the three deciding moments, a punch table, a visible reason chain.
- The fake Film Room charts break this pillar outright.

### The gym layer
| Design | Built | Call |
|---|---|---|
| 4 staff roles (assistant coach, cut man, scout, conditioning) | Only "coach" (up to 6); cut man is a corner lane, not a hire | Early Access: add cut man + scout as hires (each one clear effect) |
| Few facilities, each does one thing | 25 equipment items + wings + decor | Demo: show the ~8 a boxing gym needs; rest later |
| Gym earns from dues, purse share, sponsors | Dues + sponsors; purse share $0 unless a manager contract is filed | Default a coach's purse share so fights pay the gym |
| The gym is the home screen, a place | Painted gym still with pins into walkable 3D rooms | Keep (D33) |

### The first hour
| Design | Built |
|---|---|
| Min 3: meet your first fighter (raw, one strength, one flaw) | Start with $25,000, **0 fighters, 0 staff**; sign a boxer and hire a coach in Scouting first |
| Min 15-25: first fight night | ~13 screen visits to the first result; 11-step tutorial in 4 chapters (exists, good) |
| 3-5 decisions a week | ~30 pages, 4-group rail, many optional tabs |
| Demo ends after the pro debut | Turning pro is a silent flag, no moment |

### Built but outside the slice (reachable in a boxing career today)
MMA/kickboxing fighters in Scouting, an MMA transition button, Promotions tab, Tournaments tab, superfights, double
champions, women's offer board, press conferences, rivalry grudge offers, 175 countries, sparring market, weight cut,
25 equipment items, wings, decor, retiree-to-coach. **None is deleted** - the design's cut list says they wait behind
a demo switch until the first hour is fun.

## The plan, in the order the first hour shows it

1. **Fix the Film Room charts now** (defect): draw them from the opponent's real plan numbers.
2. **The corner, complete** (pillar 1): pause the rest clock while the corner card is open (or give the full 60 s of
   reading time); add the reads (stamina, confidence, coach's scorecard guess, one opponent tendency); add **the towel**;
   make every instruction change the engine (wire pace and emphasis, not only range) and prove it with a paired
   test: same fight, two calls, the next round measurably differs.
3. **Read the round** : stamina bars and punches landed in the scorebug; a one-line commentary ticker from the beats
   the engine already emits; knockdown count on screen with the scorebug pips; skip-to-bell.
4. **The honest result**: three deciding moments (from the causation data we have) and a landed/thrown table.
5. **The first hour path**: start with one raw boxer already in the gym and a coach (you are the coach); the camp's
   plan becomes the default plan; the pro debut becomes a moment and the demo's end; cut the route to the first fight
   from ~13 visits to ~7.
6. **Demo switch**: hide everything in "outside the slice" from a boxing demo career (no code deleted).
7. **Early Access backlog, not demo**: cut man + scout hires, hidden potential reveal, traits, purse share, facility
   trim, 6 boxing attributes on the boxing profile.

## What this means for the current queue

- In-flight agent runs finish and get merged if green (they are already paid for).
- **No new tasks** on MMA, clinch, kickboxing, staff MetaHumans, venues or extra rooms until items 1-6 ship.
- Punch-clip quality (C223/Q213) stays, but as polish behind items 2-4: the corner and the readable round decide the
  demo, not the last 3 mm of glove contact.
