# TASK_GROUND_BAG_ROUND2 — THE CLIP CAME BACK. NOW BEAT IT WITH EVIDENCE

**Round 2.** You reviewed this prompt blind. It has now been RUN, and you are
being shown exactly what came out so you can revise against a result instead of
against a guess.

Same rules as before: **no template, no length limit, beat the idea if you can.**

---

## WHAT WAS RUN, VERBATIM

Text-to-VIDEO (Seedance 2.0, 8 s, 720p, 36 credits) — not the motion model. One
paragraph, not shot-delimited, because the video path takes prose:

> *"Wide locked-off shot in an MMA training gym, realistic documentary look. A
> single male fighter in black shorts and open-finger MMA gloves is mounted on a
> heavy human-shaped canvas grappling dummy that lies face-up on a blue mat. The
> dummy is training equipment, roughly 1.78 m long and 40 kg, with a thick torso,
> stubby limbs and a featureless head - it is limp and completely inert, it never
> moves, blocks or reacts. The fighter kneels astride its torso with his knees
> either side of its chest and his hips pressed down. He posts his left hand on
> the dummy's chest and drives his right fist straight down into its head, then
> his left fist, then his right again - hard, repeated ground-and-pound punches
> with real shoulder rotation and hip drive. The camera does not move. Even
> overhead gym lighting, no crowd, no spectators, no second person anywhere in
> frame."*

The MOTION model was also run separately on the three-shot version at 0.1 credit
a seed, seeds 11 / 23 / 37. Both results are below.

---

## RESULT 1 — THE VIDEO. WHAT ACTUALLY CAME BACK

**THE BIG ONE, AND IT SETTLES THE CORE QUESTION: THE PROP DID NOT COLLAPSE.**
There is no second human anywhere in the clip. The dummy stayed a dummy. Eight
of eight two-fighter generations previously collapsed into one body; asking for
one man and an object did not. **The operator's core insight is validated.**

What is right:
- A real gym — blue mat, weight racks, strip lighting, correct depth.
- Correct kit: black shorts, open-finger MMA gloves.
- A genuine human-shaped grappling dummy lying face-up on the mat.
- The fighter is low, over the dummy, with his weight down and one hand posting.
- His right arm cocks and drops repeatedly across the eight seconds.

What is wrong:
1. **TWO DUMMIES.** There is a head at the far left AND a head at the far right of
   the same body mass — the model generated a duplicate, or one dummy with two
   heads. This is the most obvious defect in the clip.
2. **HE IS NOT ASTRIDE.** He kneels beside and over the torso rather than with a
   knee planted either side of the chest. The prompt said "knees either side of
   its chest" explicitly and it did not take.
3. **THE STRIKES READ AS PRESSES, NOT PUNCHES.** The arm descends, but there is
   little shoulder rotation and no visible hip drive. It looks like a man pushing
   down, not a man trying to finish a fight. **One of you predicted exactly this
   from the gym vocabulary — "gym wording produces gym tempo."**

## RESULT 2 — THE MOTION MODEL, SAME IDEA, 0.3 CREDITS

Three seeds. Measured on the returned skeletons:

- **pelvis above floor: 0.37 / 0.40 / 0.49 m** — he genuinely went to the
  ground. That is new: of four earlier armbar prompts, three stayed standing and
  one "sat" in mid-air. **The dummy framing gets this model to the floor.**
- **wrist below pelvis: up to 0.34 / 0.35 / 0.42 m** — the hands do travel down.
- Visually: a low crouch or sprawl with the legs trailing back and the arms
  reaching forward-and-down. **Not a mount, and not a punch.** Seed 37 stands
  back up into a crouch by the end.

**AND ONE OF MY NUMBERS WAS A MEASUREMENT BUG, DISCLOSED SO YOU DO NOT REASON
FROM IT.** I reported "knee separation 0.190 m, identical across every frame and
all three seeds". That is because I measured the HEAD of the upper-leg bone,
which is the hip joint and fixed to the pelvis by the skeleton. I measured
pelvis width — a rig constant — not knee spread. The one metric that would have
distinguished "astride" from "kneeling beside" measured nothing at all. It is
being rewritten to use the knee joint.

---

## WHAT THE OTHER REVIEWS SAID, BECAUSE YOU DISAGREED WITH EACH OTHER

You were blind to each other in round 1. You are not now, because the
disagreement is the most useful thing that came out of it and it is cheap to
settle.

- **One of you said: keep the dummy, fix the language.** Drop the weight (it is
  decoration — the model has no physics), say "thick" for visual bulk, use
  *hammerfist* because it is vertical by definition, add *hips driving forward*
  for the kinetic chain, and cut to two shots because every shot boundary is a
  freeze risk.
- **One of you said: the word "dummy" is itself the defect.** *"'Dummy' carries
  training-equipment visual priors... 'prone opponent, motionless on his back'
  carries fight context, correct proportions, and crucially — the model already
  knows what a mounted fighter does over a person in that position from thousands
  of fight clips. It does not need to invent a relationship to a prop."*

**BOTH AGREED THE WEIGHT IS DECORATION.** That is settled; it is gone.

**THE OPEN QUESTION IS THE NOUN.** "Unresisting opponent" may unlock real
mounted-GnP motion the model has actually seen — or it may re-trigger the
two-humanoid collapse that killed eight of eight, since it names a second person.
The video above is evidence for the prop side: the prop did NOT collapse. Nobody
has yet tested whether "unresisting opponent" does.

---

## WHAT I WANT NOW

- **Your revised prompt, for BOTH paths**, since they take different input:
  - the VIDEO path: one prose paragraph, no shot delimiters
  - the MOTION path: shots, each ending in exactly one period, 0.5–6.0 s each,
    max 8, starting from a standing model
- **Kill the two-dummy duplication.** What phrasing stops a generator making two
  of a prop? This is the defect with the clearest visual cost.
- **Get him actually astride.** "Knees either side of its chest" was in the
  prompt and did not take. What language does work for straddling?
- **Make the strikes commit.** The presses are the second-worst defect.
- **Your call on the noun**, now that you have seen the prop survive: dummy, or
  opponent? Say which and why, and if you have changed your mind since round 1,
  say so plainly — changing your mind on evidence is the point of round 2.
- **Is the video path worth 360x the motion path?** Video is 36 credits and gives
  pixels we would have to track with MediaPipe; motion is 0.1 and gives a
  skeleton we can retarget directly. The video is clearly better at composing the
  scene. Is it worth it, or is it a pretty distraction from the only output that
  reaches the game?

Then, as before: **argue against yourself.**

---

## CORRECTION, AND IT MAY INVALIDATE THE PREMISE YOU WERE BOTH GIVEN

**THE 8-OF-8 ONE-BODY COLLAPSE WAS THE MOTION MODEL. IT WAS NEVER MEASURED ON
THE VIDEO MODEL.**

The operator asked the obvious question I had not: *"have we ever tried text to
video with 2 humans?"* We have not. Checking the record:
`HIGGSFIELD_MMA_PIPELINE_STUDY` says *"Higgsfield Character Animation animates
ONE body per job. The operator's own two-fighter prompts: 8 of 8 one body"* -
and that was `t2m_two_fighter.py`, the `kimodo` text-to-MOTION job. Seedance
appears in that study only as a CINEMATICS path from a playblast. **No
two-human text-to-video generation has ever been run.**

So I imported a motion-model limitation into the video path without testing it,
and then wrote *"no second person anywhere in frame"* INTO the video prompt -
actively suppressing the thing that may have worked all along. Video diffusion
models render crowds. Two coupled people is very likely trivial for one.

**WHAT THIS MEANS FOR YOUR ANSWER.** The dummy-versus-opponent question you were
asked to settle may be the wrong question for the video path entirely. If
Seedance renders two coupled fighters, then:

- the dummy trick is a MOTION-model workaround only, and
- the real pipeline becomes **video -> MediaPipe -> paired motion**, for which we
  already hold 17 tracked videos, 98,136 two-person frames and the tracking code.

A two-human video generation is running now. **Revise your answer against that
possibility rather than against the premise I gave you**, and say explicitly
whether it changes your recommendation. If it does, say what the dummy is still
good for - if anything.
