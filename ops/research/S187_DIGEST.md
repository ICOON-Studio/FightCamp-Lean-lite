# S187 DIGEST - 2026-10-09 - playtest walk of the HUD2 game, UI defects fixed as found

Operator brief (verbatim): "during your walk i want you to identify possible improvements on the UI (like a proffesional
playtester)", then "fix issues as you find them". Board: "remove the current question from opsbord , we continue as it is decided
now and do changes along the way if necessary , put other questions if pending" - Q-S185-2 closed as decided; Q-S186-1/2/3 posted
(first-bout record, profile body, raw gain figure).

## What was walked (game camera, as_game hud2, hidden desktop)
- `docs/previews/s187_play_a` creation -> fight week (60 stills), `s187_play_b` creation -> first bout -> result (60),
  re-shoots after the fixes `s187_play_c` (bout) and `s187_play_d` (training week).
- The full list: `research/S187_PLAYTEST_UI.md` (16 defects D1-D16 with status, 16 improvements B1-B16).

## Fixed and pushed (each focused-tested; camera-checked in s187_play_c where the walk reaches it)
| Commit | Fix |
|---|---|
| b322910f | opponent never offered as his own sparring partner (D4); SIM TO RESULT dialog says "Sim to the result?" (D10); fight-night morning card no longer offers a training day; punch table "OF WHICH BODY" (D9); week review header names the reviewed week, no lone sparkline square, "Before the bill" chip (D12) |
| d4255c16 | camp chrome footer one word, clock label fits (part of D3) |
| a07c1510 | guide sees club program cards / camp as training (D7); day goal ticks only at the bell, week goal moves to the next move (D8); HUD2 cash refreshes after sign/hire (D2) |
| 16735957 | 14 market countries get a flag (D11); scorebug country from origin/born (D15); debut year leaves room for the record (D6); "Must make" on the opponent weigh-in plate (D16); "On weight already" (D14) |
| b782e155 | fighter gets today's stat baseline at signing + get_stat_changes oldest-snapshot fallback; `signing_stat_baseline_test` (red 2/5 without) |
| ed08e52c | striking-only tape drops WINS BY SUBMISSION; boxer card drops the grappling line (B6) |
| 63140819 | hire/sign cards show the runway: weekly wages+upkeep after the signature, weeks the cash covers before dues (B1) |
| 1982ebc0 and before | skipped bout-week day "trains nothing" (B16); week review clock drops the overlapping "WEEK"; fight night clock "BEFORE THE BELL" on the tape (B15) |

## The big finding - FLOORGAIN1 (NOT fixed, next session's first item)
**Club floor training never reaches the fighter's stats.** `GameState.file_visit` (~line 19256) adds the lived day's gains to
`athlete["floor_gains"]`; nothing in the game reads that key (`rg floor_gains` = the two writes). The profile shows "+10.4
technique" live, then it is dropped. That is why the week review says "Nobody trained this week" in every club week (camera
s187_play_d/56) and why a 4-week camp "built OVR 49 -> 49". A roster-fallback in WeekReviewPanel was tried and REVERTED
(it broke week_review_test's S183 rule and cannot fire while stats never move). The fix needs a scale decision: DayLap gains are
~+5/h raw (Q-S186-3), so applied 1:1 a stat would run 56 -> 100 in a week.

## Other
- Paint/Photos: the viewer guard closed the operator's own Photos windows ("its not paint its the other program i use to see
  pictures") - paused with `AgentComms/allow_viewers.flag` (CLAUDE.md s4 notes it). no_popups.ps1 unchanged.
- Qwen key: the operator's new key (home.qwencloud.com) is VALID on `https://dashscope-intl.aliyuncs.com/compatible-mode/v1`
  (qwen3.6-plus answered) and 401 on the Token Plan endpoint our configs use. Using it means pay-as-you-go billing = his call.
  The GitHub secret QWEN_API_KEY still showed 2026-10-03 at the last check.
- Codex: `gpt-6.1-sol` is REFUSED on the ChatGPT account (400) - the first NIGHTLY1E launch died silently; relaunched on
  gpt-6-luna (roster + memory updated).
- Agents in flight: Codex NIGHTLY1E (wt E:/FightCamp/wt/NIGHTLY1E, branch codex/nightly1e); Cursor PLAYUI1 camp-screen layout
  (wt E:/FightCamp/wt/PLAYUI1, branch cursor/playui1, brief TASK_PLAYUI1_CAMP_SETUP_LAYOUT.md).
- Nightly: latest still 10-09 @f219ad5f 599/7 - the S186 check stands, nothing new.
