# S448 handover (written 2026-11-13 ~10:10 at the end of S447; S446's handover is in git history)

OPEN IN E:\FightCamp\Lean. START: `git pull && python ops/Tools/agent_comms.py start`, then `python ops/Tools/where_we_are.py roll S448`.

## USAGE RULES (kept)
`get_usage` first; hand over at 300k context (S447 ran to 600k - start the wrap-up at 300k, not later); at most TWO helpers.

## HIS WORDS IN S447 (verbatim)
- "you told me to buy that, so why should i trust you and buy the 2 other packs ?" -> rule saved (memory
  feedback_see_motion_before_buy_s447): no buy advice without the seller's preview motion checked by eye; no preview = no buy.
  The Ailive pack cost EUR 8.47; only its footwork + sway had ever been judged.
- "also check how punch speed is affected" / "this sounds like coding weakness rather animation issue" / "can you try them all ?"
  -> all 10 Ailive clips baked on our boxer and filmed beside ours (board 2026-11-13_0920; ops/research/AILIVE_SPEED_S447.md):
  hooks/uppercuts fast (7.7-11 m/s), jab/cross slow; every punch steps into a 0.9-1.2 m stance. He has not judged yet.
- "lets see how it is with the recent additions and changes before we try" -> NO video-to-mocap until he has seen POWER1B,
  BLOCKLOOK2 and the uppercut fix in the game.
- "delete the 3 clips, i'll download them myself" -> deleted; 52 ProductionCrate tabs opened in his Chrome (he downloads; the
  free limit stopped him: never bypass it - "can you sign in with different agents" was declined).
- "yes brief qwen to make the rest in ludo" -> TASK_SOUND4, Qwen running (qwen/sound4).
- "why cant you make your own assets instead of looking elsewhere though? like these crowd flashting effects" -> CrowdFlashes
  built in the game (a07a2a8e), film on the board 2026-11-13_0958.

## RUNNING (collect first)
- SOUND4 LANDED: PR #244 (qwen/sound4), dispatcher checks 2/3 PASS, done in 7 min - suspicious for ~35 Ludo sounds:
  read the diff (were sounds really made? raw/ files, sounds.json heard:false, the failed check) before the board.
- PROGRESSION design: session "Weekly progression plan" (local_b6266b3e) runs it - his words + Claude's view were sent; collect its map.
- POWER1B - Goose, issue 241, branch goose/issue-241. Extra scope added: the PLAYED lead uppercut jumps 26-37 m/s about 0.12 s
  after the freeze (HitImpact.recover's QUICK BACK path) - JOINFIX1's isolated test never takes that path. Collect by diff, then
  FILM: `tools/hit_frame_film.gd -- <dir> jabs=0 crosses=0 uppercuts=2 seed=4242 side=1` (hidden desktop, 60 fps, --log=);
  bar: no frame over 9.6 m/s after the freeze on the lead uppercut.
- BLOCKLOOK2 - Grok Dev (sent 08:50, starts after JOINFIX1, which is now merged): ops/research/TASK_BLOCKLOOK2.md. Collect by
  diff, then FILM blocks in the played fight (not block_meet_probe's staging).

## WAITING ON HIM (board)
Q-208 regroup as everyone's fight screen; Q-209 build the amateur fight week before Ask for a fight (ASKFIGHT_MAP v4 STATUS:
a later date buys nothing today, so Ask cannot be a real choice until the fight week exists); result tabs, Ailive films, crowd
flashes on the review board; ProductionCrate company licence; voices + PA mix by ear.

## TRAPS (S447)
- A seat's isolated test can pass while the played fight fails (JOINFIX1): every motion fix closes on hit_frame_film / a
  played-fight film, never on the seat's test alone.
- hidden_desktop.py drops the game's prints unless `--log=<file>`.
- ffmpeg drawtext needs a font file here (fontconfig missing) - skip text overlays; ffmpeg h264 needs an even height (scale=1920:1008).
- Claude in Chrome: every tool result lists all 52 tabs (~6k tokens) - close the ProductionCrate tabs when he is done.
- A probe's levers must change the path they claim: ASKPROBE3's "two dates" acted only on a scale miss (= one date).
