# S150 digest - SCHED1 MY GYM, LADDER1 merged (+ record seeding, win streak), scene tree reviews, TRAIN1 (Claude, 2026-10-03)

Nightly read: 2026-10-02 at 86c8150f, 496 tests, 19 fail (AgentComms/nightly/latest.txt).

## What now works
- `agent_comms.py start` no longer crashes: roster.json's top-level `note` string broke the AGENTS list (cf7d6a42).
- SCHED1 part 1 (182b487a): the schedule opens on MY GYM. A NEXT UP card shows the next decision, the reason for it
  and one gold button. Below it, a week-by-week list of only the gym's own obligations: camp, promise, weigh-in,
  medical, contract, bout, monthly bill. Plain words, full names, money with commas, one action per row. A YOUR
  FIGHTERS panel shows bout status and the ladder line. World events stay on THE CARDS.
  - Switch `career.schedule_my_gym`: OFF = the six old tabs, unchanged.
  - Evidence: `schedule_my_gym_test` 30/30. Control: the month grid holds 14 WORLD items, MY GYM 0.
  - Stills `docs/previews/sched1/` opened: an empty gym says "sign your first fighter"; a booked club bout says
    "set camp"; Aiko Park, 20-8, reads INTERNATIONAL.
- LADDER1 merged (Cline 09024dfc -> bcfe2ca7, check_workflow 0 defects). The career level replaces the fame gate:
  5 net wins regional -> national, 7 more -> international. Offers are gated by level; a loss costs -1 progress and
  -12 ranking; international cards are offered by division rank.
- S150 fixes on LADDER1:
  - (a) An unsettled fighter now seeds his level from his record. In the real game a 20-8 pro read REGIONAL 0/5.
  - (b) A fighter's first ladder win is counted once. The record updates before the ladder settles.
  - (c) Operator: "make it so streak shorten this path". From the 3rd straight win, each win counts double
    (`career_ladder.json` streak_from 3 / bonus 1, INVENTED, labelled). An unbeaten fighter reaches national in 4.
  - Evidence: `venue_ladder_seed_test` (with a loss-reset control) and `career_ladder_test` green.
- Focused suite 28/28 (ladder, venue, offers, amateur, fight gate, grade ladder, first job/months, schedule).
- The scene tree is published as a commentable artifact: https://claude.ai/artifact/SDg2yhMWK1XgmWwrLZUzVV.

## Operator verdicts (verbatim)
- On the scene tree:
  - "this exists also in the staff room it is very confusing" (Schedule / Staff reached from many places)
  - "here it is again" (locker fight-week board -> Schedule)
  - "in this scene i want to be able to select the move i want to train , be able to preview it in animation , why we
    have training floor with no options to train"
  - "this needs also to be displayed in 2.5d the fighter training with the coach etc"
  - "the whole training selection scene needs revamping and modernazation , you have all tools to make it the
    strongest hub of the game after the 3d fight"
- "yes" to TRAIN1 before TUT1.
- "i also want other agents to provide their own scene-tree aspect nad review the current one".

## Findings
- Seen defects fixed the same session:
  - Capture doc lines passed `as_game` without `--`, so the game switches never turned on; the lines now say so.
  - `_my_gym_on` called an absolute get_node before the panel was in the tree (CareerRoot hands route args early).
- The DevJump world for a boxer has no same-sport world card within 5 weeks. Club bouts (amateur path) are how a young
  boxer gets booked, and the capture now uses that path.
- Claude's proposed navigation rule: one job per room object, one home room per screen, the rail as the shortcut.
  It waits on K85 / M41 / J61 before anything moves.

## Running at handover
- TRAIN1 slice 1 on Cline (02:10, out E:/FightCamp/wt/CLINE_TRAIN1_out.txt, branch cline/seat).
- Q213D on Codex (wt Q213C, branch codex/q213c; last commit 5e613215 00:52).
- MH2 on Codex (wt MH2, C223 production gate; last checkpoint a268d4bf 00:15).
- K85 / M41 / J61 LANDED before handover (files + previews committed, not yet acted on): K85 = the gym floor is the only
  hub, the rail opens 4 rooms, delete the 3 area pictures; M41 = 12 scenes -> 6 painted, training floor concept (mock art,
  cannot ship); J61 = the confusion is one screen under different names; Two Point's lectern is TRAIN1's shape.
- J60 John (free video generators).

## Next (decision)
1. Collect what lands: TRAIN1 (review the diff, run `station_move_picker_test` + the --only set, open the stills);
   K85 / M41 / J61 (read them whole); Q213C+D; MH2; J60.
2. From K85 / M41 / J61, apply the one-job-per-object cleanup:
   - the Locker room fight-week board opens the booked fighter's fight week;
   - the Staff room objects become board / hiring / that coach.
   Then TRAIN1 slice 2: the painted 2.5D floor with fighter + coach loops from M41's concept, progress bars and
   round-end floats.
3. TUT1 after TRAIN1. ROOMS25D rope fix on the first free seat.
