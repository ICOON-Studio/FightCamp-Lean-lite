# Verdict S240 - the office PC hub and the gym camera (Ludo r106 + r107)

Sources: research/ludo_rx/LUDO_R106_raw.txt (23,722 chars) and LUDO_R107_raw.txt (20,070 chars), lead designer Ludo, with the
office still attached. Paul (PM bot) was asked the same two questions (pm messages P15, P16).

## 1. Your question: "instead of the find fight button add for now the office with a desk a pc on it click the pc and have options dashboard finaince, leaderboards, Tournaments (book a fight here). do you agree with this?"
**Ludo: YES, with one guardrail - the office must be ONE click away** (Punch Club lost players to walking). **Claude: agree.**
What gets built:
- A late-90s beige PC with a CRT monitor on the right half of your desk (the open book stays on the left), turned 15° toward your chair.
  When a fight offer waits: the screen glows blue and a small amber "NEW FIGHT OFFER" tag floats over it; the office door on the floor
  shows "OFFICE: 2 OFFERS". Hover = white outline + hand cursor.
- Click the PC: the camera pushes in to the monitor (0.35 s), the PC screen fills the view; ESC pulls back out.
- FOUR tabs: DASHBOARD (his stats, trust, morale, cash, today's coach/station), FINANCES (weekly costs and income), RANKINGS (your
  "leaderboards": his weight class top 10, him marked), BOUT CONTRACTS (your "Tournaments", renamed - real boxing books fights by contract,
  not brackets). BOUT CONTRACTS = the opponent list Cursor already built (FINDFIGHT1): pick a row, REVIEW CONTRACT, SIGN & LOCK BOUT.
- The floor keeps only the countdown ("TARGET: <NAME> - 4 DAYS OUT") and the door tag. The FIND A FIGHT button on the floor goes.
- Cut for the demo: tournament brackets, several fighters, upgrades/loans, walk-out cutscenes, hiring/firing, purse haggling.

## 2. Your question: "would it be better to swtich to 2.5d isometric for the whole gym and keep 3d only for fight"
**Ludo: NO to a 2D/sprite gym (8-12 weeks, throws away every MetaHuman, mocap clip and the pads work); YES to the 2.5D LOOK -
keep the 3D gym and lock its camera to a straight isometric view (how Two Point Hospital and Mad Games Tycoon 2 do it). Claude: agree.**
What gets built (2-3 days of work):
- Gym camera: orthographic (no perspective stretch), angle 35.3° down / 45° around, three zoom steps: whole club 24 m, training floor
  14 m (default), one station or the desk 6.5 m.
- Front walls cut down to 0.45 m so they never hide the fighters; back walls full height with the posters; room partitions fade when
  you look into that room.
- Going to a fight: the camera swings down from the iso view into the 3D broadcast view of the ring (1.2 s). After the fight it fades
  back to your office desk for the goal talk.

## Paul (PM) on the PC, his P15 answer
"I agree - booking leaves the floor. I do not agree with four PC options. Demo PC is Finances (that desk already routes there) plus
Tournaments only." He cuts Dashboard and Leaderboards for the demo, keeps the countdown pill, and wants your open office comments
(C94, C95) read before a PC is built. **Claude: take Paul's cut for the first build** (BOUT CONTRACTS + FINANCES; Ludo's own demo list
also drops Rankings), Dashboard + Rankings follow once a fight books end to end. Paul's answer on the camera (P16) is pending.

## 3. Your earlier ruling, being built now
Board Q-S237-2 "Yes, build both" - "this should be done in the office": when a goal ends he waits in the office; walking in opens the
talk (result, trust/morale, walk-out warning under 30, his next goal from two). Ludo r106 adds: he stands across the desk (confident
when MET, slumped when MISSED) - that pose comes after the talk works.

## Order if you approve
1. Office goal talk (in progress). 2. Desk PC with BOUT CONTRACTS + FINANCES (the FIND A FIGHT list moves there; the floor button is dropped). The same build first
   clears your open office marks C94/C95 (Feedback/2026-10-17-01/-02: two wrong facings, "what is this ?" strip on the back wall,
   "add doors ?") - they were in Codex ROOMS3CD2, refused in S236.
3. Iso camera on the gym (stills on the game camera for your OK before it ships). 4. Later: DASHBOARD / RANKINGS tabs.
