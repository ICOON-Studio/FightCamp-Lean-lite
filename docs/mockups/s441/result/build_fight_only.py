"""Builds docs/mockups/s441/result/fight_only.html: the fight-only result page, round 2 (S441; round 1 was S440).
One bout, every number from the DATA below; check_fight_only.py re-checks the sums from the same file."""
import base64, io, json, pathlib
from PIL import Image

ROOT = pathlib.Path("E:/FightCamp/Lean")
OUT = ROOT / "docs/mockups/s441/result/fight_only.html"
SCR = pathlib.Path(__file__).parent


def b64(p):
    return base64.b64encode(pathlib.Path(p).read_bytes()).decode()


def img64(im, fmt="PNG"):
    buf = io.BytesIO()
    im.save(buf, fmt, optimize=True)
    return "data:image/png;base64," + base64.b64encode(buf.getvalue()).decode()


FIG_H = 218
holo = Image.open(ROOT / "assets/ui/body/holo_f.png")
FIG_W = round(holo.width * FIG_H / holo.height)
holo_s = img64(holo.resize((FIG_W, FIG_H), Image.LANCZOS))
top = Image.open(ROOT / "docs/mockups/s439/result/top_today.png").convert("RGB")
face_l = img64(top.crop((205, 113, 291, 199)).resize((112, 112), Image.LANCZOS))
face_r = img64(top.crop((1629, 113, 1715, 199)).resize((112, 112), Image.LANCZOS))

# ---------------------------------------------------------------- the bout (one source for every number)
# exchanges: (round, opponent's game, winner L/P, margin 1-3, ring place, pinned on the ropes, plan line fired, shout call, events)
EX = [
    (1, "range", "L", 2, "long", 0, "A", "", ""),
    (1, "range", "L", 1, "long", 0, "", "", ""),
    (1, "range", "P", 1, "long", 0, "", "", ""),
    (1, "range", "L", 3, "long", 0, "A", "", ""),
    (1, "counter", "P", 1, "mid", 0, "", "", ""),
    (1, "counter", "L", 1, "mid", 0, "B", "", ""),
    (2, "counter", "P", 2, "long", 0, "B", "", ""),
    (2, "counter", "L", 1, "long", 0, "", "", ""),
    (2, "press", "L", 2, "mid", 0, "", "long", "hurtP"),
    (2, "press", "P", 2, "mid", 0, "C", "", ""),
    (2, "press", "P", 3, "inside", 1, "", "", "hurtL habit"),
    (2, "press", "L", 1, "inside", 0, "", "tie", ""),
    (3, "press", "P", 2, "mid", 0, "C", "", ""),
    (3, "press", "P", 1, "inside", 0, "", "body", ""),
    (3, "press", "L", 1, "long", 0, "", "", ""),
    (3, "press", "P", 2, "inside", 0, "", "let_go", ""),
    (3, "press", "P", 3, "inside", 1, "C", "", "hurtL habit"),
    (3, "press", "P", 1, "inside", 0, "", "", ""),
]
# energy at the end of each exchange (the game's own 0-100 energy; under 35 a boxer is tired: Exchanges.SHE_TIRED)
EN = {"L": [93, 90, 86, 82, 79, 76, 81, 78, 73, 69, 63, 60, 63, 57, 52, 46, 40, 36],
      "P": [97, 94, 91, 87, 84, 81, 86, 84, 79, 75, 71, 68, 72, 68, 64, 59, 54, 50]}
# the game's own tables (scripts/rules/Exchanges.gd MODES / CALLS / EDGE_WORD, PlanFight.ANSWERS, PlanLines.FIT_WORDS, RingDuel)
CALLFIT = {"press": {"best": "long", "ok": "body", "wrong": "let_go"}, "range": {"best": "body", "ok": "lead", "wrong": "long"},
           "counter": {"best": "lead", "ok": "long", "wrong": "let_go"}, "she_hurt": {"best": "tie", "ok": "hands", "wrong": "finish"}}
CALLNAME = {"long": "Jab and move", "body": "Go to the body", "lead": "Draw the lead", "tie": "Tie up", "let_go": "Let your hands go"}
SITWORD = {"press": "Priya is pressing", "range": "Priya boxes at range", "counter": "Priya waits to counter", "she_hurt": "Lucy is hurt"}
PLAN = {"A": ("range", "Boxes at range", "One-two", "best"), "B": ("counter", "Waits to counter", "Feint and draw", "best"),
        "C": ("press", "Presses", "Step in", "wrong")}
FITWORD = {"best": "Beats it", "ok": "Works", "wrong": "Walks into it"}
ROUND_CALLS = {2: "lead", 3: "long"}
PLACE_WANT_P = {"range": "long", "counter": "mid", "press": "inside"}


def sit_of(i):
    """Exchanges.situation: our fighter hurt in the exchange before comes first, else the opponent's game."""
    if i % 6 and "hurtL" in EX[i - 1][8]:
        return "she_hurt"
    return EX[i][1]


def call_fit(call, sit):
    for k in ("best", "ok", "wrong"):
        if CALLFIT[sit][k] == call:
            return k
    return "none"


def lucy_wants(e):
    """RingDuel.CALL_PLACE: Tie up and Go to the body take it inside; else the out-boxer wants it long."""
    return "inside" if e[7] in ("tie", "body") else "long"


# punches per round: landed/thrown by kind; head/body landed; counters; where the punches that missed went (blocked/slipped/missed)
P = {
    "L": {
        "jab": [(12, 34), (8, 28), (6, 26)],
        "cross": [(5, 12), (5, 13), (3, 11)],
        "lead_hook": [(4, 8), (3, 6), (1, 6)],
        "body_hook": [(1, 4), (2, 5), (1, 3)],
        "uppercut": [(0, 0), (0, 0), (0, 0)],
        "head": [17, 13, 8], "body": [5, 5, 3], "counters": [3, 2, 1],
        "blocked": [18, 16, 15], "slipped": [8, 9, 7], "missed": [10, 9, 13],   # what happened to LUCY's punches
    },
    "P": {
        "jab": [(9, 30), (10, 32), (10, 30)],
        "cross": [(4, 14), (7, 18), (11, 20)],
        "lead_hook": [(3, 8), (4, 10), (5, 12)],
        "body_hook": [(1, 3), (2, 5), (4, 8)],
        "uppercut": [(0, 1), (1, 3), (1, 4)],
        "head": [12, 17, 22], "body": [5, 7, 9], "counters": [1, 2, 1],
        "blocked": [22, 24, 24], "slipped": [10, 11, 9], "missed": [7, 9, 10],  # what happened to PRIYA's punches
    },
}
TIER = {"jab": ("Sharp", 64), "cross": ("Usable", 52), "lead_hook": ("Usable", 41), "body_hook": ("Usable", 33), "uppercut": ("Learning", 22)}
ENERGY = {"L": [96, 76, 84, 60, 68, 36], "P": [100, 81, 89, 68, 76, 50]}  # start, end R1, after stool, end R2, after stool, end R3
CARDS = [[(10, 9), (9, 10), (9, 10)], [(10, 9), (9, 10), (9, 10)], [(10, 9), (10, 9), (9, 10)]]
MARKS = {"L": {"head": 58, "left_eye": 31, "right_eye": 69, "nose": 62, "left_ribs": 66, "right_ribs": 33},
         "P": {"head": 63, "left_eye": 66, "right_eye": 60, "nose": 49, "left_ribs": 71, "right_ribs": 52}}
CUTS = {"L": ["left_eye"], "P": []}
DATA = {"EX": EX, "P": P, "TIER": TIER, "ENERGY": ENERGY, "CARDS": CARDS, "MARKS": MARKS, "CUTS": CUTS}


def pct(a, b):
    return int(a * 100 / b + 0.5) if b else 0


def side(s, r):
    """Per-side numbers for round r (0,1,2) or None = ALL."""
    rs = [0, 1, 2] if r is None else [r]
    d = P[s]
    o = {}
    for k in ("jab", "cross", "lead_hook", "body_hook", "uppercut"):
        o[k] = (sum(d[k][i][0] for i in rs), sum(d[k][i][1] for i in rs))
    o["power"] = tuple(sum(o[k][j] for k in ("cross", "lead_hook", "body_hook", "uppercut")) for j in (0, 1))
    o["all"] = (o["jab"][0] + o["power"][0], o["jab"][1] + o["power"][1])
    for k in ("head", "body", "counters", "blocked", "slipped", "missed"):
        o[k] = sum(d[k][i] for i in rs)
    o["ex"] = sum(1 for e in EX if e[2] == s and (r is None or e[0] == r + 1))
    o["hurt"] = sum(1 for e in EX if ("hurtP" if s == "L" else "hurtL") in e[8] and (r is None or e[0] == r + 1))
    return o


def both(r):
    a, b = side("L", r), side("P", r)
    # avoided = the other side's blocked + slipped, of the other side's thrown
    a["avoid"] = (b["blocked"], b["slipped"], b["all"][1])
    b["avoid"] = (a["blocked"], a["slipped"], a["all"][1])
    return a, b


# ---------------------------------------------------------------- icons
def ic(name, c="#a89c90", s=18):
    paths = {
        "fist": '<path d="M5 9h10a3 3 0 0 1 0 6H8v3H5z M8 9V6a2 2 0 0 1 4 0v3" fill="none" stroke="{c}" stroke-width="2" stroke-linejoin="round"/>',
        "jab": '<path d="M2 10h13M11 5l5 5-5 5" fill="none" stroke="{c}" stroke-width="2.4" stroke-linecap="round" stroke-linejoin="round"/>',
        "power": '<path d="M11 1L4 11h5l-2 8 8-11h-5l3-7z" fill="{c}"/>',
        "head": '<circle cx="10" cy="8" r="5" fill="none" stroke="{c}" stroke-width="2.2"/><path d="M5 19c1-4 9-4 10 0" fill="none" stroke="{c}" stroke-width="2.2"/>',
        "body": '<path d="M5 3h10l-1 8 1 8H5l1-8z" fill="none" stroke="{c}" stroke-width="2.2" stroke-linejoin="round"/><path d="M7 9h6" stroke="{c}" stroke-width="2"/>',
        "counter": '<path d="M3 7h11l-3-3M17 13H6l3 3" fill="none" stroke="{c}" stroke-width="2.2" stroke-linecap="round" stroke-linejoin="round"/>',
        "star": '<path d="M10 1l2 5 5-2-2 5 4 2-5 2 2 5-5-2-1 4-2-4-5 2 2-5-4-2 5-2-2-5 5 2z" fill="{c}"/>',
        "ex": '<path d="M3 15L15 3M8 3h7v7" fill="none" stroke="{c}" stroke-width="2.2" stroke-linecap="round" stroke-linejoin="round"/><path d="M17 5L5 17" stroke="{c}" stroke-width="2.2" stroke-linecap="round" opacity=".5"/>',
        "shield": '<path d="M10 2l7 3v5c0 5-3.5 7.5-7 9-3.5-1.5-7-4-7-9V5z" fill="none" stroke="{c}" stroke-width="2.1" stroke-linejoin="round"/>',
        "tick": '<path d="M3 10.5l4.5 4.5L17 5" fill="none" stroke="{c}" stroke-width="3" stroke-linecap="round" stroke-linejoin="round"/>',
        "cross": '<path d="M5 5l10 10M15 5L5 15" fill="none" stroke="{c}" stroke-width="3" stroke-linecap="round"/>',
        "dash": '<path d="M5 10h10" fill="none" stroke="{c}" stroke-width="3" stroke-linecap="round"/>',
        "mega": '<path d="M2 8h4l9-5v14l-9-5H2z" fill="none" stroke="{c}" stroke-width="2" stroke-linejoin="round"/><path d="M6 12l1.5 5" stroke="{c}" stroke-width="2" stroke-linecap="round"/>',
        "plan": '<rect x="4" y="3" width="12" height="15" rx="2" fill="none" stroke="{c}" stroke-width="2"/><path d="M7 8h6M7 12h6" stroke="{c}" stroke-width="2" stroke-linecap="round"/>',
        "ropes": '<path d="M3 3v15M17 3v15M3 6h14M3 10h14M3 14h14" fill="none" stroke="{c}" stroke-width="2" stroke-linecap="round"/>',
        "back": '<path d="M16 10H4M8 5l-5 5 5 5" fill="none" stroke="{c}" stroke-width="2.4" stroke-linecap="round" stroke-linejoin="round"/><path d="M18 3v14" stroke="{c}" stroke-width="2.4" stroke-linecap="round"/>',
        "stool": '<path d="M3 6h14M5 6l-1 12M15 6l1 12M5 12h10" fill="none" stroke="{c}" stroke-width="2.2" stroke-linecap="round"/>',
        "batt": '<rect x="2" y="6" width="14" height="9" rx="2" fill="none" stroke="{c}" stroke-width="2"/><path d="M18 9v3" stroke="{c}" stroke-width="2.4" stroke-linecap="round"/><rect x="4.5" y="8.5" width="6" height="4" fill="{c}"/>',
        "legs": '<path d="M7 2v8l-2 8h4M13 2v8l2 8h-4" fill="none" stroke="{c}" stroke-width="2.2" stroke-linecap="round" stroke-linejoin="round"/>',
        "even": '<path d="M4 7h12M4 13h12" stroke="{c}" stroke-width="2.6" stroke-linecap="round"/>',
        "play": '<circle cx="10" cy="10" r="8" fill="none" stroke="{c}" stroke-width="2"/><path d="M8 6.5v7l6-3.5z" fill="{c}"/>',
        "combo": '<path d="M3 14l4-6 4 6 4-6 3 4" fill="none" stroke="{c}" stroke-width="2.2" stroke-linecap="round" stroke-linejoin="round"/>',
        "cut": '<path d="M4 16L16 4" stroke="{c}" stroke-width="2.6" stroke-linecap="round"/><path d="M6 8l2 2M11 13l2 2" stroke="{c}" stroke-width="2" stroke-linecap="round"/>',
    }
    return f'<svg width="{s}" height="{s}" viewBox="0 0 20 20">{paths[name].format(c=c)}</svg>'


RED, BLUE, GOLD, GREEN, AMBER = "#e0503c", "#4278e0", "#e9b84a", "#6cc27a", "#e8a33c"
RT, BT = "#ff7a66", "#8fbcff"
DOC = "#d0409a"


def band(v):
    """BodyMap.band: fine over 55, hurt to 35, critical to 15, doctor under."""
    return ("doctor", DOC) if v <= 15 else (("critical", RED) if v <= 35 else (("hurt", AMBER) if v <= 55 else ("fine", GREEN)))


# ---------------------------------------------------------------- fighter cards
PLACE_NAMES = [("head", "Head"), ("left_eye", "Left eye"), ("right_eye", "Right eye"), ("nose", "Nose"), ("left_ribs", "Left ribs"), ("right_ribs", "Right ribs")]
SPOT = {"head": (0.5, 0.035), "left_eye": (0.5287, 0.0675), "right_eye": (0.4713, 0.0675), "nose": (0.5, 0.089),
        "left_ribs": (0.5632, 0.3048), "right_ribs": (0.4368, 0.3048)}


def card(s):
    red = s == "L"
    name, corner, col, colt = ("LUCY JACKSON", "RED CORNER", RED, RT) if red else ("PRIYA NAIR", "BLUE CORNER", BLUE, BT)
    x = 179 if red else 1361
    W, H = 380, 362
    figx = 10 if red else W - 10 - 168
    lstx = 196 if red else 12
    m = MARKS[s]
    o = [f'<div class="card {"r" if red else "b"}" style="left:{x}px;top:78px;width:{W}px;height:{H}px">']
    o.append(f'<div class="figbox" style="left:{figx}px;top:34px;width:168px;height:{FIG_H + 8}px">'
             f'<img src="{holo_s}" style="position:absolute;left:{(168 - FIG_W) // 2}px;top:4px;width:{FIG_W}px;height:{FIG_H}px">')
    svg = [f'<svg style="position:absolute;left:0;top:0" width="168" height="{FIG_H + 8}">']
    labels = []
    for k, _ in PLACE_NAMES:
        v = m[k]
        if v > 55:
            continue
        bw, bc = band(v)
        px = (168 - FIG_W) // 2 + SPOT[k][0] * FIG_W
        py = 4 + SPOT[k][1] * FIG_H
        # hooked line out of the body: head places go up and out, rib places go down and out, toward the free side
        if k in ("left_eye", "right_eye", "nose", "head"):
            right_side = SPOT[k][0] > 0.5 or (SPOT[k][0] == 0.5 and not red)
            if right_side:
                pts = f"{px:.0f},{py:.0f} {116:.0f},{py:.0f}"
                lx, ly = 116, py - 12
            else:
                pts = f"{px:.0f},{py:.0f} {52:.0f},{py:.0f}"
                lx, ly = 4, py - 12
        else:
            outx = 26 if SPOT[k][0] < 0.5 else 142
            pts = f"{px:.0f},{py:.0f} {outx:.0f},{py + 66:.0f} {outx:.0f},{py + 80:.0f}"
            lx, ly = outx - 17, py + 80
        svg.append(f'<circle cx="{px:.0f}" cy="{py:.0f}" r="6.5" fill="none" stroke="{bc}" stroke-width="2.4"/>'
                   f'<polyline points="{pts}" fill="none" stroke="{bc}" stroke-width="2"/>')
        cut = ic("cut", "#fff", 14) if k in CUTS[s] else ""
        labels.append(f'<span class="mk" style="left:{lx:.0f}px;top:{ly:.0f}px;border-color:{bc};color:{bc}">{v}{cut}</span>')
    svg.append("</svg>")
    o.append("".join(svg) + "".join(labels) + "</div>")
    # the six places, all numbers
    rows = []
    for i, (k, nm) in enumerate(PLACE_NAMES):
        v = m[k]
        bw, bc = band(v)
        cut = ic("cut", "#f3ece2", 16) if k in CUTS[s] else ""
        nmb = nm
        rows.append(f'<div class="pl" style="top:{i * 25}px" title="{nmb}: {v} of 100 at the last bell, {bw}{", cut" if cut else ""}">'
                    f'<i class="dt" style="background:{bc}"></i><span class="pn">{nmb}</span>{cut}<b style="color:{bc if v <= 55 else "#f3ece2"}">{v}</b></div>')
    o.append(f'<div class="marks" style="left:{lstx}px;top:34px;width:172px">{"".join(rows)}'
             f'<div class="lg" style="top:158px"><i class="dt" style="background:{GREEN}"></i>fine <i class="dt" style="background:{AMBER}"></i>hurt</div>'
             f'<div class="lg" style="top:181px"><i class="dt" style="background:{RED}"></i>critical <i class="dt" style="background:{DOC}"></i>doctor</div>'
             f'<div class="lg" style="top:204px">{ic("cut", "#f3ece2", 16)} cut</div></div>')
    o.append('<div class="cap2" style="left:12px;top:6px" title="Each place starts the bout at 100. Fine over 55, hurt to 35, critical to 15, under that the doctor looks at it.">'
             'Condition at the last bell <em>(of 100)</em></div>')
    face = face_l if red else face_r
    if red:
        o.append(f'<div class="nm" style="left:12px;top:{H - 58}px"><img class="face" src="{face}" style="border-color:{col}">'
                 f'<span class="fn">{name}</span><span class="cn" style="color:{colt}">{corner}</span></div>')
    else:
        o.append(f'<div class="nm" style="right:12px;top:{H - 58}px;flex-direction:row-reverse"><img class="face" src="{face}" style="border-color:{col}">'
                 f'<span class="fn">{name}</span><span class="cn" style="color:{colt}">{corner}</span></div>')
    o.append("</div>")
    return "".join(o)


# ---------------------------------------------------------------- centre: verdict, judges, what it decided
def judges():
    o = []
    for j, c in enumerate(CARDS):
        a = sum(x[0] for x in c)
        b = sum(x[1] for x in c)
        col = RT if a > b else BT
        x = 588 + j * 254
        chips = []
        for r, (p, q) in enumerate(c):
            cc = "r" if p > q else "b"
            odd = j == 2 and r == 1
            ttl = (f"Judge {j + 1}, round {r + 1}: {p}-{q}. "
                   + ("Round 2 was 3-3 on exchanges: this judge gave it to Lucy, the other two to Priya." if odd else
                      ("Lucy's round" if p > q else "Priya's round") + " on this card."))
            chips.append(f'<span class="rch {cc}{" odd" if odd else ""}" title="{ttl}">{p}-{q}</span>')
        note = '<div class="jn" style="color:#e9b84a">R2 (3-3) to Lucy</div>' if j == 2 else '<div class="jn">&nbsp;</div>'
        o.append(f'<div class="judge" style="left:{x}px;top:194px"><div class="jl">JUDGE {j + 1}</div>'
                 f'<div class="jt" style="color:{col}">{a}-{b}</div><div class="chips">{"".join(chips)}</div>{note}</div>')
    return "".join(o)


def decided():
    rows = [("RECORD", '3-0 <span class="ar">&#8594;</span> <b>3-1</b>', '5-1 <span class="ar">&#8594;</span> <b>6-1</b>',
             "Wins, losses. Booked at the bell."),
            ("REGIONAL RANK", 'Unranked &middot; <b>1</b> win to enter', 'No. 5 <span class="ar">&#8594;</span> <b>No. 4</b>',
             "The regional ranking table. Lucy enters it at 4 wins; a loss does not move that."),
            ("BEFORE THE BELL", '<b>42%</b> to win', '<b>58%</b> to win',
             "Each boxer's chance to win, saved at the first bell. Priya was the favourite: the result went as expected.")]
    o = []
    for i, (lab, a, b, t) in enumerate(rows):
        y = 322 + i * 24
        o.append(f'<div class="dr" style="top:{y}px" title="{t}"><div class="da">{a}</div><div class="dl">{lab}</div><div class="db">{b}</div></div>')
    cost = ("WHAT IT COST", 'Cut over the left eye: <b>out 3 weeks</b>',
            "Rolled after the bout from the worst place (left eye 31, cut). No bout and no sparring for 3 weeks.")
    road = ("THE ROAD", 'Nationals: <b>1</b> more bout to enter &middot; Pro offer: <b>3</b> of 7 wins',
            "The nationals take boxers with 5 bouts (Lucy has 4). A promoter calls at 7 wins and a top-3 rank, or at 9 wins.")
    for i, (lab, a, t) in enumerate((cost, road)):
        o.append(f'<div class="dr one" style="top:{322 + (3 + i) * 24}px" title="{t}"><div class="dl">{lab}</div><div class="dx"><i>Lucy</i> {a}</div></div>')
    return "".join(o)


# ---------------------------------------------------------------- timeline
TL_X0, CELL, GAP = 352, 72, 34
MODES = {"range": "Boxing at range", "counter": "Waiting to counter", "press": "Pressing"}


def cx0(i):
    r, j = divmod(i, 6)
    return TL_X0 + r * (6 * CELL + GAP) + j * CELL


def edge(fit):
    return {"best": ("Big edge", GREEN, "tick"), "ok": ("Small edge", AMBER, "dash"), "none": ("No edge", "#8a7f74", "dash"),
            "wrong": ("Risky", RED, "cross")}[fit]


def timeline():
    o = []
    top = 448
    o.append(f'<div class="tile" style="left:179px;top:{top}px;width:1562px;height:216px"></div>')
    o.append(f'<div class="tl" style="top:{top + 8}px">ROUNDS</div>')
    o.append(f'<div class="tl" style="top:{top + 36}px">PRIYA\'S GAME</div>')
    o.append(f'<div class="tl" style="top:{top + 66}px" title="Energy after every exchange, 0 to 100. Under the dotted line (35) a boxer is tired.">ENERGY</div>')
    o.append(f'<div class="tl" style="top:{top + 98}px">EXCHANGES</div>'
             f'<div class="tl2" style="top:{top + 120}px"><span style="color:{RT}">&#9650; Lucy</span> <span style="color:{BT}">&#9660; Priya</span></div>'
             f'<div class="tl2" style="top:{top + 142}px">{ic("star", GOLD, 18)}hurt {ic("back", "#c9b9a6", 18)}habit {ic("stool", "#c9b9a6", 18)}call</div>')
    o.append(f'<div class="tl2" style="top:{top + 164}px" title="A plan line, shout or corner call is marked by how it FITS what Priya was doing, not by whether the exchange was won.">'
             f'{ic("tick", GREEN, 16)}fits {ic("dash", AMBER, 16)}half {ic("cross", RED, 16)}wrong</div>')
    o.append(f'<div class="tl" style="top:{top + 188}px">PLAN &middot; SHOUTS</div>')
    won = [sum(1 for e in EX if e[0] == r + 1 and e[2] == "L") for r in range(3)]
    assert won == [4, 3, 1]
    heads = [("ROUND 1", "Lucy 4-2", RT, ""), ("ROUND 2", "3-3 &middot; Priya's clearer", BT,
             "Even on exchanges, 3 each. Priya's three were won by more, so two judges gave Priya the round."),
             ("ROUND 3", "Priya 5-1", BT, "")]
    e0 = ENERGY["L"][0], ENERGY["P"][0]
    for r, (h, w, c, t) in enumerate(heads):
        x = cx0(r * 6)
        e = EN["L"][r * 6 + 5], EN["P"][r * 6 + 5]
        legs = (f'<span class="lw" title="What gave out first in Lucy: the legs, in round 3 (energy {e[0]} at the bell, Priya {e[1]}). Coach\'s advice: Cardio next week.">'
                f'{ic("legs", "#ffb199", 18)}legs went</span>') if r == 2 else ""
        o.append(f'<div class="rh" style="left:{x}px;top:{top + 6}px;width:{6 * CELL}px" title="{t}">'
                 f'<span class="rn">{h}</span><span style="color:{c}">{w}</span>{legs}'
                 f'<span class="en" title="Energy at the bell, Lucy and Priya. Lucy started at {e0[0]}, still a little tired from the week; Priya at {e0[1]}.">{ic("batt", "#a89c90", 18)}'
                 f'<b style="color:{RT}">{e[0]}</b><i>|</i><b style="color:{BT}">{e[1]}</b></span></div>')
    segs = []
    start = 0
    for i in range(1, 19):
        if i == 18 or EX[i][1] != EX[start][1]:
            segs.append((start, i - 1, EX[start][1]))
            start = i
    for a, b, mname in segs:
        x1, x2 = cx0(a) + 3, cx0(b) + CELL - 3
        wn = sum(1 for e in EX[a:b + 1] if e[2] == "L")
        o.append(f'<div class="mode {mname}" style="left:{x1}px;top:{top + 36}px;width:{x2 - x1}px" '
                 f'title="Priya was {MODES[mname].lower()} for {b - a + 1} exchanges. Lucy won {wn}.">{MODES[mname]}</div>')
    # energy line, one strip a round (30 to 100 on 26 px; the dotted line is 35, tired)
    ey, eh = top + 64, 30

    def yy(v):
        return 2 + (100 - v) / 70 * 26

    for r in range(3):
        pts = {}
        for s in ("L", "P"):
            vals = [ENERGY[s][r * 2]] + EN[s][r * 6:r * 6 + 6]
            pts[s] = " ".join(f"{(0 if j == 0 else (j - 1) * CELL + CELL / 2):.0f},{yy(v):.1f}" for j, v in enumerate(vals))
        endx = 5 * CELL + CELL / 2
        ttl = (f"Energy through round {r + 1}: Lucy {ENERGY['L'][r * 2]} to {EN['L'][r * 6 + 5]}, Priya {ENERGY['P'][r * 2]} to {EN['P'][r * 6 + 5]}. "
               "Under the dotted line (35) a boxer is tired.")
        o.append(f'<svg style="position:absolute;left:{cx0(r * 6)}px;top:{ey}px;cursor:help" width="{6 * CELL}" height="{eh}"><title>{ttl}</title>'
                 f'<path d="M0 {yy(35):.1f}H{6 * CELL}" stroke="#6a625b" stroke-width="1.5" stroke-dasharray="3 5"/>'
                 f'<polyline points="{pts["P"]}" fill="none" stroke="{BT}" stroke-width="2.4" stroke-linejoin="round"/>'
                 f'<polyline points="{pts["L"]}" fill="none" stroke="{RT}" stroke-width="2.4" stroke-linejoin="round"/>'
                 f'<circle cx="{endx:.0f}" cy="{yy(EN["P"][r * 6 + 5]):.1f}" r="3.5" fill="{BT}"/>'
                 f'<circle cx="{endx:.0f}" cy="{yy(EN["L"][r * 6 + 5]):.1f}" r="3.5" fill="{RT}"/></svg>')
    axis = top + 142
    for r in range(3):
        o.append(f'<div class="axis" style="left:{cx0(r * 6)}px;top:{axis}px;width:{6 * CELL}px"></div>')
    py = top + 186
    for i, e in enumerate(EX):
        x = cx0(i)
        hgt = e[3] * 12
        cls = "r" if e[2] == "L" else "b"
        y = axis - hgt if e[2] == "L" else axis + 2
        who = "Lucy" if e[2] == "L" else "Priya"
        how = " clearly" if e[3] == 3 else (" by a little" if e[3] == 1 else "")
        where = f"At {e[4]}" + (", Lucy pinned on the ropes" if e[5] else "")
        o.append(f'<i class="xb {cls}" style="left:{x + 14}px;top:{y}px;height:{hgt}px" title="Exchange {i + 1} (round {e[0]}): {who} won it{how}. {where}."></i>')
        ev = []
        if "hurtP" in e[8]:
            ev.append(("star", RT, "Lucy hurt Priya: a lead hook, the end of a 1-2-3 landed whole."))
        if "hurtL" in e[8]:
            ev.append(("star", BT, "Priya hurt Lucy: a cross with Lucy pinned on the ropes."))
        if "habit" in e[8]:
            ev.append(("back", "#c9b9a6", "Habit punished: Lucy retreated in a straight line onto the ropes."))
        for k, (n, c, tt) in enumerate(ev):
            yv = axis - 40 if e[2] == "L" else axis + 4 + k * 20
            o.append(f'<span class="evi" style="left:{x + 48}px;top:{yv}px" title="{tt}">{ic(n, c, 18)}</span>')
        res = "won" if e[2] == "L" else "lost"
        if e[6]:
            fit = PLAN[e[6]][3]
            col = GREEN if fit == "best" else (RED if fit == "wrong" else AMBER)
            o.append(f'<span class="pb" style="left:{x + 10}px;top:{py}px;border-color:{col}" '
                     f'title="Plan line {e[6]} fired ({PLAN[e[6]][2]}): {FITWORD[fit].lower()} when {SITWORD[e[1]]}. Exchange {res}.">{e[6]}{ic(edge(fit)[2], col, 16)}</span>')
        if e[7]:
            fit = call_fit(e[7], sit_of(i))
            wd, col, icn = edge(fit)
            o.append(f'<span class="pb sh" style="left:{x + 10}px;top:{py}px;border-color:{col}" '
                     f'title="Shout: {CALLNAME[e[7]]}. {wd} when {SITWORD[sit_of(i)]}. Exchange {res}.">{ic("mega", "#c9b9a6", 18)}{ic(icn, col, 16)}</span>')
    for r, call in ROUND_CALLS.items():
        gx = cx0((r - 1) * 6) - GAP
        mode = EX[(r - 1) * 6][1]
        wd, col, icn = edge(call_fit(call, mode))
        o.append(f'<span class="cc" style="left:{gx + 3}px;top:{axis - 14}px" title="Corner call before round {r}: {CALLNAME[call]}. {wd}: {SITWORD[mode]} at the bell. Round {r} lost.">'
                 f'{ic("stool", "#c9b9a6", 18)}{ic(icn, col, 14)}</span>')
    return "".join(o)


# ---------------------------------------------------------------- punch table
TB_X, TB_Y = 179, 670
COLS = dict(tier=60, pc=48, nt=96, bar=146, lab=176)
ROWH = 21
ROWS = [  # key, label, icon, kind, hover
    ("ex", "Exchanges won", "ex", "n", "30-second exchanges won. The judges score these, not punches."),
    ("all", "All punches", "fist", "stack", "Landed of thrown. The bar shows where every punch went: landed, blocked, slipped, missed."),
    ("jab", "Jabs", "jab", "nt", "Jabs landed of thrown."),
    ("power", "Power", "power", "nt", "Every punch that is not a jab: cross, hooks, uppercut."),
    ("cross", "Cross", "", "nt", "Cross landed of thrown."),
    ("lead_hook", "Lead hook", "", "nt", "Lead hook landed of thrown."),
    ("body_hook", "Body hook", "", "nt", "Body hook landed of thrown."),
    ("uppercut", "Uppercut", "", "nt", "Uppercut landed of thrown. A move is thrown in a fight from 30 mastery (Usable)."),
    ("head", "To the head", "head", "n", "Punches landed to the head."),
    ("body", "To the body", "body", "n", "Punches landed to the body."),
    ("counters", "Counters", "counter", "n", "Punches landed back while the other led."),
    ("hurt", "Hurt opponent", "star", "n", "Punches that hurt the other boxer."),
    ("avoid", "Avoided", "shield", "av", "Share of the other's punches blocked (solid) or slipped (striped). Clean misses do not count here."),
]


def val(o, k):
    if k in ("jab", "power", "cross", "lead_hook", "body_hook", "uppercut", "all"):
        return o[k]
    if k == "avoid":
        bl, sl, th = o["avoid"]
        return pct(bl + sl, th)
    return o[k]


def table(r):
    a, b = both(r)
    out = []
    W = COLS
    xs = {}
    x = 0
    for k in ("tier", "pc", "nt", "bar", "lab"):
        xs[k] = x
        x += W[k]
    xs["bar2"] = x
    xs["nt2"] = x + W["bar"]
    xs["pc2"] = xs["nt2"] + W["nt"]
    for i, (k, lab, icn, kind, hov) in enumerate(ROWS):
        y = i * ROWH
        va, vb = val(a, k), val(b, k)
        # who won the row (higher is better on every row)
        sa = va[0] if isinstance(va, tuple) else va
        sb = vb[0] if isinstance(vb, tuple) else vb
        if kind in ("nt", "stack"):
            sa, sb = pct(*va) if va[1] else -1, pct(*vb) if vb[1] else -1
        win = "a" if sa > sb else ("b" if sb > sa else "")
        sub = k in ("cross", "lead_hook", "body_hook", "uppercut")
        first = k == "ex"
        cells = []
        # label
        li = ic(icn, GOLD if first else "#a89c90", 18) if icn else ""
        cells.append(f'<div class="lb{" sub" if sub else ""}{" first" if first else ""}" style="left:{xs["lab"]}px;width:{W["lab"]}px" title="{hov}">{li}<span>{lab}</span></div>')
        # tiers (Lucy only, for the moves)
        if k in TIER:
            tn, tv = TIER[k]
            cells.append(f'<span class="tier {tn.lower()}" style="left:{xs["tier"]}px" title="Lucy\'s level with this punch: {tn} ({tv} of 100).">{tn}</span>')
        for sd, v, o2 in (("a", va, a), ("b", vb, b)):
            right = sd == "b"
            mark = '<i class="wm a"></i>' if (win == "a" and sd == "a") else ('<i class="wm b"></i>' if (win == "b" and sd == "b") else "")
            col = "r" if sd == "a" else "b"
            bx = xs["bar"] if sd == "a" else xs["bar2"]
            if kind in ("nt", "stack"):
                l, t = v
                if t == 0:
                    if sd == "a":
                        cells.append(f'<span class="nw" style="left:{xs["pc"]}px;width:{W["pc"] + W["nt"] + W["bar"] - 8}px" title="Lucy\'s uppercut is Learning (22 of 100): a punch is thrown in a fight from Usable (30).">not a weapon yet</span>')
                    continue
                p = pct(l, t)
                ntx = xs["nt"] if sd == "a" else xs["nt2"]
                pcx = xs["pc"] if sd == "a" else xs["pc2"]
                cells.append(f'<span class="nt {"wn" if mark else ""} {sd}" style="left:{ntx}px;width:{W["nt"]}px">{mark if right else ""}<b>{l}</b><em>/{t}</em>{mark if not right else ""}</span>')
                cells.append(f'<span class="pc {"wn" if mark else ""} {sd}" style="left:{pcx}px;width:{W["pc"]}px">{p}%</span>')
                scale = max(a["all"][1], b["all"][1]) if kind == "stack" else max(a[k][1], b[k][1])
                full = W["bar"] - 10
                if kind == "stack":
                    segs = [("n", l), ("bl", o2["blocked"]), ("sl", o2["slipped"]), ("ms", o2["missed"])]
                    assert sum(s[1] for s in segs) == t
                    acc = 0
                    parts = []
                    for cl, n in segs:
                        w = round(n * full / scale)
                        parts.append(f'<i class="{cl} {col}" style="{"right" if sd == "a" else "left"}:{acc}px;width:{w}px"></i>')
                        acc += w
                    ttl = f"{'Lucy' if sd == 'a' else 'Priya'} threw {t}: landed {l}, blocked {o2['blocked']}, slipped {o2['slipped']}, missed {o2['missed']}."
                    cells.append(f'<div class="bar {sd}" style="left:{bx + 5}px;width:{full}px" title="{ttl}">{"".join(parts)}</div>')
                else:
                    wo = round(t * full / scale)
                    wi = round(l * full / scale)
                    cells.append(f'<div class="bar {sd}" style="left:{bx + 5}px;width:{full}px"><i class="o {col}" style="{"right" if sd == "a" else "left"}:0;width:{wo}px"></i>'
                                 f'<i class="n {col}" style="{"right" if sd == "a" else "left"}:0;width:{wi}px"></i></div>')
            elif kind == "av":
                bl, sl, th = o2["avoid"]
                p = pct(bl + sl, th)
                ntx = xs["nt"] if sd == "a" else xs["nt2"]
                cells.append(f'<span class="nt {"wn" if mark else ""} {sd}" style="left:{ntx}px;width:{W["nt"]}px" title="{"Lucy" if sd == "a" else "Priya"} blocked {bl} and slipped {sl} of {th} thrown at {"her" if False else ("Lucy" if sd == "a" else "Priya")}.">'
                             f'{mark if right else ""}<b>{p}%</b>{mark if not right else ""}</span>')
                full = W["bar"] - 10
                w1 = round(bl * full / th)
                w2 = round(sl * full / th)
                cells.append(f'<div class="bar {sd}" style="left:{bx + 5}px;width:{full}px"><i class="n {col}" style="{"right" if sd == "a" else "left"}:0;width:{w1}px"></i>'
                             f'<i class="sl {col}" style="{"right" if sd == "a" else "left"}:{w1}px;width:{w2}px"></i></div>')
            else:
                ntx = xs["nt"] if sd == "a" else xs["nt2"]
                big = " big" if first else ""
                cells.append(f'<span class="nt {"wn" if mark else ""} {sd}{big}" style="left:{ntx}px;width:{W["nt"]}px">{mark if right else ""}<b>{v}</b>{mark if not right else ""}</span>')
                scale = max(val(a, k), val(b, k), 1)
                if k == "ex":
                    scale = 6 if r is not None else 18
                full = W["bar"] - 10
                w = round(v * full / scale)
                cells.append(f'<div class="bar {sd}" style="left:{bx + 5}px;width:{full}px"><i class="n {col}" style="{"right" if sd == "a" else "left"}:0;width:{w}px"></i></div>')
        out.append(f'<div class="tr{" sub" if sub else ""}{" first" if first else ""}" style="top:{y}px">{"".join(cells)}</div>')
    return "".join(out)


def punch_block():
    tabs = "".join(f'<div class="tab{" on" if t == "all" else ""}" data-t="{t}">{t.upper() if t == "all" else "R" + t}</div>' for t in ("all", "1", "2", "3"))
    bodies = []
    for t, r in (("all", None), ("1", 0), ("2", 1), ("3", 2)):
        bodies.append(f'<div class="tb" data-t="{t}" style="{"" if t == "all" else "display:none"}">{table(r)}</div>')
    legend = (f'<div class="leg"><i class="sw n r"></i>landed <i class="sw bl r"></i>blocked <i class="sw sl r"></i>slipped <i class="sw ms r"></i>missed'
              f'<span class="mkr" title="One rule on every row: the gold marker sits on the better number. Where a row has a percentage, the percentage decides."><i class="wm b"></i>better on the row</span>'
              f'<span class="nc" title="Standing counts and knockdowns: none in this bout.">{ic("dash", "#8a7f74", 16)}No counts</span></div>')
    return (f'<div class="tile" style="left:{TB_X}px;top:{TB_Y}px;width:826px;height:336px"></div>'
            f'<div class="pt" style="left:{TB_X + 10}px;top:{TB_Y + 4}px">'
            f'<span class="tn" style="left:0;color:{RT}">LUCY</span>'
            f'<div class="tabs">{tabs}</div>'
            f'<span class="tn" style="right:0;color:{BT}">PRIYA</span>'
            f'<div class="rows">{"".join(bodies)}</div>{legend}</div>')


# ---------------------------------------------------------------- the plan and the corner
def pips(won, n, size=11):
    return "".join(f'<i class="pp{" on" if k < won else ""}" style="width:{size}px;height:{size}px"></i>' for k in range(n))


def corner_block():
    X, Y, W, H = 1021, 670, 720, 336
    fires = {k: [e for e in EX if e[6] == k] for k in PLAN}
    rows = []
    best_n = sum(len(v) for k, v in fires.items() if PLAN[k][3] == "best")
    wrong_n = sum(len(v) for k, v in fires.items() if PLAN[k][3] == "wrong")
    for i, k in enumerate("ABC"):
        _, sit, ans, fit = PLAN[k]
        n = len(fires[k])
        w = sum(1 for e in fires[k] if e[2] == "L")
        rc = GREEN if fit == "best" else (RED if fit == "wrong" else AMBER)
        act = (f'<span class="act" title="Opens the Playbook on this plan, line {k} selected. {ans} is a wrong answer to pressing: Step back, Pivot out or the Double jab beat it.">Rewrite {k}</span>'
               if fit == "wrong" else '<span class="act none"></span>')
        rows.append(f'<div class="plr" style="top:{38 + i * 28}px" title="Line {k}: {sit} -> {ans}. Rated by how the answer fits that game: {FITWORD[fit]}. Fired {n} times, exchanges won {w}.">'
                    f'<span class="pk">{k}</span><span class="ps">{sit}</span><span class="pa">&#8594;</span><span class="pw">{ans}</span>'
                    f'<span class="rate" style="margin-left:auto;color:{rc};border-color:{rc}">{FITWORD[fit]}</span>'
                    f'<span class="pn2">won <b>{w}</b> of {n}</span>{act}</div>')
    total = best_n + wrong_n
    plan = (f'<div class="sec" style="left:14px;top:8px">{ic("plan", GOLD, 18)}YOUR PLAN</div>'
            f'<span class="grade" style="left:178px;top:7px" title="Graded by fit, not by the dice: {best_n} fires of a line that beats Priya\'s game, {wrong_n} of a line that walks into it.">MIXED</span>'
            f'<span class="pv" style="left:266px;top:8px" title="About how much the plan moved Lucy\'s chance to win, against improvising.">worth <b>+5%</b> to win</span>'
            f'<span class="pv" style="right:14px;top:8px" title="Exchanges where a line of the plan fired.">lines fired in <b>{total}</b> of 18</span>'
            + "".join(rows))
    cw, chh = 342, 100
    g = []

    def cell(cxi, cyi, title, icn, body, extra=""):
        x = 14 + cxi * (cw + 8)
        y = 128 + cyi * (chh + 6)
        g.append(f'<div class="cell" style="left:{x}px;top:{y}px;width:{cw}px;height:{chh}px">'
                 f'<div class="sec2">{ic(icn, "#c9b9a6", 18)}{title}</div>{extra}{body}</div>')

    vs = []
    for i, (mk, nm) in enumerate((("range", "Boxing at range"), ("counter", "Waiting to counter"), ("press", "Pressing"))):
        n = sum(1 for e in EX if e[1] == mk)
        w = sum(1 for e in EX if e[1] == mk and e[2] == "L")
        vs.append(f'<div class="cr" style="top:{28 + i * 24}px" title="Exchanges Lucy won while Priya was {nm.lower()}."><span class="cl">{nm}</span>'
                  f'<span class="cp">{pips(w, n)}</span><span class="cn2"><b>{w}</b> of {n}</span></div>')
    cell(0, 0, "AGAINST PRIYA'S GAME", "fist", "".join(vs))
    cc = []
    for i, (r, call) in enumerate(ROUND_CALLS.items()):
        mode = EX[(r - 1) * 6][1]
        wd, col, _ = edge(call_fit(call, mode))
        note = ("Priya changed to pressing after two exchanges." if r == 2 else "The right call; Lucy's legs could not carry it out.")
        cc.append(f'<div class="cr" style="top:{28 + i * 24}px" title="The call before round {r}, graded by fit: {wd.lower()} when {SITWORD[mode]}. Round {r} lost. {note}">'
                  f'<span class="cl"><em>R{r}</em> {CALLNAME[call]}</span><span class="cv"><b style="color:{col}">{wd}</b><em class="rs">round lost</em></span></div>')
    sh = [(i, e) for i, e in enumerate(EX) if e[7]]
    fits = [call_fit(e[7], sit_of(i)) for i, e in sh]
    pp = "".join(f'<i class="pp" style="width:11px;height:11px;background:{edge(f)[1]};border-color:{edge(f)[1]}"></i>' for f in fits)
    shw = sum(1 for _, e in sh if e[2] == "L")
    lst = "; ".join(f"{CALLNAME[e[7]]} ({edge(f)[0].lower()}, {'won' if e[2] == 'L' else 'lost'})" for (i, e), f in zip(sh, fits))
    cc.append(f'<div class="cr" style="top:76px" title="Each shout graded by fit to the moment: {lst}. Lucy was Steady, so every shout was heard.">'
              f'<span class="cl">Shouts by fit</span><span class="cp">{pp}</span><span class="cn2 w2">won <b>{shw}</b> of {len(sh)}</span></div>')
    cell(1, 0, "CORNER, GRADED BY FIT", "stool", "".join(cc))
    cb = [f'<div class="cr" style="top:28px" title="Lucy\'s drilled 1-2: every punch of it landed, 5 times of 9 thrown."><span class="cl">1-2 landed whole</span><span class="cp">{pips(5, 9)}</span><span class="cn2"><b>5</b> of 9</span></div>',
          f'<div class="cr" style="top:52px" title="Lucy\'s drilled 1-2-3: landed whole 2 times of 6. One of them hurt Priya in round 2."><span class="cl">1-2-3 landed whole</span><span class="cp">{pips(2, 6)}</span><span class="cn2"><b>2</b> of 6</span></div>',
          f'<div class="cr" style="top:76px" title="Lucy\'s habit, retreats in straight lines: Priya walked Lucy onto the ropes and hurt Lucy there, in round 2 and round 3."><span class="cl">{ic("back", "#c9b9a6", 18)} Retreats in straight lines</span><span class="cv" style="color:#ff8a78">punished <b>2</b></span></div>']
    drill = '<span class="act" style="position:absolute;right:10px;top:3px;width:138px" title="Puts the 1-2-3 on next week\'s pad rounds (Training). It landed whole 2 times of 6.">Drill the 1-2-3</span>'
    cell(0, 1, "COMBOS &middot; HABIT", "combo", "".join(cb), drill)
    places = [("Long", "long", "#b59a72"), ("Mid", "mid", "#7d6a58"), ("Inside", "inside", "#574a40")]
    full = cw - 24
    acc = 0
    segs, keys = [], []
    pinned = sum(e[5] for e in EX)
    for nm, key, c in places:
        n = sum(1 for e in EX if e[4] == key)
        w = round(n * full / 18)
        hatch = ""
        if key == "inside":
            hw = round(pinned * full / 18)
            hatch = f'<b class="hx" style="width:{hw}px" title="Pinned on the ropes: {pinned} exchanges"></b>'
        segs.append(f'<i style="left:{acc}px;width:{w - 2}px;background:{c}" title="{nm}: {n} exchanges">{hatch}</i>')
        keys.append(f'<span class="rk"><i style="background:{c}"></i>{nm} <b>{n}</b></span>')
        acc += w
    keys.append(f'<span class="rk"><i class="hk"></i>ropes <b>{pinned}</b></span>')
    lw = sum(1 for e in EX if e[4] == lucy_wants(e))
    pw = sum(1 for e in EX if e[4] == PLACE_WANT_P[e[1]])
    ring = (f'<div class="rb" style="top:30px;width:{full}px">{"".join(segs)}</div>'
            f'<div class="cr rkr" style="top:48px">{"".join(keys)}</div>'
            f'<div class="cr" style="top:74px" title="Exchanges fought at the range each boxer wanted. Lucy wants it long (inside on a Tie up or Go to the body shout). Priya wants it long when boxing at range, mid when waiting to counter, inside when pressing. Both can have it at once.">'
            f'<span class="cl">Range wanted</span><span class="cv"><b style="color:{RT}">Lucy {lw}</b>&nbsp;&middot;&nbsp;<b style="color:{BT}">Priya {pw}</b>&nbsp;of 18</span></div>')
    cell(1, 1, "WHERE IT WAS FOUGHT", "ropes", ring)
    return (f'<div class="tile" style="left:{X}px;top:{Y}px;width:{W}px;height:{H}px"></div>'
            f'<div class="cb" style="left:{X}px;top:{Y}px;width:{W}px;height:{H}px">{plan}{"".join(g)}</div>')


# ---------------------------------------------------------------- page
CSS = """
@font-face{font-family:Barlow;font-weight:500;src:url(data:font/ttf;base64,%(bm)s)}
@font-face{font-family:Barlow;font-weight:600;src:url(data:font/ttf;base64,%(bs)s)}
@font-face{font-family:Barlow;font-weight:700;src:url(data:font/ttf;base64,%(bb)s)}
@font-face{font-family:Bebas;src:url(data:font/ttf;base64,%(be)s)}
@font-face{font-family:Marker;src:url(data:font/ttf;base64,%(pm)s)}
:root{--bg:#070504;--panel:#0b0a0a;--tile:#151313;--title:#b5a595;--cap:#a89c90;--white:#f3ece2;--gold:#e9b84a;--red:#e0503c;--blue:#4278e0}
*{box-sizing:border-box;margin:0;padding:0}
html,body{width:1920px;height:1080px;overflow:hidden;background:var(--bg)}
body{position:relative;font-family:Barlow,sans-serif;color:var(--white)}
svg{flex:none}
.panel{position:absolute;left:143px;top:20px;width:1634px;height:1050px;background:var(--panel)}
.cl1{position:absolute;left:143px;top:24px;width:817px;height:6px;background:var(--red)}
.cl2{position:absolute;left:960px;top:24px;width:817px;height:6px;background:var(--blue)}
.lab{position:absolute;font:600 18px Barlow;letter-spacing:2.6px;color:var(--gold);text-transform:uppercase;white-space:nowrap}
.tile{position:absolute;background:var(--tile);border-radius:4px;border-top:3px solid #3a3532}
/* cards */
.card{position:absolute;border-radius:4px}
.card.r{background:linear-gradient(160deg,#3a1410 0%,#1c0c0a 60%,#140908 100%);border-bottom:4px solid var(--red)}
.card.b{background:linear-gradient(200deg,#122347 0%,#0c1427 60%,#0a0f1c 100%);border-bottom:4px solid var(--blue)}
.figbox{position:absolute;background:#08101c;border:1px solid #23314a;border-radius:4px;overflow:visible}
.mk{position:absolute;display:flex;align-items:center;gap:3px;height:24px;padding:0 6px;border:2px solid;border-radius:4px;background:#0b0a0a;font:400 22px/1 Bebas;padding-top:2px}
.marks{position:absolute;height:250px}
.ct{position:absolute;left:0;top:0;font:600 18px Barlow;letter-spacing:2.4px;color:var(--title)}
.pl{position:absolute;left:0;right:0;height:24px;display:flex;align-items:center;gap:8px;cursor:help}
.pl .pn{font:600 19px Barlow;color:#d9cdbf}
.pl b{margin-left:auto;font:400 25px/1 Bebas;padding-top:2px}
.dt{display:inline-block;width:11px;height:11px;border-radius:50%;flex:none}
.lg{position:absolute;left:0;display:flex;align-items:center;gap:6px;font:500 18px Barlow;color:#a89c90;white-space:nowrap}
.lg .dt{margin-left:4px}
.nm{position:absolute;display:flex;align-items:center;gap:12px;white-space:nowrap}
.face{width:52px;height:52px;border-radius:50%;border:3px solid;object-fit:cover}
.fn{font:400 38px/1 Bebas;letter-spacing:.6px;padding-top:4px}
.cn{font:600 18px Barlow;letter-spacing:2.4px}
/* centre */
.verdict{position:absolute;left:575px;width:770px;top:54px;height:74px;display:flex;align-items:center;justify-content:center;gap:40px}
.vw{font:400 66px/1 Marker;color:var(--red);letter-spacing:2px;text-shadow:0 3px 0 #000}
.vs{display:flex;flex-direction:column;gap:2px}
.vs .a{font:400 34px/1.1 Marker;color:var(--gold)}
.vs .b{font:600 22px Barlow;color:#d9cdbf;white-space:nowrap}
.vs .b b{color:#8fbcff}
.judge{position:absolute;width:250px;text-align:center}
.jl{font:600 18px Barlow;letter-spacing:2.6px;color:#d9cdbf}
.jt{font:400 52px/1 Bebas;letter-spacing:1px;padding-top:2px}
.chips{display:flex;justify-content:center;gap:6px;margin-top:4px}
.rch{display:inline-flex;align-items:center;justify-content:center;width:58px;height:30px;padding:3px 0 0;border-radius:4px;font:400 23px/1 Bebas;color:#fff;cursor:help}
.rch em{font:600 18px Barlow;font-style:normal;color:rgba(255,255,255,.75)}
.rch.r{background:#7d2a21;border:2px solid var(--red)}
.rch.b{background:#20396b;border:2px solid var(--blue)}
.rch.odd{box-shadow:0 0 0 2px var(--gold)}
.jn{font:600 18px Barlow;color:#a89c90;margin-top:1px;height:20px}
.dr{position:absolute;left:575px;width:770px;height:24px;display:flex;align-items:center;cursor:help;border-top:1px solid #2a2523}
.da,.db{flex:1;font:600 20px Barlow;color:#c9bfb3;white-space:nowrap}
.da{text-align:right}.db{text-align:left}
.da b,.db b{color:#fff;font-weight:700}
.dl{width:230px;text-align:center;font:600 18px Barlow;letter-spacing:2.2px;color:var(--title)}
.ar{color:var(--gold)}
/* why */
.why{position:absolute;left:575px;top:130px;width:770px;height:60px;background:#1c1714;border-radius:4px;border-left:4px solid var(--gold);display:flex;align-items:center;gap:12px;padding:0 12px;white-space:nowrap}
.wrs{display:flex;flex-direction:column}.wr{display:flex;align-items:center;gap:9px;height:28px}
.why .wl{font:600 18px Barlow;letter-spacing:2.6px;color:var(--gold);margin-right:4px}
.why .wi{display:flex;align-items:center;gap:6px;font:600 19px Barlow;color:#e6dccf}
.why .wi b{font:400 26px/1 Bebas;padding-top:3px}
.why .sep{color:var(--gold);font:700 22px Barlow}
/* timeline */
.tl{position:absolute;left:193px;font:600 18px Barlow;letter-spacing:2px;color:var(--title);white-space:nowrap}
.tl2{position:absolute;left:193px;display:flex;align-items:center;gap:5px;font:600 18px Barlow;color:#c9bfb3;white-space:nowrap}
.rh{position:absolute;height:26px;display:flex;align-items:center;gap:10px;font:700 19px Barlow;white-space:nowrap;cursor:help}
.rh .rn{color:#f3ece2;letter-spacing:1px}
.rh .en{margin-left:auto;display:flex;align-items:center;gap:5px;padding-right:6px}
.rh .en b{font:400 24px/1 Bebas;padding-top:2px}
.rh .en i{color:#5a5550;font-style:normal}
.lw{display:flex;align-items:center;gap:4px;font:700 18px Barlow;color:#ffb199;background:rgba(224,80,60,.16);border:1px solid rgba(224,80,60,.5);border-radius:4px;padding:0 6px;height:24px}
.mode{position:absolute;height:24px;border-radius:3px;display:flex;align-items:center;justify-content:center;font:600 18px Barlow;color:#e6dccf;cursor:help;white-space:nowrap}
.mode.range{background:#2b2a24;border:1px solid #4a473a}
.mode.counter{background:#2a2430;border:1px solid #4a3f55}
.mode.press{background:#33231d;border:1px solid #5a3d30}
.axis{position:absolute;height:2px;background:#4a4440}
.xb{position:absolute;width:30px;border-radius:2px;cursor:help}
.xb.r{background:var(--red)}.xb.b{background:var(--blue)}
.evi{position:absolute;cursor:help;display:flex}
.pb{position:absolute;height:26px;display:flex;align-items:center;gap:3px;padding:0 6px;border:2px solid;border-radius:4px;background:#0f0d0c;font:400 22px/1 Bebas;color:#f3ece2;padding-top:1px;cursor:help}
.pb.sh{border-color:#3a3532}
.cc{position:absolute;display:flex;align-items:center;flex-direction:column;cursor:help}
/* punch table */
.pt{position:absolute;width:806px;height:332px}
.tn{position:absolute;top:0;font:400 30px/1 Bebas;letter-spacing:1px;padding-top:3px}
.tabs{position:absolute;left:%(tabx)spx;top:0;display:flex;gap:6px;transform:translateX(-50%%)}
.tab{height:28px;padding:0 13px;display:flex;align-items:center;border-radius:4px;font:700 18px Barlow;letter-spacing:1px;color:#c9b9a6;background:#1d1a19;border:1px solid #3a3532;cursor:pointer;user-select:none}
.tab.on{background:var(--gold);color:#1a1410;border-color:var(--gold)}
.rows{position:absolute;left:0;right:0;top:34px;height:%(rowsh)spx}
.tb{position:absolute;left:0;right:0;top:0;bottom:0}
.tr{position:absolute;left:0;right:0;height:%(rowh)spx}
.tr.first{border-bottom:1px solid #2e2a28}
.tr>*{position:absolute;top:0;height:%(rowh)spx;display:flex;align-items:center;white-space:nowrap}
.lb{justify-content:center;gap:7px;font:600 19px Barlow;color:#e6dccf;cursor:help}
.lb.sub{color:#b8ab9c;font-weight:500}
.lb.first{color:var(--gold);font-weight:700}
.nt{gap:6px}.nt.a{justify-content:flex-end;padding-right:6px}.nt.b{justify-content:flex-start;padding-left:6px}
.nt b{font:400 23px/1 Bebas;color:#c9bfb3;padding-top:2px;font-weight:400}
.nt em{font:500 18px Barlow;font-style:normal;color:#7d746b}
.nt.big b{font-size:27px}
.nt.wn b{color:#fff}
.pc{font:600 18px Barlow;color:#8a7f74}.pc.a{justify-content:flex-end}.pc.b{justify-content:flex-start}
.pc.wn{color:var(--gold)}
.wm{width:0;height:0;border-top:6px solid transparent;border-bottom:6px solid transparent}
.wm.a{border-left:8px solid var(--gold)}.wm.b{border-right:8px solid var(--gold)}
.bar{height:13px!important;top:5px!important;background:#1f1c1b;border-radius:3px}
.bar i{position:absolute;top:0;bottom:0;border-radius:2px}
.o.r{background:rgba(224,80,60,.30)}.o.b{background:rgba(66,120,224,.32)}
.n.r{background:var(--red)}.n.b{background:var(--blue)}
.bl.r{background:repeating-linear-gradient(45deg,#c9b9a6 0 3px,#4a4440 3px 6px)}
.bl.b{background:repeating-linear-gradient(45deg,#c9b9a6 0 3px,#4a4440 3px 6px)}
.sl.r{background:repeating-linear-gradient(-45deg,rgba(224,80,60,.9) 0 2px,rgba(224,80,60,.25) 2px 5px)}
.sl.b{background:repeating-linear-gradient(-45deg,rgba(66,120,224,.9) 0 2px,rgba(66,120,224,.25) 2px 5px)}
.tb .sl.r,.tb .sl.b{background:repeating-linear-gradient(-45deg,#8a7f74 0 2px,#2c2826 2px 5px)}
.ms.r,.ms.b{background:transparent;border:1px solid #5a5550}
.tier{font:700 18px Barlow;letter-spacing:.3px;justify-content:flex-start;cursor:help}
.tier.sharp{color:var(--gold)}.tier.usable{color:#c9b9a6}.tier.learning{color:#7d746b}
.nw{font:500 18px Barlow;color:#7d746b;justify-content:center;cursor:help}
.leg{position:absolute;left:0;right:0;top:%(legy)spx;height:24px;display:flex;align-items:center;gap:7px;font:500 18px Barlow;color:#a89c90;white-space:nowrap}
.sw{display:inline-block;width:22px;height:12px;border-radius:2px;margin-left:8px}
.sw:first-child{margin-left:0}
.leg .sw.sl{background:repeating-linear-gradient(-45deg,#8a7f74 0 2px,#2c2826 2px 5px)}
.leg .sw.ms{background:transparent;border:1px solid #5a5550}
.nc{margin-left:auto;display:flex;align-items:center;gap:6px;cursor:help}
/* corner block */
.cb{position:absolute}
.sec{position:absolute;display:flex;align-items:center;gap:8px;font:600 18px Barlow;letter-spacing:2.4px;color:var(--gold);white-space:nowrap}
.grade{position:absolute;font:700 18px Barlow;letter-spacing:1px;color:#1a1410;background:var(--gold);border-radius:4px;padding:1px 9px;cursor:help}
.pv{position:absolute;font:600 19px Barlow;color:#c9bfb3;white-space:nowrap;cursor:help}.pv b{color:#fff}
.plr{position:absolute;left:14px;right:14px;height:27px;display:flex;align-items:center;gap:9px;white-space:nowrap;cursor:help;border-top:1px solid #262220}
.pk{width:26px;height:24px;border:2px solid var(--gold);border-radius:4px;display:flex;align-items:center;justify-content:center;font:400 22px/1 Bebas;color:var(--gold);padding-top:2px}
.ps{font:600 19px Barlow;color:#c9bfb3}
.pa{color:var(--gold);font:700 20px Barlow}
.pw{font:700 19px Barlow;color:#f3ece2}
.pps{margin-left:auto;display:flex;gap:3px}
.pn2{width:62px;text-align:right;font:600 18px Barlow;color:#a89c90}.pn2 b{font:400 24px/1 Bebas;color:#fff}
.rate{width:128px;text-align:center;font:700 18px Barlow;border:1px solid;border-radius:4px;padding:1px 0}
.pp{display:inline-block;border-radius:2px;background:transparent;border:2px solid #5a5550}
.pp.on{background:var(--gold);border-color:var(--gold)}
.cell{position:absolute;background:#1b1817;border-radius:4px}
.sec2{position:absolute;left:12px;top:5px;display:flex;align-items:center;gap:7px;font:600 18px Barlow;letter-spacing:1.8px;color:var(--title);white-space:nowrap}
.cr{position:absolute;left:12px;right:12px;height:24px;display:flex;align-items:center;gap:8px;white-space:nowrap;cursor:help}
.cr .cl{display:flex;align-items:center;gap:6px;font:600 18px Barlow;color:#e6dccf}
.cr .cl em{font-style:normal;color:#a89c90;font-weight:500}
.cr .cp{margin-left:auto;display:flex;gap:2px}
.cr .cn2{width:54px;text-align:right;font:500 18px Barlow;color:#a89c90}.cr .cn2 b{font:400 22px/1 Bebas;color:#fff}
.cr .cv{margin-left:auto;display:flex;align-items:center;gap:5px;font:600 18px Barlow;color:#c9bfb3}
.rb{position:absolute;left:12px;height:14px}
.rk{display:flex;align-items:center;gap:4px;font:600 18px Barlow;color:#c9bfb3;margin-right:2px}.rk b{color:#fff}.rk i{width:12px;height:12px;border-radius:2px;display:inline-block}
.rb i{position:absolute;top:0;height:14px;border-radius:3px;display:flex;align-items:center;justify-content:center;cursor:help}
.rb span{font:600 18px Barlow;color:#f3ece2;white-space:nowrap}
.cap2{position:absolute;font:600 18px Barlow;color:var(--title);white-space:nowrap;cursor:help}
.cap2 em{font-style:normal;font-weight:500;color:#8a7f74}
.dr.one{padding-left:26px}.dr.one .dl{width:160px;text-align:left;color:var(--gold)}
.dx{flex:1;font:600 20px Barlow;color:#c9bfb3;white-space:nowrap}.dx b{color:#fff}
.dx i{font-style:normal;color:#ff7a66;margin-right:6px}
.act{display:inline-flex;align-items:center;justify-content:center;height:24px;width:96px;border-radius:4px;font:700 18px Barlow;color:#f0e3cf;background:linear-gradient(#634634,#432d1f);border:1px solid #8a6449;cursor:pointer;white-space:nowrap}
.act.none{visibility:hidden}
.pn2{width:96px!important}
.cn2.w2{width:96px!important}
.cv .rs{font-style:normal;font-weight:500;color:#8a7f74;margin-left:4px}
.mkr{display:flex;align-items:center;gap:6px;margin-left:16px;cursor:help}
.rb i b.hx{position:absolute;right:0;top:0;bottom:0;border-radius:0 3px 3px 0;background:repeating-linear-gradient(45deg,#d9cdbf 0 2px,transparent 2px 6px)}
.rk i.hk{background:repeating-linear-gradient(45deg,#d9cdbf 0 2px,#574a40 2px 6px)}
.rkr{gap:4px!important}
.plr{gap:7px!important}
/* bottom */
.bot{position:absolute;left:179px;top:1014px;width:1562px;height:50px;display:flex;align-items:center;gap:14px}
.btn2{height:46px;padding:0 18px;display:flex;align-items:center;gap:10px;border-radius:4px;font:700 19px Barlow;color:#f0e3cf;background:linear-gradient(#634634,#432d1f);border:1px solid #8a6449;box-shadow:inset 0 1px 0 rgba(255,220,180,.22),0 2px 4px #000;white-space:nowrap;cursor:pointer}
.btn2.red{background:linear-gradient(#c3322c,#95221d);border-color:#d9574c;color:#fff;font-size:24px;height:50px;padding:0 40px;margin-left:auto}
.home{font:500 18px Barlow;color:#8a7f74;white-space:nowrap}
.home b{color:#c9bfb3;font-weight:600}
"""


def page():
    rows_h = len(ROWS) * ROWH
    css = CSS.replace("%%", "%")
    for k, v in dict(bm=b64(ROOT / "assets/fonts/Barlow-Medium.ttf"), bs=b64(ROOT / "assets/fonts/Barlow-SemiBold.ttf"),
                     bb=b64(ROOT / "assets/fonts/Barlow-Bold.ttf"), be=b64(ROOT / "assets/fonts/BebasNeue-Regular.ttf"),
                     pm=b64(ROOT / "assets/fonts/PermanentMarker-Regular.ttf"),
                     tabx=COLS["tier"] + COLS["pc"] + COLS["nt"] + COLS["bar"] + COLS["lab"] // 2,
                     rowsh=rows_h, rowh=ROWH, legy=34 + rows_h + 2).items():
        css = css.replace("%(" + k + ")s", str(v))
    arrow = '<span class="sep">&#8594;</span>'
    why = (f'<div class="why"><span class="wl">WHY</span><div class="wrs">'
           f'<div class="wr"><span class="wi" title="Round 1 to Lucy, round 2 to Priya on two cards: level going into round 3.">{ic("even", GOLD, 20)}Level after <b>2</b> rounds</span>{arrow}'
           f'<span class="wi" title="Priya pressed all round 3 and won 5 of its 6 exchanges.">Round 3 lost <b style="color:{BT}">1-5</b></span>{arrow}'
           f'<span class="wi" title="Lucy\'s legs gave out first, in round 3: energy 36 at the last bell against Priya\'s 50.">{ic("legs", "#c9b9a6", 20)}Legs went: energy <b style="color:#ff8a78">36</b> to <b style="color:{BT}">50</b></span></div>'
           f'<div class="wr"><span class="wi" title="Plan line C, Presses -> Step in, fired 3 times in rounds 2 and 3 and lost all 3: stepping in walks into a presser.">{ic("plan", "#c9b9a6", 20)}Line C, Step in vs pressing: <b style="color:#ff8a78">0</b> of 3</span>{arrow}'
           f'<span class="wi" title="Lucy\'s habit: retreats in straight lines. Priya pinned Lucy on the ropes and hurt Lucy there twice.">{ic("back", "#c9b9a6", 20)}Pinned on the ropes: hurt <b style="color:#ff8a78">2</b> times</span></div>'
           f'</div></div>')
    head = ('<div class="verdict"><span class="vw">LOST</span><div class="vs"><span class="a">SPLIT DECISION</span>'
            '<span class="b">Two judges to one for <b>Priya Nair</b></span></div></div>')
    bottom = ('<div class="bot">'
              f'<div class="btn2" title="The plan this bout used, each line lit with won and tried. Read only.">{ic("play", "#f0e3cf", 20)}Replay the plan</div>'
              f'<div class="btn2" title="Lucy\'s legs gave out first; Cardio is the stat behind them (Coach\'s advice after the bout). Sets next week\'s training focus to Cardio.">{ic("legs", "#f0e3cf", 20)}Train Cardio next week</div>'
              '<span class="home" style="margin-left:18px">Tiredness, mood and the club\'s money: <b>on Home</b></span>'
              '<div class="btn2 red">Continue &#9654;</div></div>')
    js = """<script>
document.querySelectorAll('.tab').forEach(t=>t.addEventListener('click',()=>{
 document.querySelectorAll('.tab').forEach(x=>x.classList.toggle('on',x===t));
 document.querySelectorAll('.tb').forEach(b=>b.style.display=b.dataset.t===t.dataset.t?'':'none');}));
</script>"""
    hdr = ('<div class="lab" style="left:179px;top:44px">The result</div>'
           '<div class="lab" style="right:179px;top:44px;color:#a89c90;letter-spacing:2px">Amateur &middot; Lightweight &middot; 3 rounds of 3 minutes</div>')
    return (f'<!doctype html><html><head><meta charset="utf-8"><title>Fight result</title><style>{css}</style></head><body>'
            f'<div class="panel"></div><div class="cl1"></div><div class="cl2"></div>{hdr}'
            f'{card("L")}{card("P")}{head}{judges()}{decided()}{why}{timeline()}{punch_block()}{corner_block()}{bottom}{js}</body></html>')


OUT.write_text(page(), encoding="utf-8")
print(OUT, OUT.stat().st_size)
