# S531 digest (2026-11-20, Opus, long session; the owner's game held RAM at 85-97% most of the day)

## Built
- GROWTH (owner Q-277 "Careful gym grows", Q-278 "Yes, build the loan"): the FIT-OUT LOAN. Club > Money, bigger premises card:
  "Move" ($12,000 cash) beside "Move on a loan" ($3,000 down, $750 a month x 12, paid with the bills as $173 a week for 52
  weeks, one loan at a time). The Money page's week costs show "Fit-out loan -$173" on its own line; the members tile says
  WHY members stop (premises / kit / coaches, GymSpend.room_line). tests/fitout_loan_test.gd PASS. Verified on the probe:
  GROWLOAN 36/60 moved, members 140, cash $6,405 (vs $4,605 cash-only), 0 closed. Stills on the review board.
- STEPS phase 5a: a step's deny reaches the duel before the exchange is settled (StepWire.deny_edge).
- ANIM (owner's Fable session): guard in front of the face, nobody punches from out of reach, smoother hit reactions
  (head jumps 14 -> 7 on film 15).

## Read / decided
- GYMSURVIVE1 (180 careers): a passive gym closes ~week 64; a careful gym survives but loses ~$3.5k a year, members flat at 66 -
  the $12k move was the wall -> the loan.
- TURNGAP1 rerun (seed fix): debut gap -4 35.5% .. 0..+2 ~79% .. +8 96.5%; both houses give ~79% today.
- Code Mode (experimental, terminal only): -44% / -41% / -23% cost on our read work, same answers
  (ops/research/CODEMODE_TEST_S531.md, launcher ops/Tools/claude_cm.ps1).
- Critics: Dola LEDGER v5 8/8, TURNPRO v5 7/8 (Arena 5/5), KNOW_STAKES v3 6/7 (Arena 6/6).
- Goose KNOWREV4 #418 and TURNREV6 #420 finished with nothing pushed -> moved to Dola (SQ248, SQ249).

## Disk (owner: "free up space on e and c")
E: 24 -> 92.5 GB free (32 worktrees retired, 17.7 GB of old renders, temp files). C: 24 -> 43 GB free (Codex + Cursor data,
owner "Yes, delete them"). SIDE EFFECT: deleting %APPDATA%\Cursor removed the Cursor login the Grok bots wake with
(gbot_wake.mjs reads %APPDATA%\Cursor\auth.json): Kalli/John/Maria need the owner to run `cursor-agent login` once.

## In flight at handover
- TREEVALUE6 (PC probe, footwork steps re-read after 5a) - result -> docs/TREEVALUE6_RESULT.md + STEPS_SCOPE phase 5.
- Arena LOANCONTRACT1 (blind loan contract test, chat 01a1f8e9) and LEDGERCRITIC6A (contracts v5 critic).
- Dola SQ248 knowledge v4, SQ249 turning pro v6 (queued behind it).
- Grok bots queued (need the login): SQ246 Kalli contracts v5 critic, SQ247 Maria turning pro v5 critic, SQ250 John loan research.
- Qwen out until 8 Dec (owner Q-279). Ludo: not reached (Chrome extension dropped at 97% RAM) - give it the loan stills next.
