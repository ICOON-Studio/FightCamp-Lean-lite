# S454 handover (written 2026-11-13 at the end of S453; S452's handover is in git history)

OPEN IN E:\FightCamp\Lean. START: `git pull && python ops/Tools/agent_comms.py start`, then `python ops/Tools/where_we_are.py roll S454`.

## USAGE RULES (kept)
- Run `get_usage` first. Hand over at 420k context (operator S452: "the limit is 420k"); wrap-up from ~395k. At most TWO helper sessions.
- Never idle while a test or agent runs: run_in_background and do the next item.

## DONE IN S453 (his comments C365-C369)
- C365/C366 fight HUD maps: no organ pictures; head, ribs and liver each outlined in the hit colour, the count inside, BodyTip tooltip on
  hover (scripts/ui/RoundHits.gd, 5be5343a). Still on the review board.
- C367/C368 office: fighter cards are fixed 232 px columns (whole roster side by side), vertical bars Stamina / Mood / Rating / Ready
  (Ready = coach checks done, OfficeDesk._boxer). Look still: tools/office_still.gd (four made-up fighters; the game's own four = FOURSTART1).
- C369 hips: BoxerFootwork's leg-to-leg weight follows FighterLife's breath phase (plan.breath_of, set in BoxerBuild), not every bounce.
  He asked for Blender; the sway is procedural code, so it was tuned there - say so if he asks. Standoff film on the review board.
- PR 255 closed (STEPMASTERY1A was collected in S452). Seat answers committed (Kalli SQ64, John SQ63, Maria SQ68) and Dola SQ66 read.

## RUNNING (collect first)
- **Grok Dev BLOCKLOOK5B** (ops/research/TASK_BLOCKLOOK5B.md, sent 16:40, ETA ~22:30): round 2 on grok/blocklook5, PR 256 stays open.
  Round 1 was good EXCEPT block_meet `ROW A_B preview pro_left_jab`: the lead glove caught it at gy -0.094 (main: rear glove, -0.048).
  COLLECT BY COMPARING ROW LINES main vs branch, never the failure count (main's 10-11 CTRL_LANDED ruler rows move run to run).
  The hook MATCH rows fail identically on main (72/63/74/66 %), so printing them as informational until HOOKTAKES1 is accepted.
  Apply the diff (`git diff main...origin/grok/blocklook5 -- <files> | git apply`), tests block_catch/meet/absorb/set, beat_clips; film the block reel.
- **Dola SQ67** (COACHFIT v2): sent by hand in a NEW Cici chat. Read: `cd ops && python Tools/cici/cici.py read --out research/COACHFIT_CRITIC_S452_DOLA.md`
  (it is the whole raw transcript; the scores are near the end: grep "Score:").
- **John SQ65** (fight week v5): queued in the seat queue.

## CRITICS SO FAR (both maps below 7 -> next versions)
- Fight week v5: Kalli 6/6 (AMATEURWEEK_CRITIC_S451_KALLI.md), Dola 7/6 (AMATEURWEEK_CRITIC_S451_BRIEF_DOLA.md), John pending -> write v6 from their
  "To reach 10/10" lists once John lands, then fresh critics.
- COACHFIT v2: Maria 6/5 (COACHFIT_CRITIC_S452_BRIEF_MARIA.md), Dola pending -> v3. (John 6/6 was on v1.)

## NEXT (Claude)
1. POWER1D: read the "S453 findings" section of ops/research/TASK_POWER1D.md - three holders (PunchReach's release pin, the carry hold
   against the clip tail's 12-14 cm shoulder lift, the guard place climbing to 1.57 after guard_home) and the next tries (a)-(c).
   One experiment (pin off + QUICK_BACK 0.10) gave 27 -> 24 and was reverted.
2. PROGBUILD1 step bars on screen (move tree on the Playbook + slot picker + fire gate together).
3. PROGPROBE1R3 to Goose.

## MIRO
Every call still errors ("connection state couldn't be read") with the connector listed. wwa.svg is ready via
`python ops/Tools/where_we_are.py svg` (its 16 data-deleted lines are approved, his S452 "yes delete the 16 stale miro cards"). One try,
then tell him once.

## WAITING ON HIM
- His look: the S453 HUD maps, the office cards, the hips film (review board); the S452 items still open there (office desktop, result tabs, camp v3).
- His ear: the voices, the PA mix.

## TRAPS (S453)
- block_meet's failure COUNT hides a block row going red: compare ROW lines.
- Still runs hide parse errors: pass `--log=<file>` to tools/hidden_desktop.py and grep SCRIPT ERROR.
- review_add.py takes `E:/...` paths, not `/e/...` (it skipped the file silently as "missing").
- Seat answers from Dola are raw transcripts; gbot `--file` is relative to ops/.
