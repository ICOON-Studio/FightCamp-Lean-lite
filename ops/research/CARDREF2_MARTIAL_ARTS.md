# CARDREF2 - many martial arts in one card game: reference games, real scoring, what we own (S538)

Research only. Owner S537: the card game takes BJJ, wrestling, judo, karate, MMA, sambo (and boxing); "this might give
enough depth and fun and replayability, however i would like to see animations if possible". This page follows
`OWNER_CARDGAME_INTERVIEW_S537.md` and adds to `CARDREF1_REFERENCE_GAMES.md` (not redone here).

**How it was read.** Installed games: read-only, nothing launched, nothing hooked, nothing of theirs copied; every line is
our words and counts; decoded text was deleted afterwards; encrypted packs stayed closed. Scratch scripts are in
`E:\tmp\cardref2` (outside the repo). Sports' rules and other games: public web pages, paraphrased, source per group.
Three marks are used below: **[file]** read from installed files, **[web]** a page that was opened, **[memory]** general
knowledge not re-checked this session (treat as a pointer, not a fact).

**What was there (checked 2026-11-22).** Installed and read: Mixed Martial Cards Demo (deep, the ground game), MMA Arena
(deep on positions; its move table is served online, not local), Kungfu Card (the nine schools), Elite MMA Manager Demo,
Gladiator Command, Dominus Gladiatus, Blood & Canvas Bareknuckle Boxing Demo (light: names and counts only).
**Not installed: Might & Magic Fates TCG.**

---

## 1. Styles that feel different

### What the games do

| Game | How a style is made | Style v style rule | Verdict for us |
|---|---|---|---|
| **Mixed Martial Cards** [file] | No named arts. Style = the deck + a skill level (1 or 2) for striking and one for grappling that gates cards + perks that tilt it (wrestler, ground and pound, submission artist, neck specialist, leg kicker). Only 4 of 124 cards work both standing and on the ground. | None. | Style as "which half of the game you are good at" works; nothing stops everyone building the same deck. |
| **MMA Arena** [file] | Ten tags (basic, boxing, kickboxing, karate, Muay Thai, wrestling, judo, ju-jitsu, MMA, misc), a nine-step belt in each, 290 moves. A move has one art, a target zone and ONE position it needs. Any mix in a 40-card deck. | None in code. Nearest: an opponent "weakness" by target zone makes matching moves cost 2 less stamina. | The arts are labels on one shared rule: same stamina, same health, same win. They look different (290 animated moves) and play the same. |
| **Kungfu Card** [file] | Nine schools, each exactly 8 technique cards + 8 principles (bring 5 + 2). The 52-card deck is shared; a school is a **rules twist** on it: one pays for leg-suit cards, one stacks bonuses on fist-suit cards, one flips between two states and wants you to play to the current one, one is built on defence cards, one on the 9-point cards with a stacking counter. | None. One win condition (health). | The best lesson here: a style is **one own mechanic**, small (16 cards), on a shared core. |
| **Elite MMA Manager** [file] | 11 backgrounds (boxing, kickboxing, karate, Muay Thai, BJJ, wrestling, judo, sambo, street, MMA, other), 32 trait effects; three ground states (standing, top, bottom). | Simulated. | A manager, not a card game. Same list of arts as the owner's. |
| **Gladiator Command / Dominus Gladiatus** [file] | Weapon classes with own attack sets (5 attack clips a class) and class-bound skills; Dominus: 8 classes, 39 powers, 3 opening styles (charge, stalk, measured advance). | Not found. | "Opening style" (how you close the distance) is a cheap third dial. |
| **Yomi** [web + memory] | Hidden simultaneous pick: attack beats throw, throw beats block/dodge, block/dodge beats attack. Characters differ by deck and one ability. | The triangle is inside every turn, not between characters. | The classic way to keep a striker v grappler matchup open: the grappler's throw beats the striker's guard, not the striker. |
| **BattleCON** [web + memory] | A 7-space line; each beat both pair a *style* card with a *base* card and add range, power, priority. Played pairs rest two beats. No dice, no shuffle. | Range decides who can hit at all. | Range as the board, with no sums beyond one addition. |
| **Exceed** [web + memory] | Cards carry range, power, speed, guard, armour; a 9-space line. | Speed decides who lands first. | As BattleCON, with a luck card ("wild swing"). |
| **MMA Combat Card Game** (tabletop) [web] | Three positions: Standing, Clinched, Grounded; a card is playable only in its printed position. Theme decks (brawler, tap-out artist, Muay Thai). The 50-card deck is also the stamina: damage discards from the top. Three rounds of five turns, then victory points. | The position decides which half of your deck is alive. | The simplest multi-art board that exists: 3 states. |
| **WWE Raw Deal** [web] | A meter that rises with the damage you have landed and unlocks bigger moves. | - | "Earn the big throw" without a dice roll. |

**The pattern.** Nobody among the installed games has a style-v-style rule. Where styles do feel different it is because
(a) a style owns **one mechanic of its own** (Kungfu Card), (b) the **position gates the cards** so a style is strong in
one place and weak in another (MMA Arena, Mixed Martial Cards, the tabletop MMA game), and (c) each style has its **own
way to win** (only Mixed Martial Cards: knockout, body knockout, tap, judges). MMA Arena has (b) alone, with one shared
resource and one shared win, and its turn is the one the mixed reviews complain about (CARDREF1).

### The real sports' scoring, in numbers

| Sport (rule set) | How points are made | Early end | Length | Source |
|---|---|---|---|---|
| **BJJ, IBJJF** | takedown 2, sweep 2, knee on belly 2, guard pass 3, mount 4, back 4; a position must be held 3 s; advantages break ties; penalties: 2nd = an advantage to him, 3rd = 2 points, 4th = out | submission | adult 5 / 6 / 7 / 8 / 10 min by belt (white to black) | our `BeltRoad.gd` (IBJJF Rule Book v6.0, read S353); [web] gymdesk.com/blog/jiu-jitsu-point-system |
| **ADCC** | pass 3, mount 2, back with hooks 3, knee on belly 2, takedown/sweep 2 (4 if it lands past the guard); **no points in the first half**; pulling guard in the points half costs 1 | submission | 10 min in one summary; finals longer [memory] | [web] same page; flograppling.com/articles/12784957 (snippet) |
| **Judo, IJF 2025** | ippon = a full throw on the back, a 20 s hold or a submission; waza-ari = a lesser throw or a 10-19 s hold, two make ippon; yuko (back since 2025) = side / buttocks landing or a 5-9 s hold, never adds up to waza-ari | ippon; 3rd shido = out | 4 min, then golden score with no limit (first score wins) | [web] ijf.org/news/show/new-rules-what-to-remember; britishjudo.org.uk (2025 rules) |
| Judo, how often | elite players attack about 6 times a match each; about **10% of attempts score**, about 1 scored throw a match; of scoring throws roughly 40% ippon / 60% waza-ari | | | our `G131_HOW_OFTEN_A_JUDO_THROW_SCORES.md` |
| **Karate, WKF kumite 2024** | yuko 1 = a punch or strike; waza-ari 2 = a kick to the body; ippon 3 = a kick to the head, or any scoring technique on a downed opponent; *senshu* = the first unopposed score wins a tie | an **8-point lead**; down and not up in 10 s | seniors 3 min | [web] WKF Kumite Competition Rules 2024 (PDF read) |
| **Sambo, FIAS** (combat rules 2022; sport per secondary pages) | throws by how HE lands and whether YOU stay standing: standing + he lands on his back = **total victory**; standing: side 4, front/buttocks 2; you fall too: back 4, side 2, else 1. Hold-down: sport 10 s = 2, 20 s = 4; combat 20 s = 2, once. Leg locks legal; chokes only in combat sambo. Combat: knockdown 4, two knockdowns end it | total victory, submission, an **8-point lead** | 5 min | [web] FIAS combat rules (PDF read); usawmembership.com/articles/14485; sambo.sport news 2026 |
| **Wrestling, UWW Jan 2026** | takedown 2, back exposure 2, step-out 1, reversal 1, a lift or big throw 4, a big throw straight to his back 5; freestyle 30 s activity clock: fail to score = 1 to him | a **10-point lead** (freestyle), 8 (Greco), or a fall | 2 x 3 min | [web] cdn.uww.org/2026-01/wrestling_rules.pdf (read) |
| **MMA, Unified Rules** | 10-point must; effective striking and grappling first, aggression only if that is level, cage control last; impact outweighs volume | KO, TKO, submission | 3 x 5 min (5 x 5 title) | [web] abcboxing.com unified rules (snippets) |
| **Boxing** | 10-point must; a knockdown round is usually 10-8 [memory] | KO, TKO | amateur 3 x 3 min; pro 4 to 12 x 3 min | [web] boxrec.com/wiki Unified Rules; ours since week 1 |

**What the scoring says about each art (ours).** Five of the eight rule sets end a bout early on a **points lead**
(karate 8, sambo 8, wrestling 10 / 8) or one **perfect move** (judo ippon, sambo's total victory, a fall, a tap, a KO).
That is the owner's "fast and punchy" already written by the sports: a card bout can end before the bell on a lead, and
each art brings its own "one perfect move". And every art pays most for the thing that is hardest and rarest: the head
kick (3), the throw flat on the back, the back take (4), the 5-point throw.

### Who beats whom, in the real meeting ground

| Fact | Number | Source |
|---|---|---|
| How UFC fights end | about 33% KO/TKO, 20% submission, 47% decision (8,544 fights); heavyweights finish 66%; women's strawweight goes the distance 66% | [web] mma.social/stats/finish-rates; agentmma.com |
| Champions by first art | of 81 UFC champions 53 came from grappling: 35 wrestling (43% of all), 17 BJJ; 5 from boxing (a media tally) | [web] flowrestling.org/articles/6448229 |
| Roster by first art | 52% grappling, 41% striking, 6% mixed, with a later win edge for grapplers (384 athletes) | [web] agentmma.com (cites the study; study not opened) |
| What wins | landing more than 4 significant ground strikes won 80.4% of bouts; with takedown accuracy over 25%, 84.9% | [web] same |
| Our own anchors | UFC lightweights: 15 to 25% of the time on the ground, 2.5 to 3.0 takedown attempts a man per 15 min, 0.5 to 1.0 submission attempts a man a fight | `scripts/rules/GroundRules.gd` header |
| Early UFC | a BJJ man won UFC 1, 2 and 4 by submission; wrestlers took over from UFC 5; strikers rose once they could stop the takedown | [memory] |

**The real triangle (ours, from the above).** The striker beats the grappler **while standing**; the wrestler decides
**where** the bout is; the submission grappler beats the wrestler **from underneath or in the scramble**. Without a rule
that holds it open the wrestler is simply the best base (43% of champions). A card game must not copy that: see the
table in section 6, where every pairing is set inside 40 to 60.

**How a matchup is kept 40 to 60 and not a lock (what the games and sports offer):**
1. **The position gates the cards, and nobody owns the position for free.** Each change of range or position costs a
   card and can be answered (a sprawl, a frame, a stand-up). MMA Arena fails here: a resolved move just changes the
   position, no answer.
2. **The triangle lives inside the turn** (Yomi): a throw beats a block, a strike beats a throw attempt, a block beats
   a strike. A boxer who only blocks gets thrown; a judoka who only reaches gets hit on the way in.
3. **Every style has an answer card in its weak place** (the two-step escape in Mixed Martial Cards: "make room", then
   the escape). A boxer on his back cannot win there, but he can get up in two cards.
4. **The bout resets.** Rounds start standing (the tabletop MMA game); a referee stands a stalled ground phase up (our
   `BjjRef.gd` stalling rule; the ground counter of 8 in Mixed Martial Cards).
5. **Several clocks at once.** Health for the striker, a points lead for the thrower, a tap track for the grappler. The
   slower clock is the safer one; a style that is losing one race can still win another.

---

## 2. Positions as the board

### What the games do

**Mixed Martial Cards [file] - two numbers and who is on top.**
- Two fight states, standing and grappling, each with its own deck. Clinch is a status between them: both get it,
  long-range cards are barred, it ends with the exchange.
- Six takedown cards open the ground (single leg, double leg, a clinch-only throw, two that counter a head punch, and
  one that counters a takedown and lands you underneath with a neck hold already on).
- The board: a **position score 0 to 8**, a **control score -4 to +4** (seen from the top man) and **top / bottom**.
  Cards move position by -3 to +3 (most 0 or -1) and control by -2 to +4 (most -1 or +1).
- Cards have gates: 17 need top, 8 need bottom; position at least 3 / 5 / 7 or at most 2 / 4; control at least 0 / 1 /
  2. So the strong holds need a far-advanced position, and some attacks from underneath only work early.
- Control at -4: everything thrown at you lands, and his control cards chip your grappling resource.
- **A submission is a status, not a roll.** Unblocked, it puts a hold on the victim. While held he cannot play normal
  cards; the holder repeats a squeeze whose stamina price climbs each use and which drains the victim's grappling
  resource (1 to 8 a card, mostly 2). The victim answers in two steps per limb type: a "make room" card that cancels
  this turn's drain, then the escape card it unlocks. A failed attempt costs the attacker control and position
  (typically -2 and -1 to -3). Reading (ours): the grappling resource at 0 while held is the tap; out of stamina in a
  hold also loses.
- A ground exchange carries a turn counter (the fixed number is 8; some cards take 2). Reading (ours): at 0 the
  exchange ends and both stand.

**MMA Arena [file] - eleven named positions, no contest.**
- Standing, plus full guard, half guard, side mount, full mount and back mount, each seen from top or bottom.
- A position changes only as a move's secondary effect that names the destination; the other man gets the mirror. A
  sweep reverses the roles. No score and no contest: if the move resolves, you are there.
- The hand of 3 is filtered by the position you are in; the dealer can guarantee a takedown or a stand-up option.
- Submission and knockout are flags that start a mini-game (five kinds: tap to fill, join the dots, a swinging bar...).
  Evade is the one dice roll (0 to 100 against the move's value).

**Others.** Elite MMA Manager: three states (standing, top, bottom). The tabletop MMA game: three (standing, clinched,
grounded). Cage Match (tabletop): four (standing, clinch, ground, ground past the guard) [web, snippet]. BJJ card games
on sale (Submission, Game of Rolls, King of the Roll) are drill or party decks or dice tables; **no published BJJ card
game with a real position graph was found** [web]. No karate or judo card game was found.

**Our own, already in the repo (see section 5).** `bjj_tree.json`: 49 positions seen from one side with a mirror, 80
moves, 135 arrows; each arrow has where it lands when it works AND when it misses, the points it gives and the answers
that stop it. That is a finished position board, deeper than either installed game's.

### What it means for "fast and punchy"

| Board | States | Sums at the table | Speed | Depth |
|---|---|---|---|---|
| MMA Arena | 11 named | none | fast | shallow: no contest for position |
| Mixed Martial Cards | 2 states x (0-8) x (-4..+4) x top/bottom | two tracks + gates + a climbing price | slow (matches run 20 min+, CARDREF1) | deep |
| Tabletop MMA | 3 | none | fast | medium |
| Ours (proposal, section 6) | **4 ranges + a ground ladder of 4 rungs** | none: the rung is a place on a strip | fast | to be probed |

The lesson: the position must be **one visible marker on one strip**, cards must say where they can be played and where
they send the bout, and a submission should be a **short race the victim can see** (a hold status with a countdown and
a named two-card way out), never a hidden roll. The Mixed Martial Cards chain is the right shape with too many numbers;
ours can be the same shape with one track.

---

## 3. Replayability

| Source of variety | Who does it | Numbers |
|---|---|---|
| A style is a small own pool on a shared core | Kungfu Card [file] | 9 schools x (8 techniques + 8 principles), bring 5 + 2: 56 x 28 = 1,568 loadouts a school before the run starts |
| Free mixing of arts in one deck | MMA Arena [file] | 10 arts, 40 cards, max 3 of one, belts in each art, move levels 1 to 3 |
| Two decks (standing and ground) | Mixed Martial Cards [file]; Caged In (54 + 30) [web] | you build both; the opponent decides which one you get to use |
| Opponents with their own small tables | Kungfu Card [file] | 18 run bosses, 10 regions, 284 events, 150 relics (CARDREF1) |
| Opening style | Dominus Gladiatus [file] | 3 (charge, stalk, measured advance) |
| Rulesets | none of the installed card games | MMA Arena has a "match type" switch that can forbid takedowns: one flag, unused as a mode |
| Played cards rest | BattleCON [memory]; Breachway (CARDREF1) | a pair sits out two beats; no shuffle luck |
| Coach / corner plan | Mixed Martial Cards (CARDREF1) | one strategy of 2 and one action of 3 at each rest |

**Nobody among the reference games uses the rulesets**, and it is the cheapest variety there is: the same deck plays a
different game under boxing rules (no kicks, no ground: the ground cards are dead), karate points (first to an 8-point
lead, light contact: health barely matters), judo (one perfect throw ends it; 20 s of hold), wrestling (points lead of
10, no submissions), BJJ (points for positions, the tap ends it), sambo (throws + leg locks, an 8-point lead) and MMA
(everything is live). Seven rule cards on one engine. A run could be a tour: each stop is another sport's night.

Cross-training fits the owner's list exactly: a fighter starts in one art (its 8 to 10 cards and its own mechanic) and
adds a second art's cards as rewards, becoming a hybrid; MMA is the ruleset where the hybrid pays off. That is the real
career path too (first art, then cross-training), and our old plan already says it (`ARTS_FEED_MMA_S356.md`: three
parts, striking / wrestling / ground; readiness = coverage of the three).

---

## 3b. Action points per limb (the owner's idea)

**Who does it.** Honest answer: **no card game found splits the action points by limb**, installed or public.

| Game | What is split by body part | Action points |
|---|---|---|
| Mixed Martial Cards [file] | tags (punch / kick / knee / elbow; head / body / legs); damage to head health, body health, stamina; leg hits give statuses (injured leg, limp) | one stamina |
| MMA Arena [file] | three target zones | one stamina |
| Elite MMA Manager [file] | **6 body parts** take damage (head, body, each arm, each leg) | simulated |
| Dominus Gladiatus [file] | injuries on 3 parts (head, arm, torso) at 3 severities; limbs can be lost | real time |
| Gladiator Command [file] | a stance resource, an injury manager, armour coverage (values not readable) | real time |
| Toribash [web] | **the one true case**: every joint (about 20) is set each turn to relax / hold / contract / extend; a broken joint cannot change | per joint; slow, a physics toy |
| EA UFC 4 / 5 [web + memory] | damage by region (head, body, legs); one stamina bar | one |
| Fallout VATS, Phoenix Point, Battle Brothers, Kenshi [memory] | damage and injuries by limb (a crippled arm drops the weapon) | shared |
| Tekken [memory] | four buttons = four limbs | real time |
| Gloomhaven [memory] | each turn the top half of one card and the bottom half of another | the nearest "two slots" rule in a card game |

So the idea is **new in cards**: nobody to copy, and nobody to prove it stays fast. What the nearest cases teach:
damage by limb is common and readable (a hurt leg = a status); *control* by limb is rare because it multiplies the
things to count. Toribash is deep and slow. The risk is the owner's own bar: five purses to track instead of one.

**A version that could stay fast (ours, for the probe).** Four limbs + hips, **one pip each a turn** (not a number to
add up: a limb is either free or spent, shown as five lights). A card names the limbs it spends: jab = lead arm;
cross = rear arm + hips; roundhouse = rear leg + hips; double leg = both arms + both legs; a guard pull = hips; a block
= the arm or leg that blocks. Then:
- You can never throw two rear-leg kicks in one turn, and a cross and a roundhouse cannot share a turn (both need the
  hips): the cheap-card door from CARDREF1 section 12A closes by itself, with no price curve.
- **Defence costs offence**: the arm you spent punching cannot block. That is a real decision each turn, visible.
- **Damage takes a light away**: a chopped lead leg has its pip every other turn (or none this round). "A hurt lead leg
  = fewer kicks" is one status, no arithmetic.
- Wind stays as the one pool beside it, or goes: that is what the probe decides.

**What it would give each style.**

| Style | Limbs it lives on | What the limb rule does for it |
|---|---|---|
| Boxing | both arms + hips | two punches a turn, and a third only by saving the hips; never spends legs, so its legs are free to MOVE (a step back out of kicking range costs a leg pip) |
| Karate | both legs + one arm | one kick + one punch a turn; a leg spent on a kick cannot retreat: the blitz in and out is the turn |
| Judo | both arms (grips) + hips + one leg | a throw spends nearly everything, so it is the whole turn: set the grip this turn (arms), throw next turn (hips + leg) |
| Wrestling | everything at once | a shot is all five lights: all in, nothing left to defend if it is stuffed |
| BJJ | hips + legs from underneath, arms on top | the only style whose legs attack on the ground (guard, triangle); its arms stay free to defend |
| Sambo | arms + hips for the throw, then legs for the leg lock | throw and lock on following turns, different limbs each |

It makes the styles differ **without any style-specific rule**: the difference is on the cards' limb icons. That is its
real promise; whether it reads at a glance is the question for the probe (P3 below).

---

## 4. Animation in card games

### What the games show when a card resolves

| Game | What plays | Counts and lengths | What it tells us |
|---|---|---|---|
| **MMA Arena** [file] | full 3D, two fighters | 1,008 clips; the 290 moves hold 708 (mostly 2 a move: reading, the giver and the receiver); **median 2.5 s, typical 2.0 to 4.1 s**, 30 frames a second, about 36 minutes in all; shared set: generic head / body / leg attack and reaction at 2.2 s, position changes at 0.67 s | the expensive road. And 2.5 s a card x 3 rounds is why its bouts feel long |
| **Mixed Martial Cards** [file] | **no move animation at all** | about 95 card illustrations (stills), 42 particle images (blood, sparks, stars), 2 small videos (motion lines, seeing stars), 2,540 voice clips (about 255 fight sounds a character, 7 characters) | a fight card game the owner enjoyed ships on stills + impact effects + **sound** |
| **Kungfu Card** [file] | 2D skeletal effects on the cards and characters | 300 card-effect skeletons, 19 character skeletons, 18 general + 7 battle effects, 608 card pictures, 17 videos (16 are rules clips) | one short effect per card, 2D |
| Gladiator Command [file] | 3D, automatic fights | 115 combat clips incl. paired execute / injure clips per weapon | paired clips exist per weapon, not per move |
| Blood & Canvas [file] | 3D real-time boxing | 129 montages, 180 sequences; each punch in 6 forms (normal, body, power, power body, step, step body); hit reactions split high / low per punch | what full 3D boxing costs: not our road for cards |
| Fights in Tight Spaces [web + memory] | a full-body 3D move per card, about 1 to 2 s; the whole fight replays in real time at the end | not published | the closest to "see the move": short clip per card + a replay |
| Slay the Spire, Monster Train [web + memory] | an idle 2D figure, a short lunge, an effect; well under 1 s; a fast mode | Slay the Spire: 2D skeletal at 30 fps | the genre's default |
| Hearthstone, Marvel Snap [web] | the card itself moves and slams | players click through and ask for an off switch; Marvel Snap added fast-forward in January 2023 because long turns dragged | **long animations get skipped** |

No public figure for clip seconds or production cost of a card game's animation was found. Rule of thumb [memory, not
sourced]: a routine action stays under about 1 second, 2 to 3 seconds is tolerated for the rare big moment, and every
such game ships a speed-up.

**For us.** With "fast and punchy" and a bout under 5 minutes, about 35 to 40 decisions (CARDREF1: 37), a clip on every
card at MMA Arena's 2.5 s would add about 90 s of watching. So: **about 0.6 to 1.0 s a routine card** (a 12 to 16 frame
strip), **2 to 3 s only for the moment that changes the bout** (a takedown lands, a throw scores, a hold goes on, a
knockdown), a speed setting, and an end-of-bout replay as the place where the full-length moves are enjoyed. Sound does
half the work (Mixed Martial Cards: 2,540 voice clips, zero move animation).

**What it costs us to make.** Nothing new to buy for a first pass: the baker exists. `tools/bake_hub_sprites.gd` already
renders a MetaHuman boxer playing a clip into a strip of 16 frames (192 x 256 each, transparent, one floor line): 304
such strips are in `assets/ui/art/hub_sprites`. `tools/grapple_pose_sheet.gd` and `tools/move_pic_bjj.gd` already render
GrappleMap positions and moves on our bodies as stills and pose cards (44 move pictures in `assets/ui/moves`). A card's
animation is one hidden-desktop render per clip per fighter look, GPU time only.

---

## 5. What our repo already has to feed it

### Rules and data (in `scripts/`, all with tests)

| Thing | Where | What it holds |
|---|---|---|
| A BJJ position board | `assets/data/bjj_tree.json`, `scripts/rules/BjjTree.gd` | 49 positions (each with its mirror from the other side), 80 moves, 135 arrows, 8 named routes. Moves by kind: 20 submissions, 12 escapes, 9 base, 8 passes, 8 entries, 7 transitions, 6 sweeps, 5 back takes, 3 takedowns. **Every arrow has: where it lands if it works, where if it misses, its IBJJF points, the answers that stop it, the belt it belongs to, and the film that shows it.** |
| A no-gi match, points and calls | `BjjMatch.gd`, `BjjWalk.gd`, `BjjBeat.gd`, `BjjOpp.gd`, `BjjOpen.gd` | initiative (a failed move hands it over and costs gas), IBJJF points (2 / 2 / 3 / 2 / 4 / 4), 5 to 10 min by belt, submission ends it |
| The referee | `BjjRef.gd` | points, then advantages, then penalties; stalling in neutral or guard (never when holding a pin); the 1st / 2nd / 3rd penalty steps |
| "Why it worked" panel | `BjjClash.gd` | takes the odds apart term by term (long shot under 0.25, favoured over 0.6): the owner's "show me everything" already built once |
| Plan lines | `MatLines.gd` | opening (pull / shoot / snap / wait), escape timing (at once / frame first / sit tight), finish timing (at once / set up), board mood (push / steady / save) |
| The ground fight on paper (MMA) | `GroundRules.gd` | positions, moves, odds by skill gap; anchored on UFC rates (ground time, takedown attempts, submission attempts) |
| Standing wrestling | `WrestleChains.gd`, `TieUpPanel.gd` | 6 tie-ups (collar tie, underhook, wrist control, 2-on-1, Russian tie, front headlock) x 30 answers: **the opponent's reaction picks the right answer** - a ready-made card mini-game |
| Belts and the syllabus | `BeltRoad.gd`, `NoGi.gd`, `StripeCall.gd`, `Grapplers.gd` | white to black, what is owned at each belt, mastery 15 = felt, 30 = owned |
| 2D pieces | `MatGlyph.gd`, `MatMap.gd`, `scripts/grapple/*` (21 files) | a glyph per position (who is on top), the map panel, the player that shows any GrappleMap move on two of our bodies with contact and grips |

### Research notes from the old archive (in `ops/research`)

| Art | File | What is in it |
|---|---|---|
| Karate | `C95_KARATE_TECHNIQUES.md` + `C95_karate_nodes.json` | 168 techniques in 4 tiers (25 / 46 / 61 / 36) on the JKA grading ladder, 8 families (stances, body shifting, punches, strikes, blocks, kicks, throws and locks, combinations) |
| Muay Thai / kickboxing | `Q65_muay_thai_nodes.json` (95), `Q70_kick_targets.json` (126 kicks), `Q67`, `Q79`, `G134`, `J57` | where kicks go, what a leg kick does, the share of leg kicks |
| Judo | `G131` (how often a throw scores), `G136` (grip to throw), `Q72` newaza, `Q76` decisions, `U74_judo_throw_scores.json` (78 throws), `U60_judo_bjj_nodes.json` (187 nodes), `JUDOPROOF1_REPORT.md` | attempts a match, score rate about 10%, ippon / waza-ari split |
| Judo + sambo | `Q78_JUDO_SAMBO_ESCAPES.md` + json | escapes, 6 + 6 nodes |
| Every ruleset | `COMPETITION_RULESET_RESEARCH.md` (karate WKF, UWW freestyle and Greco, IJF, FIAS sport and combat), `K35`, `K36`, `Q90_ground_by_ruleset.json` | which moves are legal where |
| Wrestling | `ANIM_ASSETS_S434/WRESTLING.md`, `DOLA_WRESTLING_*` | where wrestling animation can come from; verdict: GrappleMap is the best source and we have it |
| MMA as the meeting ground | `ARTS_FEED_MMA_S356.md` | striking / wrestling / ground; each art feeds one or two |
| BJJ real numbers | `BJJ_REAL_NUMBERS_S397.md`, `BJJ_REALISM_S397.md` | submission share 30 to 47% by event, and more |

### Clips and animations

Licences per `CLIP_LICENCE_LIST_S392.md` unless said. "On disk, not in the game" = a file exists, nothing is retargeted.

| Art | What | Count | Where | Licence |
|---|---|---|---|---|
| **BJJ, wrestling, judo throws** | **GrappleMap**: two-person positions and moves, 23 joints a body per keyframe | **601 positions, 1,485 moves.** Moves by tag: stand-up 26, single leg 21, double leg 20, arm drag 19, butterfly sweep 19, knee slice 17, throw 15, ankle pick 13, other sweeps 11, kimura 10, trip 9, omoplata 8, **hand throws (te waza) 8, foot throws (ashi waza) 5, sacrifice throws 9 (two tags), hip throw 1**, rear naked choke 5, darce 5, guard pull 5, armbar 4, triangle 4, sprawl 4, guillotine 3, knee bar 2, toehold 1. Positions by tag: standing 124, full guard 52, half guard 51, side control 46, turtle 30, back 27, mount 15, collar tie 22, two-on-one 11, whizzer 11 | `assets/grapplemap/` (in the game, played on our bodies) | **Public domain** (its LICENCE file) |
| BJJ | pose cards and move pictures already rendered | 44 pictures | `assets/ui/moves` | ours |
| BJJ | 8 hand-walked chains (front headlock to back take, back control to choke, single-leg X to heel hook...) | 8 | `scripts/grapple/TheatreChains.gd` | ours on public-domain data |
| Boxing | MoCap Online Punch Pro + Starter | 165 clips (145 + 20) | `assets/anim/baked`, raw packs in `E:\FightCamp\packs\mocaponline_*` | MoCap Online Standard (commercial, clips inside a product; flag 5) |
| Boxing | RamsterZ hand-to-hand: body hook, pull, rear uppercut, slip, bounce, side lean, head / body / **leg** reactions, advance, retreat, strafes | 15 | `assets/anim/baked` | Unity Asset Store EULA |
| Boxing | CMU and Rokoko long takes | 6 + 3 | `assets/anim/baked/owned` | CMU: credit line, no resale as data; Rokoko: commercial OK |
| Boxing | Mixamo crosses and steps (raw) | 11 + 23 | `E:\FightCamp\packs\mixamo_cross`, `mixamo_steps` | Mixamo: royalty free in games |
| Clinch | one two-person clinch (attacker + victim) | 2 | `assets/anim/baked/clinch_*.res` | **flag 4: Cascadeur sample, terms not clear: do not build on it** |
| **Kicks (karate, MMA)** | Mixamo, on disk, not in the game: MMA high / low / medium / roundhouse / side / spinning back kick; front snap kicks lead and rear (advancing, retreating), thrust kicks lead and rear, roundhouse rear foot, spinning back kick advancing; leg sweeps (5); capoeira and jumping kicks (about 30, mostly too showy) | **59 kick files, about 18 usable for karate / MMA** | `C:\Users\user\Downloads` | Mixamo |
| Knees, elbows (MMA) | Mixamo, on disk: Muay Thai knee, boxing knee, flying knee + punch, triple knees to uppercut; cross elbow, elbow to the head, elbow uppercut, jab to elbow | about 5 + 7 | same | Mixamo |
| **Takedown, throw (paired)** | Mixamo, on disk: double leg takedown attacker + victim in two versions (to ground and pound, 218 frames; back to standing, 106 frames); shoulder throw aggressor + victim; grab and slam; being thrown to the side | 4 + 2 + 2 files | same | Mixamo |
| Blocks, dodges | Mixamo, on disk: high / low x left / centre / right blocks, inward and outward blocks, body block, dodges | about 30 | same | Mixamo |
| Hit reactions, falls, get-ups | Mixamo, on disk: light / medium / big head hits by side, rib, kidney, body uppercut reactions, knocked down, getting up | about 120 (many not fight-related) | same | Mixamo |
| Stance | MMA standing idle | 1 | same | Mixamo |
| Figures | 23 MetaHuman characters (19 boxers, 4 staff) | 23 | `assets/models/metahuman` | UE EULA (flag 1) |
| Sound | punches, blocked, miss, body, big, bells, crowd, knockdown fall, footwork | 27 | `assets/audio` | Ludo commercial (flag 2) |

**Gaps, honestly.** (1) **Karate has kicks but no karate punches, stances or blocks** as clips (a reverse punch can be
borrowed from the boxing cross; the look will be a boxer's). (2) **Sambo has nothing of its own**: its throws are the
GrappleMap throws, its leg locks the GrappleMap leg locks (knee bar 2, toehold 1, heel hook through the saddle
positions): thin. (3) **Judo is no-gi here**: GrappleMap's throws are done without a jacket, about 37 in all. (4)
GrappleMap has no timing and no impact (median 4 keyframes a move; a throw "arrives", it does not land): fine for a 12
frame card strip, weak for a 3 s hero clip. (5) Mixamo's FBX files in Downloads are not retargeted to our MetaHuman;
the boxing route (bake to `.res`) is known. (6) Nothing for strikes on the ground (ground and pound) beyond the tail of
one Mixamo takedown.

---

## 6. The six styles in our card game (a proposal for CARDSCOPE4 to probe; nothing here is measured)

**The shared board.** One strip with four ranges: **KICKING - PUNCHING - CLINCH - GROUND**. On the ground a small
ladder of four rungs for the man on top: **guard - half guard - side pin - mount or back**. One marker. Every card says
where it can be played and where it sends the bout. Stepping one range costs a card (or a leg, under the limb rule).
Each round starts at kicking range. A ground phase with no advance for two turns is stood up by the referee.

**Three clocks, all on screen.** *Health* (strikes; 0 = knockout). *Points* (throws, takedowns, positions, clean
strikes under the ruleset of the night; a lead of 8 ends it). *The hold* (a submission or a pin is a status with a
countdown of 2 to 3 turns and a named way out; it running out = the tap or the pin). MMA rules keep all three live;
a single-sport night switches some off (section 3).

| Style | Its cards | Range | Position play | How it wins | Its own mechanic | Its counter (what beats it) |
|---|---|---|---|---|---|---|
| **Boxing** | jab, cross, hooks, uppercut, body shots, slip, parry, clinch-break | owns PUNCHING; nothing at kicking range, nothing on the ground but "get up" | wants the middle: steps in past the kicks, breaks the clinch | knockout or health lead; the body shot drains wind | **combinations**: jab, cross, hook landed in order draws a finisher (CARDREF1 12G); the most cards a turn | leg kicks from outside (it cannot answer at range) and any takedown: on its back it has only the two-card stand-up |
| **Karate** | front kick, roundhouse, side kick, head kick, reverse punch, sweep, the step out | owns KICKING; one punch at punching range; nothing in the clinch or on the ground | in and out: a blitz card moves in, scores, and moves back out in one play | points: punch 1, body kick 2, head kick 3, a lead of 8; *first score* breaks ties; a clean head kick is also a knockdown | **in-and-out**: its attacks return it to kicking range, so the fight keeps happening where it is strongest | a caught kick: a leg spent kicking is a single leg for the wrestler or sambo fighter; pressure that pins it at punching range |
| **Judo** | grip cards, hip throw, shoulder throw, foot sweeps, inner thigh throw, a pin, an armlock from the throw | owns the CLINCH | throw = straight to side pin on top (skips two rungs) | **one perfect throw** = an 8-point swing, or a pin held 2 turns; smaller throws 2 or 4 | **the grip**: a grip card laid this turn makes next turn's throw land clean; he sees the grip and has one turn to break it or strike | strikes on the way in (it must walk through punching range), and a no-grip wrestler's low shot under the clinch |
| **Wrestling** | single leg, double leg, sprawl, snap down, front headlock, mat return, ride, ground strikes (MMA nights) | shoots from PUNCHING range through the clinch to the ground; best takedown defence | lands in half guard on top; holds the top; decides where the bout is | points: takedown 2, exposure 2, big throw 4, lead of 8; in MMA it wins the round on top and with ground strikes | **the tie-up read** (our `WrestleChains`: his visible reaction to a tie-up picks which shot is clean); the sprawl turns his failed takedown into a front headlock | submissions from underneath (it sits in the guard) and the guillotine on a lazy shot; a kicker who makes it shoot from too far |
| **BJJ** | guard pull, sweeps, guard passes, back take, triangle, armbar, kimura, chokes, the two-step escape | owns the GROUND, top and bottom; weak takedowns; thin on the feet | **the only style dangerous from underneath**: being taken down is not a loss of position for it | the hold: a submission status that counts down; position points on the way (pass 3, mount 4, back 4) | **chains**: a submission that is escaped opens the next one (armbar escaped = triangle offered), from our 8 routes | a man who will not go down: a striker with one good sprawl beats it standing; a wrestler who stays out of the guard and stands up |
| **Sambo** | throws that work with or without a grip, knee bar, ankle lock, a casual pin, overhand punch (combat nights) | CLINCH and the first moment on the GROUND | throw, then straight onto a leg: it does not climb the ladder | a perfect throw staying on its feet = total victory; throw points 4 / 2 / 1; a leg lock is the fastest hold in the game (countdown 2) | **throw-to-lock**: the turn after a scored throw its leg lock costs nothing; leg locks are playable from the bottom rung where others have no attack | the ladder itself: it has no pass and no mount, so a BJJ player who survives the first lock out-positions it; strikers who never clinch |
| **MMA** (the meeting ground, not a seventh pool) | any two arts' cards + a few of its own (ground strikes, cage wall, the sprawl-and-brawl stance) | all four | all | all three clocks | **the hybrid**: fewer cards from each art, no art's own mechanic at full strength | a pure specialist who gets the bout into his one place |

### Style against style: the intended edge

Row = you; the cell = **your target win share** in an even bout under MMA rules, with the reason. Everything inside 40
to 60 by design; these are bars for the probe to hit, not results.

| you \ him | Boxing | Karate | Judo | Wrestling | BJJ | Sambo |
|---|---|---|---|---|---|---|
| **Boxing** | - | 50: he wins outside, you win once in | 55: he must walk through your range to grip | 45: he gets under the punches | 55: his takedowns are the weakest | 50: he throws well, but meets your hands first |
| **Karate** | 50 | - | 55: he never gets hold of you | 45: a caught kick is a takedown | 55: you stay away from the ground | 45: he catches kicks and has punches too |
| **Judo** | 45 | 45 | - | 50: his low shot v your grips | 50: you throw him, then you are in his guard | 50: mirror on the feet, he has legs, you have pins |
| **Wrestling** | 55 | 55 | 50 | - | 45: you take him exactly where he wants to be | 50: your shots v his leg locks when you land |
| **BJJ** | 45 | 45 | 50 | 55 | - | 50: his fast lock v your ladder |
| **Sambo** | 50 | 55 | 50 | 50 | 50 | - |

Each style averages 48 to 51 across the other five (judo lowest at 48, BJJ 49, karate 50, boxing, wrestling and sambo
51); the largest edge is 55 / 45. The triangle is visible: boxing and karate beat the mat arts that cannot reach them
(judo, BJJ), wrestling beats the strikers, BJJ beats the wrestler, and sambo sits in the middle as the all-rounder with
one mild edge (over karate). Under a single sport's rules the
home art should be favoured about 65 / 35 (a boxer on boxing night): that is what makes a tour of rulesets a run.

### What we can animate now from what we own

1. **Every BJJ card** (about 60: sweeps, passes, back takes, 20 submissions, escapes): GrappleMap move on our two
   bodies, baked to a 12 to 16 frame strip with the existing player + sprite baker. Public domain. Ready today.
2. **Every wrestling card** (single leg 21 takes, double leg 20, ankle pick 13, arm drag 19, sprawl 4, snap downs and
   front headlocks, stand-ups 26): GrappleMap, same route. Ready today.
3. **Judo throws without the jacket** (about 37: hand, foot, hip, sacrifice throws, trips 9): GrappleMap, same route.
   Plus Mixamo's paired shoulder throw as the one "hero" throw with a real landing.
4. **Sambo**: throws as judo; leg locks from GrappleMap (knee bar, toehold, the saddle and fifty-fifty positions): few
   takes, enough for 3 or 4 cards.
5. **Every boxing card**: 165 bought clips + 15 hand-to-hand clips already baked on our figures; 304 sprite strips
   already exist for the gym menu, so the route is proven.
6. **Karate and MMA kicks**: about 18 Mixamo kicks on disk (high, low, medium, roundhouse, side, spinning back, front
   snap lead and rear, thrust lead and rear, sweeps): need one retarget pass (the boxing bake route), then strips.
7. **MMA knees and elbows**: about 12 Mixamo clips on disk, same pass.
8. **The takedown as a hero clip**: Mixamo's paired double leg (attacker + victim, 106 frames to standing, 218 to
   ground and pound) for the 2 to 3 s "the bout changes" moment.
9. **Blocks, dodges, hit reactions, knockdowns, get-ups**: about 30 + 40 usable Mixamo clips on disk, plus our own
   head / body / leg reactions already baked.
10. **Position pictures**: any of the 601 GrappleMap positions as a still on our bodies (`grapple_pose_sheet.gd`), for
    the position strip itself; 44 move pictures and the position glyphs exist.

Not now: karate punches, stances and blocks in a karate look; ground strikes; a jacketed judo throw; anything from the
Cascadeur clinch (flag 4). Those are a Ludo ask or a small Mixamo download, after the rules are right - "never a blocker
for the rules" (the owner).

---

## 7. Probes for CARDSCOPE4 (none run)

Each is one rule a greybox can switch on, with the bar it should hit. By the project rule each lever is probed before
two fresh critics see it.

1. **P1 - the four-range strip.** Two decks (a striker, a grappler), the strip of section 6, range changes cost one
   card and can be answered. Bars: the bout visits at least 3 ranges in 80% of bouts; neither deck above 60%; under 5
   minutes at about 35 decisions.
2. **P2 - three clocks against one.** The same decks with (a) health only, (b) health + a points lead of 8, (c) health
   + points + the hold. Bars: with (c) at least three ways to win each take 15%+ of bouts; a bout ends early in 40 to
   70%; no clock is ignored by the best pilot.
3. **P3 - limb lights against the wind pool** (the owner's idea). Same cards, three arms: one wind pool; five limb
   lights alone; lights + wind. Measure decisions a turn, seconds a turn for a bot with a reading budget, the share of
   turns where the best play is not "spend everything", and whether the thin deck of cheap cards (CARDREF1 C8) still
   wins. Keep the limbs only if they measure better than the pool on depth AND no worse on time.
4. **P4 - the six-by-six table.** All 30 pairings, mirrored, with a competent pilot on each side. Bar: every cell
   inside 40 to 60 and each style's average inside 47 to 53; report the worst cell and the rule that causes it.
5. **P5 - the hold as a visible race.** A submission or pin is a status with a countdown (2 or 3) and a two-card way
   out, against a hidden roll with the same average. Bars: the victim's right answer is knowable from the table 100%
   of the time; a hold ends the bout in 15 to 30% of bouts that reach the ground; no "always tap" or "never tap" line.
6. **P6 - the own mechanic test.** Each style with and without its one mechanic (combination, in-and-out, the grip,
   the tie-up read, chains, throw-to-lock). Bar: removing it changes the best pilot's line in over half of the turns
   (else the mechanic is decoration), and a blind judge can name the style from a log of 10 turns.
7. **P7 - rulesets as replay.** One hybrid deck through seven nights (boxing, karate, judo, wrestling, BJJ, sambo,
   MMA). Bars: the best 10-card line differs in at least 5 of 7 nights; the home art is favoured 60 to 70%, never a
   lock; no night is unwinnable for a visiting art.
8. **P8 - cross-training.** A run where a pure style adds a second art's cards as rewards. Bars: at least three
   different second arts are the best pick somewhere across the six starters; the pure specialist still wins 40%+
   against the hybrid at the end (no forced hybrid).
9. **P9 - the animation budget.** Timed, not rendered: a strip of 0.8 s on every card and 2.5 s on the 3 to 5 big
   moments, against no animation. Bar: the bout stays under 5 minutes with it; then render ONE card of each art
   through the existing baker (a jab, a roundhouse, a double leg, a triangle, a hip throw, a knee bar) and show the
   owner the six strips before any batch.
10. **P10 - a pilot for every deck.** The owner's later asks (opponents' styles; other players' saved decks played by
    the computer) both need one AI that plays any of the six styles to within 5 points of the best scripted pilot.
    Measure it on the P4 table before anything is built on it.

---

## 8. Honest limits

- Files, not play: nobody here played a turn of any game. Counts are of definitions and assets.
- **Not read:** MMA Arena's move table (online), so no moves per art, no positions per art, no damage; Mixed Martial
  Cards' default grappling resource, the start values after a takedown, the squeeze's price curve and what the ground
  counter does at 0; Kungfu Card's per-card numbers; Gladiator Command, Dominus Gladiatus and Elite MMA Manager beyond
  names and lists; Blood & Canvas beyond asset names. Might & Magic Fates TCG is not installed.
- **Our readings, marked as such:** tap = grappling resource at 0 while held; the ground counter ends the exchange;
  two clips a move in MMA Arena = giver and receiver.
- **Web limits:** the IBJJF numbers on the web came from a secondary page (they match our own `BeltRoad.gd`, read from
  the rule book in S353); the current sport sambo rule book could not be opened (FIAS links dead), so sport sambo's
  hold times and its points lead come from secondary pages and the 2022 combat rules; ADCC lengths not confirmed; the
  UFC style numbers are media tallies and one site's summary of three studies not opened. Everything marked [memory]
  was not re-checked. No public figure on animation length or cost in card games was found; the "under 1 second" rule
  is a rule of thumb.
- The Mixamo files counted in Downloads were counted by file name; none was opened or retargeted this session.
- Sections 6 and 7 are a proposal and a list of probes. No share in the style table has been measured.
