# VERDICT S285 - time progression (MGT2 weekly time + auto-pause)

Operator S285: "should we use the time progression in the game like MGT2 1 week progression ? real time through each week and
game gets paused when players [...]". Asked Ludo (lead designer) in a fresh Ask Ludo chat; reply saved verbatim:
`research/ludo_rx/LUDO_S285_TIME_raw.txt` (23,219 chars). Ask: `research/ludo_rx/ask_s285_time.txt`.

## Today (measured)
- A gym day = 600 game minutes x 0.2 real s = ~2 min real per day at 1x, ~14 min per week (day_lap_stations.json real_s_per_min).
- S276 ruling "nothing interrupts": nothing auto-pauses; every event waits behind a top-bar icon (GameSwitches no_interrupts).

## Ludo's answer (short)
ADAPT MGT2, do not copy it: the calendar must move much faster, and only a few events may stop it.
- Scale: ~3.5 real s per game day at 1x (~25 s per week, an 8-week camp ~3 min); 2x ~1.7 s/day; 3x ~0.85 s/day.
  The floor stays visible: each boxer plays one readable activity cycle per day instead of real-time minutes.
- AUTO-PAUSE (only these): fight offer with a deadline, fight night arrives, major injury, cash below zero, contract ends
  within 7 days. Everything else (applicants, sparring results, month report, sponsors, milestones, rival news) = ICON only.
- Controls: Space pause, 1/2/3 speeds, "skip to next event" (runs fast, stops at the next pause event), and an options page
  to switch each auto-pause on/off.
- Fight camp weeks run normally; fight week slows to the walkout; after the bout the game returns paused to the gym.
- The per-weekday station roster becomes a weekly plan (it already is - week_plan_page); the daily floor keeps its logic.

## Claude's verdict
ADOPT Ludo's ADAPT. It keeps your Two Point "icons, not pop-ups" for everything small and fixes the real problem of today's
clock: a week takes 14 minutes, so the career (camps, fights, money) barely moves. It does reverse S276 "nothing interrupts"
for exactly five events - that part needs your yes.

First build step (small, playable): retime the clock to ~3.5 s per day at 1x, Space + 1/2/3 keys, and ONE auto-pause -
fight night arrives. Then the other four pauses, then skip-to-next-event, then the options toggles.

Risk to watch: at 3.5 s/day the floor animation must stay readable (one activity cycle per boxer per day) - checked on the
game camera before it ships.
