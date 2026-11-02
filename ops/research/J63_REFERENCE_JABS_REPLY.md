# J63_REFERENCE_JABS_REPLY - Grok bot john reply, verbatim (S236 collect)

On it. I'm checking Ludo's three reference jabs, the free mocap sources, and his timing claims now. I'll paste the full answer with sources when it's done.

The J63 check is running now. I'll paste the full answer here and attach the file when it's done.

I've checked Ludo's three reference jabs. All three fights' dates, venues and rounds are right, but none of his three timestamps could be confirmed. I can't watch video, so a person needs to scrub each moment.

Of his biomechanics claims, the extension time and the shoulder lift hold up. The retraction claim is backwards: measured retraction is about 2x slower than extension, not faster. I found no source at all for the 15 ms heel drop. The full memo is below and attached.

## 1. Holmes vs Cooney, 11 Jun 1982, round 2
- **Facts confirmed** ([Wikipedia](https://en.wikipedia.org/wiki/Larry_Holmes_vs._Gerry_Cooney)): Caesars Palace, Las Vegas, WBC and Ring heavyweight titles, referee Mills Lane. Holmes dropped Cooney in round 2 and won by TKO in round 13 when Cooney's trainer threw in the towel. Both fighters are orthodox. HBO re-aired the fight a week later.
- **Video:** I found no official HBO upload. Fan full-fight uploads came up in search but weren't load-checked: `-ZFgK1lIU8M` (the Howard Cosell version), `6s2rOOocTXs` and `_tBqID-E68I`.
- **"04:18 on the HBO reel": NOT CONFIRMED.** No official reel turned up. On a full upload, 04:18 would usually still be in the intros or round 1, so Ludo needs to name the exact video ID.
- **Angle:** a high, wide side angle at standard definition is likely, but that's my inference.

## 2. Golovkin vs Lemieux, 17 Oct 2015, round 1
- **Facts confirmed:** Madison Square Garden on HBO PPV, referee Steve Willis. Lemieux went down in round 5 and Golovkin won by TKO at 1:32 of round 8. There was no knockdown in round 1. GGG is orthodox.
- **Official video that loads:** [DAZN Rewind full fight](https://www.youtube.com/watch?v=zI_k8cDCV1E).
- **Ludo's timestamp:** "2:44–2:48 of the round" is possible. "09:12 on the tape" is unverified, because it depends on how long the intros run. In the corner after round 1, Abel Sanchez says "very good jab", so GGG's jab was landing that round.

## 3. Taylor vs Serrano I, 30 Apr 2022, round 3
- **Facts confirmed:** MSG on DAZN, undisputed lightweight titles. Taylor won a split decision (94–96, 97–93, 96–93) over 10 two-minute rounds, with no knockdowns.
- **Stance:** Taylor is orthodox and Serrano is a southpaw, so this is an open-stance jab on a different line from the other two. Don't use it as the generic jab without noting that.
- **Official video:** [Matchroom full fight](https://www.youtube.com/watch?v=2Vqjc10kai4) is 22:38 and probably cut down (most likely without the breaks). There's also a [DAZN playlist copy](https://www.youtube.com/playlist?list=PLqbKSibnZu3fEtWNjrpMAni8TdGdeC88X).
- **Ludo's timestamp:** "1:14–1:18 of round 3" fits inside a 2-minute round, but whether a jab actually lands there is unverified.

**How a person finds the clean jab:**
1. Use the official upload, convert the round time to the video time, and scrub ±10 s at 0.25× speed.
2. Pick a fully side-on jab that the referee isn't blocking and that returns cleanly to guard.
3. Log the video ID, the video time and the round clock.
4. Check by eye: chamber, extension line, fist turn, shoulder lift, rear-hand guard, lead heel and retraction.

Broadcast video runs at 30 or 60 fps, which is 17–33 ms per frame, so a 15 ms heel drop can't be seen on it anyway.

## Freely usable jab references
| Source | Licence | Jab? |
|---|---|---|
| [CMU Graphics Lab Mocap](https://mocap.cs.cmu.edu/) | Custom CMU terms: free for research, can ship inside commercial products, can't be resold as raw data, and acknowledgement is requested. Not a named open licence. | Boxing trials 13_17, 13_18, 14_01–03, 15_13 and 17_10. Subject 144 ("punching female", 120 fps) has Left_Punch_Sequence001/002. None are labelled "jab", but left punches by an orthodox subject are likely jabs. Start with subject 144, since the low-numbered subjects are lower quality. |
| [Adobe Mixamo](https://helpx.adobe.com/creative-cloud/faq/mixamo-faq.html) | Adobe terms: royalty-free in commercial games with no attribution, but the raw files can't be redistributed. | It has punch and boxing clips, but I didn't confirm a clip actually named "jab". |
| [BoxingVI dataset](https://arxiv.org/abs/2511.16524) | No licence stated. It's annotations over 20 YouTube videos, so the footage keeps its original copyright. | Yes: 6,915 punch clips including jabs, with 2D pose. Fine for study only. |

Rokoko free packs, AIST++ and Human3.6M weren't checked this pass. From memory, AIST++ is dance only and Human3.6M is non-commercial academic use only, but treat both as unverified. CMU is the best candidate for commercial use, though legal should confirm the custom terms.

## Ludo's timing claims
| Claim | Evidence | Verdict |
|---|---|---|
| Extension 120–140 ms | [Sensors 2021](https://www.mdpi.com/1424-8220/21/23/7882), wearable sensor on jabs into a heavy bag: throw phase 117 ± 25 ms for experienced boxers and 135 ms for inexperienced | Roughly supported |
| Retraction 90–110 ms, about 1.25x faster | Same study: retraction 262 ± 42 ms experienced, 212 ± 75 ms inexperienced; whole jab 485–524 ms | Contradicted: retraction is about 2x slower |
| Heel drops about 15 ms before contact | Nothing found. [Whiting et al. 1988](https://pubmed.ncbi.nlm.nih.gov/3377096/) found arm speed peaks 8–21 ms before contact, which is about the arm, not the heel | Unsupported, possibly a mix-up with Whiting |
| Shoulder rises to cover the chin | Coaching description in the [J Phys Ed Sport 2022 jab study](https://doi.org/10.7752/jpes.2022.03083) | Supported as coaching, not as a measured value |

**More measured data:**
- [Piorkowski et al. 2011](https://www.tandfonline.com/doi/full/10.1080/14763141.2010.547590), 10 competition boxers in optical mocap: straight punches took 357 ± 178 ms from start to contact, with contact speed of 9.3 m/s.
- [Kimm & Thiel 2015](https://doi.org/10.1016/j.proeng.2015.07.232), 16 amateurs: air-jab peak speed 8.1 m/s for men and 6.6 m/s for women, with no durations given.
- **Not retrieved:** Atha 1985 and Lenetsky.

**For the animators:** use about 115–135 ms for extension. Make retraction equal to or slower than extension, unless it's deliberately a snap-back air jab. Drop the 15 ms heel rule or label it a design choice, and keep the shoulder lift.

**Not covered:** Rokoko, AIST++, Human3.6M, Atha, Lenetsky, coaching breakdowns of each fighter's jab, and every frame-level detail and timestamp.

[attachment: J63_REFERENCE_JABS.md]
