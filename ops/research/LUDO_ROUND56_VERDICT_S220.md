# LUDO ROUND 56 VERDICT (S220) - station wear mechanics + the station card (STATIONWEAR1A-1D)

Ask `LUDO_ROUND56_ASK_S220.txt` (text only - the extension cannot upload a picture); reply verbatim `LUDO_ROUND56_REPLY_S220.txt`
(24,032 chars). Stills: previews/stationwear1d/01_pinned_worn_bag.jpg + 02_pinned_after_service.jpg.
Why this round: the operator asked "has ludo approved of this ?" - station wear 1A-1C were built from Ludo r25 numbers with no board
approval, and 1D (pin the card) was never shown to Ludo. 1D is NOT merged (grok/stationwear1d, PR #162, own test 26/26).

Ludo: mechanics "APPROVED WITH FIXES"; card "APPROVED WITH FIXES" (agrees with all three problems Claude raised).

## Claude's verdict (for the operator's OK on the board; nothing below is built)
TAKEN - mechanics:
1. Wear %/athlete-hour: speed-bag swivel 0.45, slat treadmill 0.35, power rack 0.04, mats 0.10 (boxing use only), heavy bags 0.20,
   other cardio 0.40, strength 0.08, ring 0.15, recovery/analysis 0.06 (was 0 - no dead items).
2. Bands: GOOD 75-100 x1.00 inj 0.05%; WORN 45-74 x0.85 inj 0.40%; DAMAGED 20-44 x0.65 inj 1.25%; FAILING 1-19 x0.40 inj 3.5% +
   5% breakdown; OUT OF USE 0 = cannot train. Breakdown = session ends, station to 0, injury 60% minor (7 d) / 35% moderate (21 d) /
   5% severe (45 d); a broken station needs REPLACE or an emergency overhaul at 1.5x service.
3. SERVICE = +50 points capped at 95 (no longer "straight to 95"); REPLACE = 100 at catalogue price.
NOT TAKEN: the PRISTINE band (90-100, x1.05 gain) - a sixth band and a training bonus for new kit is new scope; ask again after
the demo if the operator wants it.

TAKEN - card (Ludo fixes 1-3 + problem c):
4. Card max 360 x 390 px; order: header (name, footprint, band pill, X) -> integrity bar + hours left -> impact (gain x, injury %) +
   attributes trained as chips -> upkeep + SERVICE / REPLACE.
5. Cut BEST FOR (kickboxing / muay thai / karate) and the 6-line YOUR FIT; one grey chip "FIT: BOXING x1.0" (#9E9284).
6. X inside the header, 32 px, top-right; no floating tab.
7. SERVICE disabled at the 95 cap, tooltip "Already at the service limit - REPLACE for 100%".
CORRECTED: Ludo's own mockup labels 46% as both WORN and DAMAGED; the card shows the band from the table in item 2, one place only.

LATER (Ludo's items 3-5 of the ask - floor signal, MAINTENANCE total in the top bar): wait for round 57's follow-up answers.

## Build
STATIONWEAR1E (Grok Dev, after the operator's OK): items 1-7 on top of grok/stationwear1d; switch station_wear stays OFF; the
station_wear / station_card_pin tests re-pinned to the new numbers; stills via tools/station_pin_stills.gd.
