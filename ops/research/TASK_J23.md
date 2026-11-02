# TASK J23 — JOHN — THE MUAY THAI ANIMATION PACK, PRICED BEFORE THE SALE

**DEEP RESEARCH ONLY.** No checkout, no Godot, no repo access — none is needed.
Do not propose code. **Deliver a priced, licence-checked comparison table.**

**DO THIS BEFORE J22 (the audio cue list).** J22 has no deadline. **This one
does: the Unity sale opens 2026-09-14 with 50% off 300+ best sellers, and the
decision has to be made before it closes.**

## The situation, stated completely — you need nothing else

We have a 3D fighting-simulation game with a working fight. The simulation is
rich; the animation library is thin, and that gap is now the bottleneck.

**Our engine knows SEVEN muay thai knee and elbow techniques:**

| knees | elbows |
|---|---|
| `straight_knee` | `horizontal_elbow` |
| `clinch_knees` | `diagonal_elbow` |
| `knee_curfew` | `spinning_elbow` |
| | `up_elbow` |

plus `muay_thai_plum` (the clinch that sets the knees up) and
`eight_limb_chain`. Also live and unanimated in the wider striking set:
`muay_thai_teep`, `kickboxing_front_kick`, and `boxing_slip_counter`.

**We own TWO animation clips for all of that:** one knee (0.900 s) and one
spinning elbow (1.133 s). That is the entire library.

**So the moves exist and the film does not.** A fighter throws a `diagonal_elbow`
and the screen shows nothing, or shows the one spinning elbow we have.

## What we already own, so you do not recommend buying it twice

A **RamsterZ "H2H" pack** (hand-to-hand, cinematic martial arts), from which we
use punches, kicks, hit reactions, staggers, knockdowns, blocks, slips and an
idle. It is generic martial arts, not muay thai: **one knee, one elbow**, and its
kicks appear to be flying/spinning kicks rather than the grounded round kick a
Thai fighter throws. We also own a **RamsterZ "Full Mount Attacks"** paired
ground pack.

**Do not recommend another generic martial-arts pack.** We need the muay thai
vocabulary specifically: grounded round kicks, teeps, knees from the plum, and
elbows from more than one angle.

## THE FIVE QUESTIONS

**1. WHAT MUAY THAI / KICKBOXING ANIMATION PACKS EXIST?** Name them, with
publisher, store, list price and — where a sale is running or announced — the
sale price. Cover the Unity Asset Store first (the 09-14 sale is the deadline),
then anywhere else that sells humanoid animation: ActorCore, Mixamo, Rokoko,
Kybernetik, artist stores, marketplaces. **A pack that is cheaper elsewhere is
worth flagging — on this project the cheaper source has differed per pack
before, so check both every time.**

**2. WHAT IS ACTUALLY IN EACH ONE?** This is the question that decides it. For
each pack, list the clips **by name** as far as the listing allows, and say how
many are knees, how many elbows, how many round kicks, how many teeps. **A pack
of 200 clips that is 180 locomotion and 4 strikes is worse than a pack of 30 that
is all strikes.** Where the listing does not enumerate its clips, say **NOT
FOUND** rather than estimating — we have been burned by a count nobody verified.

**3. WILL IT RETARGET ONTO OUR RIG?** Our fighters use a humanoid skeleton with
22 mapped rows; our existing bought pack is authored on the **UE4 Mannequin** and
we retarget it with a bone map we already own. So: what skeleton is each pack
authored on? **Humanoid/Mecanim, UE4 Mannequin, Mixamo and the Godot humanoid
profile are all workable; a proprietary or unnamed rig is a risk.** Say which
each pack is, and label it DOCUMENTED or INFERENCE.

**4. THE DELIVERY PROBLEM, AND IT HAS ALREADY COST US A PAID PACK.** Unity is
**not installed** on the machine this project is built on, and the Unity Asset
Store now offers only "Open in Unity" — no web download, and its JSON download
endpoint returns 404. **We bought a RamsterZ pack, the store confirms the
purchase, and the file has never existed on our disk.** So for each pack you
list, say **how the files are actually delivered**: a direct download, a
`.unitypackage` that needs the Editor, a zip of FBX/GLB, a web dashboard.
**A pack we cannot extract is worth nothing however cheap it is**, and this may
well be the deciding column rather than price.

**5. THE LICENCE.** For each pack, what does the licence permit? Two hard
constraints on this project: **we ship commercially**, and **one vendor's direct
EULA forbids AI use while the same pack bought through a storefront does not** —
so the same asset can be safe or unsafe depending on where it was bought. Flag
any pack whose licence would block commercial release, and any where the store
version and the direct version differ.

## RULES FOR THE ANSWER

**LABEL EVERY CLAIM**: **DOCUMENTED** (a published listing or licence — name and
link it), **INFERENCE** (your reasoning, and from what), **NOT FOUND** (you
looked and it is not published — a good answer, and we want it explicitly).

**PRICES AND CLIP COUNTS MUST BE REAL OR MARKED NOT FOUND.** These go straight
into a purchase. A fabricated clip count is the worst possible output here.

**LEAD WITH ONE LINE**: the pack you would buy, its sale price, how many of our
seven knee/elbow moves it covers, and how the files are delivered. Everything
else underneath.

**RANK, DO NOT PICK A SINGLE WINNER AND DROP THE REST.** Give at least three
options with what each costs and what each gives up, including the option of
buying nothing. The decision is the operator's and they make it from your table.

**SEARCH PROPERLY.** A study on this project once concluded a whole category of
animation did not exist anywhere, and a ten-euro listing tagged with the exact
term disproved it the same day. If you find nothing, say what terms you searched.

## Owned files — the collection target

This agent has **no checkout and cannot push**. The deliverable is real
regardless: Claude collects the answer and writes the file below. Naming it here
is what lets `python Tools/agent_comms.py done --task J23` mean *"has this been
collected yet?"* rather than passing on nothing.

- `research/J23_THE_MUAY_THAI_PACK.md`

**The agent is not asked to create it and must not be given a git command.**
