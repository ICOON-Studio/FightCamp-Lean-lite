# TASK_GROUND_BAG_PROMPT — BEAT MY PROMPT, OR BEAT MY WHOLE IDEA

**Judgement and design. No code, no repo, no tests.** Read this and answer.

**YOU ARE NOT BEING ASKED TO APPROVE THIS. You are being asked to beat it.** If
you think the whole approach is wrong, say so and say what you would do instead —
that answer is worth more to me than a better adjective.

Several agents are being asked this independently and blind to each other.

---

## THE GOAL

Get **usable ground-and-pound motion** — a mounted fighter punching down — that
we can put into a 3D fight game. We cannot buy it, and we have failed to compose
it.

## THE HARD FACT THAT SHAPES EVERYTHING

We use Higgsfield text-to-motion (`kimodo` job, model `ardy-core-h8`). It returns
**ONE BODY PER GENERATION**, always. Measured, not assumed:

- Eight two-fighter generations, two prompt styles, seeds 11 and 37: **all eight
  came back as a single figure.**
- Of four armbar prompts, **none reached the ground at all** — three stayed
  standing, one "sat" in mid-air.
- A separate composition attempt (`compose_takedown.py`) paired 6 attackers with
  6 defenders, deliberately aligned — defender turned to face, fall onset on the
  attacker's reach frame, mid-thigh on the attacker's hands. It scored **0 of
  36**: every attacker stopped at the grab (follow-through 0.00–0.06 m) and the
  torsos interpenetrated in 16–81% of frames.

So: **asking it for two people does not work, and gluing two singles together
does not work.**

## THE OPERATOR'S IDEA, WHICH IS WHAT YOU ARE REVIEWING

Stop asking for two people. Ask for **one man and an inanimate object** — a
human-shaped ground-and-pound dummy of the kind fighters actually train on. The
fighter mounts the dummy and punches it. A dummy is equipment, not a person, so
it should not trip whatever collapses two humanoids into one — and the
attacker's mounted posture, hip drive and downward punches are exactly the half
we cannot get any other way.

Known limitation, already accepted: **no victim.** A dummy does not shell up,
buck, turn in or cover, so the defender half of any paired animation is still
missing. We are buying the attacker only.

## THE MECHANICS, AS OBSERVED — challenge any of these if you think I have them wrong

- A generation is a list of **shots**, each with a prompt and a duration.
- **A period is the shot delimiter.** Each shot's text must end with a period and
  contain exactly one. A second period inside a shot silently splits it.
- Max 8 shots. Each duration 0.5–6.0 s.
- **The model starts from a neutral STANDING pose.** The existing pilot carries a
  1.0 s standing preroll whose own note says the first 20 frames are cut
  afterwards. A ground clip has to get him to the floor somehow.
- **Long multi-beat timelines FROZE** — a UFC-round pilot froze on 24 of 30 and
  was abandoned. Short is safer, but I do not know where the cliff is.
- Cost is about **0.1 credit per job whatever the length**, so seeds are cheap
  and best-of-N is affordable. We hold ~924 credits.

## WHAT I HAVE WRITTEN — attack it

Three shots, five seconds:

1. *"A man kneels astride a heavy forty kilogram human shaped canvas grappling
   dummy that lies face up on the mat beneath him."* (2.0 s)
2. *"He posts his left hand on the dummy chest and drives his right fist straight
   down into its head."* (1.5 s)
3. *"He drives his left fist straight down into the dummy head and raises his
   right fist again."* (1.5 s)

The rig it has to serve: our fighter is **1.78 m, 66.7 kg**. The dummy is
described at **40 kg**, which is a real weight for a full-size human-form
grappling dummy — they are much lighter than the person they represent.

**My own doubt, so you do not have to find it:** I do not believe the stated
weight will change the output at all. What should actually matter is the dummy's
SIZE, because torso thickness sets how wide his knees splay and how high his hips
ride. If the weight is decoration, say so.

---

## WHAT I WANT FROM YOU

Answer in whatever shape suits you. There is no template and no length limit —
**take as much room as the answer needs.** These are the things I care about, not
a form to fill in:

- **A better prompt**, if you have one. Exact text, exact shot durations.
- **A better IDEA**, if the dummy is not the best trick available. Is there
  another way to make a one-body generator produce coupled motion? Something
  other than a dummy? A different framing of the same request? A different job
  type entirely? I would rather be told my idea is second-best than get a
  polished version of a mediocre plan.
- **What will go wrong with mine**, specifically. Where does it fail, and what
  does the failure look like so I can recognise it in the output?
- **How to tell success from failure** when the clip arrives. What should I
  measure or look at? "It looks right" is not usable — give me something
  checkable. This matters more than the prompt itself: we have shipped clips
  nobody watched, and we have also believed numbers that measured the wrong
  thing.
- **Whether to spend on seeds or on variants.** Same prompt across many seeds, or
  several different prompts? At 0.1 credit either is affordable.

And then, because it has repeatedly produced the best answer on this project:
**argue against yourself.** Take whatever you just recommended and attack it as
hard as you can.

---

## A FEW THINGS THAT ARE TRUE, NOT RESTRICTIONS ON YOU

- This is a real MMA sim. Ground and pound happens in a cage, in a bout, with a
  referee — not as a gym drill. If you think the clip should be prompted as a
  FIGHT rather than as training, that is exactly the kind of reframing I want.
- Female fighters never fight males. The facility a fighter trains in is a
  **"gym"**, never a "camp" — a fight camp is only pre-bout preparation.
- We already hold 38 minutes of paired 3D mocap on disk (17 tracked videos,
  98,136 two-person frames, world landmarks in metres) and a MediaPipe tracking
  pipeline. If your answer is "do not generate anything, use what you have", make
  that case.
