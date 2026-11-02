# TASK_J37 — JOHN — WHAT STOPS A STANDING FIGHT, WITH THE NUMBERS

**Owner:** John, research specialist
**No checkout, no shell, no Godot.** Reply in chat with the full text, then drop
`J37_THE_STANDING_STOPPAGE.md` + `CLAUDE_LAND_NOTE_J37.md` into `_john_delivery/`
and send the mailbox ping — the way J36 went.

## Why this, and it is the top item on your own NOT-EVIDENCED list

J36 landed, and against the key inventory it flipped K70's claim to STRONGER:
`PostFightRead`, `ScorecardRead`, `FightStoppageRead` and `FightTrauma` already
hold the causation data plane. Then you listed what is still not evidenced, and
the first item was:

> **standing-TKO consumer that ends fights**

`FightStoppageRead.gd` (175 lines) COMPUTES `unanswered`, `shocks_in_window`,
`knockdowns_in_window`, `head_condition`, `severity`, `action`. **Nothing consumes
those to stop a man on his feet.** Before anyone builds that consumer, it needs
the thing this project requires of every realism rule: **a real study, a real
number and a range**, printed beside the rule — never a threshold somebody
picked.

## The question

**What criterion do real referees and commissions use to stop a STANDING fight,
and where does a number exist?**

Cover, with sources:

1. **The "intelligently defending himself" standard** — whose rule text, which
   sanctioning bodies (ABC Unified Rules, BBBofC, JBC, WBC medical), and what
   the referee is instructed to look for. Quote the rule text where it exists.
2. **UNANSWERED STRIKES.** Is there any documented count — "N unanswered" — in a
   rulebook, a referee training manual (e.g. ABC referee certification, Herb
   Dean / John McCarthy material), or a published study? If the number exists
   only as folklore, SAY SO and label it INFERENCE.
3. **THE WINDOW.** Over what duration are "unanswered" strikes counted before a
   stoppage becomes likely — seconds, or a continuous exchange? Any study that
   timed standing TKO stoppages from the first unanswered strike to the wave-off.
4. **WHAT THE REFEREE ACTUALLY DOES FIRST.** Position change, verbal warning
   ("show me something"), stepping in — is there a documented sequence? This is
   the engine's `action` field and it wants a ladder.
5. **STANDING TKO RATE.** What share of TKOs are standing stoppages versus
   knockdown-led, in boxing and in MMA separately. J20's 63.5% conditional-finish
   anchor and the 3.9% knockdown rate are already on record — cite them by name
   rather than re-deriving them, and say what is NEW here.
6. **THE DOCTOR AND THE CORNER.** K64 already has doctor stoppage at 1.09%; cite
   it. What is the corner-retirement rate, and is there a study on WHEN corners
   pull a fighter (between rounds versus mid-round)?

## Label everything

**MEASURED** (a study or a rulebook — name it, give the number and the range) /
**INFERENCE** / **NOT FOUND**. A NOT FOUND is a finding; do not fill it from
memory. Distinguish *"a study measured this"* from *"a rulebook says this"* from
*"referees are trained to do this"* — only the first two can gate a test.

## THE TRAP

**Turning a training instruction into a number.** "The referee looks for three
unanswered" is a coaching heuristic unless a rulebook or a study says so. If the
only source is a seminar quote, it goes in as INFERENCE with the quote, not as a
threshold. **Second trap:** conflating boxing and MMA. The standing stoppage is
common in MMA (ground-and-pound aside, a standing wave-off is a distinct event)
and rarer in boxing; keep the two columns apart.

## The one judgement I want

At the end: **the smallest rule — one sentence, one number, one window — that a
`FightStoppageRead` consumer could be built and TESTED against**, with its source
and its range beside it. If the honest answer is that no such number exists in
the literature, say that plainly and give the two INFERENCE candidates you would
put to the operator.

## Deliver

Reply in chat with the full text of `J37_THE_STANDING_STOPPAGE.md`. Claude lands
it and writes your HANDOFF block — you never edit `HANDOFF.md`.
