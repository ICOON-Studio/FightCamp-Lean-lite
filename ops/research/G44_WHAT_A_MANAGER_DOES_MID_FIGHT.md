# G44 — WHAT DOES A FIGHT MANAGER ACTUALLY DO WHILE THE FIGHT IS ON?

Grok, Expert, 2026-09-10. Driven in the in-app browser by Claude; 124 sources.
Research only — no code, no tick loop, no state machine. Spliced verbatim by
Claude, who wrote this header and the HANDOFF block and changed nothing else.

Commissioned because R97 wired the real-time engine's beat into the game and
U35 surveyed what `RingStagePanel` lets a player DO to a live fight. The answer
was two verbs, both built for a simulation that advanced in 14-second lumps. The
20 Hz engine has no lumps, so the question underneath the port had never been
asked: what should a manager be doing during a live fight at all?

**The call, in one line: build ASK FOR THE STOPPAGE first.** It is the only
mid-round verb a real chief second is allowed to use that changes the result, it
reads facts the engine already emits, it costs the fight, and it does not
rewrite the seed.

---

## §1 — The shipped record

What the player's hands do during a live event, not the vibe around it.

**Title Bout Championship Boxing.** Hands work between rounds only. Before a
round the player enters the corner and assigns trainer/cutman tasks: strategy,
style, motivation, reduce swelling, close cuts. Ratings of the assigned men
drive a single roll per injury type at the end of the rest. There is no mid-round
input. Cost is opportunity cost of the assignment and the quality of the men you
hired; a free click is not on offer because you pick one job-set per rest, not a
spamable toggle. The designer's own note is that a third "gopher" exists in real
corners and is ignored. — Forums.ootpdevelopments

**World Championship Boxing Manager 2 (Astragon / Mega Cat).** Hands pick a
tactic at the round boundary: Neutral / Aggressive / Defensive / Assume Risks /
Timing (sources disagree on whether the live build is four or five labels; the
verbs are the same family). The round then plays as a short watchable clip with
no further input. Between rounds the player also applies a medical treatment;
some treatments are once-per-fight. A later patch added a knockdown minigame:
mash a button to keep the man up and restore a sliver of health. Cadence: one
choice per rest, then spectate. Cost of the tactic: stamina and exposure, paid by
the fighter, not the player. Cost of the mash: none, and it is a QTE bolted onto
a management game after players complained the watch-window was empty. Reviewers
asked for a skip. — Generacionxbox

**Boxing Manager** (the long-running sim on theboxingmanagergame.com, not the
Astragon title). Hands set one corner instruction before the bell; it can be
changed as often as the player likes until the round starts; last selected is
what goes. Change again at the next rest. Later builds added fight shouts during
the bout and a towel offer timed to the same damage threshold the AI corner would
use. Cost of the instruction: implicit energy/output tradeoffs documented by the
player base (jab-and-move spends differently than plant-your-feet). Cost of the
towel: the fight. The towel is offered, not free-fired. —
Community.theboxingmanagergame

**MMA Manager 2 / Official MMA Manager.** Hands set a gameplan before the cage
door closes (approach, transition, distance, defend-focus, attack mix). Once a
round begins, "managers can only sit back and watch." No mid-round verb. Cost of
the plan is paid in camp and in the matchup, not during. — Mmamanager.fandom

**MMA Manager** (theboxingmanagergame.com sister product, 26.1.0). Hands set a
fight plan and emphasis pre-fight; mid-fight shouts; between-round corner tactics
whose effects decay 50% per round (Keep doing what you're doing / Let your hands
go / Stay defensive / Take him down / Work the body / Go for the finish /
Conserve energy / Change game plan). **This is the closest shipped cousin to the
problem we actually have**: a live sim plus a small shout vocabulary plus a
rest-window rewrite. Cost of a shout is not published as a resource; the
between-round tactics cost future rounds via the decay, which is a real cost. —
Community.theboxingmanagergame

**The MMA Manager Game (mobile, 2025–26).** Broadcast fight screen is
watch-first. Subscriber corner pack unlocks focus areas, in-fight shouts, and the
two named calls "go for the finish" / "conserve energy." Free players watch. Cost
of the verbs is gated behind subscription, which is an economy cost, not a fight
cost. — Apps.apple

**Punch Club (and Punch Club 2).** Not a manager, but the fight layer is this
question. Hands fill a limited skill loadout before the round. The round
auto-resolves from that loadout; moves are drawn from the selected set. Between
rounds the player re-slots skills after seeing the opponent's current set (PC2
opponents change loadout each round). No mid-round input. The studio's stated
reason for denying control during the round: they wanted the player to watch.
Speed-up exists because the watch-window bores on repeat. Cost of a loadout:
stamina and slot opportunity. A free mid-round click does not exist. — Wikipedia

**Iron Fist Boxing (2008 App Store title).** Fighter-control game, not a manager.
The player's hands are the fighter. Out of scope as an analogue, useful only as a
warning: this is what "give the manager something to do during the round" becomes
if you are sloppy.

**Football Manager — touchline.** Hands issue a shout (Encourage, Calm Down,
Focus, Fire Up, No Pressure, Demand More, Praise, Berate, and variants across
editions). Cadence: roughly every 10–15 in-game minutes; a cooldown locks the
next shout. Effect is morale / body language for ~10 minutes, not a tactical
rewrite. SI themselves said the system "didn't work the way consumers thought it
worked" and cut it from FM25; it returned later because players missed the
feeling of having a hand on the game. **Instant Result exists as the honest "I do
not want to watch this" button.** Cost of a shout: the cooldown, and the risk of
the wrong valence (Berate a brittle personality and you make it worse). A mashed
shout is a wasted cooldown. Cost of Instant Result: you forfeit the spectacle and
any mid-match adjustment. — Operationsports

**Motorsport Manager — pit wall. Strongest analogue.** The sim runs in real time.
Hands change tyre mode (Attack / Push / Neutral / Conserve / Back Up),
engine/fuel mode (Super Overtake through Low), and call a pit (tyres, fuel load,
repairs). Instructions apply from the moment they are issued, or at the next pit
boundary for hardware. Cadence is continuous; the player is expected to watch
telemetry and nudge. Cost is physical and visible: Attack multiplies tyre wear
(~1.4×); Overtake burns ~1.3–1.4 laps of fuel per lap and heats the engine; a
mistimed pit costs track position in seconds. There is no "free shout." A player
who mashes Attack pays in rubber. **This is why the analogue holds: every
mid-event verb spends a resource the sim already tracks.** — Qnnit

**Out of the Park Baseball.** Hands act at natural baseball boundaries: mound
visit, pitching change, pinch hit/run, defensive alignment, steal/bunt/
pitch-around. MLB-shaped costs are baked in: five (now four, by current MLB
glossary) non-change mound visits per nine; a second visit to the same pitcher in
an inning removes him; visits are 30 seconds. The game also lets the player skip
ahead "until RISP" so the watch-window is only the parts that can be acted on.
Cost of a visit: the budget of visits, and possibly the pitcher. A free mid-pitch
click does not exist. — MLB

**Wrestling Empire / TEW.** Two different answers. Wrestling Empire's booking
mode lets you "call it in the ring"; mid-match the player is often the wrestler,
not a corner. TEW is the manager analogue: the show is booked in advance;
mid-show the player may reopen the booking sheet and change anything not yet
performed (injury replacements, recasts) with no published penalty. Completed
segments are locked. Hands do not steer a match while it is happening; they
rebook the rest of the card around what just happened. Cost of mid-show rewrite:
none published. That is a booking game, not a fight-management game. —
Hansmellman.github

**Blood Bowl.** Hands spend team re-rolls during their own turn. One re-roll per
turn in older editions; later FAQ text is looser but "never re-roll a re-roll"
holds. Re-rolls refresh at half-time; unused ones do not bank. Kick-off events
can grant or deny extras. Cost is a scarce token you bought with team value. A
mashed re-roll is a spent token and you must keep the second result. **This is
the cleanest "verb with a price" in tabletop.** — Cdn.1j1ju

**Battle Brothers.** Combat is turn-based and paused by construction. The player
issues every action. Overworld is real-time-with-pause; combat is not a
watch-window. Useless as a mid-spectacle analogue except for this: **when a game
wants the player to decide, it stops time. When it wants a spectacle, it does not
hand the player the units.**

**Auto-battlers (TFT, Dota Auto Chess, Underlords).** Hands act only in the prep
window: buy, sell, position, itemize. Combat runs with no input. The next prep is
the cost window. The genre exists because watching a fight you already committed
to is the product. Players who need to click during combat are playing the wrong
genre. — Wikipedia

**Where the player only watches, and whether that shipped.** MMA Manager 2
shipped watch-only rounds and is a live service, so it shipped. WCBM2 shipped
watch-only rounds and immediately grew a mash-to-stand minigame and a chorus of
"please let me skip." Punch Club shipped watch-only rounds and added ×4 speed.
Football Manager shipped Instant Result because a full match is long and many
matches do not need hands. Title Bout shipped watch-only rounds for thirty years
to an audience that wanted the record, not the agency. **Pattern: watch-only is
stable when the audience came for the card and the stable, and unstable when the
audience came to do something with their hands every minute.**

---

## §2 — The real sport

Research, not invention.

**Who is allowed where.** Typical commission pattern: three seconds at ringside
in a non-title; four or five in a title. During the round they stay in the
corner. During the 60-second rest, one licensee in the ring, two on the apron.
They leave the enclosure on the timekeeper's whistle and must have stools and
buckets off the canvas before the bell. Leaving the corner to coach during a
round can draw a warning, a point, a forfeited round, or a forfeited bout,
depending on the commission. **A manager who is not the licensed chief second has
no official voice.** Relatives are barred from title corners in some
sanctioning-body rules unless exempted. If our game lets "the manager" do things
only a licensed chief second or cutman may do, we are choosing fiction and should
label it. — Law.cornell

**The 60-second window, in order.** Warwick's *Focus on Coach Talk* unpacks the
rest as a fixed sequence of functions, not a free-form chat: greet / settle the
boxer; health check and breathing; build confidence; name the work-ons; re-focus
for the walk-out. Jim McDonnell, speaking as a working trainer: the first ~30
seconds the man is only getting his heart rate down; technical information before
that is wasted; a fighter remembers the last thing you said; one voice only; one
or two instructions, not twenty. **Halperin, Chapman, Martin, Abbiss & Wulf
(2016), 445 statements across 25 amateur bouts:** coaches delivered on average
**eight feedback statements per rest**; more controlling than autonomy-supportive
(53% vs 6%); more internal than external focus (15% vs 6%); more positive than
negative (29% vs 12%); and **winning corners were more positive and less
controlling than losing ones.** Information and instruction are mixed in the same
minute; the physical work (water, ice, swab, enswell, petroleum jelly) runs in
parallel with the talk, usually in the first half of the minute, so the talk that
lands is the talk delivered after the man can hear. — Gwulf.faculty.unlv

**During the round.** Corners shout. Commissions often forbid "excessive
coaching" and require seconds to remain seated; the shout still happens. **What
fighters report reaching them under fire is not a sourced, measured corpus.**
Working-corner accounts (Sherdog "Guide to Being a Cornerman," long-form Athletic
interviews) say: short verbs already trained in camp — "hands," "body," "move
right," "don't chase." Long sentences do not arrive. A DAZN corner clip from a
2026 Itauma rest is the between-round version of the same grammar: body, posture,
don't get greedy, two breaths. **Mark the in-round comprehension rate
UNSOURCED.** We should not build a system that assumes a mid-round paragraph is
heard. — YouTube

**The cutman.** This is the only corner job with a physical mid-fight outcome and
a written toolkit. Work happens in the rest, not while punches are being thrown.
Tools and rules, as published:

- **Enswell (eye iron):** chilled metal, firm pressure, swelling around the eye.
  Vision is the stake.
- **Ice / ice bags:** same job, cheaper, moulds to the face. Some amateur lists
  now prefer bags to irons.
- **Petroleum jelly:** prevention and smear-over after a cut is packed. Too much
  on gloves becomes a weapon against your own man's eyes.
- **Epinephrine / adrenaline chloride 1:1000, topical:** constricts vessels. Most
  common chemical.
- **Avitene (microfibrillar collagen)** and cousins (Thrombin, Surgicel,
  Gelfoam): powder onto a dry wound, then pressure. Avitene is the "this cut
  should have ended the fight and didn't" tool.
- **Gauze, cotton swabs, clean towels, water.**
- **Banned or restricted on many lists:** Monsel's, iron chloride, smelling
  salts, alcohol mixes, needles on the field of play.

Sequence inside the minute, from working cutmen: clean and pressure first;
chemical on the swab under the enswell; if it is a re-bleed or a wide cut,
Avitene at ~20–30 seconds; everything off at the whistle; jelly on as they stand.
Commissions limit substances to an approved list and give the referee power to
inspect and confiscate. **A cut that reopens every round is a cut the cutman is
losing. That is a modelable contest against a pip count we already emit.** —
Wikipedia

**Throwing in the towel / asking for the stoppage.** Real, consequential, often
late. History: sponge or towel as a visible surrender, 19th century onward;
Liston's stool in '64 is the other shape — refuse to come out, recorded as RTD.
Modern commissions split on the gesture. Some still honour a towel on the canvas
as a TKO. Many — California is the clear write-up — do not: **only the named
chief second may stop it, and he does it by telling the inspector, who tells the
referee.** Illinois text: "No manager or second shall bring about the termination
of a contest by tossing in a towel… The chief second may mount the apron…
indicating the retirement." Edmonton ABC championship rules: signal by mounting
the apron, do not throw objects. Unified Rules of MMA, per ABC president Dunn
(Athletic, 2020): a corner may stop it; the towel-as-object is the confused part,
not the authority. UFC culture treats towel-throws as rare to the point of taboo;
coaches at that level often defer to the referee. Cost in the real world: the
loss on the record, the fighter's purse and ranking, the corner's reputation for
pulling a man who wanted to continue, or — the other failure — the corner's
reputation for leaving a man in too long. Corners describe the decision as
body-language plus private knowledge (a camp injury the commission does not see).
**That is the verb. It is available on any tick. It ends the seed.** — NYTimes

**What a real corner legally cannot do, that a game might be tempted to allow.**
Enter the ring during a round. Handle a downed man before medical staff say so.
Coach from anywhere but the corner. Use unlisted chemicals. Stop the fight if
they are not the chief second. Change what just happened. **We should know which
of those we are breaking.**

---

## §3 — The cadence problem

Four shipped patterns for a decision during a running sim:

1. **Modal pause.** The sim stops and waits. WCBM2's knockdown mash. Our old
   "combo incoming, react?" prompt. OOTP when you are in the dugout and the
   engine is waiting on a substitution. Feels like a QTE or a board-game
   interrupt, not like managing. The old FightCamp prompt was built for
   14-second lumps. **A 20 Hz engine has no lumps.** A modal every N seconds will
   destroy the spectacle; a modal that almost never comes will feel like a
   forgotten tutorial.
2. **Run-on while a menu is open.** Motorsport Manager. FM tactics screen during
   a match in many editions. The world does not wait for your click. This feels
   like managing if — and only if — the verb has a cost that continues to accrue
   while you dither (tyres wearing, fuel burning, a man taking shots). If the
   menu is a pause in all but name, it is pattern 1 wearing a skin.
3. **Queue until the next natural boundary.** FM shouts apply at the next
   stoppage. Boxing Manager instructions lock at the bell. MMA Manager 26.1.0
   corner tactics apply at the rest and decay thereafter. Title Bout corner work
   applies in the minute. **This is the pattern that matches the sport.** A
   mid-round shout that "takes at the next clinch / next break / next rest" is
   honest. A mid-round shout that rewrites the punch that already landed is not.
4. **Only ever between rounds.** Title Bout, Punch Club, MMA Manager 2, classic
   WCBM2. Feels like managing. Ships. The complaint, when there is one, is "I had
   nothing to do with my hands for three minutes," which is a production
   complaint, not a simulation complaint. Speed controls and Instant Result exist
   to answer it without inventing verbs.

**Which feels like managing: 3 and 4, and 2 when the cost is live. Which feels
like a QTE: 1, and any free verb on a short cooldown.**

**How often may a management game interrupt a spectacle before the spectacle
stops being one? No published, measured figure was found.** FM's ~10-minute shout
cooldown is a design choice, not a finding. SI's own post-mortem on shouts is
that players misunderstood the effect, not that a frequency was validated. **Mark
this UNSOURCED.** Do not build a policy on "every thirty seconds" or "once a
round" folklore. What *is* sourced: real corners get one structured minute per
three minutes of fighting, plus whatever fragment of a shout survives crowd
noise; baseball managers get a hard visit budget; Blood Bowl coaches get a hard
re-roll budget; Motorsport Manager players may click every second and pay in
rubber every second. **The pattern that survives contact with players is scarce
verbs at sport-shaped boundaries, not a click rhythm.**

Our engine will present gathered beats, not 20,400 ticks. That is a presentation
decision, already implied by G42. **The intervention surface should attach to
those beats the way a shout attaches to a stoppage, not to the tick clock.**

---

## §4 — The shortlist

Ranked. Prefer verbs that read facts we already emit. Honest under the G42 rule:
the player may be shown an exchange, never a different exchange.

**1. Ask for the stoppage.**
*Does:* one confirmation. Chief-second action.
*When:* any time after the engine has emitted a condition we already have —
accumulated region damage, a cut/swelling pip count past a threshold, a
knockdown, a shock flag, a failed to-answer posture — or, if we are being more
honest than the commissions, whenever the player wants, with the ref free to
ignore a clean fighter.
*Engine must expose:* the same facts it already emits per impact, plus a live
"able to defend" read the ref already uses.
*Cost:* the fight, the method of loss (RTD / corner TKO), the relationship, the
public record. **Not free.**
*Honest:* yes. It ends future ticks. It does not rewrite past ones.

**2. Cutman work in the rest.**
*Does:* pick the job for the minute — pressure the swelling, pack the cut, ignore
the face and talk, or split the minute. Quality comes from who we hired, not from
a minigame.
*When:* only between rounds, and only if a cut or swelling pip exists.
*Engine must expose:* cut/swelling pip count and region, which it already does.
*Cost:* the minute is the cost. Packing a cut means you did not use those seconds
to talk. A bad cutman fails the roll and the pip remains. Not free.
*Honest:* yes. It acts on a state the last round produced.

**3. One instruction at the rest.**
*Does:* pick one verb from a short list that already exists in shipped boxing
managers — work the body, hold the centre, stop chasing the head, take him down,
get up, conserve, go for the finish. **One.**
*When:* only between rounds.
*Engine must expose:* nothing new if the fight plan already has those axes; the
rest-window writes a modifier onto the next round's existing plan.
*Cost:* you spend the only instruction the man will remember (McDonnell;
Halperin's eight statements collapse to one or two that survive). A second
instruction is a lie. Wrong valence on a losing, hurt fighter is a real cost.
*Honest:* yes, if it changes how the next round is fought, not how the last
exchange is rescored.

**4. Refuse to come out.**
*Does:* the Liston form of (1). Sit.
*When:* only at the rest, after the engine has closed a round.
*Engine must expose:* round-close, cards-so-far, medical picture.
*Cost:* identical to (1), with a different code on the record.
*Honest:* yes.

**5. A mid-round shout, queued to the next natural break in action.**
*Does:* one short verb, from the same list as (3), that takes at the next
clinch-break, knockdown, or referee pause — not on the punch now in the air.
*When:* during the round, once, until it is consumed or the rest arrives.
*Engine must expose:* a "natural break" flag it can already see (clinch, down,
ref pause).
*Cost:* if free, players will fire it every round on reflex. Charge it: the man
only hears it if he is not currently absorbing a committed exchange (UNSOURCED as
a sport fact; still the right design cost), and a heard shout that contradicts
the fight plan taxes composure or gas. **Without a cost, cut this verb.**
*Honest:* only if queued. Instant-rewrite is out.

**6. Throw the towel as a visible object.**
*Does:* the gesture version of (1).
*When:* during the round.
*Engine must expose:* same as (1).
*Cost:* same as (1), plus whatever the commission fiction we pick does with
objects in the ring.
*Honest:* yes as an end. **We should pick one stoppage verb, not two.** Prefer
(1) with an inspector, because that is the modern commission text.

**7. Work the swelling / keep the eye open, as a rest assignment rather than a
minigame.**
*Does:* subset of (2), called out because our engine already counts swelling pips
and vision is the one cutman outcome that changes the next round's contact
quality.
*When:* rest only, if swelling exists.
*Engine must expose:* swelling pips by region.
*Cost:* the assignment.
*Honest:* yes.

**8. Instant Result / skip to next rest / skip to finish.**
*Does:* stop watching.
*When:* any time.
*Engine must expose:* nothing; it already has a seed.
*Cost:* the spectacle, and any verb you did not use.
*Honest:* yes. FM shipped this because management games produce more events than
players will watch. **We will need it.** It is not a fight verb. It is how we
admit the player is a manager, not an audience member on a timer.

**9. Speed control.**
*Does:* watch faster or slower.
*When:* any time.
*Engine must expose:* nothing if G42's playback window holds.
*Cost:* none, and that is acceptable, because it does not change the card.
*Honest:* yes, inside the G42 invisibility band.

**Not ranked, and not recommended as first builds:** motivation speeches with no
state target; "combo incoming, react?"; ability bars; anything that spends a
resource we do not already simulate.

---

## §5 — The refusals

**Do not turn the manager into the fighter.** A control scheme, a timing window
on an incoming combination, a mash-to-stand, a parry prompt. WCBM2 already proved
the gravity of this trap: the empty watch-window grew a QTE. Punch Club's
designers refused it on purpose. The moment the player's hands are the fighter's
hands, we are no longer a management game and the seed is a dance pad.

**Do not build a mid-fight ability bar.** Cooldowns dressed as agency. That is an
action game HUD glued to a sim. Motorsport Manager gets away with continuous
verbs because tyres and fuel are real, ticking costs. An ability bar whose cost
is "the bar is empty" is a free verb with a timer.

**Do not touch the seeded card.** No verb may change an exchange that has already
been resolved. No "undo that hook." No mid-round plan that is implemented by
rewriting the last two seconds. G42's rule stands: the player may be shown an
exchange, never a different exchange. **If a shout takes, it takes on ticks that
have not happened.**

**Do not ship a verb that exists only to give the player something to click.**
That is the empty watch-window talking. Title Bout's audience sat on their hands
for three minutes and kept buying the game. Ours will too, if the card is good. A
click that does not spend a scarce thing and does not read a fact we already have
is content-shaped fidgeting.

**Do not let mid-round coaching be a paragraph.** Eight statements in a rest, one
or two remembered, and in-round comprehension UNSOURCED. A UI that offers a
policy document during a round is lying about the sport.

**Do not give the manager powers a commission would fine.** Entering the ring
during a round. Treating a downed man. Stopping the fight as a random second.
Unlisted chemicals. **If we break a rule, name the break.**

**Do not pause the 20 Hz engine for a modal unless the sport itself has stopped.**
Knockdowns, referee pauses, and the rest are legal stops. "Combo incoming" is not.

**Do not hide Instant Result because we are proud of the sim.** FM didn't.

---

## §6 — The one-sentence call

**Build *ask for the stoppage* first:** it is the only mid-round verb a real
chief second is allowed to use that changes the result, it reads damage and cut
and knockdown facts the engine already emits, it costs the fight, and it does not
rewrite the seed.

The rest-window already has a home; the cutman is the second build and lives
there. The mid-round shout is a third build and only earns its place if it is
queued to a break and is not free. The stoppage is the one thing we can put on
the live screen without turning the manager into the fighter, without adding a
resource we do not simulate, and without pretending a man under fire can hear a
paragraph. It will be used rarely and too late, which is how it is used in the
sport, and **a verb that is scarce because the cost is unbearable is the opposite
of a button players mash.**
