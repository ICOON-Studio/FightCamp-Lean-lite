# NAV1 - THE GYM IS THE MENU (design on paper, Claude as lead designer, 2026-10-05)

Operator, 2026-10-05, on the exported .exe, verbatim: "remove the menus and use the 3d engine maybe for everything? put a timeline bar
on top to progress continuously and pose in menus or something like that" and "check if you have already the research done and come
back with something I will enjoy playing".

## What the record already says (no new study needed to decide the direction)
- `DESIGN_ON_PAPER_S159.md` s8: "The gym is a place you can see: a bright, lived-in 3D gym that fills with people as you grow. It is
  the home screen, not a menu." - the operator's ask IS the design of record; the rail-and-hubs shell is what we shipped instead.
- `S81_HUB_DISPLAY_SYNTHESIS.md`: 3D is cheap to render (12 idling fighters 6.7 ms p95); players ignore scenery that carries no data
  (G106) - so every thing you can click must show a live number or a person.
- `J54_MENU_ARCHITECTURE_SURVEY.md`: five jobs (develop fighters, get them fights, run the gym, make money, know what needs me) - the
  jobs stay; only WHERE they live changes: from a rail to places in the gym.
- `D33` (S151, operator): rooms stay 3D. `G109`: one live number per hotspot. `D61`: doors need their own readable signs.
- Time today: CONTINUE advances one day; week review on Monday; camp counts down in weeks; fight week -> weigh-in -> fight night are
  setpieces. The MMA/boxing engine simulates a bout in real time already (fight night).

## The screen (one screen, always)
```
 ┌─ TIMELINE ────────────────────────────────────────────────────────────────────────────────────────────┐
 │ ◄ Mon 5 Jan  ▌▌ ▶ ▶▶ │ Tue  Wed  Thu  Fri  Sat  Sun ║ Mon 12 ... │ ⚑ weigh-in Fri 30 │ 🥊 FIGHT Sat 31 │ $ bill 1 Feb │
 └────────────────────────────────────────────────────────────────────────────────────────────────────────┘
   [gym crest · cash $21,082 · 1 fighter]                                               [inbox 📞 3] [⚙]

                     THE 3D GYM (the camera we have: wide, slightly high, slow drift)
     office (desk: offers 3)      staff room (coach: none - "hire")       the ring (Torres · sparring Thu)
     floor (bags: Torres drilling the jab · 84% fit)        front desk (members 56 · 7 walk-ins)
     the door (scouting: 1 you can sign)                    the wall (chapter 1: 2 of 14)

   [ a person or a place is clicked -> ONE panel slides over the right third; time PAUSES ]
```
- **No rail.** Every job is a place or a person in the gym. Hover shows the live line (G109's one number). Click opens its panel.
- **The timeline bar** is the only chrome at the top: the playhead on today, the next two weeks of days, every DATED thing pinned
  ahead of it (weigh-in, fight night, bill day, an offer's expiry, camp end, a story call). Controls: pause, play (1 day per ~4 s),
  fast (1 day per second). Time **pauses by itself** whenever a panel is open and whenever a decision is due (a pinned thing turns
  gold and the playhead stops on it). This keeps the one-decision-a-day rhythm the week review depends on: nothing is missed, the
  player only chooses how fast the quiet days go by. (Two Point Hospital / Prison Architect do exactly this.)
- **The week review** stays, as a card over the gym every Monday (M40 look, the one screen the operator liked); the playhead stops
  on it.
- **Fight week, weigh-in, fight night, result** stay as setpieces: the playhead reaches the gold pin, the gym fades to the arena.
- **Panels replace hubs.** What was FIGHTERS / FIGHTS / FINANCE becomes:

| Click in the gym | Panel (over the gym, time paused) | Today's screen it replaces |
|---|---|---|
| A fighter (on the floor, in the ring, on a bench) | HIS CARD: identity strip, six attributes with bands, condition, next bout, THIS WEEK (set the programme), CAMP | profile tabs + training |
| The office desk | OFFERS on the desk (one card per offer: opponent, purse, date, venue, the match-up sentence), SCHEDULE calendar, LADDER | FIGHTS hub |
| The office safe / ledger | MONEY: balance, weekly net, next bill, the sentence about your situation | FINANCE hub |
| The staff room | THE STAFF: who works here, the empty chair = HIRE (candidate card, FM logic) | staff + scouting STAFF tab |
| The front door / street | SCOUTING: who is outside this week you can sign (candidate card) | scouting FIGHTERS tab |
| The front desk | MEMBERS: dues, walk-ins, classes | members |
| The ring | SPARRING / the next bout's plan | camp + plan |
| The wall of photos | THE WALL (story chapter, STORY4) | - |
| The phone on the desk (rings) | THE INBOX (story cards, calls) | story_inbox |

- **People move with the week.** The programme you set is what you see: Torres on the bag on bag days, in the ring on sparring days,
  resting on rest days. A hurt fighter sits. A coach stands with his fighter. Nobody idles for show (S81's rule).
- **Decide-first.** Anything due today has a gold ring around its place in the gym AND a gold pin on the timeline. The FIRST JOB
  card becomes the coach standing by the door pointing at it (the guide is a person, not a box over the buttons).

## The first hour in this screen (the S159 table, re-walked)
| Minute | What the player does | Where |
|---|---|---|
| 0-3 | City, name the gym, your name, story on/beside/off. One screen. | creation (unchanged) |
| 3-5 | The gym fades in, empty. The phone rings: Dessa's call (story). Timeline shows Mon 5 Jan, nothing pinned yet. | gym + inbox panel |
| 5-10 | The coach by the door: "one boxer is outside". Click the door: the candidate card (FM logic). Sign Torres. He walks in. | door -> candidate |
| 10-14 | Click the desk: three offers. The match-up sentence says which is even. ENTER THE CARD: a gold pin lands on Sat 31. | desk -> offers |
| 14-18 | Click Torres: THIS WEEK (bag, ring, rest) and CAMP against Hassan (focus + protocol). Press play. | fighter card |
| 18-25 | The week runs: Torres drills the jab on the bag, spars Thursday, Monday the week review card. Fast-forward the quiet days. | timeline |
| 25-40 | The playhead reaches the gold pin: weigh-in, fight night, the corner, the honest result. | setpieces (unchanged) |
| 40-60 | Back in the gym: the result on the wall, a harder offer on the desk, the coach's chair still empty. | gym |

## What this removes and what it keeps
- REMOVED: the left rail, the four hubs as screens, the sub-page groups (the Scouting problem cannot happen: scouting is the door),
  CONTINUE as a button (it is the play control), the FIRST JOB box (it is the coach).
- KEPT (as panels or setpieces): every read and every action the game has today. No system is cut, only re-homed. `SceneRouter`
  routes stay; the gym opens them as overlays instead of screens.
- RISK named: the engine clock. Today a day is one function call on CONTINUE; continuous play calls it on a timer and must pause on
  every "needs you" item or the player misses a weigh-in. Rule: the clock never passes a due decision (same gate as today's
  "CONTINUE will not move the days until you SET CAMP"). The determinism tests (pinned seeds) are unaffected: the same calls in the same
  order.

## Build slices (each one playable, each one judged by the operator on a video of the first hour)
1. **TIMELINE1** - the bar + play/pause/fast over the existing day function; auto-pause on every due item and on any open panel;
   pins for every dated thing. Rail still present (control arm). Test: 4 weeks at fast speed never skip a due decision; byte-identical
   career state to 28 CONTINUE presses.
2. **GYM-CLICK1** - the HOME 3D gym becomes clickable places with live lines; every hub opens as a panel over it; the rail is hidden
   behind a switch (`gym_is_menu`, default OFF until the operator's OK). The coach-by-the-door replaces the FIRST JOB box.
3. **CARD1** - THE CANDIDATE and the fighter card rebuilt on the FM logic (K86 spec + M42 mock + J62 transcript when they land; the
   paper version above until then).
4. **PEOPLE1** - fighters on stations by programme (the training clips we have: C237 guard idle, the certified punches on the bag;
   no clip = he sits on the bench, honestly).
Order: 1 -> 2 -> 3 -> 4. Slice 1 and 2 are the "something I will enjoy playing": time that moves while the gym lives, and nothing to
find in a menu. Slice 2 ships OFF until the operator sees it on a video and says on (S117 switch rule).

## What would a human do? / Prefab check
A AAA lead would prototype the clock first (slice 1) because it changes the feel of every minute; the gym-as-menu is the skin on it.
Prefabs: Godot has no timeline-bar control; it is a drawn Control (UIKit) over `GameState` dates. The 3D gym, pins, rooms, camera
and the clip set exist. References to copy exactly: Two Point Hospital's top bar and pause-on-panel; Football Manager's "continue to
the next thing that needs you" as the fast mode's stop rule.

## Decision asked of the operator (taste)
Say "go" and the next session builds TIMELINE1 and GYM-CLICK1 behind a switch and shows you a 90-second video of the first ten
minutes in that screen before anything replaces the rail. Say "rail" and NAV1 repairs the hubs instead (K86 list + CARD1).
