# TASK J15 — JOHN — HOW LONG IS A KNOCKDOWN, AND WHAT FILLS THE TIME

Deep research only. One deliverable file. No code, no test, no repo commands.
Owner: john. Task id: J15.
Deliverable: `J15_THE_KNOCKDOWN_CLOCK.md`

## Why this, and why now

In J14 you corrected two rules we were about to ship wrong — the standing eight
count is **not** current professional practice, and the three-knockdown auto-stop
is **not** ABC but WBA Rule 12. You also concluded that most of the referee is
scenery. We acted on all three.

This task is the direct consequence. We are now building a 3D view of the fight,
and our simulation emits a knockdown as a **single instantaneous flag on one
impact**. It has no duration. It says a man went down; it does not say for how
long, and it does not say what happens next.

To show a knockdown we need a **clock**. That clock is not in our engine and we
will not invent it — we would rather have your numbers.

## The questions

**1. THE HEADLINE: how long is a knockdown, in seconds?**
From the moment a boxer's glove/knee/body touches the canvas to the moment the
fight is live again. Break it into the parts that actually take time:
   - the referee reaching the fighter and starting the count
   - the count itself (what is the real cadence — is a "count of eight" eight
     seconds, and does the referee's pace vary?)
   - the mandatory eight even when the fighter is up immediately
   - the referee's check (the questions, the glove wipe, the look at the eyes)
   - the wave-on
Give a **realistic total range in seconds** for the shortest and longest ordinary
knockdown. That range is the single number we will build to.

**2. The knockdown he gets straight up from.**
Our engine distinguishes a knockdown a man **rose from** from one he did not.
Is that a real distinction in the rules, and does a fighter who bounces straight
up still get the full count? What is the shortest a knockdown can legitimately
take?

**3. What does the DOWNED FIGHTER's body actually do?**
This is the animation question and it is the reason for the task. Between going
down and standing back up, what are the distinct physical states? Enumerate them
as things you could film: the fall itself, what he lands on, what he does on the
canvas, how he gets up (does he use the ropes? is that legal?), where he goes
while the referee counts. **We need this as a list of distinct body states**,
because each distinct state is a clip we may have to buy.

**4. What does the OTHER fighter do?**
Where does he have to go, who sends him there, and how long does he stand there?
A neutral corner is a rule with a real consequence — what happens if he does not
go, and does the count start before he does?

**5. MMA is different and we need it separately.**
You established that MMA has no count. So what actually happens in the seconds
after an MMA knockdown — what is the referee doing, what is the downed fighter
doing, what is the standing fighter doing? How long is that window before either
the fight continues on the ground or it is stopped? **Say plainly if the answer
is "it is not a discrete event at all in MMA"** — that is a usable finding and
would tell us this whole clock is boxing-only.

**6. And the one that decides whether we build any of it: how OFTEN?**
Roughly how many knockdowns occur per professional bout, or what share of bouts
contain one? If knockdowns are rare enough, a fully animated knockdown sequence
is the last thing we buy rather than the first. We are measuring our own
engine's rate in parallel; yours is the real-world number to check it against.

## The standing rule for your work

**Correct us where we are wrong.** J14's value was that two of its ten findings
overturned things we believed. If anything in this brief contains a false premise
about the rules, say so first and answer the corrected question.

**Where a rule differs by jurisdiction or by sanctioning body, say which** — but
note that we ship ONE corner rule rather than a jurisdiction table, so tell us
what the *common* practice is as well as where it differs. We need a default, not
a matrix.

**Where you cannot source something, say "not found".** Do not fill it in.

## Explicitly out of scope

- Designing a referee object, a state machine, or any code. Do not.
- The ground game, submissions, and grappling positions.
- Scoring and the scorecards — separate work, already done.

## Format

One markdown document. Open with a **DECISIONS** block of at most ten lines: the
seconds, the list of body states, and anything you refuse. Then the evidence.
We read the top and build from it.

**Send the finished file back.** Name it `J15_THE_KNOCKDOWN_CLOCK.md`.
