# CLIPREVIEW1 - every seat on the S258 fight-motion clip (S259, 2026-10-19)
Operator S258: "next session have everyone (ziva etc) review the clip and come back with feedback".
Clip: previews/s258_fightmotion/s258_fightmotion_ab.mp4 (left master, right one-root solver 8f6ba01f, seed 95501).

## Who answered (verbatim files)
| seat | what it saw | file | chars |
|---|---|---|---|
| Ludo (lead designer) | before/after frame sheet (uploaded) + mp4 link (Ludo takes images only) | research/ludo_rx/LUDO_CLIPREVIEW1_r1.txt | 15,880 |
| Grok Expert | frame sheet, then the mp4 itself (operator S259: "why you do not upload the video file oon grok ?") | CLIPREVIEW1_GROK.md | 2 rounds |
| Dola | frame sheets; round 2 was sent without the video (Cici refuses .mp4) - NOT evidence; round 3 = 0.5 s frame sheets, pending | CLIPREVIEW1_DOLA.md | 15,790 |
| John (research) | numbers brief (text-only seat) | CLIPREVIEW1_JOHN.md | 9,343 |
| Kalli (design) | numbers brief (text-only seat) | CLIPREVIEW1_KALLI.md | 10,927 |
| Maria (art) | numbers brief | CLIPREVIEW1_MARIA.md | landed S259 (read in S260) |
| Ziva | NOTHING: run_scene on FightWorldLive.tscn timed out twice before the first frame (same limit as S250); its MCP has no line to Ziva's own agent, so it cannot give a verbal review | - | - |

## Verdict (Claude; agreed by 2+ seats -> work, in this order)
1. SPACING FIRST - all six (Maria too: "kills the read before anything else") ranked torso merge #1. The engine holds 0.557 m chest to chest in exchanges (= clinch range). Ranges
   named: jab 1.0-1.5 m (John: elite mean 1.23 +- 0.16 m, [S1] French elite study; Ludo 1.35-1.55; Grok 1.0-1.5; Dola 1.2-1.5),
   hook/pocket 0.6-1.1 m (Ludo 0.85, John 0.75, Grok 0.6-0.9), clinch < 0.65 m. Push-out must be a step, not a slide (Kalli, John).
   -> FIGHTGAP1 moves ahead of FIGHTMOTION1 step 2: per-punch range in the engine + a separation floor outside the clinch.
2. JAB TIMING - Ludo (ext 0.26 s incl. a 0.10 s tell, retract 0.18 s), John (0.08 wind-up + 0.12 strike + 0.18 recovery), Dola
   (0.28-0.32 / 0.22-0.26), Grok (0.35-0.45 extension, Stanley 2018 amateur 405 ms). Measured: 0.07 s out, 0.05 s back. DONE S259
   PUNCHRETIME1 (switch punch_retime): extension >= G75 floor (jab 0.20 s), retraction >= Ludo's table; measured 0.22 s / 0.20 s,
   peak 8.3 -> 5.3 m/s.
3. FEET - planted during a jab; push-step 5-20 cm; rear-foot pivot 20-45 deg on cross/hook; no free slide while a punch is active
   (all five). -> FIGHTMOTION1 step 2 (as planned).
4. TWIST FROM THE HIPS - rotation driven by pelvis, spine clamp ~36 deg total (Ludo), 30-45 deg (Grok), "trunk rotation, not trunk
   twist" (John, Izumi 2018). -> after step 2.
5. RED'S CROUCH - hips drop only on slips / body shots (Kalli, John, Dola); red sits below 0.70 m on ~10% of frames.
Sources quoted by Dola and John are unverified (Dola fast mode; John flags estimates) - verify before a number becomes a gate.
