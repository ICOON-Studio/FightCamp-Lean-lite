# J_GUARDPACE1_JOHN - John answer (seat queue SQ15)

Brief: research/TASK_J_GUARDPACE1.md
Sent: 2026-10-29 06:17 | collected: 2026-10-29 06:40 by Tools/seat_queue.py (the 30-min reconcile)
Attachments on the bot's box (not downloaded): J_GUARDPACE1.md
Verify the sources before using it.

---

Starting J-GUARDPACE1 now. First I'm pulling guard measurements, punch-rate data and fighting-game impact-frame sources.

J-GUARDPACE1 research is running, and I'll post the full sourced answer here with the .md attached when it's done.

**J-GUARDPACE1 is done**, though several key numbers are still estimates. The biggest corrections are that the jab is about 0.30–0.36 s from first movement to contact, not 0.4 s, and that the guard should bob at about 1 Hz.

Most numbers below come from abstracts or search excerpts, not full papers I read. I couldn't open the England Boxing handbook. Glove distance, bounce size, head-snap angle and jab distance have no source and are marked ESTIMATE.

**1. The guard**
- **Coaching position:** lead glove at eyebrow height, rear glove on the cheekbone, elbows on the ribs, chin behind the lead shoulder. Feet about shoulder width apart, knees slightly bent, rear heel up. These are qualitative, from the [Boxing Scotland toolkit](https://www.boxingscotlandtoolkit.org/session-delivery/skill-fundamentals-stance-guard/) and [Honour & Glory Boxing](https://www.honourandglory.co.uk/coaching/foundations-guard-footwork-jab-cross).
- **Weight at rest:** 55.9% on the rear foot and 44.1% on the lead foot.
  - The lead foot carries its weight on the heel (63.7%), and the rear foot on its forefoot (51.8%), so the rear heel is light.
  - Source: a [foot-pressure study](https://www.researchgate.net/publication/352646639), about 2021.
- **Weight during a cross:** 60.6% front and 39.4% rear in elite boxers ([Dinu & Louis 2020](https://pmc.ncbi.nlm.nih.gov/articles/PMC7739747/)).
- **Angles at impact:** knee 142.8° and neck flexion 23.1° (Dinu 2020). The neck angle is our best number for how far the chin tucks.
- **Idle rhythm:** elite women make about 63 up-and-down hip movements per minute, roughly 1 Hz ([Davis et al., women](https://pubmed.ncbi.nlm.nih.gov/25933441/)). Men are lower, about 47 per minute ([Davis 2015](https://pubmed.ncbi.nlm.nih.gov/24912199/)).
- **ESTIMATES:** gloves about 10–20 cm in front of the face, a bounce of 2–5 cm, and feet about 0.25 × height apart.
- **Why ours looks fake (design suggestion):** a frozen guard is the giveaway. Add a constant bob of about 1 Hz and 2–5 cm, small hand pumps and feints, rear heel up, and the chin tucked about 23°.

**2. Pace**
- **Punches thrown per minute per boxer:** about 16 for elite women at the 2012 Olympics. About 20 for Olympic men, and about 21 for men after the 2013 rule changes ([Davis 2018](https://doi.org/10.1519/jsc.0000000000001864)).
- **Activity:** about 1.6 actions per second for women. For men, active time outweighs breaks 18 to 1, falling from 31:1 in round 1 to 6.6:1 in round 3 (Davis 2015).
- **2023 IBA women's World Championship finals:** 1,323 attacking actions over 12 bouts, about 6 attacks per minute per boxer. Boxers who threw single counterpunches tended to lose ([PMC 2025 study](https://pmc.ncbi.nlm.nih.gov/articles/PMC12452553/)).
- **Start to contact:** jab and cross 357 ± 178 ms, hook 477 ± 203 ms. The second punch of a combination lands about 125 ms after the first ([Piorkowski et al. 2011](https://knowledge.lancashire.ac.uk/id/eprint/3757/1/piorkowski-et-al-2011-punch-kinematics.pdf)).
- **A cross measured with a wearable sensor:** 402 ms in total, of which 111 ms to the target and 169 ms coming back ([Sensors 2021](https://www.mdpi.com/1424-8220/21/23/7882)).
- **Checking our numbers:**
  - Jab at about 0.4 s to contact should be **0.30–0.36 s**.
  - Power punch coming back in about 170 ms is **confirmed** (169 ms).
  - Jab coming back in 262 ms is not independently confirmed.

**3. Power on screen**
- **Hip rotation:** about 17° (range 10–27°) in a straight right ([Cheraghi 2014](https://aassjournal.com/article-1-136-en.pdf)). Experienced boxers turn the pelvis more, while novices twist the spine ([pelvic-rotation study](https://core.ac.uk/download/223208425.pdf), degree values not seen).
- **Elbow at impact:** about 113°, so the arm is never locked straight (Dinu 2020).
- **Impact on a crash-test head:**
  - A straight punch hits at 3,427 N and 9.14 m/s, with peak head rotation acceleration of 6,343 rad/s² ([Walilko & Viano 2005](https://pmc.ncbi.nlm.nih.gov/articles/PMC1725037/)).
  - A hook hits at 11 m/s and 4,405 N, with 9,306 rad/s² ([Viano 2005](https://journals.lww.com/neurosurgery/fulltext/10.1227/01.neu.0000187541.87937.d9)).
  - Neither gives the head-snap angle in degrees.
- **Street Fighter 6 hit-stop:** light 9 frames (150 ms), medium 11 frames (183 ms), heavy 13 frames (217 ms) ([FeelFrames](https://feelframes.dev/g/street-fighter-6-hit-stop)).
- **[Sakurai on hit-stop](https://www.youtube.com/watch?v=CiQzmwz_Olg):** both fighters freeze, the one hit shakes more and the shake fades, and the hurt pose blends in over about 4 frames.
- **Design suggestion (ESTIMATE):** use a shorter freeze than Street Fighter, 2–3 frames for a jab and 4–6 for power punches. Combine it with the rear foot pivoting, the hips turning about 17°, weight moving to about 60% on the front foot, and the receiver's head snapping back.

**4. Where punches land**
- **Head vs body:** in the 2023 women's finals, about 80% of landed punches hit the head and about 20% the body (1,052 of 1,309, my own sum from the paper's tables). Men land about 5 to the head for every 1 to the body (Davis 2015).
- **How often attacks land:** winners land 38–39% of their attacking actions, losers 26–29% (2023 finals paper).
- **Hits on the guard:** no study gives a share. Davis 2015 only says boxers took punches on their guard.
- **Jab distance:** arm span is about 1.01 × height ([ScienceDirect study](https://www.sciencedirect.com/science/article/pii/S2666602222001598)). From that, I estimate a jab lands at about 60–75 cm face to face for a 169 cm woman (ESTIMATE).
- **Fix for punches aiming at the hands (design suggestion):** aim each fist at a target point on the opponent's chin or nose. Only play the separate fist-meets-glove animation when the defender's block actually succeeds.

**Datasets:** none usable yet. CompuBox is proprietary, and I found no open mocap of a boxing guard. The CMU motion-capture database has boxing clips, but I haven't checked their licence. The two timing papers publish their own tables.

**Gaps:**
- **Guard measurements:** glove and elbow distances, stance width and bounce size in cm, and how often boxers pump their hands or feint.
- **Cross mechanics:** shoulder and rear-foot pivot angles, plus the receiver's head-snap angle and timing.
- **Pace data:** women's pro punch counts, how long combinations usually are, and the seconds between exchanges.
- **Defence:** the share of punches blocked on the guard.
- **Game sources:** Tekken frame data, camera-shake numbers, and Fight Night or Undisputed animation talks.

The full report is attached.

## CORRECTION (Claude, S302, primary source read)
The "second punch lands about 125 ms after the first" line above is NOT in Piorkowski, Lees & Barton 2011. The paper
(p. 11) measures contact of the 1st to contact of the 4th punch: 1.06 +- 0.46 s with alternating hands (left lead),
1.04 +- 0.42 s (right lead), 1.35 +- 0.27 s with the same hand - about 0.35 s and 0.45 s per punch. Lean uses those
(FightView.COMBO_LAND_S / COMBO_SAME_HAND_S, RoundScript.COMBO_GAP_S).
