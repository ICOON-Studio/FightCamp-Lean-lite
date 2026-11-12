# S443 handover (written 2026-11-12 during S442; S441's handover is in git history at 015c6dec)

OPEN IN E:\FightCamp\Lean. START: `git pull && python ops/Tools/agent_comms.py start`, then `python ops/Tools/where_we_are.py roll S443`
and redraw Miro (a partial SVG with the frame line and the changed cards works; then `where_we_are_svg.py learn` / `trim`).

## USAGE FIRST
`get_usage`. S442 started at all models 93 %, Fable 97 %, extra usage EUR 37.92 of 40; the week reset Thu 2026-11-12 16:00
local. He said "Carry on now", so S442 ran helpers on Opus (model "opus" on every Agent call). Keep helpers on Opus.

## HIS WORDS (S442, verbatim)
- "Carry on now" (asked whether to hold the paid critic rounds until the reset).
- "check comments on board". C314 on the retimed jab B: "still no power behind the shot it looks like a gymnastic extension
  move , not a punch"; C315 jab A: "same with jab b"; C316: "PA lines seem to be pausing a lot and the crowd volume doesnt
  rise up gradually" (fixed, new clip on the board, unheard).
- On the two recommended mocap packs (Q-S294-194): "i dont like any of their punches animations, their punches seem to be
  have to power behind them , what other options we have". Answered with four options (POWER1 first; three other packs'
  previews; capture a real boxer ourselves; film to motion). No pick from him yet. Do not buy the two packs.
- "will your agents keep running if fable credits run out ? will i be able to switch to opus and continue ?" (answered).
- "can you also a UX expert to audit game and makeimprovements", "and HUD too if can do both", "maybe add some hades-like UX
  the text labels for button remains hidden until you omouse over the mouse over them" + the video (watched whole:
  ops/research/HADES_UX_VIDEO_S442.md), "add some effects on critical decisions buttons like slowly expand and shrink to draw
  players eys ?", and the slide "Secret recipe for main menus" (nine rules: memory feedback_menu_recipe_hades_ux_s442).

## DONE IN S442 (on main, pushed)
- Collected by diff, each with fixes at collect, NONE wired to a screen: R26SWAP1 (PR 230, scripts/rules/LineSwap.gd),
  R50TRAIT1 (PR 231, TraitLine.gd), R17PHASE1 (PlanPhase.gd; the dispatcher may still open its PR: close it, it is on main).
  Their three tests are on the daily list.
- ASK FOR A FIGHT short map: ops/research/ASKFIGHT_MAP_S441.md (fair match / step up / a name for the $450 gate; a fight
  teaches Fight IQ, NEW for amateurs from the pro numbers). Free critics: Kalli (sent), John (sent); Dola unreachable.
  Answers land as ops/research/ASKFIGHT_CRITIC_S442_KALLI.md / _JOHN.md.
- Result page: round 2 FAILED its logic check (ops/research/RESULT_LOGIC_CHECK_S442.md: a hand-written bout that cannot
  happen) and two critics at 6. ROUND 3 is drawn from a real bout: tools/result_dump.gd (seed 44) ->
  docs/mockups/s442/result/bout.json -> build_result.py -> fight_result.png; note ops/research/RESULT_ROUND3_S442.md.
  Round 3 critic A = 6 (RESULT_R3_CRITIC_A_S442.md + its 10/10 drawing); critic B's file is RESULT_R3_CRITIC_B_S442.md.
- Sound: the crowd swells back in under the announcer (Sfx fade_in, FightSfx constants); preview on the board.
- Measured: ops/research/FIRELEVEL2_ADAPT1_RESULT_S442.md (fire level ON only with a first-season re-measure; the adapting
  opponent stays OFF: answering it loses 6-8 points with two shouts a round). The foundation moved Lucy v Maria from 41 %
  to 58 %: older numbers for that matchup are void.
- Ziva's editor restarted (worktree on main; its old import noise is on local branch wip/ziva-s442). Miro P0 redrawn.

## IN FLIGHT WHEN THIS WAS WRITTEN (check each before trusting it)
- UX expert (helper): audit of menus + fight HUD, fixes that are not redesigns (uncommitted edits in scripts/ui and the
  listed overlay scripts), Pulse helper + test, proposals drawn under docs/mockups/s442/ux/. Report:
  ops/research/UX_AUDIT_S442.md. REVIEW ITS DIFF AND TESTS BEFORE COMMITTING; layout changes are his pick.
- Defects fixer (helper): ops/research/TASK_RESULTDEFECTS1.md -> RESULTDEFECTS1_RESULT.md (seven places the game says two
  things about one fight). Uncommitted edits in scripts/rules, scripts/state, tests. It lists UI lines it could not touch.
- DEFECTS1: branch claude/defects1 has main merged in and pushed; its 10 touched tests green; NOT merged to main (it
  touches CornerOverlay and four scripts/ui files the UX expert may also touch: merge after the UX work is committed).
  Block stills on the board; the same look is on main, so the odd block is its own item (BLOCKLOOK1).
- Qwen: R24GRADE1, R73DEAL1, R19WORTH1, MATPRICE1 queued behind the dispatcher. Lead S439 session: POWER1 steps 3-6.

## NEXT, IN ORDER
1. Result page round 4 from the two round-3 critics: cause + measured fix in ONE row of cards with the best fix marked, one
   primary action (Continue quiet), colour discipline (red must not mean five things), a label on every mark, bars on one
   scale. Two fresh critics. To him at 8+ only, with the lists. If it does not climb, cut, do not add.
2. Collect the UX audit, then the defects fixer, then merge DEFECTS1.
3. ASK FOR A FIGHT: critics' answers, fix the map, brief ASKPROBE1 (FightLearn.gd + AskBout.gd + a probe).
4. POWER1 collect against C314/C315; nothing called fixed without his eye.
5. Wiring: LineSwap and Towel into the corner minute, TraitLine on the fighter card, PlanPhase in the Playbook.

## TRAPS (S442)
- A JSON file rewritten with json.dumps re-indents the whole file (media_comments.json, questions.json): keep the indent.
- seat_queue.py takes brief paths relative to ops/ ("research/X.md"), run from ops/.
- The dispatcher holds a seat until its own checks finish, and its checks wait behind windowed renders: a seat can look
  idle for 15 minutes. Collect the pushed branch yourself meanwhile; `seat_dispatch.py --act` launches the next brief.
- A Bash `cd` into a worktree moves the session's working directory: cd back.
SETTINGS: next session Opus 5.5 high, Fast off (critic rounds and three collects need judgement).
