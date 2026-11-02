# R144 lines 1 and 2 — what can actually be BOUGHT for paired grappling

**Done 2026-09-21 on the PC, which is what the blocker said it needed. Both
lines are answered. The short version: the vendor we already use sells paired
grappling at $35, in exactly the `_Att`/`_Vic` shape our pipeline already
consumes — but it is pro-wrestling FINISHERS, and nobody sells the thing R144
was actually about, which is HELD BJJ POSITIONS.**

The blocker's text was right that this needed a PC session:
`assetstore.unity.com` and the rest answer here and returned `connect_rejected`
at CONNECT from the cloud container on 2026-09-18.

## Line 1 — the RamsterZ catalogue, with prices

Read from `ramsterzanimations.com/store-buy` (no login, public store page).
Everything grappling-adjacent, and what each one is:

| pack | price | what it is |
|---|---:|---|
| Wrestler Finishers Volume 1 | **$34.99** | 48 clips: **30 PAIRED (15 attacker + 15 victim)**, 2 staggers, 2 attacks, 3 taunts, 1 idle, 5 ring, 5 turnbuckle |
| Wrestler Finishers Volume 2 | $39.99 | the sequel, same shape |
| Full Mount Attacks | $7.99 | we already hold this one — `Paired_FullMount_Takedown_BodyLock_Loop_Att.fbx` |
| Hand to Hand Non-Lethal Counters | $19.99 | paired counters |
| Hand to hand finishers Volume 1 / 2 | $34.99 each | paired finishers, striking-led |
| Martial Arts Master | $49.99 | the striking catalogue |
| Hostage Set | $7.99 | paired |
| Couples Anim Pack | $21.99 | paired, non-combat |

Format, verified on the Volume 1 product page: **raw `.fbx` only**, UE4
Mannequin skeleton, Unity Humanoid-compatible, root motion ready. No models, no
blueprints, no textures.

**WHY THAT FORMAT MATTERS MORE THAN THE PRICE.** Those are the two facts that
make a purchase cheap to integrate here: the UE4 Mannequin skeleton is
`FightClipRetarget.UE4_TO_OURS`, which is already the default name map for a
paired clip, and the attacker/victim split is already what a hold needs — two
clips named `<Key>_Att` / `<Key>_Vic` plus a six-field `PAIRED_BINDINGS` entry,
and never `FightMoveScript`'s strike-shaped `PAIR_KEYS`. A $35 pack is a drop-in
test of the pipeline, not a project.

## Line 2 — the wider store, and the thing that is not for sale

Searched Fab, the Unreal Marketplace and the Unity Asset Store for a paired BJJ
positional pack — side control, mount, closed/open/half guard, back control,
with transitions between them. **It does not exist as a SKU.** This is the third
independent time that conclusion has been reached here (the earlier six-source
survey, R144's own premise, and now), so it should stop being re-checked.

The one listing that looked like it on paper, `MoCap Combat Animations - Dual
Character` (Gamma Studio, Vicon, 26 clips, UE4 bone, 60 fps, €31.08-62.18), is
strangling with wire, rifle-butt melee, dragging and torturing an injured
person, groin kicks and stealth kills. **No ground grappling at all.** Rated 1.0
from one review. Do not buy it. Recording it here by name so nobody pays €62 to
find that out twice.

## What it costs to CAPTURE it instead, and the trap in that

Rokoko Smartsuit Pro II is about **$2,495 per suit**, so a paired capture needs
roughly **$5,000** of suits; a full kit with gloves and face runs $3,500-5,000
each. Multi-actor capture in one synced scene is supported, and Rokoko Studio is
already installed on this PC.

**AND IT IS PROBABLY THE WRONG TOOL FOR THIS ONE JOB.** Those suits are
inertial. An IMU rig has no absolute position reference, it drifts, and it is
disturbed by exactly what grappling does to it: two bodies pressed together,
sensors compressed and rolled on, metal near the mat. Striking capture would be
fine; side control is the worst case for the technology. So $5,000 of suits is
NOT a safe buy for the one thing we cannot get elsewhere.

Optical capture is what this actually wants, and owning it is out of range. The
realistic form is **a day of studio time with two grapplers**, which needs a
quote — no price is recorded here because none was verified, and inventing one
is how a fossil starts.

## What we already own and have not exhausted

- **98,136 two-person tracked frames**, 38 minutes over 17 videos, world
  landmarks in metres, already on disk.
- **CMU paired mocap** — free and permissively licensed, and the S39/S40 fixture.
  No martial arts in it.
- **Cascadeur Pro**, kept 2026-09-21, and that ruling already commits us to
  authoring five holds.

## The recommendation

**Do not buy suits. Buy Wrestler Finishers Volume 1 at $34.99 and nothing
else, and not until S41 has landed.**

The reasoning is S40's: the retarget was losing 0.17 m at the hand before any
question of data, and the fix is `now`. A bought clip run through a pipeline
that is still 0.17 m out tells us nothing about the clip. Once S41 lands, that
$35 is the cheapest possible test of a real question — does a BOUGHT paired take
survive our retarget and hold its contact? — and it arrives in the exact
`_Att`/`_Vic`, UE4-Mannequin shape we already consume.

If it lands clean, a studio day for the held positions is worth getting quoted.
If it does not, no amount of capture would have helped and the money is unspent.

## Sources

- https://www.ramsterzanimations.com/store-buy
- https://www.ramsterzanimations.com/store-buy/p/wrestler-finishers-volume-1-fbx-only
- https://www.fab.com/listings/e2b5225b-14b2-4d03-857f-6308c7b1e30f
- https://www.rokoko.com/products/smartsuit-pro
