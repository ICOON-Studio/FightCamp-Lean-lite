# G38 — THE GROUND FIGHT READ

Forecast research for the live viewer layer. No code. No repo. Engine facts are taken as given from the task (G34 events/seats/control units, G35 METHOD_SUBMISSION + stall clock, G37 adapter fold, R85R Undisputed HUD standard). Invention is labelled invention.

Delivered by Grok at Expert tier, 2026-09-10, 115 sources; driven in the in-app browser by Claude and committed verbatim from the chat.

---

## Verdict table

| # | Question | Verdict |
|---|---|---|
| 1 | Broadcasts: what is on screen in a ground exchange? | Names + fight clock. Position is spoken, not labelled. Control time is a *recap* stat, not a live running overlay on UFC / ONE. IBJJF shows points/advantages. Judo shows an osaekomi clock because the clock *is* the score. |
| 2 | Games: ambient vs diagnostic | Ambient that travels: a position word + who is on top. Diagnostic that does not: every submission minigame, Grapple Assist compass, Resilience bar as a QTE. |
| 3 | Control clock vs our integral | Not the same quantity. Broadcasts/UFC Stats log unweighted duration. We score 0/1/2 per tick. Show the seat. Do not dress the integral up as "ground control 2:14". |
| 4 | Submission threat | The open attempt is the threat. No pre-attempt "danger aura". While open: who, hold if known, closeness 0–100, 1 Hz. |
| 5 | Live-read design | Quiet. One seat chip on FightHudPanel. Event lines on BroadcastRead. No third surface. |
| 6 | Sound of ninety quiet seconds | Silence on BroadcastRead. The seat chip and the still-moving heart rate are the "not hung" signal. |

**Standing rule used here:** published broadcast and shipped-game facts first. Design recommendations are invention and marked as such.

---

## 1. How real broadcasts show ground position

### UFC (Fox 2011–2018, ESPN 2019–present, Vizrt/RCS package from UFC 273 in 2022)

Persistent on-screen package is names, records, round number, and the round clock. That is the graphic. Position is not printed on the fight feed.

What the viewer actually gets during a ground stretch:

- Commentary names the seat on the transition ("he's in half guard", "takes the back", "looking for the rear-naked") and then often stops naming it every second.
- Control time exists as a *logged* stat. UFC Stats / ESPN publish it per fighter per round. Example on the record: ESPN and UFC Stats logged **21:40 of control for Khamzat Chimaev vs Dricus du Plessis across 25 minutes in 2025** (87% of the fight). That number appears on recap cards, between-round stat bugs, and post-fight packages. It is not a live MM:SS overlay running on the canvas while they scramble.
- Submission attempts are a discrete counted event on the same recap cards, not a live tightness meter.
- The 2014 Fox-era **FightTrax / "UFC DNA"** companion (FOX Sports write-up, Feb 2014; USPTO filings describing the UFC DNA interface) *did* show a "Time in Control" clock and a colour-coded control lane on a 5-second timeline, plus a position graphic (striking distance / clinch / ground / guard). That was a second-screen product, not the PPV/ESPN program feed. Do not treat FightTrax as the house broadcast.

Where UFC disagrees with itself: the *stat* is duration of control (ground top + cage pin). The *judges*, under the Unified Rules as amended 6 Aug 2025, are told to start with successful fighting techniques; three minutes of holding is not three points. Broadcast graphics can make control time feel like a scoreboard. Official scoring does not.

### ONE Championship (global ruleset, Colorado-approved text 2021; on-air practice unchanged through 2024–26)

Same shape as UFC on the program feed: names, clock, occasional mid-fight stat lower-third. No live position chip. No running control clock.

The distinctive ONE signal is **verbal and referee-side**, not graphic. ONE's own 2022 explainer: standing stall gets "action"; ground stall gets "improve your position" or "work to finish"; failure can be a yellow card and a stand-up. Judging the whole fight, not round-by-round, with near-KO / near-submission at the top of the pyramid. The broadcast trusts the referee's voice and the commentators to carry "this is a threat" — there is no tightness pip.

### IBJJF streams and FloGrappling (Worlds, Pans, The Crown; Flo as rights holder)

Two different products:

- **IBJJF points matches.** Persistent scorebug: points, advantages, penalties, match clock. Points appear after the referee confirms **3 seconds of control** in a scoring seat (IBJJF rulebook, Article on scoring; official tutorial "Principles of the Match", 2024). The graphic does **not** usually print "HALF GUARD" or "MOUNT". The number changes; the commentators name the seat. A near-submission is an *advantage after the fact*, not a live threat bar (Article 5 — advantage when the opponent is in real danger of submitting).
- **WNO / Flo "no points" cards (rules explainer 2021).** Names + clock. Decision criteria (aggression, dangerous attacks, positional control) are spoken, not scored live. The screen is emptier than IBJJF on purpose.

Flo commentary practice on IBJJF points cards (example: 2025 award-nominee match calls) is event-driven: "two points… mount… he's walking the arm up." They do not narrate every grip.

### Olympic / IJF judo (Tokyo 2020, Paris 2024; NBC Olympics rules explainer 2024; IJF scoring)

This is the one broadcast that *does* put a control clock on screen, because the clock is the score.

- Scoreboard: ippon / waza-ari (yuko restored for the 2026–28 cycle on short pins / side landings).
- Separate **osaekomi** clock starts when the referee calls "osaekomi", stops on "toketa" / "matte".
- Thresholds (current senior IJF): pin 10–19 s = waza-ari, 20 s = ippon. The number the viewer watches *is* the winning condition.
- Shime-waza / kansetsu-waza have no progress graphic. Tap, referee stop, or nothing.

Judo is not a model for MMA/IBJJF live read unless the ruleset in the chair is judo. Copying osaekomi onto a Unified Rules fight would tell the viewer a pin is about to end the fight. It is not.

### Where broadcasters disagree (plainly)

| Surface | UFC / ONE program feed | IBJJF points | WNO / submission-only | IJF judo |
|---|---|---|---|---|
| Position name on screen | No | No | No | Implicit (osaekomi = recognised pin) |
| Running control clock | No (recap only) | No (3 s gate, then points) | No | Yes — official |
| Submission tightness | No | Advantage after | No | No |
| What carries the seat | Commentary + picture | Scorebug delta + commentary | Commentary + picture | Referee call + osaekomi clock |

**Finding:** the honest broadcast answer for a mixed-rules fight sim is closer to UFC/ONE/WNO than to judo or to an IBJJF scorebug. The picture plus a spoken (or printed) seat name carries the exchange. Adding a live control clock is a stat-product habit, not program-feed practice.

---

## 2. How the games show it

Separate diagnostic (the minigame's own UI) from ambient (a label a spectator could use).

### EA Sports UFC 5 (2023)

- **Ambient:** the body language of the model, plus Grapple Assist goals that never change seat on the HUD (Get Up / Submit / Ground and Pound) so a spectator can read intent. Legacy mode shows a transition compass. There is no broadcast-style "GROUND CONTROL 2:14" chrome.
- **Diagnostic:** Submission Resilience meter that must be emptied to finish. Chaining submissions and denying transitions drains it. This replaced the UFC 4 minigame (Screen Rant, 27 Oct 2023; official deep-dive trailer ft. Martial Mind, Sep 2023). Still a player-input finish UI. Not ambient.

### EA Sports UFC 4 (2020) and UFC 3

- **Ambient:** Grapple Assist triad (Submit / Get Up / GNP) — UFC 4 redesign from the "messy options" wheel of UFC 3 (ISK Mogul, 11 Aug 2020; official manual).
- **Diagnostic, refuse:** two submission minigames. Chokes = wedges on a circle, left stick. Joints = wedges on an arc, triggers. First to overlap wins a stage (Den of Geek interview with Brian Hayes, 29 Jul 2020; official UFC 4 submissions tutorial). This is exactly the QTE the task forbids.

### UFC Undisputed 3 (Yuke's / THQ, 2012)

- **Ambient:** optional fighter HUD / paper-doll trauma; green energy bar under the name; the model and the transition direction carry the seat. Official manual lists Ground Position, Sub Position, transitions, referee break for stall — no printed "MOUNT" chrome as a broadcast lower-third.
- **Diagnostic, refuse:** octagon-shaped submission HUD. Attacker overlaps defender's bar; camera pushes in as the finish nears (official guided tutorial; GameSpot Now Playing 2012; digitalchumps review 14 Feb 2012). Reviewers already flagged the contradiction: a "HUD-free" game grows an eyesore the moment a sub starts.

### Fight Night Champion (EA, 2011)

Clinch only. No ground hierarchy, no seat table, no control clock. HUD default is stamina-only; "Health and Damage" is an option. Clinch is a tie-up you enter with LB+RB / L2+R2 and break with push. Useful only as a reminder that a short clinch does not need its own dashboard. Hayes' own later UFC work is the through-line, not Champion's clinch chrome.

### Undisputed (Steel City, early access 2023 → 1.0 2024) — house standard, R85R

Heart rate + zone for cardio. Discrete trauma. Attrition bars. **Clinch was removed** from 1.0 because it did not meet quality bar (official launch notes). There is no ground game to copy. We take the *specificity* of that HUD (rate, not a stamina bar; pips, not a smear) and apply it to ground — we do not invent a boxing ground layer.

### Grappling-first titles worth naming

- **EA Sports MMA (2010)** and **UFC Undisputed 2010**: same family as Undisputed 3 — transition stick + sub HUD. Diagnostic.
- **Absolver / Sifu / hand-to-hand beat-em-ups:** no positional grappling read that maps to seats.
- No shipped management sim has solved "spectator ground HUD" well. That absence is a finding, not a gap we fill with a minigame.

**Ambient layer that survives contact with "the player watches and corners":** a seat word, who is on top, and a threat read that appears only while an attempt is actually open. Everything else in this list is a control scheme.

---

## 3. The control clock

### Two quantities

| Quantity | What it is | Who uses it |
|---|---|---|
| Duration | Seconds of "this fighter is controlling the other" | UFC Stats, ESPN recap bugs, fantasy, FightTrax "Time in Control". Unweighted. Guard-top, half-top, mount, back, cage pin all tick the same clock. |
| Weighted integral | Our `control_score`: 0 / 1 / 2 units per scoring tick (1 s). 0 standing and guard, 1 clinch-top and half-top, 2 side / mount / back. | G34 table. Rulesets that care about *quality* of control. |

They disagree on purpose. A man in closed guard for 2:14 has a broadcast control-time of 2:14 if the statkeeper credits top control, and a FightCamp `control_score` of **0** from that seat. A man on the back for 0:40 has less duration and more score.

### What a viewer understands

Duration. "He's been on top for two minutes" is a sentence a casual viewer already has. "He has accrued 48 control units" is not.

### Would showing one while scoring the other mislead?

Yes, if the live number is presented as the thing the judges are adding up.

UFC already lives in that tension and papers it over by keeping the duration figure *off the live canvas* and putting it on the recap. Judges are not scoring the clock. We would make it worse if we put a running "CONTROL 1:12" on FightHudPanel while RealtimeRoundStats is folding `control_score` and position points into the card.

**Invention, labelled:** do not display a running MM:SS control clock as if it were the score. If a duration is shown at all, it is the **current-seat hold timer** (the same integer the stall clock is already counting) and it is framed as "how long this seat has lasted", not as "control score". The integral stays in the adapter / judges fold, which is G37's job.

---

## 4. Submission threat

G37: IBJJF advantage is derivable without a new event; `submission_threat` was flagged as optional.

### Does the live read need a threat signal beyond the attempt?

No, not before an attempt is open. Broadcasts do not put a "he might attack soon" meter on a man in side control. Commentators speculate; the graphic stays quiet. Games that pulse a danger aura off-attempt are teaching the player to press a button.

Once `submission_attempt` is open, the attempt *is* the threat. The viewer must be told three things, at the cadence the engine already has (progress 0..100 advances once a second):

1. **Who** — the attacker. Inferred from the fighter who owns the attempt, not from `top` (guard attacks exist).
2. **What hold** — a short name if the event carries one; otherwise the seat plus "submission" ("back, choke", "half, arm").
3. **How close** — the integer 0..100, shown as a single tightness read, not a minigame.

Cadence: appear on attempt-open, tick at 1 Hz, vanish on escape / finish / referee break. No linger after the attempt dies.

IBJJF advantage (near-sub that did not finish) is a *judges/adapter* fact. It can land on the between-exchange stats fold. It does not need a live pip of its own.

**Invention:** optional `submission_threat` event is not required for the viewer layer if `submission_attempt` already carries attacker + progress. Use the existing event.

---

## 5. Recommendation (invention — this whole section)

One concrete live read. Typed so a build task can lift it.

### Principle

A ground fight should look **quieter**, not busier. The striking HUD going still is not "broken" if a seat chip is present and the heart rate is still moving. That is the feeling: pressure, not highlight-reel. The player is the corner, not the grappler.

### What appears

**A. Seat chip — FightHudPanel**

- Visible when `stance` is `clinch` or `ground`. Hidden when `standing`.
- Copy: `seat` mapped to a short label (see paste block). Prefix with who is `top` when `top != -1` ("RED · HALF"). When `seat == guard` and top is set, the chip still shows GUARD — do not hide it because units are 0. The 0 is a scoring fact, not a visibility fact.
- Cadence: on `position_change`, `takedown`, `throw`, `clinch_engage`, `clinch_break`. Instant. No tween through intermediate seats.
- What it replaces on the panel: the striking-site pip row can stay (ground-and-pound still cuts people). The continuous body-attrition bars stay. Heart rate + zone stay. Nothing new is added beside those except this chip.

**B. Attempt tightness — FightHudPanel, same column as trauma pips**

- Visible only while a submission attempt is open.
- Copy: hold short-name (or "SUB") + a discrete 5-pip tightness (0–19 / 20–39 / 40–59 / 60–79 / 80–100). Discrete pips, not a continuous bar — matches R85R trauma language.
- Cadence: 1 Hz, matching progress ticks.
- Hidden otherwise. No "warm" state.

**C. Stall warning — FightHudPanel, on the seat chip**

- Stall clock is already an integer tick count in the current seat with no seat change and no attempt. First fire at 400 ticks = 20 s (G35).
- Chip goes amber at 300 ticks (15 s held). Chip goes red at 400. That is the "referee is about to stand them up" read.
- No separate countdown number unless we are in the last 5 s. Numbers here compete with the round clock.

**D. BroadcastRead lines — existing commentary surface**

Fire a line on:

- `takedown` / `throw` / `clinch_engage` / `clinch_break`
- `position_change` (one line, seat name, who is top)
- `exposure`
- `submission_attempt` open ("looking for the [hold]")
- attempt progress crossing 80 ("it's tight")
- attempt escape / finish
- stall first-fire / stand-up

Do **not** fire on control-unit ticks. Do **not** fire once a second in a stable seat.

**E. RealtimeRoundStats**

Unchanged charter: fold the log onto the judges. `control_score`, position points, takedowns, submission attempts live here, not on the live canvas.

### What deliberately does not appear

- A running "GROUND CONTROL 2:14" clock.
- A control-unit counter (`+2`, `48u`).
- IBJJF points/advantages on a Unified Rules fight.
- An osaekomi-style auto-win ring.
- A Grapple Assist compass, transition wheel, or any input prompt.
- A submission circle / arc / overlap HUD.
- A pre-attempt danger aura.
- Per-second commentary.
- A third surface.

### Why no new surface

FightHudPanel already owns "what is true of the bodies right now" (heart, trauma pips, attrition). A seat chip and an attempt pip-row are the same kind of fact.

BroadcastRead already owns "what just happened". Ground is event-sparse; that surface should get *less* traffic, not a new ticker.

A third surface would be the instinct this task exists to kill: three correct features that cannot line up.

---

## 6. What it should sound like

Ground fighting is long quiet stretches punctuated by transitions. UFC cageside practice (Anik / Cormier / Sanko-era PPVs through 2025) is: name the seat on the change, talk about the *plan* ("he's looking to pass", "need to get a hook"), then let the picture work. They fill dead air with story and corner context, not with a second-by-second grip call. Flo points-card callers are slightly hotter because the scorebug is changing. WNO callers go quieter still.

**BroadcastRead during ninety seconds of nothing: silence.**

Silence is the answer. It is also how you avoid the "bars that barely move and a line that says nothing" failure mode — that failure is a *striking* sentence stuck on a *ground* fight. Take the striking sentence away.

### How the UI says "deliberately quiet" rather than "hung"

Three living things stay on screen the whole time:

1. Seat chip still showing the current seat and who is on top.
2. Heart rate still ticking (R85R). Cardio is the thing that moves when hands do not.
3. Stall chip colour advancing toward amber if they are glued.

If those three are up, a blank BroadcastRead line is a choice. If the seat chip is missing and BroadcastRead is blank, it will read as hung. That is the whole bug R91 will ship into unless the chip lands first.

Do not invent filler lines ("still in half guard", "working", "jockeying for position") on a timer. Those are how a commentary surface tells the player it is broken in a different way.

---

## One-screen spec

| Element | Source field | Cadence | Surface | Notes |
|---|---|---|---|---|
| Seat chip | `stance`, `seat`, `top` | On seat/stance event | FightHudPanel | Hidden when standing. Label table below. |
| Stall colour | stall tick count in seat | Continuous; amber 300; red 400 | FightHudPanel (on chip) | G35 first fire = 400. |
| Attempt pips | attempt progress 0..100 | 1 Hz while open | FightHudPanel | 5 pips. Hidden when no attempt. |
| Attempt owner + hold | attempt attacker, hold name if present | On open | FightHudPanel + one BroadcastRead line | If no hold name: "SUB" + seat. |
| Event line | G34 events listed in §5.D | On event only | BroadcastRead | No heartbeat lines. |
| Heart rate + zone | existing | existing | FightHudPanel | Do not freeze it on ground. |
| Trauma pips / attrition | existing | existing | FightHudPanel | GNP still writes these. |
| Control duration MM:SS | — | — | **nowhere live** | Recap / judges fold only. |
| `control_score` integral | `control_score` | scoring tick | RealtimeRoundStats only | Never on the canvas. |
| Input prompt / QTE | — | — | **nowhere** | Hard refuse. |

### Seat labels (copy)

```text
none        -> (no chip)
over_under  -> CLINCH
guard       -> GUARD
half        -> HALF
side        -> SIDE
mount       -> MOUNT
back        -> BACK
```

Chip format: `{CORNER} · {LABEL}` when `top` is a fighter; `{LABEL}` when `top == -1`.

### BroadcastRead line shapes (copy, not flavour text)

```text
takedown            -> "{name} takes it down"
throw               -> "{name} throws"
clinch_engage       -> "clinch"
clinch_break        -> "they break"
position_change     -> "{name} to {LABEL}"
exposure            -> "back exposed"
submission_attempt  -> "{name} looking for the {hold}"
progress >= 80      -> "it's tight"
attempt escape      -> "{name} escapes"
attempt finish      -> METHOD_SUBMISSION (existing finish line)
stall first fire    -> "referee wants work"
stand-up            -> "back to the feet"
```

No line for control-unit accrual. No line for "still in {LABEL}".

---

## REFUSE list

A refusal is a finding.

| Convention | Where it lives | Why it is refused |
|---|---|---|
| Submission minigame (circle / arc / overlap / camera-push) | UFC 4 (2020), UFC 3, Undisputed 3 (2012) | Player-input finish. Wrong question. |
| Submission Resilience / drain bar as a verb | UFC 5 (2023) | Still a finish UI the player operates. Progress pips that *watch* the sim are enough. |
| Grapple Assist triad / Legacy transition compass | UFC 4, UFC 5 | Diagnostic of player agency. We are not driving transitions. |
| Fight Night clinch-as-tie-up HUD | Fight Night Champion (2011) | No seat table. Nothing to steal. |
| Undisputed boxing clinch | Removed in 1.0 (2024) | They killed it. We do not resurrect a dead boxing clinch as a ground read. |
| Running "ground control 2:14" on the live canvas | UFC Stats / ESPN recap language, FightTrax 2014 companion | Duration ≠ our integral. UFC itself keeps this off the program feed. Putting it live would pretend the clock is the score. |
| FightTrax / UFC DNA control timeline | Fox second-screen, 2014 | Companion product. Too busy for a management-sim HUD. |
| IBJJF points/advantages scorebug as default | IBJJF / Flo points cards | Correct for that ruleset only. G37 already owns per-ruleset fold. Do not paint it onto Unified Rules. |
| Osaekomi clock | IJF / Olympics 2020 and 2024 | Clock *is* the win condition in judo. It is not in MMA. |
| NCAA riding-time clock | Folkstyle wrestling | Official scoring device for a different sport. Same trap as osaekomi. |
| Pre-attempt "danger" meter | Various game auras | Invents a threat the engine has not opened. |
| Vendor heatmaps / force meters / live strike-target CGI | HITAI and similar 2025–26 sales decks | Striking chrome. Does not name a seat. |
| Per-second commentary lines | Bad sports-game habit | Makes quiet stretches read as a stuck ticker. |
| Paper-doll ground-pressure map | Undisputed 3 optional fighter HUD, over-applied | Trauma pips already cover damage. Pressure is the seat chip. |
| Yellow-card graphic copied from ONE | ONE ruleset | Fine as a ruleset-specific referee event later. Not part of the ambient read. |
| Showing `control_score` live next to a duration clock | — | Two numbers, one lie. |

---

## Open questions (two, each with a default)

**Q1. Does `submission_attempt` carry a hold name?**
If yes, print it. If no, print `SUB` + seat.
Default: ship the chip with `SUB` + seat. Do not block the read on a new event field. G37 already said advantage does not need a new event; the hold name is a nice-to-have on the existing one.

**Q2. Is the stall amber visible to the player before the referee speaks?**
Default: **yes.** Amber at 300 ticks, red at 400 with the BroadcastRead "referee wants work". The player is the corner. Corners can see a referee getting ready to stand a fight up. Hiding the stall clock until the stand-up makes the stand-up feel like a bug.

Both decided. No further operator question required to type the build task.

---

## What the player is meant to feel in the quiet

A man in half guard working to pass is not a blank screen. It is two people locked, cardio climbing, a seat that has a name, and a referee who will not wait forever. The live read should make that readable in one glance and then get out of the way. When the attempt opens, the pips exist so a finish does not come out of a silent HUD. When nothing opens for ninety seconds, nothing talks. That is the design.

End of G38.
