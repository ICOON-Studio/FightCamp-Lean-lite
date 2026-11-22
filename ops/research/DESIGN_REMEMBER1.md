# REMEMBER1 - one opponent who remembers: design map v1, from the code (S537, DEPTH35 change 5)

Source: DEPTH_AUDIT_S534.md part 4 change 5, DEPTH_SCOPE_S534.md row 5. Bar (owner S534): the lever is probed on a greybox
BEFORE the critics; then 8+ DEPTH and 8+ PLAY from two fresh critics. Probe: tools/remember_probe.gd, result
docs/REMEMBER1_RESULT.md. **Read section 6 first: the probe's verdict decides whether this map goes to critics.**

## 1. What the game does today (CODE)
| Claim | Where |
|---|---|
| A professional's opponent studies her last two pro bouts and waits for the combination fired most | scripts/rules/ProRead.gd:18-61 (`target`) |
| Amateurs and the debut are never read: no pro bout on the tape = no target; the first bell clears the read for an amateur bout | scripts/rules/ProRead.gd:24-25, scripts/state/ProReadWire.gd:29-33 (`open`) |
| The price: a planned, fired use of the read line loses 6 points of that exchange's edge | scripts/state/ProReadWire.gd:15 (`READ_EDGE`), :39-43 (`edge`) |
| A second line held Sharp or Signature and fired 80% as often splits the read: the corner alternates round by round, half price | scripts/rules/ProRead.gd:5, :9, :46-56, :64-71, :84-85 |
| A "feint" line in the plan makes half of the read uses cost nothing | scripts/rules/ProRead.gd:6-7, :80-81, scripts/state/ProReadWire.gd:34 |
| The tape is written when a pro bout ends (fired combinations; how the read line did) and keeps 4 bouts | scripts/state/ProReadWire.gd:16, :47, scripts/state/BoutFinish.gd:68 |
| The read opens at the first bell | scripts/state/BoutNight.gd:75 |
| The player is told: "Their corner will wait for your <line>" on Fight prep and on her own analysis page | scripts/rules/ProRead.gd:115-122, scripts/ui/FightPrep.gd:212, scripts/ui/FightAnalysisOwn.gd:193 |
| READ-PROOF season chip: beat the read in two pro fights running | scripts/rules/ProRead.gd:90-112, scripts/state/ProReadWire.gd:91, scripts/ui/FightPrep.gd:215 |
| A second, in-fight read exists as bout keys only (no screen): a line the corner "covers" earns its edge x the cover, and two answers to it (`set_up`, `wait_cost`) | scripts/rules/ReadBack.gd:16-30 |
| The game knows a rematch and keeps what was found about an opponent for it | scripts/rules/BoutSheet.gd:147 (`rematch`), scripts/rules/OppFile.gd:174 (`remember`), :192 (`history`) |
| Every rival has a bout-by-bout past, ours included | scripts/rules/RivalPast.gd:25, :48 |
| Named rivals and their gyms | scripts/state/Data.gd:71-80 (`OPPONENTS`), :88-103 (`RIVALS`), :173 (`DIVISION_RIVALS`) |

Measured before this map: READ1 (docs/READ1_RESULT.md, pro, 4 rounds, one boxer): the careless plan loses 5.8 wins in 100;
the split costs 2.5 and the feint 3.3 against their own unread rows; changing the plan costs 0 against its own row but that
plan is 5 lower to begin with. READBACK1 (docs/READBACK1_RESULT.md, the in-fight read): dropping the line wins back 0.7 of
7.0, swapping 0.0; the best rule tried (`wait_cost` 1.5) 3.7 of 7.0.

## 2. The rule proposed
1. **A rival gym's corner remembers.** When our boxer meets a boxer she has met before, or a boxer from a named rival gym
   that has already cornered against her, that corner brings the pro read: the combination she fired most in her last
   two bouts against that gym (`ProRead.target` on a per-gym tape), at the same price (`READ_EDGE`).
   First meetings and strangers are never read: the amateur week stays what it is.
2. **On the ladder** (after the small living world): the mandatory challenger's corner reads her last two bouts whoever
   they were against. Design only until the ladder is built.
3. **The player is told a week ahead** (the same sentence the pro sees) and has five answers, each with a price:
   - *The same plan again* - free; pays the read.
   - *Leave the line at home* - free; loses her most-used line.
   - *A new line for the rematch* - pad nights (two to three weeks for a new combination to be Usable).
   - *A second weapon* - pad nights to bring her other line to Sharp: the corner must split.
   - *Feint off it* - a plan slot for the feint line.
   Second weapon and feint stack (the code already multiplies them: half the uses at half price).
4. **What it does to the season:** a plan that beat this gym last month is the risky plan this month; the tape of the
   last two bouts is something the player manages (what she shows in an easy fight is what the rival waits for).

## 3. Why these answers and not READBACK1's
READBACK1's drop and swap fail because the in-fight read arrives after round 1 with no time to learn anything. A rival
who remembers is known a week or more before the bell, so pad time can answer it. The counters are today's ProRead rules;
nothing new has to be invented for the fight. The probe measures them in amateur bouts, on four different boxers, each
against her own unread row and against the careless plan.

## 4. Where it is shown and wired (one row per menu)
| Menu | What appears | Wired to |
|---|---|---|
| Fights > offer card | "Rematch: Dale Youth's corner has seen her twice" | `BoutSheet.rematch` + the per-gym tape |
| Fights > Fight prep (scripts/ui/FightPrep.gd:212) | "Their corner will wait for your 1-1" + the five answers with their prices | `ProReadWire.words` reading the gym tape |
| Fighters > Playbook, the plan chart | the read line marked; a second Sharp line shows "splits their read" | `ProRead.target` (`split`) |
| Training > "Learn on the pads" | "Sharp by the rematch: Wed week 2" on the second weapon's card | `PadWeek.project` |
| Fight night, the corner minute | "They are waiting for the 1-1" when a read use loses | the exchange's read share |
| After the fight, the Why (scripts/ui/FightAnalysisOwn.gd:193) | "Read: 1-1 thrown 9 times, 3 won" and what the next corner will wait for | `ProReadWire.close` rows on the gym tape |
| Opponent file, rival's page | "Has cornered against Lucy: 2 bouts" under her past | `RivalPast` rows with `ours` |

## 5. Build notes (not built by this task)
- `ProReadWire.open` gates on `bout.pro`: the amateur route needs its own gate (a rematch or a rival gym with a tape) and a
  per-gym tape beside `pro_tape`. `ProRead.gd` itself needs no change.
- The first 30 seconds of round 1 are fought inside "start" before a probe can set the read; in the game the read is set in
  `open`, before them.

## 6. The probe's verdict
FAIL on two bars of four (S537): the read takes 2.5 wins in 100 in a 3-round rematch (needs 3), and "learn a new best line" is the best answer in 8 pairings of 10 (it beats even the unread plan). The counter bar passes: second weapon + feint stacked wins back 2.47 of 2.53. Not sent to critics. What a v2 must change (read size, a full book, the line that WON most): docs/REMEMBER1_RESULT.md.

## 7. The 10/10 target
- The read costs a careless player 4 to 7 wins in 100 in a rematch and nothing in a first meeting.
- No answer is right in more than 6 pairings of 10: against one rival the new line wins, against another the second weapon,
  against a third keeping the line is still best because nothing else she owns answers that game.
- The best answer wins back at least half of what the read takes, and the player can see why on the Why page.
- The tape is a thing to manage: an easy fight is a chance to show the rival's scouts the wrong line.
- One golden-path test: win with a line, book the rematch, read the sentence, bring the second line to Sharp, watch the
  corner split.
