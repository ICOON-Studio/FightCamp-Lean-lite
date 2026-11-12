# R73DEAL1 blind review (REVIEW3, 2026-11-12) - PR 234, branch qwen/r73deal1 @ 626360e0

Verdict: **COLLECT WITH FIXES** (fixes below are uncommitted in this worktree, which was created for the review:
`git worktree add --detach E:/FightCamp/wt/LEAN_R73DEAL1 origin/pr234`, seeded with seed_godot_cache.ps1).
Seat: the brief named Arena; the dispatcher gave it to Qwen (qwen3-coder).

## a. Brief items (as delivered)
| Item | Status | Where (delivered file:line) |
|---|---|---|
| 1 pad places 2 per pads evening, 8 all pads | DONE | ClubDeal.gd:89-90 |
| 1 holder: can_hold (loyal, 6+ bouts), +1 to the pool | DONE | :22-23, :97-98 |
| 1 held place worth 0.7 **to whoever takes it** | WRONG | :97-98 + :142-143: the 9th place is dealt round-robin at its NTH value (usually 1.0) AND the holder's row gets +0.7 with no place behind it. A 9-place week summed 9.7 of value; the holder was paid for holding. |
| 1 NTH_VALUE 1,1,1,0.7,0.5, no 6th | DONE | :15, :103 |
| 1 counters in fighter-sessions | WRONG (small) | :103/:108: `asked` capped each ask at 5, so a boxer asking 6 shows asked 5 / short 0 on the counter while the row says short. |
| 2 class_cash reads DuesLevers.CLASS_WEEKLY; members_4w n x 0.25 | DONE | :27-33 |
| 3 mornings: 6 slots, pair same-session asks FIRST, 0.8 each, 2 covered | WRONG | :184-208: sessions are walked in dictionary order, so an unpaired session met first takes a slot before a pair; pairs are not first. |
| 5 deal mornings **in order**, one at a time round the order | MISSING | `_deal_mornings` never reads `order` for who goes first; it follows the fighters list. |
| 4 coach_order: first, short last week, fight week, nearest target, id | WRONG (partial) | :44-76: four buckets, each later key used only in the last bucket; two fight-week boxers were ordered by id, not by the nearer target. |
| 5 deal() return shape, causes short / full_week / held_pads | DONE | :156-162 |
| 5 covered never over owned | DONE, but by a clamp | :132 `mini(pad_covered, pad_owned)` made the 200-week assert unable to fail. |
| 6 coach_evenings via GymBills.runway_weeks, < 8 -> first "class" | DONE | :217-221 |
| 7 words() "Pad places: N asked, N covered, N short" | DONE | :225-227 |

| Required assert | Status |
|---|---|
| all pads 8; two class nights 4, cash from CLASS_WEEKLY, members 0.5 | DONE (test:49-71) |
| quiet week 10 on 8: covered 8 short 2; 200 seeded weeks covered <= owned | DONE, but the 200-week loop could not fail (module clamp, fixed evenings, no holder) |
| 4th/5th at 0.7/0.5, 6th never dealt | DONE |
| holder: 5 bouts adds nothing; 6 -> pool 9, held place 0.7, holding, held_pads | WRONG: `held_val >= 0.7` (test:154) passes for any holder with a pad |
| mornings: pair at 0.8 and 2 covered; six slots cover at most 12, only when all paired | MISSING (the "12" case was never built; test:177 asserts 6 with a message about 12) |
| Coach's order: first before fight week; short last week never short again | DONE but weak: `order.find("A") < order.find("B")` passes when A is MISSING (-1) |
| round-robin: 5 places, two boxers asking 4 -> 3 and 2 | WRONG: built 8 places and accepted 4+4 (test:201-224), so it can never see a greedy deal |
| coach_evenings 8 -> pads, 7 -> one class | DONE |
| causes exactly; words names asked/covered/short | WEAK: `has`, not exactly; words checked for the three words only |
| MUTANTS fail the SAME asserts | WRONG: each mutant had its own private comparison, not the round-robin / NTH asserts |

## b. Read, not retyped
CLASS_WEEKLY and runway_weeks are read (DuesLevers.gd:20, GymBills.gd:62). ASK constants are the brief's (CLUBWEEK 3.1).

## c. Mutants on the DELIVERED source (scratch copy, restored)
greedy deal caught (1 fail), flat NTH caught, shared morning at 1.0 caught, pair counted once caught, no held place caught,
runway 7 caught, **dropping `first` fighters from Coach's order NOT caught** (the -1 index passes `<`).
On the FIXED source: greedy, flat NTH, held place at NTH value, shared at 1.0, order flipped, no cascade, no cap,
no held place: all 8 caught.

## d. Words
"Pad places: ..." - no pronoun, no code name, no surname. Causes are code keys for Loyalty.gd (not shown).

## e. Files
Only the two OWNS files changed; no test deleted. ClubDeal.gd 234 lines delivered (213 fixed) < 320.

## Fixes made (uncommitted, this worktree)
scripts/rules/ClubDeal.gd
- :17-21 added `const SHARED_VALUE := 0.8` and `const HELD_VALUE := 0.7` (the two values as named constants).
- coach_order (was :38-77, four buckets): one `sort_custom` with the cascading key first > short_last_week > fight_week >
  nearest target_day (-1 last) > id.
- deal (was :82-162): `asked` = the raw asks (was capped at 5); the pool is dealt one place at a time round the order
  with a rotating index; the LAST place of a held pool is the held place, worth HELD_VALUE to whoever takes it and never
  to the holder (was: dealt at NTH value AND +0.7 added to the holder, :142-143 removed); `pad_covered` is no longer
  clamped to owned (was :132).
- _deal_mornings (was :166-213): pairs of two DIFFERENT fighters on the same session are built first, dealt one slot
  at a time round the order, then the unpaired asks round the order (was: dictionary order, singles before pairs, order
  ignored).
tests/club_deal_test.gd (each new assert names the defect it catches; "REVIEW3" comments)
- quiet week: `words(r) == "Pad places: 10 asked, 8 covered, 2 short"` exactly.
- 200 seeded weeks: evenings and a holder vary; asserts covered <= owned, <= asked, rows sum to covered, no 6th place,
  mornings covered <= 12 and <= asked.
- 6th ask: asked 8, short 1, the row short.
- holder: covered 9; the taker of the held place has 3 places worth 2.7; the holder and B worth 3.0 (no extra 0.7);
  5 bouts gives no held_pads cause. (Replaces `held_val >= 0.7`.)
- mornings: six shared sessions -> 12 covered; one pair + unpaired asks -> 7 (pairs first).
- Coach's order: A must be IN the order; two fight-week boxers -> C (14), B (20), A.
- round-robin: the brief's 5 places (two pad evenings + a held place), X and Y asking 4 -> exactly 3 and 2.
- causes: short rows have only "short", full rows only "full_week".
- mutants: greedy and flat now fail `_split_ok` / `_nth_ok`, the same helpers the real deal passes; their owned count
  comes from the real deal (holder included).

## Open for Claude (spec, not fixed)
- Round-robin vs SHORTWEEK1: a boxer short last week who asks 4 beside two asking 3 on 8 places is still short under
  pure round-robin, though someone else could be. The brief's assert passes only on a week built for it. Decide whether
  Coach's deal fills a short-last-week boxer's asks before the round-robin.
- "the holder's own evening is spent holding": the module reads it as "the holder cannot take the held place" and keeps
  the holder's own pad places. If holding should also cost the holder pad places, say so.

## Test runs (fixed worktree, Godot via godot_slot, Dummy audio)
- parse --check-only ClubDeal.gd, club_deal_test.gd: clean.
- club_deal_test: `CLUB_DEAL failures=0`, `MUTANT caught: greedy`, `MUTANT caught: flat value`.
- regression: `GYM_BILLS failures=0`, `DUES_WIRE failures=0`, `EVENINGS failures=0`, `FILE_LIMITS failures=0`.
