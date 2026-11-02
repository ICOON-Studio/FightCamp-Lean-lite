# G71 — THE ANCHORS FOLLOW THE BONE, THE CONES STAY IN THE TRUNK

**Agent:** Grok, Expert mode, in-app browser. **Delivered in 2m 59s.**
**Landed by Claude, S52, 2026-09-22.** Follows `G70_TYPED_GRIP_ANCHORS.md`.

> **CAPTURED FROM THE CHAT SURFACE.** It wrote `artifacts/G71_POSE_FRAMES.md`
> and `artifacts/g71_grip_anchors.py` in its own sandbox, which we cannot reach.
> What follows is the full answer as delivered. To get the module, ask it to
> print the file inline rather than to write one.

## WHY THIS EXISTS

G70 designed four named grip anchors and then raised its own strongest
objection, unprompted:

> *"Once the head flexes, bind-pose `t` and 'anterior' are no longer on the
> throat — weakest number is `mastoid` ±70°."*

That is the objection that would have broken this in the game, because **a
guillotine and a front headlock are both taken with the head already flexed
forward** — the two holds that need the anterior and lateral anchors most are
taken in exactly the pose where a bind-space anchor has moved off the target.
G71 answers it.

## 1. THE FRAME RULE — AND IT IS TWO FRAMES, NOT ONE

**Two posed axes, current endpoints, never bind:**

- `N` = caudal → occiput (the cervical axis)
- `H` = occiput → crown (the skull axis)

Each anchor belongs to whichever axis actually carries it:

| anchor | axis | `u` | aspect |
|---|---|---|---|
| `mid_nuchal` | **N** | 0.54 | posterior |
| `laryngeal` | **N** | 0.62 | anterior |
| `nuchal_base` | **H** | 0.04 | posterior |
| `mastoid` | **H** | 0.06 | lateral |

> *"Point-anterior follows the parent so the throat stays the throat at 40°
> flex. **Cones stay in the trunk frame so they do not nod off the attacker.**"*

**That split is the whole answer and it is not obvious.** The anchor POINTS are
parented to the bone so they track the anatomy; the approach CONES stay in the
TRUNK frame so they keep describing where the attacker is standing. Parent the
cone to the skull instead and a defender who ducks drags the legal approach
direction around with his own head.

## 2. THE FLEX ENVELOPE

`head_flex_deg` = the signed sagittal angle between `trunk_forward` and
`head_forward`; positive is chin down. Per-hold validity windows:

| hold | window (deg) |
|---|---|
| collar tie | −10 .. +25 |
| plum / double collar | +5 .. +45 |
| rear naked choke | −20 .. +45 |
| guillotine | **+20 .. +55** |
| front headlock | **+15 .. +55** |

Outside the window: **refuse. No snap, no shortened neighbours** — it carried
both prohibitions forward from G70.

**All five are labelled estimates and it named the measurement:** the 5th–95th
percentile of `head_flex_deg` on the 98,136 two-person frames we already hold.

## 3. THE MASTOID NUMBER — REPLACED, NOT DEFENDED

Asked to defend or replace its own weakest number, **it replaced it** and said
so plainly. `mastoid` goes from `az ±70°, el 0°, half 28°` to a trunk-frame cone
of **`az ±40°, el −15°, half 32°`**. Still an estimate; the measurement it names
is **wrist → ear in the trunk frame on tagged front-headlock frames**.

## 4. ITS SELF-OBJECTION, AND IT IS A FALSIFIABLE PREDICTION

> *"Survive? Yes — only while cones stay trunk-fixed and flex stays one scalar.
> **Parenting the cone to the skull is the week-waster.** Guillotine vs front
> headlock now share flex and hemisphere — **if the video mean for front
> headlock is near az 0°, `mastoid` as a separate approach cone is already
> dead.**"*

**That is not a caveat, it is a test with a named outcome.** Guillotine
(`laryngeal`, +20..+55) and front headlock (`mastoid`, +15..+55) now overlap in
both flex window and hemisphere, so the only thing separating them is the
azimuth of the approach. Measure front-headlock approach azimuth on the tagged
frames: **near 0° and the fourth anchor collapses into the third.**

## WHAT TO DO WITH THIS

**Do not ship the numbers.** Every cone and every flex window is an estimate,
and it says so. But it has now named **three specific measurements** against a
corpus we already own:

1. `head_flex_deg` 5th–95th percentile per hold → the flex windows.
2. Wrist → ear in trunk frame on front-headlock frames → the `mastoid` cone.
3. Front-headlock approach azimuth → **whether `mastoid` should exist at all**.

**Run 3 first.** It is the cheapest and it can delete a quarter of the design,
which is the most valuable thing any of these could do.

**The frame rule, by contrast, is structural and does not need a measurement.**
Points parented to their own axis, cones in the trunk frame — that is the part
to build.
