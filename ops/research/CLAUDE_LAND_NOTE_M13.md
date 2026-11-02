# CLAUDE LAND — Maria M13 The Fight Screen (2026-09-10)

Maria Art Director finished **TASK M13 — THE FIGHT SCREEN THAT MUST NOT PICK A PUNCH**.
Art only. Please land. Do not wait on Maria for more files. Do **not** expect
Maria to edit `HANDOFF.md` — write the Maria HANDOFF block yourself after land.

## What landed

- Spec: `research/M13_THE_FIGHT_SCREEN.md`
- Boards: `DesignLibrary/screens/fight_screen/m13_*` (**new folder**, 8 PNGs)
- Staging zip: `_maria_delivery/M13_THE_FIGHT_SCREEN.zip`
- This note: `_maria_delivery/CLAUDE_LAND_NOTE_M13.md` and
  `research/CLAUDE_LAND_NOTE_M13.md`

## Call (one line)

Wide / corner / labelled replay / HUD = summaries; tight contact = CLAIM only if
the 20 Hz engine scored it. HUD is the second camera. Not a fighting-game fight screen.

## Token / instrument calls

- Shell / round / primary dock = `GYM_DEFAULT` (`#2f6fb0`). **SELECT does not exist.**
- Candour / pocket / highlight label / pip arrival rim = `LINK`.
- Heart rate = permanent ring + BPM; bands `GOOD` / `AMBER` / `BAD` — **not a stamina bar**.
- Trauma pips = discrete CUTS (`BAD`) + SWELL (`AMBER`); empty `TRACK`.
- Six regions = HN/TC/LA/RA/LL/RL glance chips (`LIFE_RAMP`/`AMBER`/`BAD`) — not anatomy.
- KD / doctor stoppage = `BAD`. Corner towel = `AMBER`. Ref wave-off = `GYM`.
- `GOLD` ×1 = verdict word on M5 exit only. `SODIUM` / `ICE` / `GO` unused on this HUD.

## Permanent vs on-change

- **Permanent:** HR, trauma rows, 6-region glance, round+clock, pocket chip, names, actable dock.
- **On-change:** pip arrival, KD mark, ground seat, judge tick at bell, stoppage reason, pocket pulse.

## Crescendos

1. Knockdown — ref+count subject; teach accumulation first.
2. Stoppage — typed reason plate → labelled replay → M5 verdict path.
3. Between round — labelled HIGHLIGHT; volume board from full ledger; J1–J3; corner actables.

## Rejects (spend instead is in spec §5)

Cinematic cam · per-punch impact · broadcast package · stamina bar · health-bar FG layout.
Also: live drop-count, SELECT, GOLD on live chrome, world HP billboards.

## Land steps

1. Extract `_maria_delivery/M13_THE_FIGHT_SCREEN.zip` →
   `DesignLibrary/screens/fight_screen/` (create folder) + research spec.
2. Spec → `research/M13_THE_FIGHT_SCREEN.md`.
3. Do **not** import board PNGs as runtime bitmaps — code-draw from UITokens +
   fight HUD instruments.
4. Write Maria HANDOFF block; mark TASK_M13 done when acknowledged.
5. Anchors: G42/G43/G44/G45 · M5 GOLD/judges · M6 BAD/regions · M7 SODIUM off ·
   K19 frame-pin keep / punch fantasy replace · R97 sample adapter.

## Boards

`m13_01_the_frame.png` · `m13_02_hud_second_camera.png` · `m13_03_knockdown.png` ·
`m13_04_stoppage.png` · `m13_05_between_round.png` · `m13_06_reading_without_punches.png` ·
`m13_07_rejects.png` · `m13_08_composed.png`
