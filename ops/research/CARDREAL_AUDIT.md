# CARDREAL_AUDIT - every card and step of the card game against how a real fight goes (CARDAUDIT1, S544)

Phase 2 of `ops/research/CARDREAL_SCOPE_S543.md`. Read-only: nothing in `proto/cardgame` was changed. The yardstick is
John's memo `ops/research/CARDREAL1_JOHN_BRIEF_JOHN.md` (with Claude's source check at its top: [S26] [S27] [S21] exact; [S19]
Ali-Inoki and [S22] Leites not opened - used here as the shape of a bout, never as a number; every ESTIMATE timing is
used only to order moves). Section numbers below ("memo 1c step 4") are the memo's.

Verdicts: **REAL** = a referee, a coach and the memo would all recognise the move as written. **WRONG** = the code lets
something happen that a fight does not. **MISSING-LINK** = the move is real, but the code skips a step that has to come
before or after it (a grip first, a beat on the knees after), so the move arrives too cheap or too early.

COUNTS: 83 audit rows (49 cards, some in two uses; 7 steps, Step out in two rows; 22 engine rules) - **REAL 60, WRONG 18,
MISSING-LINK 5**; MISSING list 22 (15 needed for boxer against BJJ, 7 can wait). Size check 1.14 x. Walked bout: no
"how is that possible?" turn.

## 1. The position model as coded

There is ONE position for the bout, shared by both fighters. Nothing in the state says where either body is.

| Field | Values | Where |
|---|---|---|
| `S.pos` | `'K'` kick range, `'P'` punch range, `'C'` clinch, `'G'` ground | `engine.mjs:274` (starts `'K'`), `guide.mjs:10` (the strip KICK - PUNCH - CLINCH - GROUND) |
| `S.top` | the index of the fighter on top, or -1 standing | `engine.mjs:128-129` |
| `S.rung` | 0..3 on the ground: 0 full guard, 1 half guard, 2 side control / mount, 3 the back (capped at 3, `engine.mjs:197`) | read by the cards' `at` lists, e.g. `cards.mjs:69-73` |
| `posKey(S, m)` | `K`, `P`, `C` standing; on the ground `'T'+rung` for the man on top, `'B'+rung` for the man underneath | `engine.mjs:24`; the 11 keys `plan.mjs:7` |
| `S.grip` / `S.tie` | `{by, pass}`: a judo grip / a wrestling tie-up, owned by one man | set `engine.mjs:181,188`, cleared `129,140,148,219-220` |
| `S.hold` | `{by, kind: sub or pin, count, brk, tick, pts}` | `engine.mjs:194` |
| `S.stall` | empty turns of the man on top | `engine.mjs:266-270` |

The two functions that move the bout move BOTH men at once:
- `stand(S, pos)` (`engine.mjs:128`): pos = K/P/C, top = -1, rung = 0, hold cleared. Whoever called it, both men are on their feet.
- `ground(S, top, rung, by, pull)` (`engine.mjs:129`): pos = G, the named man on top at that rung, grip and tie gone. Both men are down.

Who changes the position, and to what:

| Change | Who plays it | Effect on the shared switch | Line |
|---|---|---|---|
| Step in | either, standing | K -> P -> C | `engine.mjs:81,139` |
| Step out | either, standing, not when gripped (unless karate) | C -> P -> K, tie cleared | `engine.mjs:82,140` |
| Jab (boxer), reverse punch (karate), kickboxing kind change | the striker | K -> P (and P -> C, C -> P for kickboxing) | `engine.mjs:63,151-152` |
| Karate kick from P, karate volley not stopped | karate | P -> K | `engine.mjs:152,218` |
| Grip (judo) | judo | -> C | `engine.mjs:188` |
| Tie in (answer) | judo | -> C | `engine.mjs:156` |
| Step off (answer) | karate | -> K | `engine.mjs:159,180,187` |
| Stuffed shot by a wrestler | wrestling | -> C with a tie | `engine.mjs:181` |
| Any clean takedown or throw | the thrower | `ground(thrower on top, card.to)` | `engine.mjs:184` |
| Catch the kick (answer) | sambo | `ground(catcher on top, 0)` | `engine.mjs:160` |
| Pull guard | BJJ, from K, P or C, no grip | `ground(the OTHER man on top, 0)` | `engine.mjs:85,146` |
| Guard pass, Ride | man on top | rung + 1 | `engine.mjs:195-197` |
| A hold answered by Escape | the man underneath | the holder on top loses a rung | `engine.mjs:190` |
| Let him up | the man on top | `stand(S,'P')`: BOTH on their feet at punch range | `engine.mjs:83,141` |
| Get up | the man underneath | rung <= 1 (rung 0 under a wrestler): `stand(S,'P')`, BOTH up; else rung - 2 (- 1) | `engine.mjs:84,142-145` |
| Escape played in his own turn | the man underneath | as Get up, two rungs | `engine.mjs:89,148` |
| Escape / Break free inside a hold | the held man | `stand(S,'C')`: BOTH on their feet in the clinch | `engine.mjs:209` |
| A pin that runs its count | the holder | points, then `stand(S,'C')` | `engine.mjs:133` |
| Referee stand-up | automatic: the man on top laid no card for `N.stallMax` turns (sized: 1) | `stand(S,'K')` | `engine.mjs:266-269`, `sized.json` |
| Each round | automatic | `stand(S,'K')` | `engine.mjs:299` |

Strikes are allowed by the same switch: a card fits if its printed range equals `posKey` (`engine.mjs:25,97`). The boxer's
punches are printed `P` (`cards.mjs:23-27`); hook, body hook and uppercut also `C` (`engine.mjs:70`). No boxing card works on
the ground. The only ground strike in the game is the wrestler's Ground strikes, from on top (`cards.mjs:62`). Nobody
strikes from underneath. Steps are never answerable: `ansFits` returns false for anything that is not a card
(`engine.mjs:111`).

THE OWNER'S CASE, traced: the boxer is in the BJJ fighter's guard. He lays Let him up, Jab, Cross. While he lays them the
projection `S.pj` already stands both men at PUNCH (`engine.mjs:141,262`), so the jab and the cross are legal
(`engine.mjs:257`). On the BJJ man's turn they resolve in order: both on their feet at punch range, then a jab and a cross
into a man who, a moment before, was on his back with his legs round the boxer. He cannot answer the step
(`engine.mjs:111`). The screen kept saying GROUND, you are underneath, because the strip shows the bout as it stood before
the volley resolved.

The rest of the prototype reads the same switch: `plan.mjs:7,48` (the pilot values a place by `posKey`), `plan.mjs:141`
(the scripted pilot: on top Let him up, underneath Get up), `career.mjs:96-100` (the training state is the share of turns
at each key), `ui-text.mjs:8,11-18,81-84` (the strip, "you are underneath, ground step n", the step texts),
`guide.mjs:8-11,18-19`.

## 2. The audit table

Cards: all 49 in `cards.mjs`. Steps: all 7 in `FLOOR` (`cards.mjs:88`). Engine rules: every rule that changes position,
allows a strike or ends an exchange. The memo covers boxer against jiu-jitsu fighter in depth (sections 1a-1f), the rule
sets (2), the clinch (3) and the numbers (4); rows for the other four arts cite what of it applies, and say so when the
memo has no row (phase 1 for those arts is still to come).

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

### 2b. Cards - core and boxing

| Card or step (file:line) | What the code does | Memo row | Verdict | For WRONG: what a fight does, and the smallest rule change |
|---|---|---|---|---|
| Sprawl, as an answer (`cards.mjs:18`, `engine.mjs:118`) | stops a takedown that is not clean, or a grip/tie set-up; both stay standing where they were | 3 (sprawl); 4 (63.5% stuffed [S26]) | **REAL** | (The man who shot is left standing: see the stuffed-shot rule in 2d.) Against a Sweep from the guard it reads as "post / base": same effect, another word on the card. |
| Sprawl, laid in his own turn (`engine.mjs:90,148`) | clears a grip or tie held on him | 3 ("win the underhook ... circle back") | **REAL** | Word: "Break the grip", not sprawl. |
| Escape, as an answer (`engine.mjs:120,190`) | stops a pass; stops a hold as it is laid and the holder on top loses one rung; both stay on the ground | 1c ("posture"); 4 ("a third escaped or reversed") | **REAL** | - |
| Escape, laid in his own turn (`engine.mjs:89,148`) | as Get up but two rungs: at rung <= 1 both stand at PUNCH | 1d | **WRONG** | As Get up: only the escaping man moves, it is a move, it can be answered. Rule: the card is "Recover guard / stand up", moving his own position one step. |
| Escape, inside a hold (`engine.mjs:209`) | **both on their feet in the CLINCH** | 1d ("worst case dragged back down"); 4 | **WRONG** | As Break free above: the hold ends, both stay down, the holder one layer back. |
| Jab (`cards.mjs:23`, `engine.mjs:152`) | standing at PUNCH; from KICK it steps in first; never on the ground | 3; 1a ("punch the way in") | **REAL** | The owner's jab came through Let him up, not through this card. |
| Cross (`cards.mjs:24`) | standing at PUNCH | 3 | **REAL** | - |
| Lead hook (`cards.mjs:25`, `engine.mjs:70`) | PUNCH, and in the CLINCH (infighting) | 3 (clinch KOs: a punch in 47% of 64 [S24]) | **REAL** | - |
| Body hook (`cards.mjs:26`) | PUNCH and CLINCH, drains wind | 3 | **REAL** | - |
| Uppercut (`cards.mjs:27`) | PUNCH and CLINCH; cannot be blocked or covered | 3 | **REAL** | (Not a position point.) |
| Slip (`cards.mjs:28`, `engine.mjs:114`) | a standing punch misses; never against a ground strike | 3 | **REAL** | - |
| Block (`cards.mjs:29`) | a strike for 4 less (any range, also on the ground) | 3; 1f | **REAL** | - |

### 2c. Cards - BJJ, judo, wrestling, sambo, kickboxing, karate

| Card or step (file:line) | What the code does | Memo row | Verdict | For WRONG: what a fight does, and the smallest rule change |
|---|---|---|---|---|
| Sweep (`cards.mjs:68`) | BJJ underneath in full or half guard -> BJJ on top at rung 1 (in the other man's half guard), 3 points; the other man underneath | 1c step 1; GrappleMap "hip bump sweep" (894) | **REAL** | Only against a kneeling man. The sweep against a man standing up out of the guard (1e: tripod, sickle, ankle pick) does not exist: see MISSING. |
| Guard pass (`cards.mjs:69`) | on top: rung + 1 from T0/T1/T2 | 4 ("a third of ground time past full guard" [S24]); GrappleMap "bull fighter pass" (752) | **REAL** | From side control (T2) to the back it is a position advance, not a pass: word only. |
| Triangle (`cards.mjs:70`) | from the bottom of the full guard | 1c step 1 (6.1% of UFC submissions [S27]); GrappleMap 704 | **REAL** | - |
| Armbar (`cards.mjs:71`) | from the bottom of the full guard, from side/mount, from the back | 1c step 1 (12.8% [S27]); GrappleMap 1458 | **REAL** | - |
| Rear choke (`cards.mjs:72`) | from the back | 4 (40.4% [S27]); GrappleMap 716 | **REAL** | - |
| Kimura (`cards.mjs:73`) | from the bottom of the half guard, top half guard, side control | GrappleMap "half guard kimura" (1786) | **REAL** | - |
| Grip (`cards.mjs:50`, `engine.mjs:188`) | judo: PUNCH or CLINCH -> CLINCH with his grip | 1a (contact first); 3 | **REAL** | - |
| Hip throw (`cards.mjs:51`, sized `to: 3`) | CLINCH with a grip -> thrower on top **at rung 3, on the back** | memo has no judo row; 3 ("takedowns from the clinch succeed more often") | **WRONG** | A hip throw lands the man on his back with the thrower beside him: side control / scarf hold (rung 2), or the thrower still standing. Rule: `to: 2`. |
| Foot sweep (`cards.mjs:52`, sized `to: 3`) | as above, rung 3 | (no judo row) | **WRONG** | A foot sweep drops him; the thrower is still standing over him (new model: standing over a man on his back) or follows to side control. Rule: `to: 2`, or the standing-over state once it exists. |
| Shoulder throw (`cards.mjs:53`, sized `to: 3`) | as above, rung 3 | (no judo row) | **WRONG** | As the hip throw: `to: 2`. |
| Hold-down (`cards.mjs:54`) | a pin from top half guard, side/mount or the back; ticks points; ends in the CLINCH | (no judo row); rule 6 ("holding a position is not effort") | **WRONG** | A judo hold-down is on a man on his back, from the side or mount - not from inside his half guard (legs tangled) nor from his back. Rule: works at T2 only. (Its run-out outcome: see 2d.) |
| Armlock (`cards.mjs:55`) | from side/mount or the back | (no judo row) | **REAL** | - |
| Tie in (`cards.mjs:56`, `engine.mjs:156`) | a strike is smothered, both in the CLINCH | 3 | **REAL** | - |
| Double leg (`cards.mjs:59`, sized `to: 1`) | from any standing range (wrestler) -> on top in half guard | 1a (Gracie's double at 1:00 [S17]); 4 ("fewer than half get to half guard") | **REAL** | - |
| Single leg (`cards.mjs:60`, `to: 0`) | -> on top in the guard | 4 | **REAL** | - |
| Body lock slam (`cards.mjs:61`, `to: 0`) | CLINCH -> on top in the guard | 3 | **REAL** | - |
| Ground strikes (`cards.mjs:62`) | on top at any rung, to the head | 1f (punches down legal [S1]); 4 (ground and pound 23.1% of KOs [S27]) | **REAL** | - |
| The fall (`cards.mjs:63`) | a pin from top half guard, side/mount, back; ticks points; ends in the CLINCH | rule 6 | **REAL** | As points for dominance it stands; the run-out outcome is in 2d. |
| Ride (`cards.mjs:64`) | on top: rung + 1 | 4 | **REAL** | - |
| Front headlock (`cards.mjs:65`, `engine.mjs:119,179`) | a shot is snapped down; both stay standing | 3 (sprawl, "frame the head"); GrappleMap "sprawl vs turtle" | **MISSING-LINK** | A snapped-down shooter is on his knees under the man holding his head for a beat before he can stand (GrappleMap "sprawl w/ head&arm vs double-leg"). Rule: as the stuffed shot in 2d. |
| Sambo throw (`cards.mjs:77`, `engine.mjs:71,103`) | from PUNCH with no grip -> on top in the guard; behind his own punch it cannot be stopped | 1a (contact first); 3 | **MISSING-LINK** | Behind a punch the grab is part of the same motion (punch to clinch to throw); a bare throw from punch range still needs the grab. Rule: from PUNCH only right behind his own punch; never unanswerable (2d, the clean-takedown rows). |
| Leg trip (`cards.mjs:78`) | CLINCH -> on top in half guard | 3 | **REAL** | - |
| Knee bar (`cards.mjs:79`) | sambo: from anywhere on the ground, top or bottom | 1e (Imanari [S32]) | **REAL** | - |
| Ankle lock (`cards.mjs:80`) | as the knee bar | 1e | **REAL** | - |
| Chest hold (`cards.mjs:81`) | a pin from on top at any rung | rule 6 | **REAL** | Points for dominance; the run-out outcome is in 2d. |
| Overhand (`cards.mjs:82`) | standing at PUNCH | 3 | **REAL** | - |
| Catch the kick (`cards.mjs:83`, `engine.mjs:160`) | a kick is caught -> the catcher on top in the kicker's guard | 1e (Ali's ankle grab, the other way round) | **REAL** | - |
| One-two (`cards.mjs:34`) | standing at PUNCH | 3 | **REAL** | - |
| Left hook (`cards.mjs:35`) | standing at PUNCH | 3 | **REAL** | - |
| Low kick (`cards.mjs:36`) | KICK or PUNCH, lames the leg | 1a (Gracie's low kicks [S17]); 1b (Inoki's kicks to the legs) | **REAL** | - |
| Body kick (`cards.mjs:37`) | standing, KICK (the kickboxer also PUNCH) | 4 | **REAL** | - |
| High kick (`cards.mjs:38`) | standing, KICK (the kickboxer also PUNCH) | 4 (head kicks 5.3% of KOs [S27]) | **REAL** | - |
| Knee (`cards.mjs:39`) | in the CLINCH | 3 (a knee in 42% of clinch KOs [S24]) | **REAL** | - |
| Check (`cards.mjs:40`) | a kick misses | - | **REAL** | - |
| Front kick (`cards.mjs:43`) | standing at KICK | 4 | **REAL** | - |
| Roundhouse (`cards.mjs:44`) | standing at KICK | 4 | **REAL** | - |
| Head kick (`cards.mjs:45`) | standing at KICK | 4 | **REAL** | - |
| Leg kick (`cards.mjs:46`) | KICK or PUNCH, lames the leg | 1b | **REAL** | - |
| Reverse punch (`cards.mjs:47`, `engine.mjs:152`) | blitzes in from KICK, lands at PUNCH | - | **REAL** | - |
| Step off (`cards.mjs:48`, `engine.mjs:115,159,180`) | a standing strike, or a takedown that is not clean, misses; back at KICK | 3 ("circle back to striking range") | **REAL** | - |

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

## 4. The new position model (on paper)

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

## 5. Which of today's tests the new model breaks

The brief says "47 engine tests". `node --test engine.test.mjs` today: 29 tests, all passing; the other 18 are
`ui.test.mjs` (29 + 18 = 47). Broken BY MEANING (each should break):

| Test (exact name) | File:line | Why it should break |
|---|---|---|
| "wrestling, chain wrestling and the ride: the shot travels from KICK; stuffed, he is tied up and the next shot cannot be stopped; the man under him gets up one rung at a time" | `engine.test.mjs:124` | asserts the second shot cannot be sprawled (the clean-takedown rule, WRONG) and that Get up from half guard under a judo man puts both at PUNCH (`Q.pos === 'P'`). |
| "bjj, the guard: Pull guard is his own step, and he attacks from underneath at once; nobody else can" | `engine.test.mjs:141` | pulls from PUNCH with no tie and lands a triangle in the same volley, unanswered. In the new model it is a sit (the boxer stays standing) unless a tie stood first, and the pull can be sprawled. |
| "the hold: wind comes back slower while held; the price goes up 1 a turn; break free the turn you can pay; else the count ends it" | `engine.test.mjs:178` | asserts `S.pos === 'C'` after Break free: both on their feet in the clinch. New: still down, the holder one layer back. |
| "a pin scores at the top of every turn it is on, also the turn he escapes, and its last points at the end; only the Escape card gets out" | `engine.test.mjs:196` | asserts the clinch both after the pin runs out and after Escape. New: run-out = referee stand-up to KICK; Escape = recover guard. |
| "judo, the grip: no throw without it; laid in the same volley it can be stopped ..." | `engine.test.mjs:99` | its second half (a grip that stood a turn makes the throw unstoppable) breaks with the +1-wind rule; the first half stays. |
| "a points lead ends the bout early" | `engine.test.mjs:222` | only if the lead rule is dropped (the owner's call; 2d). |
| "the How to play button is on every screen, and its page holds the guide's six lines and a small picture of the strip" | `ui.test.mjs:281` | the one-switch strip (KICK - PUNCH - CLINCH - GROUND) is the picture of the old model; the new screen shows where each man is. |

Not broken by meaning, only their data shape changes (they set `S.pos = 'G'; S.top; S.rung` by hand): "the referee stands
up a ground phase with no attack" (`:229`, still true: stand-up to KICK), "sambo, throw-to-lock ..." (`:152`), "the pilot
in a hold follows the printed rule ..." (`:211`). The two ladder tests ("L2 measures the ladder's own training states ..."
`:280` and "every training state is read off a bout the ladder fought" `:345`) read positions through
`career.mjs:96-100`: re-measured, not a meaning break.

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

## 8. Files opened

`ops/research/TASK_CARDAUDIT1.md`; `proto/cardgame/engine.mjs` (313 lines, whole); `proto/cardgame/cards.mjs` (114, whole);
`proto/cardgame/sized.json`; `proto/cardgame/plan.mjs` (whole); `proto/cardgame/guide.mjs` (whole);
`proto/cardgame/ui-text.mjs` (whole); `proto/cardgame/career.mjs` (grep for positions, lines 96-106);
`proto/cardgame/engine.test.mjs` (test list; lines 26-60, 124-240, 300-351; ran it: 29 of 29 pass);
`proto/cardgame/ui.test.mjs` (test count 18, line 281); `ops/research/CARDREAL1_JOHN_BRIEF_JOHN.md` (whole, with its source
check); `ops/research/CARDREAL_SCOPE_S543.md`; `ops/research/CARD_R8_OWNER_PLAY_S543.md`; `proto/grapplemap/README.md`;
`proto/grapplemap/bjj_slice.json` (card, position and move names). Not opened: `CARD_R8_CLAUDE_PLAY_S542.md`,
`DESIGN_CARDGAME_SCOPE.md`, `topics/ground.md`, `topics/clinch.md` (the memo and the code answered every row; the critic
round can add them).

## 9. Round 9b: the changed rows (S548, after two fresh critics; TASK_CARDROUND9B)

Written before any engine code. Where a row here and a row of 4c disagree, this one wins. Sources: Kalli's review
(`CRITIC_CARDREAL_BRIEF_KALLI.md`, numbered K1-K9), Dola's (`CRITIC_CARDREAL_BRIEF_DOLA.md`, D), the memo's row M20.
Every number marked FIRST GUESS is reported, not tuned (balance is round 11).

### 9a. The rows (4c format: before and after for EACH man, how long, the other man's window)

| # | Move or rule (who) | Before (mover / other) | After (mover / other) | How long | The other man's window |
|---|---|---|---|---|---|
| A1 | THE KNOCKDOWN (a rule on any standing punch; K1) | STANDING / STANDING, the punch lands for 6 or more and leaves him at 10 health or under (FIRST GUESS 6, 10) | STANDING, in leg range / SEATED (pair 3) | at once, as the punch lands; the rest of the volley is laid at a man who is down, so only the punch down still lands | none: it is the punch's result. He gets his own turn seated (Get up, Up-kick, Cover) |
| A2 | The referee's stoppage (TKO; K1) | pair 3 or a ground pair: punches LAND on the man down in 2 of the puncher's turns running, and the man down laid nothing back in between (FIRST GUESS 2) | the bout ends, win by stoppage | automatic | laying anything back (Up-kick, Get up, Sweep, a hold, Hold the legs) resets the count |
| B1 | Keep your base (a floor move, 2 wind; K2) - the answer to a pull, a trip or a sweep | whatever pair the pull / trip / sweep was laid at | the same pair: the pull, trip or sweep fails; a failed pull drops the tie (H2) and leaves the puller SEATED as today | his one answer | - |
| B1c | The Sprawl CARD (the stronger version; in words "Sprawl: keep your base and drive him down") | as B1 | as B1, and against a pull or a shot the man who tried it ends ON HIS KNEES in front of him (pair 7) instead of seated | his one answer | - |
| B2 | Escape a hold (floor move, 2 wind; K2) | held | the hold ends, both stay down, the holder where he was (mount stays mount) | his one answer | - |
| B2c | The Escape CARD (stronger) | held | as today: the holder ONE LAYER BACK (mount -> half guard, triangle -> plain guard) | his one answer | - |
| B3 | Up-kick from your back (floor move, 2 wind; K2) | SEATED or ON HIS BACK / STANDING in leg range | the same; 2 damage (the card: 3, as printed) | part of a volley, or his answer to Follow him down / Walk away / Back away / Punch down | Cover |
| B4 | Hold the legs (floor move, 2 wind; K2) - the answer to Stand up in the guard or Back away | GUARD UNDERNEATH (closed) / the man standing up or backing out | Stand up: he stands but the guard stays CLOSED round him (pair 4, legs held). Back away: it fails, he stays in pair 4 | his one answer; at most 2 turns running, then the guard opens by itself (the cap of the loop) | - |
| C1 | POSTURE, one flag on the man IN GUARD ON TOP: UP or BROKEN (K3) | a pull, or a sweep stopped by Keep your base, leaves it BROKEN; a takedown or Follow him down leaves it UP | - | - | - |
| C2 | Posture up (a move of the man on top, 1 wind) | IN GUARD ON TOP, posture BROKEN / GUARD UNDERNEATH | the same, posture UP | part of a volley | Triangle or Armbar may answer it (he gives an arm to post) |
| C3 | Ground punches from inside the guard need posture UP (K3) | - | a punch laid with posture BROKEN is not legal | - | - |
| C4 | Sweep, by posture (K3): hip bump when his posture is UP; scissor when it is BROKEN | GUARD UNDERNEATH / IN GUARD ON TOP | as today (he comes up on top) | one card | Keep your base; a stopped sweep leaves posture BROKEN |
| C5 | Breaking a triangle or an armbar (D) | the hold on | the SAME kind of guard as before the hold (closed stays closed, half stays half), posture as it was | his answer | - |
| D1 | A punch from inside the guard gives up an arm (K4) | IN GUARD ON TOP, posture UP / GUARD UNDERNEATH | the same | part of a volley | Cover, Block - AND the Armbar or the Triangle may answer the punch itself: the punch does not land and the hold is on |
| E1 | Punch down from standing in the guard (pair 4) at FULL damage (K5) | STANDING / GUARD UNDERNEATH | the same | part of a volley | Cover; Sweep (he is swept as he punches); Armbar on the punching arm (the hold is on, he is pulled back IN GUARD ON TOP, posture BROKEN) |
| E2 | Stand up in a CLOSED guard opens it (K5) | IN GUARD ON TOP (closed) / GUARD UNDERNEATH | STANDING / GUARD UNDERNEATH, guard OPEN - unless the man underneath pays Hold the legs (B4) | ends his volley | Sweep, Triangle, Armbar as today; Hold the legs |
| E3 | Back away while the legs are held | pair 4, legs held | not legal that turn | - | - |
| F1 | The jiu-jitsu fighter punches from on top (a rule, no card; K6): 1 wind, half of a cross (2 damage) | PAST THE GUARD (mount or side) / PINNED | the same | part of a volley | Cover up or Escape (the card recovers guard as he punches) |
| G1 | Tie up is a collar tie or a body lock: his choice as he lays it (K9, M20) | STANDING / STANDING | CLINCH, he holds the tie (kind: collar or body) | part of a volley | Frame (H1), or hit him on the way in |
| G2 | Trip (the jiu-jitsu fighter, a move off his BODY LOCK, 2 wind) | CLINCH, his body lock, stood through one of the boxer's turns | PAST THE GUARD (side control) / PINNED | ends his volley | Keep your base: he stays standing, the clinch and the body lock hold |
| G3 | Pull guard stays, from the COLLAR tie | as 4c | as 4c (posture BROKEN, C1) | as 4c | Keep your base / Sprawl |
| H1 | Frame (a floor move, 1 wind; K7) - the answer to a Tie up | STANDING / STANDING at PUNCH | the same: the tie fails, both stay at PUNCH | his one answer | - |
| H1b | THE TIE MUST STAND through one of the other man's turns before a pull or a trip: no tie-and-pull in one volley (K7). With no tie that has stood, the button is Sit down | - | - | - | - |
| H2 | A failed pull drops the tie (K7) | - | no tie | - | - |
| H3 | Recover guard, by where he was pinned (K7; 4c's row was wrong, section 7 turn 20 was right) | PINNED under mount / PINNED under side control | GUARD UNDERNEATH, HALF guard / GUARD UNDERNEATH, closed guard | part of a volley | as 4c |
| H4 | Get up in open space: unchanged (ends at KICK; the one punch as he rises when the standing man is in leg range). Kalli's "ends at punching range" is NOT taken: a technical stand-up moves away from him | - | - | - | - |
| I1 | The grounded man who will not engage (K8, D): after ONE empty turn he hears "get up" and stays down; after the SECOND empty turn running he is stood up | pair 3 | first: the same pair, a warning in words; second: STANDING / STANDING at KICK, the timidity count +1 | automatic | - |
| I2 | A warning always comes before a point off | - | the first stand-up in a round is free, the second is the WARNING, the third and later a point off (as 4c: unchanged in number, now guaranteed in order) | - | - |
| I3 | A pull is an attempt and never counts toward timidity; a Sit down with no tie still does | - | - | - | - |
| I4 | A clinch held through a whole exchange (both turns) with nothing laid by either man is broken | CLINCH | STANDING / STANDING at PUNCH, no tie | automatic | - |
| I5 | Standing in the guard (pair 4) is the ground for the nobody-works stand-up, and THAT stand-up leaves the boxer STANDING in leg range and the other man ON HIS BACK (pair 3) - not both up at KICK - so the boxer still has to pass the up-kick to leave | pair 4, nobody working for one exchange | STANDING in leg range / ON HIS BACK | automatic | - |
| J | NOT TAKEN: the kneeling in-between state as a picture (D; the screen is round 10); pairs 7 and 8 get no word on the first screen (K) | - | - | - | - |

### 9b. The loops these rows open, and their caps (the brief's "Feedback loops")
- Floor defences cost wind -> less to attack with: capped by the wind that comes back each turn and by the referee (A2, I1).
- Knockdown -> punches down -> another knockdown: capped by A2 (two turns of landed punches with nothing back ends it).
- Hold the legs <-> Stand up in the guard: at most 2 turns running (B4), then the guard opens.
- Frame <-> Tie up: 1 wind against a card; the tie costs a card.

### 9c. The bout of section 7, re-walked on these rows (the boxer goes first)
ROUND 1 - both standing, kicking range.
1. The boxer steps in and jabs; the jab lands. -> Both standing, punching range.
2. The jiu-jitsu fighter ties up a collar tie. -> (laid)
3. The boxer could Frame (1 wind); he keeps his wind and takes the tie, then throws a body hook and an uppercut inside. -> Clinch, the jiu-jitsu fighter holding a collar tie that has now STOOD a turn.
4. The jiu-jitsu fighter covers the uppercut, takes the body hook, and pulls guard off the collar tie. -> (laid)
5. The boxer answers with Keep your base (2 wind; he holds no Sprawl card). The pull fails and the tie is gone. -> The boxer standing; the jiu-jitsu fighter SEATED, in leg range. The boxer walks away. -> (laid)
6. The jiu-jitsu fighter pays 2 wind for an Up-kick as the boxer leaves (no card needed): it lands. The boxer is out of leg range. The jiu-jitsu fighter worked this turn (the up-kick), so the referee says nothing.
   He gets up. -> (laid) -> Both standing, kicking range.
7. The boxer steps in: jab, cross. -> Both standing, punching range.
8. The jiu-jitsu fighter covers the cross; the jab lands. He ties up (a body lock this time). He cannot pull or trip in the same volley: the tie has not stood. -> (laid)
9. The boxer Frames (1 wind): the tie fails. -> Both standing, punching range. He throws jab, cross, hook: the combination. -> (laid)
10. The jiu-jitsu fighter covers the hook; the jab and the cross land - the cross for 6, and it leaves him on 9: A KNOCKDOWN. -> The jiu-jitsu fighter SEATED; the boxer standing over him, in leg range.
    Seated, he lays an Up-kick (2 wind). -> (laid)
11. The boxer chooses: Punch down, Follow him down, or Walk away. He covers the up-kick and punches down (his cross, half damage). -> (laid)
12. The punch down lands. The jiu-jitsu fighter laid something back last turn (the up-kick), so the stoppage count is 0. He gets up (the boxer is in leg range: one punch as he rises - the boxer has no punch laid for it). -> Both standing, kicking range.
The bell.

ROUND 2 - both standing, kicking range.
13. The jiu-jitsu fighter steps in and ties up a body lock. -> (laid)
14. The boxer has 0 wind for a Frame after his own volley; the tie goes on. He throws two uppercuts inside. -> Clinch, body lock, stood.
15. The uppercuts land. The jiu-jitsu fighter Trips off the body lock. -> (laid)
16. The boxer cannot pay Keep your base (2 wind): he goes down. -> The jiu-jitsu fighter PAST THE GUARD in side control; the boxer PINNED.
    The boxer recovers guard (the Escape card, in his own turn). -> (laid)
17. From side control the recovery is to the closed GUARD: the boxer on his back, the jiu-jitsu fighter IN HIS GUARD ON TOP, posture UP. The jiu-jitsu fighter passes to the half guard. -> (laid)
18. The pass goes through (the boxer holds no Escape now and saves his wind). -> Half guard. The boxer lays nothing.
19. The jiu-jitsu fighter passes again -> side control; punches from on top (1 wind, 2 damage). -> (laid)
20. The boxer covers the punch. The pass stands: PINNED under side control. There is no hold yet, so nothing to escape; he holds no Escape card to recover guard with. The nobody-works clock does not run: the top man is working.
21. The jiu-jitsu fighter lays the Kimura from side control. -> (laid)
22. The boxer pays 2 wind: Escape a hold (the floor move). The kimura ends; the jiu-jitsu fighter stays in side control (no layer back: that is the card). -> Same.
23. The jiu-jitsu fighter punches from on top twice and lays the Kimura again. -> (laid)
24. The boxer has 1 wind: he cannot pay. The punches land; the kimura runs. He taps on its count. The jiu-jitsu fighter wins by submission in round 2.

Turns decided by "he had no card for it" in section 7: 6, 9, 12, 19, 21. Here: none. Turns 5 (Keep your base), 6 (Up-kick), 9 (Frame) and 22 (Escape a hold) are paid in wind; turns 14, 16 and 24 are lost because the wind was spent - a choice he made earlier, which is the point (K2).
