# ALLPLAY2B_ARENA: Tells version 2, three bouts (seat arena, 2026-11-26)

Shell seat, round 2. I played three bouts through `node proto/twohands/tools/play_cli.mjs` with `tells=2`, one
against each man, in the order the task gave: V1 The Jabber seed 51, V2 The Slugger seed 52, V3 The Body Snatcher
seed 53. I decided every beat myself, and wrote one line of WHY before each beat (`why_v1.txt` ... `why_v3.txt`: the
WHY line, then the tool's own output). I did not read `tells.mjs` or `DESIGN_TELLS2.md` until all three bouts were
over. State files and logs: `v1.json` ... `v3.json` and `*.json.log.txt`.

| Bout | Opponent | Result | Cards | His punches that landed | My punches that landed | Tells true/fake |
|---|---|---|---|---|---|---|
| V1 | The Jabber, s51 | LOSS | 27-29 (10-9, 8-10, 9-10) | 6 | 2 | 11 / 7 |
| V2 | The Slugger, s52 | DRAW | 28-28 (8-10, 10-9, 10-9) | 3 | 2 | 16 / 2 |
| V3 | The Body Snatcher, s53 | WIN | 29-28 (10-9, 9-10, 10-9) | 2 | 0 | 13 / 5 |

Counted from the logs: 54 tells, 40 true and 14 fake (74% true). The three bouts were decided by 1-2 points each,
and nobody was knocked down in any of them. Compared with my version-1 tells bouts (his punches landed 17 times in
three bouts there), version 2's tells cut what landed on me to 11 across three bouts — the defence the round-1 report
asked for now works. What did not improve is the Slugger: he lied only twice.

## VERDICT

**Version 2's fixes are real and mostly they work — the tell is now a duel I can read, not a lookup table, but the
Slugger's lie fires too rarely in practice to keep him honest, and the bluff-only cap means a caught lie can still
hide a big punch.** All three lie rules were findable from the screen, the ledger's "when" line taught each of them
in one round, and after learning them I took almost no damage: 6, 3 and 2 punches landed on me across the three
bouts, and I lost, drew and won by a point each time. Against the Jabber and the Body Snatcher the tell is now a
genuine decision — true or lie, and if a lie, which light beat is coming. Against the Slugger it is still a lookup
table for two thirds of the bout, because his rule only fires the beat after *I* land a punch, and I landed only four
in the whole bout. Catching a lie still feels good (V3 R2b3, V2 R3b4). What version 2 did NOT fix: a lie's content
varies, so knowing a tell is a lie does not always tell you which line to close — V1 R2b2 and V2 R1b4 both cost me
damage *after* I had caught the lie.

## 1. Each man's lie: found, when, and what tipped me off

**The Jabber — fake shoulder drop, the beat after he backed off. FOUND, V1, learned from the ledger at the R1 bell.**
The first two shoulder tells were true (R1b1 step in + cross, R1b2 back off + cross). R1b3 showed shoulder and was a
FAKE (he threw a plain jab), R1b5 showed shoulder and was a FAKE (body jab, then a step in and body cross). The bell
ledger said it plainly: "rear shoulder drop 4 (true 2, fake 2: **all the beat after he backed off**)". From R2b2 on I
read every shoulder shown after one of his back-offs as a lie — and it fired every time (R2b2, R2b4, R2b5, R3b3, R3b4,
all fakes). It was the LEDGER that taught me, not the beat story: the fakes hid four different things (jab, body jab,
feint + back off, a plain wait), so nothing in the beat itself gave the rule away.

**The Slugger — fake shoulder drop, the beat after I landed on him. FOUND, V2, caught it in the beat itself.**
R1b4 showed shoulder; he stepped in and threw a lead uppercut AND a rear uppercut — 7 damage — because my high rear
could not cover the under line. The tool said the truth would have been the knees cue. I wrote down "he lied right
after I scored (R1b3 jab)", and the R1 bell ledger confirmed: "rear shoulder drop 2 (true 1, fake 1: **it the beat
after you landed on him**)". I then used it: after my R3b3 hook landed, his R3b4 shoulder was a fake (truth: a quiet
step-in hold), and I covered low-low and took nothing. This one was caught from the BEAT STORY (the damage pattern)
and confirmed by the ledger.

**The Body Snatcher — fake knees bend, the beat after I blocked one of his punches. FOUND, V3, from the ledger at the
R1 bell.** R1b2 showed knees and was a FAKE (truth: a step in + feint), R1b4 showed knees and was a FAKE (truth: the
back foot — he clinched me). The R1 ledger: "knees bend 4 (true 2, fake 2: **all the beat after you blocked one of
his punches**)". I used it from R2b3 on (R2b3, R2b5, R3b4 all fakes, each after a blocked punch). Two of my
predictions failed, and the failures taught me the extra rule: after I blocked his body cross at R2b5, the R2b6 knees
tell was TRUE (body hook), and after I blocked his body cross at R3b5, the R3b6 knees tell was TRUE. Reading
`tells.mjs` after the bouts explains it: a lie only fires when the fake cue threatens more than the real beat, and a
body punch already shows knees — so after a blocked punch, knees is a fake only when his real beat is *lighter*
(a step in, a back off, a clinch, a plain punch). The ledger's phrasing is right but the cap is invisible to the
player.

## 2. A caught lie: the gap it left

**Where the gap was hittable: V2 R3b4 (Slugger).** His shoulder was a lie (my R3b3 hook had landed), the truth was a
quiet step-in hold. I covered lead low + rear low, took zero damage, and the round stayed mine. Caught lie, no big
punch behind it, gap closed — exactly what the design intended.

**Where the gap was NOT usable, and it cost me: V2 R1b4 (Slugger).** I caught the lie in the beat — shoulder shown,
truth knees — but "lighter than shoulder" still allowed a step in plus a DOUBLE UPPERCUT for 7 damage. My high-high
guard was wrong for the under line and I never saw the uppercuts coming until they landed. Catching the lie told me
there was no big rear punch; it did not tell me the real beat was weak.

**Where the gap existed but I chose the wrong line: V1 R2b2 (Jabber).** Lie caught (back-off preceded), but the
hidden beat was a body jab, a step in and a body cross. I covered high-high, ate 3 and lost the round. The lie was
readable; what it hid was not guessable from the cue.

**The Snatcher's lies left a different gap — the clinch.** V3 R1b4: knees was a lie, truth back foot, he clinched
and my hook was wiped out for nothing. V3 R3b4: same shape, I took no damage but he gained 2 stamina. Both times
the honest response (a push) was available and I did not use it.

## 3. Is a beat with a tell still a decision, or a sum with one right answer?

**Better than version 1, but uneven across the three men.** In version 1 the Jabber's honest shoulder turned the
Slugger bout into a table (my own T2 R2 report). In version 2 the beat has two decisions stacked: (a) is the cue
true or is the man's rule firing, and (b) which line do I close against the real beat. Against the Jabber and the
Snatcher that is a real decision — the lie's content varies (jab, body jab, feint, clinch, back off, wait), so even
knowing the rule leaves a read. Against the **Slugger it is still a sum for most of the bout**: his lie fires only
after I land a punch, I landed four in eighteen beats, so most shoulder tells were true and each one had one answer
(cover high-high). He is the version-1 problem again, just rarer. Also new and good: the back-foot cue splits the old
"quiet" into two distinct meanings, so the cue set no longer collapses.

## 4. The back-foot cue and the quiet guard

**Both are clear and immediately usable.** "His weight sits on his back foot" = a back off or a clinch, and it read
true every time it mattered: V2 R1b1 (back off + jab, both of mine blocked), V2 R2b6 (back off, my push was a shove
at nothing — my own error, he was not Inside), V3 R2b3 (back off, the lie I predicted was true and cost me a blocked
bjab). "A quiet guard" = none of the others, and it always meant a plain lead punch or a feint: Jabber R3b5 (jab),
Slugger R1b3 (lead hook), R2b5 (feint + step in), Snatcher R1b3 (lead hook). No confusion all bout.

**The clinch still surprised me, twice, and both were the Snatcher.** V3 R1b4 and V3 R3b4: knees shown, truth the
back foot, he tied me up before I could act. The cue *does* say "back off or a clinch", so the information was on
screen — but a caught knees-lie points you at body/uppercut lines, and the clinch arrives on the line you are not
covering. I never pushed in answer to a back-foot tell. That is a learnable read, but it cost me a wiped punch and a
free 2 stamina for him, and the tool does not highlight the clinch until it has already happened.

## 5. SCORES (1-10), version 2 beside my version 1 tells scores

| | FUN | DEPTH | CLARITY | VARIETY |
|---|---|---|---|---|
| **V2 tells (this round)** | 7 | 8 | 8 | 7 |
| **V1 tells (last round)** | 8 | 7 | 7 | 7 |

- **FUN 7 (was 8):** catching a lie still feels good (V3 R2b3, V2 R3b4), and all three bouts went to the last beat.
  But I played this round very defensively — 11 punches landed on me across three bouts — and long stretches were
  "cover the two promised lines", which is satisfying once and repetitive across beats. The v1 Jabber bout had more
  attacking variety.
- **DEPTH 8 (was 7):** three distinct lie rules, the bluff-only cap (a lie only when the fake threatens more than
  the truth), the split quiet cue, and the stamina cost of a fake — more layers, and I used every one.
- **CLARITY 8 (was 7):** cue meanings are plain, the true/fake line after every beat teaches fast, and the ledger's
  "when each fake came" is the single best change — it taught the Jabber's and Snatcher's rules in one round.
- **VARIETY 7 (was 7):** three different men to read, but the Slugger's 2-fake bout flattens his half, and the beats
  still funnel into cover-the-lines.

## 6. TO REACH 10/10 for the tells (most important first, each tied to a beat)

1. **Give the Slugger a second, on-screen lie condition so a defensive player still gets lied to.** His rule fires
   only after *I* land a punch; I landed 4 in 18 beats and he lied 2 times (V2 R1b4, R3b4). Between those, every
   shoulder tell was a one-answer lookup (V2 R1b2, R1b6, R2b1...). One condition is not enough for the man who throws
   with both hands: add one tied to a state he reaches often — e.g. "when his stamina is 3 or less and he holds"
   (his v1 condition, still true of his style) or "after he backs off".
2. **Teach the bluff-only cap.** The ledger says WHEN a fake came but not that the real beat was *lighter* than the
   cue. V2 R1b4: I caught the Slugger's shoulder lie and still ate a 7-damage double uppercut, because the hidden
   truth (knees) is allowed to be a big beat. One line after a caught lie — "he showed more than he threw" plus the
   hidden cue's class (body/uppercut vs a step in/back off/clinch) — or rank the cues on the ledger so the player can
   see why some lies hide big punches.
3. **Pair the lie with the player's own open lines (my v1 ask #1).** The lie's content varies — Jabber R2b2 hid a
   body jab + body cross behind a shoulder fake, and no guard choice was safe (high ate the body, low ate the jab).
   If my panel showed my open lines per moment before I throw, a caught lie would turn into a punishable read instead
   of a coin flip between two guards.
4. **Warn the clinch.** V3 R1b4 and R3b4: a knees lie hid a back-foot clinch, my punch was wiped and he gained
   stamina. When the back foot is on screen at Inside, flash a "he ties you up" line (or a clinch-live icon) before
   the beat resolves, so the push answer is a reaction and not a memory.
5. **Remove the AI's empty beats.** V1 R1b1: my overhand fell short into his Long back-off. V2 R2b6: two shoves at
   nothing (his back off and my push, both Inside-only actions at Long). A back off or a push with nowhere to go
   teaches nothing and stalls the beat.
6. **Keep the bell ledger exactly as it is.** "knees 2 fakes, both the beat after you blocked one of his punches"
   is plain, honest, and it is what made the Snatcher's rule learnable in one round. It is the strongest part of
   version 2 and should not be traded for a tooltip.

**The stamina cost of a fake (feedback loop check):** it is visible and it works. The Jabber paid for four fakes in
round 2 and was on 1 stamina by R2b5, throwing nothing but waits; the Slugger went to 1 stamina after his R1b4 lie
and backed off rather than uppercut again; the Snatcher's five fakes left him on 2-3 stamina for whole stretches.
But his AI still does not know I read his cue, so the cost tired him without changing his plan toward me — the honest
Slugger stayed honest between his rare lies. A cost without a feedback loop is a timeout, not a duel.

**Mistakes I made, for the record:** in V2 R1b5 I sent `clinch` when I meant `push` (he backed off; the beat was
wasted and he gained stamina). In V3 R2b1 I predicted a Snatcher fake from a blocked punch across the round boundary
and the lie did not fire (his rule seems to reset at the bell, or the cap blocked it). Both are my errors, not the
tool's, and both are noted in the why files.

**Could NOT judge from words:** whether a body pose (knees, shoulder, weight on the back foot) reads at a glance in
3D; pace and time pressure; whether a human holds the ledger plus the last-three-beats card in their head (I wrote
mine down); sound.

---

## Where this round lands against the owner's question

Version 2 answers the round-1 asks in order: the lie rate is up (14 fakes in 54 tells, against 9 in 54 in my v1
bouts), every lie is a bluff tied to one visible state, the ledger says when each fake came, the front foot means
nothing Inside, and the back foot/quiet split removes the old free-information hole. The tells now make the game
*more* of a read and less of a sum — except against the Slugger, whose practical lie rate (2 in 18) is the one place
where version 2 still reads like version 1. Fix that one condition, teach the bluff cap, and the tells are ready for
the page.

ALLPLAY2B DONE
