# R155 — CMU paired mocap: what is actually there, measured

**Claude, 2026-09-21.** Checked because a pasted recipe named specific CMU files
as "paired wrestling/BJJ sequences". **It named the wrong ones**, and the
category it claimed does not exist — but paired data that is genuinely useful to
us DOES, and it is free.

## THE CITATION WAS WRONG

The recipe said: *"CMU Mocap: search 87_04, 87_05 — these are paired interaction
sequences, not single-person."*

**Subject #87 is `acrobatics`, single person.** Read off
`mocap.cs.cmu.edu/search.php?subjectnumber=87`:

| trial | description |
|---|---|
| 87_01 | Jump with kick and spin |
| 87_02 | T-Pose |
| 87_03 | Backflip |
| **87_04** | **backflip** |
| **87_05** | **cartwheels** |

Not paired, not wrestling. Taking it on trust would have cost a session.

## THERE IS NO MARTIAL ARTS IN CMU AT ALL

Keyword `martial` → *"Your search did not return any results."* Keyword `wrestl`
returns exactly one thing, and it is **arm** wrestling.

## WHAT IS ACTUALLY THERE, AND IT IS WORTH HAVING

CMU exports a two-person capture as **two subjects sharing trial numbers** —
which is precisely the "two separate skeletons" shape the recipe wants.

| subjects | theme | contact trials |
|---|---|---|
| **20 / 21** | human interaction — at play, formations | link arms + walk (02, 03), hold hands |
| **22 / 23** | human interaction | **01 `B sits; A pulls up B`**, 02 the reverse, 03-07 comforting with hands on shoulders, 08 hold hands swing arms walk, **17 `rush up, arm wrestle`** |

## MEASURED, NOT ASSUMED

Downloaded `22.asf` / `23.asf` and trials 01 and 17 for both subjects, then
measured root separation per frame (CMU units → metres at 0.056444):

| trial | frames A | frames B | min | p10 | p50 | p90 | max |
|---|---:|---:|---:|---:|---:|---:|---:|
| 01 `B sits; A pulls up B` | 782 | **782** | **0.73** | 0.83 | 1.17 | 1.44 | 1.89 |
| 17 `rush up, arm wrestle` | 832 | **832** | 1.29 | 1.33 | 1.40 | 1.55 | 1.87 |

**THE FRAME COUNTS MATCH EXACTLY.** The two skeletons are frame-synchronised and
share a world coordinate space — which is the property that makes this ground
truth rather than two unrelated clips.

**AND 22_01 REACHES CLINCH RANGE.** Its 0.73 m minimum sits on top of Q115's
measurement of a real clinch at **0.719 m hip-to-hip** from tracked footage. Two
independent sources, two completely different methods, the same number.

## WHY THIS MATTERS EVEN THOUGH IT IS NOT GRAPPLING

`22_01` is one person taking another's weight through a sustained two-handed
grip. Structurally that is a sweep or a pull-up from guard: grip, load transfer,
one body moving another. **It is the free, correct, frame-synced paired fixture
the anchor mechanism can be VALIDATED on before a penny is spent on grappling
content.**

The experiment it enables is the decisive one and nobody has run it: put a
KNOWN-GOOD paired capture through our retarget and measure whether the grip
survives. If the hands separate on input that is provably correct, the defect is
in our pipeline, not in the clips we bought — and `s31_contact_probe` already
reports `att_lhand_to_vic_neck` at 388% drift on our own authored clinch.

## WHAT IS ON DISK

`AssetLibrary/cmu_paired/` — `22.asf`, `23.asf`, `22_01.amc`, `23_01.amc`,
`22_17.amc`, `23_17.amc`. 2.5 MB total. ASF/AMC, not FBX, so it needs a
conversion step before `FightClipRetarget` can see it.

**LICENCE — CHECKED AND CLEAR.** Read off `mocap.cs.cmu.edu/faqs.php`, verbatim:

> "The motion capture data may be copied, modified, or redistributed without
> permission."

No commercial restriction, no attribution clause, no registration. `info.php`
adds "The database contains free motions which you can download and use."
It carries two disclaimers, both about QUALITY rather than rights: they do not
guarantee the data, and the classification is an aid rather than a warranty.

**This is why CMU is the one to build the mechanism on**, and why the AMASS and
SFU suggestions below need their own licence read before a single frame of them
is used.


---

## SECOND PASS, same day — subjects 17, 18, 19 checked

A follow-up paste named `18_06`, `19_03 / 19_04` and "Subject 17 = Wushu kicks".
Two of those three are wrong, and the third is wrong in a way that matters.

**SUBJECT 17 IS `different walking styles`, NOT Wushu.** Anger, stealth, hobble,
whistling, heavyset. **But 17_10 is `boxing`** — a real single-person boxing clip,
2.2 MB, and worth having on its own account.

**18 AND 19 ARE NOT TWO SETS. THEY ARE THE PAIR.** Subject 18 is *subject A* and
subject 19 is *subject B* of one capture. So `19_03 / 19_04` is not a pair - it
is one person at two different trials. **The pair is `18_03` + `19_03`.** Getting
this backwards would put the same body on both sides and produce exactly the
"single body collapse" the anchor is meant to prevent.

**THE TRIAL CONTENT IS RIGHT, AND IT IS BETTER THAN 22/23 FOR OUR PURPOSE:**

| trial | description | frames A | frames B | min | p10 | p50 | max |
|---|---|---:|---:|---:|---:|---:|---:|
| 18/19_03 | A pulls B; B resists | 592 | 592 | 1.11 | 1.19 | 1.50 | 1.78 |
| 18/19_04 | A pulls B; B resists | 405 | 405 | 1.16 | 1.20 | 1.38 | 1.64 |
| **18/19_05** | **A pulls B by the elbow; B resists** | **438** | **438** | **0.77** | 0.84 | 0.99 | 1.71 |
| 18/19_06 | A pulls B by the elbow; B resists | 407 | 407 | 0.98 | 1.00 | 1.10 | 1.33 |

All four frame-synced. **`18/19_05` is the best anchor-validation fixture we
have**: a sustained elbow grip under active resistance, closing to 0.77 m, which
is clinch range against Q115's 0.719 m. Two people applying opposing force
through a grip is the mechanical core of grappling, even though nobody is
throwing anybody.

## A LICENCE WARNING THAT IS NOT YET VERIFIED BUT IS CHEAP TO HEED

The same paste recommends **AMASS** for "wrestling, contact subsets" and **SFU**
for martial arts. **Both are research databases and their constituent datasets
are commonly NON-COMMERCIAL research licences** - AMASS requires registration and
unifies 100+ datasets each with its own terms. **I have not read either licence
page**, so this is a flag rather than a finding. But the earlier paste itself
said of SFU "Research — contact for commercial rights", which is the same
concern in the source's own words.

**CMU is the permissive one and it is the reason to start here.** Its exact
wording is still owed before anything ships.

## WHAT IS ON DISK NOW

`AssetLibrary/cmu_paired/` — subjects 17, 18, 19, 22, 23 ASF plus
`17_10` (boxing), `18/19_03..06` (pull + resist), `22/23_01` (pull-up),
`22/23_17` (arm wrestle).
