# FightCamp production roadmap (S254 proposal) - Paul drafted, Claude reviewed, Ludo to review, operator approves

Operator S254 (verbatim): "can you ask paul to make a production roadmap to see what will be fixed when etc and check if you and ludo approve it".
Paul's full answer (22,036 chars, grok-4.7): `research/PAUL_ROADMAP_S254_raw.md` section 1. Stages are sessions, not dates. Visual rows close
only on a game-camera still + operator OK; a new test fails on master first.

## The roadmap (after Claude's review)

| Stage | Milestone (exit test) | What gets fixed / built | Seats |
|---|---|---|---|
| S254 | Landed HUD: dock still + every open row labelled boxing or not | SHOUTDOCK1 dock DONE (e91b81a4, still 131e9672); preview-boxer look (C108/C109) to Ludo; discipline labels on open rows + the 16 nightly reds; Arena 100-bout shout check | Claude, Ludo, Arena |
| S255 | Career slice 1: one screen shows a deadline goal + GAINS and ATTRITION and the day you must change the plan | Ludo spec -> Arena pure math -> Cursor goal card + meters -> Claude merge; **punch feel from the Undisputed study (Claude add, below)** | Ludo, Arena, Cursor, Claude |
| S256 | Career slice 2: watch one training day and one coach working; one fatigue/stress fix moves a meter | Training day + coach at work (staff MetaHumans stay OFF), fatigue/stress fix | Ludo, Cursor, Arena |
| S257 | Career slice 3: that camp reaches one bout and a progress check against the goal | Opponent on the goal, the fight from that camp, result why-line (a92b359c exists), progress check | Ludo, Cursor, Claude |
| S258 | Demo .exe of that loop; boxing reds green | playable_loop_test cut to the slice; no-real-name, asset_manifest, camp_pays; hangs (decision_pacing, fight_realtime) on cloud seats only | Claude, Grok Dev, Goose, Arena |
| S259 | Watchable punch: jab passes the Q-S231-2 bar | PAIRLIVE1 + ANIMSOURCE1 jab side by side with D69's 3 reference jabs; then polish: live-read ticker, film +6 pick UI, shout pace/distance/weight levers | Ludo, Claude, Cursor, Arena |
| S260 | Steam EA | Store/app/upload - blocked on the operator (money + scope) | Operator |

Held (not built until the operator says): PLACEMENT1 C (is "light equipment" = Two Point move/turn/buy?), light customers, GYMLOOK3 clip batch,
promotions_board. Parked: KICKREACH1, CORNERLIVE1, CLINCH, STORY6, STAFF1, MH3, DAGESTAN, controller support.

## Claude's review - approve with 4 changes
1. **Stale: Q-S249-1 branch delete.** Paul says "leave blocked". The operator gave the go in chat this session ("you have permission to
   delete the 333 merged branches"); done - 333 deleted from origin, verified with ls-remote. Row closed.
2. **Stale: SHOUTDOCK1.** Collected e91b81a4, pips defect seen on the still and fixed 131e9672, still on the review board. Row done.
3. **Stale: C108/C109 "marks not in the snapshot".** Read: both mark the 3D boxer on the Techniques tab (`Feedback/2026-10-18-01`),
   "this doesn't look good" - barefoot, shiny purple spandex shorts, rear glove away from the chin, stiff stance. It is an ART call, so it
   goes to Ludo with the picture (not straight to Cursor as Paul proposes).
4. **Missing: punch feel (S255, beside the meters).** `research/UNDISPUTED_STUDY_S254.md` (operator S254 "you can rea on undisputed"):
   their 3,152 clips hand control back 0.11-0.17 s after impact; ours lock the fighter 0.42 s (jab) to 1.4 s (body shots) after contact
   (`clip_phases.json` recover_s). That is a data change, cheap, and it is the likeliest cause of the stiff one-at-a-time exchanges the
   operator watches in every bout. Ludo verdict first, then one brief with a red test. It belongs before S259's jab work, not after.
Agree with Paul on the order (career loop before more fight chrome) and on holding the ticker / film +6 / levers to S259: the operator's
S248 "Go" was FIGHTLINK, which shipped through step 5; the career meters are the gap he named in P12.

## Operator calls the roadmap needs (Paul section 7)
1. Scope: the demo .exe = that thin loop, shouts on, promotions off?
2. Scope: "light equipment" = PLACEMENT1 move/turn/buy, or held until after the .exe?
3. Money: any Steam app/store spend before the .exe is in your hands, or wait?

## Ludo's review (r119, 17,749 chars, `ludo_rx/LUDO_R119_raw.txt`, ask `LUDO_R119_ask.txt` + the C108 marked picture uploaded)
- ORDER: approves with one move - the watchable jab / striking fluidity comes BEFORE the .exe ("if the 3D match engine looks broken,
  players judge the backend as equally broken"), so the gym pads and the fight share clean striking.
- S255 READ: one goal strip - deadline + opponent + weight target; GAINS = Readiness 0-100 (plan familiarity 0.35 + weight cut 0.35 +
  primary tactic mastery 0.30, target >= 80%); ATTRITION = Wear 0-100 (muscle fatigue 0.40 + micro-trauma/chin 0.35 + weight drain 0.25):
  0-39 fresh, 40-59 productive, **60 = change-the-plan point** (amber border; growth -40%, injury +25%/session), 80+ breakdown.
  Action: drop sparring/heavy bag for 48 h of recovery work until wear < 50.
- OFF for the first playable: placement (keep fixed station slots), background customers, promotions. Must NOT be cut: weigh-in on the
  scale, one visible cut + cutman on the stool, mitt pop sound scaled by mastery.
- PUNCH FEEL: adopts control at impact + 0.11-0.17 s, the clip tail on a blend layer; per punch control-return offsets jab +0.12,
  double jab +0.11, jab body +0.13, cross +0.15, cross body +0.16, lead hook +0.14/+0.15 body, rear hook +0.16, uppercut +0.14/+0.16,
  overhand +0.17. Body contact targets: lead body hook 0.40, rear body hook 0.44, body jab 0.32 (level change starts at 0.08 s).
  Counter window: hitbox_on - 0.05 s .. control return; inside it the puncher's evasion = 0, hits on him +25% crit, +20% rocked;
  length x (1 + (100 - technique)/200) x (1 + fatigue/100 x 0.40). Anti-pop: inertial blend, arm retraction >= 0.14 s, 2-frame impact hold.
- PREVIEW ART: matte satin trunks (navy #0F172A or charcoal #1E2229, gold trim #E8B04B, 10 cm white waistband), black high-top boots +
  white socks, oxblood gloves #8B1E1E, wraps visible 3 cm; orthodox guard - rear glove on the cheekbone, lead at eyebrow 20 cm out, chin
  tucked, 15 deg knee bend, 60/40 rear weight, breathing idle; octagonal 2.4 m slate plinth #151921 with brass trim #C59A41 + contact AO;
  key #FFF8EE (-1.4, 2.2, 2.2), fill #384556 (2.0, 1.4, 1.8), gold rim #E8B04B (-1.8, 2.8, -1.5), cyan rim #7DD3FC (1.8, 2.4, -1.2);
  camera (0, 1.35, 2.65), pitch -4 deg, FOV 32, boxer 82% of frame height.

## Seat fix (operator S254: "why is qwen not included in the team on the roadmap ?")
Qwen (role S178: small pure modules + tests, shell seat that pushes a branch) was missing: its roster note was stale since S206
("pure modules now go to ARENA first"), Paul's snapshot carried no free seat for it, and Claude's review did not check seats. Now:
- S254/S255 Qwen: label the 16 nightly reds by discipline (boxing / gym / OFF-DEMO) from their logs - a report, no fixes. Unblocked.
- S255 Qwen: `scripts/rules/PunchTiming.gd` pure module + test - control return = our clip's contact + Ludo r119 B per-punch offset,
  body contact targets 0.40/0.44/0.32, read from `clip_phases.json` values passed in (no preloads). Starts on the operator's roadmap OK.
- S255 Qwen (if Q-S249-5 = build): the counter-window maths (hitbox_on - 0.05 .. control return, x technique/fatigue scaling).
- ZIVA (operator S254 "also ziva can help"; S248 "ziva should be able to do everything") = the PLAYTESTER and owner of the loop test,
  in wt/ZIVA on the hidden desktop, only on a GREEN watchdog with no other Godot job (S237 heat trap): every slice is played through
  `run_scene` with real inputs before Claude takes the stills -
  S255: open the Techniques tab after PREVIEWLOOK1 lands + play the goal strip / meters screen (does Wear crossing 60 show the amber
  alert and let you swap the day?); S256: play a gym day with the new punch timing (pads + spar) and report errors/stalls;
  S257: play walk-in -> goal -> train -> coach -> fight -> progress check end to end; S258: OWNS `playable_loop_test.gd` - cut it to
  the S237 slice and make it green (no story/clinch/placement turned on to pass it); S259: the demo .exe path once more, as a player.
  Ziva reports defects as a list; fixes go to the module's owner (one owner per area, S227).
- Arena keeps the Readiness/Wear meter maths and the 100-bout check; one owner per module (S227).

## Verdict (Claude, on Ludo r119 + Paul) - for the operator's approval on the board
1. ORDER (Ludo's move taken): S255 career slice 1 (goal strip + Readiness/Wear meters) + punch timing data fix; S256 watchable jab +
   striking fluidity; S257 training day + coach + fatigue fix; S258 opponent + the fight from that camp + progress check; S259 demo .exe +
   polish (ticker, film +6, levers); S260 Steam EA (your money/scope call).
2. PUNCH TIMING: take Ludo's RELATIVE rule (control back at our own clip's contact + his per-punch offset) - not his absolute contact
   times, which are invented for clips we do not have; take his body contact targets (0.40 / 0.44 / 0.32) as the retime goal. Built behind
   GAME_ON with a test red on master first; judged on a game-camera clip, not a number.
3. COUNTER WINDOW: a NEW mechanic (puncher exposed while punching, scaled by technique and fatigue) - needs your yes; not built before it.
4. SCOPE ADDS from Ludo (weigh-in on the scale, a visible cut + cutman, mitt pop sound): your call. Claude's read: the cut exists in data
   (`cut_scar.json`) and is the cheapest; weigh-in and sound are new.
5. PREVIEW BOXER (your C108 mark): build Ludo's outfit + guard pose + light rig on the Techniques preview; closes on a still and your OK.
   Boots are the one asset gap - prefab search first (Fab/Mixamo/Ludo 3D), else Ludo generates them.
