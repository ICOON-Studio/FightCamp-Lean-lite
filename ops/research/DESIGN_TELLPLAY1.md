# DESIGN_TELLPLAY1 - a tell changes how the opponent fights (S543, the TELLPLAY1 worker)

Brief: `ops/research/TASK_TELLPLAY1.md`. Scope: `ops/research/TELLPLAY_SCOPE_S543.md`. Before: `docs/TURNPROBE18_RESULT.md`.
Probe: `tools/tellplay1_probe.gd` + `tools/tellplay1_rules.gd` (the flagged local copies), tables `tools/tellplay1_sum.py`.
Nothing under scripts/ or tests/ changes. Every code claim below was opened today (S543).

## 1. What the code does today

**How the opponent's next game is chosen.** `Exchanges.next_mode` (`scripts/rules/Exchanges.gd:269-308`): hurt -> "hurt";
an empty tank (energy < `OPP_TIRED` 45) -> "tiring" at 0.75; a weakness containing "fades" -> "tiring" at 0.5 from round 3
(l.276); "slow to start" -> "counter" for round 1's first two exchanges (l.278); else keep the last game at `KEEP` 0.6 (at most
`MAX_RUN` 3 in a row); else roll the style's weights (`MODE_I`/`MODE_V`, l.169-190), with "walks in" adding +0.3 to press
(l.292) and each weight multiplied by `bias[game]` (l.294-295). **The bias** is a dict game -> multiplier. Its only source is
`RingDuel.mode_bias` (`scripts/state/RingDuel.gd:82-94`): the games of the place the opponent does best at (`Duels.best_place`)
get 1 + ring IQ/100; it is cached on `f.bout.mode_bias` for the bout. The live bout passes it at the first bell
(`LiveRound.gd:85-86`) and every exchange through `RingDuel.step_bias` (`RingDuel.gd:71-78`, l.413-414: plus the ring cut,
`PlaceEdge` and `StepWrong`). The read passes the same `mode_bias` to `BoutRead._games` (`BoutRead.gd:278-296`, called at l.326),
which rolls `next_mode` 300 rounds with seed 387 and gives only the style and "walks in" (l.280). Nothing reads the weapon,
and no weakness but "walks in", "fades" and "slow to start".

**What a weapon and a weakness change today.** `RoundStyle.from_opponent` (`RoundStyle.gd:55-91`): the weapon moves the
opponent's punch mix ("body" -> Body hook at full rating, "hook" -> Lead hook, "right"/"cross"/"straight" -> Cross,
"everything" -> all 0.8); `AttrGen.attrs_of` shapes his attributes from the words. A body-punch weapon raises the body-shot
share against our boxer to `BODY_THREAT_SHARE` 0.35 (`BoutRead.gd:329-330`). The weakness: "fades" -> the late tiring game and
`BoutRules.OPP_FADE` in the last round (`BoutRead.gd:339-340`, `LiveRound.gd:72-73`); "walks in" -> +0.3 press weight;
"slow to start" -> round 1's counter game; a chin weakness -> the chin in the profile. None of them makes the opponent play the
situation `OppFile` maps them to (`OppFile.gd:33-60`, the fourth column) more often - except "walks in" (press) and "fades".

**Where the plan's line is read and how often it fires.** In the read, `BoutRead._game_edge_of` (l.231-252) adds the corner
call and the habits per situation; for "tiring" and "she_tired" it also adds the line at `PLAN_REACH x PLAN_CARRY` = 0.75 x
1.9 = 1.425 of its `LineGrade.edge` (l.247-248) **in every tiring exchange, with no fire share**. The other situations' lines
go through `PlanChain.walk` (l.378) at `PLAN_CARRY` 1.9 x the chance she stands on the line's card, exchange by exchange. So a
line's worth = its edge x how often its situation comes up x how often she is on its card. The mix share is the lever the tell
never moves.

**Tells with no situation** (out of this task): "Leaves the chin open" / "chin" (OppFile: the straight right; RoundStyle: a
lower chin in his profile; the knockdown and hurt rolls read it), "Slow to start" / "gives away round 1" (call let_go, no
situation; next_mode plays round 1's first two exchanges as counter), "drops the right" (a counter-left cue; no code reads it
in the ring beyond the habit HabitBeats words), "stands still after" (a cue only), "Stops people" (no WEAPON_ANSWERS row
matches: no answer, no situation), "everything" (none by design).

## 2. The two rules (flagged local copies, `tools/tellplay1_rules.gd`)

**A. THE TELL PLAYS.** For each tell (weapon, weakness) whose OppFile situation is press, range, counter or loadup, that game's
weight in the bias is multiplied so its share of the mix becomes max(1.5 x share, share + 10 points) (cap 85%), solved on
`BoutRead._games`' own dice (the same bias the live bout reads, so the read and the ring play the same mix). A situation named
by both tells is raised once (two tells confirm one game; they do not double it). The tiring situation is left to rule B:
`next_mode` already plays the fade. In the live bout the probe writes that bias to `f.bout.mode_bias` before the first bell,
the cache `RingDuel.mode_bias` returns all bout, so `step_bias`'s ring-cut, place and step layers still apply on top.
Real-world reason: a scout's "body puncher" is a man who comes forward to land it (a body puncher must close the distance); a
"big right hand" is a man who sits down and loads it; "counters over the jab" waits for you to lead; a "long jab" boxes at
range. Coaches tape what a man DOES most, so the tell is a frequency, not only a punch weight.

**B. THE FADE ANSWER UNDER THE CAP.** Two candidates, both probed: (i) "chain" - the tiring line walks the card chain at its
fire share like the other situations (`tiring` out of `_game_edge_of`'s line term and out of `walk`'s skip list); (ii) "carry:x"
- the tiring line read at x instead of 1.425. The choice: the smallest change that brings the best fade line to 10 or less AND
whose gain the real bout agrees with (bar 5). Rule B has no ring side: the live bout's fade answer is what it is today.

**The mirror (ProRead).** Rule A here writes the OPPONENT's `mode_bias` only. The pro corner reading OUR boxer (`ProReadWire`)
is untouched; the rule as written would not apply to our boxer, and must not in this task.

## 3. Where the player sees it

| Screen | Shows today (source) | Line it gains |
|---|---|---|
| Film panel (camp film, `FilmEdge.rows`, `OppFileCard.gd`) | each found tell: what it is, the counter words, the corner call (`OppFile.tells`) | "Plays this more: presses more than his style (body puncher)" - the game and its share before -> after |
| Opponent's file (`OppFileCard.gd`, `MatchupCards.gd`) | Game (style's main game), Best weapon, the weakness, the mode tells with how often film shows them | under the weapon / weakness: "His game: pressing 30% -> 45% of the fight" |
| Plan board (`PlanPanel.gd`, `GamePlan.gd`) | the "when" arrows by situation, the coach's lines | on the situation a found tell names: "He does this more: about N of 24 exchanges" |
| Result's Why (`FightWhy.gd`, `ResultCause.gd`) | the situations fought, the best answer, wrong calls | "He pressed 11 of 24 exchanges, as the tape said; your line answered 8" |

## 4. Feedback loops

- Tell -> the opponent's mix -> the answering line fires more -> wins. One way: the file is fixed for the bout; nothing writes
  back. Cap: 10 points a line (bar 2).
- Zero-sum mix: a raised game takes share from the others, so lines on those fire less. The probe prints every file's mix on
  and off and STOPS if a game a style lives on (base weight 0.25 or more) falls under 5%.
- The coach's plan already answers the style's main game; rule A raises the usual plan too where the tell names that game
  (bar 6 checks the population moves under 2 points).
- No loop through ProRead (not changed) or through the film count (a found tell's `FILM_PER_ANSWER` is unchanged).
- One-rep trial run first (done before the bars: Lucy Jackson, six Boxer-puncher files; see the result page).

## 5. The bars (written before any full run; never loosened)

All points of win chance, the 4-round debut card, the same-rated man (DebutOpp gap 0), week 4, coach 58 unless named.
"Gain" = the read with the coach's plan + one line minus the read with the coach's plan.
1. THE PLAYER'S LINE PAYS: for a type, a situation passes when the median over the files whose weapon or weakness maps there of
   the best line in that situation is 3 or more. A type passes with 4 of the 5 situations. PASS: 6 of 10 types.
2. NEVER A WIN BUTTON: no line adds more than 10 for any type against any file (rules on).
3. THE WRONG LINE COSTS: per type, the median over the files with a tell of the worst line in a tell's situation is -2 or
   lower. PASS: 6 of 10 types (the same count as bar 1).
4. THE FILE MUST BE READ: per type, no one line (move + situation) is the best line on more than 90 of the 180 files.
5. THE READ IS THE FIGHT: per situation, pooled over types and the bout files, the mean real-bout gain of the read's best line
   (n paired bouts, line on and off, rule A on) is within 3 points of the mean read gain on those same files; 2 standard errors
   printed (the bout is sized so 2 SE is under 1.5 points).
6. THE GAME DID NOT MOVE: real bouts on the coach's plan, rule A off and on, paired dice: the population's mean win rate moves
   under 2 points and no boxer-style x opponent-style cell more than 6.
7. THE COACH STILL MATTERS: bar 1-4's table at coach 40, 58 and 75 (no bar).
