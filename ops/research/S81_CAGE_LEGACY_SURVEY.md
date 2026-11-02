# S81 - COMPETITOR SURVEY: Cage Legacy (Steam app 5002990)
Claude, 2026-09-25, operator request: "i want this game surveyd". Sources: Steam store page, developer site
roguedogindie.com (#cage-legacy), the five Steam screenshots (read by eye; copies in the session scratchpad only,
never in the repo). Demo NOT played: it installs through Steam on the operator's account - see "Next" below.

## What it is
- **"Build a struggling MMA gym into a title-winning empire"** - a single-player pixel-art MMA gym management sim.
- Developer/publisher: Werner Viljoen, "Rogue Dog Indie" - ONE person, ships fast (8 titles on the site: two paid
  releases July 2026, browser prototypes, an Act I early access).
- **Full release March 2027. Free demo LIVE now** ("the real build", stops at 60 in-game weeks, ~25 min). Win/macOS/Linux,
  English + 5 languages, min spec integrated graphics + WebGL (a web-tech build), 1 GB.
- No reviews yet, no trailer on the store. AI disclosure: portraits, characters, venue/event/facility art "initially
  created with generative-AI tools, then ... edited". Mature note: underground fights, police raids, optional doping.

## Feature list (their words, condensed)
8 divisions, 4 fictional promotion tiers, persistent rankings and title paths; generated fighters with hidden potential,
style, morale, health, ageing, decline, retirement epilogues; training plans, nutrition, weight cuts, injuries;
scouting with ratings shown as RANGES; contracts (purses, win bonuses, PPV points, clauses), staff payroll, gym
memberships, sponsors, facility construction; press conferences, weigh-ins, face-offs, rivalries, weekly events;
underground money; **live fight nights in a "stylised 2.5D octagon" with corner input**, normal / double / skip.

## What the screenshots show
1. **Command Center** (HOME): left rail of 14 sections in 3 groups (Gym Operations / Fight Business / Front Office),
   top bar season-week-balance-reputation-gym stars + a red ADVANCE WEEK. A wide pixel-art **banner still** ("GYM CAM
   01") with a slogan, 4 stat tiles, the fight team as rows (portrait, 6 stats, OVR bar, record, READY), Gym Pulse,
   World Fight Wire ticker.
2. **Camp Planner**: same banner still ("GYM CAM 02"), 3 tiles, one card per fighter: training plan / diet / weight
   cut dropdowns with a weekly $ cost, over-limit lb in red.
3. **Scouting Board**: banner (world map + dossiers), 4-step flow strip (search -> watch -> dossier -> offer),
   prospect cards with scouted OVR and potential as ranges, signing fee + weekly wage, OFFER CONTRACT.
4. **Your Legacy**: titles, wins, reputation, net worth; trophy cabinet; achievement wall; gym alumni.
5. **Live fight**: a pre-rendered pixel octagon from an elevated broadcast cam, one static-looking pixel sprite pair
   on the ground, stamina/damage bars, momentum, a text log with jokes ("a judge confidently scores the feints"),
   8 corner orders (Pressure, Wrestle, Submission, Counter, Recover, Inspire, Cutman, Bend Rules).

## Read against FightCamp
**Where they are level with or ahead of us**
- **The same design space, almost line for line**: weight cuts, camps, ranged scouting, contracts with clauses,
  press/weigh-in/face-off hype, corner orders, rankings, retirement. A player who tries their demo first will read
  ours as "the other one".
- **A playable demo is public now and the date is set** (March 2027). We have no public build.
- **Legibility**: every screen is one dense, consistent dashboard; the rail labels carry a subtitle ("Contracts &
  health"); one hero banner per page, then numbers. Fast to read, cheap to extend.

**Where we are ahead, and it is not close**
- **The fight itself.** Theirs is a still arena with a sprite pair and a text log - the fight is the log. Ours is
  simulated body-on-body in 3D with real motion, camera director and broadcast shot. **This is the one thing a
  one-person web-tech pixel game cannot copy, and it is where FightCamp must spend.**
- **Disciplines**: they are MMA only. We book boxing, kickboxing, MMA and grappling with discipline-legal fighters.
- **Real organisation names** (operator ruling 2026-09-25) vs their four fictional promotions.
- **Hubs that change** (S81's question): their banner is one fixed still per page ("GYM CAM 01/02") that never shows
  the player's own gym or fighters. That is exactly option A's weakness in `TASK_HUB_DISPLAY_EVAL.md`, and they chose it.

**What it says for S81's hub-display decision**
- A (stills) is what the direct competitor ships. Doing only A makes our front end look like theirs with brass instead
  of pixels. It strengthens the case for **C (our 3D engine on HOME)**: our own fighters on our own floor is the
  visible difference in the first ten seconds, before any fight.
- Their banner-plus-tiles layout is a good pattern for INNER pages (one picture, then numbers) - note, not copy.

## Added from Grok (G106, same day, sourced)
- Developer post, r/playmygame, 4 Aug 2026 (reddit.com/r/playmygame/comments/1vfiu24): the demo started at 20 turns
  with a Steam median session of ~11 minutes; it was extended to 60 weeks / ~25 min because players FINISHED it rather
  than bounced. That is a retention signal for the niche, not only for them.
- No press coverage found as of 2026-09-25. Different products with near names: "Cage Empire" (Steam 5062590) and an
  itch.io "Cage Legacy" by Bobin03.

## Risks to watch
- Their scope claim is large for one developer; the demo is 60 weeks. Their review score in March 2027 sets player
  expectations for the whole niche - good reviews help us (the niche exists), bad ones on the fight view help us more.
- Name collision: none (Cage Legacy vs FightCamp). Their promotions are fictional, no clash with our real org names.


## DEMO PLAYED (2026-09-25/26, build 1.23.0, "FIRST 120 WEEKS", Standard difficulty, 10 in-game weeks, 2 fights)
Installed through Steam on the operator's word; driven by Claude over the Electron app's DevTools port (it is an
Electron web app, 520 MB). Screenshots in the session scratchpad only.

**Onboarding.** Owner registration (gym name, manager name, 3 difficulties, 16 crests), then an 8-step coach-mark
tour, one line per page: command center (watch weekly burn), fighters, training, fight office, intel, corner, legacy.
Short, skippable, and it teaches the whole loop before week 1. Worth measuring ours against.

**The loop, as played.** Fight Office -> pick a fighter -> the promotion offers exactly THREE opponents (safe tune-up
-7 OVR / even / ranked gamble +3..+11 OVR) -> haggle (purse tier, win bonus %, PPV points, fighter share, one clause:
rematch or catchweight) -> signed, fight in 6 weeks -> Training Camp (plan / diet / weight cut dropdowns per fighter,
priced per week) -> Opponent Intel (tape $600 -> field scout $1,500 -> inside source $3,200; each level narrows the
opponent's rating RANGES and adds a joke "scout report") -> advance weeks -> weigh-in face-off choice (calm stare /
shove / break first) -> weight made or missed -> tale of the tape -> live fight.

**The fight.** 3 rounds of **30 seconds**. Two identical pixel sprites (only the shorts colour differs) stand apart
under a referee in a pre-rendered octagon; the fight is a scrolling text log, one line every ~2.5 s, from a SMALL POOL
OF JOKE LINES that repeat within a round ("They trade in the centre. Nobody wins, except the replay editor." five times
in one round). Tags show the opponent's live plan when intel is level 2 ("[HE IS PRESSURING]"). A boxer was logged
"hunting takedowns" and "chasing subs"; the commentator mentioned an "inside leg kick". Between rounds: a summary
(strikes, takedown/ground edges), a card estimate, treatments. Results: Marco (BJJ) beat a boxer on a 2-1 decision;
Kabelo (kickboxer, weight missed by 1.5 lb because I left his cut on Maintain) lost by TKO in round 2 to a +11 OVR.
**My corner-order clicks did not register (log stayed on the default COUNTER), so whether orders change results is
UNTESTED here** - their tutorial claims a rock-paper-scissors: wrestle > pressure/counter, pressure > submission,
submission > wrestler, counter > pressure.

**What is good (operator agreed on the first three, 2026-09-26)**
- **Scouting that keeps a file on the opponent** - a numbered case, style, primary threat, ranged ratings that narrow
  as you pay. Operator: *"this is some good idea to keep record of scout to know weak points of fighters you scouted"*.
- **Gym facilities** - operator: *"their gym facilites seems well thought"*. Six buildings, each ONE effect (Heavy Bag
  Hall = striking, Mat Academy = grappling, Performance Lab = cardio + injury, Recovery Suite, Fuel Kitchen = weight +
  morale, Fighter Dorms = roster size), 3 levels, a ONE-OFF build price ($6k-$15k), no weekly charge; members
  (81 at start, $972/week) grow with reputation and facility levels.
- **Backroom staff** - operator: *"backroom staff nice too"*. Named hires, one role each (head coach, cut specialist,
  wrestling / striking coach, sports psychologist, nutritionist), one "training effect +N%", one weekly wage.
- Finance page: runway in weeks at current burn, weekly commitments itemised, a projected next week, a ledger.
- Media: per-fighter media plan (blackout / standard / build the star), 3 PR events, 4 endorsement tiers gated by rep.

**What is weak (our openings)**
- **The fight is a text log with two identical sprites**, 90 seconds long, with repeating jokes. Ours is the body.
- **Fighter share "fair" = 30%**: the gym keeps 70% of the purse. Real managers take roughly 10-33%. The money model
  is upside down; ours can be right.
- **Rankings do not hold together**: Kabelo was #54 in week 1 and #7 in week 7 without fighting; Marco showed #68 in
  the office and #7 on the tape. A #6 accepts a 9-3 #68.
- **Canned text**: the face-off report was word for word the same for both fights; the weigh-in art is one painted
  picture (not pixel art) of the same two men for every bout.
- Weeks 2-5 of the first camp had NO events at all - advance, advance, advance.
- The title screen is a hooded fighter seen from behind walking to the cage - very likely the "other game" the operator
  recognised our S80 walkout still from.

**For FightCamp (decisions, not questions)**
- Build a lasting SCOUTING FILE per opponent (operator's idea): what our film study and scouts learned, kept across
  fights, with known weak points, visible when booking and in the corner. We have film depth only INSIDE one camp
  (`FightCamp.gd:204-261`), forgotten after the bout. -> queued as a design task (see HANDOFF).
- Add a MEDIA / PR hire to backroom staff (operator 2026-09-26: *"if you invest to a media guy he can promote fighters
  and generate the hype"*). Today our staff is coaches only; hype comes only from press conferences and media choices
  (`GameState.gd:10610` `_apply_media_effects`). The hire would raise bout hype and fighter profile week by week, at a
  weekly wage. Their game has media plans and PR events but NO media staff member - this goes past them.
- Compare our gym facilities and staff pages to theirs on readability: one effect per building, one number per hire,
  one-off price stated plainly.

## Next
- Demo played 2026-09-26 (above). Untested: whether corner orders change results.
- Browser agents get this file as added context for their HUB_DISPLAY_EVAL memos (G106 Grok: watch for reviews when
  the demo gets coverage).
