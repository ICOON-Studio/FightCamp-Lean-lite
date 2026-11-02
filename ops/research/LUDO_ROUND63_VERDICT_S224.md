# LUDO ROUND 63 VERDICT (S224) - the whole corner, on a REAL-TIME clock

Ask `LUDO_ROUND63_ASK_S223.txt` (today's corner card uploaded); reply verbatim `LUDO_ROUND63_REPLY_S224.txt` (34,835 + 12,540 chars
after "continue"). The operator's brief: "make it fun,addictive,interactive and realistic as possible , i feel as a simulation i real
time timer would be more apporpriate". This REPLACES the corner half of Q-S221-4 (Ludo r62 B/B2); the kits half (r62 A) is unchanged.
Nothing below is built until you OK it.

## A. The verdict - TAKE Ludo's "ticking corner" (real-time, you control the speed)
- The 60 s rest clock RUNS. 0-5 s he walks to the stool and sits; 5-50 s is the working minute (45 s); at 50 s "SECONDS OUT":
  no new jobs, running jobs get their last seconds; 60 s the bell.
- Nothing is frozen and nothing is busywork: the camp's plan and the obvious jobs (worst cut first, water when tired) are already
  running when he sits down. Doing nothing = a properly attended fighter. You step in to change things.
- SEND HIM OUT (Space) does not skip the minute - it plays the rest at 4x, so the jobs still finish and you see vitals climb to the
  bell. Ludo scored the frozen card 4.2/10 for fun, pure 60 s real time 7.8, this hybrid 9.6.

## B. One corner, on screen
- Stool view (3D, live): he breathes hard and slows down as the seconds pass; heart rate and stamina tick on screen.
- Three lanes work AT THE SAME TIME, each a short queue you can add to, cancel or reorder while the clock runs:
  CUTMAN (swab the cut, enswell the swelling, Vaseline, deep coagulant), SECOND (ice collar, water + mouthpiece, towel air,
  deep rehydrate), CHIEF (the tone first, then the call / the scouted tell / the exit plan). A job shows a filling bar with its seconds.
- Crew pace any time: CAREFUL (slower, 2% slip), NORMAL (8%), RUSHED (jobs take 0.7 of the time, 25% slip). A slip is visible
  (swab in the eye, water makes him cough, a muddled call he ignores for the first 45 s of the round).
- Doctor: a bad cut or a shut eye brings the ringside doctor to the apron at 30 s; if the cutman got the bleeding down in time he
  lets it go on, otherwise it is stopped.
- THROW THE TOWEL: a red button you HOLD for 0.6 s (no accidental click). ESC stays the pause menu (Ludo's own risk note).
- Tone x stool state (groggy / panicked / complacent / steady) = the S190 table you already approved (D40), unchanged.

## C. The camp
- Camp sets: the default CALL (camp focus -> call, Kalli K87 table, our camp names - not Ludo's renamed ones), the scouted TELL
  (only if scouting found it), and a hired cutman starts on the worst cut at once.
- Not from the camp: cuts and recovery come from the state he is in at the bell.
- No camp: default call "Hold the centre" (tagged COACH'S CALL), no tell. A good camp = fewer things to fix, never an automatic corner.

## D. The whole fight
- First corner of the first fight: always played, full clock, the plan already chosen - it teaches "confirm or change, then send".
- Later: AUTO-SEND switch (Tab) plays the minute at 10x (~5 s) and shows what was done. It switches itself OFF (you play the corner)
  on: a knockdown, a cut or swelling, the doctor, two lost rounds in a row, the last round of a close fight. (= Ludo r62/Kalli K87.)
- Keys: Space send, 1/2/3 tone, Q/E cycle call, Z/X/C pace, Tab auto-send, hold the towel button. Controller map in the reply.

## E. Why it pulls you back
- At the next bell the scorebug shows the call for 8 s and the boxer visibly does it; the round verdict names what the call produced.
- Result screen: a CORNER tab - bleeding stopped, stamina won back on the stool, calls that won rounds, cutman grade.

## F. Numbers - keep / change (Claude's rulings on Ludo's table)
- 60 s rest, 45 s usable, 10 s seconds out: KEEP (real rules).
- 15 s per action point: KEEP. Per lane 3 AP instead of 2: TAKE (45 / 15 = 3; the old "rushed 3rd AP at 35%" goes - rushing is now the
  pace setting).
- Slip 2% / 8% / 25% (today's card shows 3 / 8 / 20, the S190 table 35% for the rushed 3rd AP): TAKE 2 / 8 / 25. Estimates, not sourced.
- Heart rate on the stool: Ludo's -1.2 bpm/s (~54-72 bpm in the minute) is NOT taken - too fast. John (J68, xAI, sourced): elite
  boxers end a round at 175-199 bpm and drop 26-35 bpm in the 60 s rest (~0.45-0.6 bpm/s, faster in the first 20 s); cooling helps
  how it feels, barely the heart rate. Ruling: about -0.5 bpm/s, front-loaded; the ice collar a small extra; capped.
- Vaseline: NOT Ludo's "30% glancing blows". Real Vaseline cuts friction so fewer cuts open: ruling = lower cut chance for 2 rounds,
  no damage change (estimate).
- Doctor at 30 s: estimate (Ludo's own word "standard" is unsourced).
- Every effect on the NEXT round is MEASURED with seeded bouts (called vs not), like CAMPPAY1 - Ludo's "+40% counter" style numbers are
  not used.

## G. Build order if you approve (each ships ON, each comes back to you as a short clip)
1. The corner clock (pure module + contract test, Arena): 60 s, the 5 / 45 / 10 phases, three lane queues running in parallel,
   add / cancel / reorder, pace, slip rolls, a job cut by the bell gives part of its effect, 4x send, 10x auto-send and its 5 stop
   rules. Built on today's CornerPitStop.gd + ludo_corner.json, not a new system.
2. The live corner card (cloud Cursor): CornerPitStopPanel becomes the running clock - lane bars, queue edits, keys, hold-to-towel.
3. The stool scene live (Codex, PC): camera to the stool, breathing slows with the clock, the doctor at the apron.
4. The call's effect in round 2, measured (Codex/Grok Dev), and the result screen's CORNER tab.
Later, with the animation work: the cutman's hands on the cut, the ice collar, the water bottle.
