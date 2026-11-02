# TASK J-GUARDPACE1 - JOHN - what a real boxing guard and real punch pace look like (numbers, with sources)

Kind: research
Model: John (Grok research seat). Discipline: boxing (demo). Assigned 2026-10-29 (S301).

## Why
The operator watched our 3D fight (women's amateur boxing, side-on broadcast camera) on 2026-10-29 and wrote:
"the guard looks fake, still too slow, the punches feel like they have no power and target enemys hand rather than
their head". We need real-world numbers to fix each, not guesses.

## Questions (answer each with numbers and a source; say when a number is an estimate)
1. THE GUARD (orthodox, amateur and pro women if possible, else men scaled): where are the gloves relative to the face
   (glove height vs chin/eyes, distance in front of the face in cm), elbows (tucked to ribs? how far from the torso),
   chin tucked, shoulders raised, knee bend, stance width (feet apart as a fraction of height), weight split front/back,
   how much the guard MOVES while waiting (bounce amplitude cm, rhythm Hz, hand pumping/feints). What makes a guard
   look stiff/fake on screen versus alive (animation or broadcast-analysis sources welcome)?
2. PACE: punches thrown per minute per boxer in women's amateur bouts (CompuBox-style or study data), typical
   combination length, seconds between exchanges, time from first visible movement to contact for jab / cross / hook,
   retraction time. We have: jab ~0.4 s first movement to contact, retraction jab ~262 ms, power ~170 ms - confirm or
   correct.
3. POWER ON SCREEN: what makes a punch read as powerful on broadcast and in games (weight transfer: hip/shoulder
   rotation degrees, rear-foot pivot, head snap of the receiver in degrees and ms, hit-stop / impact frames in fighting
   games in ms, camera shake). Cite game-animation talks or fighting-game frame data where you can.
4. WHERE PUNCHES LAND: in amateur bouts, what share of thrown punches hit the guard/gloves vs the head vs the body,
   and at what distance (cm between the fronts of the two boxers' heads) a jab lands on the face past the guard.

## Prior research
research/topics/striking.md, G75_STRIKE_SPEEDS.md (Kimm & Thiel 2015 jab speeds), J28_HOW_FIGHT_MOVES_FLOW.md
(retraction ~170/262 ms, Menzel), J50_HOW_A_DEFENDER_DEFENDS.md (jab ~405 ms to contact), UNDISPUTED_STUDY_S254.md
(clip-start -> impact jab 0.365 s, cross 0.501, hook 0.534, uppercut 0.489). Do not repeat these; build on them.

## What would a human do?
A boxing coach judges a guard by eye in seconds (gloves at the cheekbones, elbows on the ribs, chin down, always
moving); a game animator matches mocap to broadcast reference frame by frame and adds impact frames for weight. We want
the numbers those two people carry in their heads.

## Prefab check
None: this is a research question. Name any free dataset (punch-phase timings, CompuBox women's stats, open mocap of a
boxing guard) with its licence if you find one.

## Answer format
Markdown, one section per question, every number with its source (title, author/site, year, URL). Longest complete
answer; then "continue" if cut.
