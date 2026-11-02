# G134 KICKBOXING LEG KICK SHARE

Grok (Expert), chat grok.com/c/eaf86efc-b403-4eb4-9cb6-5c9a1fc45e79, collected S98 2026-09-27 by Claude.
Task: `TASK_G134_KICKBOXING_LEG_KICK_SHARE.md`. Text below is Grok's answer, tables flattened to markdown.

Sim at ~2.3 landed leg strikes / ~8% of landed is below every published K-1/Glory count. Best target-split study
puts legs at ~18% of landed. High-volume Dutch kickers go far above that. PROXY 14-20% is the average band, not a
kicker ceiling.

## 1. Glory / K-1 / ONE (3x3) - landed mix

No CompuStrike-style public database for modern Glory. Two video-count studies + one broadcast card.

| Source | Sample | Clock | Landed / fighter | Head | Body | Legs | Leg share of landed | Notes |
|---|---|---|---|---|---|---|---|---|
| Zav'yalov et al. 2014 | 100+ Glory WS + Superfights Tokyo, 214 fighters | paper says 6 min | punches 44.0, kicks 30.7, total ~75 | - | - | - | kicks = 41% of landed (all heights) | kick acc. 60%, punch acc. 26% |
| Wasacz / Niewczas 2024 | 10 simulated K-1 spars, 20 pros | spar | 47.6 effective | 580/952 = 61% | 204/952 = 21% | 168/952 = 18% | 17.6% | best target split |
| Derived | Zav'yalov kicks x Wasacz kick-to-leg fraction (~52%) | - | ~16 to legs | - | - | ~16 | ~21% | PROXY |
| Glory 12 broadcast | Van Roosmalen vs Kiria | 3x3 | 118 total landed (RVR) | - | - | 59 | 50% | Dutch high-volume outlier |
| Slimani 2017 | 36 elite low-kick bouts (WAKO 3x2) | 3x2 | thrown, not landed | 57% of attacks | 43% body/leg | low kick = 28% of attacks (men) | - | different ruleset |

Wasacz raw: 416 thrown to legs, 168 landed (40% land rate). Right low kick is the workhorse (14.9 thrown / 5.6 landed
per fighter per spar). ISKA K-1 mix (thrown): punches 50% / kicks 32% / knees 18%. PROXY.

Read for the sim: 8% is not Glory-average. Average landed-to-leg is 15-21%. The all-kick share (~41% of landed) must
not be used as the leg band.

- https://cyberleninka.ru/article/n/quantitative-and-qualitative-assessment-of-hitting-actions-in-modern-professional-kickboxing-k-1/pdf
- https://www.balticsportscience.com/cgi/viewcontent.cgi?article=2030&context=journal
- https://glorykickboxing.com/news/glory-12-by-the-numbers
- https://journals.humankinetics.com/view/journals/ijspp/12/2/article-p182.xml

## 2. Low kicks - thrown / landed / style split

| Style | Thrown low kicks / fight | Landed | Land rate | Share |
|---|---|---|---|---|
| Mean K-1 spar (Wasacz) | R 14.9 + L ~5.9 = ~21 | 8.4 | R 38%, L 47%, combined 40% | legs 18% of landed |
| Elite low-kick men (Slimani, 3x2) | 34 +/- 5 | - | - | 27.6% of attacks; 76% of kicks |
| Elite low-kick women (Slimani) | 41 +/- 6 | - | - | 40.5% of attacks |
| K-1 B-class (Ljubisavljevic) | - | - | - | low kick 22% of techniques thrown |
| Dutch volume (RVR Glory 12) | - | 59 legs (one fight) | 45% overall | 50% of landed |
| Boxing-first / counter | low | low | - | well below 15% legs - PROXY |

Per round (3x3 PROXY from Wasacz): ~2-3 landed low kicks/round typical; 5-8+ Dutch kicker; 1-2 counter striker.
Checks of low kicks: 13 +/- 5 per fight (men).

- https://www.researchgate.net/publication/303357924_The_Activity_Profile_of_Elite_Low-Kick_Kickboxing_Competition
- https://www.researchgate.net/publication/357835548_TECHNICAL_AND_TACTICAL_ANALYSIS_OF_KICKBOXING_FIGHTERS_K1-B_CLASS

## 3. Damage curve - limp and stoppage (no published strike-by-strike tally; case counts only)

| Fight | Rules | Visible limp | Stoppage | Clean lows before limp | Notes |
|---|---|---|---|---|---|
| Hoost (self) | K-1 | - | - | 3 ("for me, 3") | specialist power |
| Verhoeven vs A. Silva, Glory 33 | 3x3 | R2 inside low | TKO R2 2:57 (3-KD) | 16/22 kicks in R1 | inside thigh |
| Wilnis vs Rodriguez, Glory 63 | 3x3 | end R2 | TKO 0:15 R3 | PROXY ~8-15 | accumulated ~6 min |
| Stephens vs Melendez | UFC | mid-fight | decision | 32/35 leg kicks, mostly calf | MMA |
| Vera vs O'Malley I | UFC | R1 drop-foot | TKO R1 | few calf kicks | MMA, nerve |
| Poirier vs McGregor 2 | UFC | R1 stance collapse | KO (not the leg) | accumulated calf | MMA |

Thigh: conditioned fighters eat 8-15 clean before a visible limp; stoppage later or via 3-KD. Calf/peroneal: 1-5 hard
can force a stance switch or drop-foot.

- https://en.wikipedia.org/wiki/Rico_Verhoeven
- https://glorykickboxing.com/news/wilnis-chops-down-rodriguez-with-leg-kicks
- https://www.nytimes.com/athletic/1666839/2020/03/10/rise-of-the-calf-kick-how-a-forgotten-technique-became-mmas-hottest-strike/

## 4. Calf vs thigh

| | Thigh | Calf |
|---|---|---|
| Glory/K-1 usage | default | legal, historically uncommon |
| Strikes to compromise | 8-15 clean to visible limp | 1-5 hard to numbness / stance switch |
| Published KB count | none head-to-head | MMA case series only |

Do not set the kickboxing limp curve to the calf-MMA curve unless the sim targets the calf.

**RECOMMENDED BAND: leg share of landed strikes 20-40% (kicker), 8-15% (counter striker); limp after 8-12 clean thigh / 3-6 calf.**

## Claude's read (S98)

U189 landed 15.4% (thai vs counter pooled) and 20.0% (dutch vs counter pooled). Those are POOLED pair figures; Grok's
band is per style. A kicker at 20-40% and a counter at 8-15% pool to roughly 14-28%, so U189's numbers sit inside the
pooled band - the proxy 14-20% holds as a pooled floor. The limp curve (8-12 clean thigh kicks) is what LEG_WEAR_GAIN
is judged against.
