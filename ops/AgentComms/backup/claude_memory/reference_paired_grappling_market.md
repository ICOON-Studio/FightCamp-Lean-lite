---
name: reference_paired_grappling_market
description: "What paired grappling animation can and cannot be bought, with real prices read from the stores on 2026-09-21 - RamsterZ sells paired FINISHERS at $34.99 in our exact _Att/_Vic shape, and a paired BJJ POSITIONAL pack does not exist as a SKU anywhere"
metadata: 
  node_type: memory
  type: reference
  originSessionId: f02744a5-1c08-4eb6-8344-185c616bfbd1
  modified: 2026-09-21T18:02:20.829Z
---

Read from the live stores on the PC, 2026-09-21. This closed R144 lines 1 and 2,
which had been blocked since 09-18 for one reason only: `assetstore.unity.com`,
`fab.com` and the rest return `connect_rejected` at CONNECT from a cloud
container and answer fine from the operator's machine. **Any store question is a
PC question.**

**WHAT CAN BE BOUGHT** — `ramsterzanimations.com/store-buy`, no login:

| pack | price | what it is |
|---|---:|---|
| Wrestler Finishers Volume 1 | **$34.99** | 48 clips, **30 PAIRED (15 attacker + 15 victim)**, 2 staggers, 2 attacks, 3 taunts, 1 idle, 5 ring, 5 turnbuckle |
| Wrestler Finishers Volume 2 | $39.99 | same shape |
| Full Mount Attacks | $7.99 | already owned (`Paired_FullMount_Takedown_BodyLock_Loop_Att.fbx`) |
| Hand to Hand Non-Lethal Counters | $19.99 | paired counters |
| Hand to hand finishers Vol 1 / 2 | $34.99 ea | paired, striking-led |
| Martial Arts Master | $49.99 | striking catalogue |

Format, from the Volume 1 product page: **raw `.fbx` only**, UE4 Mannequin
skeleton, Unity Humanoid compatible, root motion ready. That matters more than
the price — UE4 Mannequin is `FightClipRetarget.UE4_TO_OURS`, and
attacker/victim is already what a hold needs (two clips `<Key>_Att`/`<Key>_Vic`
plus a six-field `PAIRED_BINDINGS` entry, never the strike-shaped `PAIR_KEYS`).

**WHAT CANNOT BE BOUGHT, AT ANY PRICE:** a paired **BJJ positional** pack — side
control, mount, the guards, back control, with transitions. Not on Fab, the
Unreal Marketplace or the Unity Asset Store. **This is now the third independent
time this project has reached that conclusion; stop re-checking it.** The
listing that looks right on paper, Gamma Studio's *MoCap Combat Animations –
Dual Character* (€31.08–62.18, 26 clips, Vicon, UE4 bone), is strangling with
wire, rifle-butt melee, dragging and torturing an injured person, groin kicks
and stealth kills — **no ground work at all**, rated 1.0 from one review.

**CAPTURING IT INSTEAD:** Rokoko Smartsuit Pro II ≈ **$2,495/suit**, so ≈ $5,000
paired; full kit with gloves and face $3,500–5,000 each. Rokoko Studio is
already installed on the PC and multi-actor capture is supported. **But it is
probably the wrong tool for this one job** — an inertial rig has no absolute
position reference and drifts, and grappling is its worst case: two bodies
pressed together, sensors compressed and rolled on, metal near the mat. Striking
would be fine. Optical is what this wants; owning it is out of range and a
studio day with two grapplers needs a quote. **No studio price is recorded here
because none was verified** — inventing one is how a fossil starts.

**How to apply:** do not buy suits. Once the retarget is fixed, $34.99 on
Wrestler Finishers Volume 1 is the cheapest real test — does a BOUGHT paired
take survive our pipeline and keep its contact? A clip run through a retarget
still 0.17 m out at the hand tells you nothing about the clip. And note what the
demand actually is: Q114 found existing film already covers **80.4%** of 2,477
grapple events, and the single biggest gap is `grapple_clinch_engage` at 3.8%,
which is **standing** — servable from what we already own. Related:
[[project_paired_3d_mocap_on_disk]], [[project_higgsfield_mma_study]],
[[project_cascadeur_kept]].
