# G80 - real boxing, MMA, Muay Thai glove and WKF mitt dimensions (Grok, collected S61 2026-09-23)

VERBATIM from grok.com chat "Glove Dimensions Research for 3D Fighter Game", Expert mode, collected by Claude.

Claude's read: the FINAL TABLE is what `CCFighterSkin.gd` sizes from (10 oz 0.26 x 0.11 x 0.10 m, cuff
0.15; 4 oz MMA 0.19 x 0.10 x 0.06, cuff 0.08; Muay Thai 0.28 x 0.12 x 0.11, cuff 0.10; WKF mitt L
0.16 x 0.10 x 0.055). Most per-brand rows are CARTON sizes, which Grok itself flags; the WKF foam
table and the IBA diagram marks are the only true product specs.

---

TASK_G80 — Glove dimensions

Manufacturers almost never publish cuff-to-fist length, knuckle-pad width, fist depth or pad thickness. Below: what exists. NOT FOUND where it does not.

Hand baseline for a 1.74–1.83 m man (DERIVED, anthropometry): hand length ~0.19 m, clenched-fist breadth ~0.09 m, fist depth ~0.06–0.07 m, wrist circ. ~0.17 m.

1. Product dimensions
10 oz boxing (fight)
Brand	Length	Knuckle width	Fist depth	Pad over knuckles	Cuff length	Cuff circ.
Cleto Reyes Official Fight	0.261 m item L (Amazon L×W×H 10.26×5.01×5.01 in) [SPEC]	0.127 m [SPEC, same listing — likely packed width, not pad]	0.127 m [SPEC, packed]	NOT FOUND	NOT FOUND (lace, long cuff)	NOT FOUND
Winning	NOT FOUND	NOT FOUND	NOT FOUND	NOT FOUND	NOT FOUND	NOT FOUND
IBA / World Boxing contest glove	~0.20 m mark on official diagram [SPEC]	0.08–0.10 m mark [SPEC]	NOT FOUND	NOT FOUND	0.14–0.16 m mark [SPEC]	NOT FOUND

Cleto Reyes High Precision (training, shorter cuff): package 16×8×6 in / 14.69×6.1×4.84 in depending on listing — pair carton, not worn size.

16 oz sparring boxing
Brand	Length	Knuckle width	Fist depth	Pad	Cuff L	Cuff circ.
Winning MS-600	Package 0.318×0.224×0.191 m [SPEC, pair carton]	NOT FOUND	NOT FOUND	NOT FOUND	NOT FOUND	NOT FOUND
Generic measured review	0.30–0.33 m cuff-end to fist front [MEASURED]	fist circ. 0.18–0.20 m → width ~0.07–0.08 m if circular [DERIVED]	NOT FOUND	NOT FOUND	NOT FOUND	NOT FOUND
Fairtex BGV1 16 oz (Thai-cut, often used as sparring)	Product listing 0.30×0.16×0.16 m [SPEC]	~0.16 m listed W (inflated/packed)	~0.16 m listed	NOT FOUND	short Thai cuff (qualitative only)	NOT FOUND
OEM palm chart (Wolon, low-grade)	palm length 0.22–0.24 m at 16 oz [SPEC]	palm width 0.11–0.14 m [SPEC]	NOT FOUND	NOT FOUND	NOT FOUND	NOT FOUND

4 oz MMA
Brand	Length	Knuckle width	Fist depth	Pad	Cuff L	Cuff circ.
Hayabusa T3 4 oz	Target listing 0.229×0.114×0.038 m (D×W×H) [SPEC]	~0.114 m	~0.038 m listed H — too thin to be worn fist; treat as flat-pack	“minimal knuckle pad” only [SPEC]	Dual-X strap, length NOT FOUND	sized by hand circ. S 0.165–0.178 m … XL ≥0.216 m [SPEC]
UFC official fight	4 oz / 113 g [SPEC]	NOT FOUND	NOT FOUND	“gel in strike zone” only	dual wrist wrap, length NOT FOUND	sized by hand meas. M 0.20–0.22 m
Venum Challenger	4 oz density [SPEC]	NOT FOUND	NOT FOUND	“layered foam” only	wide Velcro, length NOT FOUND	S 0.165 m / M 0.19–0.20 m / L-XL 0.216 m [SPEC]

Open fingers: pad covers knuckles + back of hand only. Fingers and most of palm are exposed. Do not model as a closed boxing shell.

Muay Thai (Fairtex / Twins, typical 10–16 oz)

Same ounce ladder as boxing. Shape differs: shorter, more flexible cuff for clinch; slightly squatter, wider fist than a Mexican fight glove.

Brand	Length	Width	Depth	Pad	Cuff L	Cuff circ.
Fairtex BGV1	0.30×0.16×0.16 m listing [SPEC]	packed 0.16 m	packed 0.16 m	3-layer EVA+latex+HD, thickness NOT FOUND	short (qualitative)	NOT FOUND
Twins BGVL3	12 oz carton 0.275×0.220×0.170 m [SPEC]	NOT FOUND	NOT FOUND	thicker/softer than Fairtex [review]	short; BGVL6 long-cuff option	NOT FOUND
Fairtex BGV7 (lace contest)	NOT FOUND	NOT FOUND	NOT FOUND	harder dual-layer latex	long cuff vs BGV1 [review]	NOT FOUND

Fight oz in Thailand/WMC: 6 / 8 / 10 oz by class — see §2. Gym gloves are 12–16 oz.

WKF karate mitt (Adidas / Daedo / SMAI) — best-specified object here

WKF homologation foam table (allow ±3 mm). Size L is the 1.70–1.90 m athlete.

Size	d foam length	a	e pad thickness (all sizes)
S	0.157 m	0.095 m	0.055 m
M	0.160 m	0.099 m	0.055 m
L	0.163 m	0.103 m	0.055 m
XL	0.166 m	0.107 m	0.055 m
e = max foam at impact face, fixed across sizes. Size only grows footprint, not pad depth.
Thumb optional; not stitched shut.
Fastener at wrist must stop slip on a frontal blow. Cuff length / circ. NOT FOUND as numbers.
Adidas XL package 0.250×0.145×0.100 m; listed item 0.350×0.150×0.110 m — carton, treat as upper bound.
SMAI “A” width: S 0.095 / M 0.100 / L 0.105 / XL 0.110 m.

This is a mitt, not a glove: open fingers, thin back, no boxing cuff.

2. Rulebook limits

IBA (2026 Technical Rules §45): Elite/Youth men — 10 oz from 46–48 kg through welter 67 kg; 12 oz from light-middle 71 kg through super-heavy. Women + school: 10 oz all classes. Weights 284 g / 340 g ±5%. Leather ≤½ mass, padding ≥½. Thumb attached, max 10 mm gap. Appendix 12 diagram marks 20 cm, 14–16 cm, 8–10 cm. No published pad-thickness millimetres.

World Boxing (2024 rules): same 284 g / 340 g ±5%, 10 oz light men + all women/U17; 12 oz heavier men.

Pro boxing (commissions, not IBA): commonly 8 oz ≤147 lb / welter, 10 oz above. Nevada MMA-adjacent boxing text uses 8 oz ≤136 lb, 10 oz above.

ABC Unified MMA: open-finger gloves, minimum 4 oz, no hard 6 oz cap (3XL–5XL may exceed 6 oz). Promoter-supplied. Amateur often 6 oz. Nevada: 4–8 oz.

IFMA amateur: 10 oz (284 g) all elite classes; leather ≤½, padding ≥½. Head/shin/elbow guards mandatory.

WMC / Thai stadium pro: 6 oz mini-fly–feather; 8 oz super-feather–welter; 10 oz super-welter and up.

WKF: homologated mitt only (table above). Compulsory in kumite. Red 032 C / Process Blue C.

3. How ounces scale

Ounce is mass of the glove, not a length.

Same brand/model, stepping 10 → 16 oz usually adds padding volume (knuckle stack + some back-of-hand and wrist foam), so depth and silhouette grow more than cuff-to-tip length. Hand compartment often stays the same last; some brands also open the last for bigger hands.

Counter-examples that kill a 1:1 scale:

A 10 oz fight glove can look taller/thicker than a 16 oz Thai glove (Hit-and-Move vs Fairtex BGV1).
Winning 16 oz is large and soft; Cleto Reyes 10 oz is slim and hard. Same “oz” ≠ same mesh.
WKF mitt: size up changes length/width only; e stays 55 mm.

Practical mesh rule for a closed boxing/Thai shell on a 1.78 m body: treat 16 oz as ~10–20% more radial pad than 10 oz, not 60% longer.

4. Argue against yourself

What would look wrong on a 1.74–1.83 m fighter:

Using Amazon L×W×H as worn size. Those are cartons. A 0.16 m “Fairtex width” is a boxed pair, not a 16 cm-wide fist. Gloves that fat read as novelty foam.
Scaling length with ounces. 16 oz is not 1.6× a 10 oz glove. A 0.40 m glove on a 0.19 m hand is a oven mitt.
Same shell for MMA. A 4 oz glove is a knuckle cap + short wrist strap. Closed-fist boxing mesh on an MMA fighter is immediately fake; fingers must read.
WKF mitt with boxing cuff / 55 mm pad drawn as a 16 oz pillow. Real mitt is short (~0.16 m foam), 55 mm face, open fingers. Make it a boxing glove and it looks like youth gear on an adult.
Cuff too long on Thai. Fairtex/Twins short cuff is the silhouette difference vs Reyes/Winning. Long cuff = boxing, not Muay.
Pad thickness from oz/density guess. Foam density varies (horsehair Reyes vs layered Winning vs WKF 94–96 kg/m³). Guessing 16 oz = 40 mm pad will be wrong for at least one brand.
Ignoring brand last. Reyes 10 oz is a thin puncher; Winning 16 oz is a loaf. One mesh scaled by oz will be wrong for half the roster.

Safest game read: lock hand last to anthropometry, add a discipline shell (closed long-cuff / closed short-cuff / open 4 oz / open mitt), then add oz as extra radial foam, not extra length.

Final table (metres)

Values for a typical adult last on a 1.74–1.83 m man. One number per cell = recommended game default.

Type	Length (cuff→front)	Width (knuckle pad)	Depth (palm→back)	Cuff length	Label
10 oz boxing fight	0.26	0.11	0.10	0.15	SPEC (Reyes item L + IBA 14–16 / 8–10 / 20 marks) / DERIVED width-depth
16 oz boxing spar	0.31	0.12	0.12	0.16	MEASURED length 0.30–0.33 / DERIVED +2 cm pad vs 10 oz
4 oz MMA	0.19	0.10	0.06	0.08	SPEC Hayabusa 0.229 pack L trimmed to hand+strap / DERIVED
Muay Thai 14 oz gym	0.28	0.12	0.11	0.10	SPEC Fairtex 0.30 pack L / DERIVED short cuff
WKF mitt L	0.16	0.10	0.055	0.04	SPEC WKF d=0.163, a=0.103, e=0.055 / DERIVED strap

Pad over knuckles (not in table columns): fight 10 oz ~0.025–0.035 m DERIVED; spar 16 oz ~0.035–0.050 m DERIVED; MMA 4 oz ~0.015–0.025 m DERIVED; WKF 0.055 m SPEC.

Cuff circumference: NOT FOUND as product spec. Use wrist + strap: boxing ~0.22–0.26 m DERIVED; MMA wrap ~0.20–0.24 m DERIVED.

138 sources
