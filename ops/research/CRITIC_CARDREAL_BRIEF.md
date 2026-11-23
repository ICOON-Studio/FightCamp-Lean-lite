# Critic brief: the card game's new position model, checked against a real fight (CARDREAL, S544) - you are a FRESH critic

You have not seen this game. It is a turn-based card game of a bout between two different martial arts; the first
pairing is a BOXER against a BRAZILIAN JIU-JITSU fighter, under unified MMA rules. A turn: one fighter lays a volley of
cards and steps face up; on the other fighter's turn it resolves in order, and he may answer ONE thing of it.

**Why you are asked.** The owner, who has watched fights for 40 years, played the prototype and said: "this is has not
been given enough thought , how the boxer jabs when he is in the ground , its like very quickly drafted without any
attention to how a a real fight is done." The cause: the prototype had ONE shared position for both fighters, so when
the man on top stood up out of the guard, the man on his back was on his feet in the same instant and was hit with a
jab and a cross. We researched real bouts and rule sets, audited every card, and wrote a new model on paper in which
each fighter has an OWN position and getting up is a move that costs a turn and can be punished. Nothing is built yet.
You judge the PAPER MODEL below. Be blunt; a kind score is useless.

## What to do
1. THE WALKED BOUT (PART 4). Read it turn by turn as a referee or a coach would. List every turn where you would ask
   "how is that possible?" or "no, he would not be there" - with what a real fight does instead.
2. THE MOVES (PART 2, table 4c). For each move: is the before and after of EACH man right? Is the other man's window
   (his answer) the right one? Name wrong rows and what to write instead.
3. THE LEGAL PAIRS (4b). Is a real pair missing for boxer against jiu-jitsu fighter (not for other arts)? Is one listed
   that does not happen?
4. THE RULE SET (4d) and THE LOOPS (4e): can a player stall, or spin a free loop, that a real referee would stop? Is any
   cap harsher than a real referee?
5. WHAT WAS LEFT OUT (PART 1: "CAN WAIT", and PART 3): is anything left out that a boxer-against-grappler bout cannot
   look real without? Is anything kept that the first screen could drop?
6. THE FIRST SCREEN. The owner could not read the old screen (it spoke in codes like B0 and T1). In a few lines: how
   should the screen show where EACH man is, in plain fight words, at a glance?

## Score, each out of 10, with reasons
- REAL FIGHT: would a fight fan watching a bout played on this model recognise every exchange?
- DEPTH: real decisions with trade-offs in the standing-to-ground game (follow him down or not; stand out or stay;
  pull or sit; when to get up), no single best line.
- PLAY: fast and punchy (the owner's taste: about 5 minutes a bout, quick turns, every number on the table).
The bar is 8 on each. END WITH "TO REACH 10/10": the concrete list of changes, most important first, specific enough
to build. Then DRAW YOUR 10/10 FIRST SCREEN: one self-contained HTML page, 1920x1080, in one code block (the two
fighters and where each is, the volley on the table, the cards in hand, wind, health, points).

---
# PART 0 - what the old prototype did (the steps, audited)

### 2a. Steps (the floor buttons)

| Card or step (file:line) | What the code does (both fighters, before -> after) | Memo row | Verdict | For WRONG: what a fight does, and the smallest rule change |
|---|---|---|---|---|
| Step in `@in` (`engine.mjs:81,139`) | both standing: KICK -> PUNCH, PUNCH -> CLINCH | 3 (clinch entry), 1a ("punch the grappler on the way in") | **REAL** | - |
| Step out `@out` from PUNCH (`engine.mjs:82,140`) | both standing: PUNCH -> KICK | 1b ("walk away") | **REAL** | - |
| Step out `@out` from CLINCH (`engine.mjs:82,140`) | both standing: CLINCH -> PUNCH, the tie dropped, cannot be answered; only a judo grip holds him | 3 ("win the underhook, post a forearm, step off at an angle"); rule 7 (the clinch runs while active) | **MISSING-LINK** | Leaving an MMA clinch is fought for: the holder gets one answer as he leaves (pull guard, takedown, knee). Rule: a step that leaves contact is laid like a card and can be answered. |
| Let him up `@stand` (`engine.mjs:83,141`) | top in guard -> standing at PUNCH; the man on his back -> **standing at PUNCH, same instant, free**; punches may follow in the same volley | 1c steps 1-4; 1d; memo 6 item 1 | **WRONG** | The top man stands in the guard (1-3 s), breaks the legs open (1-5 s), backs away; the bottom man is **still on his back** and must spend his own move to get up (1d), and can sweep or up-kick in each window (1e, 1f). Rule: Stand up changes the top man's OWN position only; the bottom man stays on his back; it takes two moves (stand in the guard, then back away), each answerable. Rename: "Stand up out of his guard". |
| Get up `@up` (`engine.mjs:84,142-145`) | the man underneath at rung <= 1 -> standing at PUNCH, and **the man on top, kneeling in his guard, is also standing at PUNCH**; at rung 2-3: rung - 2 | 1d (technical stand-up / wrestle-up); memo 6 item 3 | **WRONG** | Under a man in your guard you cannot simply stand: you wrestle up into a clinch, or wait for him to stand. Once the other man stands apart, the technical stand-up takes a beat on one hand and one foot and can be hit. Rule: Get up moves only the man getting up, takes his move and is answerable; from under a kneeling man it is a wrestle-up ending in the CLINCH (or failing); from under side control it is "recover guard", one step, not two. |
| Pull guard `@pull` (`engine.mjs:85,146`) | BJJ from KICK, PUNCH or CLINCH, **no grip**: BJJ on his back in guard, the boxer **pulled down to his knees in the guard**, cannot be answered; a triangle may follow in the same volley | 1a ("a pull needs contact first"; "after a sit with no grip: boxer still standing"; "during the pull: sprawl the hips back"); memo 6 item 5 | **WRONG** | Without a grip it is a sit: the BJJ man is on the floor, the boxer stays standing and chooses whether to follow (1b). With a grip (collar tie, overhook, body lock) it pulls the boxer into the guard, and he can sprawl back and keep his posture. Rule: Pull guard needs a tie he made earlier; with none it becomes "Sit down" (his own position only); a pull is answerable by Sprawl. |
| Cover up `@cover` (`engine.mjs:46,113,155`) | the struck man takes 2 less | 3 (boxer defence); 1f (covering under ground strikes) | **REAL** | - |
| Break free `@break` (`engine.mjs:48,209,227`) | the man in a submission pays its price in wind -> **both on their feet in the CLINCH** | 1c step 1 (posture against arm attacks); memo 4 ("a third of position gains are escaped or reversed") | **WRONG** | Pulling out of an armbar or a triangle leaves you where the fight was: in his guard, or under him one layer down. Rule: breaking free ends the hold and the holder drops one layer (from the bottom: back to plain guard; from on top: rung - 1). Both stay down. |


# PART 0b - the old engine rules, audited

### 2d. Engine rules that change position, allow a strike, or end an exchange

| Rule (file:line) | What the code does | Memo row | Verdict | For WRONG: what a fight does, and the smallest rule change |
|---|---|---|---|---|
| ONE shared position: `posKey`, `stand()`, `ground()` (`engine.mjs:24,128,129`) | both men are always at the same place; one call moves both | the memo's core finding; 6 item 1 | **WRONG** | Each fighter has his own position, and what joins them is separate (section 4). The root of every WRONG row about getting up. |
| A card fits only its printed range (`engine.mjs:25,97`) | standing punches never work on the ground | 1f; 6 item 2 | **REAL** | (The rule is right; Let him up dodged it.) |
| Steps cannot be answered (`engine.mjs:111`) | pull guard, get up, let him up, step out pass untouched | 1a, 1c, 1d ("that is when they're at risk") | **WRONG** | The risky moments of the ground game ARE these steps. Rule: a step that leaves contact, goes to the ground or rises from it is answerable like a card. |
| A hold needs a settled position (`engine.mjs:96`) | no hold in the same volley as the takedown | 1c step 1 | **REAL** | - |
| ... except behind BJJ's pull (`engine.mjs:96`, `gpull`) | pull guard + triangle in one volley, from no grip | 1a | **MISSING-LINK** | A pull straight into a triangle needs an arm and the head already held. Rule: only behind a pull made from a tie. |
| ... except sambo (`engine.mjs:96`) | throw + lock in one volley | - | **REAL** | Throw-to-armlock is a sambo staple. |
| A grip or tie that stood a turn makes the takedown clean (`engine.mjs:104-105`) | the takedown cannot be answered at all | 4 (63.5% stuffed [S26]); 6 item 6 | **WRONG** | No takedown is unanswerable; a set-up raises its odds. Rule: the stood grip makes the answer dearer (+1 wind), not impossible. |
| Sambo: the throw behind his punch is clean (`engine.mjs:103`) | as above | 4 | **WRONG** | As above. |
| A gripped man cannot shoot (`engine.mjs:94`) | the grip owns his posture | 3 | **REAL** | - |
| A grip holds him in, not the karate man (`engine.mjs:82`) | anyone gripped cannot step out; the karate man can | 3 | **WRONG** | A karate man who has been gripped is held like anyone. Rule: drop the exemption (his art keeps him out of grips earlier, by Step off). |
| A stuffed shot (`engine.mjs:178-182`) | the shooter stays standing at the same range (a wrestler: tied up in the CLINCH) | 3 (sprawl, "then circle back"); GrappleMap "sprawl vs turtle" | **MISSING-LINK** | The shooter lands on his knees under a sprawl and has to get up; the sprawler then circles back out. Rule: a sprawled shooter is "on his knees" for one beat (his next move is getting up, answerable). Can wait for boxer against BJJ: neither deck shoots a takedown. |
| Wrestler stuffed -> tied up in the CLINCH (`engine.mjs:181`) | chain wrestling | 3 | **REAL** | - |
| Answers that move the bout: Step off -> KICK, Tie in -> CLINCH, Catch the kick -> ground (`engine.mjs:156-160`) | as in 2c | 3 | **REAL** | - |
| Karate volley ends at KICK (`engine.mjs:218`) | in-and-out | - | **REAL** | - |
| The guard is BJJ's (`engine.mjs:74`) | nobody else plays a card from underneath in the guard | 6 item 12 (a boxer underneath has nothing to do) | **REAL** | - |
| Leg locks from a settled top position, except sambo (`engine.mjs:73`) | - | 1e | **REAL** | - |
| A pin that runs its count (`engine.mjs:133`) | points, then **both on their feet in the CLINCH** | rule 6 (stand-up for no effort); 2 (unified MMA: no win by pin) | **WRONG** | Under the chosen rule set a held pin is dominance (the points stand), and a holder who only holds is stood up by the referee - apart, at KICK, not in the clinch. Rule: run-out -> referee stand-up to KICK. |
| Referee stand-up (`engine.mjs:266-269`) | the man on top laid no card for `N.stallMax` (1) turns -> both stand at KICK; work from underneath keeps it down | rule 6 [S1]; Leites ~45 s [S22] | **REAL** | Only the top man's idling counts. The grounded man who will not engage (rule 5, Leites) is MISSING. |
| The bell waits for a hold (`engine.mjs:303`) | a submission or pin runs to its end through the bell | 2 (unified MMA rounds) | **WRONG** | In MMA the bell ends the round and the hold with it. Rule: the hold ends at the bell, no tap. |
| A points lead of `N.lead` ends the bout (`engine.mjs:126`) | the bout stops on a 7-point lead | 2 (judged on damage, dominance, duration; no lead stoppage) | **WRONG** | No MMA bout stops on a points lead. Rule: drop it (judges at the bell). It is a game rule as much as a fight rule: the owner's call, not urgent for position. |
| KO at 0 health (`engine.mjs:125`) | ends the bout | 4 | **REAL** | - |
| Each round starts standing at KICK (`engine.mjs:299`) | - | 2 | **REAL** | - |
| The pin ticks points every turn (`engine.mjs:206`) | dominance in points | rule 4 (dominance, duration) | **REAL** | - |


---
# PART 1 - what a real fight has that the game lacked

## 3. MISSING - real options from the memo that the game lacks

| # | Missing option | Memo row | Needed for boxer against BJJ to look like a fight? |
|---|---|---|---|
| M1 | One man standing, the other down (seated or on his back), apart: the "Inoki position" ("standing vs supine w/ legs extended" in GrappleMap) | 1b | **NEEDED** - the state after every stand-up out of the guard and every sit to guard. |
| M2 | Refusing to follow: the boxer stays standing, out of leg range, or walks away | 1b | **NEEDED** - the boxer's main answer to a sit. |
| M3 | Following him down: the boxer steps into the guard (the up-kick's moment) | 1b | **NEEDED** |
| M4 | The referee stands up the grounded man who will not engage; the timidity foul if he keeps doing it | 1b; rule 5 | **NEEDED** - the cap on the sit-down loop. |
| M5 | The up-kick: from the back at a standing man in leg range (legal to the head of a standing man, not a kneeling one [S1]) | 1f; rule 3; Henderson-Edgar [S24] | **NEEDED** - the reason a boxer respects the feet. |
| M6 | Getting up as a move: the technical stand-up takes his move and can be hit if the other man is close | 1d | **NEEDED** - the owner's point. |
| M7 | Standing out of the guard in two moves (stand in the guard; back away), each a window for the man underneath | 1c | **NEEDED** - the owner's point. |
| M8 | The sweep against a standing man (tripod, sickle, ankle pick; Ali's round 6) | 1e | **NEEDED** - the risk of standing out of the guard. The Sweep card also works here; no new card. |
| M9 | A pull needs a grip: a BJJ clinch entry (collar tie / body lock) | 1a | **NEEDED** - the BJJ deck has no way to make contact today. |
| M10 | Sprawl / keep posture against the pull | 1a | **NEEDED** - one more use of the Sprawl the boxer already holds. |
| M11 | The boxer's punches from on top: from inside the guard (weak, posture) and past the guard (full) | 1c ("punches from the top count"); rule 2; Schaub [S24] | **NEEDED** - without it the boxer on top has nothing but standing up. A rule on his hook and cross, not a card. |
| M12 | Punching down from standing at a man on his back (legal, rarely lands: Ali, six punches in 15 rounds) | 1b; 1f | **NEEDED**, small - one rule on the cross (half damage, the up-kick answers it). |
| M13 | Escapes that stay on the ground: shrimp back to guard, pull out of the triangle | 1c; 4 ("a third escaped or reversed") | **NEEDED** - the fix of the WRONG escape rows. |
| M14 | The bell ends a hold | 2 | **NEEDED** - a rule, no card. |
| M15 | An answerable step out of the clinch (the frame / underhook fight) | 3 | **NEEDED** - so the tie in M9 is worth something. |
| M16 | Wrestle-up from under a man in your guard, into a clinch | 1d | CAN WAIT - a boxer underneath "had nothing to do but wait for the referee" (memo 6 item 12); the referee stand-up covers it. |
| M17 | The fence: wall walk, pinned on the fence | 1d; 3 | CAN WAIT - the prototype has no fence or ropes. |
| M18 | On the knees / turtle as its own place; front headlock outcomes | 3 | CAN WAIT - neither the BJJ deck nor the boxer shoots a takedown. |
| M19 | Leg locks against a standing man (Imanari rolls) | 1e | CAN WAIT - not in the BJJ deck. |
| M20 | A BJJ standing takedown (Gracie's double leg on Jimmerson) | 1a | CAN WAIT - the tie and the pull carry the first bout. |
| M21 | Other rule sets (ONE's knees to the grounded head, Pride's soccer kicks, boxing's count) | 2 | CAN WAIT - one rule set first. |
| M22 | Judges at the bell on damage, then dominance, then duration | 2; rule 4 | CAN WAIT - today's points + damage at the bell is close enough. |

---
# PART 2 - the new position model (on paper)

### 4a. Each fighter's own position, and what joins them

Own position (each man, separately):

| Position | The body | GrappleMap name where it has one |
|---|---|---|
| STANDING | in stance | - |
| SEATED | sitting up, one hand posted, feet towards him | (the seated form of "standing vs supine") |
| ON HIS BACK | flat, feet up towards him, spinning on the hips | "standing vs supine w/ legs extended" (bottom) |
| ON HIS KNEES | rising, or sprawled on (later: the turtle) | "sprawl vs turtle w/ single" (bottom) |
| IN GUARD, ON TOP | kneeling or squatting between the other man's legs (closed, open, half) | "posture broken full guard" (top) |
| GUARD, UNDERNEATH | on his back, the other man between his legs | "posture broken full guard" (bottom) |
| PAST THE GUARD | side control, mount, the back | "chest pass", "back w/ arm trapped" (top) |
| PINNED | on his back (or front, back taken) with his guard passed | the bottom of the row above |

What joins them: APART at a range (KICK or PUNCH; with one man down: OUT OF LEG RANGE or IN LEG RANGE), CLINCH (a tie,
and who holds it), ENTANGLED (guard or past the guard: implied by the two positions), ON THE FENCE (later).

### 4b. Legal pairs

| # | One man | The other | Join | Real example |
|---|---|---|---|---|
| 1 | STANDING | STANDING | apart, KICK or PUNCH | the opening |
| 2 | STANDING | STANDING | clinch (who holds the tie) | a collar tie before a pull |
| 3 | STANDING | SEATED or ON HIS BACK | apart: out of leg range / in leg range | Ali-Inoki; after a stand-out |
| 4 | STANDING | GUARD, UNDERNEATH | entangled (he stood up in the guard, the legs still round him) | memo 1c steps 2-3 |
| 5 | IN GUARD, ON TOP | GUARD, UNDERNEATH | entangled: closed / open / half | after a pull |
| 6 | PAST THE GUARD | PINNED | entangled: side / mount / back | after a pass or a sweep to mount |
| 7 | STANDING | ON HIS KNEES | apart or clinch | rising from a sprawl; mid stand-up |
| 8 | SEATED / ON HIS BACK | SEATED / ON HIS BACK | apart | a double sit: the referee stands both up |

Pairs that do NOT exist (the engine refuses them): IN GUARD ON TOP with anything but GUARD UNDERNEATH; PAST THE GUARD
with anything but PINNED (and the reverse); both men "on top" or both "underneath"; a CLINCH with a man seated or on his
back (the fence's wall walk comes later). And no standing punch (jab, hook, uppercut) at a man who is down: rule 2 allows
punches down, and only the cross-down rule (M12) and the ground punches from on top (M11) use it.

### 4c. The moves - before and after for EACH man, how long, and the other man's window

A move is laid in a volley like a card and resolves on the other man's turn; he may answer ONE thing of the volley
(today's rule). The new rule: these moves are answerable like cards. "Ends his volley" = nothing more can be laid after
it that turn: the move takes the rest of his turn, which is where getting up costs a turn.

| Move (who) | Before (mover / other) | After (mover / other) | How long | The other man's window (his answer) |
|---|---|---|---|---|
| Step in / Step out (either) | STANDING / STANDING, apart | the same, a range in / out | part of a volley | standing answers as today |
| Tie up (BJJ, new card) | STANDING / STANDING at PUNCH | STANDING / STANDING, CLINCH, BJJ holds the tie | part of a volley | the boxer hits him on the way in (the BJJ man's Cover / Block decide what lands); the tie itself goes on |
| Step out of the clinch (either) | CLINCH | apart at PUNCH | part of a volley | the tie holder answers: Pull guard (if he holds the tie) or a strike |
| Pull guard (BJJ, needs his tie) | STANDING in a clinch / STANDING | GUARD UNDERNEATH / IN GUARD ON TOP | ends his volley | **Sprawl** (posture): the pull fails; BJJ ends SEATED, the boxer STANDING, in leg range (pair 3) |
| Sit down (BJJ, no tie) | STANDING / STANDING | SEATED / STANDING, in leg range | ends his volley | none needed: the boxer decides on his own turn |
| Follow him down (boxer) | STANDING / SEATED or ON HIS BACK, in leg range | IN GUARD ON TOP / GUARD UNDERNEATH (open) | ends his volley | **Up-kick**: he is kicked on the way in and stays STANDING |
| Walk away (boxer: Step out over a grounded man) | STANDING in leg range / down | STANDING out of leg range / down | part of a volley | Up-kick as he leaves (once) |
| Punch down (boxer: his Cross, a rule) | STANDING in leg range / down | the same | part of a volley | Up-kick or Cover; half damage (Ali: six punches in 15 rounds) |
| Get up in open space (the man down) | SEATED or ON HIS BACK / STANDING | STANDING at KICK / STANDING | ends his volley | if the standing man is IN LEG RANGE: one punch as he rises (a hand on the floor is not "grounded" under the Aug 2026 text, and punches to a grounded head are legal anyway); out of range: free |
| Stand up in the guard (boxer on top) | IN GUARD ON TOP / GUARD UNDERNEATH | STANDING / GUARD UNDERNEATH (pair 4) | ends his volley | **Sweep** (tripod / sickle: the boxer ends ON HIS BACK or SEATED, BJJ on top or standing); or an arm attack as his posture opens (Armbar, Triangle) |
| Back away (boxer, out of the guard) | STANDING / GUARD UNDERNEATH (pair 4) | STANDING / ON HIS BACK, in leg range (pair 3) | part of a volley | **Up-kick**, or Sweep (ankle pick) as he goes |
| Guard pass (top) | IN GUARD ON TOP / GUARD UNDERNEATH | PAST THE GUARD / PINNED | one card | Escape (recover guard) |
| Sweep from the guard (BJJ) | GUARD UNDERNEATH / IN GUARD ON TOP | PAST THE GUARD (mount) or IN GUARD ON TOP / PINNED or GUARD UNDERNEATH | one card | Sprawl as "post / base" |
| Submission (Triangle, Armbar, Kimura, Rear choke) | the pair printed on the card | the same pair, a hold running | one card | Escape as it is laid; then Escape or Break free while it runs |
| Escape / Break free from a hold | the pair of the hold | the same kind of pair, the holder one layer back (mount -> guard; triangle -> plain guard) | his answer | - |
| Recover guard (Escape in his own turn, the man pinned) | PINNED / PAST THE GUARD | GUARD UNDERNEATH / IN GUARD ON TOP | part of a volley | the top man may answer with a pass back (later) |
| Ground punches (boxer on top: hook, cross) | IN GUARD ON TOP (weak) or PAST THE GUARD (full) | the same | part of a volley | Cover, Block; in the closed guard the man underneath may break his posture (his next punch from the guard is gone) |
| Referee stand-up | any ground pair with no strike and no attack for one exchange (both turns) | STANDING / STANDING apart at KICK | automatic | - |
| Referee stand-up of the grounded man (rule 5) | pair 3: the man down laid nothing towards the standing man in his turn | STANDING / STANDING apart at KICK | automatic | the second time in a round he is warned; the third time a point off (timidity) |

### 4d. The rule set: current unified MMA (memo section 2, "one honest mixed rule set")

1. Grounded = any part of the body other than the hands and feet on the canvas. CHECK in the memo (each commission adopts
   the Aug 2026 text on its own). **Reading taken: the Aug 2026 text.** For boxer against BJJ it changes nothing, because
   punches to the head of a grounded man are legal in every reading; it will matter when the kickboxer or the karate man
   meets a man rising on his hands (kicks and knees). The punch "as he rises" in 4c is legal in every reading.
2. Standing man against a grounded man: punches (and elbows) to the head legal; kicks, knees and stomps to the head are
   fouls; kicks to the body and legs legal. The boxer has punches only: Punch down (M12) and ground punches from on top (M11).
3. Up-kicks to a standing man's head legal; to a kneeling man's head not. **So the up-kick never answers a man IN GUARD ON
   TOP**, only a man standing in leg range.
4. A guard pull is legal and scores nothing; rounds are judged on damage, dominance, duration.
5. The referee stands up a grounded man who will not engage (Leites); doing it again and again is the timidity foul.
6. The referee stands both men up when nobody works on the ground; holding a position is not work.
7. The clinch runs while active (strikes and takedowns allowed); broken only when idle.
8. The 12-6 elbow (CHECK in the memo): no deck holds an elbow; no reading needed.
9. The bell ends the round and any hold.

### 4e. Free loops (a bot would spin in them) and their caps

| Loop | Why it is free | Cap |
|---|---|---|
| Sit down -> the boxer walks away -> the referee stands him up -> both standing at KICK, as at the start | the BJJ man loses nothing | the timidity rule (4c, last row): warned the second time in a round, a point off the third (the shape of ADCC's minus point [S15] and Leites [S22]) |
| Pull guard -> the boxer stands out (two moves) -> the BJJ man gets up -> pull again | each pull needs a new Tie up card and wind; each stand-out gives the BJJ man two answer windows | the tie costs a card; the timidity count also counts pulls that lead to nothing |
| On top, lay nothing -> referee stand-up -> takedown again | today's one-turn stand-up | each takedown costs a card; the stand-up stays |
| Recover guard <-> Guard pass | - | each costs a card and wind; no cap needed |
| Step in <-> Step out | - | 1 wind each, no gain; no cap needed |


---
# PART 3 and 4 - the size check and one whole bout walked on the new model

## 6. Size check

Counted from the code, boxer against BJJ (the pairing the owner plays):

| | Today | New model | Note |
|---|---|---|---|
| Card kinds in the two decks + core | 15 (boxing 7, BJJ 6, core 2) | 17 (+ Tie up, + Up-kick) | |
| Floor steps | 7 (Step in, Step out, Let him up, Get up, Cover up, Break free, Pull guard) | 8 (Step in*, Step out*, Stand up in the guard, Back away, Get up, Cover up, Break free, Pull guard / Sit down**) | * over a grounded man Step in is named "Follow him down" and Step out "Walk away": the button's NAME follows the state, not a new button. ** one button, named by whether he holds a tie. |
| Things a player can meet | 22 | 25 | **1.14 x** - under the 1.5 x limit |
| Places a card says it works at | 11 codes (K P C T0-T3 B0-B3) | 8 own positions, 8 legal pairs; a card names its place in words ("in his guard, on top") | |
| Rules added without a card | - | punch down (cross); ground punches (hook, cross from on top); a punch as he rises; the grounded-man stand-up and timidity; the bell ends a hold | each hangs on a card the player already holds |

Left out on purpose (it would push past the owner's first screen): the fence and the wall walk, the turtle as its own
place, a BJJ double leg, leg locks on a standing man, the wrestle-up, the other rule sets. Half guard stays a kind of
guard (the Kimura needs it), not a place of its own.

## 7. A first bout on the new model: boxer against BJJ fighter, unified MMA rules

Each line: who moves and what, then where both men are. The boxer goes first.

ROUND 1 - both standing, kicking range.
1. The boxer steps in and jabs; the jab lands. -> Both standing, punching range.
2. The BJJ fighter reaches in and ties up a collar tie. -> Both standing, in a clinch, the BJJ fighter holding the tie.
3. The boxer takes the tie (he has no answer for it) and throws a short body hook and an uppercut inside. -> Both standing, clinch.
4. The BJJ fighter covers the uppercut, takes the body hook, and pulls guard off his collar tie. -> (laid; it happens on the boxer's turn)
5. The boxer answers the pull with a sprawl: hips back, posture kept. The pull fails. -> The boxer standing; the BJJ fighter sitting on the mat in front of him, inside the reach of his feet.
   The boxer does not follow him down: he walks away out of leg range. -> The boxer standing, out of leg range; the BJJ fighter seated.
6. The BJJ fighter could up-kick the man leaving; he has no up-kick in hand. He stays sitting, waving him in, and lays nothing. -> The referee stands him up. -> Both standing, kicking range.
7. The boxer steps in: jab, cross. -> Both standing, punching range.
8. The BJJ fighter covers the cross; the jab lands. He ties up again and pulls guard in the same go. -> (laid)
9. The boxer has no sprawl in hand: he is pulled down. -> The boxer on his knees inside the BJJ fighter's closed guard, his head pulled down; the BJJ fighter on his back, legs locked round him.
   The boxer posts and throws a short right hand down from inside the guard (a ground punch: legal, weak from here). -> Same.
10. The BJJ fighter covers the right hand and goes for a triangle. -> (laid)
11. The boxer answers with Escape: posture up, the arm pulled out. The triangle fails; he is still inside the guard. -> The boxer on his knees in the guard; the BJJ fighter on his back.
    He stands up in the guard. -> (laid)
12. The BJJ fighter could sweep the standing man's heel; he has no sweep in hand, so the stand-up goes through. -> The boxer standing, the BJJ fighter's legs still round his hips; the BJJ fighter on his back.
    He holds on and saves his wind (nothing to lay from under a standing man without a sweep or an up-kick). The boxer is working, so no referee.
13. The boxer backs away, out of the legs. -> (laid)
14. The BJJ fighter answers with an up-kick as the boxer leaves: it catches his chin (legal: the boxer is standing). -> The boxer standing, at the edge of leg range; the BJJ fighter on his back.
    He starts a technical stand-up. -> (laid)
15. The boxer is out of punching reach of a man rising, so he lets him rise. -> Both standing, kicking range.
    The boxer steps in: jab, cross, hook. -> Both standing, punching range.
The bell. (The BJJ fighter blocks the hook on his next answer: the bell resolves the last volley, as today.)

ROUND 2 - both standing, kicking range.
16. The BJJ fighter steps in and ties up a body lock. -> Both standing, clinch, the BJJ fighter holding.
17. The boxer throws two uppercuts inside and steps out. -> (laid)
18. The two uppercuts land; the BJJ fighter answers the step out by pulling guard off the body lock he still holds. -> The boxer on his knees in the closed guard; the BJJ fighter on his back.
    He lays a hip bump sweep. -> (laid)
19. The boxer has no sprawl left to post with. He is swept. -> The BJJ fighter mounted on him, past the guard; the boxer flat on his back, pinned.
    The boxer shrimps (Escape: recover guard). -> (laid)
20. The escape works: he gets a knee back in. -> The BJJ fighter on top in the boxer's half guard; the boxer underneath (a boxer playing guard has no attacks from there).
    The BJJ fighter goes for a kimura from the half guard. -> (laid)
21. The boxer has no escape left and too little wind to break free. The kimura runs. -> Same, the hold on.
22. He taps. The BJJ fighter wins by submission in round 2.

Turns where you would ask "how is that possible?": **none found.** Two a coach might question, kept because the memo backs
them: turn 9 (a punch from inside the closed guard - legal and weak, memo 1c "punches and elbows from the top count") and
turn 14 (an up-kick at a man backing out of the guard - memo 1c step 4 and Henderson-Edgar [S24]). Turn 6 (the referee
stands the seated man up after one empty turn) is the Leites rule on a game-sized clock, not a measured time (memo: NOT
FOUND for a general figure). Turn 18 needs the answerable step out (M15): today a step out of a clinch cannot be answered.

