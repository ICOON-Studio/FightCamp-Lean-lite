# DESIGN CORNERBASE1 - three coaches in the other chair (S547; written BEFORE any run)

Task: `ops/research/TASK_CORNERBASE1.md`. A measurement: the coach's call lives in `tools/cornerbase1_rules.gd` beside the
probe's other local rules; nothing under scripts/ or tests/ changes. The eight fight commands are CORNERCMD2's, untouched.
No ring call in any arm (the reader is CORNERCMD2's `reader_nr`: the reader with the ring at Centre).

Real-corner study the FILE coach follows: `ops/research/J55_THE_CORNER_BETWEEN_ROUNDS.md` (section 2: one or two
instructions a minute - "two instructions maximum", savate survey S23; Warwick/England Boxing S22: settle and breathe,
health check, then the work-on). John's CORNERREAL1 answer (`CORNERREAL1_JOHN_JOHN.md`) is NOT on disk at writing (only the
brief `CORNERREAL1_JOHN.md`), so the order below is J55's: health (hurt) first, breath (tired) second, the work-on third.

## What every coach may read (and what none may)
Allowed - what the game shows the player's side: the opponent's style word on the file (free at booking:
`OppFile.tells` l.73-83, "how": "booking"), our boxer's wind at the bell (the round record's `energy.a_end`,
`LiveRound.gd` l.418) and whether she was hurt in the round (each exchange's `sit` = "she_hurt", `LiveRound.gd` l.156 /
`Exchanges.situation` l.194, which the round's clue line says; and `hurt_at_bell`, l.453). The probe's bouts are film 1 with
no tape session, so nothing else of the file is found (`OppFile.known` l.122: weapon, modes and weakness stay hidden).
NOT allowed: the exchange's `mode` before it is fought (the reader's edge), the opponent's `weak`/`threat` text, his rating,
the engine's next_mode roll.

## The table (one call a round, set in the corner; never changed by the exchange)

| Coach | Round 1 call (opening, `BoutNight._open` as CORNERCMD2's OPEN_CALL) | Each later corner (between rounds), first rule that holds |
|---|---|---|
| BLIND (control, arm `plan`) | `BoutRules.auto_corner(stats)` (l.383): "long" if technique > power, else "body" | the same call, every round (`BoutNight.gd` l.128) |
| FILE (arm `file`) | G = `OppFile.main_game(opp)` (l.113: the style's heaviest game in `Exchanges.STYLE_MODES`, l.156); call = `Exchanges.MODES[G].best` (l.124) | 1. hurt in the last round -> "hands" (Hands up, `CMD.hands.call`); 2. wind at the bell < 35 -> "calm" (Reset, `CMD.reset.call`); 3. else the round-1 call |
| FILE + SKILL r (arms `skill35`, `skill58`, `skill80`) | as FILE, but G is right with chance r / 100; when wrong he reads another game of the same style (the other three, weighted by `STYLE_MODES`) and calls that game's best | as FILE (wind and hurt are on screen: no skill needed) |

The cells' file games (STYLE_MODES): presser and fader -> press -> "long" (Jab and move); mover and the five Boxer-puncher
cells (slow, body, switch, favourite, underdog) -> range -> "body"; counter -> counter -> "lead"; loader (Slugger) ->
loadup -> "hands".

Decisions and why:
- WIND LINE 35 = `Exchanges.SHE_TIRED` (l.52), the line under which the engine itself fights her exchanges as "your boxer is
  tired" (best call: calm). CORNERCMD2's printed bells sit on both sides of it: PLAN ONLY 69 49 34 22 14 7 (Lucy) and
  56 23 1 0 0 0 (Samira) at 6 rounds; the reader 64 37 26 26 26 25. Feedback-loop cap: if FILE rests in more than half the
  rounds (rounds 2+), the line moves once to 25 (the reader's own floor) and the reason is written in the result.
- SKILL p = rating / 100. The game has no rule that turns a coach's rating into how often his read of an opponent is right
  (rating is read only by `CoachPlan.write` and `PlanBoard.arrow_limit`, `BoutNight.gd` l.199, l.211); CORNERCMD2's
  clamp((t - 30) / 50) was its own tuned local rule. Plain reading: a 58 coach reads the file right 58 times in 100.
  Rolls are paired: one roll per bout (seeded by boxer, cell, length and bout number, not by the rating), so an 80 coach
  is right in every bout a 58 coach is right in.
- The file read is made once, before the bout (the brief's FILE coach); he does not re-read from round 1. A coach who
  updates after round 1 is another arm, not built here.
- Calls are the game's own calls: their edge, wind cost and grade are the game's (`Exchanges.call_edge` l.255, `CALLS`
  costs), exactly as BLIND's. The sit-dependent wind fix CORNERCMD2 put on its commands (HONEST) applies to commands only.
- The plan's writer stays the 58 coach in every arm (`sc.coach`); the arm is the corner's call only.

## Arms of the run (ring out of all)
`plan` (BLIND), `file`, `skill35`, `skill58`, `skill80`, `reader_nr` (READER, eight commands), and the eight commands held
all bout `c:body` ... `c:get_out` (bar 8, bar 5, and "the best fixed": with the ring out a fixed PAIR has no ring half, so
the best fixed arm is the command held all bout with the highest all-cell mean per length, picked after the run).

## Stops written before the run
- Step 0: the copy with the coaches off reproduces CORNERCMD2 `full.jsonl` bout for bout (presser, 3 rounds, Lucy and
  Samira, 70 bouts, plan and reader) - else stop.
- One-rep trial (loader, Samira, 3 and 6 rounds, 20 bouts, all arms): stop if two arms print identical outcome strings
  (except skill arms that rolled right in every bout, which equal FILE by construction - checked by the roll count), or
  FILE < BLIND against the loader.
- FILE rests in over half the rounds 2+: move the line once (35 -> 25).
