# TASK CLIPREVIEW1 - every seat reviews the S258 fight-motion clip and reports back
Status: OPEN (operator S258: "next session have everyone (ziva etc) review the clip and come back with feedback")
Kind: research (no code, no PR - answers land in CLIPREVIEW1_FEEDBACK.md; no '## Contract' block needed)
Model: Claude sends and collects; each seat answers in its own words. Discipline: boxing (demo).

## The clip
- `previews/s258_fightmotion/s258_fightmotion_ab.mp4` - left master, right the one-root solver (8f6ba01f), same
  fight (seed 95501), game camera, 20 s.
- Frames every 2 s: `before_every2s.jpg`, `after_every2s.jpg` (same folder). Seats that cannot take video get the frames;
  pictures are UPLOADED, never described (operator S220).

## Who and how
- Ludo (lead game + art designer): upload the mp4 or both frame sheets in Ask Ludo, long answer, save verbatim to research.
- Ziva: play the live boxing fight itself (run_scene / playtest in wt/ZIVA, as_game) and report what it sees in feet, hips,
  torso, gap, punch speed - not only the recorded clip.
- Maria (art direction), Kalli (game design), Dola (fresh eyes), John (real-boxing reference): frame sheets + the questions below
  (seat_queue / gbot).
- Grok Expert (Browser 1): the frame sheets + questions.

## Questions (same for everyone)
1. Which side reads more like two real boxers - and where exactly does each side break (feet, hips, torso twist, spacing)?
2. Feet: do planted feet stay planted? Do steps look like boxing footwork (push step, pivot) or a glide?
3. Punches: the operator says "the jab fires like a bullet". Does it? Which punch looks too fast or too slow?
4. Spacing: do the torsos merge or pass through each other in exchanges?
5. The three worst moments (time in the clip) and what a fighting-game animator would do about each.

## Collect
One file `research/CLIPREVIEW1_FEEDBACK.md`: each seat's answer verbatim (with char count for Ludo), then Claude's
verdict list: what is agreed by 2+ seats goes into FIGHTMOTION1 step 2 / the jab-speed fix / FIGHTGAP1; taste calls go to the
operator on the board with the clip attached.
