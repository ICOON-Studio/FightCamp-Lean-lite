# S190 DIGEST - 2026-10-09/10 - LUDO FIRST: Ludo is the lead designer; 12 verdicts approved; first Ludo modules merged

## Operator rulings this session (verbatim)
- "i want you to prioritize the ludo , if we need to redesign everything to match its ideas do it , continue with ludo on this session and
  then evaluate our work against ludos propositions" -> D39 LUDO FIRST.
- "you communicate with ludo for design and mechanics he is your lead game and art designer assistant .i approve final verdicts" ->
  CLAUDE.md s8 (Ludo = lead game + art designer; every design/mechanics/art question goes to Ask Ludo; he approves verdicts on the board).
- "approve all, use ludo's cast" -> D40: V1-V12 (LUDO_EVALUATION_S190.md s6) + Ludo's cast replaces the D36 chapter-1 cast.
- "the ring and the 3d fight that we already have will be used right ?" -> yes: FightRealtime + the 3D ring stay (Ludo 4c: CHANGE, not NEW);
  Ludo's mock-ups are layout references, not an art-style change.
- PC: "remove the drive so windows cannot see it" -> disk 1 WD15EARS (D:) OFFLINE; "terminate amd app" + "remove it from startup" ->
  AMD Software stopped, tasks StartCN/StartCNBM/StartDVR disabled; "give it as txt" -> documents go out as .txt (memory).

## Ludo record (all verbatim in research)
- LUDO_ROUND4_S190.md: round 4 (one core loop: camp week Mon-Sat, fight-night single screen, gym layout, first-hour build order, merges),
  4b mock-ups `docs/previews/ludo_s190/01_gym_screen.png` + `02_fight_night_screen.png`, 4c migration plan onto our build, round 5 rulings on
  7 conflicts, round 6 hour-1 start.
- LUDO_FIRST_HOUR_S190.md: minute 0-60 timeline. LUDO_CAST_S190.md: Leo Vance, Malik Adebayo, Damian Cross, Tommy Perez, Ray Miller,
  Sal Barone, Hector Bravo (stats, traits, tells). LUDO_CORNER_TABLES_S190.md: stool state word + State x Tone, corner actions at 2 AP,
  COMPOSURE (V14).
- LUDO_EVALUATION_S190.md: the game vs Ludo's 20 propositions = 2 built / 15 partial / 3 missing, file:line evidence; s6 FINAL VERDICTS
  V1-V13 (V13 pending).

## What now works (merged)
| Commit | What |
|---|---|
| 593da823 | FLOORGAIN2B (Codex): first END DAY mid-visit opens the coach-day drawer, second confirms, BACK resumes; amber when the weight plan is off. coach_day_drawer_test 3 -> 0. Game-camera still OWED. |
| dd07c15d | LUDO-CORNER1 (Qwen): LudoCorner.gd + ludo_corner.json = V1+V2 rules, 170 checks, mutants caught. PURE - not wired. |
| (SPAR1A) | SparRead.gd (Arena PR #73): the fight-week spar panel's CompuBox numbers - feeds V5 lock one / sacrifice one. |

## Not merged / in flight at handover (they are the next session's)
- Codex LUDO-PAD1 (sol; wt E:/FightCamp/wt/LUDOPAD1, branch codex/ludo-pad1) - V8 pad chains in the live fight behind `pad_chains` OFF.
- Qwen LUDO-TRAP1 (wt E:/FightCamp/wt/LUDOTRAP1, branch qwen/ludo-trap1) - V11 promoter's trap, pure.
- Arena LUDO-TELLS1 (chat 01a1227e-408a-7086-98c7-49fcb8bcb16c) - V4 named tells, pure; add Ludo's authored Perez/Miller tells after.
- Cursor PLAYUI1E (wt E:/FightCamp/wt/PLAYUI1, branch cursor/playui1) - 4th send-back: PLAYUI1D fit 1080 by deleting the numbers;
  now icon chips + UIKit.tip. Merge only when still 50 shows every price/effect AND nothing clips.
- Board: Q-S189-2 (V13 hour-1 start) and Q-S189-3 (V14 composure) wait for the operator.

## Next (decision, in order)
Collect the four runs; brief LUDO-CORNER2 (wire LudoCorner + composure into the live corner/FightRealtime, Codex after PAD1); LUDO-HUD1
(Ludo's fight HUD, Cursor after PLAYUI1E); LUDO-CUT3 weigh-in roulette into the live engine; LUDO-DOC1 doctor + Cut-Prone scar;
LUDO-WEEK1 week-4 cadence; LUDO-HOUR1 after V13 approval. Game-camera stills owed: FLOORGAIN2 week review + the coach-day drawer.
