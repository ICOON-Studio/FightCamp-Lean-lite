# TASK G132 - GROK - LIVE LIMB DAMAGE IN THE FIGHT, AND WHAT THE CORNER DOES ABOUT IT (SURVEY)
Owner: grok (in-app browser, NEW chat). Assigned 2026-09-27 (S95, operator request). Research only - no repo, no code.
Reply inline, <= 900 words, titled G132_LIVE_DAMAGE_AND_THE_CORNER. Mark every number SOURCED (with the site) or PROXY.

## Why
FightCamp is a fight-gym MANAGEMENT sim (boxing, kickboxing, Muay Thai, MMA): the player runs the gym and sits in the
corner; the bout itself is simulated and shown in 3D. The operator, verbatim: "the limbs need to have some kind of
threshold when for example fighters get kicked really hard on one of their legs limb go to red and animations play someone
who is in pain on his red leg for a bit" and "i want this to be live on the fight pointing damage, need proper survey how
to make it engaging and linked to the corner duties and options".
WHAT WE ALREADY HAVE (do not re-derive): the engine totals head/body/leg damage per bout; a profile body map (six regions:
head-neck, torso, left/right arm, left/right leg) for injuries between fights; an art spec for an in-fight readout with
three named stops fine / hurt / critical plus a separate "doctor" state, shown as LETTER CHIPS + meters rather than a body
outline; corner-card sentences between rounds; corner rules (chief second, cutman, one minute, what is legal). What we do
NOT have: per-limb state live in the fight, a visible limp/pain reaction, or corner ACTIONS tied to a damaged region.

## What would a human do?
Answer this FIRST, from real practice: what does a real chief second and cutman do in 60 seconds for (a) a leg that has
eaten heavy kicks, (b) a cut over the eye, (c) swelling/closing eye, (d) a hurt body, (e) a hurt hand/arm, (f) a fighter
who got wobbled? What do they SEE during the round that tells them, what do they say, what can they physically do (ice,
enswell, vaseline, adrenaline 1:1000 where legal, massage, stool, water), and when do they throw the towel? How do
broadcasters (UFC, DAZN, Matchroom, ONE) show accumulated limb damage live?

## Questions
1. The corner playbook per region (a-f above): signs, actions, what each action buys, legality by sport.
2. How other GAMES show live limb damage and make the corner matter: EA UFC 3-5 (limb damage), Fight Night Champion,
   Undisputed (cuts, corner, cutman), Punch Club 1-2, Cage Legacy, Boxing Champs, any MMA/boxing manager. For each: what
   the player sees, what the player DECIDES, and what reviewers/players said worked or felt like busywork. SOURCED.
3. Live display: body figure that points at the damage vs letter chips vs on-the-fighter cues (limp, holding the leg,
   blood). Which reads at fight speed, which is engaging, which feels like a health bar? Recommend one, with the reason.
4. Thresholds: at what point does a real fighter become "compromised" on a leg / body / eye, how often per fight (e.g.
   share of UFC bouts with a visibly compromised leg, leg-kick TKO share of finishes), and how much recovers in a round
   break. SOURCED or PROXY.
5. ENGAGEMENT: the 3-5 corner decisions that are genuinely interesting (a real trade-off, e.g. ice the leg vs work the
   cut with only 60 s; "switch stance" vs "go for the takedown"; stop it now vs one more round) and 2-3 that would be
   busywork. How often per fight should the player get a meaningful choice?
6. What else this opens (targeting the hurt limb as a tactic, scouting "doesn't check kicks", post-fight injury weeks,
   commentary, replays) - rank by value for a small studio.
